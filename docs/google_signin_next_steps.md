# Google Sign-In — Remaining Work

Status of the Google sign-in feature and what still needs to be handled before it
works end-to-end.

---

## ✅ Done

| Layer | File | What |
|---|---|---|
| Service | `lib/core/services/auth/supabase_auth_impl.dart` | `signInWithGoogle()` calls `signInWithOAuth(OAuthProvider.google)` |
| Data source | `lib/features/auth/data/datasource/auth_remote_datasource.dart` | `signInWithGoogle()` + `ServerException` mapping |
| Repository | `lib/features/auth/data/repo/auth_repo.dart` | `signInWithGoogle()` returning `Either<Failure, void>` |
| Cubit | `lib/features/auth/presentation/controller/auth_cubit/auth_cubit.dart` | `signInWithGoogle()` emits `AuthLoading → AuthSuccess / AuthError` |
| Widget | `lib/features/auth/presentation/widgets/continue_with_google_button.dart` | `onTap` callback |
| View | `lib/features/auth/presentation/widgets/login_view_body.dart` | Button calls `cubit.signInWithGoogle()` |
| Android | `android/app/src/main/AndroidManifest.xml` | Deep-link intent filter for `io.supabase.ecommerce` |
| iOS | `ios/Runner/Info.plist` | `CFBundleURLTypes` for `io.supabase.ecommerce` |
| Deep link | `lib/features/auth/.../auth_cubit.dart` | `AuthCubit` consumes `DeepLinkService.stream`; emits `AuthSuccess` only after the real Google `signedIn` event |
| Admin gate | `auth_remote_datasource.dart` / `auth_repo.dart` | `isCurrentUserAdmin()` checks `profiles.role`; non-admins are signed out with `error_permission` |
| DI | `lib/core/di/injection_container.dart` | `Database` injected into `AuthRemoteDataSourceImpl` |

---

## 🔜 Next — must handle

### 1. Supabase dashboard config (blocking)
- **Auth → URL Configuration → Redirect URLs**, add:
  - `io.supabase.ecommerce://login-callback`
  - `io.supabase.ecommerce://reset-callback`
- **Auth → Providers → Google**: enable + set Client ID / Secret.
- Google Cloud OAuth client: register Android package name + **SHA-1**
  (debug and release), and the iOS bundle id.

Without these the browser opens but the callback is rejected.

### 2. Handle the OAuth callback → session ✅ DONE
`AuthCubit` now subscribes to `DeepLinkService.instance.stream` and emits
`AuthSuccess` only when the real `googleLogin` event arrives (the
`signInWithGoogle()` success branch no longer navigates on browser launch). The
existing `BlocConsumer` in `login_view_body.dart` handles navigation.

### 3. Admin-only access check ✅ DONE
After the Google session arrives, `AuthCubit._onDeepLink` calls
`authRepo.isCurrentUserAdmin()` (reads `profiles.role`). Non-admins are signed
out and shown `error_permission`; only admins reach `LayoutView`.

### 4. iOS `SceneDelegate` deep-link forwarding
The project uses a `SceneDelegate` (see `Info.plist`). Confirm it forwards
incoming URLs so `supabase_flutter` receives the callback; otherwise the session
never lands on iOS.

---

## 🧪 Verify
- Android: tap **Continue with Google** → browser → returns to app → session set →
  navigates to `LayoutView`.
- iOS: same flow (needs a Mac/simulator).
- Cancel mid-flow → no crash, returns to login.
- Non-admin Google account → blocked (after step 3).

---

## 📝 Notes
- Redirect scheme: `io.supabase.ecommerce`
  (`login-callback` for OAuth, `reset-callback` for password reset).
- `_signInWithGoogle` reuses the same `AuthState` variants, so the existing
  `BlocConsumer` listener in `login_view_body.dart` handles its success/error.
- SDK note: local Flutter is `3.9.0` but the project needs `^3.11.0` —
  run `flutter upgrade` before `flutter analyze` / build.
