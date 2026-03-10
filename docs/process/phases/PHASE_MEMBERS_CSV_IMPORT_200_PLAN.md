# PHASE Members CSV Import 200 — PLAN

**Phase:** Members CSV Import 200（第200回参加者CSV 汎用Artisanコマンド）  
**Phase Type:** implement  
**作成日:** 2026-03-10  
**Related SSOT:** docs/SSOT/DATA_MODEL.md, docs/networking/bni/dragonfly/REQUIREMENTS_MEMBERS_CSV_200.md

---

## 1. Purpose

第200回（2026-03-10）の参加者CSV（`dragonfly_59people.csv`）を DB に取り込むため、**第200回専用ではなく今後も再利用できる汎用 Artisan コマンド**を実装する。UI や管理画面アップロードは行わず、コマンドラインからのインポートに限定する。

---

## 2. Background

- 要件整理は [REQUIREMENTS_MEMBERS_CSV_200.md](../../networking/bni/dragonfly/REQUIREMENTS_MEMBERS_CSV_200.md) に記載済み。
- 現状は [DragonFlyMeeting199Seeder](../../../www/database/seeders/DragonFlyMeeting199Seeder.php) が PHP 配列で第199回のみ投入しており、CSV 読み込みは未実装。
- 本 Phase では **dragonfly:import-participants-csv** コマンドを新設し、回番号・CSV パス・開催日オプションで任意回の参加者を投入できるようにする。

---

## 3. Related SSOT

| Spec / Doc | 内容 |
|------------|------|
| docs/02_specifications/SSOT_REGISTRY.md | 仕様起点 |
| docs/SSOT/DATA_MODEL.md | members / participants / categories / roles / member_roles 定義。participants.type の値域（regular, absent, guest, proxy）。同室集計で absent/proxy 除外。 |
| docs/networking/bni/dragonfly/REQUIREMENTS_MEMBERS_CSV_200.md | 第200回CSV要件・種別対応・DoD 案。 |

---

## 4. Scope

### 4.1 実装するもの

- 汎用 Artisan コマンド `dragonfly:import-participants-csv`
- CSV 読み込み（ヘッダー・エンコーディング・空行スキップ）
- meeting の取得／作成（number + held_on）
- members の解決／作成／更新（名前・よみがな・category_id・type・display_no・introducer_member_id・attendant_member_id）
- categories 解決（大カテゴリー → group_name、カテゴリー → name）
- roles / member_roles 解決（役職 → 現在役職として登録）
- participants 登録（meeting_id, member_id, type, introducer_member_id, attendant_member_id）
- 未解決時の warning 出力（紹介者・アテンド・カテゴリ等）
- テスト（正常系・warning 系・再実行系）

### 4.2 実装しないもの

- 管理画面からの CSV アップロード
- オリエン列の DB 保存（読むが保存しない）
- 既存 UI 改修
- breakout / summary ロジックの変更
- 第199回 Seeder の置き換え・削除

---

## 5. Target Files

| 種別 | パス |
|------|------|
| 新規 | `www/app/Console/Commands/ImportParticipantsCsvCommand.php`（または App\Console\Commands 配下の適切な名前） |
| 新規 | `www/tests/Feature/ImportParticipantsCsvCommandTest.php`（または Unit。判断に従う） |
| 変更 | なし（コマンド登録は Laravel の discovery または Kernel で行う） |
| 参照のみ | `www/database/seeders/DragonFlyMeeting199Seeder.php`, `www/app/Models/Member.php`, `www/app/Models/Participant.php`, `www/app/Models/Category.php`, `www/app/Models/Role.php`, `www/app/Models/MemberRole.php`, `www/app/Models/Meeting.php` |

---

## 6. Implementation Strategy

### 6.1 コマンド仕様

- **シグネチャ案:**  
  `php artisan dragonfly:import-participants-csv {meeting_number} {csv_path} [--held_on=YYYY-MM-DD]`
- **引数**
  - `meeting_number`: 定例会回番号（例: 200）
  - `csv_path`: CSV ファイルパス（絶対または `storage_path()` / `database_path('csv')` からの相対）
- **オプション**
  - `--held_on`: 開催日（YYYY-MM-DD）。省略時は当日または meeting 既存値のまま（方針を実装時に固定する）

### 6.2 meeting 解決

- `Meeting::firstOrCreate(['number' => $meetingNumber], ['held_on' => $heldOn, 'name' => "第{$meetingNumber}回定例会"])` に準拠。
- 既存の [DragonFlyMeeting199Seeder] の `Meeting::updateOrCreate(['number' => 199], [...])` と同様に、存在しなければ作成、存在すれば held_on / name はオプションで更新可能とする（コマンドでは `--held_on` 指定時のみ更新するなど、最小限のルールでよい）。

### 6.3 CSV 読み込み

- 1行ずつ読み、ヘッダー行で列名を解決する。
- 必須列: 種別, 名前（No はメンバー以外は空可）。
- エンコーディング: UTF-8 を優先し、BOM や Shift_JIS の可能性があれば検出またはオプションで指定できるようにする（実装時に UTF-8 のみで DoD を満たし、他は REPORT に「将来対応」と残すでも可）。
- 空行はスキップ。必須列が欠けている行はエラーで停止するか、warning でスキップするかを Task で決める（推奨: ヘッダー不足はエラー、行の必須列不足は warning でスキップ）。

### 6.4 種別マッピング（固定）

| CSV 種別 | members.type | participants.type |
|----------|--------------|--------------------|
| メンバー | member | regular |
| ビジター | visitor | visitor |
| ゲスト | guest | guest |
| 代理出席 | guest | proxy |

- **理由（participants.type）:** DATA_MODEL §4.7 では regular / absent / guest / proxy。既存 Seeder は member / visitor / guest を使用しているが、同室除外は `absent` / `proxy` のみ。今回からメンバーは **regular** に統一し、代理出席は **proxy** に統一する。既存第199回は触らない。
- **理由（members.type 代理出席）:** DATA_MODEL §4.2 の members.type 値域は active / inactive / guest。BNI 運用で member / visitor / guest を使用。proxy は participants 側の概念のため、**代理で出席した人物**は members 上は **guest** で 1 件登録する。

### 6.5 display_no 方針

- **メンバー:** CSV の No をそのまま `display_no` に使用。
- **ビジター / ゲスト / 代理出席:** No が空のため、既存 [DragonFlyMeeting199Seeder] に合わせて **ビジターは V1, V2, V3**（出現順）、**ゲストは G1**、**代理出席は P1** のようにプレフィックス＋連番で生成する。

### 6.6 categories 解決

- **方針:** CSV の「大カテゴリー」「カテゴリー」を `categories.group_name` と `categories.name` にマッピングする。
- **未登録時:** **firstOrCreate で自動作成する。** 既存 DragonFlyMeeting199Seeder の `resolveCategoryId` が 1 列で (group_name, name) を同じ値で firstOrCreate しているのと同様に、import を止めずにマスタを拡張する。大カテゴリー・カテゴリーが両方空の場合は `category_id = null` とし、warning を出さない（意図的な空とみなす）。

### 6.7 roles / member_roles

- **方針:** CSV の「役職」が空でない場合、`Role::firstOrCreate(['name' => $役職名])` でロールを確保し、`MemberRole` で「現在の役職」として登録する。
- **既存との整合:** [DragonFlyMeeting199Seeder] の `syncCurrentRole` と同様に、既存の term_end=null の member_roles を一度 term_end=今日で閉じ、新規に term_start=今日・term_end=null の 1 件を追加する。
- **役職が複数ある場合（例: 「BODコーディネーター/メンターサポート」）:** 1 つにまとめて 1 つの role name とするか、複数 role に分割するかは **今回は「1 行を 1 つの role name として firstOrCreate」に統一する。** スラッシュ区切りは 1 つの名前として登録する（既存 Seeder も同様）。

### 6.8 紹介者 / アテンド

- **保存先:** 既存スキーマどおり、**members** の `introducer_member_id` / `attendant_member_id` と、**participants** の `introducer_member_id` / `attendant_member_id` の両方に保存する（DragonFlyMeeting199Seeder は members にのみ設定し、participants にも同じ値を渡している）。
- **解決:** 名前の完全一致で既存 members を検索。見つかった member_id を設定。
- **未解決時:** **warning を出し、id は null のまま保存。** import 全体は継続する。

### 6.9 オリエン

- **今回は DB に保存しない。** CSV からは読んでもよいが、いかなるテーブルにも投入しない。REPORT に「オリエン列は今回未対応」と明記する。

### 6.10 participants 再実行ポリシー

- **方針:** **updateOrCreate** を用いる。
- **ユニークキー:** `['meeting_id' => $meeting->id, 'member_id' => $memberId]`
- **挙動:** 同一 meeting ＋ 同一 member が既にいれば、type / introducer_member_id / attendant_member_id を CSV の内容で更新する。いなければ create。これにより再実行時も冪等になり、CSV を差し替えて再実行すれば内容が更新される。既存の他回（例: 第199回）の participants は触らない。

### 6.11 members 解決・作成・更新

- **優先順位:** (1) 名前の完全一致 (2) 同一 type で display_no 一致（メンバーは No 一致）(3) 見つからなければ create。
- **更新対象:** name, name_kana, category_id, type, display_no, introducer_member_id, attendant_member_id。役職は member_roles で別途 sync する。
- **一意性:** 既存 Seeder と同様、`(type, display_no)` または `(type, name)` で updateOrCreate のキーを決める。display_no が空の種別（ビジター・ゲスト・代理）は、生成した display_no（V1, G1, P1 等）で一意化する。

### 6.12 warning 方針

- 未解決の紹介者・アテンド（名前で member が見つからない）→ 1 件ごとに warning。
- 必須列欠損で行をスキップした場合 → warning。
- エンコーディング検出失敗やファイルが開けない場合は **エラーで終了**。warning のみの場合は exit 0 で成功とする。

---

## 7. Tasks

- [ ] **Task1: 調査** — meeting / member / participant / category / role 周りの既存実装を確認し、保存先・一意キー・型を PLAN に反映済みであることを確認する。
- [ ] **Task2: PLAN 確定** — 上記方針で不足がないか確認し、必要なら PLAN を 1 行追記する。
- [ ] **Task3: Artisan コマンド土台** — コマンド名 `dragonfly:import-participants-csv`、引数 meeting_number / csv_path、オプション --held_on、基本バリデーション（ファイル存在・数値）を実装する。
- [ ] **Task4: CSV パーサ** — ヘッダー判定・行ごとの正規化・空行スキップ・必須列チェックを実装する。
- [ ] **Task5: members / categories / roles 解決** — 既存データ照合・firstOrCreate による create/update・syncCurrentRole 相当・warning 出力を実装する。
- [ ] **Task6: participants 登録** — meeting 紐付け・type 設定・updateOrCreate による再実行対応を実装する。
- [ ] **Task7: テスト** — 正常系（59件・種別・proxy・カテゴリ）、warning 系（未解決紹介者等）、再実行系（冪等）のテストを追加する。
- [ ] **Task8: REPORT / WORKLOG 更新** — 変更ファイル一覧・実装内容・テスト結果・残課題を REPORT と WORKLOG に記録する。

---

## 8. DoD（Definition of Done）

- 汎用 Artisan コマンドで第200回 CSV を取り込める。
- 第200回 59 名が意図どおり members / participants に投入される。
- 種別が正しくマッピングされ、proxy が participants.type=proxy で登録される。
- 既存の同室・集計ロジック（MeetingBreakoutService / MemberSummaryQuery）を変更しておらず、既存テストが通る。
- オリエンは取り込まれない。
- warning 方針がコードと PLAN で一致している。
- PLAN / WORKLOG / REPORT が作成され、変更ファイル一覧を報告できる。
- 追加したテストがすべて成功する。

---

## 9. 参照

- [DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.2 members, §4.3 categories, §4.4–4.5 roles / member_roles, §4.7 participants
- [REQUIREMENTS_MEMBERS_CSV_200.md](../../networking/bni/dragonfly/REQUIREMENTS_MEMBERS_CSV_200.md)
- [DragonFlyMeeting199Seeder](../../../www/database/seeders/DragonFlyMeeting199Seeder.php)
- [MeetingBreakoutService](../../../www/app/Services/Religo/MeetingBreakoutService.php)（absent / proxy 除外）
