# JobagzStore - Flutter Setup Guide

## Prerequisites
- Flutter SDK: https://docs.flutter.dev/get-started/install
- Android Studio (for Android) or Xcode (for iOS)

## 1. Supabase Setup
1. Go to https://supabase.com and create a new project.
2. Open SQL Editor, paste `supabase/schema.sql`, and run it.
3. Go to Settings > API and copy the Project URL and anon public key.

## 2. Install Dependencies
```bash
flutter pub get
```

## 3. Run the App
Use your Supabase project URL and anon key:

```powershell
flutter run -d chrome `
  --dart-define=SUPABASE_URL=https://rqpnzmdhdpzyeidtfxia.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

## 4. Build Release APK (Android)
```powershell
flutter build apk --release `
  --dart-define=SUPABASE_URL=https://rqpnzmdhdpzyeidtfxia.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```
APK output: `build/app/outputs/flutter-apk/app-release.apk`
Share this file to family members via USB, Google Drive, or Viber.

## 5. Build for iOS
```powershell
flutter build ios --release `
  --dart-define=SUPABASE_URL=https://rqpnzmdhdpzyeidtfxia.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```
Requires an Apple Developer account for device distribution.

## Project Structure
```
lib/
|-- main.dart                  # App entry point
|-- core/
|   |-- theme.dart             # Colors (navy, gold, red)
|   `-- router.dart            # Navigation (go_router)
|-- models/
|   `-- product.dart           # Product data class
|-- repositories/
|   `-- product_repository.dart # Supabase CRUD queries
|-- providers/
|   `-- product_provider.dart  # Riverpod state management
`-- screens/
    |-- splash_screen.dart     # Animated splash
    |-- home_screen.dart       # Search + product list
    `-- add_product_screen.dart # Add/Edit form
```
