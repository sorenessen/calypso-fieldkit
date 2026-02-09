# Calypso FieldKit

**Calypso FieldKit** is a .NET MAUI Blazor Hybrid mobile application
that serves as the foundation for an offline‑first field operations
companion.

This repository represents the **initial working milestone**: - Verified
Android build and emulator deployment - Clean multi‑project .NET
architecture - Configured mobile development environment -
Portfolio‑ready starting point for continued feature development

------------------------------------------------------------------------

# Current Status

## Working

-   .NET 9 MAUI Blazor Hybrid app builds successfully
-   Android emulator deployment confirmed
-   JDK 21 and Android SDK configured
-   Project branding updated to **Calypso FieldKit**
-   Repository structured for professional presentation

## Architecture

    src/
      FieldOps.App            → MAUI Blazor Hybrid UI
      FieldOps.Core           → Domain logic (future expansion)
      FieldOps.Infrastructure → Persistence & services (future)

    tests/
      FieldOps.Core.Tests     → Unit tests

------------------------------------------------------------------------

# Prerequisites

You must have installed:

-   macOS
-   .NET SDK 9
-   Android SDK
-   JDK 21
-   Android Emulator

------------------------------------------------------------------------

# Environment Setup (macOS)

Run before building:

``` bash
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator"
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
```

------------------------------------------------------------------------

# Run the App (Android)

Start an emulator:

``` bash
"$ANDROID_SDK_ROOT/emulator/emulator" -list-avds
"$ANDROID_SDK_ROOT/emulator/emulator" -avd "<YOUR_AVD_NAME>"
```

Deploy the app:

``` bash
dotnet build src/FieldOps.App/FieldOps.App.csproj -t:Run -f net9.0-android   -p:AndroidSdkDirectory="$ANDROID_SDK_ROOT"   -p:JavaSdkDirectory="$JAVA_HOME"
```

If device detection fails:

``` bash
adb devices
adb kill-server
adb start-server
```

------------------------------------------------------------------------

# Verified Milestone

This project currently demonstrates:

-   End‑to‑end mobile .NET build pipeline
-   Emulator deployment
-   MAUI Blazor Hybrid startup
-   Clean architectural separation

This serves as the **foundation checkpoint** before real feature work
begins.

------------------------------------------------------------------------

# Planned Roadmap

## Phase 1 --- Real App Shell

-   Replace template UI
-   Add branded navigation
-   Establish layout structure

## Phase 2 --- Field Features

-   Work orders
-   Notes
-   Checklists
-   Local SQLite storage
-   Offline‑first behavior

## Phase 3 --- Sync & Services

-   Background sync
-   Conflict resolution
-   Cloud integration
-   Authentication

## Phase 4 --- Production Readiness

-   Logging & telemetry
-   Error handling
-   Packaging & signing
-   Release pipeline

------------------------------------------------------------------------

# Purpose

Calypso FieldKit exists to provide:

1.  **Portfolio‑level proof** of mobile .NET capability\
2.  **Foundation for a real offline field operations product**

------------------------------------------------------------------------

# Author

**Soren Essen**\
Calypso Labs
