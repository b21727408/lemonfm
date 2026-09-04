import de.thetaphi.forbiddenapis.gradle.CheckForbiddenApis
import net.ltgt.gradle.errorprone.errorprone
import org.gradle.api.artifacts.VersionCatalogsExtension

plugins {
    java
    checkstyle
    id("com.diffplug.spotless")
    id("net.ltgt.errorprone")
    id("de.thetaphi.forbiddenapis")
}

val catalog = extensions.getByType<VersionCatalogsExtension>().named("libs")

dependencies {
    checkstyle(catalog.findLibrary("checkstyle").get())
    compileOnly(catalog.findLibrary("jspecify").get())
    testCompileOnly(catalog.findLibrary("jspecify").get())
    errorprone(catalog.findLibrary("error-prone-core").get())
    errorprone(catalog.findLibrary("nullaway").get())
}

spotless {
    java {
        target("src/main/java/**/*.java", "src/test/java/**/*.java")
        googleJavaFormat(catalog.findVersion("google-java-format").get().requiredVersion)
        formatAnnotations()
    }
}

checkstyle {
    toolVersion = catalog.findVersion("checkstyle").get().requiredVersion
    configDirectory = rootProject.layout.projectDirectory.dir("config/checkstyle")
}

tasks.withType<Checkstyle>().configureEach {
    exclude("fm/lemon/generated/**")
}

tasks.withType<JavaCompile>().configureEach {
    options.errorprone {
        disableWarningsInGeneratedCode.set(true)
        error("NullAway")
        option("NullAway:OnlyNullMarked", "true")
    }
}

tasks.withType<CheckForbiddenApis>().configureEach {
    bundledSignatures = setOf("jdk-unsafe", "jdk-deprecated")
    signaturesFiles = rootProject.files("config/forbidden-apis/signatures.txt")
    failOnMissingClasses = false
    exclude("fm/lemon/generated/**")
}
