package fm.lemon.architecture;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import fm.lemon.modulithfixture.FixtureApplication;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.springframework.modulith.core.ApplicationModule;
import org.springframework.modulith.core.ApplicationModuleDependency;
import org.springframework.modulith.core.ApplicationModules;
import org.springframework.modulith.core.DependencyType;

final class ModulithDependencyClassificationTest {
  @BeforeAll
  static void selectExplicitModules() {
    System.setProperty("spring.modulith.detection-strategy", "explicitly-annotated");
  }

  @Test
  void publicModelDistinguishesComponentStaticAndListenerDependencies() {
    ApplicationModules modules = ApplicationModules.of(FixtureApplication.class, location -> true);
    ApplicationModule alpha = modules.getModuleByName("alpha").orElseThrow();

    Map<String, Set<DependencyType>> byTarget =
        alpha.getDirectDependencies(modules).stream()
            .collect(
                Collectors.groupingBy(
                    dependency -> dependency.getTargetModule().getIdentifier().toString(),
                    Collectors.mapping(
                        ApplicationModuleDependency::getDependencyType, Collectors.toSet())));

    assertEquals(
        Set.of(DependencyType.USES_COMPONENT, DependencyType.DEFAULT), byTarget.get("beta"));
    assertEquals(
        Set.of(DependencyType.EVENT_LISTENER, DependencyType.DEFAULT), byTarget.get("gamma"));
    assertEquals(Set.of(DependencyType.DEFAULT), byTarget.get("delta"));
    assertTrue(
        alpha.getDirectDependencies(modules).stream()
            .filter(
                dependency ->
                    dependency.getTargetModule().getIdentifier().toString().equals("gamma"))
            .collect(
                Collectors.groupingBy(
                    dependency ->
                        dependency.getSourceType().getName()
                            + "->"
                            + dependency.getTargetType().getName(),
                    Collectors.mapping(
                        ApplicationModuleDependency::getDependencyType, Collectors.toSet())))
            .values()
            .contains(Set.of(DependencyType.EVENT_LISTENER, DependencyType.DEFAULT)));
    alpha.getDirectDependencies(modules).stream()
        .forEach(
            dependency ->
                assertTrue(dependency.getTargetModule().isExposed(dependency.getTargetType())));
  }
}
