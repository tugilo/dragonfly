# Meetings 参加者CSV反映 — 差分更新 要件整理たたき台

**作成日:** 2026-03-19  
**ステータス:** 要件整理たたき台（実装前）  
**関連 Phase:** M7-C4-REQUIREMENTS  
**関連:** [MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md](MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md), [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md), [DATA_MODEL.md](DATA_MODEL.md)

---

## 1. 機能概要

参加者CSVを participants / members に反映する際に、**全置換**ではなく**差分更新**方式を採用する場合の要件・設計たたき台を整理する。

**目的**

- CSV 反映時に既存 participants を全削除せず、追加・更新・削除候補を明確にし、BO（ブレイクアウト）割当や手動調整済み情報をできるだけ保護する。
- 業務フロー・データルール・更新ルール・BO 影響・UI/UX・実装フェーズを整理し、安全に反映するための方針を固める。

**前提**

- 実装は行わない。本 Phase は要件整理に徹する。
- 「安全に反映する」ことを最優先とする。

---

## 2. 背景と問題意識

- **現状（M7-C3）:** CSV 反映時に `Participant::where('meeting_id', $meeting->id)->delete()` で当該 meeting の participants を全削除し、CSV の行から participants を再作成している（全置換）。
- **問題:** participant に紐づく **participant_breakout**（BO 割当）は `participant_id → participants.id` で **cascadeOnDelete** のため、participant 削除とともに消える。その結果、反映前に設定済みの BO 割当や、手動で調整した member 紐づけ・紹介者・アテンドが失われる。
- **危険な場面:** 例会後に BO 割当を済ませた状態で、誤って CSV を再反映した場合に BO がすべて消える。または、PDF 候補で手動マッチングしたうえで反映した後に、別の CSV で上書きすると同じ meeting の participant が作り直され、BO が消える。
- **望ましい姿:** CSV を「確定データ寄り」として扱いつつ、既存 participant レコードや BO 割当をできるだけ活かし、追加・更新・削除を明示的に扱う差分更新方式を検討する。

---

## 3. 現状方式（全置換）の整理

### 3.1 何が起きるか

1. 対象 `meeting_id` の既存 **participants** をすべて削除する。
2. CSV の各行（種別・名前が有効なもの）について、member を名前で解決 or 新規作成し、**participants** を新規作成する。
3. `meeting_csv_imports` の当該 import に `imported_at` / `applied_count` を保存する。

### 3.2 何が消える可能性があるか

| 対象 | 消えるか | 理由 |
|------|----------|------|
| **participants** | 全削除 | 明示的に delete している |
| **participant_breakout**（BO 割当） | 消える | participant_id が FK で cascadeOnDelete のため、participant 削除に連動して削除される |
| **introducer_member_id / attendant_member_id** | 消える | participant ごと作り直すため。現状 C3 では null で作成している |
| **手動マッチした member 紐づけ**（PDF 側） | 影響あり | 同一 meeting を CSV で上書きすると participant が作り直され、PDF 由来の matched_member_id は参照されない |
| **imported_at / applied_count** | 上書き | 最新の反映で更新される（履歴は 1 回分のみ） |

### 3.3 どんな場面で危険か

- **BO 割当済みの meeting に CSV を反映した場合:** 全 participant が削除され、BO 割当（participant_breakout）がすべて消える。
- **例会後に「参加者を CSV で更新」したつもりが、意図せず BO も含めて上書きしてしまう場合。**
- **PDF で手動マッチングして反映した後、別の CSV をアップロードして反映すると、同じ meeting の participant が CSV 基準で再作成され、BO が消える。**

### 3.4 なぜ単純で分かりやすいか

- 状態が「CSV の内容そのもの」に一意に定まる。削除→全挿入のため、差分の解釈が不要。
- 実装が短く、バグの入り込みが少ない。M7-P3 / M7-C3 の両方で同じ思想で揃えやすい。

---

## 4. 守りたいデータ / 影響範囲

| 守りたいもの | 説明 | 全置換での扱い |
|--------------|------|----------------|
| **既存 participant レコード** | meeting_id + member_id をキーにした参加者行。BO や紹介者・アテンドの紐づけ元。 | 全削除される |
| **BO 割当** | participant_breakout。どの participant がどの breakout_room にいたか。 | participant 削除で cascade 削除 |
| **introducer / attendant** | participant の紹介者・アテンド。将来 CSV や手動で設定する想定。 | 作り直し時は null（C3 では未設定） |
| **手動修正した member 紐づけ** | PDF 候補で手動マッチした matched_member_id。apply 時にその member_id で participant 作成。 | CSV 反映では「名前」で再解決するため、同一人物なら同じ member に紐づく可能性はあるが、participant 自体は削除される |
| **imported_at / applied_count** | 反映履歴。 | 上書きで残る（最新 1 回分） |
| **会議後に調整した情報** | BO 割当・メモ・その他 meeting に紐づく編集結果。 | BO は participant 削除で消える |

**結論:** 差分更新では「participant を削除しない」または「削除する participant を限定し、BO 設定済みは削除しない」ことで、BO や紹介者・アテンドを守る必要がある。

---

## 5. 差分判定キー案

同一人物とみなすキーを何にするかを整理する。

| 候補 | 内容 | メリット | デメリット |
|------|------|----------|------------|
| **member_id** | CSV 行から解決した member_id と既存 participant の member_id を比較 | 一意で確実。BO は participant に紐づくので participant を更新するだけにできる。 | CSV に同じ人が別名で載っていると別 participant になる。名前変更時は別人扱いになる。 |
| **名前完全一致** | 名前で既存 participant（member.name）と CSV 行を照合 | 実装が分かりやすい。CLI や C3 の「名前で member 解決」と揃う。 | 表記ゆれで別人扱い。同名別人の区別ができない。 |
| **名前 + 種別** | 名前と種別（メンバー/ビジター等）の両方で照合 | 同名で種別が違う別人を区別できる。 | 種別を間違えて修正した場合に「更新」ではなく「削除+追加」になる。 |
| **name_kana 併用** | 名前＋よみがなで照合 | 表記ゆれを減らせる。 | よみがなが未入力の行が多いと使えない。CSV 品質に依存。 |
| **手動マッチ済み member 優先** | PDF 同様、CSV 行に「この行は既存 participant P に対応」を人が紐づける | 確度が高い。 | UI が重い。第一歩としては過剰の可能性。 |

**推奨（現実的な第一候補）**

- **第一候補: member_id を主キーにした「同一 participant 」**
  - CSV の各行から「名前で member を解決 or 新規作成」した結果の **member_id** を取得する（現行 C3 と同じ）。
  - 既存 participants の **member_id** と照合する。一致すれば「その participant を更新」、一致しなければ「新規 participant 追加」。
  - 「CSV に存在しない member_id」を持つ既存 participant は「削除候補」または「残す」のどちらか（後述の案 B/C）。
- **同一人物の判定:** 「CSV 上の 1 行」と「既存 participant 1 件」の対応は **meeting 内で member_id が一意**（participants は meeting_id + member_id UNIQUE）なので、**member_id で一意に対応する**。名前だけが変わっている（表記修正）場合は、CSV 側で同じ member に解決されるなら既存 participant を更新すればよい。別 member に解決された場合は「削除候補の participant（旧）」と「追加の participant（新）」の 2 件になる可能性があるが、それは運用で避ける（CSV で名前を揃える）か、後続 Phase で手動マッチを入れる。

---

## 6. 差分更新ルール案（A / B / C）

### 案A: 全置換（現状維持）

- 既存 participants を全部削除し、CSV から作り直す。

| 観点 | 内容 |
|------|------|
| **メリット** | 実装が単純。状態が CSV と一致する。 |
| **デメリット** | BO 割当・紹介者・アテンド・手動調整がすべて消える。 |
| **BO への影響** | 全 participant 削除により participant_breakout もすべて削除される。 |
| **実装コスト** | 既に実装済み。 |

---

### 案B: 差分更新（追加・更新・未掲載は残す）

- CSV にあるもの: 該当する member_id の participant がいれば **更新**（type 等）、いなければ **追加**。
- CSV にない既存 participants: **削除しない**。そのまま残す。

| 観点 | 内容 |
|------|------|
| **メリット** | BO 割当や手動調整が消えない。安全寄り。 |
| **デメリット** | 「欠席した人」が CSV から外れていても participant は残り続ける。参加者一覧が「CSV + 過去の残り」になり、実態とずれる可能性がある。 |
| **BO への影響** | participant を削除しないため、BO は残る。追加した participant は BO 未割当。 |
| **実装コスト** | 中。追加・更新の分岐と、削除しない仕様の明文化が必要。 |

---

### 案C: 差分更新（追加・更新・未掲載は削除候補）

- CSV にあるもの: 案B と同様に **追加 or 更新**。
- CSV にない既存 participants: **削除候補**とする。即削除はせず、反映前プレビューで「削除候補」として表示し、BO 設定済みの場合は warning を出し、人の確認を経てから削除する（または削除しないオプションを選べる）。

| 観点 | 内容 |
|------|------|
| **メリット** | 参加者一覧を CSV と一致させつつ、削除前に確認できる。BO 設定済みは「削除禁止」や「warning 必須」にできる。 |
| **デメリット** | プレビュー・確認 UI と削除ポリシー（BO ありは削除しない等）の設計が必要。 |
| **BO への影響** | 削除候補のうち、BO 設定済み participant は削除しないルールにすれば BO を保護できる。 |
| **実装コスト** | 大。差分計算・プレビュー API・削除ポリシー・確認フローの実装が必要。 |

---

### 比較まとめ

| 観点 | 案A（全置換） | 案B（未掲載は残す） | 案C（未掲載は削除候補） |
|------|----------------|----------------------|---------------------------|
| BO 保護 | なし（全消え） | あり | あり（削除ポリシー次第） |
| 参加者一覧の一致度 | CSV と完全一致 | CSV + 残り（ずれあり得る） | CSV に寄せられる |
| 実装コスト | 済 | 中 | 大 |
| 運用の分かりやすさ | 高い | 中（残りをどう扱うか要説明） | 中（削除候補の扱い要説明） |
| 推奨度（差分更新を目指す場合） | 現状維持 | 第一歩としてあり | **推奨**（確認を挟むなら） |

---

## 7. BO 影響の整理

### 7.1 participant を削除すると BO にどう影響するか

- **participant_breakout** は `participant_id → participants.id` に **cascadeOnDelete** が設定されている（DATA_MODEL §4.9）。
- したがって、participant を 1 件削除すると、その participant に紐づく **participant_breakout の行がすべて削除**される。
- つまり、その参加者が属していた BO 割当が消える。**同じ BO に別の participant が残っていれば breakout_room 自体は残る**が、削除した participant の BO 紐づけは消える。

### 7.2 participant を維持したまま属性更新するなら BO は残るか

- **残る。** participant を削除せず、同じ participant 行の `type` や `member_id`（設計上は通常変更しない）を更新するだけなら、participant_id は変わらないため、**participant_breakout はそのまま残る**。

### 7.3 名前変更 / member 差し替え時に BO はどう扱うべきか

- **名前だけ変更（表記修正）:** member は同じで名前だけ更新する場合、participant の member_id はそのままなので、**participant を更新するだけ**でよく、BO は残る（member の name を更新するかは別途）。
- **member 差し替え（別人に紐づけ直す）:** 同じ participant 行の member_id を別の member に変更すると、BO 割当は「見た目では別の人」の同室履歴になる。データ的には participant_id が同じなので BO は残るが、業務意味としては「別人を同じ席にした」ことになる。通常は **participant を削除して新 participant を追加**する運用の方が分かりやすく、その場合は BO は消える。差分更新では「member_id をキーに同一 participant とみなす」ため、member 差し替えは「旧 participant 削除＋新 participant 追加」に相当する扱いになり、BO は旧 participant に紐づいていた分は消える。

### 7.4 「BO 設定済みの participant は削除禁止」にするべきか

- **推奨:** する方が安全である。削除候補に出しても、**BO に 1 件でも紐づいている participant は自動削除しない**（または「BO ありは削除するか」を明示的に選ばせる）ようにすると、意図せず BO が消えるリスクを減らせる。
- 運用で「BO をやり直す」場合は、別途「BO 割当をクリア」などの機能を検討する。

### 7.5 差分更新と BO 保護の両立

- **追加:** CSV にあり既存にない member_id → 新規 participant 作成。BO は未割当でよい。
- **更新:** CSV にあり既存にもある member_id → 既存 participant の type 等を更新。participant_id 不変のため **BO は残す**。
- **削除候補:** CSV にない既存 participant → 削除する場合、**BO に紐づいていれば削除しない**（または warning のうえユーザーが「削除する」を選んだ場合のみ削除）。これで差分更新と BO 保護を両立できる。

---

## 8. UI / UX 要件案

### 8.1 「participants に反映」前に差分プレビューが必要か

- **推奨: 必要とする。** 追加・更新・削除候補を一覧し、特に「削除候補に BO 設定済みが含まれる」場合は warning を出してから反映させる方が安全。

### 8.2 追加 / 更新 / 削除候補を色分け表示するか

- **推奨: する。** 例: 追加＝緑、更新＝青、削除候補＝黄または赤。BO 設定済みの削除候補はアイコンや注記で「BO あり」と分かるようにする。

### 8.3 BO 設定済みがある場合に warning を出すか

- **推奨: 出す。** 「削除候補に BO 割当済みの参加者が N 名含まれています。削除すると BO 割当が消えます。削除しますか？／BO ありは削除しない」などの選択を用意する。

### 8.4 そのまま反映させるか、確認ダイアログを強化するか

- **推奨: 確認ダイアログを強化する。** 差分件数（追加 N / 更新 M / 削除候補 K、うち BO あり L）を表示し、反映実行前にユーザーが内容を確認できるようにする。

### 8.5 「安全モード」として削除をしない運用が現実的か

- **現実的である。** 案B のように「CSV にない参加者は削除しない」をデフォルトにし、「削除も行う」をオプション（または別ボタン）にすると、誤って BO を消すリスクを減らせる。案C では「削除候補は表示するが、BO ありは削除しない」を安全モードとして採用できる。

---

## 9. データ要件案

### 9.1 participant に差分判定用の追加情報が必要か

- **基本は不要。** 同一 meeting 内で **member_id はユニーク**（participants の meeting_id + member_id UNIQUE）なので、member_id で「追加／更新／削除候補」を判定できる。必要なら「この participant はどの CSV import で追加されたか」を残す `source_csv_import_id` のような項目は将来拡張で検討可能。

### 9.2 import 側に「前回反映スナップショット」が必要か

- **あると便利だが必須ではない。** 差分を「前回反映時点の participant 一覧」と「今回 CSV」で比較する場合、前回の member_id 一覧をどこかに持っておくと再計算しやすい。meeting_csv_imports に `last_applied_member_ids`（JSON 配列）などを保存する案はあり。なくても「現在の participants の member_id 一覧」と「今回 CSV から解決した member_id 一覧」を比較すれば差分は出せる。

### 9.3 CSV import と participant をどう関連づけるか

- **現状:** CSV import は meeting に紐づくだけで、participant とは直接の FK はない。反映時に「その meeting の participants を更新した」という事実は imported_at / applied_count で残している。
- **差分更新後も:** 同じく meeting_csv_imports に imported_at / applied_count を残し、必要なら applied_added / applied_updated / applied_deleted のような内訳を保存する程度でよい。participant 側に csv_import_id を持たせるかは任意（トレース用）。

### 9.4 反映時のログを別テーブルに残すべきか

- **将来検討でよい。** 監査や「誰がいつ何件追加したか」を残すなら、別テーブル（例: meeting_csv_apply_logs）に applied_at, added_count, updated_count, deleted_count, option_safe_mode などを記録する案がある。第一歩では meeting_csv_imports の imported_at / applied_count のみでも可。

### 9.5 rollback までは必要か

- **第一歩では必須としない。** 差分更新で「削除しない」を選んでおけば、追加・更新だけが入り、問題があれば手動で participant を編集する運用で足りる。rollback は後続 Phase で検討する。

---

## 10. 実装フェーズ案

| Phase | 内容 |
|-------|------|
| **D1** | 差分比較ロジックの設計・Service 化。CSV 行から member_id 一覧を取得し、既存 participants の member_id と比較して「追加／更新／削除候補」を返す。BO 紐づけ有無の取得を含める。 |
| **D2** | 反映前プレビュー API と UI。追加・更新・削除候補の件数と一覧（および BO ありフラグ）を返し、Drawer で色分け表示。 |
| **D3** | 安全な差分反映。追加・更新を実行。削除は「削除候補のうち BO なしのみ」または「ユーザーが削除を許可したもののみ」に限定。BO あり participant は削除しない。 |
| **D4** | BO 保護ルールの明文化と UI。BO 設定済み participant を削除候補に含める場合の warning と、「BO ありは削除しない」オプション。 |
| **D5** | 履歴・ログ・再反映の強化。applied_added / applied_updated / applied_deleted の保存、必要なら apply_log テーブル、再反映時の差分プレビュー再表示。 |

---

## 11. 推奨方針

- **第一歩として案C（差分更新・未掲載は削除候補）を採用する。**
- **CSV にない既存 participant は即削除しない。** 削除候補としてプレビューに表示し、ユーザーが確認したうえで削除する（または「削除しない」を選べる）。
- **BO 設定済み participant は削除候補に含めても、実際の削除対象からは外す**（「BO ありは削除しない」をデフォルトとする）。これにより BO が意図せず消えることを防ぐ。
- **反映前に差分プレビューを必須とする。** 追加・更新・削除候補の件数と、BO ありの有無を表示し、確認後に反映実行する。

---

## 12. 今後の確認事項

- 削除候補を「その場で削除する」と「削除候補として残し、別操作で削除」のどちらを標準にするか。
- 「安全モード」（削除を行わない）をデフォルトにするか、オプションにするか。
- PDF 候補の apply と CSV の apply で、同一 meeting に対して「どちらを正とするか」の運用（CSV 反映後に PDF 反映すると上書きになる等）。
- 監査ログ・imported_by の要否とスコープ。

---

## 参照

- [MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md](MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md)
- [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md)
- [DATA_MODEL.md](DATA_MODEL.md) §4.7 participants, §4.9 participant_breakout
- 既存実装: ApplyMeetingCsvImportService, ApplyParticipantCandidatesService, MeetingController, MeetingsList.jsx
