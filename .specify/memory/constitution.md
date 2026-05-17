<!--
  Sync Impact Report
  Version change: (new) → 1.0.0
  All sections: new (initial constitution)
  Templates requiring updates: none (all generic templates align)
  Follow-up TODOs: none
-->

# Lumna Admin Constitution

## Core Principles

### I. Feature-First Architecture (Layered)

Every feature lives in `lib/features/<name>/` with strict two-layer separation:

- **`data/`** — models, data sources (abstract interface + impl), repositories (abstract interface + impl with `Either<Failure, T>`)
- **`presentation/`** — views, widgets, controller (Cubit + state)

Layer rules are non-negotiable:
- `data/` MUST NOT import from `presentation/`
- Presentation MUST NOT directly access data sources or database — flow goes View → Cubit → Repo → DataSource → Database
- Every DataSource and Repository MUST define an abstract `interface class` before its implementation
- Models MUST extend `Equatable`, implement `fromMap`/`toMap`, and provide `copyWith`

Rationale: Enables testability, parallel development, and clear ownership boundaries across 9+ features.

### II. Cubit + Either State Management

All feature state management uses `flutter_bloc` Cubits with `dartz` for error handling:

- Cubits call repo methods and `.fold()` on the `Either<Failure, T>` result
- States use either **sealed classes** (for disjoint variants) or **class + enum `status` field** with `copyWith` (for multi-field states)
- Every state class MUST extend `Equatable`
- Repos return `Either<Failure, T>` — Left is `Failure`, Right is success data
- DataSources throw `ServerException` on backend errors — repos catch and convert to `Failure`
- View handling: use `switch(state)` for exhaustive sealed class matching

Rationale: Consistent, predictable state transitions with explicit error paths at every layer.

### III. Supabase Backend Abstraction

All backend operations go through abstractions in `lib/core/`:

- **Database**: All CRUD + streaming through the `Database` interface (`core/database/database.dart`). The `SupabaseDpImpl` wraps `SupabaseClient`. Never access `SupabaseClient` directly from features.
- **Auth**: All authentication through `AuthService` interface (`core/services/auth/`). Uses Supabase Auth (email/password, Google OAuth, PKCE flow).
- **Storage**: File uploads through `StorageService` interface (`core/services/storage/`). Uses Supabase Storage buckets.
- **Real-time**: Use `Database.stream()` for live data (e.g., orders). Supabase `stream()` with primary key filtering.
- **Endpoints/keys**: All table names, storage bucket names, and configuration MUST be in `core/constants/`. No hardcoding.
- **RPCs**: Custom SQL functions called via `Database.rpc()`.

Rationale: Single abstraction layer means Supabase can be replaced without touching feature code. Centralized error handling.

### IV. Code Quality & Widget Hygiene

Strict code quality rules enforced at all times:

- **File size**: Every file MUST stay under 120 lines. Exceeding requires immediate split.
- **Widget rules**: One widget per file. Public classes only — no `_WidgetName` private widgets. Never return Widget from functions. Extract complex UI into named widget classes.
- **Logging**: Use `Logger` (`core/logging/`) — never `print` or `debugPrint`. Levels: debug, info, warning, error.
- **Navigation**: Use `context.pushNamed()` and `context.pushNamedAndRemoveUntil()` from `core/navigation/`. Never use raw `Navigator.of(context)`.
- **Models**: Immutable with `copyWith` + `Equatable` + `fromMap`/`toMap`.
- **Reusable widgets**: Use `CustomButton` for all buttons, `CustomTextFormField` for all text fields, `CustomFailureWidget` for all error states.
- **Naming**: `snake_case` for files/folders, `PascalCase` for classes, `camelCase` for vars/methods.
- **Alerting**: Use `showAppDialog()` extension for success/error dialogs, `showToast()` for toasts.

Rationale: Maintains a consistent, readable codebase that scales. Prevents common Flutter anti-patterns.

### V. Localization & Internationalization

All user-facing text MUST be localized:

- Use `easy_localization` with generated `LocaleKeys` constants
- Supported locales: English (`en`), Arabic (`ar`) — Arabic is default
- After modifying translation files (`assets/translations/en.json`, `assets/translations/ar.json`), regenerate keys: `dart run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart -O lib/core/translation`
- Validation error messages MUST also use `LocaleKeys`, never hardcoded strings
- Use `context.locale.languageCode` for RTL/layout decisions

Rationale: The app serves an Arabic-first user base with English fallback. Every string path must be traceable through generated keys.

## Technology Stack & Constraints

### Framework & Core
| Category | Technology | Constraint |
|----------|-----------|------------|
| **Framework** | Flutter SDK ^3.11 | Locked to SDK version range |
| **State Management** | flutter_bloc ^9.1.1 | Cubit pattern only (no Bloc events) |
| **DI** | get_it ^9.2.1 | Service locator — Cubits as factories, everything else as singletons |
| **Responsive** | flutter_screenutil | Use `ScreenUtil` for all size/layout calculations |

### Backend & Services
| Service | Technology | Purpose |
|---------|-----------|---------|
| **Database** | Supabase (supabase_flutter ^2.12.2) | Data, real-time streams, RPCs |
| **Auth** | Supabase Auth | Email/password, Google OAuth, PKCE |
| **Storage** | Supabase Storage | Images (avatars, products, categories) |
| **Push** | Firebase FCM + flutter_local_notifications | Remote + local notifications |
| **Maps** | Mapbox (mapbox_maps_flutter + geocoding API via Dio) | Store location, geocoding |
| **Location** | geolocator | Device GPS for store address |
| **Caching** | shared_preferences + flutter_secure_storage | Local persistence |

### UI & Assets
- **Fonts**: Google Fonts — Plus Jakarta Sans (via `google_fonts`)
- **Icons**: Material Icons + custom SVGs in `assets/icons/`
- **Images**: Network images via `cached_network_image`, SVG via `flutter_svg`
- **Theme**: Material 3 with custom `ThemeExtension` for typography (`AppTextStyle`) and colors (`AppLightColors`/`AppDarkColors`)

### Compliance
- No hardcoded endpoints, keys, or storage paths — MUST use `core/constants/Endpoints` and `core/constants/`
- All secrets (Supabase anon key, Mapbox token) are in `app_config.dart` (non-sensitive public keys only)
- Linting: `flutter_lints` with project-specific rules in `analysis_options.yaml`

## Development Workflow & Conventions

### Feature Creation
1. Use `feature_script.dart` to scaffold new features with the standard folder structure
2. Always create: abstract DataSource interface → impl → abstract Repo interface → impl → Cubit + sealed/enum state → View + Widgets
3. Register all new dependencies in `lib/core/di/injection_container.dart` via `setupLocator()`

### Code Generation
- After editing `assets/translations/*.json`, regenerate `LocaleKeys`:
  ```
  dart run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart -O lib/core/translation
  ```

### Quality Gates
- Run `flutter analyze` before committing — zero warnings/errors required
- Every file under 120 lines — review and split during PR
- No `print`/`debugPrint` — only `Logger`
- All routes must pass through `core/navigation/AppRouter`
- All navigation calls must use `context.pushNamed()` extensions

### Commit Conventions
- Use conventional commit format: `type(scope): message`
- Types: `feat`, `fix`, `refactor`, `docs`, `chore`, `test`
- Scope: feature name (e.g., `products`, `orders`, `auth`)

## Governance

### Amendment Procedure
1. Propose changes to this constitution as a markdown diff
2. Changes must be reviewed and approved by at least one maintainer
3. After approval, update the constitution with the new content
4. Bump `CONSTITUTION_VERSION` according to semantic versioning:
   - MAJOR — backward incompatible principle removals or redefinitions
   - MINOR — new principle/section added or materially expanded guidance
   - PATCH — clarifications, wording, typo fixes, non-semantic refinements
5. Run consistency propagation checklist (templates, guidance docs, RULES.MD)
6. Commit with message format: `docs: amend constitution to vX.Y.Z (reason)`

### Compliance Review
- Every spec/plan cycle MUST reference the constitution for principle alignment
- Code reviews MUST verify compliance with widget hygiene rules (file size, Logger, navigation)
- Violations of Core Principles MUST be justified in the plan's Complexity Tracking section

### Versioning
**Version**: 1.0.0 | **Ratified**: 2026-05-17 | **Last Amended**: 2026-05-17
