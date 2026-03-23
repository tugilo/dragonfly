# 1 to 1 作成時の target_member_id プリフィル — Fit & Gap（SSOT）

**作成日:** 2026-03-23  
**ステータス:** **ONETOONES_DASHBOARD_TARGET_PREFILL_P4** で URL クエリ方式を SSOT 化し、Create の検証をオーナースコープに整合。Dashboard Tasks（stale）の 1to1 導線を補強。  
**関連:** [ONETOONES_CREATE_UX_REQUIREMENTS.md](ONETOONES_CREATE_UX_REQUIREMENTS.md)、[DASHBOARD_DATA_SSOT.md](DASHBOARD_DATA_SSOT.md)、`OneToOnesCreate.jsx`・`DashboardService::getTasks`

---

## 1. サマリ

**正:** `GET` 相当の画面遷移では **`?target_member_id=<数値>`** を URL クエリに付け、`OneToOnesCreate`（および一覧 Quick Create で同クエリがある場合）が **オーナーに紐づく相手候補**に含まれるときだけ初期値に入れる。

**理由:** ブックマーク・共有・再読み込みに強く、Create 側にフォームロジックを集約できる（location state / グローバル state は採用しない）。

---

## 2. 現状の導線一覧（P4 時点）

| 導線 | リンク例 | P4 前後 |
|------|----------|---------|
| Dashboard Leads | `/one-to-ones/create?target_member_id={member_id}` | 既に付与済み |
| Members 一覧（Card/Table） | `?target_member_id={id}` | 既に付与済み |
| Member 詳細（Show） | `?target_member_id={id}` | 既に付与済み |
| Dashboard Tasks（stale・1行目） | `/one-to-ones/create` のみ | **P4 で `?target_member_id=` を付与** |
| Dashboard ヘッダ / ショートカット | `/one-to-ones/create`（相手なし） | 変更なし（文脈上メンバー未特定） |
| 1 to 1 一覧「フォームで追加」 | `/one-to-ones/create` | 変更なし |

---

## 3. Fit

- Create は **`useSearchParams`** で `target_member_id` を解釈済み。
- **P4:** 受け取り後の **存在チェックを `GET /api/dragonfly/members?owner_member_id={owner}`**（オーナースコープ）に統一し、`OwnerScopedTargetSelect` の候補と一致させる。
- Quick Create（P3）は P4 で **`?target_member_id=` を一覧 URL に付いたとき**、ダイアログ初期値に反映（同一検証）。

---

## 4. Gap（P4 前）

| 問題 | 対応 |
|------|------|
| Create が **全件** `GET /api/dragonfly/members` で target を判定し、スコープ外 ID が紛れうる | オーナー別取得で **targetOk** を判定 |
| Dashboard Tasks の「1to1予定」が **相手なし**で Create へ | `target_member_id` をクエリに付与 |
| Quick Create が URL prefill 未対応 | 一覧で `useSearchParams` + スコープ検証 |

---

## 5. P4 実装方針

1. **Create:** `workspaces` + `me` + 全件 members（Owner 候補）取得後、**scoped members** を取得し `target_member_id` を検証。
2. **DashboardService:** `stale_follow` 1 行目の `href` を `/one-to-ones/create?target_member_id={tid}` に変更。
3. **Quick Create:** `useSearchParams` + scoped 検証 + `defaultValues.target_member_id`。
4. **不正値:** 数値でない・owner と同じ・スコープ外 → **無視**（既存どおり）。

---

## 6. 次 Phase への入力

- **カスタム所要時間**（別 Phase）。
- Quick Create の `POST` を `dataProvider.create` に寄せる検討（任意）。
