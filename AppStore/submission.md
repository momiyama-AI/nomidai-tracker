# App Store / TestFlight 提出メモ

最終更新日: 2026年7月3日

## アプリ基本情報

- アプリ名: 飲み代トラッカー
- Bundle ID: `com.momi0216yama.nomidaitracker`
- Widget Bundle ID: `com.momi0216yama.nomidaitracker.widget`
- App Group: `group.com.momi0216yama.nomidaitracker`
- カテゴリ候補: ファイナンス
- 対応言語: 日本語
- 対応OS: iOS 17.0以降
- 年齢制限: 17+

## サブタイトル候補

今月の飲み代を1秒で確認

## プロモーション文候補

家飲みも外飲みも、今月いくら使ったかをすぐ確認できる支出トラッカーです。予算、カレンダー、ウィジェット、のみだぬきの表情で飲み代のペースを楽しく把握できます。

## 説明文候補

飲み代トラッカーは、家飲み・外飲みの支出をすばやく記録し、今月の飲み代をわかりやすく確認するためのアプリです。

主な機能:

- 缶ビール350ml/500ml、缶チューハイ、日本酒1合、ワイングラス、外飲みなどのプリセット記録
- 今月の支出合計、先月同日比、家飲み/外飲み内訳
- 月次予算と残額、消化ペース
- 日別支出のカレンダーヒートマップ
- マスコット「のみだぬき」による支出ペース表示
- 小/中サイズウィジェット
- Pro機能: 全期間グラフ、CSV出力、カスタムプリセット無制限、中サイズウィジェット

本アプリは完全ローカル動作です。サーバー、外部API、アカウント登録は使用しません。

## キーワード候補

飲み代,家飲み,外飲み,支出,予算,家計簿,お酒,カレンダー,ウィジェット,CSV

## スクリーンショット候補

6.7インチ相当のシミュレータで撮影済み。サイズは 1206 x 2622 px。

- `AppStore/screenshots/home.png`
- `AppStore/screenshots/quickRecord.png`
- `AppStore/screenshots/calendar.png`
- `AppStore/screenshots/settings.png`
- `AppStore/screenshots/paywall.png`

スクリーンショット用のデモデータはDebugビルド限定の `-screenshotDemoData` 起動引数で投入する。通常起動、Releaseビルド、TestFlight提出ビルドには影響しない。

## 有料機能 / In-App Purchase

リリース時に買い切りまたはサブスクのどちらを主導線にするか決める。コード上は両方対応済み。

| 種別 | Product ID | 価格案 | 参照名 |
|---|---|---:|---|
| 非消耗型 | `nomidai.pro.lifetime` | 600円 | 飲み代トラッカー Pro 買い切り |
| 自動更新サブスクリプション | `nomidai.pro.monthly` | 200円/月 | 飲み代トラッカー Pro 月額 |

Pro対象:

- 全期間グラフ
- CSV出力
- カスタムプリセット無制限
- 中サイズウィジェット

詳細な商品設定案は `AppStore/iap-products.md` を参照。

## 利用規約 / プライバシーポリシー

アプリ内リンク:

- 利用規約: `https://momiyama-ai.github.io/nomidai-tracker/terms`
- プライバシーポリシー: `https://momiyama-ai.github.io/nomidai-tracker/privacy`
- サポート: `https://momiyama-ai.github.io/nomidai-tracker/support`

GitHub Pagesで公開する場合:

- `docs/terms.md`
- `docs/privacy.md`
- `docs/support.md`

リポジトリ名を `nomidai-tracker` にして、Pagesの公開元を `docs` に設定する。

## プライバシー回答

- データ収集: なし
- トラッキング: なし
- サーバー送信: なし
- アカウント登録: なし
- 課金処理: Apple StoreKit / App Store経由

詳細な回答案は `AppStore/privacy-answers.md` を参照。

## 年齢制限

- 推奨: 17+
- 理由: アルコールへの言及があるため。

詳細な入力メモは `AppStore/age-rating.md` を参照。

## 審査メモ候補

本アプリは酒類に関する支出記録アプリです。医療、健康改善、節酒、禁酒、依存症治療を目的とするアプリではありません。記録データは端末内に保存され、開発者サーバーへの送信、外部API連携、アカウント登録はありません。アプリ内課金はStoreKit 2を利用し、購入復元ボタン、利用規約、プライバシーポリシーへのリンクを設置しています。

## App Store Connectで必要な作業

1. App ID `com.momi0216yama.nomidaitracker` を作成する。
2. App Group `group.com.momi0216yama.nomidaitracker` を作成し、App IDとWidget App IDへ紐づける。
3. Widget用 App ID `com.momi0216yama.nomidaitracker.widget` を作成する。
4. In-App Purchase商品を作成する。
5. GitHub Pages等で利用規約とプライバシーポリシーを公開する。
6. XcodeでArchiveを作成し、TestFlightへアップロードする。
7. TestFlightで購入/復元/CSV共有/Widget表示を確認する。

提出前チェックリストは `AppStore/release-checklist.md` を参照。
