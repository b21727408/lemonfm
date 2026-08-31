plugins {
    java
}

val sourceSets = extensions.getByType<SourceSetContainer>()

sourceSets.named("main") {
    java.srcDir("src/generated/jooq")
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-jooq")
    implementation("org.springframework.boot:spring-boot-starter-flyway")
    implementation("org.flywaydb:flyway-database-postgresql")
    runtimeOnly("org.postgresql:postgresql")
    testImplementation("org.jooq:jooq-codegen")
    testImplementation("org.testcontainers:testcontainers-postgresql:2.0.5")
}

tasks.register<JavaExec>("generateJooq") {
    group = "code generation"
    description = "Replays migrations and generates one jOOQ package per owned schema."
    dependsOn(tasks.named("testClasses"))
    classpath = sourceSets.named("test").get().runtimeClasspath
    mainClass = "fm.lemon.database.JooqGenerator"
    args(layout.projectDirectory.dir("src/generated/jooq").asFile.absolutePath)
}
