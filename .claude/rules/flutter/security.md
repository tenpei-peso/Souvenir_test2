---
paths:
  - "**/*.dart"
---

# Flutter セキュリティ

> [common/security.md](../common/security.md) を拡張。

## シークレット管理

```dart
// 誤り: ハードコード
const apiKey = 'sk-xxxxx';

// 正解: --dart-define で注入
const apiKey = String.fromEnvironment('API_KEY');

// 正解: flutter_secure_storage
final storage = FlutterSecureStorage();
await storage.write(key: 'token', value: token);
final token = await storage.read(key: 'token');
```

## 入力バリデーション

```dart
// フォームバリデーション
TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) return '必須項目です';
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return '有効なメールアドレスを入力してください';
    }
    return null;
  },
)
```

## ネットワークセキュリティ

```dart
// 正解: Certificate Pinning
final dio = Dio()
  ..httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient()
        ..badCertificateCallback = (cert, host, port) => false;
      return client;
    },
  );

// 正解: トークンインターセプター
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _secureStorage.read('access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

## データ保護

- `flutter_secure_storage` で機密データを保存
- ログに個人情報を出力しない
- リリースビルドで `print()` / `debugPrint()` を無効化
- ProGuard/R8 で難読化を有効化

## Agent サポート

- **security-reviewer** で包括的なセキュリティ監査を実施
