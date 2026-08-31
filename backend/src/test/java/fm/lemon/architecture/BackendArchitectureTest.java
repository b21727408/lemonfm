package fm.lemon.architecture;

import static org.junit.jupiter.api.Assertions.assertThrows;
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
    for (JavaClass source : CLASSES) {
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
  void externalIoRuleIsProvenByATransitiveFixture() {
    JavaClasses fixture = new ClassFileImporter().importPackages("fm.lemon.externaliofixture");
    assertThrows(
        AssertionError.class, () -> assertTransactionalTypesCannotReachExternalIo(fixture));
  }

  private static void assertTransactionalTypesCannotReachExternalIo(JavaClasses classes) {
    Set<JavaClass> external = new HashSet<>();
    Set<JavaClass> transactional = new HashSet<>();
    for (JavaClass type : classes) {
      if (type.isAnnotatedWith(ExternalIo.class)) {
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
    if (targetName.startsWith("org.springframework")
        || targetName.startsWith("org.jooq")
        || targetName.startsWith("com.fasterxml.jackson")
        || targetName.startsWith("jakarta.persistence")
        || targetName.startsWith("jakarta.servlet")) {
      fail(source.getName() + " domain dependency is forbidden: " + targetName);
    }
    String sourceModule = moduleOf(source.getPackageName());
    if (targetModule != null
        && (!targetModule.equals(sourceModule) || !"domain".equals(targetLayer))) {
      fail(source.getName() + " domain dependency is forbidden: " + targetName);
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
    boolean allowed =
        switch (sourceLayer) {
          case "infrastructure" -> Set.of("application", "domain", "api").contains(targetLayer);
          case "application" -> Set.of("domain", "api").contains(targetLayer);
          case "domain" -> targetLayer.equals("domain");
          case "api" -> targetLayer.equals("api");
          default -> false;
        };
    if (!allowed) {
      fail(source.getName() + " has reversed layer dependency on " + targetName);
    }
  }

  private static void assertCrossModuleApiOnly(
      JavaClass source, String targetName, @Nullable String targetLayer) {
    if (!"api".equals(targetLayer)) {
      fail(source.getName() + " reaches another module's internals: " + targetName);
    }
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
