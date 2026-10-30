# GreenLeaf Flutter Android — same HTML design

This test app uses `assets/greenleaf.html`, a direct copy of the provided
`GreenLeaf_Clean_Campaigns_Smooth_Navigation (1).html` with only an Android-specific
CSS correction appended. It does not rewrite the UI in native Flutter.

## Make your APK using GitHub (no Android Studio required)

1. Extract the ZIP **on your computer**.
2. Create a new GitHub repository (or use an empty one).
3. Use **Add file -> Upload files** and upload **all files and folders INSIDE**
   the extracted directory, including the `.github` folder. Do not upload
   only the ZIP; the workflow needs to be a repository file.
4. Commit to the default `main` branch.
5. Go to the **Actions** tab -> **Build GreenLeaf Android APK** -> **Run workflow**.
   A push to `main` also triggers the build.
6. After the workflow completes, open its run and download the artifact
   `GreenLeaf-Android-APKs` from **Artifacts** at the bottom.
7. Extract that artifact ZIP. Install **`app-release.apk`** on your phone.
   `app-debug.apk` is also included for troubleshooting. If an older package
   was signed with a different key, uninstall the old version before installing.

### If the `.github` folder did not upload

Create the file `.github/workflows/build-apk.yml` in your repo using GitHub's
**Add file -> Create new file**, and paste the contents of
`COPY_WORKFLOW_TO_GITHUB.yml` (also in this ZIP). Commit it, then use Actions.

## Important details

* **Look and feel**: Original cards, palette, typography, icons and interaction
  logic are unchanged. One CSS block only addresses Android-specific layout.
* **Footer**: HTML tab bar fixed to 62 CSS pixels. Flutter's SafeArea handles
  the actual Android bottom system navigation area once, avoiding double padding.
* **Status bar**: Android displays real time/battery above the HTML's existing
  dark header; no in-HTML mock bar or header dimensions are modified.
* **Touch**: Disables the browser's blue touch-highlight, retaining the selected
  glassy navigation styling.
* **Performance**: One persistent WebView; tab switches happen in-page. This is
  still a WebView application, so smoothness and frame rate depend on device and
  Android System WebView. It does NOT force 120 fps.
* **Scope**: The provided HTML is a **UI demonstration** with sample content;
  the APK is also a demonstration. It is NOT connected to the real GreenLeaf
  WhatsApp API/server and cannot send actual messages.
* **Offline**: The HTML has its embedded fonts, scripts and SVG icons; the demo
  UI does not need a live internet connection to show.
* **Device**: Android 7.0+ (API level 24), including Samsung Galaxy S25.

## Local build if you have Flutter

From the directory containing `pubspec.yaml`:

```bash
flutter create --platforms=android --project-name=greenleaf_mobile --org=com.greenleaf .
flutter pub get
flutter run
```

For the exact GitHub APK settings (including Android minimum SDK and app name),
use the checked-in workflow. The folder does not include generated Android SDK
boilerplate because GitHub Action creates it with the installed Flutter version.
