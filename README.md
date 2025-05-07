# 画面解像度表示アプリ

フラッタで作られた画面解像度表示アプリです。デバイスの画面サイズ、ピクセル比、物理ピクセルを表示します。

## Firebase デプロイ設定

このアプリはFirebase Hostingを使用してデプロイできます。

### 手動デプロイ

1. Firebase CLIをインストール
```bash
npm install -g firebase-tools
```

2. Firebaseにログイン
```bash
firebase login
```

3. プロジェクトの初期化（初回のみ）
```bash
firebase init
```

4. ビルドとデプロイ
```bash
flutter build web --release
firebase deploy
```

## CI/CD設定

GitHub Actionsを使用して自動デプロイが設定されています。

### 設定手順

1. GitHubリポジトリのSecretsに以下の項目を追加：
   - `FIREBASE_SERVICE_ACCOUNT`: Firebase CLIから生成したサービスアカウントキー

2. mainブランチにプッシュすると自動的にFirebaseにデプロイされます。

## 開発の始め方

```bash
flutter pub get
flutter run
```
