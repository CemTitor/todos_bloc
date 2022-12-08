# Todos Bloc

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Generated by the [Very Good CLI][very_good_cli_link] 🤖

An example todos app that showcases bloc state management patterns.

---

## Key Topics

- Bloc and Cubit to manage the various feature states.
- Layered Architecture for separation of concerns and to facilitate reusability.
- BlocObserver to observe state changes.
- BlocProvider, a Flutter widget which provides a bloc to its children.
- BlocBuilder, a Flutter widget that handles building the widget in response to new states.
- BlocListener, a Flutter widget that handlers performing side effects in response to state changes.
- RepositoryProvider, a Flutter widget to provide a repository to its children.
- Equatable to prevent unnecessary rebuilds.
- MultiBlocListener, a Flutter widget that reduces nesting when using multiple BlocListeners.


## Architecture

Layering our code is incredibly important and helps us iterate quickly and with confidence. Each layer has a single responsibility and can be used and tested in isolation. This allows us to keep changes contained to a specific layer in order to minimize the impact on the entire application. In addition, layering our application allows us to easily reuse libraries across multiple projects (especially with respect to the data layer).

Our application consists of three main layers:

- data layer 
- domain layer
- feature layer
  - presentation/UI (widgets)
  - business logic (blocs/cubits)

# Data Layer

This layer is the lowest layer and is responsible for retrieving raw data from external sources such as a databases, APIs, and more. Packages in the data layer generally should not depend on any UI and can be reused and even published on pub.dev as a standalone package. 

In this example, our data layer consists of the todos_api and local_storage_todos_api packages.

The data layer is the lowest layer in our application and consists of raw data providers. Packages in this layer are primarily concerned with where/how data is coming from. In this case our data layer will consist of the TodosApi, which is an interface, and the LocalStorageTodosApi, which is an implementation of the TodosApi backed by shared_preferences.



  
# Domain(Repository) Layer

This layer combines one or more data providers and applies "business rules" to the data. Each component in this layer is called a repository and each repository generally manages a single domain. Packages in the repository layer should generally only interact with the data layer. In this example, our repository layer consists of the todos_repository package.

A repository is part of the business layer. A repository depends on one or more data providers that have no business value, and combines their public API into APIs that provide business value. In addition, having a repository layer helps abstract data acquisition from the rest of the application, allowing us to change where/how data is being stored without affecting other parts of the app.

# Feature Layer

This layer contains all of the application-specific features and use cases. Each feature generally consists of some UI and business logic. Features should generally be independent of other features so that they can easily be added/removed without impacting the rest of the codebase. Within each feature, the state of the feature along with any business logic is managed by blocs. Blocs interact with zero or more repositories. Blocs react to events and emit states which trigger changes in the UI. Widgets within each feature should generally only depend on the corresponding bloc and render UI based on the current state. The UI can notify the bloc of user input via events. In this example, our application will consist of the home, todos_overview, stats, and edit_todos features.



## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*Todos Bloc works on iOS, Android, Web, and Windows._

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:todos_bloc/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

[comment]: <> (```xml)
    

[comment]: <> (    <key>CFBundleLocalizations</key>)

[comment]: <> (	<array>)

[comment]: <> (		<string>en</string>)

[comment]: <> (		<string>es</string>)

[comment]: <> (	</array>)

    
[comment]: <> (```)

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
