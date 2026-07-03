# 署名診断メモ

最終更新日: 2026年7月3日

TestFlightアップロード前に、Cloud Macで署名状態を確認するためのメモです。

## 実行コマンド

```sh
bash scripts/diagnose-signing.sh
```

成功時は以下が表示されます。

```text
Signing diagnostics passed.
```

## 確認する項目

- Team ID: `H79G72QG4F`
- App Bundle ID: `com.momi0216yama.nomidaitracker`
- Widget Bundle ID: `com.momi0216yama.nomidaitracker.widget`
- App Group: `group.com.momi0216yama.nomidaitracker`
- App用Provisioning Profile
- Widget用Provisioning Profile

## 失敗した場合

以下を確認してから再実行します。

1. Xcode > Settings > AccountsでApple IDに再ログインする。
2. Apple DeveloperでApp ID `com.momi0216yama.nomidaitracker` を作成する。
3. Apple DeveloperでWidget App ID `com.momi0216yama.nomidaitracker.widget` を作成する。
4. App Group `group.com.momi0216yama.nomidaitracker` を作成する。
5. App IDとWidget App IDの両方に同じApp Groupを紐づける。
6. XcodeでAutomatic signingを有効にしたまま、Provisioning Profileが生成されるまで待つ。
7. `bash scripts/archive-testflight.sh` を再実行する。

## 位置づけ

`scripts/verify-release-readiness.sh` はコード、画像、URL、PrivacyInfo、StoreKit設定などの提出物整合性を確認します。
`scripts/diagnose-signing.sh` はApple Developer側の署名状態を確認します。

署名診断が成功しない状態では、ArchiveやTestFlightアップロードは成功しません。
