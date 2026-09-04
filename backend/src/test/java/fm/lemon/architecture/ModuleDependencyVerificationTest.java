package fm.lemon.architecture;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import fm.lemon.LemonApplication;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.springframework.modulith.core.ApplicationModule;
import org.springframework.modulith.core.ApplicationModuleDependency;
import org.springframework.modulith.core.ApplicationModules;
import org.springframework.modulith.core.DependencyType;

final class ModuleDependencyVerificationTest {
  private static final ModulePolicy POLICY = ModulePolicy.load();

  @BeforeAll
  static void selectExplicitModules() {
    System.setProperty("spring.modulith.detection-strategy", "explicitly-annotated");
  }

  @Test
  void discoveredModulesAndTypedDependenciesMatchCanonicalPolicy() {
    ApplicationModules modules = ApplicationModules.of(LemonApplication.class);
    Set<String> discovered = new LinkedHashSet<>();
    modules.stream()
        .forEach(
            module -> {
              String source = module.getIdentifier().toString();
              discovered.add(source);
              List<ApplicationModuleDependency> dependencies =
                  module.getDirectDependencies(modules).stream().toList();
              dependencies.forEach(dependency -> verify(source, dependency, dependencies));
            });

    assertEquals(POLICY.modules(), discovered, "Spring Modulith module discovery drifted");
  }

  private static void verify(
      String source,
      ApplicationModuleDependency dependency,
      List<ApplicationModuleDependency> dependencies) {
    ApplicationModule targetModule = dependency.getTargetModule();
    String target = targetModule.getIdentifier().toString();
    DependencyType type = dependency.getDependencyType();

    assertTrue(
        targetModule.isExposed(dependency.getTargetType()),
        () ->
            source
                + " reaches non-API type "
                + dependency.getTargetType().getName()
                + " in "
                + target);

    if (type == DependencyType.EVENT_LISTENER) {
      String event = dependency.getTargetType().getSimpleName();
      assertTrue(
          POLICY.subscriptions(source, target).contains(event),
          () -> "Undeclared event subscription: " + source + " -> " + target + "." + event);
      return;
    }

    if (type == DependencyType.DEFAULT && hasPairedEventListener(dependency, dependencies)) {
      return;
    }

    assertTrue(
        type != DependencyType.ENTITY, () -> "Cross-module entity dependency: " + dependency);
    assertTrue(
        POLICY.calls(source).contains(target + ".api"),
        () -> "Undeclared synchronous dependency (" + type + "): " + source + " -> " + target);
  }

  private static boolean hasPairedEventListener(
      ApplicationModuleDependency candidate, List<ApplicationModuleDependency> dependencies) {
    return dependencies.stream()
        .anyMatch(
            dependency ->
                dependency.getDependencyType() == DependencyType.EVENT_LISTENER
                    && dependency.getSourceType().equals(candidate.getSourceType())
                    && dependency.getTargetType().equals(candidate.getTargetType())
                    && dependency.getTargetModule().equals(candidate.getTargetModule()));
  }
}
