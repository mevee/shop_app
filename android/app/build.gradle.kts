plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.shop_app"
    compileSdk = flutter.compileSdkVersion
    //ndkVersion = flutter.ndkVersion //OLD
    ndkVersion = "27.0.12077973" //NEW

    compileOptions {
        
        isCoreLibraryDesugaringEnabled = true
        
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_1_8.toString()
        jvmTarget = "1.8"
    }

    // Add this block
    kotlin {
        jvmToolchain(17) // Or your desired JDK version, e.g., 8, 11, 17, 21
        // It's generally recommended to use a recent LTS version like 17.
    }

    defaultConfig {
        applicationId = "com.example.shop_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Add this line inside defaultConfig
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            //shrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ... your other dependencies
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4") // Or the latest version
}