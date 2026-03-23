# 1 to 1 一覧 Quick Create Dialog — Fit & Gap（SSOT）

**作成日:** 2026-03-23  
**ステータス:** **ONETOONES_QUICK_CREATE_UX_P3** で Create / Edit と同一フォーム・同一 `buildOneToOnePayload` に統一済み。  
**関連:** [ONETOONES_CREATE_UX_REQUIREMENTS.md](ONETOONES_CREATE_UX_REQUIREMENTS.md)、[ONETOONES_EDIT_UI_FIT_AND_GAP.md](ONETOONES_EDIT_UI_FIT_AND_GAP.md)、`www/resources/js/admin/pages/OneToOnesList.jsx`

---

## 1. サマリ

一覧「＋ 1to1を追加」から開く **Quick Create Dialog** は、当初 **独自の `useState` + 手組み POST body** であり、Create ページ（`OneToOnesCreate` + `OneToOneFormFields`）および Edit（P2 以降）と **入力部品・送信規則が二重管理** になっていた。

P3 では **react-admin `Form` + `OneToOneFormFields`（`mode="create"`）+ `buildOneToOnePayload`** に寄せ、**相手サマリ・所要時間・例会 `ReferenceInput`・メモ** を Create と同じ順序・同じ正規化で送る。

**Quick Create 固有の差分**は次のみとする。

- **Owner（自分）** は一覧フィルタの `owner_member_id` に固定（入力は無効化）。変更は一覧フィルタで行う。
- **Dialog 用レイアウト**（`maxWidth`、スクロール、`DialogTitle` の Owner 説明）。
- ダイアログを開くたび **`formSession` で `Form` をリマウント**し、初期値と所要時間チップをリセット。

---

## 2. Fit（P3 実装後）

| 項目 | 内容 |
|------|------|
| 相手 | `OwnerScopedTargetSelect` + `TargetMemberSummaryCard`（Create と同じ）。 |
| 日時 | `OneToOneCreateScheduleFields` + 所要 30/60/90 分・終了予定プレビュー。 |
| 例会 | `OneToOneMeetingReferenceInput`（`ReferenceInput` + `dataProvider`）。 |
| 送信 | `buildOneToOnePayload(data, durationMinutes, { mode: 'create', workspaceId })`。 |
| メモ | `notes` は transform で trim 空は null（`oneToOnesTransform.js` 共通）。 |
| 成功時 | `notify`・`useRefresh()`・`onClose()`。 |

---

## 3. Gap（P3 前の主な問題）

| 問題 | 対応 |
|------|------|
| 相手・例会が MUI `Autocomplete` 直書きで、`TargetMemberSummaryCard` と `ReferenceInput` と二重 | `OneToOneFormFields` に統一。 |
| 日時・所要時間を手計算で `scheduled_at` / `ended_at` を組み立て | `buildOneToOnePayload` に統一。 |
| `meeting_id` のオブジェクト/id 揺れを個別処理 | `normalizeMeetingId` に集約。 |
| Create の `transform` と無関係な POST が増える | 同一 transform を Dialog submit からも使用。 |

---

## 4. 実装差分の詳細（P3）

| 項目 | 内容 |
|------|------|
| ファイル | `OneToOnesList.jsx` 内 `OneToOnesQuickCreateDialog` |
| データ取得 | `GET /api/workspaces`（先頭 id）、`GET /api/dragonfly/members`（Owner 候補・Create と同型）。 |
| フォーム | `Form` + `defaultValues`（`owner_member_id` ＝一覧フィルタ由来、`status: 'planned'` 等）。 |
| 追加 props | `OneToOneFormFields` に `suppressCreateOwnerHint`・`ownerInputDisabled`（一覧と Owner を固定するため）。 |
| `payload` | `fetch('/api/one-to-ones', { method: 'POST', body: JSON.stringify(body) })`（Create の `dataProvider.create` 経路と別だが **body 形状は同一**）。 |

---

## 5. 次 Phase への入力

| 候補 | 内容 |
|------|------|
| ONETOONES_DASHBOARD_TARGET_PREFILL_P4 | Dashboard / Leads から Create への `target_member_id` 自動プリフィル（本 SSOT の対象外）。 |
| ONETOONES_DURATION_CUSTOM_P5 | 30/60/90 以外の所要時間。 |
| 任意 | Quick Create の `POST` を `dataProvider.create('one-to-ones', …)` に統一して通信経路まで一本化するかは要検討（現状は body 整合で十分）。 |
