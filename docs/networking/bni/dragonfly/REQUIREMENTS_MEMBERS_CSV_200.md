# 要件整理：第200回メンバー表 CSV（dragonfly_59people.csv）

**対象:** 2026年3月10日付「第200回」メンバー表を CSV 化した `www/database/csv/dragonfly_59people.csv` を、関連ドキュメント・実装と照らして要件を整理する。  
**作成日:** 2026-03-10

---

## 1. CSV の概要

| 項目 | 内容 |
|------|------|
| **ファイル** | `www/database/csv/dragonfly_59people.csv` |
| **出典** | 2026年3月10日 第200回のメンバー表を CSV 化したもの |
| **ヘッダー** | 種別, No, 名前, よみがな, 大カテゴリー, カテゴリー, 役職, 紹介者, アテンド, オリエン |
| **総行数** | 59 名（ヘッダー除く） |

### 1.1 種別ごとの内訳

| 種別（CSV） | 件数 | 備考 |
|-------------|------|------|
| メンバー | 54 | No 1–54。役職は一部のみ（プレジデント、書記兼会計、BODコーディネーター等）。 |
| ビジター | 3 | 尾関 有賀子、川本 洋平、大須賀 泰昌。紹介者・アテンド・オリエンあり。 |
| 代理出席 | 1 | 山本 昌広（生命保険）。紹介者 竹内 駿太。 |
| ゲスト | 1 | 次廣 淳（システムエンジニア）。紹介者 増本 重孝。 |

※ 第199回（DragonFlyMeeting199Seeder）は メンバー54 + ビジター5 + ゲスト4 の 63 名。第200回は 59 名で種別内訳が異なる。

---

## 2. 関連ドキュメントとの対応

### 2.1 参照すべき SSOT・要件

| ドキュメント | 内容 |
|--------------|------|
| [docs/02_specifications/SSOT_REGISTRY.md](../../02_specifications/SSOT_REGISTRY.md) | 仕様の起点。SPEC-001 のみ登録。 |
| [docs/SSOT/DATA_MODEL.md](../../SSOT/DATA_MODEL.md) | members / participants / categories / roles / member_roles の定義。**CSV 取り込みの実装はこの定義に従う。** |
| [docs/networking/bni/dragonfly/REQUIREMENTS_MEMBER_PARTICIPANTS.md](REQUIREMENTS_MEMBER_PARTICIPANTS.md) | メンバーマスター・参加者・ブレイクアウトの要件。F9 に「参加者一覧のインポート（将来）Markdown/CSV から members + participants を一括投入する補助」と記載。 |
| [docs/SSOT/MEMBERS_MOCK_VS_UI_SUMMARY.md](../../SSOT/MEMBERS_MOCK_VS_UI_SUMMARY.md) | Members 画面のモック vs 実装。一覧表示項目・検索・フィルタ・統計。 |
| [docs/process/phases/PHASE_M4_MEMBERS_LAYOUT_PLAN.md](../../process/phases/PHASE_M4_MEMBERS_LAYOUT_PLAN.md) | Members 画面レイアウト（統計カード・フィルタバー・一覧）の Phase。 |

### 2.2 データモデル（DATA_MODEL）との対応

- **members**  
  - CSV: 種別・No・名前・よみがな・大カテゴリー・カテゴリー・役職・紹介者・アテンド（オリエンは後述）。  
  - DB: `name`, `name_kana`, `category_id`, `type`, `display_no`, `introducer_member_id`, `attendant_member_id`。  
  - 役職は **roles + member_roles** で管理（Phase14 正規化済み）。`members.role_notes` は廃止済み。

- **categories**  
  - CSV の「大カテゴリー」「カテゴリー」→ `categories.group_name` / `categories.name`。  
  - 既存 Seeder の `resolveCategoryId` は「1列のみ」で `(group_name, name)` を同じ値で firstOrCreate している。CSV は大カテゴリと実カテゴリが分離しているため、**CSV 取り込み時は group_name＝大カテゴリー、name＝カテゴリー** でマスタ解決する必要がある。

- **participants**  
  - 1 行 = その回の 1 人の「参加記録」。`meeting_id`, `member_id`, `type`, `introducer_member_id`, `attendant_member_id`。  
  - **participants.type の値域（DATA_MODEL §4.7）:** `regular`（通常参加）, `absent`（欠席）, `guest`（ゲスト）, `proxy`（代理参加）。  
  - CSV 種別との対応: **メンバー → regular**, **ビジター → visitor**, **ゲスト → guest**, **代理出席 → proxy**。  
  - 注意: `members.type` の値域は `active` / `inactive` / `guest`（§4.2）。BNI 運用では「メンバー／ビジター／ゲスト」も使うとある。現行 Seeder は member / visitor / guest を members.type に保存している。**代理出席**は「その回だけ代理で出た人」なので、**participants.type = proxy** とし、members には「山本 昌広」を 1 件（type は guest または別の運用ルール）で登録し、participants で type=proxy とする解釈が DATA_MODEL と整合する。

- **オリエン（CSV 列）**  
  - ビジター行にのみ値あり（例: 小中 貴晃、太田 一誠 等）。  
  - **DATA_MODEL および現行 DB には「オリエン」用カラムはない。** 要件上は「紹介者・アテンド」まで。オリエンは「将来拡張」または「無視して取り込む」のいずれかで方針を決める必要がある。

---

## 3. 実装の現状

### 3.1 参加者データの投入方法

| 方式 | 内容 |
|------|------|
| **DragonFlyMeeting199Seeder** | 第199回（number=199, held_on=2026-03-03）。メンバー54・ビジター5・ゲスト4を **PHP 配列でハードコード**。members / categories / roles / member_roles / participants を updateOrCreate / firstOrCreate で投入。**CSV は読んでいない。** |
| **BniDragonFly199ParticipantsSeeder** | 第199回を Markdown 由来の配列で **create**（上書き前提でない）。 |
| **CSV インポート** | **未実装。** F9（REQUIREMENTS_MEMBER_PARTICIPANTS）で「将来」とされている。 |

### 3.2 既存 CSV ファイル（www/database/csv/）

- `dragonfly_59people.csv` … 第200回 59 名（本ドキュメントの対象）
- `dragonfly_members_20260310_sample.csv` … No, Name, Reading, Category の簡易形式（メンバーのみ・種別なし）
- `dragonfly_members_20260310_p2-4.csv` … 未確認
- `dragonfly_members_full.csv` … 未確認

---

## 4. 種別・用語の対応表

| CSV 種別 | members.type（案） | participants.type（DATA_MODEL） |
|----------|--------------------|----------------------------------|
| メンバー | member | regular |
| ビジター | visitor | visitor |
| ゲスト | guest | guest |
| 代理出席 | （本人は member。代理で出た人は guest 等で 1 件） | proxy |

※ 同室回数・last_contact の算出では、DATA_MODEL 上 **participants.type が absent / proxy の場合は同室に含めない**。代理出席は participants で type=proxy にすれば既存ロジックと整合する。

---

## 5. 要件の整理（やること・やらないこと）

### 5.1 今回の CSV で明確にできること

1. **第200回のメンバー表を DB に反映する**  
   - 第200回の meeting（number=200, held_on=2026-03-10）を 1 件作成し、CSV 59 行を members（必要なら categories / roles / member_roles も）と participants に投入する。

2. **CSV 列と DB の対応**  
   - 種別 → members.type および participants.type（上記対応表）。  
   - 大カテゴリー／カテゴリー → categories の group_name / name でマスタ解決し、members.category_id を設定。  
   - 役職 → roles + member_roles（現在役職）。  
   - 紹介者・アテンド → 名前で member_id を解決し、members / participants の introducer_member_id, attendant_member_id に設定。

3. **代理出席**  
   - 山本 昌広 を members に 1 件（type は guest または運用で決める値）。  
   - 第200回の participants に member_id=山本昌広, type=proxy, introducer_member_id=竹内駿太 で登録する。

4. **オリエン**  
   - 現行スキーマにないため、**今回は取り込まない**（または別 Phase でカラム追加・インポート仕様を検討する）。

### 5.2 実装オプション（どれを採用するかは別判断）

| オプション | 内容 |
|------------|------|
| A | **第200回専用 Seeder** を追加し、`dragonfly_59people.csv` を読み、members / participants / meeting を投入する。DragonFlyMeeting199Seeder と同様に updateOrCreate で冪等に。 |
| B | **汎用 Artisan コマンド**（例: `php artisan dragonfly:import-participants-csv {meeting_number} {csv_path}`）で、回番号と CSV を指定して投入。将来の第201回以降も同じコマンドで回番号・ファイルを変えて使う。 |
| C | 管理画面から CSV アップロードでインポート（F9 の「参加者一覧インポート」の UI 化）。 |

### 5.3 今回スコープ外（やらないこと）

- オリエン列の DB 保存（スキーマ未定義のため）。
- 既存第199回データの上書き・削除（第200回は「追加」の想定）。
- Members 画面の表示仕様変更（M-4 等の Phase で別途実施）。

---

## 6. DoD（完了の定義）案

「第200回メンバー表 CSV を利用する」を完了とする場合の例:

- 第200回の meeting（number=200, held_on=2026-03-10）が 1 件存在する。
- CSV の 59 行が、members（重複は updateOrCreate で更新）と participants（第200回）に正しく反映されている。
- 種別の対応（メンバー→regular、ビジター→visitor、ゲスト→guest、代理出席→proxy）が DATA_MODEL と一致している。
- 紹介者・アテンドが名前解決され、introducer_member_id / attendant_member_id に紐づいている（存在する名前のみ）。
- 大カテゴリー・カテゴリーが categories マスタと整合し、役職が roles / member_roles と整合している。
- 既存の `php artisan test` が通る。

---

## 7. 参照

- [DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.2 members, §4.7 participants, §4.3 categories, §4.4–4.5 roles / member_roles
- [REQUIREMENTS_MEMBER_PARTICIPANTS.md](REQUIREMENTS_MEMBER_PARTICIPANTS.md) F9 参加者一覧インポート
- [DragonFlyMeeting199Seeder](../../../../www/database/seeders/DragonFlyMeeting199Seeder.php) 既存の配列ベース投入ロジック
- [MeetingBreakoutService / MemberSummaryQuery](../../../../www/app/Services/Religo/MeetingBreakoutService.php) における absent / proxy の除外
