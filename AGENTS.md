# AGENTS.md - Flutter Codebase Guidelines & Architecture Specification

This document defines the architectural patterns, directory structures, coding standards, state management conventions, and development rules for this Flutter project. AI coding agents working on this project MUST strictly follow these guidelines.

---

## 1. Overall Project Architecture

This application strictly adheres to **Clean Architecture** layered design combined with the **BLoC / Cubit** pattern for state management and **GetIt / Injectable** for Dependency Injection.

The architecture strictly separates concerns into three primary layers per feature:
- **Presentation (UI Layer)**: Screens (`views`), feature-specific widgets, and state management controllers (`Cubits` & `States`).
- **Domain Layer**: Core business logic, pure data entities, abstract repository interfaces, and use cases.
- **Data Layer**: Data access implementations, API networking clients (`Dio`), data sources (`contract` & `impl`), data transfer models (DTOs), and local caching (`Hive`, `SharedPreferences`).

```
                               ┌─────────────────────────┐
                               │  Presentation (UI)      │
                               │  Views, Cubit, State    │
                               └───────────┬─────────────┘
                                           │ (calls)
                                           ▼
                               ┌─────────────────────────┐
                               │       Domain Layer      │
                               │  Use Cases & Entities   │
                               └───────────┬─────────────┘
                                           │ (implements contract)
                                           ▼
                               ┌─────────────────────────┐
                               │        Data Layer       │
                               │  RepoImpl & DataSources │
                               └─────────────────────────┘
```

---

## 2. Folder Structure & Responsibilities

The codebase is organized into `lib/core` (shared infrastructure and utilities) and `lib/feature` (modular feature-based components).

```
lib/
├── core/
│   ├── api/          # Network manager (Dio wrapper), API endpoints, API base URLs
│   ├── di/           # Dependency Injection setup using GetIt & Injectable
│   ├── provider/     # Global ChangeNotifier providers (e.g., LanguageProvider)
│   ├── utils/        # App constants, routes, colors, styles, assets, strings, validators, failures, local caching wrappers
│   └── widgets/      # Reusable cross-feature UI widgets (custom text fields, buttons, dialogs)
├── feature/
│   └── <feature_name>/
│       ├── data/     # Data sources, data models (DTOs), repository implementations
│       ├── domain/   # Entities, repository abstract contracts, use cases
│       └── ui/       # Views (screens), viewmodels (Cubits & States), feature widgets
└── main.dart         # App entry point, initialization, localization, providers, routes
```

### Responsibility of Core Folders:
- **`lib/core/api/`**: Contains `ApiManger` (singleton managing HTTP methods), `EndPoints` (static endpoint constants), and `ApiConstants` (base URLs).
- **`lib/core/di/`**: Contains `di.dart` for initializing `GetIt` via `injectable`.
- **`lib/core/provider/`**: Houses app-wide state providers (e.g., `LanguageProvider` for localization state).
- **`lib/core/utils/`**: Centralized design system tokens (`AppColors`, `AppStyles`, `AppTheme`), navigation paths (`AppRoutes`), assets (`AppAssets`), string keys (`AppStrings`), input validation (`AppValidator`), failure objects (`Failure`), and storage helpers (`SharedPreference`, `HiveCashing`).
- **`lib/core/widgets/`**: Reusable generic widgets (`CustomElevateBtn`, `CustomTextField`, `CustomMessageDialog`).

---

## 3. Feature Structure

Each feature inside `lib/feature/<feature_name>/` is self-contained and split into 3 Clean Architecture subdirectories:

```
lib/feature/<feature_name>/
├── data/
│   ├── datasources/
│   │   ├── contract/   # Abstract data source interfaces
│   │   └── impl/       # Remote & local data source implementations
│   ├── model/          # DTO response/request models (extends domain entities)
│   └── repo/           # Repository implementations (implements domain repo)
├── domain/
│   ├── entities/       # Pure domain data objects
│   ├── repo/           # Abstract repository contracts
│   └── usecase/        # Independent business logic use cases
└── ui/
    ├── viewmodel/      # Cubit and State classes
    └── views/          # Screen layouts and UI widgets
        └── widgets/    # Sub-widgets specific to this feature
```

---

## 4. Layer Responsibilities (Data / Domain / Presentation)

### Domain Layer (Business Core)
- **Pure Dart**: Free of Flutter framework dependencies and external library logic (except `dartz` for `Either` types).
- **Entities**: Simple classes holding core data properties.
- **Repository Interface**: `abstract class FeatureRepo` defining contract methods returning `Future<Either<Failure, Entity>>`.
- **Use Cases**: Encapsulate a single business operation. Annotated with `@injectable`. Consumes repository contract.

### Data Layer (Data Fetching & Mapping)
- **Data Models (DTOs)**: Inherit from Domain Entities (`class FeatureModel extends FeatureEntity`) and implement `fromJson` / `toJson`.
- **Data Sources**:
  - `contract/`: Defines interface returning `Future<Either<Failure, Model>>`.
  - `impl/`: Implements interface using `ApiManger`. Performs connectivity checks (`Connectivity`), parses JSON into models, handles HTTP status codes, and returns `Right(model)` or `Left(ServerFailure / NetworkFailure)`. Annotated with `@Injectable(as: FeatureDataSource)`.
- **Repository Implementation**: Implements `DomainRepo`, delegates data operations to `DataSources`, and returns domain results. Annotated with `@Injectable(as: FeatureRepo)`.

### Presentation / UI Layer (User Experience)
- **Cubits**: Extend `Cubit<FeatureState>`, manage state, hold text controllers/form keys, invoke use cases, and emit state transitions. Annotated with `@injectable`.
- **States**: Base abstract state class `FeatureState` with immutable subclass states (`Initial`, `Loading`, `Success`, `Failure`, and UI toggle states).
- **Views**: `StatelessWidget` or `StatefulWidget` screens using `BlocProvider`, `BlocBuilder`, `BlocListener`, and `BlocConsumer`. Obtains Cubit instances via dependency injection `getIt<FeatureCubit>()`.

---

## 5. State Management Conventions

- **State Management Library**: `flutter_bloc` (`Cubit`) for feature business flow; `provider` (`ChangeNotifier`) for simple global app configuration.
- **Cubit Naming**: `<Feature><Action>Cubit` (e.g., `LogInCubit`, `ListMovieCubit`).
- **State Naming Hierarchy**:
  - Abstract base state: `abstract class <Feature><Action>State {}`
  - Initial state: `class <Feature><Action>InitialState extends <Feature><Action>State {}`
  - Loading state: `class <Feature><Action>LoadingState extends <Feature><Action>State {}`
  - Success state: `class <Feature><Action>SuccessState extends <Feature><Action>State { final Entity entity; ... }`
  - Failure state: `class <Feature><Action>FailureState extends <Feature><Action>State { final Failure failure; ... }`
- **Cubit Instantiation in Views**:
  ```dart
  Widget build(BuildContext context) {
    MyCubit cubit = getIt<MyCubit>();
    return BlocProvider(
      create: (context) => cubit..loadData(),
      child: BlocListener<MyCubit, MyState>(
        listener: (context, state) {
          if (state is MyLoadingState) { /* Show loading dialog */ }
          else if (state is MyFailureState) { /* Show error dialog */ }
          else if (state is MySuccessState) { /* Process success & navigate */ }
        },
        child: Scaffold(...),
      ),
    );
  }
  ```
- **Global Logging**: `Bloc.observer = MyBlocObserver();` configured in `main.dart` for tracking state transitions.

---

## 6. Dependency Injection Conventions

- **Libraries**: `get_it` and `injectable`.
- **DI Entrypoint**: `lib/core/di/di.dart`:
  ```dart
  final getIt = GetIt.instance;
  @InjectableInit()
  void configureDependencies() => getIt.init();
  ```
- **Annotations**:
  - `@singleton`: Global singletons (e.g., `ApiManger`).
  - `@injectable`: Use cases, Cubits.
  - `@Injectable(as: AbstractContract)`: Implementations binding to interfaces (e.g., `@Injectable(as: AuthRepo) class AuthRepoImpl implements AuthRepo`).
- **Code Generation Command**:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

---

## 7. API and Networking Conventions

- **HTTP Client**: `Dio` wrapped inside `ApiManger` (`lib/core/api/api_manger.dart`) registered as `@singleton`.
- **Endpoints**: Defined as static constants in `EndPoints` (`lib/core/api/end_points.dart`).
- **Base URLs**: Centralized in `ApiConstants` (`lib/core/api/api_constants.dart`).
- **Network Request Execution**:
  - Check network connection using `Connectivity().checkConnectivity()` before performing API requests.
  - Return `Left(NetworkFailure(...))` if disconnected.
  - Evaluate status codes (`response.statusCode >= 200 && response.statusCode <= 300`).
  - Return `Right(Model)` on success, or `Left(ServerFailure(failureMessage: ...))` on API server error.

---

## 8. Repository and Data Source Conventions

- **Data Flow Pipeline**:
  `View -> Cubit -> UseCase -> Repository Interface (Domain) <- Repository Impl (Data) -> DataSource Contract -> DataSource Impl -> ApiManger`
- **Error Handling**: Method returns always wrapped in `Future<Either<Failure, T>>`.
- **Model / Entity Mapping**: Data Models extend Entities. JSON deserialization happens in `Model.fromJson()`.

---

## 9. Localization Conventions

- **Package**: `easy_localization`.
- **Translation File Paths**: `assets/translations/en.json`, `assets/translations/ar.json`.
- **String Keys**: Declared as static constants in `AppStrings` (`lib/core/utils/app_strings.dart`).
- **UI Translation Syntax**: `AppStrings.keyName.tr()`.
- **Supported Locales**: English (`en`) and Arabic (`ar`).
- **App Wrapper**: `EasyLocalization` initialized in `main.dart` surrounding root widget.

---

## 10. Reusable Widget Conventions

- **Global Core Widgets**: `lib/core/widgets/` (e.g., `CustomTextField`, `CustomElevateBtn`, `CustomMessageDialog`).
- **Feature-Specific Widgets**: `lib/feature/<feature_name>/ui/views/widgets/`.
- **Design Guidelines**:
  - Built as `StatelessWidget` wherever possible.
  - Use `AppColors`, `AppStyles`, and `AppStrings` constants for default values.
  - Support full customization via optional constructor properties (`backgroundColor`, `style`, `prefixIcon`, `validator`, `onPressed`).

---

## 11. Theme & Design Constants Conventions

- **Theme Data**: Defined in `AppTheme` (`lib/core/utils/app_theme.dart`). Uses dark theme as main app palette.
- **Color Palette**: `AppColors` (`lib/core/utils/app_colors.dart`) defines colors (`black`, `yellow`, `darkGreenGray`, `white`, `grey`, `green`, `red`).
- **Typography & Text Styles**: Defined in `AppStyles` (`lib/core/utils/app_styles.dart`) using `GoogleFonts.inter` with `flutter_screenutil` sizing (`.sp`).
- **Screen Responsiveness**: Uses `flutter_screenutil` initialized in `MyApp` (`designSize: Size(430, 932)`). All dimensions must use extension getters: `.w` (width), `.h` (height), `.sp` (font size), `.r` (radius).
- **Navigation Routes**: Declared as static constants in `AppRoutes` (`lib/core/utils/app_routes.dart`) and mapped in `main.dart`.
- **Input Validation**: Centralized static methods in `AppValidator` (`lib/core/utils/app_validator.dart`).

---

## 12. Naming Conventions

### File Naming
- **Format**: `snake_case.dart`.
- **Standard Suffixes**:
  - Views: `*_view.dart` or `*_views.dart`
  - Cubits: `*_cubit.dart`
  - States: `*_state.dart`
  - Data Sources: `*_data_source.dart` / `*_data_source_impl.dart`
  - Repositories: `*_repo.dart` / `*_repo_impl.dart`
  - Use Cases: `*_use_case.dart`
  - Models: `*_model.dart`
  - Entities: `*_entity.dart`

### Class & Symbol Naming
- **Classes**: `PascalCase` (e.g., `LogInCubit`, `AuthRepoImpl`, `CustomTextField`).
- **Variables & Methods**: `camelCase` (e.g., `emailController`, `isPassVisibilityOff`, `getData()`).
- **Text Styles**: `w[FontWeight]S[FontSize][Color]` (e.g., `w700S24White`, `w400S14Yellow`, `w600S20Black`).

---

## 13. Error Handling Conventions

- Functional error handling using `dartz` `Either<Failure, SuccessType>`.
- Core failure types in `lib/core/utils/failure.dart`:
  - `Failure`: Base error class with `failureMessage`.
  - `ServerFailure`: API & backend responses error.
  - `NetworkFailure`: Connectivity failure.
- In Presentation:
  ```dart
  either.fold(
    (failure) => emit(FeatureFailureState(failure: failure)),
    (data) => emit(FeatureSuccessState(data: data)),
  );
  ```
- UI error feedback shown via `CustomMessageDialog(message: state.failure.failureMessage, type: MessageType.error)` or `SnackBar`.

---

## 14. Package Usage Guidelines

| Package | Purpose & Usage Rule |
|---|---|
| `flutter_bloc` | State management (`Cubit`, `BlocProvider`, `BlocListener`, `BlocBuilder`) |
| `get_it` & `injectable` | Dependency Injection container & generator |
| `dio` | HTTP API request engine |
| `dartz` | Functional programming (`Either`, `Left`, `Right`) |
| `easy_localization` | App internationalization & translation |
| `flutter_screenutil` | Dynamic responsive design sizing (`.w`, `.h`, `.sp`, `.r`) |
| `google_fonts` | Typography system (`GoogleFonts.inter`) |
| `shared_preferences` | Persistence of primitive key-value data (`SharedPreference` utility) |
| `hive` & `hive_flutter` | High-performance local caching (`HiveCashing` utility) |
| `connectivity_plus` | Checking active network interface connection before API calls |
| `cached_network_image` | Image caching and web image loading |
| `shimmer` | Loading placeholder skeleton widgets |

---

## 15. How to Create a New Feature (Step-by-Step)

When adding a new feature (e.g., `watchlist`), follow this exact sequence:

1. **Create Directory Hierarchy**:
   ```
   lib/feature/watchlist/
   ├── data/
   │   ├── datasources/
   │   │   ├── contract/
   │   │   └── impl/
   │   ├── model/
   │   └── repo/
   ├── domain/
   │   ├── entities/
   │   ├── repo/
   │   └── usecase/
   └── ui/
       ├── viewmodel/
       └── views/
           └── widgets/
   ```
2. **Define Entity**: Create `domain/entities/watchlist_entity.dart`.
3. **Define Repository Contract**: Create `domain/repo/watchlist_repo.dart` returning `Future<Either<Failure, WatchlistEntity>>`.
4. **Create UseCase**: Create `domain/usecase/get_watchlist_use_case.dart` annotated with `@injectable`.
5. **Create Data Model**: Create `data/model/watchlist_model.dart` extending `WatchlistEntity` with `fromJson`/`toJson`.
6. **Create DataSource**:
   - Contract: `data/datasources/contract/watchlist_data_source.dart`.
   - Implementation: `data/datasources/impl/watchlist_data_source_impl.dart` annotated with `@Injectable(as: WatchlistDataSource)`.
7. **Create Repository Impl**: Create `data/repo/watchlist_repo_impl.dart` annotated with `@Injectable(as: WatchlistRepo)`.
8. **Create Viewmodel (Cubit & State)**:
   - State: `ui/viewmodel/watchlist_state.dart` with `Initial`, `Loading`, `Success`, `Failure` states.
   - Cubit: `ui/viewmodel/watchlist_cubit.dart` annotated with `@injectable`.
9. **Generate DI Bindings**: Run `flutter pub run build_runner build --delete-conflicting-outputs`.
10. **Create View**: Create `ui/views/watchlist_view.dart`, register route in `AppRoutes` and `main.dart`, and add string keys to `AppStrings`.

---

## 16. How Existing Code Should Be Modified

- **Preserve Clean Architecture**: Do NOT bypass Use Cases or call Data Sources directly from UI or Cubits.
- **Maintain Design System Tokens**: Use `AppColors`, `AppStyles`, and `AppStrings` instead of introducing raw inline styles or strings.
- **Extend Interfaces**: If adding methods to a feature, update the domain repo interface first, then the repository implementation, data source interface, data source implementation, usecase, and cubit.
- **Re-generate DI**: Run `build_runner` after adding/updating `@injectable` or `@singleton` annotations.

---

## 17. What AI Agents MUST Do

- **MUST** follow Clean Architecture directory structure (`data/`, `domain/`, `ui/`).
- **MUST** return `Future<Either<Failure, T>>` for all asynchronous repository and data source methods.
- **MUST** annotate all UseCases, Cubits, DataSources, and Repository Implementations with `@injectable` or `@Injectable(as: Interface)`.
- **MUST** use `flutter_screenutil` extension methods (`.w`, `.h`, `.sp`, `.r`) for all hardcoded widget dimensions.
- **MUST** use `AppStrings.keyName.tr()` for user-visible UI text.
- **MUST** use `AppColors` and `AppStyles` for widget styling.
- **MUST** execute `flutter pub run build_runner build --delete-conflicting-outputs` whenever DI dependencies change.

---

## 18. What AI Agents MUST Not Do

- **MUST NOT** make HTTP network calls (`Dio` / `http`) directly in Cubits or Views.
- **MUST NOT** hardcode raw strings, hex colors, font sizes, or asset paths inside UI widgets.
- **MUST NOT** import Data layer Models directly inside Presentation Views or Domain UseCases when Entities exist.
- **MUST NOT** manually edit `lib/core/di/di.config.dart` (always let `build_runner` generate it).
- **MUST NOT** mutate state variables directly inside Cubit without emitting new State instances.
- **MUST NOT** remove existing exception handling or connectivity checks from Data Source implementations.
