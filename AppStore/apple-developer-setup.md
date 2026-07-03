# Apple Developer 署名設定手順

最終更新日: 2026年7月3日

TestFlightへ進むために必要なApple Developer側の設定手順です。現在のコード側設定は完了済みで、残りはApple ID再ログイン、App ID、App Group、Provisioning Profileです。

## 現在のArchiveブロッカー

`bash scripts/archive-testflight.sh` の最新結果では、以下でArchiveが止まっています。

- Apple ID `m0mi0216yama@gmail.com` のXcodeログイン情報が拒否されている。
- App ID `com.momi0216yama.nomidaitracker` のProvisioning Profileがない。
- Widget App ID `com.momi0216yama.nomidaitracker.widget` のProvisioning Profileがない。

## 作成する識別子

| 種別 | 値 |
|---|---|
| Team ID | `H79G72QG4F` |
| App Bundle ID | `com.momi0216yama.nomidaitracker` |
| Widget Bundle ID | `com.momi0216yama.nomidaitracker.widget` |
| App Group | `group.com.momi0216yama.nomidaitracker` |

## Apple Developerサイトで行うこと

1. [Apple Developer](https://developer.apple.com/account/) にApple IDでログインする。
2. `Certificates, Identifiers & Profiles` を開く。
3. `Identifiers` でApp IDを2つ作成する。
4. 1つ目はアプリ本体として作成する。
   - Platform: iOS, tvOS, watchOS
   - Description: `NomidaiTracker`
   - Bundle ID: Explicit
   - Bundle ID: `com.momi0216yama.nomidaitracker`
5. 2つ目はWidget Extensionとして作成する。
   - Platform: iOS, tvOS, watchOS
   - Description: `NomidaiTrackerWidget`
   - Bundle ID: Explicit
   - Bundle ID: `com.momi0216yama.nomidaitracker.widget`
6. `Identifiers` でApp Groupを作成する。
   - Identifier: `group.com.momi0216yama.nomidaitracker`
   - Description: `NomidaiTracker App Group`
7. 作成したApp ID本体を開き、Capabilityの `App Groups` を有効にして、`group.com.momi0216yama.nomidaitracker` を選択して保存する。
8. 作成したWidget App IDを開き、同じく `App Groups` を有効にして、同じApp Groupを選択して保存する。

## Xcodeで行うこと

1. クラウドMacでXcodeを開く。
2. `Xcode > Settings > Accounts` を開く。
3. Apple ID `m0mi0216yama@gmail.com` を削除または再ログインする。
4. Team `H79G72QG4F` が表示されることを確認する。
5. プロジェクト `NomidaiTracker.xcodeproj` を開く。
6. Target `NomidaiTracker` の `Signing & Capabilities` を確認する。
   - Team: `H79G72QG4F`
   - Bundle Identifier: `com.momi0216yama.nomidaitracker`
   - Release signing: Manual
   - Provisioning Profile: `NomidaiTracker AppStore`
   - App Groups: `group.com.momi0216yama.nomidaitracker`
7. Target `NomidaiTrackerWidget` の `Signing & Capabilities` も同じように確認する。
   - Team: `H79G72QG4F`
   - Bundle Identifier: `com.momi0216yama.nomidaitracker.widget`
   - Release signing: Manual
   - Provisioning Profile: `NomidaiTrackerWidget AppStore`
   - App Groups: `group.com.momi0216yama.nomidaitracker`

## 設定後の確認コマンド

クラウドMacで以下を実行する。

```sh
bash scripts/verify-release-readiness.sh
bash scripts/archive-testflight.sh
```

期待結果:

- `verify-release-readiness.sh`: `Release readiness local checks passed.`
- `archive-testflight.sh`: `ARCHIVE_EXIT_STATUS:0`
- `/tmp/NomidaiTracker.xcarchive` が作成される。

## Archive成功後

1. Xcodeで `Window > Organizer` を開く。
2. 作成された `NomidaiTracker.xcarchive` を選択する。
3. `Validate App` を実行する。
4. 問題がなければ `Distribute App > App Store Connect > Upload` を選び、TestFlightへアップロードする。
5. App Store Connectでビルド処理が完了したら、内部テスターへ配布する。

## 注意

- App IDとWidget App IDの両方に同じApp Groupを紐づける。
- App Groupsを変更した後は、XcodeのSigning画面でプロファイルが更新されるまで少し待つ。
- Archiveが同じエラーで失敗する場合は、XcodeのAccountsからApple IDを一度削除して再ログインする。
- Release archive はApp Store用Provisioning Profileを使うManual signingで実行する。
