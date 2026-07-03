# In-App Purchase Products

最終更新日: 2026年7月3日

App Store Connect のアプリ内課金商品作成用メモです。

## Product IDs

| 種別 | Product ID | 価格案 | 表示名案 | 説明案 |
|---|---|---:|---|---|
| 非消耗型 | `nomidai.pro.lifetime` | 600円 | 飲み代トラッカー Pro 買い切り | グラフ、CSV出力、カスタムプリセット無制限、中サイズウィジェットをまとめて解放します。 |
| 自動更新サブスクリプション | `nomidai.pro.monthly` | 200円/月 | 飲み代トラッカー Pro 月額 | 必要な期間だけPro機能を利用できます。 |

## Pro対象機能

- 全期間グラフ
- CSV出力
- カスタムプリセット無制限
- 中サイズウィジェット

## 実装側の対応

- Product ID定義: `NomidaiTracker/Supporting/ProductIDs.swift`
- 購入処理: `NomidaiTracker/Supporting/StoreKitService.swift`
- 復元ボタン: `NomidaiTracker/Views/Paywall/PaywallView.swift`
- ローカルStoreKit設定: `StoreKit/NomidaiTracker.storekit`

## リリース判断

コード上は買い切りと月額の両方に対応済み。初回リリース時に、両方を出すか、片方を主導線にするかをApp Store Connectの商品審査前に決める。

## 注意

App Store Connectで商品が未作成/未承認の場合、実機やTestFlightで商品情報を取得できない。TestFlight前に商品作成、価格設定、審査情報入力、スクリーンショット準備が必要。
