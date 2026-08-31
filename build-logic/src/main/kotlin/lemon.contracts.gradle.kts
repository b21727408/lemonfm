import org.openapitools.generator.gradle.plugin.tasks.GenerateTask
import org.openapitools.generator.gradle.plugin.tasks.ValidateTask

plugins {
    java
    id("org.openapi.generator")
}

val sourceSets = extensions.getByType<SourceSetContainer>()
val repositoryRoot = rootProject.layout.projectDirectory
val contractRoot = repositoryRoot.dir("contracts/http")
val openApiBuild = layout.buildDirectory.dir("openapi")

sourceSets.named("main") {
    java.srcDir("src/generated/openapi/public")
    java.srcDir("src/generated/openapi/admin")
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-validation")
    compileOnly("jakarta.annotation:jakarta.annotation-api")
    testImplementation("com.atlassian.oai:openapi-request-validator-mockmvc:3.0.0")
    testImplementation("org.wiremock:wiremock:3.13.2")
}

fun registerServerGenerator(name: String, surface: String, specification: String) =
    tasks.register<GenerateTask>(name) {
        generatorName.set("spring")
        inputSpec.set(contractRoot.file(specification).asFile.absolutePath)
        outputDir.set(openApiBuild.map { it.dir("$surface-server") })
        apiPackage.set("fm.lemon.generated.contract.$surface.api")
        modelPackage.set("fm.lemon.generated.contract.$surface.model")
        invokerPackage.set("fm.lemon.generated.contract.$surface")
        cleanupOutput.set(true)
        configOptions.set(
            mapOf(
                "annotationLibrary" to "none",
                "dateLibrary" to "java8",
                "documentationProvider" to "none",
                "generateJsonIncludeAnnotations" to "false",
                "generateJsonSetterNullsAnnotations" to "false",
                "hideGenerationTimestamp" to "true",
                "interfaceOnly" to "true",
                "openApiNullable" to "false",
                "performBeanValidation" to "false",
                "skipDefaultInterface" to "true",
                "useJakartaEe" to "true",
                "useSpringBoot3" to "true",
                "useTags" to "true",
            ),
        )
        globalProperties.set(
            mapOf(
                "apis" to "",
                "apiDocs" to "false",
                "apiTests" to "false",
                "models" to "",
                "modelDocs" to "false",
                "modelTests" to "false",
                "supportingFiles" to "false",
            ),
        )
    }

fun registerClientGenerator(name: String, surface: String, specification: String) =
    tasks.register<GenerateTask>(name) {
        generatorName.set("dart")
        inputSpec.set(contractRoot.file(specification).asFile.absolutePath)
        outputDir.set(openApiBuild.map { it.dir("$surface-client") })
        cleanupOutput.set(true)
        configOptions.set(
            mapOf(
                "enumUnknownDefaultCase" to "true",
                "pubName" to if (surface == "publicv1") "api_client" else "admin_api_client",
                "pubVersion" to "0.0.1",
            ),
        )
        globalProperties.set(
            mapOf(
                "apiDocs" to "false",
                "apiTests" to "false",
                "modelDocs" to "false",
                "modelTests" to "false",
            ),
        )
    }

val rawPublicServer = registerServerGenerator(
    "generateRawPublicServer",
    "publicv1",
    "public-v1.yaml",
)
val rawAdminServer = registerServerGenerator(
    "generateRawAdminServer",
    "adminv1",
    "admin-v1.yaml",
)
val rawPublicClient = registerClientGenerator(
    "generateRawPublicClient",
    "publicv1",
    "public-v1.yaml",
)
val rawAdminClient = registerClientGenerator(
    "generateRawAdminClient",
    "adminv1",
    "admin-v1.yaml",
)

fun registerGeneratedSync(
    name: String,
    generator: TaskProvider<GenerateTask>,
    source: Provider<Directory>,
    destination: Directory,
) = tasks.register<Sync>(name) {
    dependsOn(generator)
    from(source)
    into(destination)
}

val publicServer = registerGeneratedSync(
    "generatePublicServer",
    rawPublicServer,
    openApiBuild.map { it.dir("publicv1-server/src/main/java") },
    layout.projectDirectory.dir("src/generated/openapi/public"),
)
val adminServer = registerGeneratedSync(
    "generateAdminServer",
    rawAdminServer,
    openApiBuild.map { it.dir("adminv1-server/src/main/java") },
    layout.projectDirectory.dir("src/generated/openapi/admin"),
)
val publicClient = registerGeneratedSync(
    "generatePublicClient",
    rawPublicClient,
    openApiBuild.map { it.dir("publicv1-client/lib") },
    repositoryRoot.dir("packages/api_client/lib"),
)
val adminClient = registerGeneratedSync(
    "generateAdminClient",
    rawAdminClient,
    openApiBuild.map { it.dir("adminv1-client/lib") },
    repositoryRoot.dir("packages/admin_api_client/lib"),
)

tasks.named("compileJava") {
    mustRunAfter(publicServer, adminServer)
}

tasks.register("generateContractBindings") {
    group = "code generation"
    description = "Generates both Java servers and both Dart clients from authored OpenAPI."
    dependsOn(publicServer, adminServer, publicClient, adminClient)
}

val validatePublic = tasks.register<ValidateTask>("validatePublicOpenApi") {
    inputSpec.set(contractRoot.file("public-v1.yaml").asFile.absolutePath)
    recommend.set(true)
}
val validateAdmin = tasks.register<ValidateTask>("validateAdminOpenApi") {
    inputSpec.set(contractRoot.file("admin-v1.yaml").asFile.absolutePath)
    recommend.set(true)
}

tasks.register("contractsCheck") {
    group = "verification"
    description = "Validates both authored HTTP specifications."
    dependsOn(validatePublic, validateAdmin)
}
