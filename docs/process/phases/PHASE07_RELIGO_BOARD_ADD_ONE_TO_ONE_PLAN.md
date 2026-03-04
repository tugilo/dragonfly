# PHASE07 Religo DragonFlyBoard から 1 to 1 登録 — PLAN

**Phase:** DragonFlyBoard から 1 to 1 登録 UI  
**作成日:** 2026-03-04  
**SSOT:** [docs/SSOT/DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.9 one_to_ones, §5 Derived Metrics（last_one_to_one, last_contact_at は canceled 除外）

---

## 1. 狙い

- planned / completed / canceled を登録できる。
- 登録後に one_to_one_count / last_one_to_one / last_contact_at が更新される（status=canceled は last_* から除外する規約に従う）。

## 2. UI 追加箇所

- **コンポーネント:** `www/resources/js/admin/pages/DragonFlyBoard.jsx`
- **配置:** 右ペイン（選択中メンバーカード内）に「1 to 1 登録」ボタンを設置。クリックで簡易モーダルを表示（メモ追加と同様の最小構成）。

## 3. 入力項目

| 項目 | 種別 | 必須 | 備考 |
|------|------|------|------|
| workspace_id | 数値 | 必須 | API 必須。デフォルト 1。単一 workspace 運用で 1 件作成済み前提。将来 GET /api/workspaces で選択拡張可。 |
| status | 選択 | 任意（default: planned） | planned / completed / canceled |
| scheduled_at | datetime-local または日付+時刻 | 任意 | 予定日時 |
| started_at | 同上 | 任意 | 開始日時 |
| ended_at | 同上 | 任意 | 終了日時 |
| notes | テキスト | 任意 | メモ |
| meeting_id | 数値 | 任意 | 紐づけたい定例会 ID |

- **owner_member_id / target_member_id / workspace_id の取得元:**
  - **owner_member_id:** 既存の `ownerMemberId`。
  - **target_member_id:** 選択中メンバー `targetMember.id`。未選択時はボタン無効または非表示。
  - **workspace_id:** フォーム内の数値入力（初期値 1）。API が必須のため必須入力とする。

## 4. 登録後の更新方針

1. **POST /api/one-to-ones** を呼ぶ。
2. **成功時（201）:** members 一覧を再取得。`GET /api/dragonfly/members?owner_member_id={owner}&with_summary=1` で再 fetch。選択中 target の summary_lite（one_to_one_count, last_one_to_one, last_contact_at）が更新される。同時に summary（右ペイン）を loadSummary() で再取得。
3. **表示:** one_to_one_count が増える。last_one_to_one / last_contact_at は status が completed または planned のとき更新。canceled のときは count は増えるが last_* は変化しない場合がある（規約どおり）。

## 5. テスト

- **UI:** 自動テスト不要。手動スモークを WORKLOG に残す。
  - planned を登録 → one_to_one_count 更新を確認。
  - canceled を登録 → count は増えるが last_* は更新されない（規約どおり）ことを確認。

## 6. DoD

- [ ] DragonFlyBoard に「1 to 1 登録」UI（ボタン＋モーダル）を追加
- [ ] workspace_id（必須）・status・scheduled_at/started_at/ended_at・notes・meeting_id の入力と POST 実装
- [ ] POST 成功後に members 再 fetch（with_summary=1）で summary_lite を更新
- [ ] WORKLOG に手動確認結果を記載
- [ ] PLAN / WORKLOG / REPORT 作成済み、1 コミットで push、develop へ merge（--no-ff）
