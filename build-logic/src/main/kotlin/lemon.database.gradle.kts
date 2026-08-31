plugins {
    java
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-jooq")
    implementation("org.springframework.boot:spring-boot-starter-flyway")
    runtimeOnly("org.postgresql:postgresql")
    testImplementation("org.testcontainers:testcontainers-postgresql:2.0.5")
}
