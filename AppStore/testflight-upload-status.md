# TestFlightアップロード状況

最終更新日: 2026年7月3日

## 2026年7月3日 追記

- App Store Connectに新規アプリ `飲み代トラッカー` を作成済み。
- App Store Connect App ID: `6787132445`
- Bundle ID: `com.momi0216yama.nomidaitracker`
- SKU: `nomidai-tracker-20260703`
- `bash scripts/archive-testflight.sh` は `ARCHIVE_EXIT_STATUS:0` で成功。
- `bash scripts/upload-testflight.sh` は `UPLOAD_EXIT_STATUS:0` で成功。
- アップロードされたバイナリ: `NomidaiTracker`
- App Store Connect側でTestFlightビルド処理が開始済み。
- TestFlightビルド `1.0 (1)` は処理完了し、ステータス `提出準備完了` を確認済み。
- 内部テストグループ `内部テスト` を作成済み。
- 内部テスターとして `m0mi0216yama@gmail.com` を追加済み。ステータスは `招待済み`。

## 現在の状態

TestFlightへの初回バイナリアップロードは成功しています。
内部テストグループと内部テスター追加まで完了しています。

## 実行済み

Cloud Macで以下を実行しました。

```sh
bash scripts/diagnose-signing.sh
bash scripts/archive-testflight.sh
bash scripts/upload-testflight.sh
```

## 結果

`diagnose-signing.sh`:

```text
OK: Project uses Team ID H79G72QG4F
OK: Project app bundle ID is com.momi0216yama.nomidaitracker
OK: Project widget bundle ID is com.momi0216yama.nomidaitracker.widget
OK: Release signing is manual for App Store profiles
OK: App Store profile is specified for app target
OK: App Store profile is specified for widget target
OK: App entitlement has App Group
OK: Widget entitlement has App Group
OK: App provisioning profile found: NomidaiTracker AppStore
OK: Widget provisioning profile found: NomidaiTrackerWidget AppStore
```

`archive-testflight.sh`:

```text
ARCHIVE_EXIT_STATUS:0
```

`upload-testflight.sh`:

```text
UPLOAD_EXIT_STATUS:0
Uploaded NomidaiTracker
```

## 次に必要な操作

App Store Connectで以下を行います。

1. 招待メールまたはTestFlightアプリから `飲み代トラッカー` を開く。
2. 必要に応じてApp Store Connect上でテスト情報やメタデータを追加する。
3. 次回以降のアップロードは `bash scripts/archive-testflight.sh` と `bash scripts/upload-testflight.sh` を実行する。

## Apple Developer確認済み

2026年7月3日にApple Developerで以下を確認済みです。

- App ID: `com.momi0216yama.nomidaitracker`
- Widget App ID: `com.momi0216yama.nomidaitracker.widget`
- App Group: `group.com.momi0216yama.nomidaitracker`
- App IDとWidget App IDの両方にApp Group `group.com.momi0216yama.nomidaitracker` を紐づけ済み。

## ログ

最新Archiveログ:

```text
/tmp/nomidai_archive_latest.log
```
