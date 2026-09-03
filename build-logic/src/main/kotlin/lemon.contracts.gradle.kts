import org.openapitools.generator.gradle.plugin.tasks.GenerateTask
import org.openapitools.generator.gradle.plugin.tasks.ValidateTask

plugins {
    java
    id("org.openapi.generator")
}

val sourceSets = extensions.getByType<SourceSetContainer>()
val repositoryRoot = rootProject.layout.projectDirectory
val contractRoot = repositoryRoot.dir("contracts/http")
val fixtureContractRoot = repositoryRoot.dir("contracts/fixtures/http")
val openApiBuild = layout.buildDirectory.dir("openapi")

sourceSets.named("main") {
    java.srcDir("src/generated/openapi/public")
    java.srcDir("src/generated/openapi/admin")
}
sourceSets.named("test") {
    java.srcDir(openApiBuild.map { it.dir("fixture-publicv1-server/src/main/java") })
    java.srcDir(openApiBuild.map { it.dir("fixture-adminv1-server/src/main/java") })
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-validation")
    compileOnly("jakarta.annotation:jakarta.annotation-api")
    testImplementation("com.atlassian.oai:openapi-request-validator-mockmvc:3.0.0")
    testImplementation("org.wiremock:wiremock:3.13.2")
}

fun registerServerGenerator(
    name: String,
    surface: String,
    specification: File,
    packageRoot: String = "fm.lemon.generated.contract",
    packageSurface: String = surface,
) =
    tasks.register<GenerateTask>(name) {
        generatorName.set("spring")
        inputSpec.set(specification.absolutePath)
        outputDir.set(openApiBuild.map { it.dir("$surface-server") })
        apiPackage.set("$packageRoot.$packageSurface.api")
        modelPackage.set("$packageRoot.$packageSurface.model")
        invokerPackage.set("$packageRoot.$packageSurface")
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

fun registerClientGenerator(
    name: String,
    surface: String,
    specification: File,
    packageName: String,
) =
    tasks.register<GenerateTask>(name) {
        generatorName.set("dart-dio")
        inputSpec.set(specification.absolutePath)
        outputDir.set(openApiBuild.map { it.dir("$surface-client") })
        cleanupOutput.set(true)
        configOptions.set(
            mapOf(
                "enumUnknownDefaultCase" to "true",
                "pubName" to packageName,
                "pubVersion" to "0.0.1",
                "serializationLibrary" to "built_value",
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
    contractRoot.file("public-v1.yaml").asFile,
)
val rawAdminServer = registerServerGenerator(
    "generateRawAdminServer",
    "adminv1",
    contractRoot.file("admin-v1.yaml").asFile,
)
val rawPublicClient = registerClientGenerator(
    "generateRawPublicClient",
    "publicv1",
    contractRoot.file("public-v1.yaml").asFile,
    "api_client",
)
val rawAdminClient = registerClientGenerator(
    "generateRawAdminClient",
    "adminv1",
    contractRoot.file("admin-v1.yaml").asFile,
    "admin_api_client",
)

val fixturePublicServer = registerServerGenerator(
    "generateFixturePublicServer",
    "fixture-publicv1",
    fixtureContractRoot.file("public-v1.fixture.yaml").asFile,
    "fm.lemon.generated.contractfixture",
    "publicv1",
)
val fixtureAdminServer = registerServerGenerator(
    "generateFixtureAdminServer",
    "fixture-adminv1",
    fixtureContractRoot.file("admin-v1.fixture.yaml").asFile,
    "fm.lemon.generated.contractfixture",
    "adminv1",
)
val fixturePublicClient = registerClientGenerator(
    "generateFixturePublicClient",
    "fixture-publicv1",
    fixtureContractRoot.file("public-v1.fixture.yaml").asFile,
    "contract_fixture_public_client",
)
val fixtureAdminClient = registerClientGenerator(
    "generateFixtureAdminClient",
    "fixture-adminv1",
    fixtureContractRoot.file("admin-v1.fixture.yaml").asFile,
    "contract_fixture_admin_client",
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
tasks.named("compileTestJava") {
    dependsOn(fixturePublicServer, fixtureAdminServer)
}

tasks.register("generateContractBindings") {
    group = "code generation"
    description = "Generates both Java servers and both Dart clients from authored OpenAPI."
    dependsOn(
        publicServer,
        adminServer,
        publicClient,
        adminClient,
        fixturePublicServer,
        fixtureAdminServer,
        fixturePublicClient,
        fixtureAdminClient,
    )
}

tasks.register("generateFixtureContractBindings") {
    group = "verification"
    description = "Generates build-local public/admin fixture bindings for contract round trips."
    dependsOn(fixturePublicServer, fixtureAdminServer, fixturePublicClient, fixtureAdminClient)
}

val validatePublic = tasks.register<ValidateTask>("validatePublicOpenApi") {
    inputSpec.set(contractRoot.file("public-v1.yaml").asFile.absolutePath)
    recommend.set(true)
}
val validateAdmin = tasks.register<ValidateTask>("validateAdminOpenApi") {
    inputSpec.set(contractRoot.file("admin-v1.yaml").asFile.absolutePath)
    recommend.set(true)
}
val validateFixturePublic = tasks.register<ValidateTask>("validateFixturePublicOpenApi") {
    inputSpec.set(fixtureContractRoot.file("public-v1.fixture.yaml").asFile.absolutePath)
    recommend.set(true)
}
val validateFixtureAdmin = tasks.register<ValidateTask>("validateFixtureAdminOpenApi") {
    inputSpec.set(fixtureContractRoot.file("admin-v1.fixture.yaml").asFile.absolutePath)
    recommend.set(true)
}

tasks.register("contractsCheck") {
    group = "verification"
    description = "Validates both authored HTTP specifications."
    dependsOn(validatePublic, validateAdmin, validateFixturePublic, validateFixtureAdmin)
}
