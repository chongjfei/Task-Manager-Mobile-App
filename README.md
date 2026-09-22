# Task Manager App

A Flutter task management app built for the Flutter Development Intern technical assessment.

## Features

- **Task List** — title, description, category, due date, completion status
- **Add / Edit / Delete** tasks (delete asks for confirmation)
- **Mark complete** with a visual strikethrough indicator
- **Dark mode** toggle (persisted)
- **Search** tasks by title/description
- **Categories** with filter chips (General, Work, Personal, Study, Health)
- **Due dates** with date + time picker, overdue tasks highlighted in red
- **Local notifications** scheduled for each task's due date
- **Cloud sync (optional)** — Firestore sync service included but not wired into
  the UI by default; enable it once you've set up a Firebase project (see below)

## Architecture

- **State management:** Provider (`TaskProvider`, `ThemeProvider`)
- **Local storage:** Hive (`Task` is a `HiveObject` with a hand-written
  `TypeAdapter` in `task.g.dart`, so no `flutter pub run build_runner build`
  step is required — though you can regenerate it that way if you change the model)
- **Structure:**
  ```
  lib/
    models/       Task (Hive model + adapter)
    providers/     TaskProvider, ThemeProvider
    screens/       HomeScreen, AddEditTaskScreen
    widgets/       TaskCard
    services/      NotificationService, SyncService (Firestore, optional)
    utils/         AppTheme, category list
    main.dart
  ```

## Setup

This project was written as source files without running Flutter tooling, so
you'll generate the platform folders (android/, ios/, etc.) yourself:

1. Install Flutter (stable channel) and run `flutter doctor` to confirm your
   setup.
2. From this folder, run:
   ```
   flutter create .
   ```
   This generates `android/`, `ios/`, and other platform folders around the
   existing `lib/` and `pubspec.yaml` without overwriting them.
3. Install dependencies:
   ```
   flutter pub get
   ```
4. **Android notification permissions** — add to
   `android/app/src/main/AndroidManifest.xml` inside `<manifest>`:
   ```xml
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
   <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
   <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
   ```
5. Run the app:
   ```
   flutter run
   ```

### Enabling cloud sync (optional bonus)

1. Create a Firebase project, then run `flutterfire configure` in this
   directory to generate `firebase_options.dart`.
2. In `main.dart`, initialize Firebase before `runApp()`:
   ```dart
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   ```
3. Call `SyncService` methods from `TaskProvider` (e.g. push on add/update,
   delete on delete) wherever you want sync to happen.

## Screenshots

<img width="472" height="873" alt="image" src="https://github.com/user-attachments/assets/fb049608-8a94-4ffb-9c91-a7e7864760cb" />

## Notes

- Tested logic paths manually against the Flutter/Dart APIs; since no Flutter
  SDK was available in the environment this was written in, please run
  `flutter analyze` after `flutter create .` to catch any environment-specific
  issues before submitting.
- If you change fields on `Task`, either hand-edit `task.g.dart` to match or
  delete it and run `flutter pub run build_runner build` to regenerate it.
