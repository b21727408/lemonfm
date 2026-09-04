import org.gradle.api.artifacts.VersionCatalogsExtension

plugins {
    java
}

val sourceSets = extensions.getByType<SourceSetContainer>()
val catalog = extensions.getByType<VersionCatalogsExtension>().named("libs")
val composeFile = rootProject.layout.projectDirectory.file("compose.yaml").asFile

sourceSets.named("main") {
    java.srcDir("src/generated/jooq")
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-jooq")
    implementation("org.springframework.boot:spring-boot-starter-flyway")
    implementation("org.flywaydb:flyway-database-postgresql")
    runtimeOnly("org.postgresql:postgresql")
    testImplementation("org.jooq:jooq-codegen")
    testImplementation(catalog.findLibrary("testcontainers-postgresql").get())
}

tasks.register<JavaExec>("generateJooq") {
    group = "code generation"
    description = "Replays migrations and generates one jOOQ package per owned schema."
    dependsOn(tasks.named("testClasses"))
    classpath = sourceSets.named("test").get().runtimeClasspath
    mainClass = "fm.lemon.database.JooqGenerator"
    systemProperty("lemon.compose.file", composeFile.absolutePath)
    args(layout.projectDirectory.dir("src/generated/jooq").asFile.absolutePath)
}

tasks.withType<Test>().configureEach {
    systemProperty("lemon.compose.file", composeFile.absolutePath)
}
