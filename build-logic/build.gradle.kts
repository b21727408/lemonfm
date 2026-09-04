import org.gradle.api.artifacts.VersionCatalogsExtension

plugins {
    `kotlin-dsl`
}

group = "fm.lemon.buildlogic"

repositories {
    gradlePluginPortal()
    mavenCentral()
}

val catalog = extensions.getByType<VersionCatalogsExtension>().named("libs")

dependencies {
    implementation(catalog.findLibrary("spring-boot-gradle-plugin").get())
    implementation(catalog.findLibrary("spotless-gradle-plugin").get())
    implementation(catalog.findLibrary("errorprone-gradle-plugin").get())
    implementation(catalog.findLibrary("forbiddenapis-gradle-plugin").get())
    implementation(catalog.findLibrary("openapi-generator-gradle-plugin").get())
}

dependencyLocking {
    lockAllConfigurations()
}
