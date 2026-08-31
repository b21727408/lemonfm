plugins {
    application
    java
    id("com.diffplug.spotless")
}

application {
    mainClass = "fm.lemon.tooling.architecture.ArchitectureTool"
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

spotless {
    java {
        target("src/main/java/**/*.java")
        googleJavaFormat("1.36.1")
        formatAnnotations()
    }
}

dependencies {
    implementation(enforcedPlatform("com.fasterxml.jackson:jackson-bom:2.21.5"))
    implementation("com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:2.21.5")
    implementation("com.networknt:json-schema-validator:2.0.7")
}
