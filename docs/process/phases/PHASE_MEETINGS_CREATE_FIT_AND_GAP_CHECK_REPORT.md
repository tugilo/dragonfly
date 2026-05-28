# PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK — REPORT

**Phase ID:** MEETINGS_CREATE_FIT_AND_GAP_CHECK  
**種別:** docs  
**ステータス:** completed（調査・ドキュメントのみ）  
**日付:** 2026-03-19

---

## 作成したドキュメント一覧

| ドキュメント | 役割 |
|--------------|------|
| `docs/SSOT/MEETINGS_CREATE_FIT_AND_GAP.md` | Fit/Gap・業務フロー・案 A/B/C・推奨方針・次アクションの SSOT 寄りまとめ（本文 10 節構成） |
| `docs/process/phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_PLAN.md` | 背景・目的・調査対象・DoD |
| `docs/process/phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_WORKLOG.md` | 確認証拠・判断理由 |
| 本 REPORT | 要約・次ステップ |

`docs/INDEX.md`、`docs/process/PHASE_REGISTRY.md`、`docs/dragonfly_progress.md` を更新。

---

## 調査結果の要約

- **モック・既存 SSOT（FIT_AND_GAP_MEETINGS 等）には例会の新規作成・編集・削除を求める記述はない。** モック `#/meetings` にも新規作成ボタンはない。
- **実装も一致しており、** `MeetingController` は読取系のみ、API に meetings の POST/PUT/DELETE なし、react-admin の meetings は list のみ、`MeetingsList.jsx` に例会新規導線なし。
- **データ投入の実在経路:** Seeder と `ImportParticipantsCsvCommand::resolveMeeting`（`number` で `firstOrCreate`、`name` は `第N回定例会` 形式）。
- **結論:** 「モックどおりだから不要」ではなく、**業務上は次回例会の `meetings` 行が定期的に必要**であり、現状は**管理画面・API では作れない Gap** がある。過去 Phase は**スコープ外・未検討**に近い。

---

## Fit / Gap の要約

**Fit**

- 既存の CSV/PDF/メモ/BO は **meeting 既存前提**で整合。
- モックにも例会作成 UI が無く、**画面パリティ**の観点では矛盾しない。
- CLI が `firstOrCreate` で**代替生成**をすでに実装。

**Gap**

- 管理画面・REST での例会 **CRUD なし**（特に作成）。
- **number 採番・name 既定・未来日 held_on・削除時の子データ**のプロダクト合意が SSOT に未固定。
- 管理画面 CSV フローは **既存 meeting 選択が前提**（取込時自動作成は無し）。

---

## 推奨方針

1. **中長期:** 管理画面から**新規作成できるべき（案A 主軸）** — 週次運用と「例会管理」のラベルに整合。
2. **実装の段階:** まず **`POST /api/meetings`**（`number`, `held_on` 必須、任意 `name`、未指定時は `第{number}回定例会` で CLI と揃える）と一覧の最小 UI。**編集・DELETE は別 Phase**（cascade / 運用ポリシー確定後）。
3. **案B** は案A 後の**補助**として検討。案C は**暫定**として文書化し、本番では案A 相当まで進めることを推奨。

---

## 次に進むなら何をやるか

| 順 | 内容 |
|----|------|
| 1 | ステークホルダーと**正の投入経路**（画面必須 vs CLI 継続）を合意 |
| 2 | docs Phase で **POST のバリデーション・権限・name 既定**を SSOT（`DATA_MODEL` または専用節）に追記 |
| 3 | implement Phase: `POST /api/meetings`、MeetingsList 作成 Dialog、Feature テスト |
| 4 | PATCH/DELETE は子テーブル影響表を書いたうえで別 Phase |
| 5 | （任意）`FIT_AND_GAP_MEETINGS.md` に「例会マスタ作成はモック外・運用で要検討」の注記 |

---

## Merge Evidence

本 Phase は **docs のみ**のため、merge・`php artisan test` の証跡は対象外。取り込み時は REPORT に **merge commit id** を追記する運用に従うこと。

**scope check:** OK（docs のみ）  
**ssot check:** OK（新規 SSOT 文書を追加）  
**dod check:** OK
