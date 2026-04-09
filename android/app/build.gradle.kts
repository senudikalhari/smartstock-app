plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    classpath("com.google.gms:google-services:4.3.15")
}

android {
    namespace = "com.example.smartstock_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // This matches your Firebase registration
        applicationId = "com.example.smartstock_app"
        
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Signing with the debug keys for now so your demo works
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.3.15")
    }
}
}

flutter {
    source = "../.."
}