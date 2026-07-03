# TestFlightアップロード状況

最終更新日: 2026年7月3日

## 現在の状態

TestFlightアップロード前のArchive作成で停止しています。
アプリ本体のビルド/テスト/提出物チェックは通っており、Apple Developer側のApp ID/App Group作成と紐づけも完了しています。
残りはCloud MacのXcodeに保存されているApple IDログインの再認証と、Provisioning Profileの自動生成です。

## 実行済み

Cloud Macで以下を実行しました。

```sh
bash scripts/diagnose-signing.sh
bash scripts/archive-testflight.sh
```

## 結果

`diagnose-signing.sh`:

```text
OK: Project uses Team ID K4RPQR296Y
OK: Project app bundle ID is com.momi0216yama.nomidaitracker
OK: Project widget bundle ID is com.momi0216yama.nomidaitracker.widget
OK: Project uses Automatic signing
OK: App entitlement has App Group
OK: Widget entitlement has App Group
NG: Provisioning profile directory is missing: /Users/user298254/Library/MobileDevice/Provisioning Profiles
DIAGNOSE_EXIT_STATUS:1
```

`archive-testflight.sh`:

```text
ARCHIVE_EXIT_STATUS:65
```

主なエラー:

```text
Invalid credentials in keychain for EFF0CB17-EA24-4D67-8506-615241060D18, missing Xcode-Username
No Accounts: Add a new account in Accounts settings.
Unable to log in with account 'm0mi0216yama@gmail.com'.
The login details for account 'm0mi0216yama@gmail.com' were rejected.
No profiles for 'com.momi0216yama.nomidaitracker' were found.
No profiles for 'com.momi0216yama.nomidaitracker.widget' were found.
```

## 次に必要な操作

Cloud MacのXcodeで以下を行います。

1. `Xcode > Settings > Accounts` を開く。
2. Apple ID `m0mi0216yama@gmail.com` を一度サインアウト/削除する。
3. `Add Apple Account...` から同じApple IDを再追加し、2FAまで完了する。
4. Team `K4RPQR296Y` が表示されることを確認する。
5. XcodeでAutomatic signingによりProvisioning Profileが生成されることを確認する。
6. `bash scripts/diagnose-signing.sh` が `Signing diagnostics passed.` になることを確認する。
7. `bash scripts/archive-testflight.sh` を再実行する。
8. Archive成功後、OrganizerまたはXcode uploadコマンドでTestFlightへアップロードする。

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
