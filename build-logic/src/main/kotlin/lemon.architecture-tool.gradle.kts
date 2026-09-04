import org.gradle.api.artifacts.VersionCatalogsExtension

plugins {
    application
    java
    id("com.diffplug.spotless")
}

val catalog = extensions.getByType<VersionCatalogsExtension>().named("libs")
val javaVersion = catalog.findVersion("java").get().requiredVersion.toInt()

application {
    mainClass = "fm.lemon.tooling.architecture.ArchitectureTool"
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(javaVersion)
    }
}

spotless {
    java {
        target("src/main/java/**/*.java")
        googleJavaFormat(catalog.findVersion("google-java-format").get().requiredVersion)
        formatAnnotations()
    }
}

dependencies {
    implementation(enforcedPlatform(catalog.findLibrary("jackson-bom").get()))
    implementation(catalog.findLibrary("jackson-yaml").get())
    implementation(catalog.findLibrary("json-schema-validator").get())
}
