package fm.lemon.tooling.architecture;

import static fm.lemon.tooling.architecture.ToolSupport.YAML;

import com.fasterxml.jackson.databind.JsonNode;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Set;

public final class ArchitectureTool {
  private ArchitectureTool() {}

  public static void main(String[] arguments) throws Exception {
    Path root = findRoot(Path.of("").toAbsolutePath());
    JsonNode modules = YAML.readTree(root.resolve("architecture/modules.yaml").toFile());
    ArchitectureValidator validator = new ArchitectureValidator(root, modules);
    GeneratedArtifactProducer generator = new GeneratedArtifactProducer(root, modules);
    RepositoryPolicy policy = new RepositoryPolicy(root, modules);
    String command = arguments.length == 0 ? "validate" : arguments[0];
    String scope = arguments.length < 2 ? "all" : arguments[1];

    switch (command) {
      case "validate" -> validator.validate();
      case "generate" -> {
        validator.validate();
        generator.write();
      }
      case "contract-manifest" -> {
        if (scope.equals("generate")) {
          generator.writeContractManifest();
        } else if (scope.equals("check")) {
          generator.checkContractManifest();
        } else {
          throw new IllegalArgumentException("Expected contract-manifest generate|check");
        }
      }
      case "migration-append-only" -> policy.checkAppendOnlyMigrations(scope);
      case "check" -> {
        validator.validate();
        if (scope.equals("all") || scope.equals("policy")) {
          policy.check();
        }
        if (scope.equals("all") || scope.equals("generated")) {
          generator.check();
        }
        if (!Set.of("all", "policy", "generated").contains(scope)) {
          throw new IllegalArgumentException("Unknown architecture check scope: " + scope);
        }
      }
      default -> throw new IllegalArgumentException("Unknown architecture command: " + command);
    }
  }

  private static Path findRoot(Path start) {
    Path candidate = start;
    while (candidate != null) {
      if (Files.isRegularFile(candidate.resolve("architecture/modules.yaml"))) {
        return candidate;
      }
      candidate = candidate.getParent();
    }
    throw new IllegalStateException("Cannot locate repository root from " + start);
  }
}
