plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

fun releaseSigningValue(name: String): String? =
    providers.gradleProperty(name).orElse(providers.environmentVariable(name)).orNull

val releaseSigningValues =
    mapOf(
        "store file" to releaseSigningValue("LEMON_RELEASE_STORE_FILE"),
        "store password" to releaseSigningValue("LEMON_RELEASE_STORE_PASSWORD"),
        "key alias" to releaseSigningValue("LEMON_RELEASE_KEY_ALIAS"),
        "key password" to releaseSigningValue("LEMON_RELEASE_KEY_PASSWORD"),
    )
val releaseSigningConfigured = releaseSigningValues.values.all { !it.isNullOrBlank() }

gradle.taskGraph.whenReady {
    val releaseTaskRequested = allTasks.any { it.project == project && it.name.contains("Release") }
    if (releaseTaskRequested && !releaseSigningConfigured) {
        val missing = releaseSigningValues.filterValues { it.isNullOrBlank() }.keys.joinToString()
        throw GradleException("Release signing is not configured; missing: $missing")
    }
}

android {
    namespace = "fm.lemon"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "fm.lemon"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (releaseSigningConfigured) {
            create("release") {
                storeFile = file(requireNotNull(releaseSigningValues["store file"]))
                storePassword = releaseSigningValues["store password"]
                keyAlias = releaseSigningValues["key alias"]
                keyPassword = releaseSigningValues["key password"]
            }
        }
    }

    buildTypes {
        release {
            if (releaseSigningConfigured) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
