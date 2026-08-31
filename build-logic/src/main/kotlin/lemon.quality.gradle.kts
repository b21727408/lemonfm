import de.thetaphi.forbiddenapis.gradle.CheckForbiddenApis
import net.ltgt.gradle.errorprone.errorprone

plugins {
    java
    checkstyle
    id("com.diffplug.spotless")
    id("net.ltgt.errorprone")
    id("de.thetaphi.forbiddenapis")
}

dependencies {
    checkstyle("com.puppycrawl.tools:checkstyle:14.1.0")
    compileOnly("org.jspecify:jspecify:1.0.1")
    testCompileOnly("org.jspecify:jspecify:1.0.1")
    errorprone("com.google.errorprone:error_prone_core:2.50.0")
    errorprone("com.uber.nullaway:nullaway:0.14.1")
}

spotless {
    java {
        target("src/main/java/**/*.java", "src/test/java/**/*.java")
        googleJavaFormat("1.36.1")
        formatAnnotations()
    }
}

checkstyle {
    toolVersion = "14.1.0"
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
