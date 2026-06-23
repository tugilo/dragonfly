# Phase 238 REPORT — MeetingsList UI 種別対応

**完了:** 2026-06-23 22:12 JST  
**Phase Type:** implement  
**Related SSOT:** SPEC-018 Phase D

---

## 実施内容

- Meetings ツールバー: 種別 Select（`/api/meeting-types`）、チーム Select（チームMTG 時のみ）
- サブタイトル: 「集会・議事録履歴」
- Drawer: 参加者/BO タブ・Chip・Connections 導線を `supports_*` で非表示（チームMTG）
- 議事録モーダル: import コマンドヘルプを種別出し分け、リファーラルボタン非表示
- Actions 列: PDF/BO/リファーラルを種別で非表示
- `meetingTypeUi.js` + dataProvider フィルタ連携

---

## モック比較

- 実施: FIT_AND_GAP_MEETINGS §Phase 238 参照
- モックに種別フィルタ無 → **意図的 Gap（SPEC-018 拡張）**

---

## テスト

```
npm run build  → success
php artisan test → 499 passed
```

---

## Merge Evidence

| 項目 | 内容 |
|------|------|
| merge commit id | de7f8387a673419020cbf3fbbdf59355b9542e25 |
| source branch | feature/phase238-meetings-list-ui |
| target branch | develop |
