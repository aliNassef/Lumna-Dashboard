# Flutter Project — AI Coding Instructions

> **Always read and follow this file before generating any code & act as flutter expert.**


---
## Flutter style guide
* **SOLID Principles:** Apply SOLID principles throughout the codebase.
* **Concise and Declarative:** Write concise, modern, technical Dart code.
  Prefer functional and declarative patterns.
* **Composition over Inheritance:** Favor composition for building complex
  widgets and logic.
* **Immutability:** Prefer immutable data structures. Widgets (especially
  `StatelessWidget`) should be immutable.
* **State Management:** Separate ephemeral state and app state. Use a state
  management solution for app state to handle the separation of concerns.
* **Widgets are for UI:** Everything in Flutter's UI is a widget. Compose
  complex UIs from smaller, reusable widgets.
* **Navigation:** Use a modern routing package like `auto_route` or `go_router`.
  For more guidelines around navigation, see the section on [routing](#routing).

---
## Package Management
* **Pub Tool:** To manage packages, use the `pub` tool, if available.
* **External Packages:** If a new feature requires an external package, use the
  `pub_dev_search` tool, if it is available. Otherwise, identify the most
  suitable and stable package from pub.dev.
* **Adding Dependencies:** To add a regular dependency, use the `pub` tool, if
  it is available. Otherwise, run `flutter pub add <package_name>`.
* **Adding Dev Dependencies:** To add a development dependency, use the `pub`
  tool, if it is available, with `dev:<package name>`. Otherwise, run `flutter
  pub add dev:<package_name>`.
* **Dependency Overrides:** To add a dependency override, use the `pub` tool, if
  it is available, with `override:<package name>:1.0.0`. Otherwise, run `flutter
  pub add override:<package_name>:1.0.0`.
* **Removing Dependencies:** To remove a dependency, use the `pub` tool, if it
  is available. Otherwise, run `dart pub remove <package_name>`.

---

## Dart Best Practices
* **Effective Dart:** Follow the official Effective Dart guidelines
  (https://dart.dev/effective-dart)
* **Class Organization:** Define related classes within the same library file.
  For large libraries, export smaller, private libraries from a single top-level
  library.
* **Library Organization:** Group related libraries in the same folder.
* **API Documentation:** Add documentation comments to all public APIs,
  including classes, constructors, methods, and top-level functions.
* **Comments:** Write clear comments for complex or non-obvious code. Avoid
  over-commenting.
* **Trailing Comments:** Don't add trailing comments.
* **Async/Await:** Ensure proper use of `async`/`await` for asynchronous
  operations with robust error handling.
    * Use `Future`s, `async`, and `await` for asynchronous operations.
    * Use `Stream`s for sequences of asynchronous events.
* **Null Safety:** Write code that is soundly null-safe. Leverage Dart's null
  safety features. Avoid `!` unless the value is guaranteed to be non-null.
* **Pattern Matching:** Use pattern matching features where they simplify the
  code.
* **Records:** Use records to return multiple types in situations where defining
  an entire class is cumbersome.
* **Switch Statements:** Prefer using exhaustive `switch` statements or
  expressions, which don't require `break` statements.
* **Exception Handling:** Use `try-catch` blocks for handling exceptions, and
  use exceptions appropriate for the type of exception. Use custom exceptions
  for situations specific to your code.
* **Arrow Functions:** Use arrow syntax for simple one-line functions.

## Flutter Best Practices
* **Immutability:** Widgets (especially `StatelessWidget`) are immutable; when
  the UI needs to change, Flutter rebuilds the widget tree.
* **Composition:** Prefer composing smaller widgets over extending existing
  ones. Use this to avoid deep widget nesting.
* **Private Widgets:** Use small, private `Widget` classes instead of private
  helper methods that return a `Widget`.
* **Build Methods:** Break down large `build()` methods into smaller, reusable
  private Widget classes.
* **List Performance:** Use `ListView.builder` or `SliverList` for long lists to
  create lazy-loaded lists for performance.
* **Isolates:** Use `compute()` to run expensive calculations in a separate
  isolate to avoid blocking the UI thread, such as JSON parsing.
* **Const Constructors:** Use `const` constructors for widgets and in `build()`
  methods whenever possible to reduce rebuilds.
* **Build Method Performance:** Avoid performing expensive operations, like
  network calls or complex computations, directly within `build()` methods.
---

## Lint Rules

Include the package in the `analysis_options.yaml` file. Use the following
`analysis_options.yaml` file as a starting point:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Add additional lint rules here:
    # avoid_print: false
    # prefer_single_quotes: true
```
---

## Layout Best Practices

### Building Flexible and Overflow-Safe Layouts

#### For Rows and Columns

* **`Expanded`:** Use to make a child widget fill the remaining available space
  along the main axis.
* **`Flexible`:** Use when you want a widget to shrink to fit, but not
  necessarily grow. Don't combine `Flexible` and `Expanded` in the same `Row` or
  `Column`.
* **`Wrap`:** Use when you have a series of widgets that would overflow a `Row`
  or `Column`, and you want them to move to the next line.

#### For General Content

* **`SingleChildScrollView`:** Use when your content is intrinsically larger
  than the viewport, but is a fixed size.
* **`ListView` / `GridView`:** For long lists or grids of content, always use a
  builder constructor (`.builder`).
* **`FittedBox`:** Use to scale or fit a single child widget within its parent.
* **`LayoutBuilder`:** Use for complex, responsive layouts to make decisions
  based on the available space.

### Layering Widgets with Stack

* **`Positioned`:** Use to precisely place a child within a `Stack` by anchoring it to the edges.
* **`Align`:** Use to position a child within a `Stack` using alignments like `Alignment.center`.

### Advanced Layout with Overlays

* **`OverlayPortal`:** Use this widget to show UI elements (like custom
  dropdowns or tooltips) "on top" of everything else. It manages the
  `OverlayEntry` for you.

  ```dart
  class MyDropdown extends StatefulWidget {
    const MyDropdown({super.key});

    @override
    State<MyDropdown> createState() => _MyDropdownState();
  }

  class _MyDropdownState extends State<MyDropdown> {
    final _controller = OverlayPortalController();

    @override
    Widget build(BuildContext context) {
      return OverlayPortal(
        controller: _controller,
        overlayChildBuilder: (BuildContext context) {
          return const Positioned(
            top: 50,
            left: 10,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('I am an overlay!'),
              ),
            ),
          );
        },
        child: ElevatedButton(
          onPressed: _controller.toggle,
          child: const Text('Toggle Overlay'),
        ),
      );
    }
  }
  ```

---

## Documentation

* **`dartdoc`:** Write `dartdoc`-style comments for all public APIs.


### Documentation Philosophy

* **Comment wisely:** Use comments to explain why the code is written a certain
  way, not what the code does. The code itself should be self-explanatory.
* **Document for the user:** Write documentation with the reader in mind. If you
  had a question and found the answer, add it to the documentation where you
  first looked. This ensures the documentation answers real-world questions.
* **No useless documentation:** If the documentation only restates the obvious
  from the code's name, it's not helpful. Good documentation provides context
  and explains what isn't immediately apparent.
* **Consistency is key:** Use consistent terminology throughout your
  documentation.

### Commenting Style

* **Use `///` for doc comments:** This allows documentation generation tools to
  pick them up.
* **Start with a single-sentence summary:** The first sentence should be a
  concise, user-centric summary ending with a period.
* **Separate the summary:** Add a blank line after the first sentence to create
  a separate paragraph. This helps tools create better summaries.
* **Avoid redundancy:** Don't repeat information that's obvious from the code's
  context, like the class name or signature.
* **Don't document both getter and setter:** For properties with both, only
  document one. The documentation tool will treat them as a single field.

### Writing Style

* **Be brief:** Write concisely.
* **Avoid jargon and acronyms:** Don't use abbreviations unless they are widely
  understood.
* **Use Markdown sparingly:** Avoid excessive markdown and never use HTML for
  formatting.
* **Use backticks for code:** Enclose code blocks in backtick fences, and
  specify the language.

### What to Document

* **Public APIs are a priority:** Always document public APIs.
* **Consider private APIs:** It's a good idea to document private APIs as well.
* **Library-level comments are helpful:** Consider adding a doc comment at the
  library level to provide a general overview.
* **Include code samples:** Where appropriate, add code samples to illustrate usage.
* **Explain parameters, return values, and exceptions:** Use prose to describe
  what a function expects, what it returns, and what errors it might throw.
* **Place doc comments before annotations:** Documentation should come before
  any metadata annotations.

## Accessibility (A11Y)
Implement accessibility features to empower all users, assuming a wide variety
of users with different physical abilities, mental abilities, age groups,
education levels, and learning styles.

* **Color Contrast:** Ensure text has a contrast ratio of at least **4.5:1**
  against its background.
* **Dynamic Text Scaling:** Test your UI to ensure it remains usable when users
  increase the system font size.
* **Semantic Labels:** Use the `Semantics` widget to provide clear, descriptive
  labels for UI elements.
* **Screen Reader Testing:** Regularly test your app with TalkBack (Android) and
  VoiceOver (iOS).
  ---

## 🏗️ Architecture Overview

Each feature lives in its own folder and is split into two layers:

```
lib/
├── core/ # Shared utilities, constants, themes, errors, extensions, helpers, navigation , database, services.
└── features/
    └── <feature_name>/
        ├── data/ # External data, API/DB clients, DTOs, repository implementations
        │   ├── models/
        │   ├── data_sources/
        │   │   ├── <feature>_data_source.dart        # abstract interface
        │   │   └── <feature>_data_source_impl.dart   # implementation
        │   └── repositories/
        │       ├── <feature>_repository.dart          # abstract interface
        │       └── <feature>_repository_impl.dart     # implementation
        └── presentation/  # UI, state management, widgets 
            ├── view/
            │   └── <feature>_screen.dart
            ├── widgets/
            └── controller/
                ├── <feature>_cubit.dart
                └── <feature>_state.dart
```

---

## Layer Rules

### 1. Models (`data/models/`)
- Plain Dart classes representing data entities.
- Include `fromMap` / `toMap` where needed.
- Use `copyWith` for immutability.
- always extends from `Equatable` package.

```dart
class UserModel  extends Equatable {
  final String id;
  final String name;

  const UserModel({required this.id, required this.name});

  UserModel copyWith({String? id, String? name}) => UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(id: json['id'], name: json['name']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}
```

---

---

### 2. Data Source (`data/data_sources/`)
Always define an **abstract interface** first, then the **implementation**.

```dart
// abstract
abstract interface class UserRemoteDataSource {
  Future<UserModel> getUser(String id);
}

// implementation
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
 
  @override
  Future<UserModel> getUser(String id) async {
     // actual API/DB call here
  }
}
```


---

### 3. Repository (`data/repos/`)
Always define an **abstract interface** first, then the **implementation**.
use dartz package for error handling `Either` 
```dart
// abstract
abstract interface class UserRepository {
  Future<Either<Failure, UserModel>> getUser(String id);
}

// implementation
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource dataSource;
 

  UserRepositoryImpl({required this.dataSource});

  @override
   Future<Either<Failure, UserModel>> getUser(String id) async {
    try {
        final user =await dataSource.getUser(id);
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
```

---

### 4. State (`presentation/controller/<feature>_state.dart`)
Use **sealed classes** for exhaustive state handling.  
Use **`copyWith`** when passing multiple data fields inside a state variant.
always extends from `Equatable` package.
```dart
sealed class UserState  extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final UserModel user;
  final bool isFavorite;

  const UserLoaded({required this.user, required this.isFavorite});

  @override
  List<Object?> get props => [user, isFavorite];

}

class UserError extends UserState {
  final Failure failure;
  const UserError({required this.failure});

  @override
  List<Object?> get props => [failure];
}
```
if the state has multiple variants params, use **`enum`** instead of **`sealed class`**.
``` dart

enum CartStatus { intial, loading, failure, success, add, updateQuantity }

extension CartStatusX on CartStatus {
  bool get isLoading => this == CartStatus.loading;
  bool get isSuccess => this == CartStatus.success;
  bool get isFailure => this == CartStatus.failure;
  bool get isInitial => this == CartStatus.intial;
  bool get isAdded => this == CartStatus.add;
  bool get isUpdatingQuantity => this == CartStatus.updateQuantity;
}

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItemModel> cartItems;
  final Set<String> ids;
  final Failure? failure;
  const CartState({
    this.cartItems = const [],
    this.status = CartStatus.intial,
    this.ids = const {},
    this.failure,
  });
  CartState copyWith({
    CartStatus? status,
    Set<String>? ids,
    Failure? failure,
    List<CartItemModel>? cartItems,
  }) {
    return CartState(
      status: status ?? this.status,
      ids: ids ?? this.ids,
      failure: failure ?? this.failure,
      cartItems: cartItems ?? this.cartItems,
    );
  }

  num get total => cartItems.fold(
    0,
    (previousValue, element) =>
        previousValue + (element.price * element.quantity),
  );
  @override
  List<Object> get props => [status, ids, cartItems];
}
```
---
### 5. Logging Always use `Logger` — never `print` or `debugPrint`.
```dart 
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

abstract class Logger {
  static void info(String message, {String tag = 'INFO'}) {
    if (kDebugMode) {
      developer.log(message, name: tag);
    }
  }

  static void warning(String message, {String tag = 'WARNING'}) {
    if (kDebugMode) {
      developer.log(message, name: tag, level: 900); // 900 ~ WARNING
    }
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String tag = 'ERROR',
  }) {
    developer.log(
      message,
      name: tag,
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }

  static void debug(String message, {String tag = 'DEBUG'}) {
    if (kDebugMode) {
      developer.log(message, name: tag, level: 500);
    }
  }
}
```
- use Logger.debug() for debug logs.
- use Logger.info() for info logs.
- use Logger.warning() for warning logs.
- use Logger.error() for error logs.
--- 
### 6. Use CustomButton Widget for all buttons & CustomTextFormField for all text form fields.
---
### 7. Use CustomFailureWidget for all error handling in UI.
---
### 8. Use Switch(state) for handling state in UI.
--- 
### 9. Use `context.pushNamed()` for navigation, Don't use `Navigator.of(context).pushNamed()` anywhere.
--- 
### 10. Use `context.pushNamedAndRemoveUntil()` for navigation, Don't use `Navigator.of(context).pushNamedAndRemoveUntil()` anywhere.
---

### 11. Ask for a Plan First

```
Before coding, create a step-by-step plan
```

Benefits:

* Better structure
* Fewer mistakes

---


### 🤖 Agent Operating Rules
- ✅ Always check `core/navigation/` before adding routes.
- ✅ Place new services in `core/services/`.
- ✅ Keep `presentation/` files < 120 lines. Extract complex logic to `state/`.
- ✅ Use explicit error types ( `Either`, or sealed classes) for async operations.
- ✅ Never hardcode endpoints, keys, or paths. Use `core/constants/Endpoints` or `.env`.
- ✅ Follow naming: `snake_case` (files/folders), `PascalCase` (classes), `camelCase` (vars/methods).
- ❌ Never mix UI logic into services or database classes.
- ❌ Never bypass `core/navigation/` for programmatic routing.
- ❌ Never use `dynamic` unless parsing unknown third-party JSON.
---
Keep every file under 120 lines of code. If it grows beyond that, split it immediately into multiple files.
Never return a Widget directly from a function.
Always extract UI into a separate Widget class.
Each Widget must be placed in its own file when it becomes reusable or exceeds a small local scope.
Do not define Widgets as private (no _WidgetName); always use public class names.
Avoid anonymous Widget builders for complex UI; prefer named Widgets.
Break large UI trees into small, single-responsibility Widgets.
Each file should have one clear responsibility (Single Responsibility Principle).
Do not mix business logic with UI code inside Widgets.
Keep build methods clean; if logic appears, extract it into methods or separate classes.
Prefer composition over large monolithic Widgets.
If a Widget is used in more than one place, it must be moved to a shared components folder.


## Quick Checklist Before Generating Code

- [ ] Feature folder has both `data/` and `presentation/` sub-layers
- [ ] Data source has abstract interface + impl
- [ ] Repository has abstract interface + impl
- [ ] State uses sealed class
- [ ] State variants with multiple fields have `copyWith`
- [ ] Cubit uses `Logger`, not `print`
- [ ] View handles every sealed state variant
- [ ] Navigation uses `context.pushNamed()` (core system)
- [ ] No raw `Navigator` calls anywhere
