# Provisioning / Archive 確認メモ

最終確認日: 2026年7月3日

## 実行したArchiveコマンド

```sh
xcodebuild archive \
  -project NomidaiTracker.xcodeproj \
  -scheme NomidaiTracker \
  -destination 'generic/platform=iOS' \
  -archivePath /tmp/NomidaiTracker.xcarchive \
  -allowProvisioningUpdates
```

同じ確認は以下でも実行できます。

```sh
bash scripts/archive-testflight.sh
```

## 結果

2026年7月3日に再実行し、Archiveは引き続き失敗しました。アプリ本体のコンパイルではなく、Apple Developerアカウント認証とProvisioning Profile不足が原因です。

主なエラー:

- `Unable to log in with account 'm0mi0216yama@gmail.com'. The login details ... were rejected.`
- `No profiles for 'com.momi0216yama.nomidaitracker' were found`
- `No profiles for 'com.momi0216yama.nomidaitracker.widget' were found`

## 解消手順

詳細な画面操作は `AppStore/apple-developer-setup.md` を参照。

1. クラウドMacのXcodeを開く。
2. `Xcode > Settings > Accounts` を開く。
3. Apple ID `m0mi0216yama@gmail.com` を再ログインする。
4. Team `K4RPQR296Y` が表示されることを確認する。
5. Apple DeveloperサイトまたはXcodeの自動管理で以下を作成する。
   - App ID: `com.momi0216yama.nomidaitracker`
   - Widget App ID: `com.momi0216yama.nomidaitracker.widget`
   - App Group: `group.com.momi0216yama.nomidaitracker`
6. App IDとWidget App IDにApp Groupを紐づける。
7. Xcodeで `Automatically manage signing` が有効な状態でArchiveする。
8. Archive成功後、OrganizerからTestFlightへアップロードする。

## コード側の確認状況

- `xcodebuild test` は成功済み。
- Team IDは `NomidaiTracker.xcodeproj` に設定済み。
- App Group entitlementはアプリ本体とWidgetの両方に設定済み。
- Signing Styleはアプリ本体とWidgetの両方でAutomaticに設定済み。
- Archiveの残課題はApple Developer側の認証/Provisioning設定。

最新ArchiveログはクラウドMac上の `/tmp/nomidai_archive_latest.log` に出力済み。
