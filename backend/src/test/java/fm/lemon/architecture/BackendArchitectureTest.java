package fm.lemon.architecture;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;

import com.tngtech.archunit.core.domain.Dependency;
import com.tngtech.archunit.core.domain.JavaClass;
import com.tngtech.archunit.core.domain.JavaClasses;
import com.tngtech.archunit.core.importer.ClassFileImporter;
import com.tngtech.archunit.core.importer.ImportOption;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;
import org.jspecify.annotations.Nullable;
import org.junit.jupiter.api.Test;
import org.springframework.transaction.annotation.Transactional;

final class BackendArchitectureTest {
  private static final ModulePolicy POLICY = ModulePolicy.load();
  private static final JavaClasses CLASSES =
      new ClassFileImporter()
          .withImportOption(new ImportOption.DoNotIncludeTests())
          .importPackages("fm.lemon");

  @Test
  void domainAndLayerBoundariesHold() {
    assertModuleBoundaries(CLASSES);
  }

  @Test
  void apiSelfStandingRuleRejectsAForeignApiFixture() {
    JavaClasses fixture =
        new ClassFileImporter()
            .importClasses(
                fm.lemon.identity.api.ForeignIdentityApiFixture.class,
                fm.lemon.profile.api.ProfileApiDependsOnIdentityFixture.class);
    AssertionError violation =
        assertThrows(AssertionError.class, () -> assertModuleBoundaries(fixture));
    assertTrue(
        Objects.requireNonNull(violation.getMessage())
            .contains("api package must be self-standing"));
  }

  @Test
  void apiPurityRuleRejectsAFrameworkTypeFixture() {
    JavaClasses fixture =
        new ClassFileImporter()
            .importClasses(fm.lemon.profile.api.ProfileApiExposesSpringFixture.class);
    AssertionError violation =
        assertThrows(AssertionError.class, () -> assertModuleBoundaries(fixture));
    assertTrue(
        Objects.requireNonNull(violation.getMessage())
            .contains("org.springframework.http.ResponseEntity"));
  }

  @Test
  void apiPurityRuleAllowsDeclaredStructuralAnnotations() {
    JavaClasses fixture =
        new ClassFileImporter()
            .importClasses(fm.lemon.profile.api.ProfileApiWithStructuralAnnotationsFixture.class);
    assertDoesNotThrow(() -> assertModuleBoundaries(fixture));
  }

  @Test
  void structuralAnnotationsCannotBecomeApiPayloadTypes() {
    JavaClasses fixture =
        new ClassFileImporter()
            .importClasses(fm.lemon.profile.api.ProfileApiExposesStructuralAnnotationFixture.class);
    AssertionError violation =
        assertThrows(AssertionError.class, () -> assertModuleBoundaries(fixture));
    assertTrue(
        Objects.requireNonNull(violation.getMessage())
            .contains("may appear only as annotation metadata"));
  }

  @Test
  void directHttpIoRuleRejectsPureLayerFixtures() {
    for (Class<?> fixtureType :
        Set.of(
            fm.lemon.identity.domain.DomainHttpClientFixture.class,
            fm.lemon.identity.application.ApplicationHttpClientFixture.class)) {
      JavaClasses fixture = new ClassFileImporter().importClasses(fixtureType);
      AssertionError violation =
          assertThrows(AssertionError.class, () -> assertModuleBoundaries(fixture));
      assertTrue(
          Objects.requireNonNull(violation.getMessage())
              .contains("direct HTTP I/O dependency belongs in [infrastructure]"));
    }
  }

  @Test
  void directHttpIoRuleAllowsInfrastructureFixture() {
    JavaClasses fixture =
        new ClassFileImporter()
            .importClasses(fm.lemon.identity.infrastructure.MarkedHttpAdapterFixture.class);
    assertDoesNotThrow(() -> assertModuleBoundaries(fixture));
  }

  @Test
  void directIoAdapterBehindUnmarkedCapabilityFails() {
    JavaClasses fixture =
        new ClassFileImporter()
            .importClasses(
                fm.lemon.identity.application.UnmarkedExternalPortFixture.class,
                fm.lemon.identity.infrastructure.UnmarkedHttpAdapterFixture.class);
    AssertionError violation =
        assertThrows(AssertionError.class, () -> assertDirectIoCapabilitiesMarked(fixture));
    assertTrue(
        Objects.requireNonNull(violation.getMessage())
            .contains("direct-I/O adapter must carry @ExternalIo"));
  }

  @Test
  void markingOnlyImplementationCannotHideUnmarkedPort() {
    JavaClasses fixture =
        new ClassFileImporter()
            .importClasses(
                fm.lemon.identity.application.UnmarkedExternalPortFixture.class,
                fm.lemon.identity.infrastructure.ImplementationOnlyMarkedHttpAdapterFixture.class);
    AssertionError violation =
        assertThrows(AssertionError.class, () -> assertDirectIoCapabilitiesMarked(fixture));
    assertTrue(
        Objects.requireNonNull(violation.getMessage())
            .contains("external-I/O capability port must carry @ExternalIo"));
  }

  @Test
  void markedPortAndAdapterPassExternalIoCapabilityRule() {
    JavaClasses fixture =
        new ClassFileImporter()
            .importClasses(
                fm.lemon.identity.application.MarkedExternalPortFixture.class,
                fm.lemon.identity.infrastructure.MarkedHttpAdapterFixture.class);
    assertDoesNotThrow(() -> assertDirectIoCapabilitiesMarked(fixture));
  }

  private static void assertModuleBoundaries(JavaClasses classes) {
    for (JavaClass source : classes) {
      String sourceModule = moduleOf(source.getPackageName());
      if (sourceModule == null) {
        continue;
      }
      String sourceLayer = layerOf(source.getPackageName(), sourceModule);
      for (Dependency dependency : source.getDirectDependenciesFromSelf()) {
        JavaClass target = dependency.getTargetClass();
        String targetName = target.getName();
        String targetModule = moduleOf(target.getPackageName());
        String targetLayer =
            targetModule == null ? null : layerOf(target.getPackageName(), targetModule);

        assertDirectIoOwnership(source, sourceLayer, targetName);
        if (POLICY.crossModuleVisibleLayer().equals(sourceLayer)) {
          assertApiDependency(source, sourceModule, targetName, targetModule, targetLayer);
        }
        if ("domain".equals(sourceLayer)) {
          assertDomainDependency(source, targetName, targetModule, targetLayer);
        }
        if (sourceModule.equals(targetModule)) {
          assertLayerDirection(source, sourceLayer, targetName, targetLayer);
        } else if (targetModule != null) {
          assertCrossModuleApiOnly(source, targetName, targetLayer);
        }
        assertSchemaOwnership(source, sourceModule, targetName);
      }
    }
  }

  @Test
  void transactionalTypesCannotReachExternalIoCapabilities() {
    assertTransactionalTypesCannotReachExternalIo(CLASSES);
  }

  @Test
  void outboundAdaptersExposeOnlyMarkedCapabilities() {
    assertDirectIoCapabilitiesMarked(CLASSES);
  }

  @Test
  void externalIoRuleIsProvenByATransitiveFixture() {
    JavaClasses fixture = new ClassFileImporter().importPackages("fm.lemon.externaliofixture");
    assertThrows(
        AssertionError.class, () -> assertTransactionalTypesCannotReachExternalIo(fixture));
  }

  private static void assertTransactionalTypesCannotReachExternalIo(JavaClasses classes) {
    Set<JavaClass> external = new HashSet<>();
    Set<JavaClass> transactional = new HashSet<>();
    for (JavaClass type : classes) {
      if (type.isAnnotatedWith(POLICY.externalIoMarker())) {
        external.add(type);
      }
      if (type.isAnnotatedWith(Transactional.class)
          || type.getMethods().stream()
              .anyMatch(method -> method.isAnnotatedWith(Transactional.class))) {
        transactional.add(type);
      }
    }
    for (JavaClass source : transactional) {
      assertCannotReachExternal(source, external);
    }
  }

  private static void assertDirectIoCapabilitiesMarked(JavaClasses classes) {
    for (JavaClass adapter : classes) {
      String module = moduleOf(adapter.getPackageName());
      if (module == null) {
        continue;
      }
      String layer = layerOf(adapter.getPackageName(), module);
      if (!POLICY.directIoJavaOwnerLayers().contains(layer) || !dependsOnDirectIo(adapter)) {
        continue;
      }
      if (!adapter.isAnnotatedWith(POLICY.externalIoMarker())) {
        fail(
            adapter.getName()
                + " direct-I/O adapter must carry @ExternalIo ("
                + POLICY.externalIoMarker()
                + ")");
      }
      Set<JavaClass> capabilityPorts =
          adapter.getRawInterfaces().stream()
              .filter(port -> module.equals(moduleOf(port.getPackageName())))
              .filter(
                  port ->
                      !POLICY
                          .directIoJavaOwnerLayers()
                          .contains(layerOf(port.getPackageName(), module)))
              .collect(java.util.stream.Collectors.toSet());
      if (capabilityPorts.isEmpty()) {
        fail(adapter.getName() + " direct-I/O adapter must implement a marked capability port");
      }
      for (JavaClass port : capabilityPorts) {
        if (!port.isAnnotatedWith(POLICY.externalIoMarker())) {
          fail(
              adapter.getName()
                  + " external-I/O capability port must carry @ExternalIo: "
                  + port.getName());
        }
      }
    }
  }

  private static boolean dependsOnDirectIo(JavaClass type) {
    return type.getDirectDependenciesFromSelf().stream()
        .map(dependency -> dependency.getTargetClass().getName())
        .anyMatch(
            target ->
                POLICY.directIoJavaForbiddenNamespaces().stream().anyMatch(target::startsWith));
  }

  @Test
  void applicationCodeDoesNotRequestIndependentTransactions() throws IOException {
    Path sourceRoot = Path.of("src/main/java");
    if (!Files.isDirectory(sourceRoot)) {
      sourceRoot = Path.of("backend/src/main/java");
    }
    try (var paths = Files.walk(sourceRoot)) {
      paths
          .filter(path -> path.toString().endsWith(".java"))
          .forEach(
              path -> {
                try {
                  String source = Files.readString(path, StandardCharsets.UTF_8);
                  if (source.contains("REQUIRES_NEW")
                      || source.contains("PROPAGATION_REQUIRES_NEW")) {
                    fail("Independent transaction requested in " + path);
                  }
                } catch (IOException exception) {
                  throw new IllegalStateException(exception);
                }
              });
    }
  }

  private static void assertDomainDependency(
      JavaClass source,
      String targetName,
      @Nullable String targetModule,
      @Nullable String targetLayer) {
    for (String namespace : POLICY.domainForbiddenNamespaces()) {
      if (targetName.startsWith(namespace)) {
        fail(source.getName() + " domain dependency is forbidden: " + targetName);
      }
    }
    String sourceModule = moduleOf(source.getPackageName());
    if (targetModule != null && !targetModule.equals(sourceModule)) {
      if (!POLICY.domainMayDependOnOtherModules()) {
        fail(source.getName() + " domain dependency is forbidden: " + targetName);
      }
      return;
    }
    if (targetModule != null
        && !"domain".equals(targetLayer)
        && !POLICY.domainDependencies().contains(targetLayer)) {
      fail(source.getName() + " domain dependency is forbidden: " + targetName);
    }
  }

  private static void assertDirectIoOwnership(
      JavaClass source, @Nullable String sourceLayer, String targetName) {
    if (sourceLayer == null || POLICY.directIoJavaOwnerLayers().contains(sourceLayer)) {
      return;
    }
    for (String namespace : POLICY.directIoJavaForbiddenNamespaces()) {
      if (targetName.startsWith(namespace)) {
        fail(
            source.getName()
                + " direct HTTP I/O dependency belongs in "
                + POLICY.directIoJavaOwnerLayers()
                + ": "
                + targetName);
      }
    }
  }

  private static void assertLayerDirection(
      JavaClass source,
      @Nullable String sourceLayer,
      String targetName,
      @Nullable String targetLayer) {
    if (sourceLayer == null || targetLayer == null || sourceLayer.equals(targetLayer)) {
      return;
    }
    if (POLICY.crossModuleVisibleLayer().equals(sourceLayer)) {
      return;
    }
    var order = POLICY.layerOrder();
    int sourceIndex = order.indexOf(sourceLayer);
    boolean allowed;
    if (POLICY.crossModuleVisibleLayer().equals(targetLayer)) {
      int implementationIndex = order.indexOf(POLICY.apiImplementedBy());
      allowed = sourceIndex >= 0 && sourceIndex <= implementationIndex;
    } else {
      int targetIndex = order.indexOf(targetLayer);
      allowed = sourceIndex >= 0 && targetIndex > sourceIndex;
    }
    if (!allowed) {
      fail(source.getName() + " has reversed layer dependency on " + targetName);
    }
  }

  private static void assertCrossModuleApiOnly(
      JavaClass source, String targetName, @Nullable String targetLayer) {
    if (!POLICY.crossModuleVisibleLayer().equals(targetLayer)) {
      fail(source.getName() + " reaches another module's internals: " + targetName);
    }
  }

  private static void assertApiDependency(
      JavaClass source,
      String sourceModule,
      String targetName,
      @Nullable String targetModule,
      @Nullable String targetLayer) {
    if (targetModule != null && !sourceModule.equals(targetModule)) {
      fail(
          source.getName()
              + " api package must be self-standing; foreign dependency: "
              + targetName);
    }
    if (POLICY.apiAnnotationOnlyTypes().contains(targetName)) {
      assertAnnotationTypeIsMetadataOnly(source, targetName);
      return;
    }
    String category = apiTypeCategory(sourceModule, targetName, targetModule, targetLayer);
    if (category != null
        && POLICY.apiMayDependOn().contains(category)
        && POLICY.apiMayExpose().contains(category)) {
      return;
    }
    String detail =
        category != null
                && (POLICY.apiMayNotDependOn().contains(category)
                    || POLICY.apiMayNotExpose().contains(category))
            ? "forbidden category " + category
            : "unapproved type category";
    fail(source.getName() + " api dependency is forbidden (" + detail + "): " + targetName);
  }

  private static void assertAnnotationTypeIsMetadataOnly(JavaClass source, String annotationName) {
    Set<JavaClass> signatureTypes = new HashSet<>();
    source
        .getTypeParameters()
        .forEach(type -> signatureTypes.addAll(type.getAllInvolvedRawTypes()));
    source.getSuperclass().ifPresent(type -> signatureTypes.addAll(type.getAllInvolvedRawTypes()));
    source.getInterfaces().forEach(type -> signatureTypes.addAll(type.getAllInvolvedRawTypes()));
    source.getMembers().forEach(member -> signatureTypes.addAll(member.getAllInvolvedRawTypes()));
    boolean usedOutsideMetadata =
        signatureTypes.stream().anyMatch(type -> type.getName().equals(annotationName))
            || source.getReferencedClassObjects().stream()
                .anyMatch(reference -> reference.getValue().getName().equals(annotationName))
            || source.getInstanceofChecks().stream()
                .anyMatch(check -> check.getRawType().getName().equals(annotationName))
            || source.getAccessesFromSelf().stream()
                .anyMatch(access -> access.getTargetOwner().getName().equals(annotationName));
    if (usedOutsideMetadata) {
      fail(
          source.getName()
              + " structural annotation type may appear only as annotation metadata: "
              + annotationName);
    }
  }

  private static @Nullable String apiTypeCategory(
      String sourceModule,
      String targetName,
      @Nullable String targetModule,
      @Nullable String targetLayer) {
    if (sourceModule.equals(targetModule) && POLICY.crossModuleVisibleLayer().equals(targetLayer)) {
      return POLICY.ownApiCategory();
    }
    if (sourceModule.equals(targetModule) && targetLayer != null) {
      return targetLayer;
    }
    for (var category : POLICY.apiNamespaceCategories().entrySet()) {
      for (String namespace : category.getValue()) {
        if (targetName.startsWith(namespace)) {
          return category.getKey();
        }
      }
    }
    return null;
  }

  private static void assertSchemaOwnership(
      JavaClass source, String sourceModule, String targetName) {
    String prefix = "fm.lemon.generated.jooq.";
    if (!targetName.startsWith(prefix)) {
      return;
    }
    String remainder = targetName.substring(prefix.length());
    String schema = remainder.substring(0, remainder.indexOf('.'));
    String owned = POLICY.schemas().get(sourceModule);
    if (!schema.equals(owned)) {
      fail(source.getName() + " references schema " + schema + " owned by another module");
    }
  }

  private static void assertCannotReachExternal(JavaClass source, Set<JavaClass> external) {
    Set<JavaClass> visited = new HashSet<>();
    Deque<JavaClass> pending = new ArrayDeque<>();
    pending.add(source);
    while (!pending.isEmpty()) {
      JavaClass current = pending.removeFirst();
      if (!visited.add(current)) {
        continue;
      }
      if (!current.equals(source) && external.contains(current)) {
        fail(source.getName() + " transitively reaches @ExternalIo " + current.getName());
      }
      current.getDirectDependenciesFromSelf().stream()
          .map(Dependency::getTargetClass)
          .filter(target -> target.getPackageName().startsWith("fm.lemon"))
          .forEach(pending::addLast);
    }
  }

  private static @Nullable String moduleOf(String packageName) {
    for (String module : POLICY.modules()) {
      if (packageName.equals("fm.lemon." + module)
          || packageName.startsWith("fm.lemon." + module + ".")) {
        return module;
      }
    }
    return null;
  }

  private static @Nullable String layerOf(String packageName, String module) {
    String prefix = "fm.lemon." + module + ".";
    if (!packageName.startsWith(prefix)) {
      return null;
    }
    String remainder = packageName.substring(prefix.length());
    int separator = remainder.indexOf('.');
    return separator < 0 ? remainder : remainder.substring(0, separator);
  }
}
