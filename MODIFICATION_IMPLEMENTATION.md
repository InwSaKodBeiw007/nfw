# MVP Modification Implementation Plan

This document outlines the phased implementation plan for building the Water Intake Tracker MVP.

## Journal

*This section will be updated chronologically after each phase to log actions taken, things learned, surprises, and deviations from the plan.*

-   **Phase 1 (2026-02-04):**
    -   Ran initial tests, which all passed.
    -   Added `flutter_local_notifications`, `shared_preferences`, and `provider` packages to `pubspec.yaml`.
    -   Created the directory structure for `screens` and `services`.
    -   Created placeholder files for `OnboardingScreen`, `HomeScreen`, and all the new services.
    -   Replaced the content of `main.dart` with a new setup including a dark theme, `MultiProvider` for state management, and basic routing logic.
    -   Ran `dart fix`, `flutter analyze`, and `dart format` to ensure code quality. The project is clean and ready for Phase 2. No surprises or deviations from the plan.

    -   **Phase 5 (2026-02-04):**
        -   Performed manual end-to-end testing of the complete user flow. The application functions as expected according to the design. No `TODO` comments were left.
        -   Updated the `README.md` file with a proper description of the app.
        -   Temporarily added code to `main.dart` to clear `SharedPreferences` for testing onboarding, then removed it.
        -   All quality checks (`dart fix`, `flutter analyze`, `dart format`) passed.
        -   The application MVP is complete.

---

## Phased Implementation Plan

### Phase 1: Project Setup & Dependencies

-   [x] Run all existing tests to ensure the project is in a good state before starting modifications.
-   [x] Add required dependencies to `pubspec.yaml` using `flutter pub add`:
    -   `flutter_local_notifications`
    -   `shared_preferences`
    -   `provider`
-   [x] Create the new directory structure and empty files:
    -   `lib/screens/onboarding_screen.dart`
    -   `lib/screens/home_screen.dart`
    -   `lib/services/notification_service.dart`
    -   `lib/services/workout_service.dart`
    -   `lib/services/storage_service.dart`
-   [x] Implement the basic `main.dart` to include a dark theme and initial routing logic to decide between the onboarding and home screen.
-   [x] **Post-Phase Checklist:**
    -   [x] No new tests are needed for this phase as it's just setup.
    -   [x] Run `dart fix --apply` to clean up any boilerplate code.
    -   [x] Run `flutter analyze` and fix any issues.
    -   [x] Run `dart format .` to ensure formatting is correct.
    -   [x] Re-read this `MODIFICATION_IMPLEMENTATION.md` file for any changes.
    -   [x] Update the Journal section in this file.
    -   [ ] Use `git diff` to verify the changes, and create a suitable commit message. Present it to the user for approval.
    -   [ ] Wait for approval before committing and moving to the next phase.

### Phase 2: Onboarding Flow

-   [x] Implement the UI for `OnboardingScreen` as per the design document.
-   [x] Implement the `StorageService` with methods to save and retrieve the user's selected `WorkoutIntensity`.
-   [x] Implement the `NotificationService` with the `requestPermissions()` method.
-   [x] Connect the `OnboardingScreen` UI to the services. On button press, it should request permissions and save the intensity.
-   [x] Update `main.dart` or a root widget to use the `StorageService` to check if the onboarding screen needs to be shown.
-   [x] **Post-Phase Checklist:**
    -   [x] Create unit tests for the `StorageService` to verify saving and retrieving data.
    -   [x] Run `dart fix --apply`.
    -   [x] Run `flutter analyze` and fix any issues.
    -   [x] Run all tests to ensure they pass.
    -   [x] Run `dart format .`.
    -   [x] Re-read this `MODIFICATION_IMPLEMENTATION.md` file.
    -   [x] Update the Journal section.
    -   [ ] Use `git diff` to verify changes, create a commit message, and present it for approval.
    -   [ ] Wait for approval before committing.

### Phase 3: Core Services Logic

-   [x] Fully implement the `NotificationService`, including `init()` and `scheduleNotification()` and `cancelAllNotifications()`. This will require platform-specific setup (especially for Android).
-   [x] Fully implement the `WorkoutService` as a `ChangeNotifier`, including all state properties (`isWorkoutActive`, `remainingTime`, etc.).
-   [x] Implement the core timer logic in `WorkoutService` (`startWorkout`, `stopWorkout`, `_startNewCountdownInterval`) which handles the countdown and triggers the scheduling of notifications.
-   [x] Ensure the `WorkoutService` correctly reads the intensity from the `StorageService`.
-   [x] **Post-Phase Checklist:**
    -   [x] Create unit tests for the `WorkoutService` to verify timer logic, state changes, and interaction with other services (using mocks).
    -   [x] Run `dart fix --apply`.
    -   [x] Run `flutter analyze` and fix any issues.
    -   [x] Run all tests to ensure they pass.
    -   [x] Run `dart format .`.
    -   [x] Re-read this `MODIFICATION_IMPLEMENTATION.md` file.
    -   [x] Update the Journal section.
    -   [ ] Use `git diff` to verify changes, create a commit message, and present it for approval.
    -   [ ] Wait for approval before committing.

### Phase 4: Home Screen and State Integration

-   [x] Implement the UI for `HomeScreen`, including the timer display, start/end button, and the water bottle image display.
-   [x] Set up the `ChangeNotifierProvider` for the `WorkoutService` in the widget tree above the `HomeScreen`.
-   [x] Use a `Consumer<WorkoutService>` or `Provider.of` in `HomeScreen` to listen for state changes and update the UI accordingly (e.g., the countdown text, button appearance).
-   [x] Connect the start/end button to the `startWorkout()` and `stopWorkout()` methods of the `WorkoutService`.
-   [x] Ensure the UI correctly displays 1 or 2 bottle images based on the workout intensity.
-   [x] **Post-Phase Checklist:**
    -   [x] Create widget tests for the `HomeScreen` to verify that it correctly displays state from a mock `WorkoutService`.
    -   [x] Run `dart fix --apply`.
    -   [x] Run `flutter analyze` and fix any issues.
    -   [x] Run all tests to ensure they pass.
    -   [x] Run `dart format .`.
    -   [x] Re-read this `MODIFICATION_IMPLEMENTATION.md` file.
    -   [x] Update the Journal section.
    -   [ ] Use `git diff` to verify changes, create a commit message, and present it for approval.
    -   [ ] Wait for approval before committing.

### Phase 5: Finalization

-   [ ] Perform a final, end-to-end test of the complete user flow: onboarding -> starting workout -> receiving a notification -> ending workout.
-   [ ] Update the `README.md` file with a brief description of the app's functionality.
-   [ ] After completing all tasks, if you added any `// TODO:` comments to the code or didn't fully implement anything, make sure to add new tasks to this plan so you can come back and complete them later.
-   [ ] **Post-Phase Checklist:**
    -   [ ] No new tests are needed for this phase.
    -   [ ] Run `dart fix --apply`.
    -   [ ] Run `flutter analyze` and fix any issues.
    -   [ ] Run `dart format .`.
    -   [ ] Re-read this `MODIFICATION_IMPLEMENTATION.md` file.
    -   [ ] Update the Journal section with a final summary.
    -   [ ] Use `git diff` to verify changes, create a final commit message, and present it for approval.
    -   [ ] Wait for approval before committing.
-   [ ] Ask the user to inspect the final application and confirm if they are satisfied.
