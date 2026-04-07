# セットアップガイド：おすすめお土産ガイド

このガイドは、おすすめお土産CRUD機能アプリをセットアップするための手順です。

## 前提条件

- Flutter SDK (FVM 推奨)
- Firebase プロジェクト
- Flutter/Dart の基本的な知識

## セットアップ手順

### 1. Firebase プロジェクトの作成

1. [Firebase Console](https://console.firebase.google.com) にアクセス
2. 新規プロジェクトを作成
3. プロジェクト名：`souvenir-guide` など
4. Google Analytics は任意

### 2. Firebase 認証の設定

1. **認証** > **ログイン方法** を開く
2. **メール/パスワード** を有効化
3. **匿名ログイン** も有効化（テスト用）

### 3. Firestore データベースの作成

1. **Firestore Database** > **データベースを作成**
2. **ロケーション**: `asia-northeast1` （日本）
3. **セキュリティルール**: `PRODUCTION モード` を選択
4. 以下の Security Rules を設定:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      match /my_souvenirs/{souvenirId} {
        allow read, write: if request.auth.uid == userId;
        allow create: if request.resource.data.name is string
          && request.resource.data.name.size() > 0
          && request.resource.data.price is number
          && request.resource.data.price > 0;
        allow update: if request.resource.data.name is string
          && request.resource.data.price is number
          && request.resource.data.price > 0;
      }
    }
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

（詳細は `firestore.rules` ファイルを参照）

### 4. Firebase Storage の設定

1. **Storage** > **ルールを設定**
2. 以下のルールを設定:

```storage
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read: if request.auth.uid == userId;
      allow write: if request.auth.uid == userId
        && request.resource.size < 5 * 1024 * 1024
        && request.resource.contentType.matches('image/.*');
    }
    match /{allPaths=**} {
      allow read, write: if false;
    }
  }
}
```

（詳細は `storage.rules` ファイルを参照）

### 5. Firebase プロジェクト設定の取得

1. **プロジェクト設定** > **アプリを追加**
2. プラットフォームごとに追加:
   - **iOS**: `com.example.test2`
   - **Android**: `com.example.test2`
   - **Web**: `test2`

3. 設定ファイルをダウンロード

#### iOS の場合
- `GoogleService-Info.plist` をダウンロード
- `ios/Runner` に配置

#### Android の場合
- `google-services.json` をダウンロード
- `android/app` に配置

#### Web の場合
- Firebase Config をコピー
- `lib/firebase_options.dart` に設定

### 6. firebase_options.dart の更新

Firebase Console から取得した設定値で、`lib/firebase_options.dart` を以下のように更新:

```dart
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // プラットフォーム判定
    if (kIsWeb) {
      return web;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    // ... その他のプラットフォーム
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'your-project-id',
    authDomain: 'your-project-id.firebaseapp.com',
    storageBucket: 'your-project-id.appspot.com',
  );
  
  // ... その他のプラットフォーム設定
}
```

### 7. mySouvenirListProvider の Firestore インスタンス注入

`lib/presentation/pages/my_souvenir_list/my_souvenir_list_provider.dart` を以下のように修正:

```dart
final mySouvenirListProvider = StateNotifierProvider.autoDispose<
    MySouvenirListNotifier,
    MySouvenirListState>((ref) {
  final firestore = FirebaseFirestore.instance; // 実際のインスタンス
  final repository = MySouvenirRepositoryImpl(firestore);
  return MySouvenirListNotifier(
    repository: repository,
    userId: 'test-user-id', // TODO: Firebase Auth から取得
  );
});
```

### 8. パッケージのインストール

```bash
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
```

### 9. テストの実行

```bash
# ユニットテスト
fvm flutter test --coverage

# 統合テスト（Firebase Emulator 推奨）
fvm flutter test integration_test/my_souvenir_crud_test.dart
```

### 10. アプリの起動

```bash
fvm flutter run
```

## Firebase Emulator の使用（推奨）

開発時は Firebase Emulator を使用してローカルテストを行うことを推奨します。

```bash
# Firebase CLI をインストール
npm install -g firebase-tools

# Emulator を起動
firebase emulators:start

# アプリを起動（Emulator に接続）
fvm flutter run --dart-define FIREBASE_EMULATOR=localhost:8080
```

## トラブルシューティング

### ビルドエラーが発生する場合

```bash
fvm flutter clean
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
```

### Firestore 接続エラー

- Firebase プロジェクト ID が正しいか確認
- Security Rules が正しく設定されているか確認
- ネットワーク接続を確認

### 画像アップロード失敗

- Firebase Storage のルールが正しく設定されているか確認
- ファイルサイズが 5MB 以下か確認
- 画像形式が JPEG/PNG 等のサポート形式か確認

## 設定完了後

セットアップが完了したら、以下の機能が使用可能になります：

- ✅ お土産の作成・読み込み・更新・削除
- ✅ 画像のアップロード
- ✅ カテゴリ分類
- ✅ バリデーション

## 参考リンク

- [Firebase Flutter プラグイン](https://firebase.flutter.dev/)
- [Cloud Firestore ドキュメント](https://firebase.google.com/docs/firestore)
- [Firebase Storage ドキュメント](https://firebase.google.com/docs/storage)
- [Flutter Security Rules](https://firebase.google.com/docs/firestore/security/start)
