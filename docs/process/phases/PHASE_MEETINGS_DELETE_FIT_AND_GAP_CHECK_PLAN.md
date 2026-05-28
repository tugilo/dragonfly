# PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK — PLAN

**Phase ID:** MEETINGS_DELETE_FIT_AND_GAP_CHECK  
**種別:** docs（**実装・マイグレーション・API 変更なし**）  
**Related SSOT:** `DATA_MODEL.md` §4.6 ほか meetings 周辺、`MEETINGS_CREATE_FIT_AND_GAP.md`、create/update Phase REPORT の残課題  
**作成日:** 2026-03-19

---

## 背景

Meetings について一覧・統計・詳細・POST・PATCH・管理 UI（新規・編集）まで実装済み。一方 **DELETE は未実装**であり、子データ（participants / breakout / メモ / 参加者 PDF / CSV import・resolutions・apply ログ等）が `meeting_id` で結ばれている。マイグレーション上 **cascade / nullOnDelete が混在**しており、削除を安易に実装すると **意図しないデータ喪失または参照の孤児化**が起き得る。削除の **業務必要性・禁止条件・物理/論理の別**が SSOT に未整理のため、**実装 Phase に入る前の判断材料**を docs で揃える。

## 調査目的

- Meetings **削除が業務・プロダクト上必要か**、代替（編集・非表示）で足りるかを整理する。  
- **子データの種類・FK 挙動・業務的意味**を列挙し、削除時の **Fit / Gap / リスク**を明示する。  
- **削除ポリシー案（A〜E）**を比較し、**推奨方針**と **実装前に決めること**を明記する。  
- **コードは一切変更しない**（調査・SSOT 文書化のみ）。

## 調査対象

### SSOT / Phase 文書

- `docs/SSOT/DATA_MODEL.md` §4.6 meetings、§4.7 以降（participants / breakout / memos 等）
- `docs/SSOT/FIT_AND_GAP_MEETINGS.md`、`FIT_AND_GAP_MOCK_VS_UI.md`
- `docs/SSOT/MEETINGS_CREATE_FIT_AND_GAP.md`
- `PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_*`、`PHASE_MEETINGS_CREATE_IMPLEMENT_*`、`PHASE_MEETINGS_UPDATE_IMPLEMENT_*`

### 実装（読取のみ）

- `MeetingController`、`routes/api.php`（meetings 系 DELETE の有無）
- `MeetingsList.jsx`（削除 UI の有無）
- `Meeting` モデルと関連
- `meetings` および **`meeting_id` を持つ migrations** 全確認
- `ImportParticipantsCsvCommand` 等の meeting 依存（number / firstOrCreate）

### モック

- `www/public/mock/religo-admin-mock-v2.html` — `#/meetings` に削除導線があるか

## 確認する関連テーブル・関連機能（観点）

- participants / breakout_rooms / breakout_rounds / breakout_memos / participant_breakout
- contact_memos（meeting_id nullable・nullOnDelete）
- meeting_participant_imports、meeting_csv_imports、meeting_csv_import_resolutions、meeting_csv_apply_logs
- one_to_ones、introductions、dragonfly_contact_events（該当 migration がある場合）

## 整理観点

- 業務上「削除」vs「訂正」vs「非表示」  
- 子データ影響（cascade / set null / 監査・履歴）  
- 物理削除 vs 論理削除 vs アーカイブ（案 A〜E）  
- number UNIQUE と **再利用・欠番**  
- 削除導線の UI 位置（一覧 / Drawer / 限定運用）  
- 実装しない理由の明記

## 成果物一覧

| 成果物 | パス |
|--------|------|
| SSOT 調査まとめ | `docs/SSOT/MEETINGS_DELETE_FIT_AND_GAP.md` |
| PLAN | 本ファイル |
| WORKLOG | `PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_WORKLOG.md` |
| REPORT | `PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_REPORT.md` |
| レジストリ・INDEX・進捗 | `PHASE_REGISTRY.md`、`INDEX.md`、`dragonfly_progress.md` |

## DoD

- [x] `MEETINGS_DELETE_FIT_AND_GAP.md` が §1〜10 の観点を含み、子データ・FK・案 A〜E・推奨・次 Phase が書かれている  
- [x] PLAN / WORKLOG / REPORT が揃っている  
- [x] **コード・migration の変更がない**ことが PLAN / REPORT に明記されている  
- [x] INDEX / PHASE_REGISTRY / dragonfly_progress を更新した  
- [x] 削除の **必要性・危険性・未確定（要合意）** が明示されている  
