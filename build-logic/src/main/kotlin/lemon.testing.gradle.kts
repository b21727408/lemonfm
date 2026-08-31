plugins {
    java
}

val sourceSets = extensions.getByType<SourceSetContainer>()

dependencies {
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.springframework.modulith:spring-modulith-starter-test")
    testImplementation("com.tngtech.archunit:archunit-junit5:1.4.2")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

tasks.withType<Test>().configureEach {
    useJUnitPlatform()
    testLogging {
        events("failed", "skipped")
        exceptionFormat = org.gradle.api.tasks.testing.logging.TestExceptionFormat.FULL
    }
}

tasks.named<Test>("test") {
    useJUnitPlatform {
        excludeTags("postgres")
    }
}

tasks.register<Test>("postgresIntegrationTest") {
    group = "verification"
    description = "Runs the real-PostgreSQL Testcontainers suite."
    testClassesDirs = sourceSets.named("test").get().output.classesDirs
    classpath = sourceSets.named("test").get().runtimeClasspath
    useJUnitPlatform {
        includeTags("postgres")
    }
    shouldRunAfter(tasks.named("test"))
}
