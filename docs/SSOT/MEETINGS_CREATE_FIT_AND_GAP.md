# Meetings 新規作成機能 — Fit & Gap（調査まとめ）

**Phase:** MEETINGS_CREATE_FIT_AND_GAP_CHECK（docs）  
**調査日:** 2026-03-19  
**ステータス:** 調査・整理＋**作成・更新実装済**（`POST /api/meetings` — Phase `MEETINGS_CREATE_IMPLEMENT`、`PATCH /api/meetings/{id}` — Phase `MEETINGS_UPDATE_IMPLEMENT`、2026-03-19）。**削除**は未着手。

**関連:** [FIT_AND_GAP_MEETINGS.md](FIT_AND_GAP_MEETINGS.md)、[FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) §5、[DATA_MODEL.md](DATA_MODEL.md) §4.6

---

## 1. 調査目的

- Religo 管理画面の Meetings 周りは、一覧・詳細 Drawer・メモ・CSV/PDF 取込・participants / members / roles 同期まで実装が進んでいるが、**例会エンティティ（`meetings` 行）そのものを管理画面から新規登録する導線**があるか不明確だった。
- 要件・SSOT・モック・過去 Phase・コード・Seeder/CLI を横断し、**「作成機能が必要か」「あれば何が足りないか」**を業務運用の現実とセットで整理する。

---

## 2. 確認した資料・実装

| 種別 | 参照 |
|------|------|
| SSOT / Fit&Gap | `FIT_AND_GAP_MEETINGS.md`、`FIT_AND_GAP_MOCK_VS_UI.md` §5、`MOCK_UI_VERIFICATION.md` §4.3、`DATA_MODEL.md` §4.6 |
| モック | `www/public/mock/religo-admin-mock-v2.html` — `#/meetings`（`#pg-meetings`） |
| Phase 文書 | `PHASE_MEETINGS_LIST_ENHANCEMENT_*`、`ROW_ACTIONS_*`、`DETAIL_DRAWER_*`、`MEMO_MODAL_*`、`TOOLBAR_FILTERS_*`、`STATS_CARDS_*`、`FIT_AND_GAP_FINAL_UPDATE_*`（いずれも例会**作成**をスコープに含めない） |
| API | `MeetingController`（`index` / `stats` / `show` のみ）、`routes/api.php`（meetings の GET と配下リソースのみ） |
| フロント | `app.jsx` — `<Resource name="meetings" list={MeetingsList} />`（create/edit なし）、`MeetingsList.jsx` |
| DB | `2026_03_03_100002_create_meetings_table.php` — `number` UNIQUE、`held_on` 必須、`name` nullable |
| データ投入 | `DragonFlyMeeting199Seeder.php`、`BniDragonFly199ParticipantsSeeder.php`、`ImportParticipantsCsvCommand::resolveMeeting`（`firstOrCreate`） |

---

## 3. 要件確認結果

| 観点 | 結果 |
|------|------|
| **モックに例会「新規作成」導線があるか** | **ない。** `#/meetings` のヘッダ右は「🗺 Connectionsで編集」のみ。ツールバーは検索・フィルタ・件数。一覧・詳細・例会メモモーダルのみ。対照的に `#/one-to-ones` には「＋ 1to1を追加」がある。 |
| **SSOT / FIT_AND_GAP に例会の作成・編集・削除の記述** | **明示的な記述はない。** `FIT_AND_GAP_MEETINGS` は一覧・統計・Drawer・メモ・（拡張で）参加者PDF列など**既存例会の閲覧・操作**が中心。DATA_MODEL §4.6 はスキーマと number 一意・不明時の実装規約のみ。 |
| **過去 Phase のスコープ** | M1〜M6 は「一覧拡張」「行アクション」「Drawer」「メモ」「ツールバー」「統計」とし、**Meeting の CRUD は対象外**（明示的にスコープ外とした記述は少ないが、**未検討・未着手**のまま）。 |
| **業務上の例会の発生想定** | BNI 定例会は**毎週（または定期）**発生するため、システム上は「次の回」の `meetings` 行が**事前または都度**必要。取りうる経路は (1) **管理画面で作成**、(2) **CLI/インポートで `firstOrCreate`**、(3) **Seeder/手動 SQL**、(4) **将来の別システム連携**（未実装）。現リポジトリでは **(2)(3) が実在**する。 |

---

## 4. 現状実装確認結果

| 観点 | 結果 |
|------|------|
| **MeetingController** | `index` / `stats` / `show` のみ。**store / update / destroy 相当なし。** |
| **routes/api.php** | `GET /meetings`、`GET /meetings/stats`、`GET /meetings/{id}` と、メモ・CSV・PDF・breakout 等の**既存 meeting 前提**のルートのみ。**POST/PUT/DELETE meetings 本体なし。** |
| **react-admin** | `meetings` Resource に **list のみ**（Create / Edit リソースなし）。 |
| **MeetingsList.jsx** | 例会行の**新規作成ボタン・フォームなし**。「新規作成」は **CSV 未解決の member/category/role** や **PDF 候補の member** 文脈のみ。 |
| **Seeder / Command** | `Meeting::updateOrCreate` / `firstOrCreate` で投入。**本番運用でも「週次で誰が何をするか」はドキュメント化されていない。** |
| **DB 必須カラム** | `number`（unsignedInteger, **UNIQUE**）、`held_on`（date, **NOT NULL**）、`name`（nullable string） |

---

## 5. Fit（合っている・代替で足りている部分）

- **モックとの整合:** モックにも例会の「＋ 新規」が無いため、**「モック再現」という観点だけなら作成 UI 欠如はギャップに含めにくい**（ただし**運用要件**は別論）。
- **既存機能の前提:** メモ・BO・CSV・PDF はすべて **`meeting_id` が既に存在する**前提で設計されており、その前提のもとで一貫している。
- **代替経路の存在:** `ImportParticipantsCsvCommand::resolveMeeting` が `number` をキーに **`firstOrCreate`** し、`held_on`・`name`（`第{n}回定例会`）を設定。**「CSV インポート CLI からの初回生成」はコード上可能**。
- **DATA_MODEL:** number 一意・held_on 必須が明文化されており、採番・日付ポリシーを決めれば実装の足場は明確。

---

## 6. Gap（足りない・未決の部分）

| 項目 | 内容 |
|------|------|
| **管理画面に例会作成 UI がない** | 運用者がブラウザだけで次回例会を切れない（Seeder/CLI/DB 依存）。 |
| **REST API に meetings の POST/PUT/PATCH/DELETE がない** | フロント・外部連携から例会マスタを増やせない。 |
| **入力バリデーション・業務ルールが API 層に未整備** | 将来追加時に number 重複・未来日 held_on・name フォーマット等をどうするか**未文書化**（CLI は独自ロジック）。 |
| **number 採番ルールがプロダクト合意として未固定** | 手入力 vs 自動（max+1） vs 「チャプター運用表と同期」等。 |
| **name と held_on の関係** | CLI は「第N回定例会」固定。管理画面で任意タイトルにするかは未決。 |
| **CSV 管理画面フローとの接続** | 現在は **「既存 meeting を選んでアップロード」**。**アップロード時に meeting が無ければ作る**フローは無い（案 B の余地）。 |
| **削除・編集** | 子テーブル（participants, breakout, imports 等）が cascade/restrict 混在。**削除ポリシーは未設計**のまま API も無し。 |

---

## 7. 業務フロー観点の整理

| 論点 | 整理 |
|------|------|
| **誰が・いつ例会行を作るか** | チャプター運用では「次回の回番号・日付」が週次で決まる。**管理者または幹事が例会前にシステムへ載せる**のが自然。現状はその役割が **開発者/CLI/Seeder** に寄っている可能性が高い。 |
| **number** | **一意**が DB 制約。自動採番は「最大+1」でよいか、欠番を許すか、は運用と相談。 |
| **held_on** | **未来日を許す**のが一般的（次回予定）。stats の「次回例会」も未来日を想定した表示。 |
| **name** | 表示用。CLI 準拠の自動生成＋編集可、または任意入力、を要件化すべき。 |
| **CSV/PDF と順序** | **meeting 作成 → その meeting に CSV/PDF を紐づける**のが現在の API 形と一致。**「先に取込だけしたい」**場合は meeting 作成または案 B の補助が必要。 |
| **作成後に初めて CSV 同期** | **技術的には問題ない**（participants 0 件の meeting から始められる）。運用上「例会登録と取込のどちらを先に強制するか」はマニュアル化の余地。 |

---

## 8. 実装パターン案（A / B / C）

### 案A: 一覧に「新規作成」— number / held_on / name を入力

| | 内容 |
|---|------|
| メリット | 運用が直感的。API・権限・監査を一箇所に集約しやすい。既存 CSV/PDF フローと「先に meeting」を明示できる。 |
| デメリット | POST/PATCH/DELETE・バリデーション・UI・テストの実装コスト。削除は子データとの整合が重い。 |
| 運用自然性 | **高い**（SaaS 管理画面として期待されやすい）。 |
| 既存構造との整合 | `meeting_id` 前提の API はそのまま活かせる。 |

### 案B: 取込時に meeting が無ければ作成する補助

| | 内容 |
|---|------|
| メリット | 「CSV を上げるだけ」で週次フローを閉じられる可能性。一覧にボタンを増やさない。 |
| デメリット | number/日付を CSV ヘッダや別パラメータからどう取るかの設計が必要。**誤った meeting への紐づけリスク**。 |
| 運用自然性 | 幹事が「名簿だけ先に」ときは有効。完全代替にはなりにくい。 |
| 既存構造との整合 | CLI の `firstOrCreate` と思想は近い。管理画面 API との二系統になる場合はルール統一が必要。 |

### 案C: meetings は Seeder / CLI / 手動 DB のみ（管理画面では作らない）

| | 内容 |
|---|------|
| メリット | 実装増なし。現状のまま開発・検証に集中できる。 |
| デメリット | **本番の週次運用が開発者依存になりやすい**。オンボーディングコスト。 |
| 運用自然性 | 小規模・単一チャプター・インフラに慣れた担当のみなら成立。 |
| 既存構造との整合 | 現状どおり。 |

---

## 9. 推奨方針（現実的な提案）

1. **中長期では「管理画面から例会を新規作成できるべき」（案A を主軸）** とするのが、BNI 週次運用と Religo の「例会管理」ラベルに最も整合する。モックに無いから不要、ではなく、**モックが業務ライフサイクル（次回例会の立ち上げ）まで描いていない**と解釈するのが妥当。
2. **実装は段階的が現実的:**  
   - **第1段:** `POST /api/meetings`（必須: `number`, `held_on`、任意: `name`）＋一覧の「新規例会」Dialog。**編集・削除は別 Phase**（削除はポリシー確定後）。  
   - **number:** 既定は **手入力＋重複時 422**、補助として「次候補（max number + 1）」を GET で返す等はオプション。  
   - **name:** 未指定時は **`第{number}回定例会`** で CLI と揃えるのが一貫しやすい。  
3. **案B** は「CSV アップロード画面で meeting 未選択時に number+日付を入力して自動作成」のような**限定補助**として、案A 後に検討してよい（単独では採番・誤結合のリスクが高い）。  
4. **案C** は**短期の暫定**（現在に近い）として文書化し、「本番運用では案A 相当まで進める」ことを SSOT または運用マニュアルに明記することを推奨。

---

## 10. 次にやるべきこと

| 優先 | 内容 |
|------|------|
| 高 | プロダクト/チャプター側と **「例会行の正の投入経路」** を合意（画面必須か、CLI 継続か）。 |
| 高 | **要件 Phase（docs）** で POST のフィールド・バリデーション・name デフォルト・未来日 held_on・権限を SSOT に追記。 |
| 中 | **implement Phase:** `POST /api/meetings`、MeetingsList の作成 Dialog、Feature テスト。 |
| 中 | **PATCH/DELETE** は participants・imports・cascade の影響表を DATA_MODEL または設計書に書いたうえで別 Phase。 |
| 低 | 案B の要否判断（案A 実装後の UX 改善として）。 |
| 低 | `FIT_AND_GAP_MEETINGS.md` に「例会マスタ CRUD はモック外。運用では作成が必要な場合あり」と注記を追記するか検討。 |

---

**作成ドキュメント:** `docs/process/phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_{PLAN,WORKLOG,REPORT}.md` と本ファイル。
