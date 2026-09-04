import org.gradle.api.artifacts.VersionCatalogsExtension

plugins {
    java
}

val catalog = extensions.getByType<VersionCatalogsExtension>().named("libs")
val javaVersion = catalog.findVersion("java").get().requiredVersion.toInt()

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(javaVersion)
        vendor = JvmVendorSpec.ADOPTIUM
    }
}

tasks.withType<JavaCompile>().configureEach {
    options.release = javaVersion
    options.encoding = "UTF-8"
    options.compilerArgs.add("-parameters")
}
