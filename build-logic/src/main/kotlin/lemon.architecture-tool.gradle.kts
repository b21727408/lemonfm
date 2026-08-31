plugins {
    application
    java
}

application {
    mainClass = "fm.lemon.tooling.architecture.ArchitectureTool"
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

dependencies {
    implementation(enforcedPlatform("com.fasterxml.jackson:jackson-bom:2.21.5"))
    implementation("com.fasterxml.jackson.dataformat:jackson-dataformat-yaml:2.21.5")
    implementation("com.networknt:json-schema-validator:2.0.7")
}
