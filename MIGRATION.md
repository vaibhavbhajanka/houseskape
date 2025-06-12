# Flutter Project Modernisation Guide (2025)

This document captures **all** of the manual fixes we applied while resurrecting an older-template Flutter project on today's stable tool-chain (Flutter 3.32 / Dart 3 / AGP 8.x).
Use it as a checklist to modernise any legacy repository.

---

## 1  Dart / Flutter SDK

| Item | Old | New |
|------|------|-----|
| Dart constraint | `">=2.15 <3.0"` | `">=3.2.0 <4.0.0"` |
| Flutter channel | n/a | stable `3.32.x` |

### pubspec.yaml
```yaml
environment:
  sdk: ">=3.2.0 <4.0.0"
```

---

## 2  Package upgrades

Add / bump to latest **null-safe, Dart 3 compatible** versions:

```yaml
# pubspec.yaml (excerpt)
dependencies:
  cloud_firestore: ^5.6.9
  firebase_core:   ^3.14.0
  firebase_auth:   ^5.6.0
  firebase_storage:^12.4.7
  firebase_messaging:^15.2.7
  flutter_local_notifications:^19.2.1
  google_sign_in:  ^6.3.0
  image_picker:    ^1.1.2
  provider:        ^6.0.5
  uuid:            ^4.5.1
  flutter_plugin_android_lifecycle: ^2.0.28
  date_time_picker:^2.1.0

# Lints
 dev_dependencies:
  flutter_lints: ^6.0.0
```

Optional override (temporary) for the `file` package to satisfy new IO API:
```yaml
dependency_overrides:
  file: ^7.0.1
```

Run:
```bash
flutter pub get
```

---

## 3  Android/Gradle overhaul

### 3.1  Gradle wrapper & AGP

* **Gradle 8.4** wrapper: `android/gradle/wrapper/gradle-wrapper.properties`
  ```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.4-all.zip
  ```
* **Android Gradle Plugin 8.3.2** (matches Flutter 3.32): this is set in `android/settings.gradle` plugins block.
* **Kotlin 1.9.22** – also in the plugins block.

### 3.2  settings.gradle
```groovy
pluginManagement {
    def flutterSdkPath = {
        def p = new Properties(); file('local.properties').withInputStream { p.load(it) }
        return p.getProperty('flutter.sdk')
    }()
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google(); mavenCentral(); gradlePluginPortal()
    }
}

plugins {
    id 'dev.flutter.flutter-plugin-loader' version '1.0.0'
    id 'com.android.application'          version '8.3.2' apply false
    id 'org.jetbrains.kotlin.android'     version '1.9.22' apply false
    id 'com.google.gms.google-services'   version '4.4.1' apply false
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
        // required for pre-built Flutter engine artifacts
        maven { url 'https://storage.googleapis.com/download.flutter.io' }
    }
}

include ':app'
```

### 3.3  Root **build.gradle**
Minimal – only clean task & a workaround that auto-injects a `namespace` for plugins that haven't migrated yet:
```groovy
rootProject.buildDir = "../build"
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
    project.evaluationDependsOn(":app")

    // temporary namespace shim for legacy plugins
    plugins.withId('com.android.library') {
        def android = project.extensions.findByName('android')
        if (android != null && android.namespace == null) {
            android.namespace = "${project.group}.${project.name}".replaceAll(':', '.')
        }
    }
}

tasks.register('clean', Delete) { delete rootProject.layout.buildDirectory }
```

### 3.4  app/build.gradle

Key changes:
* Switch to **plugins DSL** (no `apply plugin:`).
* Java 17 tool-chain.
* **namespace** required by AGP 8.
* **minSdk 23** (Firebase kits now require this).
* **Core library desugaring** enabled.
* Latest Firebase BoM.

```groovy
plugins {
    id 'com.android.application'
    id 'org.jetbrains.kotlin.android'
    id 'dev.flutter.flutter-gradle-plugin'
    id 'com.google.gms.google-services'
}

android {
    namespace "com.example.mini"
    compileSdkVersion flutter.compileSdkVersion

    defaultConfig {
        applicationId "com.example.mini"
        minSdkVersion 23
        targetSdkVersion flutter.targetSdkVersion
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
        coreLibraryDesugaringEnabled true
    }
    kotlinOptions { jvmTarget = '17' }
}

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.3')
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.5'
}
```

---

## 4  Codebase tweaks

| Area | Change |
|------|--------|
| Material 3 text themes | Replaced `headline1`, `bodyText2`, etc. with `displayLarge`, `bodyMedium`, etc.  
  Added `text_theme_extensions.dart` shim for incremental migration. |
| ElevatedButton | `styleFrom(primary:)` → `styleFrom(backgroundColor:)`. |
| Firestore 4.x | Added explicit generics<br>`QuerySnapshot<Map<String,dynamic>>` throughout. |
| Android desugaring | Added `coreLibraryDesugaringEnabled true` and dependency. |

---

## 5  Build commands

```bash
flutter clean          # remove old artefacts
flutter pub get        # fetch updated deps
flutter run            # builds with AGP 8 / Gradle 8
```

If you're still on Flutter < 3.19 you *must* pass `--android-skip-build-dependency-validation`.

---

## 6  Troubleshooting

* **Missing namespace error** → ensure every Gradle sub-module sets `namespace` *or* keep the shim in root `build.gradle`.
* **Repository not found for Flutter engine artifacts** → verify the extra Maven repo in `settings.gradle`.
* **Compile errors in plugins** → bump plugin versions or add `dependency_overrides` as illustrated (`file` pkg shim for Dart 3 IO changes).

---

Happy modernising! 🎉 