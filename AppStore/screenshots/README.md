# App Store Screenshots

最終生成日: 2026年7月3日

## 生成済みファイル

| ファイル | 内容 | サイズ |
|---|---|---|
| `home.png` | ホーム、今月合計、のみだぬき、予算 | 1206 x 2622 |
| `quickRecord.png` | クイック記録プリセット一覧 | 1206 x 2622 |
| `calendar.png` | カレンダーヒートマップ | 1206 x 2622 |
| `settings.png` | 設定、予算、法務リンク | 1206 x 2622 |
| `paywall.png` | Pro機能、購入候補、月額説明、購入復元、法務リンク | 1206 x 2622 |

## 再生成コマンド

クラウドMacでDebugビルド後に実行する。

```sh
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -path '*/Build/Products/Debug-iphonesimulator/NomidaiTracker.app' -type d | sort | tail -1)
DEVICE_ID=FFA828F5-BDC6-4643-BB78-A06B873A1CDE

xcrun simctl boot "$DEVICE_ID" 2>/dev/null || true
xcrun simctl bootstatus "$DEVICE_ID" -b
xcrun simctl ui "$DEVICE_ID" appearance light
xcrun simctl status_bar "$DEVICE_ID" override --time 9:41 --dataNetwork wifi --wifiBars 3 --cellularBars 4 --batteryState charged --batteryLevel 100
xcrun simctl install "$DEVICE_ID" "$APP_PATH"

mkdir -p /tmp/nomidai_screenshots
for screen in home quickRecord calendar settings paywall; do
  xcrun simctl launch --terminate-running-process "$DEVICE_ID" com.momi0216yama.nomidaitracker -screenshotDemoData -screenshotScreen "$screen"
  sleep 4
  xcrun simctl io "$DEVICE_ID" screenshot "/tmp/nomidai_screenshots/${screen}.png"
done
```

`-screenshotDemoData` と `-screenshotScreen` はDebugビルド限定。Release/TestFlightビルドでは通常起動のみ。
