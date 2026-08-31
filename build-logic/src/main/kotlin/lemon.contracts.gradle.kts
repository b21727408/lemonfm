plugins {
    java
    id("org.openapi.generator")
}

dependencies {
    testImplementation("com.atlassian.oai:openapi-request-validator-mockmvc:3.0.0")
    testImplementation("org.wiremock:wiremock:3.13.2")
}
