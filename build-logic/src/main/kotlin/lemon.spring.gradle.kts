import org.gradle.api.artifacts.VersionCatalogsExtension

plugins {
    java
    id("org.springframework.boot")
}

val catalog = extensions.getByType<VersionCatalogsExtension>().named("libs")

dependencies {
    implementation(platform(catalog.findLibrary("spring-boot-bom").get()))
    implementation(platform(catalog.findLibrary("spring-modulith-bom").get()))
    implementation("org.springframework.boot:spring-boot-starter")
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.modulith:spring-modulith-starter-core")
    implementation("org.springframework.modulith:spring-modulith-starter-jdbc")
}

tasks.withType<org.springframework.boot.gradle.tasks.bundling.BootJar>().configureEach {
    archiveFileName = "lemon-backend.jar"
}
