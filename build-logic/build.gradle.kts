plugins {
    `kotlin-dsl`
}

group = "fm.lemon.buildlogic"

repositories {
    gradlePluginPortal()
    mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-gradle-plugin:4.1.1")
    implementation("com.diffplug.spotless:spotless-plugin-gradle:8.10.1")
    implementation("net.ltgt.gradle:gradle-errorprone-plugin:5.1.1")
    implementation("de.thetaphi:forbiddenapis:3.10")
    implementation("org.openapi.generator:org.openapi.generator.gradle.plugin:7.25.0")
}

dependencyLocking {
    lockAllConfigurations()
}
