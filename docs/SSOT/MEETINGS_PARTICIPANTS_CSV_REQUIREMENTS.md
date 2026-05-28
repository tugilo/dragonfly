# Meetings 参加者CSV取込 — 要件整理（ChatGPT作成CSV連携）

**作成日:** 2026-03-17  
**ステータス:** 要件整理たたき台（実装前）  
**関連 Phase:** M7-P11-REQUIREMENTS  
**関連:** [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md), [DATA_MODEL.md](DATA_MODEL.md), 既存 `ImportParticipantsCsvCommand`

---

## 1. 機能概要

ChatGPT 等で作成した参加者 CSV を Meeting に紐づけてアップロードし、確認のうえ `members` / `participants` に反映する。PDF 解析は「候補生成」、CSV は「確定データに近い入力」として扱い、当面の運用を CSV 優先で安定させる。

**実現したいこと**

- 例会ごとに「参加者CSV」を Meeting に紐づけてアップロード・保存できること
- CSV 内容をプレビューし、必要なら修正してから participants（および members）に反映できること
- 既存の PDF 取込・候補編集・反映フローを壊さず、CSV を「もう一つの入口」として追加すること
- 既存 CLI の `dragonfly:import-participants-csv` と仕様を揃え、ロジックの共通化を検討できること

**前提として置かないこと**

- CSV が 100% 正しいこと（人の確認は推奨）
- PDF 解析を廃止すること（将来の高度化に備え残す）

---

## 2. 背景と目的

### 背景

- M7 系で PDF アップロード・ページ判定・候補抽出・編集・反映まで実装済み。一方、PDF 解析だけで「1人=1行」の CSV 相当精度にするには調整コストがまだ高い。
- ChatGPT で PDF から CSV を作成する運用は実績があり、精度も高い。
- 当面は「CSV を正」として取り込み、実運用を安定させたい。将来的に PDF 解析の高度化や OpenAI API による自動構造化も検討する。

### 目的

- CSV アップロードを Meeting に紐づけ、members / participants / 必要に応じて meetings と連携する方式の要件を整理する。
- 業務フロー・画面・データ・CSV 仕様・既存構造との連携・リスク・実装フェーズをたたき台として固める。

---

## 3. 想定ユースケース

| UC | 概要 |
|----|------|
| UC-C1 | 例会前に ChatGPT で PDF から CSV を作成し、Meeting に CSV をアップロードして保存する |
| UC-C2 | アップロードした CSV の内容をプレビューし、誤りがあれば修正してから participants に反映する |
| UC-C3 | CSV を「確定データ」としてそのまま反映する（確認のみで修正は最小） |
| UC-C4 | 既存 members と名前で照合し、マッチした場合は member_id を紐づけ、未マッチは member を新規作成してから participants に反映する |
| UC-C5 | 同じ Meeting に CSV を再アップロードした場合、既存 participants を全置換する |

**誰がいつ使う想定**

- 例会担当者または管理者が、例会前日〜当日に CSV をアップロードし、必要に応じて確認・修正してから「反映」する。CLI 運用から UI 運用へ移行するイメージ。

---

## 4. 業務フロー案（A / B / C）

### 案A: Meeting に紐づけて CSV をアップロード → そのまま participants に反映

- **流れ:** Meeting を選択 → CSV をアップロード → 即時または「反映」ボタンで participants（および members）に反映。プレビューは最小限またはなし。
- **メリット:** 実装が軽い。CLI の `dragonfly:import-participants-csv` に近い。  
- **デメリット:** 誤りがあっても気づきにくい。確認の機会が少ない。

### 案B: Meeting に紐づけて CSV をアップロード → 中身を確認・修正してから participants に反映（推奨）

- **流れ:**  
  1. Meeting を選択し CSV をアップロードして保存  
  2. アップロードした CSV の内容をプレビュー表示（種別・名前・紹介者・アテンド等）  
  3. 必要なら行の追加・削除・修正  
  4. 「participants に反映」で members / participants を更新（全置換）  
- **メリット:** 誤りを減らせる。PDF の「候補 → 確認 → 反映」と似た体験で一貫する。  
- **デメリット:** プレビュー・編集 UI の実装が必要。

### 案C: PDF と CSV を両方保持し、CSV を優先的に participants に反映

- **流れ:** 同一 Meeting に PDF と CSV の両方を紐づけ可能にする。反映時は「PDF 由来候補」と「CSV 由来」のどちらを使うか選択するか、CSV があれば CSV を優先して反映する。
- **メリット:** 原本 PDF と整形済み CSV の両方を残せる。  
- **デメリット:** 二重管理・優先ルールの説明が複雑になる。第一歩としては過剰の可能性。

### 比較まとめ

| 観点 | 案A | 案B | 案C |
|------|-----|-----|-----|
| 実装コスト | 小 | 中 | 大 |
| 確認のしやすさ | 低 | 高 | 中 |
| 運用の分かりやすさ | 高 | 高 | 中（優先ルール要説明） |
| 推奨度（第一歩） | あり（最小実装） | **推奨** | 将来検討 |

**推奨:** 案B。プレビューと簡易修正を挟むことで、ChatGPT 由来の誤りを減らしつつ、確定は人が「反映」で行う形にできる。

---

## 5. 画面要件案

- **導線:** Meetings 一覧または例会詳細 Drawer から「参加者CSV」の導線を置く。既存の「参加者PDF」ブロックの近くに「参加者CSV」ブロックを追加し、PDF と CSV を並列で扱えるようにする。
- **CSV アップロード:** 対象 Meeting を明示したうえで CSV ファイルを選択・アップロード。保存後は「プレビュー」または「反映」へ進める。
- **プレビュー:** アップロード済み CSV の内容を表形式で表示。列は種別・No・名前・よみがな・カテゴリー・役職・紹介者・アテンド等。編集可能にするかは Phase で判断（C2 で読み取りのみ、C3 で編集可能など）。
- **既存候補編集UIとの関係:** PDF 由来の「解析候補」と CSV 由来の「取込データ」は別導線とする。Drawer 内で「参加者PDF」ブロックと「参加者CSV」ブロックを分け、CSV 反映時は「CSV を反映」で participants を更新する。PDF の「候補を編集 → 反映」とは別ボタン・別APIにしてもよい。
- **「PDF由来候補」と「CSV由来」の見せ方:** 同一 Meeting に PDF 解析結果と CSV 取込の両方がある場合、「今回の参加者データは CSV で反映しました」などキャプションで区別できるとよい。または「参加者データの出典: PDF候補 / CSV」を 1 つに絞る運用（CSV 反映時は PDF 候補は参照用に残すかどうかは仕様で決定）。

---

## 6. データ要件案

- **CSV の保存:** Meeting に紐づけて CSV ファイル（またはパス）を保存する。1 Meeting あたり「1 つの CSV」を保持するか、「取込履歴として複数」とするかは方針次第。第一歩は「1 Meeting = 1 CSV」（再アップロードで上書き）でよい。
- **PDF import と CSV import のテーブル:**  
  - **別テーブル案:** `meeting_participant_imports` は PDF 用のままにし、CSV 用に `meeting_participant_csv_imports`（または `meeting_csv_imports`）を新設。file_path, original_filename, parsed_at, parse_status に相当するものを CSV 用に持つ。  
  - **同一テーブル案:** `meeting_participant_imports` に `source_type`（pdf / csv）を追加し、PDF と CSV を同じテーブルで扱う。同一 Meeting に PDF と CSV が両方ある場合は 2 行（または 1 行で file_path と csv_path の両方を持つか）で管理。  
  - **推奨:** 別テーブルにすると PDF フローを触りにくくできる。CSV は「確定に近い」ので、履歴だけ残すなら `meeting_csv_imports` のような新設が分かりやすい。
- **participants 反映:** 既存と同様、全置換方式。CSV 反映時にその Meeting の participants を削除し、CSV の行から members を解決（既存同名 or 新規作成）して participants を insert。introducer_member_id / attendant_member_id は名前で解決。
- **反映履歴:** PDF と同様、CSV 反映日時・反映件数をどこかに残す（例: `meeting_csv_imports.imported_at`, `applied_count`）。M7-P6 の PDF 側 imported_at / applied_count と揃えるか、CSV 専用で持つかは設計で決定。
- **再アップロード / 再反映:** CSV を再アップロードしたら既存 CSV を上書き。再反映時は participants を再度全置換。確認ダイアログは任意。

---

## 7. CSV 仕様案

サンプル（`dragonfly_201_20260317_all_csv.txt` 等）に基づく。

- **必須列:** `種別`, `名前`
- **任意列:** `No`, `よみがな`, `大カテゴリー`, `カテゴリー`, `役職`, `紹介者`, `アテンド`, `オリエン`
- **種別の値:** `メンバー` / `ビジター` / `代理出席` / `ゲスト`。既存 ImportParticipantsCsvCommand の TYPE_MAP に合わせる（代理出席 → participants.type = proxy, members.type = guest 等）。
- **区分と participants.type:** メンバー → regular, ビジター → visitor, ゲスト → guest, 代理出席 → proxy。
- **名前・よみがな・カテゴリー:** members の name, name_kana, category_id に反映。カテゴリーは大カテゴリー・カテゴリーで categories マスタを firstOrCreate。
- **紹介者・アテンド:** 名前で既存 member を検索し、introducer_member_id / attendant_member_id に設定。同一 CSV 内の先行行で解決できるようにする（既存コマンドと同様）。
- **オリエン:** 現行 DATA_MODEL にはオリエン用カラムなし。読み飛ばすか、将来拡張で保持するか。第一歩では読み飛ばしでよい。
- **形式:** UTF-8（BOM あり可）。ヘッダー行必須。1 行 = 1 人。空行はスキップ。
- **1人=1行:** 原則として 1 行 1 名。複数紹介者・アテンドは 1 セルに「A、B、C」のように入っている想定で、先頭 1 名だけ解決するか、複数対応は将来とする。

---

## 8. 既存構造との連携整理

- **members:** CSV の 1 行ごとに、種別・display_no（メンバーは No、ビジターは V1…、ゲストは G1…、代理は P1…）をキーに updateOrCreate。name, name_kana, category_id, type, introducer_member_id, attendant_member_id を更新。役職は roles / member_roles に同期（既存コマンドの syncCurrentRole と同様）。
- **participants:** meeting_id + member_id をキーに updateOrCreate。type, introducer_member_id, attendant_member_id を設定。
- **meetings:** CSV 取込時は「既存の Meeting に紐づける」前提。Meeting が無ければ作成するかは仕様次第（CLI は firstOrCreate）。UI では「Meeting を選択してから CSV をアップロード」とするなら、Meeting は既にある想定でよい。
- **既存 ImportParticipantsCsvCommand:** ロジック（readCsvRows, TYPE_MAP, resolveOrCreateMember, resolveCategoryId, resolveMemberIdByName, Participant::updateOrCreate）を Service に切り出し、CLI と Web アップロードの両方から呼べるようにする。共通化を推奨。
- **PDF 解析フローとの関係:** PDF は「候補」、CSV は「確定に近い入力」。CSV を反映した場合、PDF 解析結果（extracted_result）は上書きしない。表示上「参加者データの出典」を CSV と分かるようにするか、PDF 候補は参照用として残すかは運用で決める。

---

## 9. リスク・論点

| 論点 | 整理 |
|------|------|
| ChatGPT 由来 CSV の誤り | 表記ゆれ・抜け・重複があり得る。案B のプレビュー・修正で軽減。反映前に件数・種別内訳を表示するとよい。 |
| 同じ人が別表記で来る場合 | 名前完全一致で member を検索しているため、表記が違うと別 member になる。将来的に名前正規化・あいまいマッチを検討。第一歩では CSV 側で表記を揃える運用。 |
| CSV を正とするリスク | 誤った CSV を反映すると participants が壊れる。反映前にプレビューと確認、可能なら「反映前にバックアップ」や「再反映で上書き」で復旧可能にする。 |
| PDF と CSV の二重管理 | 同一 Meeting に PDF と CSV が両方ある場合、「どちらを反映したか」を分かるようにする。CSV 反映時は PDF 候補は「参考」として残し、再反映は CSV で行う運用にすると整理しやすい。 |
| CSV アップロード後に PDF 解析結果が残っている場合 | PDF 解析結果（extracted_result）はそのまま残す。表示では「参加者PDF」と「参加者CSV」を別ブロックにし、CSV を反映したら「参加者データは CSV で反映済み」などと表示する。 |
| 優先ルール | 「CSV があれば CSV を優先して表示・反映する」「PDF は候補のみ」と明文化すると運用が分かりやすい。 |

---

## 10. 実装フェーズ案

| Phase | 内容 |
|-------|------|
| **C1** | Meeting に CSV をアップロードして保存する。API: POST .../meetings/{id}/participants/csv-import（または類似）。ストレージに CSV を保存し、取込レコード（新テーブルまたは meeting_participant_imports 拡張）に file_path 等を保存。 |
| **C2** | アップロードした CSV の内容をプレビュー表示する。GET で取込レコードと CSV パース結果を返し、Drawer 内で表表示。 |
| **C3** | CSV 内容を members / participants に反映する。既存 ImportParticipantsCsvCommand のロジックを Service 化し、Web から呼び出す。全置換。 |
| **C4** | 反映履歴（imported_at, applied_count）と再反映ルールを整理。CSV 再アップロード・再反映時の挙動を確定。 |
| **C5** | PDF 解析フローとの統合整理。Drawer で「参加者PDF」と「参加者CSV」の両方を表示し、出典と反映状態を分かりやすくする。 |

---

## 11. 推奨方針

- **第一歩:** 「Meeting に CSV をアップロード → プレビューで確認 → 全置換で participants に反映」（案B + C1〜C3）。
- **CSV を「確定データ」に近いものとして扱う:** プレビューで明らかな誤りを直し、反映は人がボタンで実行する。PDF 解析は「候補生成」に留め、運用では CSV を優先する。
- **既存 PDF フローは残す:** 廃止せず、将来の PDF 解析高度化や API 連携に備える。CSV と PDF は「二つの入口」として並列で用意する。
- **CLI との共通化:** ImportParticipantsCsvCommand のパース・Member 解決・Participant 更新を Service に抽出し、CLI と Web の両方から利用する。

---

## 12. 今後の確認事項

- CSV を保存するストレージ場所（local / S3）とファイル名規則（Meeting ごと 1 ファイルか、履歴で複数か）。
- 同一 Meeting に PDF と CSV の両方がある場合の UI 表示順・ラベル（「参加者PDF（候補）」「参加者CSV（反映済み）」など）。
- プレビュー画面で行編集をどこまで許容するか（読み取りのみ / 種別・名前の修正 / 紹介者・アテンドの修正）。
- オリエン列を DB に持つか、将来拡張で introducer と別のカラムを用意するか。
- C1 実装時に既存 Meetings 一覧・Drawer・PDF 取込を壊さないことを DoD に含める。

---

## 参照

- [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md)
- [DATA_MODEL.md](DATA_MODEL.md) §4.2 members, §4.7 participants
- [REQUIREMENTS_MEMBERS_CSV_200.md](../networking/bni/dragonfly/REQUIREMENTS_MEMBERS_CSV_200.md)
- 既存実装: `App\Console\Commands\ImportParticipantsCsvCommand`
- サンプルCSV: `www/database/csv/dragonfly_201_20260317_all_csv.txt`
