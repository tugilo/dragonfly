# PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK — WORKLOG

**Phase ID:** MEETINGS_DELETE_FIT_AND_GAP_CHECK  
**種別:** docs（実装なし）  
**日付:** 2026-03-19

---

## 実際に確認したファイル

### SSOT / Docs

- `DATA_MODEL.md` §4.6（POST/PATCH・削除は別 Phase）、§4.7 participants（cascadeOnDelete）、§4.8 breakout_rooms、§4.9 participant_breakout、§4.11 contact_memos（nullOnDelete）
- `FIT_AND_GAP_MEETINGS.md` — 例会削除要件なし（メモの空削除は meeting 行ではない）
- `MEETINGS_CREATE_FIT_AND_GAP.md` — 更新済み・削除未着手
- `PHASE_MEETINGS_CREATE_IMPLEMENT_REPORT.md` / `PHASE_MEETINGS_UPDATE_IMPLEMENT_REPORT.md` — 次 Phase に delete 記載

### モック

- `religo-admin-mock-v2.html` — `#pg-meetings` 周辺。**例会削除 UI なし**

### 実装（grep / 読取）

- `MeetingController` — destroy なし
- `routes/api.php` — `DELETE /meetings/{id}` なし（CSV resolution の DELETE のみ）
- `MeetingsList.jsx` — 削除ボタンなし（ユーザー報告と整合）
- `www/database/migrations` — `meeting_id` / `meetings` を `rg` で検索し、cascade / nullOnDelete を一覧化

### 特記した migration

- `participants`, `breakout_rooms`, `breakout_rounds`, `breakout_memos` — meeting **cascade**
- `meeting_participant_imports`, `meeting_csv_imports`, `meeting_csv_apply_logs` — **cascade**
- `meeting_csv_import_resolutions` — import 経由で **連鎖削除**
- `contact_memos`, `one_to_ones`, `introductions`, `dragonfly_contact_events` — **nullOnDelete**

## meetings を参照している関連テーブルと関係（要約）

- **CASCADE 系:** 参加・BO・PDF・CSV・apply ログ・resolutions（間接）— meeting 物理削除で **子行も消える**  
- **SET NULL 系:** 例会に紐づくが必須でない参照 — meeting 削除で **参照だけ外れ、行は残る**

## モック / SSOT / 実装上の delete の扱い

- **モック:** 削除導線なし → 要件として「必須」とは読めない  
- **SSOT:** 削除ポリシー未記載。「別 Phase」までが DATA_MODEL の範囲  
- **実装:** DELETE 未実装 → 現状は **事故リスク低**、実装時に **ポリシー必須**

## 迷った点

- **案 B（cascade 丸呑み）**を「DBがそうなっているから OK」と書くべきか → **プロダクト上は非推奨**として明記（技術的事実と運用推奨を分離）  
- PDF ストレージのファイル実体は migration からは読めず → **未確定・要確認** とした

## 案 A / B / C / D / E の比較メモ

- **A/E:** 条件付きが安全寄り。E は A の運用版。  
- **B:** 実装コスト最小だが喪失最大。  
- **C:** 強いがスキーマ・クエリ波及大。  
- **D:** 削除を避けつつ「見えない」を満たす候補。

## 採用した推奨方針の理由

- Religo の **会の地図・参加・同室**は SSOT 上コア価値。**無条件物理削除は価値を壊しやすい**  
- 既に **PATCH** で誤登録の多くは修正可能  
- 削除が要るなら **条件＋説明＋権限**をセットで検討するのが現実的

## テスト実施結果

- 該当なし（docs Phase）。**コード変更なしのため `php artisan test` は実施不要**。
