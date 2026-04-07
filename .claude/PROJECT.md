# おすすめお土産ガイド プロジェクト固有設定

> このファイルはプロジェクト固有の設定です。
> 新しいプロジェクトで .claude フォルダを使う際は、このファイルだけをプロジェクトに合わせて書き換えてください。
> rules/、skills/、agents/ はこのファイルを参照して動的に適用されます。

---

## プロジェクト概要

- **名前**: おすすめお土産ガイド
- **概要**: ユーザーの旅行先、好み、予算、渡す相手などの条件に応じて、おすすめのお土産を提案するアプリ
- **構成**: 単一リポジトリ
  - `lib/` - Flutter アプリ本体
  - `functions/` - Firebase Cloud Functions（TypeScript、必要に応じて利用）

## 使用技術スタック

| 領域         | 技術                                     |
| ------------ | ---------------------------------------- |
| モバイル/Web | Flutter (Dart 3)                         |
| バックエンド | Firebase Cloud Functions (TypeScript)    |
| データベース | Cloud Firestore                          |
| ストレージ   | Firebase Storage                         |
| 認証         | Firebase Authentication                  |
| 状態管理     | Riverpod + Hooks                         |
| コード生成   | Freezed, json_serializable, build_runner |
| ルーティング | go_router_builder                        |
| Flutter 管理 | FVM                                      |
| テスト       | flutter_test, mocktail, integration_test |

---

## アーキテクチャ

### アーキテクチャパターン

4層レイヤードアーキテクチャ（DDD ベース）

### ディレクトリ構成

```text
lib/
  domain/
    entities/          # Freezed エンティティ + Value Objects + Enhanced Enum
    repositories/      # Repository インターフェース (abstract interface class)
  infrastructure/
    mapper/            # Doc/DTO → Entity 変換 (Extension method)
    repositories/      # Repository 実装
  application/
    usecases/          # ビジネスロジック (Repository 組み合わせ)
  presentation/
    pages/             # 画面 (ページ単位ディレクトリ: page + provider + state + widget/)
    providers/         # グローバル状態 (Riverpod)
    widgets/           # 共通 Widget
    extensions/        # UI 拡張メソッド (DateTime 表示、Enum → Color 等)
    routing/           # GoRouter + go_router_builder
    theme/             # ThemeExtension (AppColors, AppTextStyles)
  util/                # ロガー、共通例外クラス
```

### 依存方向ルール

```text
Domain ← Infrastructure ← Application ← Presentation
```

- Domain 層は外部パッケージ（Firebase 等）に依存しない
- 上位層は下位層に依存できる（Presentation → Application → Domain）
- Infrastructure は Domain に依存（依存性逆転の原則）
- Common の ValueObject（enum）は例外的に Domain から依存可能

---

## 実装パターン

### Entity パターン (Freezed)

- `@freezed abstract class X with _$X` 形式（`class` ではなく `abstract class`）
- メソッド追加時は `const X._()` プライベートコンストラクタが必要
- ドメイン固有ファクトリメソッド、static 定数、computed プロパティを持てる
- `@Default` でデフォルト値を定義

```dart
@freezed
abstract class Souvenir with _$Souvenir {
  const factory Souvenir({
    required String id,
    required String name,
    required SouvenirCategory category,
    @Default(<String>[]) List<String> tags,
    required DateTime createdAt,
  }) = _Souvenir;

  const Souvenir._();
  bool get isPopular => tags.contains('popular');
}
```

**Value Object**: 同じ Freezed 形式。ID を持たない小さなデータ構造。

**ページ状態**: 複数の非同期データを1つの Freezed クラスに集約。

```dart
@freezed
abstract class RecommendationPageState with _$RecommendationPageState {
  const factory RecommendationPageState({
    required UserProfile? currentUser,
    required List<Souvenir> souvenirs,
    required int unreadCount,
  }) = _RecommendationPageState;
}
```

### Enhanced Enum パターン

- `value` フィールド + `fromString` ファクトリメソッドを持つ
- JSON 変換には `JsonConverter` を実装（Freezed 連携）
- UI 表示用 `label` フィールド、ドメインロジック用メソッドを持てる

```dart
enum SouvenirCategory {
  sweets(value: 'sweets'),
  craft(value: 'craft');

  const SouvenirCategory({required this.value});
  final String value;

  static SouvenirCategory fromString(String value) {
    return SouvenirCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid SouvenirCategory: $value'),
    );
  }
}

class SouvenirCategoryConverter
    implements JsonConverter<SouvenirCategory, String> {
  const SouvenirCategoryConverter();

  @override
  SouvenirCategory fromJson(String json) =>
      SouvenirCategory.fromString(json);

  @override
  String toJson(SouvenirCategory category) => category.value;
}
```

### Repository パターン

- インターフェース: `abstract interface class`（Domain 層）
- 実装: Infrastructure 層で外部依存を注入
- Provider で DI（Provider 定義は Infrastructure 層）

```dart
// Domain 層: インターフェース
abstract interface class SouvenirRepository {
  Future<Souvenir> getById(String id);
  Future<void> update(Souvenir souvenir);
}

// Infrastructure 層: 実装 + Provider
final souvenirRepositoryProvider = Provider<SouvenirRepository>((ref) {
  return SouvenirRepositoryImpl(ref.watch(dataSourceProvider));
});

class SouvenirRepositoryImpl implements SouvenirRepository {
  SouvenirRepositoryImpl(this._dataSource);
  final DataSource _dataSource;
  // 外部エラーはドメイン例外(AppException)に変換して throw
}
```

### Mapper パターン (Extension method)

Doc/DTO → Entity 変換は Extension method で定義。

```dart
extension SouvenirDocMapper on SouvenirDoc {
  Souvenir toEntity(String id) => Souvenir(id: id, name: name, ...);
  static SouvenirDoc fromEntity(Souvenir souvenir) => SouvenirDoc(name: souvenir.name, ...);
}
```

### Usecase パターン

Provider で Repository を注入。複数 Repository を組み合わせたビジネスロジック。

```dart
@riverpod
RecommendationUsecases recommendationUsecases(Ref ref) =>
    RecommendationUsecases(
      repository: ref.watch(souvenirRepositoryProvider),
    );

class RecommendationUsecases {
  RecommendationUsecases({required SouvenirRepository repository})
    : _repository = repository;
  final SouvenirRepository _repository;

  Future<void> saveFavorite(Souvenir souvenir) async {
    if (souvenir.name.isEmpty) throw AppException(/* ... */);
    await _repository.update(souvenir);
  }
}
```

### 状態管理パターン (Riverpod)

| パターン       | アノテーション                       | 用途                       |
| -------------- | ------------------------------------ | -------------------------- |
| グローバル状態 | `@Riverpod(keepAlive: true)` + class | 認証ユーザー、キャッシュ等 |
| ページ状態     | `@riverpod` 関数                     | 複数データ集約             |
| DI             | `Provider<Interface>`                | Repository/Usecase 注入    |

- 状態更新は `copyWith` + `AsyncData` で不変更新
- `Future.wait` + Record 分割代入で並列取得
- 楽観的更新: UI 即反映 → 非同期処理 → エラー時ロールバック
- データ更新後のリスト再取得: `ref.invalidate(provider)`

```dart
// グローバル状態
@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  Future<UserProfile?> build() async { ... }
}

// ページ状態
@riverpod
Future<RecommendationPageState> recommendationPage(Ref ref) async {
  final [user as UserProfile?, souvenirs as List<Souvenir>] =
      await Future.wait<Object?>([userFuture, souvenirFuture]);
  return RecommendationPageState(
    currentUser: user,
    souvenirs: souvenirs,
    unreadCount: 0,
  );
}
```

### Widget パターン

- `HookConsumerWidget` を基本クラスとして使用
- ページは `static const name` / `static const path` を持つ
- AsyncValue の `when` で loading/error/data を分岐
- データ表示は `_PrivateWidget` に委譲（メソッド Widget `Widget _buildX()` は禁止）
- **ConsumerWidget**: AsyncValue 処理、Provider の監視のみ
- **HookConsumerWidget**: Ephemeral State（フォーム入力など）が必要な場合

```dart
class RecommendationPage extends HookConsumerWidget {
  const RecommendationPage({super.key});
  static const name = 'recommendation';
  static const path = '/recommendation';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(recommendationPageProvider);
    return asyncData.when(
      loading: () => const LoadingWidget(),
      error: (e, s) => ErrorWidget(
        onRetry: () => ref.refresh(recommendationPageProvider),
      ),
      data: (state) => _RecommendationWidget(souvenirs: state.souvenirs),
    );
  }
}
```

### フォームパターン (Hooks)

| Hook                                    | 用途                                   |
| --------------------------------------- | -------------------------------------- |
| `useTextEditingController`              | テキスト入力管理                       |
| `useState`                              | ローカル状態（ボタン有効/無効等）      |
| `useMemoized(GlobalKey<FormState>.new)` | FormKey 生成                           |
| `useEffect`                             | リスナー登録/解除（return で cleanup） |

### ルーティング (go_router_builder)

- `@TypedGoRoute<XxxRoute>` でルート定義
- ページに `static const path` / `static const name` を持つ
- `XxxRoute(param: value).go(context)` で型安全遷移
- `@TypedShellRoute` でボトムナビゲーション
- 認証リダイレクト: `GoRouter.redirect` + `ChangeNotifier`

### テーマ (ThemeExtension)

- `ThemeExtension<AppColors>` でカスタムカラー/テキストスタイル定義
- `Theme.of(context).extension<AppColors>()` でアクセス
- Extension メソッドでショートカット: `context.appColors`

### エラーハンドリング

- `AppException` 基底クラス + `ErrorDetail` インターフェースで構造化
- ドメイン固有例外は enum で `ErrorDetail` を実装
- Repository 層で外部エラーをドメイン例外に変換
- Presentation 層で View 用メッセージにマッピング

### 一覧表示パターン

- 初回取得後、View 側でフィルタリングや並び替えを行う
- StateNotifier でページネーション、ソート、お気に入り状態を管理する

---

## 命名規則

| 要素               | 規則                   | 例                                  |
| ------------------ | ---------------------- | ----------------------------------- |
| Entity             | `XxxEntity`            | `SouvenirEntity`                    |
| ValueObject        | `XxxId`, `XxxName`     | `SouvenirId`                        |
| Repository（抽象） | `XxxRepository`        | `SouvenirRepository`                |
| Repository（実装） | `XxxRepositoryImpl`    | `SouvenirRepositoryImpl`            |
| Usecase            | `XxxUsecases`          | `RecommendationUsecases`            |
| Notifier           | `XxxNotifier`          | `RecommendationNotifier`            |
| Page               | `XxxPage`              | `SouvenirRecommendationPage`        |
| ディレクトリ       | `snake_case/`          | `souvenir_recommendation/`          |
| Page ファイル      | `snake_case_page.dart` | `souvenir_recommendation_page.dart` |
| GoRouter path      | `kebab-case`           | `/souvenir-recommendation`          |
| GoRouter name      | `camelCase`            | `souvenirRecommendation`            |

---

## テスト戦略

### レイヤー別テスト方針

| レイヤー      | テスト対象                   | ツール                       |
| ------------- | ---------------------------- | ---------------------------- |
| Entity        | ファクトリ、computed、ルール | flutter_test                 |
| Enhanced Enum | fromString 正常系/異常系     | flutter_test                 |
| Repository    | CRUD 操作、エラー変換        | mocktail                     |
| Usecase       | ビジネスロジック             | mocktail                     |
| Widget        | 表示とインタラクション       | flutter_test + ProviderScope |
| Riverpod      | Provider 動作、状態遷移      | ProviderContainer            |
| 統合          | ユーザーフロー全体           | integration_test             |

### テスト実行コマンド

```bash
fvm flutter test                        # 全テスト
fvm flutter test --coverage             # カバレッジ付き
fvm flutter test test/path/to_test.dart # 特定テスト
fvm flutter test integration_test/      # 統合テスト
```

---

## ビルド・テストコマンド

```bash
# FVM セットアップ
fvm install
fvm use stable

# 依存関係の取得
fvm flutter pub get

# コード生成
fvm dart run build_runner build --delete-conflicting-outputs

# 静的解析
fvm dart analyze

# テスト実行
fvm flutter test

# テストカバレッジ
fvm flutter test --coverage

# フォーマット
fvm dart format .

# Web ビルド
fvm flutter build web

# iOS ビルド
fvm flutter build ios

# Android ビルド
fvm flutter build apk

# Firebase Functions デプロイ
cd functions && npm run deploy
```

---

## Firestore スキーマ

詳細は `docs/02_infrastructure/01_firebase_schema.md` を参照。

主要コレクション:

- `users` - ユーザー情報、嗜好、アレルギー、予算帯
- `souvenirs` - お土産マスタ、価格帯、地域、カテゴリ、画像情報
- `regions` - 地域情報、空港・駅・観光地との関連
- `recommendation_histories` - 提案履歴、閲覧履歴、選択条件
- `favorites` - お気に入り登録情報

---

## 設計ドキュメント

| ドキュメント               | 内容                       |
| -------------------------- | -------------------------- |
| `docs/00_overview/`        | アプリ概要                 |
| `docs/01_architecture/`    | アーキテクチャ設計         |
| `docs/02_infrastructure/`  | Firebase スキーマ・Storage |
| `docs/03_coding_rule/`     | コーディングルール         |
| `docs/04_detailed_design/` | 詳細設計                   |
| `docs/05_view_specs/`      | 画面仕様                   |
| `docs/06_e2e_test_specs/`  | E2Eテスト仕様              |

---

## セキュリティ要件

- Firebase Authentication によるユーザー認証を必須とする
- Firestore Security Rules で適切なアクセス制御を設定
- Storage Rules で画像や添付ファイルのアクセスを制限する
- API キーをクライアントコードにハードコードしない
- 環境変数は `--dart-define` または Firebase Remote Config で管理する

---

## アーキテクチャルール

- Entity は必ず Freezed で定義する（イミュータブル）
- Repository は抽象クラスを domain 層に、実装を infrastructure 層に配置
- 状態管理は Riverpod AsyncNotifier を使用
- ナビゲーションは go_router_builder を使用（型安全ルーティング）
- Enhanced Enum を活用する
- `!` 演算子の使用は原則禁止（null チェックで対応）
- Widget はメソッドではなくクラスで分割（`Widget _buildX()` は禁止）
- Widget は可能な限り `const` で構築
- `final` を積極的に使用
- 1つの `build` は 50 行以内を目安

---

## 外部サービス連携

- **Firebase**: Authentication, Firestore, Storage, Cloud Functions, Cloud Messaging
