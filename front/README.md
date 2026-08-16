# FactoryCare — Maintenance Technician App (UI Prototype)

A **frontend-only** Flutter prototype for the sewing factory maintenance app. Everything runs on mock/hardcoded data — no backend, no API calls, no real authentication. This matches the brief: a polished, realistic UI and navigation flow that a backend can be wired into later.

## Status

Fully built per the spec: all 8 screens, dark Material 3 theme, GoRouter navigation, Riverpod state management, mock data organized as a swappable "repository" layer.

**I don't have Flutter/Dart tooling available in the sandbox this was built in** (no network access to `pub.dev`), so I could not run `flutter pub get`, `flutter analyze`, or a live build to verify it compiles. I reviewed every file manually — checked brace/paren balance, import usage, and deliberately used long-stable Flutter APIs (`.withOpacity()`, `CardTheme`, `DialogTheme`, `MaterialStateProperty`) instead of very recent ones I couldn't verify against a live SDK — but please run `flutter pub get && flutter analyze` before treating this as build-verified, and let me know what comes up if anything does.

## Setup

```bash
flutter pub get
flutter run
```

No environment variables, no backend required. Any email/password on the login screen will "log in" successfully after a short simulated delay.

## Screens & flow

```
Splash (auto, ~1.6s)
  -> Login (fake auth, any credentials)
    -> Home / Notifications / Profile (bottom nav)
         Notifications: Accept -> Assigned Repair (10-min prep countdown)
                                     -> Start Repair -> Repair (live upward timer)
                                                            -> Finish Repair -> Repair Report (mandatory form)
                                                                                   -> Submit -> success dialog -> Home
```

## Project structure

```
lib/
  core/
    theme/          # AppColors, AppTheme (Material 3, dark-only)
    router/          # GoRouter config — shell for bottom nav + pushed workflow screens
  models/            # Technician, Machine, RepairNotification, AssignedRepair, RepairHistoryEntry, RepairReport, RepairPriority
  providers/
    mock_data.dart              # ALL fake data lives here — the single seam to replace with real API calls later
    auth_provider.dart          # fake login/logout
    ticker_provider.dart        # 1-second stream driving the countdown/timer reactively
    technician_provider.dart
    notifications_provider.dart
    assigned_repair_provider.dart
    repair_history_provider.dart
    repair_workflow_controller.dart   # orchestrates accept -> start -> finish -> submit across providers
  shared/
    widgets/         # PrimaryButton, AppCard, PriorityChip, StatusBadge, SectionTitle, ReadOnlyField
    scaffold/         # MainShell (bottom nav with notification badge)
    utils/             # time/duration formatters
  features/
    splash/ auth/ home/ notifications/ repair/ report/ profile/
  main.dart
```

Note: widgets live under `shared/widgets/` rather than a top-level `widgets/` folder, to keep everything reusable-but-not-a-model-or-provider under one `shared/` namespace. Functionally identical to what was asked for — just nested one level differently.

## Design notes

- **Mock data is isolated in one file** (`providers/mock_data.dart`) so wiring up the real backend later means replacing that file's contents with repository/API calls — the providers, controller, and UI don't need to change shape.
- **`RepairWorkflowController`** exists so screens never touch more than one provider directly for a workflow action (e.g. "accept" touches the notification list, the assigned-repair state, *and* the technician's status — the screen just calls one method).
- **`tickerProvider`** is a single shared 1-second stream so the prep countdown and repair timer don't each manage their own `Timer`/dispose lifecycle — they just recompute from stored timestamps whenever the tick fires.
- **The 10-minute prep deadline is derived, not stored** (`acceptedAt + 10min`), mirroring the same decision made on the backend side for the same reason: one less value that can drift.

## Next step (not part of this prototype)

Wiring this UI to the real backend (auth, incidents, reports, Socket.IO) that was built in the earlier phase of this project — swapping `mock_data.dart` and the providers' fake logic for real Dio/Socket.IO calls.
