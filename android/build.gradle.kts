plugins {
    id("com.android.application") version "8.11.1" apply false
    id("com.android.library") apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
    id("dev.flutter.flutter-gradle-plugin") apply false
    id("com.google.gms.google-services") version "4.4.1" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

// We removed the "tasks.register<Delete>("clean")" section because it already exists!