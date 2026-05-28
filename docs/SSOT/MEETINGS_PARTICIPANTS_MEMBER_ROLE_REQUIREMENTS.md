# Meetings 参加者CSV反映 — participants 差分更新 + members 更新 + Role History 連携 要件整理

**作成日:** 2026-03-19  
**ステータス:** 要件整理たたき台（実装前）  
**Phase:** M7-C4.5-REQUIREMENTS  
**関連:** [MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md](MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md), [MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md](MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md), [DATA_MODEL.md](DATA_MODEL.md)

**実装メモ（2026-03-17）:** members 基本情報の**更新候補プレビュー**（名前・よみがな・カテゴリー差分の表示のみ、DB 更新なし）を **M7-M2** で追加。API: `GET .../csv-import/member-diff-preview`。詳細は `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_REPORT.md`。  
**実装メモ（2026-03-17）:** 上記候補の**確定反映**（既存 member の name / name_kana / category_id のみ。マスタ解決済み category のみ。新規 member・categories 作成なし・Role History 非対象）を **M7-M3** で追加。API: `POST .../csv-import/member-apply`。詳細は `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_REPORT.md`。  
**実装メモ（2026-03-17）:** CSV の役職列と **現在役職**（member_roles 由来）の**差分プレビュー（表示のみ・DB 非更新）**を **M7-M4** で追加。API: `GET .../csv-import/role-diff-preview`。`roles` の自動作成なし。詳細は `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_REPORT.md`。  
**実装メモ（2026-03-17）:** 上記差分の**確定反映**（`member_roles` のみ。解決済み changed/csv_only と current_only の終了。基準日は **M7-M6** 以降 `effective_date` / `held_on` / `today` の優先解決。`roles` 自動作成なし。participants / members 非更新）を **M7-M5** で追加。API: `POST .../csv-import/role-apply`。詳細は `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_REPORT.md`。  
**実装メモ（2026-03-17）:** **M7-M6** で CSV 反映の**監査ログ**（`meeting_csv_apply_logs`、participants / members / roles 別）と、Role 反映の**基準日**（`effective_date` 任意 → 未指定時は `meeting.held_on` → フォールバック `today`）を追加。`GET .../csv-import/apply-logs`、Meeting 詳細の `csv_apply_logs_recent`。詳細は `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_AUDIT_AND_EFFECTIVE_DATE_M6_REPORT.md`。  
**実装メモ（2026-03-17）:** **M7-M7** で **unresolved member / category / role** を import 単位の **`meeting_csv_import_resolutions`** に保存し、preview / apply で**最優先**参照。API: `GET .../csv-import/unresolved`、`POST .../csv-import/resolutions`、`POST .../resolutions/create-member|create-category|create-role`、検索 `GET /api/categories/search`、`GET /api/roles/search`。UI: Meetings 例会詳細 Drawer「未解決を解消」。詳細は `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_REPORT.md`。  
**実装メモ（2026-03-17）:** **M7-FINAL-CHECK** で横断確認。**category** は resolution → マスタ照合で一貫。**role（役職名）** は `roles.name` 一致を resolution より先に見るが、preview と apply で同順。当時、**CSV 名から Member を解決する順序**だけが apply と各 diff プレビューで逆だったが、**M8.5** で解消済み（下記）。詳細は `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_REPORT.md`。  
**実装メモ（2026-03-17）:** **M8** で unresolved（open）向けに **あいまい一致候補**を追加（自動確定なし）。`CsvResolutionSuggestionService` と `GET .../csv-import/unresolved-suggestions`。UI は「候補を表示」→ スコア順の参考候補と「これを使う」→ 既存 resolution 登録。詳細は `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_SUGGESTION_M8_REPORT.md`。  
**実装メモ（2026-03-17）:** **M8.5** で **CSV 名 → Member** の解決順を **全系統で統一**: **① `meeting_csv_import_resolutions`（member）② `Member::where('name', CSV名)` ③ プレビュー系は unresolved（新規作成なし）／participants apply のみ必要時 `Member::create`。**`MeetingCsvMemberResolver`** に集約。`MeetingCsvDiffPreviewService` / `MeetingCsvMemberDiffPreviewService` / `MeetingCsvRoleDiffPreviewService` / `MeetingCsvUnresolvedSummaryService` / `ApplyMeetingCsvImportService`。詳細は `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_REPORT.md`。  
**実装メモ（2026-03-19）:** **M9** で **resolution の一覧・解除・再マップ**（`GET/PUT/DELETE .../csv-import/resolutions`、最新 import のみ）と、**同名 member** 時の **`duplicate_name_warning` / `duplicate_count` / `duplicate_candidates`**（`resolveExistingWithMeta`、resolution 時は警告なし）。preview・unresolved・各 diff・unresolved-suggestions・MeetingsList。詳細は `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_MANAGEMENT_M9_REPORT.md`。

---

## 1. 機能概要

毎週のミーティング参加者名簿（CSV）を、**参加者反映（participants）** だけでなく、**members マスタの更新** と **Role History（役職履歴）との整合** まで含めてどう扱うかを整理する。

**目的**

- participants の安全な差分更新（M7-C4 で整理済み）に加え、CSV に含まれる名前・かな・カテゴリー・役職を members や役職履歴にどう反映するかを方針化する。
- カテゴリー変更・役割の半年交代を考慮し、履歴を壊さず「毎週名簿から更新してよい範囲」と「確認必須の範囲」を分ける。

**前提**

- 実装は行わない。本 Phase は要件整理に徹する。
- 安全性を最優先し、Role History の自動更新は慎重に扱う。

---

## 2. 背景と問題意識

- **M7-C3:** CSV 反映時は participants を全削除して再作成。ApplyMeetingCsvImportService は member を名前で解決 or 新規作成するが、**category / role / introducer / attendant は更新していない**（名前・かな・type のみ新規作成時に入れる）。
- **M7-C4-REQUIREMENTS:** participants は差分更新にすべきと整理済み。BO 保護のため participant を安易に削除しない。
- **毎週の名簿:** 参加者名簿には members のカテゴリー・役職が含まれており、members マスタ更新にも使える可能性がある。一方で、カテゴリーは変わることがあり、役割は半年に一度変わる運用。**単純に毎週上書きすると Role History の意味を壊す**（例: 毎週 term_end を閉じて term_start を「今週」にすると、履歴が「週ごとの細切れ」になる）。
- **既存 Role History:** DATA_MODEL では役職は **roles（マスタ）** と **member_roles（履歴: term_start / term_end）** で管理。現在役職は「term_end IS NULL かつ term_start <= 今日」の member_role から導出。members に current_role カラムはなく、member_roles が正。
- **既存 CLI:** ImportParticipantsCsvCommand は **syncCurrentRole** で「既存の term_end 未設定をすべて term_end=today で閉じ、CSV の役職名で新規 member_role を term_start=today で開始」している。毎週実行すると同じ役職でも週ごとにレコードが増える設計になっており、半年交代の履歴としては不向き。

---

## 3. 反映対象の整理（participants / members / Role History）

### A. participants

| 観点 | 内容 |
|------|------|
| **何を持つか** | その回の参加者。meeting_id + member_id をキーに、type, introducer_member_id, attendant_member_id。 |
| **何が変わりうるか** | 参加・不参加、種別変更、紹介者・アテンドの変更。 |
| **毎週名簿からどこまで更新してよいか** | **追加・更新は CSV を正として反映してよい。** 削除は「削除候補」とし、BO 設定済みは削除しない（M7-C4 推奨方針）。 |

participants は meeting ごとのデータであり、BO（participant_breakout）に影響する。差分更新で participant を削除すると BO が cascade で消えるため、削除は限定する。

---

### B. members

| 観点 | 内容 |
|------|------|
| **何を持つか** | チャプター所属メンバーのマスタ。name, name_kana, category_id, type, display_no, introducer_member_id, attendant_member_id。役職は member_roles で保持（後述）。 |
| **何が変わりうるか** | 名前表記・よみがなの修正、カテゴリー変更、紹介者・アテンドの変更。役職は member_roles で管理するため「現在役職」の更新は Role History と連動する。 |
| **毎週名簿からどこまで更新してよいか** | **名前・よみがな:** 差分があれば更新候補とし、反映時に上書きしてよい（表記修正として許容）。**カテゴリー:** 変更時は warning を出し、候補として表示したうえで確認のうえ更新（§5 で詳細）。**紹介者・アテンド:** 名簿に含まれていれば participant 単位で設定してよい。members の introducer_member_id / attendant_member_id は「メンバーとしてのデフォルト紹介者・アテンド」であり、毎週名簿で上書きするかは運用次第（第一歩では participant のみでよい）。**役職:** Role History と連動するため、毎週の自動上書きは推奨しない（§6）。 |

---

### C. Role History（member_roles）

| 観点 | 内容 |
|------|------|
| **何を持つか** | メンバーがどの期間にどの役割だったか。member_roles: member_id, role_id, term_start, term_end。現在役職は term_end IS NULL かつ term_start <= 今日 の行から導出。 |
| **何が変わりうるか** | 半年に一度の役職交代で「前役を閉じる（term_end 設定）」と「新役を開始（新行の term_start）」が発生。同じ役職が継続している場合は履歴を増やさないのが望ましい。 |
| **毎週名簿からどこまで更新してよいか** | **自動で「現在役職を閉じて新役職を開始」するのは危険。** 毎週 CSV に同じ役職名が載っていても、それを「新規 term_start」にすると履歴が細切れになる。推奨: 毎週名簿からは **役割の差分を検知して「変更候補」として表示** し、確定は人が確認のうえで行う。自動反映は行わない（第一歩）。 |

---

## 4. members 更新項目の分類

毎週の名簿から members に対して、項目ごとの扱いを整理する。

| 項目 | 分類 | 扱い |
|------|------|------|
| **名前** | 差分があれば更新候補 | プレビューで「名前変更候補」を出し、反映時に members.name を更新してよい。表記修正として許容。 |
| **よみがな** | 同上 | name_kana を更新候補として表示し、反映時に上書きしてよい。 |
| **カテゴリー** | 差分があれば warning | 既存 category_id と CSV のカテゴリー（categories マスタ照合後）が異なる場合は「カテゴリー変更候補」として warning を出し、確認のうえ更新。categories に存在しない名称はマスタに firstOrCreate するか、プレビューで「未登録カテゴリー」として表示する。 |
| **役割 / 役職** | Role History と連動 | 自動更新せず、**変更候補**として別セクションで表示。確定は人が Role History 更新フローで行う（§6）。 |
| **備考** | 自動更新しない | 名簿に備考列があっても members の備考に自動反映しない。候補表示のみ可。 |
| **地域 / 所在地** | 名簿に含まれない想定 | 現行 CSV 仕様にない。将来列があれば「候補として扱う」程度。 |
| **紹介者・アテンド** | participant 単位で設定可 | participants の introducer_member_id / attendant_member_id は CSV から設定してよい。members の introducer_member_id / attendant_member_id は「メンバーとしてのデフォルト」であり、毎週名簿で上書きするかは別論（第一歩では participant のみ）。 |
| **type / display_no** | 種別・表示番号 | CSV の種別から participants.type と members.type を設定。display_no は CLI と同様に No / V1… / G1… 等。反映時に更新してよい。 |

---

## 5. カテゴリー変更の扱い

- **CSV のカテゴリーを最新値として members に毎週上書きしてよいか**  
  **条件付きでよい。** 既存値と同一ならそのまま。**既存値と違う場合は「カテゴリー変更候補」として warning を出し、ユーザーが確認してから反映する。**

- **既存値と違う場合は warning を出すべきか**  
  **出すべき。** カテゴリー変更は業務上意味があるため、プレビューで「A → B に変更」と明示し、確認のうえで反映する。

- **category master との照合が必要か**  
  **必要。** CSV の「大カテゴリー」「カテゴリー」は categories の group_name / name で firstOrCreate または検索し、category_id に変換する。未登録の名称は「未登録カテゴリー」としてプレビューに表示し、反映時に categories に作成してから category_id を設定するか、運用で決める。

- **変更履歴を持つべきか**  
  第一歩では **持たない**。members.category_id の上書きのみ。将来「カテゴリー変更履歴」テーブルを用意する場合は別 Phase。

- **差分プレビューに「カテゴリー変更候補」を出すべきか**  
  **出すべき。** 追加・更新・削除候補と同様に、member 更新候補の一覧で「カテゴリー: 建設/解体 → IT/Web制作」のように色分けまたはアイコンで表示する。

---

## 6. 役割 / Role History の扱い

### 6.1 現在役割の保持方法

- **members.current_role のような現在値だけを持つか**  
  **持たない。** DATA_MODEL では **member_roles が正**。現在役職は「term_end IS NULL かつ term_start <= 今日」の member_role から role を参照して導出する（Member::currentRole()）。

### 6.2 毎週の名簿から役割差分を見つけたとき

| アクション | 推奨 |
|------------|------|
| **現在役割を閉じる** | **自動で行わない。** 人が「役割変更を反映」で確定したときのみ、既存の term_end 未設定に term_end を設定する。 |
| **新役割を開始する** | **自動で行わない。** 人が確定したときのみ、新規 member_role を term_start 付きで insert する。 |
| **差分候補として人が確認する** | **推奨。** プレビューに「役割変更候補: プレジデント → なし」「役割変更候補: なし → 書記」などを表示し、別ステップまたはチェックボックスで「Role History を更新する」を選んだ場合のみ DB を更新する。 |

### 6.3 半年に一度変わる運用のモデル化

- member_roles の **term_start / term_end** で期間を管理する現行モデルでよい。
- 半年交代なら、交代日（例: 4/1, 10/1）に「前役の term_end を設定」「新役の term_start を設定」する 1 回の操作でよい。**毎週 CSV で「今週の役職」をそのまま term_start=today で insert すると、同じ役職が何十回も重複するため避ける。**

### 6.4 同じ役割が継続している場合

- **履歴を増やさないルールにする。** CSV の役職名が現在の member_roles（term_end 未設定）の role.name と一致する場合は、**何もしない**。差分候補にも出さない。

### 6.5 毎週 CSV から Role History を自動更新してよいか

- **自動更新しない。** 変更候補の表示までに留め、確定は人が確認のうえで行う。安全性を最優先する。

---

## 7. 差分更新との関係整理

| 対象 | 必須か | 同時にやるか | 推奨 |
|------|--------|--------------|------|
| **participants 差分更新** | 必須 | 1 回の「CSV 反映」で実行 | 追加・更新は反映、削除は削除候補（BO ありは削除しない）。 |
| **members 基本情報更新** | 任意 | 同一「反映」で行うか、別ステップか | **同一反映で「member 更新候補」を適用する**形が現実的。名前・かな・カテゴリーをプレビューで確認し、一括反映で participants と members を更新する。 |
| **Role History 更新** | 任意 | **別ステップ推奨** | 同一反映では **行わない**。プレビューに「役割変更候補」を出し、別ボタンまたは「Role History を更新する」チェックを付けた場合のみ member_roles を更新する。第一歩では **候補表示のみ** とし、確定反映は別 Phase でも可。 |

**1 回の CSV 反映で一括するもの**

- participants の追加・更新（および削除候補のうちユーザーが「削除する」を選んだもの）。
- members の名前・よみがな・カテゴリー（変更候補として確認済みのもの）。

**候補表示に留めるもの**

- 役割変更候補。確定は人が行う。

---

## 8. UI / UX 要件案

- **差分プレビューで「participants 差分」だけでなく「member 更新候補」も見せるか**  
  **見せる。** 参加者リストとは別に、または同じテーブル内に「member 更新候補」列またはセクションを設け、名前・かな・カテゴリーの変更を表示する。

- **カテゴリー変更候補を色分け表示するか**  
  **する。** 例: 変更ありの行を黄色、または「カテゴリー」セルに「A → B」と表示してアイコンで注意を促す。

- **役割変更候補を別セクションで表示するか**  
  **する。** 「役割変更候補」セクションを設け、「山田太郎: プレジデント → （なし）」「鈴木花子: （なし） → 書記」のように一覧する。ここでは自動反映せず、将来的に「反映する」ボタンやチェックで確定する。

- **Role History 更新はチェックボックスや確認ダイアログを必須にするか**  
  **必須にする。** Role History を更新する場合は「上記の役割変更を member_roles に反映する」チェックを付け、確認ダイアログで「現在の役職を閉じ、新しい役職を開始します」と明示する。

- **安全性を優先し、Role History は最初は自動反映せず確認のみとするか**  
  **とする。** 第一歩では役割変更候補の **表示のみ**。確定反映は別 Phase または「Role History を更新する」を明示的に選んだ場合のみとする。

---

## 9. データ要件案

- **members に現在役割を持っているなら、その更新ルール**  
  members は現在役割を持たない（member_roles が正）。更新ルールは member_roles への insert / 既存行の term_end 更新に集約する。

- **role history テーブル（member_roles）への insert / close のルール**  
  - **close:** 役割変更を確定するとき、現在の「term_end 未設定」の member_role に term_end = 確定日（または CSV 反映日）を設定する。  
  - **insert:** 新しい役職を開始するとき、role を firstOrCreate し、member_roles に member_id, role_id, term_start = 確定日, term_end = null を insert する。  
  - **同じ役職が継続:** CSV の役職名が現在の role と一致する場合は **何もしない**（insert しない）。

- **category 変更履歴が必要か**  
  第一歩では **不要**。members.category_id の上書きのみ。将来必要なら別テーブルを検討。

- **CSV import と participants / members / role history の更新ログを関連づけるか**  
  **関連づけるとよい。** meeting_csv_imports に imported_at / applied_count があるように、**members 更新件数** や **role_history_updated（boolean または件数）** を残すと監査しやすい。第一歩では participants 反映件数のみでも可。拡張として「この反映で members を N 件更新、role_history を M 件更新」を記録する。

- **rollback / audit の必要性**  
  第一歩では **rollback は必須としない**。audit は「誰がいつ CSV を反映したか」を imported_at で残す程度。Role History 確定時は「いつ誰が役割変更を反映したか」をログに残すとよい（将来拡張）。

---

## 10. 実装フェーズ案

| Phase | 内容 |
|-------|------|
| **M1** | participants 差分更新（BO 保護）。M7-C4 の D1〜D4 に相当。追加・更新・削除候補、プレビュー、BO 設定済みは削除しない。 |
| **M2** | members 基本情報更新（名前・かな・カテゴリー）。CSV から member 解決時に差分を検知し、プレビューに「member 更新候補」を表示。反映時に members を更新。 |
| **M3** | カテゴリー変更候補のプレビュー。既存 category_id と CSV のカテゴリーが異なる場合に warning と変更候補表示。categories マスタ照合。 |
| **M4** | Role History 差分検知。CSV の役職と現在の member_roles（term_end 未設定）の role を比較し、「役割変更候補」一覧を生成。同じ役職継続の場合は候補に含めない。 |
| **M5** | Role History 更新確認フロー。「役割変更を反映する」チェックと確認ダイアログ。term_end の設定と新規 member_role の insert。同じ役職継続は何もしない。 |
| **M6** | ログ・監査・再反映強化。meeting_csv_imports に members_updated_count / role_history_updated 等を記録。監査用の表示（将来）。 |

---

## 11. 推奨方針

- **まずは participants 差分更新のみ実装（M1）**  
  M7-C4-REQUIREMENTS の推奨方針に沿い、BO 保護と差分プレビューを必須とする。

- **members は名前・かな・カテゴリーのみ更新候補として出す（M2, M3）**  
  反映時に「member 更新候補」を適用する。カテゴリー変更は warning を出し、確認のうえで更新する。

- **Role History は自動更新せず「変更候補を表示するだけ」に留める（M4）**  
  第一歩では役割変更候補の表示のみ。確定反映は M5 で実装するか、別 Phase とする。

- **Role History の確定反映は別フェーズでも可（M5）**  
  候補表示ができたら、その後の「反映する」ボタン・チェック・確認ダイアログは M5 で実装。同じ役職継続では履歴を増やさないルールを守る。

---

## 12. 今後の確認事項

- members の introducer_member_id / attendant_member_id を毎週名簿で上書きするか、participant 単位のみとするか。
- カテゴリー「未登録」を反映時に自動で categories に firstOrCreate するか、事前にマスタ登録を必須とするか。
- Role History 確定時の「確定日」を CSV 反映日とするか、ユーザーが日付を選べるようにするか。
- プレビューと反映を 1 画面で完結させるか、participants / members / role でタブやステップを分けるか。
- PDF 取込と CSV 取込の両方がある場合、members 更新は CSV 反映時のみに限定するか、PDF 反映時にも同様の「member 更新候補」を出すか。

---

## 参照

- [MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md](MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md)
- [MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md](MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md)
- [DATA_MODEL.md](DATA_MODEL.md) §4.2 members, §4.4 roles, §4.5 member_roles
- 既存実装: ApplyMeetingCsvImportService, ImportParticipantsCsvCommand（syncCurrentRole）, Member::currentRole(), MeetingCsvPreviewService
