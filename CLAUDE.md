# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`ts_admin` — Flutter admin app for a transportation/logistics system (chat, clock-in/out, HR, inspections, invoices, shipments, assets/shop management, file storage, user management). Flutter 3.41.x, Dart SDK `>=3.0.0 <4.0.0`. Android applicationId `com.transport_system.ts_admin` (minSdk 26, targetSdk 36).

## Commands

```bash
flutter pub get                      # install deps (run after touching pubspec)
flutter run                          # run on attached device (VSCode launch config: "ts_admin")
flutter analyze                      # static analysis (flutter_lints + lint package)
flutter build apk --release          # release APK (signed via android/key.properties)
flutter build appbundle --release    # release AAB
dart run build_runner build --delete-conflicting-outputs   # regenerate flutter_gen assets
flutter test                         # run all tests
flutter test test/<name>_test.dart   # run a single test file
```

Test coverage is minimal — `test/` holds only a handful of widget-layout smoke tests and one storage-helper test. Most of the app has no tests; don't assume coverage exists for code you change.

The suite is green (256 cases across 4 files) — a failure is yours. `test/realtime_configuration_storage_helper_test.dart` used to fail on Windows and no longer does; don't "fix" it by restoring the teardown it deliberately omits. get_storage 2.1.1 calls `getApplicationDocumentsDirectory()` on **every** file op even when constructed with an explicit path, and `_madeBackup()` fires that untracked, so a write always lands after the awaited future resolves. Removing the `path_provider` mock (or deleting the temp dir) in `tearDownAll` makes that straggler throw *after* the test completes; the file also stays open, so Windows can't delete the directory anyway.

Prefer the **dart MCP tools** (`analyze_files`, `hot_reload`, `run_tests`, etc.) over shell `flutter` commands when available — they integrate with the running IDE/app.

A PostToolUse hook (`.claude/hooks/format-dart.ps1`) formats + analyzes after every Dart edit. When several edits land in one batch, the hook fires between them and reports *transient* errors from the half-applied state — don't chase those; run `analyze_files` once after the whole batch and trust that result.

## Environment / API switching

`lib/app/core/network/connection/environments.dart` defines `dev` / `staging` / `production` hosts. The active environment is hardcoded in `api_constants.dart` via `ApiConstants._env` (check its current value — it gets flipped between `dev`/`staging` during development). Base URL is `https://<host>/api/v2/`. **To change environments, edit `_env`** — there are no build flavors. All endpoint paths are string constants in `ApiConstants`.

## Architecture

### Two DI systems (don't mix them up)

- **GetIt** (`sl` global in `lib/app/services/injection_service.dart`) — the **data/domain** service locator. Registers network, repositories, data sources, and use cases as lazy singletons. Everything is wired in `init()` → `initNetwork/initRepositories/initDataSources/initUsecases/initExtra`.
- **GetX** (`Get.put`, `Bindings`) — the **presentation** layer: controllers, routing, reactive state (`.obs`/`Obx`), and per-route DI via `*_binding.dart`.

Controllers pull use cases from GetIt: `final usecase = sl<SomeUsecase>();`.

### ⚠️ GetX wiring is invisible to the import graph

A controller registered with `Get.put` in one module is reachable from any other module by `Get.find`/`Get.isRegistered` with **no import between them**. So "which files import this?" does not answer "is this alive?" — always grep the class name too before concluding something is dead or safe to change.

Live example: `AnnoucmentsController` is created by `ClockInOutController` (clock-in-out module), and resolved independently by the announcements listing screen and by the FCM handler in `core/widgets/local_notification.dart`. Nothing imports across those boundaries. Same shape for `AuthController`, `ThemeController`, and `MenuPageController`.

Corollary: when several surfaces must share one instance, register it **untagged** and let all consumers `Get.find` it. A tag only earns its place when two instances of the same type genuinely coexist; otherwise it is a string that must match across files with no compile-time check — a typo silently produces a second instance instead of an error.

### Clean Architecture per module

Every feature under `lib/app/modules/<module>/` follows:

```text
data/        datasources (I<X>RemoteDataSource + Impl, call DioClient), models (fromJson), repositories (impl)
domain/      enitities (sic — the folder is misspelled repo-wide, keep it), repositories (abstract interfaces), usecases (one class per operation, extends BaseUseCase)
presentation/<screen>/{bindings,controllers,views}   one folder per screen
```

Exception: four **hub screens** sit loose in `presentation/` root as plain `StatelessWidget`s with no route, binding, or controller — `inspection_management.dart`, `invoice_management.dart`, `shop_management.dart`, `leave_management/presentation/employee_management.dart`. They are tile grids that only navigate onward, pushed as widgets (`Get.to(() => const XManagement())`) from the menu or safety screen. `get_cli create page` has no template for a routeless, stateless screen, so these are hand-written on purpose — don't "fix" them into the folder structure or give them empty controllers.

Data flow: **View → Controller (GetX) → UseCase → Repository(interface) → RemoteDataSource → DioClient**.

The newest full-pattern example is `shipment/presentation/additional_pay` (list + pagination + search + bottom-sheet actions) with its chain through `get_additional_pays_usecase.dart` → `shipment_repository.dart` → `shipment_remote_datasource.dart`.

### ⚠️ Inverted `Either` convention (most important gotcha)

This codebase uses `dartz` `Either<Type, Failure>` where **Left = success, Right = Failure** — the *opposite* of the usual dartz convention. `DioClient.makeRequest` returns `Left(converter(data))` on success and `Right(ServerFailure(...))` on error. Consume it as:

```dart
response.fold(
  (data)    { /* SUCCESS — Left */ },
  (failure) { /* FAILURE — Right, use failure.message */ },
);
```

Use cases and repositories pass this `Either` straight through unchanged.

### Network layer

`DioClient` (singleton) exposes `makeRequest<T>({url, method, data, converter, ...})` over a single shared `Dio` instance (`DIO_CLIENT`, built once — connection pool reuse). Each data source supplies a `converter` that maps raw JSON to a model/bool. Static headers (`Accept`, `X-Platform`) live in `BaseOptions`; header names/values are consts in `ApiConstants` (`//! headers` block). Auth: the interceptor attaches `Authorization: Bearer <token>` from GetStorage (`AuthenticationPrefKeys.token`) except for `_publicPaths` (login, verifyOtp — exact match on `options.path`, so call sites must pass those constants unmodified). Responses pass through `responseHandler` (`http_handler.dart`); non-2xx throws `DioException`. Prefer `queryParams:` for GET params — dio puts `data:` in the request body even on GET; several older data sources still pass `data:` on GET and rely on the backend reading the body.

### App startup (`main.dart`)

`runZonedGuarded` → `initLocalDb()` (GetStorage) → `di.init()` → `di.initFirebase()` → Crashlytics error hooks → `runApp(Application)`. `Application` wraps `GetMaterialApp` in `ScreenUtilInit` (design size 375×812). Routes come from `AppPages.routes`; theme is light/dark switched by `ThemeController` (`Obx`).

### Storage & realtime

- **GetStorage** — key-value app/user/settings prefs (keys in `core/values/*_preferences_keys.dart`).
- **sqflite** — chat persistence: `MessagesDatabase`, `ConversationsDatabase`, `GroupConversationsDatabase`, `MessagesNotificationsDatabase` (initialized in `initDatabases`).
- **flutter_secure_storage** — sensitive values.
- **Pusher** (`dart_pusher_channels` via `PusherManager`) — chat sockets, (re)initialized in `initPusherManager`.
- **Firebase** — FCM (foreground notifications via `LocalNotification`, background via `_firebaseMessagingBackgroundHandler`), Auth, Crashlytics, Realtime Database. Config in generated `firebase_options.dart`.

### Routing

`lib/app/routes/app_pages.dart` (`GetPage` list with bindings) + `app_routes.dart` (`Routes` string constants, `part of app_pages.dart`). Navigate with `Get.toNamed(Routes.x)`.

Navigation is **always** through `Routes.*` constants — there is not a single `Get.toNamed('literal')` in the repo, so grepping a constant finds every caller. FCM navigates only to `Routes.MAIN_SCREEN` and `Routes.CHAT_DETAIL` (`core/widgets/local_notification.dart`).

**Registered ≠ reachable.** Many `GetPage` entries are never navigated to, because their view is mounted directly as a widget instead — MainScreen tabs (`main_screen_controller.dart`), the conversations `TabBarView`, and `Get.to(() => SomeView())` call sites. Before treating a route as live, grep `Routes.<NAME>` for a real navigation; before deleting one, note that its **binding usually stays alive** — `MainScreenBinding` and `ConversationsBinding` call the per-screen bindings directly.

### Shared code (`lib/app/core/`)

`widgets/` (reusable UI), `network/`, `helpers/` (file managers, pusher, sound/recording, location tracking), `resources/themes/`, `utils/extensions.dart`, `enum/`, `values/`. Prefer reusing these over re-implementing.

Widgets worth knowing before you build a screen — these are the ones most often re-implemented by accident:

- Screen header (brand red gradient) → `AppRedHeader`, with `GlassControl` for the back/action chips
- Empty or error state → `EmptyStateView` (optional `actionLabel`/`onAction` renders a retry button); `NoDataView` and `TasksEmptyState` are older variants still in use
- Inline field-level failure → `InlineErrorRetry`
- Loading skeleton → `SkeletonBones` + `SkeletonBone` (`core/widgets/skeleton.dart`); `ShimmerSliverList` is the sliver wrapper over them
- Frosted panel on the red header → `GlassPanel` (free-form: radius, blur, optional `onTap`); `GlassControl` is the fixed 42pt icon-button flavour
- Primary action button → `MainAppButton` (owns its loading state, disables itself while loading)
- Text field → `RoundedInputField`

### ⚠️ Shimmer masks its whole subtree

`Shimmer` (package `shimmer`) paints via a `ShaderMaskLayer` with **`BlendMode.srcIn`** — every opaque pixel under it is replaced by the sweep. So card chrome placed *inside* a shimmer is repainted as the gradient and the skeleton collapses into one flat rectangle with no anatomy.

`srcIn` preserves the destination's *alpha*, which is why this bug hides: a dark-mode card at 4.5% alpha survives and shows its bones, while the same code in light mode (opaque white fill) flattens. It reads as "works in dark, broken in light".

The rule: **chrome outside, bones inside.**

```dart
Container(                                  // real fill / border / shadow
  decoration: SomeCard.decoration(context),
  child: SkeletonBones(                     // only bones get masked
    child: Column(children: [SkeletonBone(width: 120, height: 12), ...]),
  ),
)
```

Skeletons take their silhouette from the real card via a `static BoxDecoration decoration(BuildContext)` on the card widget (see `AdditionalPayRequestCard`, `ShipmentListItem`, `ShipmentSectionCard`) so a restyle can't silently desync them. ~57 files still call `Shimmer.fromColors` directly and many have the vulnerable shape — check before copying one as a template.

The same contract covers **layout metrics**, not just the fill. Any number the skeleton must match — icon-slot width, gutter, a fixed column — goes next to `decoration` as a public `static const double` and is read by both (`AdditionalPayRequestCard.glyphSlot/glyphGutter/moneyColumnWidth`; the house precedent is `DashboardStatsStrip.height`, `DashboardHeroSliver.collapseTravel`). Retyping the number in the skeleton with a `// matches the card` comment is how they drift — and the drift is invisible, because the card scales with ScreenUtil (`22.w`) and a hand-copied bone usually doesn't (`height: 22`), so the two only diverge off the 375pt design width.

**A skeleton that draws conditional chrome needs the same input the card branches on.** `AdditionalPayLoadingView` takes the loading `status` because only pending rows render an action row; drawing those bones on a decided tab collapses every card ~52px on arrival. Express the rule once on the domain type (`AdditionalPayStatus.hasActionRow`) and have card and skeleton both read it, rather than spelling `== pending` in each.

`.tr` for translation comes from **GetX**, not from `core/utils/extensions.dart` — import `package:get/get.dart` to use it.

### Colors / design tokens

Two homes, nothing else — **do not create module-local style/token files** (two have been built and torn down by owner request; the second was `DashboardTheme`):

- **Raw constants** → `resources/themes/light/light_colors.dart` (`AppColorsLight`) and `dark/dark_colors.dart` (`AppColorsDark`). `AppColorsLight.mainColor` is the brand red and is used in dark mode too — `theme.primaryColor` is near-black in dark, so never use it for red accents.
- **Theme-resolved getters** → `core/utils/theme_extensions.dart` (`context.surfaceColor`, `context.mutedTextColor`, `context.flatCardColor`, …). Despite the extension's name it also vends non-colors that vary by brightness: `context.cardShadow`, `context.accentGlow(t)`, `context.skeletonBaseColor`/`skeletonHighlightColor`. Add new ones there.

**On-hero colors are the exception.** Anything painted on the `AppRedHeader` gradient sits on a surface that reads dark in *both* app themes, so it must NOT resolve by brightness — `context.*` would invert it. Those are always-light raw constants: `AppColorsLight.onHeroTextSecondary`, `onHeroTextMuted`, `onHeroGlass`, `onHeroGlassBorder`, `onHeroOnline`, `onHeroAttention`. The gradient itself is `AppRedHeader.gradient` (const per brightness, sweep direction included) — never re-declare it.

**Type sizes are not tokens.** `theme_extensions.dart` is for values that *resolve from brightness*; a font size doesn't, so don't add `context.cardTitleSize`-style getters there. The app-wide ramp is `Light/DarkTextTheme` (stock Material, unscaled). A dense card that needs rungs the ramp lacks (e.g. between 10 and 12) declares them inline with `.sp` — that's the house style, and it stays local until a second screen needs the same ramp.

**`Get.isDarkMode` vs `context.isDark`.** `Get.isDarkMode` is not an inherited-widget read, so a widget using it does *not* rebuild when the theme is toggled — it goes stale until something else invalidates it. Prefer `context.isDark` inside `build`. Reserve `Get.isDarkMode` for places with no context (and note that a `SliverPersistentHeaderDelegate` needs brightness as a *field* compared in `shouldRebuild`, since `shouldRebuild` gates whether `build` runs at all).

## Conventions

- **State:** GetX reactive (`RxBool`, `RxList`, `Rxn<T>`, `.obs`) read inside `Obx(() => ...)`. Loading/error/data flags are explicit `RxBool`s per fetch (see any controller's `isLoadingX` / `errorWhileLoadingX`). Entities may carry `Rx` fields for state the admin mutates locally (e.g. `AdditionalPayEntity.status`).
- **Fetch methods** open with an in-flight guard (`if (isLoadingX.value) return;`). Screens can trigger the same fetch from several places at once — pull-to-refresh, a retry button, a binding re-entry, an FCM push — and without the guard they stack duplicate requests. Set the error flag in **both** the `fold` failure branch and the `catch`, and clear it at the start of each attempt. Don't `list.clear()` before a refetch when another screen shares that list; `isLoading` already drives the skeleton, and clearing blanks the other surface.
- **Models mirror the API JSON shape** — nested JSON objects become nested entity classes (with matching `*Model extends *Entity` + `fromJson` per block), never flattened. Main class first in the file, nested classes below it. Parse money as `(json[x] as num?)?.toDouble()` (samples without decimals otherwise bake in `int`), dates as `DateTime.tryParse(x)?.toLocal()`. Entity exposes convenience getters (`driverName => driver?.name`) so UI code doesn't chain nested blocks.
- **Pagination:** query params `page` / `per_page`; `BaseResponse.hasMore` drives load-more. When an envelope has no `has_more`, derive it in the datasource converter (full page ⇒ more), not in the controller.
- **List envelopes:** parse via `BaseResponse.listFromJson(response, itemFromJson)` — it maps `message`/`code`/`has_more` and turns null/absent `data` into an empty list. Never hand-roll `List.from(json.map(...))` in a converter; a filtered-out result set returns `data: null` and bare `.map`/`as List` crashes.
- **Pull-to-refresh (the ONE pattern):** `SmartRefresher`'s child must BE the scrollable — always a `CustomScrollView`, with every loading/empty/error/data branch inside it as slivers via `Obx` (`SliverFillRemaining(hasScrollBody: false)` for full-screen states, `SliverList`/`SliverPadding` for content). Never put a wrapper between `SmartRefresher` and the scrollable — `Obx(() => ListView…)`, `SlidableAutoCloseBehavior(child: ListView…)`, or a widget whose build returns a scrollable all silently kill the pull gesture (the inner scrollable eats the drag). `SlidableAutoCloseBehavior` goes **above** `SmartRefresher`; pagination attaches a `ScrollController` to the `CustomScrollView` with an `extentAfter` prefetch listener in the controller — never fire load-more from `itemBuilder`.
- **Money display:** `'${value}'.decimalPattern().dollar()` from `core/utils/extensions.dart` → `$14,862.74`. Per-entity UI helpers (captions, labels) live in `core/utils/<feature>_extensions.dart`.
- **New module checklist:** add abstract repo + impl, datasource interface + impl, use case(s), then register all three in `injection_service.dart` (`initRepositories`, `initDataSources`, `initUsecases`); add the screen's `Binding`; register the route in `app_pages.dart` + `app_routes.dart`.
- **Form input formatters** are not exported by `material.dart` — import `package:flutter/services.dart` for `FilteringTextInputFormatter` / `LengthLimitingTextInputFormatter`.
- **`const` widgets are mostly unreachable here, by design.** ScreenUtil's `.w/.h/.sp/.r` are runtime getters on `num`, as are `context.*` tokens, so any widget touching either can't be `const` — don't read a screen's missing `const` as an oversight. Give every widget class a `const` constructor anyway, keep `const` on literal-only values (`Duration`, `Offset`, `fontFeatures`, `SizedBox.shrink()`), and get the real rebuild savings structurally instead: pass a prebuilt subtree to `TweenAnimationBuilder`/`AnimatedBuilder` via `child:` so the animation ticks without rebuilding it, and hoist a repeated widget out of an `itemBuilder` when every row is identical (see `AdditionalPayLoadingView`).
- **`InputDecoration.errorText` shares its row with the `maxLength` counter** and defaults to one line, so a sentence-length message ellipsizes mid-word next to `0/500`. Set `errorMaxLines: 2` on any field that has both.
- **⚠️ Duplicate widget basenames across modules.** Many component names exist several times over (`category_dropdown_widget.dart` ×4, `filter_by_role_widget.dart`, `date_picker_widget.dart`, `client_dropdown_widget.dart`, `install_device_bottom_sheet.dart` ×2 each). Call sites import them **relatively** (`import 'components/search_widget.dart';`), so a grep hit on a basename tells you nothing about which copy is used — resolve the relative path from the importing file before assuming. This is how dead near-duplicates accumulate: editing the wrong copy changes nothing at runtime. When adding a component, check whether a sibling module already has one worth promoting to `core/widgets/` instead.
- **Vendored package:** `pro_image_editor/` is a local path dependency (`pubspec.yaml`) that has been modified in-tree — edit it directly, don't expect upstream parity. `flutter_callkit_incoming/` holds native calling code.
- **Versioning / release:** bump `version:` in `pubspec.yaml` (`X.Y.Z+build`). Commit messages for releases follow `vX.Y.Z+build - live <note>`. A `flutter-apk-rename` skill is available for naming release APKs.
