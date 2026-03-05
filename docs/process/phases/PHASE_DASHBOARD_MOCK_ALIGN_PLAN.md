# PHASE Dashboard Mock Align — PLAN

**Phase:** Phase D（Dashboard モック一致）  
**作成日:** 2026-03-05  
**SSOT:** docs/SSOT/DASHBOARD_REQUIREMENTS.md（要件）、モック `www/public/mock/religo-admin-mock2.html` の `#pg-dashboard`  
**実装対象:** `www/resources/js/admin/pages/Dashboard.jsx`（ルート `/`）

---

## 1. 目的

- ダッシュボード画面（/）をモック（#pg-dashboard）に **100% 合わせる**。
- 静的表示でモック一致をゴールとし、追加 API は実装しない。
- tugilo 標準（Phase 管理 + SSOT 固定 + PLAN/WORKLOG/REPORT + 1push + テスト駆動）を厳守する。

---

## 2. SSOT リンク（判断基準）

| 種別 | パス | 用途 |
|------|------|------|
| 要件書 | docs/SSOT/DASHBOARD_REQUIREMENTS.md | ブロック構成・文言・導線・レイアウト・チェックリストの正とする |
| モック | www/public/mock/religo-admin-mock2.html 行 327〜384（#pg-dashboard） | 見た目の最終判断基準 |
| 実装 | www/resources/js/admin/pages/Dashboard.jsx | 変更対象ファイル（補助コンポーネントは同ディレクトリ配下で完結可） |
| 参照 | docs/SSOT/MOCK_UI_VERIFICATION.md, FIT_AND_GAP_MOCK_VS_UI.md, ADMIN_UI_THEME_SSOT.md | あれば参照。最終はモック優先 |

---

## 3. 作業対象ファイル

- **原則:** `www/resources/js/admin/pages/Dashboard.jsx` のみ。
- **補助:** 必要最小限のコンポーネント分割は可。ただし `www/resources/js/admin/pages/` 配下で完結させる。
- **変更禁止:** 他画面、API、テーマ/全体 CSS の大改修。必要なら Dashboard ローカルで完結。

---

## 4. 変更禁止事項

- **API 追加禁止** — 今回は静的表示でモック一致がゴール。
- **他画面への波及禁止** — Connections / Members / Meetings / One-to-Ones 等は触らない。
- **余計なリファクタ禁止** — 既存仕様・既存実装を勝手に変更しない。大きなリファクタは禁止。

---

## 5. 実装ステップ（順序固定）

| Step | 内容 | 確認ポイント |
|------|------|--------------|
| Step0 | 現状確認 | 既存 Dashboard の目視差分を WORKLOG に記録 |
| Step1 | ページヘッダー | タイトル「Dashboard」、サブ「今日の活動・未アクション・KPI」、右に「Connectionsへ」「＋ 1to1追加」 |
| Step2 | 統計カード（stats） | 4 枚横並び、grid 4 列・gap 12px、未接触／今月1to1／紹介メモ数／例会メモ数。ダミー値は PLAN 指定の固定値を使用 |
| Step3 | 2 カラム | 左 1fr / 右 340px、gap 14px。1100px 以下で 1 列。レスポンシブ 768px 以下も必要なら確認 |
| Step4 | 今日やること（Tasks） | 4 件。未接触フォロー×2、1to1予定、例会メモ未整理。背景・左ボーダー・ボタン/チップをモック通り |
| Step5 | クイックショートカット | 4 ボタン。文言・導線・スタイルをモック通り（Connections、Members一覧、＋1to1を追加、例会一覧） |
| Step6 | 最近の活動 | 6 件。タイムライン行の区切り・余白をモック通り |
| Step7 | 全体確認 | モックと左右に並べて余白・gap・折返し・見出しを確認 |

---

## 6. 表示確認方法

- モックと実装を**並べて表示**し、構成・文言・余白・色を比較する。
- ブレークポイント: **1100px 以下で 2 カラム → 1 列**になることを確認。必要なら 768px 以下も確認。
- 参照: docs/SSOT/MOCK_UI_VERIFICATION.md の手順があればそれに従う。

---

## 7. ダミー値（静的表示用・固定）

Cursor が勝手に数字を作らないよう以下で固定する。

| 統計カード | 値 | 補足 |
|------------|-----|------|
| 未接触（30日以上） | 3 | 要フォロー |
| 今月の1to1回数 | 5 | 先月比 +2 |
| 紹介メモ数（今月） | 8 | BO含む |
| 例会メモ数（今月） | 4 | 例会#247 含む |

※ 将来 API 連携は別 Phase。

---

## 8. チェックリスト（要件書 6 の転記）

- [ ] ページヘッダー: タイトル「Dashboard」、サブ「今日の活動・未アクション・KPI」、右に「Connectionsへ」「＋ 1to1追加」
- [ ] 統計カード: 4 枚横並び（未接触／今月1to1／紹介メモ数／例会メモ数）、アイコン・ラベル・値・補足をモック通り
- [ ] 2 カラム: 左 1fr / 右 340px、gap 14px（レスポンシブで 1 列化）
- [ ] 今日やること: 見出し「⚡ 今日やること（Tasks）」、タスク行 4 種（未接触フォロー×2、1to1予定、例会メモ未整理）、背景・左ボーダー・ボタン/チップをモック通り
- [ ] クイックショートカット: 4 ボタン（Connections、Members一覧、＋1to1を追加、例会一覧）、スタイル・リンク先をモック通り
- [ ] 最近の活動: 見出し「🕐 最近の活動」、タイムライン 6 件、tl-item のアイコン・タイトル・メタをモック通り
- [ ] カード・余白・フォントをモック／ADMIN_UI_THEME_SSOT に合わせる

---

## 9. Phase 分割

| Phase | 目的 | 成果物 |
|-------|------|--------|
| **D-1** | Docs（計画/作業ログ/報告の雛形） | PLAN / WORKLOG / REPORT の 3 点セット作成、commit/push |
| **D-2** | UI 実装 | Dashboard.jsx をモック一致に修正、commit/push |
| **D-3** | 検証と締め | チェックリスト確認、モック比較、REPORT 確定、commit/push |

各 Phase で git status クリーン・意図した変更範囲・テスト/ビルド通過を確認してから commit → push。マージは PR なしで develop へ --no-ff merge。

---

## 10. Git 方針（Phase D-1）

- ブランチ: `feature/dashboard-mock-align-docs`
- コミット: `docs: dashboard mock alignment phase docs`
- 取り込み: develop へ --no-ff merge 後、REPORT に取り込み証跡を追記
