# ドキュメント INDEX

このファイルは **docs/ 以下のドキュメント一覧と管理ルール** を定義する INDEX です。  
**ドキュメントを追加・変更・削除したら、必ずこの INDEX を更新すること。**

---

## 更新ルール（必須）

- 新しいドキュメントを追加したら、この INDEX の「一覧」に追記する。
- **進捗ファイル（<プロジェクト名>_progress.md）を更新したら、この INDEX の一覧に含まれていることを確認する。**
- ドキュメントを移動・リネーム・削除したら、この INDEX を整合する。

---

## 一覧

### 進捗（docs/ 直下）

進捗は **必ず** `docs/<プロジェクト名>_progress.md` に記録する。このプロジェクトの進捗ファイルは以下。

| ファイル | 説明 |
|----------|------|
| [dragonfly_progress.md](dragonfly_progress.md) | 本プロジェクトの進捗。Phase ・作業内容をここに追記する。 |

### その他（docs/）

| ファイル | 説明 |
|----------|------|
| [INDEX.md](INDEX.md) | 本ファイル。ドキュメントの索引と更新ルール。 |
| [GIT_WORKFLOW.md](GIT_WORKFLOW.md) | Git ブランチ運用ルール（main / develop / feature / hotfix、1push 原則、**PRレス取り込み**）。SSOT。 |
| [DEPLOYMENT.md](DEPLOYMENT.md) | **GitHub Actions デプロイ**（tugilo_site 同一 VPS。develop→`/var/www/laravel/religo_dev`、main→`religo_app`）。Secrets・`www/public` の指し方。 |
| [PROJECT_NAMING.md](PROJECT_NAMING.md) | プロジェクト命名（Religo＝プロダクト名、DragonFly＝チャプター名、dragonfly＝リポジトリ名）。 |
| [AI_TOOLING.md](AI_TOOLING.md) | **AI 開発 SSOT（Cursor / Claude Code 共通）**。DevOS・Docker・Git・命名・禁止事項・ツール使い分け。Claude Code 入口: `CLAUDE.md`、Skills 12 本: `.claude/skills/`（一覧: `.claude/skills/README.md`）。 |

### エクスポート・参考資料（docs/pdf/）

日付フォルダに保存する PDF・CSV（例会・エクスポートのバックアップ）。

| ファイル | 説明 |
|----------|------|
| [pdf/260414/キッズマネースクール紹介チラシ.pdf](pdf/260414/キッズマネースクール紹介チラシ.pdf) | キッズマネースクール紹介チラシ。 |
| [pdf/260421/定例会参加者リスト2026_04_21.pdf](pdf/260421/定例会参加者リスト2026_04_21.pdf) | DragonFly 定例会参加者リスト（2026-04-21）。 |
| [pdf/260421/dragonfly_206_20260421_all_full.csv](pdf/260421/dragonfly_206_20260421_all_full.csv) | メンバー一覧 CSV エクスポート（`www/database/csv/` の同名ファイルと同内容の参照用）。 |
| [pdf/260518/定例会参加者リスト2026-05-19.pdf](pdf/260518/定例会参加者リスト2026-05-19.pdf) | DragonFly 定例会参加者リスト（2026-05-19・第208回）。 |
| [pdf/260518/dragonfly_208_20260519_all_full.csv](pdf/260518/dragonfly_208_20260519_all_full.csv) | 定例会参加者 CSV（第208回・`www/database/csv/` 同名参照可）。 |
| [pdf/260526/定例会参加者リスト2026_05_26.pdf](pdf/260526/定例会参加者リスト2026_05_26.pdf) | DragonFly 定例会参加者リスト（2026-05-26・第209回）。 |
| [pdf/260526/dragonfly_209_20260526_corrected_full.csv](pdf/260526/dragonfly_209_20260526_corrected_full.csv) | 定例会参加者 CSV（第209回・`www/database/csv/` 同名参照可）。 |
| [pdf/260609/[NE]DragonFly_新基準MTLR(半年)_5月.pdf](pdf/260609/[NE]DragonFly_新基準MTLR(半年)_5月.pdf) | **PALMS 新基準 MTLR（半年・5月）**。パワーチーム WS（2026-06-10）で PT 候補評価に参照。 |
| [pdf/260609/100点までの道のり_5月.pdf](pdf/260609/100点までの道のり_5月.pdf) | DragonFly **100点までの道のり**（5月版）。 |
| [pdf/260623/定例会参加者リスト2026_06_23.pdf](pdf/260623/定例会参加者リスト2026_06_23.pdf) | DragonFly 定例会参加者リスト（2026-06-23・第212回）。 |
| [pdf/260623/dragonfly_212_20260623_all_full.csv](pdf/260623/dragonfly_212_20260623_all_full.csv) | 定例会参加者 CSV（第212回・`www/database/csv/` 同名参照可）。 |
| [pdf/260623/728162322_28119126191007384_3754338031899008407_n.png](pdf/260623/728162322_28119126191007384_3754338031899008407_n.png) | 第212回定例会 BOR 部屋割り画像。 |

### 開発 DB 同期（Git）

| ファイル | 説明 |
|----------|------|
| [../www/database/sync/README.md](../www/database/sync/README.md) | **ローカル MariaDB を Git 同期** — 固定ファイル `dragonfly.sql` を上書き export/import。`make db-export` / `make db-import`。 |
| [../www/database/sync/dragonfly.sql](../www/database/sync/dragonfly.sql) | 開発 DB ダンプ（常に同名上書き・private リポジトリ前提）。 |

### 打合せ・会議メモ（docs/meetings/）

| ファイル | 説明 |
|----------|------|
| [meetings/README.md](meetings/README.md) | **直下・`chapter/`・`team/`・`webmaster/`・`1to1/` の役割分担**（定例会・チームMTG・Webマスター・1to1・提案書）。 |

#### チャプター定例会（docs/meetings/chapter/）

| ファイル | 説明 |
|----------|------|
| [meetings/chapter/README.md](meetings/chapter/README.md) | **定例会議事録の命名**（`chapter_weekly_YYYYMMDD.md`）・YAML・Religo 連携メモ。 |
| [meetings/chapter/chapter_weekly_20260512.md](meetings/chapter/chapter_weekly_20260512.md) | **DragonFly 定例会 第207回 2026-05-12**（Zoom）。3週間ぶりの開催。藤井恵理子更新承認、吉田俊之一時退会、清原佳彩美カテゴリー変更、教育「エレベーターピッチ」、MP大竹絵理香（家族も使える福利厚生）/清原佳彩美（サロン向け育毛機器・商材販売）、ビジター6名・ゲスト2名。文字起こし由来の数値不整合は要確認として記録。 |
| [meetings/chapter/chapter_weekly_20260519.md](meetings/chapter/chapter_weekly_20260519.md) | **DragonFly 定例会 第208回 2026-05-19**（Zoom）。参加65・RF118・西岡MP・教育「紹介しやすい人」・増本SS。決定: グロビジ補助8/21・フォーラム締切 **5/22**・対面ランチ二次会表明 **5/26** まで。 |
| [meetings/chapter/chapter_weekly_20260526.md](meetings/chapter/chapter_weekly_20260526.md) | **DragonFly 定例会 第209回 2026-05-26**（Zoom）。参加56・RF110・新メンバー2名承認（米沢・森園）・MP木村・中村・教育「紹介の解像度を上げる」・小中SS。次廣招待ビジター石原氏フォロー対象。 |
| [meetings/chapter/chapter_weekly_20260602.md](meetings/chapter/chapter_weekly_20260602.md) | **DragonFly 定例会 第210回 2026-06-02**（Zoom）。RF146（内部16・外部130）・新メンバー木村アンナ承認・畑山/今西更新承認・MP田渕（庵治石）/松倉（エアロゲル透明断熱フィルム）・教育「3週間の配球」・次廣RF 9件で今週1位。 |
| [meetings/chapter/chapter_weekly_20260609.md](meetings/chapter/chapter_weekly_20260609.md) | **DragonFly 定例会 第211回 2026-06-09**（Zoom）。RF134（内部19・外部115）・新規八田奈緒美・更新竹内駿太・MP倉持/佐藤・教育「バレーボールローテーション」・清原RF15件で1位・久米→原田約900万円RF確認・増本→次廣推薦の言葉・部屋9デモBOR。 |
| [meetings/chapter/chapter_weekly_20260616.md](meetings/chapter/chapter_weekly_20260616.md) | **DragonFly モメンタムトレーニング 2026-06-16**（Zoom）。**定例会回数外**（9回目扱い）。前回定例会=第211回、次回=第212回（6/23予定）。メンバー53名（八田欠席）・ビジター/ゲストなし。 |
| [meetings/chapter/chapter_weekly_20260623.md](meetings/chapter/chapter_weekly_20260623.md) | **DragonFly 定例会 第212回 2026-06-23**（Zoom）。RF160（内部31・外部129）・岡元智美3年目更新・MP船津麻理子/次廣淳・教育「送りバント」・清原佳彩美SS・横山尚武→小中貴晃推薦の言葉・参加人数/統計差分は要確認として記録。 |
| [meetings/chapter/chapter_weekly_20260616_momentum_script.md](meetings/chapter/chapter_weekly_20260616_momentum_script.md) | **モメンタムトレーニング進行原稿**（2026-06-16）。BOR 6テーマの冒頭・各室ガイド・締め。 |
| [meetings/chapter/chapter_weekly_20260616_momentum_bor_tsugihiro.md](meetings/chapter/chapter_weekly_20260616_momentum_bor_tsugihiro.md) | **モメンタム BOR — 次廣個人原稿**（2026-06-16）。6テーマ各30秒版。メインプレ §4.1 反映。 |
| [meetings/chapter/chapter_bod_20260728.md](meetings/chapter/chapter_bod_20260728.md) | **DragonFly BOD 2026-07-28**（月）。**定例会回数外**。半期イベント。プレースホルダー。 |
| [pdf/260616/dragonfly_momentum_20260616_members_only.csv](pdf/260616/dragonfly_momentum_20260616_members_only.csv) | モメンタムトレーニング参加者 CSV（メンバーのみ・八田欠席）。 |

#### チーム MTG（docs/meetings/team/）

| ファイル | 説明 |
|----------|------|
| [meetings/team/README.md](meetings/team/README.md) | **チーム MTG 議事録の命名**（`team_<slug>_YYYYMMDD.md`）・YAML・**SPEC-018** DB 連携（`import-team-minutes`・未実装）。 |
| [meetings/team/team_threebiz_20260609.md](meetings/team/team_threebiz_20260609.md) | **スリーバイス チームMTG 2026-06-09**（火 8:00–8:45 JST・Zoom）。**BOD（7/28）** 向け40人リスト戦略・チーム目標ビジター3〜4名・入会率10%・メンバー別リストレビュー・推薦の言葉・大名優勝特典。次廣×石原氏はチーム目標の半分見込み。 |
| [meetings/team/team_threebiz_20260616.md](meetings/team/team_threebiz_20260616.md) | **スリーバイス チームMTG 2026-06-16**（火 8:00–・早期解散）。モメンタム週・カテゴリー設定ガイドライン・来週以降パーソナル軸セッション決定・横山氏カテゴリー変更提出方針。 |
| [meetings/team/team_threebiz_20260623.md](meetings/team/team_threebiz_20260623.md) | **スリーバイス チームMTG 2026-06-23**（火 8:00–8:45 JST・Zoom）。横山尚武さんのパーソナル軸共有回。辻堂・バンコク生活、不動産営業、ベンチャー/Uber Eats 展開、AI教育事業ダッシュキャンプ、家族・価値観、BNIとの親和性、次回次廣回を整理。 |
| [meetings/team/team_threebiz_20260630.md](meetings/team/team_threebiz_20260630.md) | **スリーバイス チームMTG 2026-06-30 準備稿**（火 8:00–8:45 JST・Zoom予定）。次廣によるReligo共有メインスピーカー回。PDFプレゼン資料14枚に合わせたスライド順の20分話者原稿、Religoの読み方（レリゴ）・発音記号風のつかみ・`ligo` はラテン語で「繋ぐ」という語源、ビジター招待の貢献と週2リファーラル目標、記憶力を記録力で補う思想、Zoom要約コピペ→AI下書き＋人の確認、A/B/C/Dの紹介経路と二段階リファーラル連鎖、他者121秘匿とつながり可視化、Givers Gain整合、開発ドキュメント照合メモ、図解・絵中心のGensparkスライド生成プロンプト・修正プロンプト。 |
| [meetings/team/team_threebiz_20260602.md](meetings/team/team_threebiz_20260602.md) | **スリーバイス チームMTG 2026-06-02**（火 8:00–8:45 JST・定例会前）。**新メンバー 米澤 侑桂** 加入。**自己紹介・ビジネス紹介**から開始。次廣×米澤 **121 2026-04-08 実施済み**（`one_to_ones.id=12`）。MTG 後追記枠あり。 |
| [meetings/team/team_threebiz_20260519.md](meetings/team/team_threebiz_20260519.md) | **スリーバイス チームMTG 2026-05-19**（火 8:00–8:45 JST・Zoom）。小中氏 AI/Claude Code 共有、BOD ビジター4名選抜（期限 **6/16**）、パワーチーム連携・セキュリティ議論。次廣×小中 ローカルLM 1to1 予定。 |

#### Webマスターチーム（docs/meetings/webmaster/）

| ファイル | 説明 |
|----------|------|
| [meetings/webmaster/README.md](meetings/webmaster/README.md) | **Webマスターチーム議事録の命名**（`webmaster_<topic>_YYYYMMDD.md`）・YAML・関連 1to1 リンク。 |
| [meetings/webmaster/webmaster_handover_20260603.md](meetings/webmaster/webmaster_handover_20260603.md) | **Webマスター業務引き継ぎ 2026-06-03 JST 20:00–21:00**（Zoom）。次廣が倉持から朝礼スライド統合・定例会 Zoom 操作（レコーディング／スポットライト）を引き継ぎ。**初回作業 2026-06-09（月）午前**。AI 協業・リストマーケ・パワーチーム等も議論。 |

#### 1to1 専用（docs/meetings/1to1/）

| ファイル | 説明 |
|----------|------|
| [meetings/1to1/README.md](meetings/1to1/README.md) | **ファイル命名・スラッグ・DB取り込み想定**（`1to1_id` 等）。チャプターを跨ぐ1to1もここに集約。 |
| [meetings/1to1/_TEMPLATE.md](meetings/1to1/_TEMPLATE.md) | 新規1to1用テンプレ（任意 YAML front matter）。 |
| [meetings/1to1/1to1_sato_takuto_brightlink.md](meetings/1to1/1to1_sato_takuto_brightlink.md) | 佐藤 拓斗（株式会社BrightLink）**1to1＋BNIプロフィール統合**（サマリー・第N回・累積・戦略・リファーラル）。第1回 **2026-04-03 JST 07:15–08:15**・Zoom。 |
| [meetings/1to1/1to1_okamoto_kachiteru_present.md](meetings/1to1/1to1_okamoto_kachiteru_present.md) | **岡元智美（RyoTen・筑後市）** 勝てるプレゼン資料作成。プロフィール・推薦文インサイト・リファーラル強化済。第1回2025-03-16・時刻TODO。 |
| [meetings/1to1/1to1_kimura_kengo_mfg_retail.md](meetings/1to1/1to1_kimura_kengo_mfg_retail.md) | **木村健悟（ハート・プランニング／倉敷屋／Tシャツプリント）**。**第2回 2026-06-26 JST 10:00–11:00 実施済み**（Religo id TODO）。自己紹介シート統合済。第2回はTシャツプリント事業の価格感・小ロット/修正/追加注文対応、次廣のReligo（会話上の呼称: Ribo）紹介、BCP支援ツール、木村さんの社内システム導入相談、Tシャツ相見積もり・6/29後のセカンドオピニオン・こうたくんへの声かけを整理。付録に旧システム構想全文（2025-03-12・時刻TODO）。 |
| [meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md](meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md) | **木村秀継（株式会社国宝社／BNI SPREAD）**。**第2回 2026-05-29 JST 14:00–15:00 実施済み**・**Religo `one_to_ones.id=38`**。Zoom要約反映。BPS木村の製本システム（VB+Oracle）改善、PDF注文書の手入力自動化、社内Webインターフェース＋Oracle連携、Hyper-V/Linux、提案書・簡易モック無償作成合意。第1回 2026-05-08。 |
| [meetings/1to1/1to1_kimura_hidetsugu_kokuhosha_requirements_20260529.md](meetings/1to1/1to1_kimura_hidetsugu_kokuhosha_requirements_20260529.md) | **木村秀継 第2回121 要望整理**。株式会社国宝社／BPS木村の製本販売管理システム改善要望を、提案書・簡易モック向けに別紙化。PDF注文書手入力削減、既存VB+Oracle温存、Oracle登録、社内完結型Web、初期スコープ・非スコープ・確認待ち事項を整理。 |
| [meetings/1to1/1to1_tamura_kodai_money_cooking.md](meetings/1to1/1to1_tamura_kodai_money_cooking.md) | **田村広大（お金の料理教室・BNI カーネル）**。**第1回 2026-05-07 JST 15:57〜**（終了時刻 TODO）・Zoom。金融/保険/投資助言、建設業向け損保削減＋DX協業、SE・SEO・FC専門家紹介、次廣の保険/投資相談 Todo を整理。**SEO（垣谷直人）121は 2026-06-04 着地**→ [`1to1_kakiya_naoto_dock.md`](meetings/1to1/1to1_kakiya_naoto_dock.md)。 |
| [meetings/1to1/1to1_shimotsuji_hs_neo_project.md](meetings/1to1/1to1_shimotsuji_hs_neo_project.md) | **下辻（株式会社hsネオプロジェクト・BNI カーネル）**。田村紹介・**同業**。**第1回 Zoom 2026-05-19 JST 14:00〜**（終了・`one_to_ones.id` TODO）。受託7.5割・10名・Claude Code必須・AI3割削減・協力体制（提案複数通過時）・友達申請。士業vs補助金チャネル差。 |
| [meetings/1to1/1to1_tanabe_hikaru_telecom_sns.md](meetings/1to1/1to1_tanabe_hikaru_telecom_sns.md) | **田辺光**（通信・新電力・SNS運用代行）。**船津麻理子**紹介・**第207回（2026-05-12）ゲスト**。**第1回 2026-05-19 JST 16:00–17:00** 予定（議事録・`one_to_ones.id` TODO）。表記「田村光」は名簿照合要確認。 |
| [meetings/1to1/1to1_tsuji_ryo_mainc_meo.md](meetings/1to1/1to1_tsuji_ryo_mainc_meo.md) | **辻亮（株式会社MainC／MEO・SEO・HP・SNS／BNI TRES STELLAS）**。髙月さん121・トレスステラ紹介経由。**第1回 Zoom 2026-05-18 JST 16:00〜**（終了時刻 TODO・`one_to_ones.id = 26`）。NEリージョン・守成クラブ他。**6/5 リージョンフォーラム**名刺交換予定。 |
| [meetings/1to1/1to1_takatsuki_yuuka_eatomslab.md](meetings/1to1/1to1_takatsuki_yuuka_eatomslab.md) | **髙月佑果（イートムラボ／料理教室・ロジカルクッキング／BNI TRES STELLAS）**。**第1回 2026-04-30 JST 09:00–10:00 実施済み**（Religo id TODO）。NCASプロフィールとZoom要約を統合し、包丁の持ち方レッスン、認定講師育成、東京対面レッスン、50代女性向け食と健康レッスン、次廣のAI業務改善システム構築紹介、辻氏（MEO・SNS運用）・平山氏（シングルマザーコミュニティ）・蒲田氏・ウェブデザイナーを軸にした相互紹介方針を整理。 |
| [meetings/1to1/1to1_maeda_referral_imaishi.md](meetings/1to1/1to1_maeda_referral_imaishi.md) | **前田 和良（マーケ・コンサル／実装伴走・群馬／非BNI）**。今西様紹介・**DragonFly・平山氏**経由の接点。**第1回 Zoom 実施済み**（要約反映・**開始終了時刻 YAML TODO**）。思考R診断・AI情報交換・事例共有。**見積レンジ50〜80万円（最小）**等は議事録本文。静岡対面・今西様同席は日程未定。 |
| [meetings/1to1/1to1_fujimoto_yuki_tax_advisor.md](meetings/1to1/1to1_fujimoto_yuki_tax_advisor.md) | **藤本勇輝（BNI トレスステラ／税金アドバイザー）**。船津麻理子さん紹介・**第1回 Zoom 2026-05-21 JST 11:00〜**（終了時刻・正式カテゴリー TODO）。医療クリニック特化税理士、税務セカンドオピニオン、未来会計、次廣の法人化・顧問税理士活用・AI/ITツール活用課題を整理。 |
| [meetings/1to1/1to1_gondo_chiemi_campanula.md](meetings/1to1/1to1_gondo_chiemi_campanula.md) | **権堂千栄実（株式会社Campanula／企業研修・人材育成・業務改善／BNI パッシオーネ PASSIONE）**。**第1回 2026-05-21 実施済み**（開始終了時刻・正式カテゴリー・読み TODO）。建設業/製造業の現場密着支援、タイル技能者育成、マネージャー育成、評価制度、業務フロー改善、リファラルマーケット講座、建設業サポートコミュニティ、次廣との教育設計×システム化の協業可能性を整理。 |
| [meetings/1to1/1to1_nishioka_foreign_trainee.md](meetings/1to1/1to1_nishioka_foreign_trainee.md) | **西岡優希（外国人技能実習生受入れ・育成就労支援／BNI DragonFly）**。**第1回 2026-05-21 JST 14:50〜**（終了時刻・組合名 TODO）。24時間対応・病院付き添い・月1回寮訪問の手厚い実習生支援、建設業の人材不足、次廣の建設業/製造業向けAI業務改善、LINE日報・勤怠・見積・受発注のモック資料作成アクションを整理。 |
| [meetings/1to1/1to1_nampo_yuma_waibous.md](meetings/1to1/1to1_nampo_yuma_waibous.md) | **南方優馬（ワイボウズ／BNI Tifonet・東京NE）**。望月紹介・**第1回 2026-05-27 実施済み**。受動的紹介のみ（低コストEC）。補助金系は協力しない。**Religo `one_to_ones.id=35`**。 |
| [meetings/1to1/1to1_nishiura_miyabi_draci.md](meetings/1to1/1to1_nishiura_miyabi_draci.md) | **西浦雅（株式会社Myria-mu／BNI DragonFly／外構SNS集客）**。**第1回 2026-06-04 JST 15:00–16:00 実施済み**・**Religo `one_to_ones.id=66`**。Draci（WordPress）案件は3層アカウント管理、掲示板テストサーバー、支部検索、フォント変更を整理。**第2回 2026-06-14 JST 20:00〜実施済み**（終了時刻・Religo id TODO）。Myria-mu の顧客問い合わせ、施工店最大3社抽出、契約・報告、インフルエンサー専用URL、報酬計算（3%/4%要確認）、公式LINE/Lステップ連携の管理システム相談を整理。 |
| [meetings/1to1/1to1_terada_tifonet_engineer_collaboration.md](meetings/1to1/1to1_terada_tifonet_engineer_collaboration.md) | **寺田直史（株式会社ハーベスト／BNI Tifonet）**。西浦さん紹介・**第1回 2026-06-01 JST 17:00–18:00 実施済み**・**Religo `one_to_ones.id=40`**。Zoom要約反映。SES高還元モデル（90%還元＋ボーナス）、知人エンジニア紹介、キャパ超過時のSES活用、要件定義×実装パワーチーム、アイビーコミュニケーションズ藤井氏紹介、法人フロント協力を整理。正式氏名表記は要確認。 |
| [meetings/1to1/1to1_mitarai_fudotech.md](meetings/1to1/1to1_mitarai_fudotech.md) | **御手洗さん（株式会社風土テック／BNI VORTEX）**。VORTEX の加門さん紹介・**第1回 2026-05-22 JST 09:00〜実施済み**（終了時刻 TODO・`one_to_ones.id = 32`）。建設業採用支援・採用活動の資産化・MVV/SNS/無料媒体支援、次廣の LINE 日報/建設業務改善事例、外国人労働者支援・西岡さん三者連携、メンバー表交換、6月リージョンフォーラム対面、2〜3ヶ月ごとの情報交換、西岡さん了承後の3名グループ作成確認を整理。 |
| [meetings/1to1/1to1_noguchi_yuko_hair_salon_viv.md](meetings/1to1/1to1_noguchi_yuko_hair_salon_viv.md) | **野口裕子（HAIR SALON ViV／BNI DragonFly→2026年5月退会決定）**。**第1回 2026-05-25 JST 15:00〜実施済み**（終了・Religo id TODO）。個人経営・火曜営業と定例会両立不可、ホットペッパー/紙予約課題、軍司LINE3ヶ月、次廣無償PC支援・夏頃予約システム提案、ジンボウさん1to1リファラル合意。 |
| [meetings/1to1/1to1_matsukura_kenji_glassfilm_coating.md](meetings/1to1/1to1_matsukura_kenji_glassfilm_coating.md) | **松倉健治（株式会社松和／エアロゲル透明断熱フィルム・BNI DragonFly）**。**第1回 2026-04-24 JST 11:30–12:30 実施済み**（Religo `one_to_ones.id=19`）・Zoom。NCASプロフィールとZoom要約を統合し、エアロゲル透明断熱フィルム、ガラスコーティング、高級リゾートホテル・富裕層住宅・既存建物向け紹介軸、次廣のAI業務改善システム、外注ブロック管理システム上の接点、静岡インテリア商材卸し会社への紹介検討、リファーラル発表の外向け表現改善、AI秘書システム商品化助言、Action Items を整理。 |
| [meetings/1to1/1to1_otake_erika_welfare.md](meetings/1to1/1to1_otake_erika_welfare.md) | **大竹絵理香（個人事業主／家族も使える福利厚生・BNI DragonFly）**。**第1回 2026-06-24 JST 14:00–15:00 実施済み**（Religo id TODO）・Zoom。ネイル（労働収入）＋福利厚生事業（権利収入）の二本柱、BNI活動アドバイス（リファラル蓄積・分割発表、ビジター招待戦略、121積極化）、松倉さんへの121申し込み決意、知人27歳SE接続検討、コナカさんへのつなぎ、ネイル顧客管理（まず紙メモ）を整理。 |
| [meetings/1to1/1to1_takeuchi_shunta_athlete_insurance.md](meetings/1to1/1to1_takeuchi_shunta_athlete_insurance.md) | **竹内駿太（エグゼクティブランス／アスリート専門生命保険・BNI DragonFly）**。**第1回 2026-04-20 JST 15:53〜**（終了時刻 TODO）・Zoom。キッズマネー教育の静岡展開、サッカーパパコーチ・PTA紹介、法人営業先のDXニーズ紹介、Dリーグ接点 Todo を整理。 |
| [meetings/1to1/1to1_gunji_lstep_webhook.md](meetings/1to1/1to1_gunji_lstep_webhook.md) | **軍司敦哉（株式会社Conduct／LINE公式アカウント運用代行）**。**第1回 2026-03-30 JST 15:30–16:30 実施済み**、**第2回 2026-04-01 JST 14:00–15:00 実施済み**（実施方法・Religo id TODO）。第2回はリンクアットジャパン向け **Lステップ + AIチャットボット提案**、Genspark提案資料、スタートプラン約100万円、軍司さんLステップ構築 × 次廣Webhook/API/AI構築の役割分担、エンジニアリングパートナー同席、技術論点・価格・横展開・Action Items を整理。 |
| [meetings/1to1/1to1_yonezawa_yuka_comechan_design.md](meetings/1to1/1to1_yonezawa_yuka_comechan_design.md) | **米澤 侑桂（Comechan Design）**。**§10〜14**＝協業合意・案件・スキル・稼働・成功要因（2026-04-08）。**§15〜18**＝再現用ヒアリング／台本。**求人サイトアプリ化＋古紙回収リッチメニュー** 合意。 |
| [meetings/1to1/1to1_yoshida_takuma_yoshida_clinic.md](meetings/1to1/1to1_yoshida_takuma_yoshida_clinic.md) | **吉田拓磨（吉田クリニック御一家・非BNI）**。**第1回 2026-06-11 実施済み**・**Religo `one_to_ones.id=77`**（開始・終了時刻 TODO）。SNSマーケティング／コンテンツビジネス／公式LINE・Lステップ・プロライン収益化動線。次廣との段階的協業、店舗向けSNS×予約/再来店導線、吉田クリニックLINE公式・若年層集客・スポーツ外傷ブランディング提案を整理。Zoom要約の「平野拓馬」は誤記として訂正。 |
| [meetings/1to1/1to1_kadowaki_yui_omoroo.md](meetings/1to1/1to1_kadowaki_yui_omoroo.md) | **門脇優衣（株式会社オモロー／SNSマーケティング・DragonFly第210回ビジター）**。**第1回 2026-06-11 JST 17:00〜実施済み**（終了時刻 TODO）。`one_to_ones.id=73`（`members.id=150`）。Instagram特化型スクール **バズミーキャンパス**（3,000円/15,000円/50,000円・約800人生徒・学校型プラットフォーム）、AIアバター授業・コイン制度・地域別コミュニティ、熊本廃校ホテル地方創生、営業担当メンバーのBNI参加検討、SNS集客後の予約/LINE/顧客管理導線での tugilo 連携可能性を整理。 |
| [meetings/1to1/1to1_hirayama_mayumi_lifesupport.md](meetings/1to1/1to1_hirayama_mayumi_lifesupport.md) | **平山 真由美（ライフサポート／シングルマザー専門事業コンシェルジュ）**。**第1回 2026-04-08 JST 11:00〜**（終了時刻 TODO）・Zoom。**議事録体裁**（概要・決定・アクション・協業案・次回 RF 11/9）。 |
| [meetings/1to1/1to1_ito_takao_phoenix_jsp.md](meetings/1to1/1to1_ito_takao_phoenix_jsp.md) | **伊藤隆夫（フェニックス人事労務／株式会社フェニックスミッション・BNI 大人なじみ）**。飯塚さん経由の**クロスチャプター**。**第1回実施済み**（Zoom・文字起こし要約を 2026-05-13 反映。正式日時 YAML **TODO**）。協業・業務改善助成金・ローカルLLM提案書・多摩スキー紹介。
| [meetings/1to1/1to1_iizuka_graphic_design.md](meetings/1to1/1to1_iizuka_graphic_design.md) | **飯塚氏（グラフィックデザイナー・BNI 大人なじみ）**。**第1回 2026-04-27 JST 10:58〜**（終了時刻 TODO）・Zoom。社労士/雨漏り調査/竹本氏紹介、田渕氏（庵治石）・行政書士メンバー紹介、システム×デザイン協業、月次1on1合意を整理。 |
| [meetings/1to1/1to1_jimbo_ryota_snep.md](meetings/1to1/1to1_jimbo_ryota_snep.md) | **神保玲太（SNEP株式会社・10分ネイル／BNI Diana）**。鈴木健介さん紹介・**第1回 2026-05-28 実施済み**（開始終了時刻 TODO）・**Religo `one_to_ones.id=36`**。10分ネイル戦略、脱ホットペッパー支援、BNI向け予約管理システム（月額1万円以下・4,980円基本＋オプション）、MEO等集客支援パワーチーム、周期リマインド、野口さん接続、プロトタイプ優先共有を整理。 |
| [meetings/1to1/1to1_furuya_shuji_telecom_cost.md](meetings/1to1/1to1_furuya_shuji_telecom_cost.md) | **古屋周治（合同会社TF 代表社員／屋号スマホドクター静岡葵）**。三本柱＝**携帯回線（固定費削減）・害虫ブロック取扱店・不動産売買仲介（宅建士）**。**BNI インフィニティ∞（静岡セントラル・2023/10〜）／守成クラブ静岡会場 代表**。**増本重孝さん（害虫ブロック）紹介・DragonFly 第208回（2026-05-19）ゲスト**。**第1回 1to1 2026-05-29 実施**（時刻・`one_to_ones.id` TODO）。ゲストカード＋GAINSシート（2026-05-04）反映、固定費削減×業務DXの補完、守成クラブ再接続（次廣も会員・約3年ご無沙汰）、相互リファーラルを整理した事前ドキュメント。 |
| [meetings/1to1/1to1_suzuki_kensuke_studio_suzu.md](meetings/1to1/1to1_suzuki_kensuke_studio_suzu.md) | **鈴木健介（合同会社スタジオ鈴・BNI Diana）**。**第1回 2026-04-17 JST 09:55〜**（終了時刻 TODO）・Zoom。スタートアッププレゼン改善、VR×サウナコンテンツ、藤原氏（VR推進協会）紹介、北欧サウナ体験、飲食店向けAIコールセンターの芽を整理。 |
| [meetings/1to1/1to1_isobe_masayuki_nestle_detective.md](meetings/1to1/1to1_isobe_masayuki_nestle_detective.md) | **礒部昌之（ネスレ探偵事務所・BNI レブリー）**。**第1回 2026-05-16 10:00〜11:00 実施済み**（Zoom 詳細要約反映）。探偵業（レムリ／大宮）・保険営業紹介（紀川・竹内・海沼・山本）・メンバー表相互共有・倫理会ゲスト管理システム化の芽・藤枝/フランス語の接点。 |
| [meetings/1to1/1to1_harada_saori_ruiled_vision_japan.md](meetings/1to1/1to1_harada_saori_ruiled_vision_japan.md) | **原田里織（RUILED VISION JAPAN株式会社／BNI DragonFly）**。**第1回 2026-06-01 JST 14:00–15:00 実施済み**・**Religo `one_to_ones.id=37`**。店舗・施設集客を高めるLEDデジタルサイネージ、中国深圳工場との直接契約、1台から納品、販売代理店（加盟金55万円・ノルマ/在庫なし）、看板屋・電気工事士との協業、導入実績、次廣の電気工事士紹介確認、ホットペッパー代替予約システム構想、おかわり121合意を整理。 |
| [meetings/1to1/1to1_konaka_takaaki_becheerz.md](meetings/1to1/1to1_konaka_takaaki_becheerz.md) | **小中貴晃（株式会社BeCheerz／BNI DragonFly）**。**第1回 2026-06-01 JST 15:00–16:00 実施済み**・**Religo `one_to_ones.id=38`**。AIツール情報発信、AI研修、業務効率化・生産性向上支援、システム開発、医療向けAIカルテ生成支援。Zoom要約反映。アルシルブ事業化（補助金・自治体展開・AI研修連携）、予約管理システム、BNI用1to1管理システム商業化、クリニックへのカルテ生成支援紹介、開発案件相談体制（営業フィー20〜30%）を整理。 |
| [meetings/1to1/1to1_yamamoto_yoko_idemitsu_credit.md](meetings/1to1/1to1_yamamoto_yoko_idemitsu_credit.md) | **山本葉子（出光クレジット／BNI DragonFly）**。**第1回 2026-06-03 JST 15:00–16:00 実施済み**・**Religo `one_to_ones.id=41`**（Zoom要約反映）。動物病院×アメックス・獣医師会賛助会員、予約システムチラシ共同配布・6/6 RF対面・藤枝デモ合意。**おかわり121**予定。 |
| [meetings/1to1/materials/animal_hospital_line_reservation_flyer_202606.md](meetings/1to1/materials/animal_hospital_line_reservation_flyer_202606.md) | **動物病院向け LINE予約チラシ（A4・ビジュアル中心）**。yamabuki 実画面キャプチャ5枚接続済み（v4 2026-06-03）。 |
| [meetings/1to1/materials/screenshot_capture_guide.md](meetings/1to1/materials/screenshot_capture_guide.md) | 上記チラシ用 **yamabuki スクリーンショット取得手順**（LIFF 3枚・管理画面2枚・LINE通知1枚）。 |
| [meetings/1to1/1to1_iida_chiho_sui.md](meetings/1to1/1to1_iida_chiho_sui.md) | **飯田千帆（彗 sui／経営者向け開運占い師／BNI DragonFly）**。**第1回 121 2026-06-12 JST 09:00-10:00 実施済み**・**Religo `one_to_ones.id=69`**。**総合鑑定 2026-06-22 10:00-11:00 実施済み**（メインプレ前日）。3年BNIコミット・発信強化・3000万超・法人化来年夏・健康・家族・大井神社参拝等を整理。鑑定質問リスト・事前送付文案あり。OCC・WEBマスター・飯田香との同姓区別。
| [meetings/1to1/1to1_kiyohara_kasami_ui.md](meetings/1to1/1to1_kiyohara_kasami_ui.md) | **清原佳彩美（株式会社u\`i／サロン向け育毛機器・商材販売／BNI DragonFly）**。**第1回 2026-06-12 JST 10:00〜実施済み**・**Religo `one_to_ones.id=70`**（終了時刻 TODO・Zoom要約反映）。まつ毛美容液「伸びるラッシュ」、毛根由来幹細胞50%の育毛美容液、育毛マシン、予防育毛、FC展開構想を整理。Zoom誤記校正（宮城→西浦雅、千葉→飯田千帆、松本→増本）。清原×千帆は旧知・入会きっかけ。次廣の業務改善システム説明、6/15メインプレゼンリハ参加、システム相談の再121合意を記録。 |
| [meetings/1to1/1to1_masumoto_shigetaka_pestblock.md](meetings/1to1/1to1_masumoto_shigetaka_pestblock.md) | **増本重孝（株式会社プロテクトラボ／害虫ブロックFC・ピタカット）**。**第1回 2026-06-12 JST 16:00–17:00 実施済み**・**Religo `one_to_ones.id=76`**。主題＝新事業 **ピタカット** を既存 **P-Link** に **組み込めるか・どう組み込むか**（別建て不要・販売代理店ロール追加・25〜30万円見込）。6/13静岡でスライド深掘り。BNI運営話は補足。 |
| [meetings/1to1/1to1_iida_kaori_libero.md](meetings/1to1/1to1_iida_kaori_libero.md) | **飯田香（Libero／グラントイーワンズ代理店／BNI DragonFly）**。**第1回 2026-06-17 実施済み**（Religo `one_to_ones.id=67`）・**第2回 2026-06-25 JST 13:00–14:00 実施済み**。第1回は次廣事業紹介・BCPシステム開発相談。第2回は当日朝の地震対応、ティフォーネット（表記要確認）と **SONAE / LINE公式連携** の安否確認比較、来週LT提案、グラントイーワンズの **ながら健康美容法**（着る・寝る・飲む・入浴する）・機能性インナー/水/睡眠/シャワーヘッド・紹介条件を整理。 |
| [meetings/1to1/1to1_takemura_yuji_onode.md](meetings/1to1/1to1_takemura_yuji_onode.md) | **竹村裕司（株式会社ONODE／プロモーション動画制作・チアプリント／DragonFly 2026-07-07入会予定）**。**第1回 2026-06-26 JST 09:00–10:00 実施済み**（Religo id TODO）。芳賀崇利さん紹介ゲスト。元大阪GaiYenチャプターのメンバーで、ゲスト登録カテゴリーは **プロモーション動画制作**。ONODEの動画/Web制作、チアプリントの全国コンビニ対応・掲載無料・高マージン還元・即日販売開始、Dリーグ/ダンス業界接点、補助金・制作協力者ニーズ、次廣のReligo/予約管理/AI開発との協業・マーケティング支援・bitさん接続検討を整理。 |
| [meetings/1to1/1to1_ohta_issei_finebubble.md](meetings/1to1/1to1_ohta_issei_finebubble.md) | **太田一誠（ファインバブル／BNI DragonFly）**。**第1回 2026-05-08 JST 11:00–12:00 実施済み**（Religo id TODO）。NCASプロフィールとZoom要約を統合し、ファインバブル代理店事業、取扱店年間20件・売上1,000万円目標、営業・SNSコンサル経験、次廣の業務改善・Webシステム開発紹介、工務店・建設業・中小企業経営者・士業への相互紹介方針、「雑につなぐ」合意、フィードバック、Action Items を整理。 |
| [meetings/1to1/1to1_kumagai_ryusho_lifinity.md](meetings/1to1/1to1_kumagai_ryusho_lifinity.md) | **熊谷龍笙（株式会社Lifinity／通信費削減・長期インターン/創業支援・DragonFlyビジター）**。**第1回 2026-06-17 JST 14:15〜実施済み**（終了時刻・Religo id TODO）。小中貴晃さん紹介。Zoom要約反映。携帯削減はフックで、本体は長期インターン・営業組織づくり・創業支援。新会社ファンダーズ構想、AI系企業への携帯削減訴求、本人入会よりスタッフ入会が自然というBNI判断、次廣の携帯プラン個別相談を整理。 |
| [meetings/1to1/1to1_kadomatsu_naoyuki_sics.md](meetings/1to1/1to1_kadomatsu_naoyuki_sics.md) | **門松直幸（株式会社サイクス／社外情シス担当／BNI EduTech）**。**第1回 2026-06-26 JST 17:00–18:00 実施済み**（Religo id TODO）。NCASプロフィールとZoom要約を統合し、同業者として競合ではなく協業パートナー関係を作る合意、門松さんの社外情シス・Web/アプリ/業務システム開発・EduTech立ち上げ状況、次廣のSE26年・AI駆動開発・価値ベース見積もり・Religo/BNI向け1to1/リファーラル支援システム、BNI向けクラウドサービス案、リージョンフォーラム対面、Action Items、お礼文案を整理。 |
| [meetings/1to1/1to1_fukushi_toshiaki_universe_products.md](meetings/1to1/1to1_fukushi_toshiaki_universe_products.md) | **福士利明（株式会社ユニバースプロダクツ／BNI DragonFly）**。**第1回 2026-06-19 JST 09:00〜実施済み**（終了時刻・Religo id TODO）。Zoom要約反映。BtoC国際物流・中国TikTokライブコマース、コンクリートリバイブ CTP2000（水性コンクリート含浸材・NETIS登録・公共/防水工事/食品工場等の用途）、次廣の業務改善システム構築、福士さん側の5社統合システム相談可能性、名古屋の防水工事業者への打診、資料・7分間ビデオ共有、名刺交換、次回121調整を整理。福士さんへのお礼文案あり。 |
| [meetings/1to1/1to1_hirano_masakuni_biken_tecno.md](meetings/1to1/1to1_hirano_masakuni_biken_tecno.md) | **平野眞邦（有限会社 美研テクノ／BNI クリエーションズ）**。平岡さん紹介・**第1回 2026-07-01 JST 15:00-16:00予定**（先方都合により 2026-06-19 13:00 からリスケ）。防水工事・塗装・下地補修、内容不明な見積書相談、環境部（害虫ブロック・節電ガラスコート・看板PUシールド）、アスリート雇用支援について、初回121台本・質問・紹介仮説・お礼文案を整理。 |
| [meetings/1to1/1to1_yokoyama_taiki_aratas.md](meetings/1to1/1to1_yokoyama_taiki_aratas.md) | **横山太樹（株式会社ARATAS／資金調達支援・DragonFlyビジター）**。渡邊真大さん紹介・**第1回 2026-06-19 JST 14:00〜実施済み**（Zoom要約反映・`one_to_ones.id=81`、DB completed 反映 TODO）。元銀行員×税理士の財務顧問、次廣の法人化・財務戦略・銀行格付け相談、AI/情報セキュリティ、DragonFly入会プッシュ、獨協大学の共通縁を整理。 |
| [meetings/1to1/1to1_nakamura_keigo_shakumoto.md](meetings/1to1/1to1_nakamura_keigo_shakumoto.md) | **中村啓吾（株式会社笏本縫製／SHAKUNONE・つやまスーツ・BNI DragonFly）**。**第1回 2026-05-21 実施済み**（正式時刻 TODO）。次廣事業・予約管理システム・料金パッケージ化・宮城氏（トレスステラ）紹介合意・中村氏新カテゴリー（コンサルではなく日本製ものづくりチーム形成）を整理。 |
| [meetings/1to1/1to1_tabuchi_kyohei_tabuchi_stone.md](meetings/1to1/1to1_tabuchi_kyohei_tabuchi_stone.md) | **田渕恭平（田渕石材株式会社／株式会社TABUCHI・BNI DragonFly）**。**第1回 2026-05-14 JST 17:00–18:00 実施済み**・**Religo `one_to_ones.id=82`**。高級石材の採掘・供給、庵治石、「令和の新石器時代」構想、石の空間プロデュース、石インテリア/アクセサリー/アパレル、次廣のAI業務改善システム構築、田渕さんのファイル管理・資料生成ニーズ、大人なじみチャプターのリブランディング専門デザイナー・木村くん（建築家）を軸にした紹介方針、BNI自チャプター121・夜間トレーニング、Action Items を整理。 |
| [meetings/1to1/1to1_kuramoto_kenichi_webmaster.md](meetings/1to1/1to1_kuramoto_kenichi_webmaster.md) | **倉持 賢一（WEBマスター／中国向け物販支援）**。**第2回 2026-04-13 JST 11:00–12:00**・Zoom。ITウェブパワーチーム・坂木氏・双葉企画・エアコン案件等。**第1回** 2026-04-02 要約あり。 |
| [meetings/1to1/1to1_funatsu_mariko_aicare_lab.md](meetings/1to1/1to1_funatsu_mariko_aicare_lab.md) | **船津 麻理子（アイケアラボ／眼の整体）**。**第1回 2026-04-13 実施済み**・Zoom（既存記録 14:30–15:30、Zoom要約タイトル 15:37 のため正式時刻 TODO）。予防眼科・視力回復、藤本税理士/秋田財務コンサル紹介、関東圏眼科医紹介検討、FC本部システム化、1on1記録整理・顧客管理（DB `one_to_ones.id` 15）。 |
| [meetings/1to1/1to1_hatakeyama_noriyuki_wagashi_oem.md](meetings/1to1/1to1_hatakeyama_noriyuki_wagashi_oem.md) | **畠山 憲之（和スイーツOEM／BCP担当）**。**第1回 2026-04-13 JST 18:00–19:00**・Zoom。業務課題整理・再1on1合意（DB `one_to_ones.id` 16）。 |
| [meetings/1to1/1to1_fujii_eriko_hiraten.md](meetings/1to1/1to1_fujii_eriko_hiraten.md) | **藤井恵理子（HiraTen／播州織の日傘製造・BNI DragonFly）**。**第1回 2026-05-29 JST 15:00–16:00 実施済み**・**Religo `one_to_ones.id=37`**。キャッチ採用、Religo関心、シフト管理紹介合意、播州織・メンズ日傘・パリ出展・守成5月末退会。 |
| [meetings/1to1/1to1_endo_satomi_mirai_realestate.md](meetings/1to1/1to1_endo_satomi_mirai_realestate.md) | **遠藤聡美（株式会社みらい不動産／BNI SILVIS・11期1to1）**。**第1回 2026-06-04 JST 14:00–15:00 実施済み**（DragonFly×SILVIS）。`one_to_ones.id=72`・`members.id=164`・`workspaces` SILVIS id=11。トレーニング同組・業務改善関心。 |
| [meetings/1to1/1to1_fukuda_kohei_anfunini.md](meetings/1to1/1to1_fukuda_kohei_anfunini.md) | **福田航平（アンフィニ／オンライン家庭教師→塾向けオーダーメイドテキスト・神奈川）**。**越賀淑恵**紹介・**第208回（2026-05-19）DragonFlyビジター**。**第1回 2026-06-04 JST 09:00–10:00 実施済み**・**Religo `one_to_ones.id=42`**。相互紹介合意、スマホ最適化教材・AI（ChatGPT→Claude/Gemini）、子育て/受験・教育業界構造の意見交換。次回はネタあり次第。 |
| [meetings/1to1/1to1_kakiya_naoto_dock.md](meetings/1to1/1to1_kakiya_naoto_dock.md) | **垣谷直人（合同会社 dock.／SEOコンサルタント／BNI KerNel）**。**田村広大**紹介・**第1回 2026-06-04 JST 11:00–12:00 実施済み**（**Religo `one_to_ones.id=71`**）。NCAS反映。CRO/EFO・HP制作会社向けSEO顧問。予約管理×SEO/MEO協業、Contact Circle（広告代理店/HP制作/システム開発）。Zoom表記「柿谷」は誤変換。 |

#### 提案書・その他（docs/meetings/ 直下）

| ファイル | 説明 |
|----------|------|
| [2026-06-11_katana_uchida_ishihara_zoom.md](meetings/2026-06-11_katana_uchida_ishihara_zoom.md) | **KATANA（刀）打田社長・石原氏・次廣 3名Zoom 議事録**（2026-06-11 11:00 JST〜、終了時刻 TODO）。打田康平氏（株式会社J.NOVA / KATANA）は**非BNI会員**。Zoom要約反映済み。経営統合システム「刀」の財務・会計、案件管理、勤怠/業務報告、人事評価、権限管理、AI伴走、社内チャットを整理。次廣の評価・UI/ゲーミフィケーション/疎結合化/データ移行/AI時代の評価制度への提言、BNI東京NEリージョン接続・個別1to1設定の合意を記録。 |
| [2025-03-12_kimura_system_concept_proposal.md](meetings/2025-03-12_kimura_system_concept_proposal.md) | 木村様向け提案書：業務整理と仕組みづくりの構想メモ（2025/3/12）。クライアント共有用。 |
| [2026-03-30_gunji_lstep_webhook_ai_proposal.md](meetings/2026-03-30_gunji_lstep_webhook_ai_proposal.md) | 軍司様向け提案書（2026/3/30）：Lステップ Webhook × AI チャットボット構築・協業（START / GROW / SHIFT プラン・展開）。クライアント／パートナー共有用。 |

### 提案（docs/proposals/）

クライアント／パートナー向けの **提案書・ブリーフ・PDF**。[`meetings/README.md`](meetings/README.md) と役割分担。

| ファイル | 説明 |
|----------|------|
| [proposals/README.md](proposals/README.md) | 本ディレクトリの用途（議事録・1to1 との分離）。 |
| [proposals/sonae_bcp_proposal_iida_kaori.md](proposals/sonae_bcp_proposal_iida_kaori.md) | **SONAE 飯田香さん向け提案書**。DragonFly BCP担当・役員向けに、BCP担当の人力依存、半期交代による属人化、SONAEを「人を支える運営の土台」とする思想、DragonFlyをモデルチャプターにしたPoC開発、気象庁連携、LINE通知、訓練、回答集計、チャプターごとの独立性を整理。根拠: [`SSOT/SONAE_REQUIREMENTS.md`](SSOT/SONAE_REQUIREMENTS.md)。 |
| [proposals/sonae_bcp_proposal_iida_kaori_genspark_slide_prompt.md](proposals/sonae_bcp_proposal_iida_kaori_genspark_slide_prompt.md) | **SONAE 飯田香さん向け Gensparkスライド生成プロンプト**。最新提案書をもとに、属人化から仕組み化、人に頼る運営から人を支える運営への転換、PoC開発を伝えるPowerPoint向けスライド構成・デザイン・禁止事項を整理。 |
| [proposals/sonae_proposal.pdf](proposals/sonae_proposal.pdf) | **SONAE 最新PDF提案書（PoC版）**。飯田香さん・DragonFly BCP担当向けの16枚スライド版。DragonFlyをモデルチャプターにしたPoCとして、人力依存から人を支える運営への転換、LINE回答、気象庁情報による自動発報、PoCで作る範囲、開発費・利用料請求なしを視覚化。 |
| [proposals/sonae_proposal3.pdf](proposals/sonae_proposal3.pdf) | **SONAE 旧PDF提案書（v3）**。飯田香さん・DragonFly BCP担当向けの16枚スライド版。PoC版作成前の参考資料。 |
| [proposals/myria_mu_exterior_referral_system_initial_proposal.md](proposals/myria_mu_exterior_referral_system_initial_proposal.md) | **Myria-mu 外構紹介管理システム 初期導入版提案書（提出用）**。YUINIWA（ユイニワ）向け。西浦さんの初期相談に合わせ、160〜180万円程度の初期導入プランを本命として提示。Myria-mu担当者・施工店・インフルエンサーの3者が利用するWebシステムで、顧客は問い合わせフォーム/アンケートフォームのみ利用する構成を明記。 |
| [proposals/myria_mu_initial_proposal_genspark_slide_prompt.md](proposals/myria_mu_initial_proposal_genspark_slide_prompt.md) | **Myria-mu 初期導入版提案書 Gensparkスライド生成プロンプト**。YUINIWA（ユイニワ）の提出用初期導入版提案書を元に、西浦さん向けの8〜10枚程度の分かりやすいスライドをGensparkで生成するためのプロンプト。160〜180万円程度の初期導入、対象利用者、含める範囲/含めない範囲、将来拡張を控えめに伝える構成。 |
| [../www/public/mock/yuiniwa-proposal-mock.html](../www/public/mock/yuiniwa-proposal-mock.html) | **YUINIWA 外構紹介管理システム クリッカブルモック（商談用）**。初期導入版提案書を元にした単一HTMLモック。タブで Myria-mu管理画面 / 案件詳細 / 施工店ポータル / インフルエンサーマイページ を切替。実体: `www/public/mock/yuiniwa-proposal-mock.html`。ローカル確認: http://localhost/mock/yuiniwa-proposal-mock.html 。 |
| [proposals/myria_mu_exterior_referral_system_proposal.md](proposals/myria_mu_exterior_referral_system_proposal.md) | **Myria-mu 外構紹介プラットフォーム構築提案（内部資料・将来構想版）**。要件定義書を根拠に、インフルエンサー・顧客・施工店パートナー・顧客満足・施工事例・データ活用が循環する紹介ネットワークとして整理。商談で相手が将来構想に乗ってきた場合のバックポケット資料。 |
| [proposals/printing_business_improvement_overview.md](proposals/printing_business_improvement_overview.md) | **印刷業向け 業務改善・システム化整理資料**（芳賀さん共有・非技術者向け）。要件と提案書の中間、補助金説明にも流用可。根拠: `requirements/printing_order_management_system_requirements_final.md` 等。 |
| [proposals/printing_business_improvement_estimate.md](proposals/printing_business_improvement_estimate.md) | **印刷業向け 業務改善システム 概算見積（案・税別）**。核スコープ、120万規模の内訳、補助金・進め方。overview / PDF スライドと対。 |
| [proposals/2026-04-14_sato_brightlink_listing_pipeline_proposal_brief.md](proposals/2026-04-14_sato_brightlink_listing_pipeline_proposal_brief.md) | **佐藤拓斗（BrightLink）向け・提案書素案用ブリーフ。** テレアポ用リスティング自動化の目的・手段・効果・リスク・未確認事項。根拠: `meetings/1to1/1to1_sato_takuto_brightlink.md`。 |
| [proposals/ilc_monthly_report_automation_proposal_imanishi.md](proposals/ilc_monthly_report_automation_proposal_imanishi.md) | **AiLC 月次集計表作成 自動化提案メモ**。今西さん向け。検証結果（51 TSV・76,628行）、削減効果、AI駆動Web MVP、概算費用、ROI、返信案を整理。根拠: `consultations/ILC/consultation_imanishi_monthly_report_automation.md`。 |
| [proposals/ilc_monthly_report_automation_genspark_slide_prompt.md](proposals/ilc_monthly_report_automation_genspark_slide_prompt.md) | **Genspark用スライド生成プロンプト**。AiLC 月次集計表作成 自動化提案メモを、経営者向け10〜12枚の提案スライドに変換するためのプロンプト。 |
| [proposals/l_step_webhook_ai_chatbot_proposal_20260331025854.pdf](proposals/l_step_webhook_ai_chatbot_proposal_20260331025854.pdf) | Lステップ × AI チャットボット関連 PDF（既存）。 |

### メンバー相談（docs/consultations/）

メンバーから受けた細かい相談事を、調査・検討・次アクションに整理するための中間置き場。1to1 の関係履歴や共有用提案書とは分離する。

| ファイル | 説明 |
|----------|------|
| [consultations/README.md](consultations/README.md) | **メンバー相談メモの運用ルール**。置くもの・置かないもの、命名規約、推奨フォーマット、1to1 / proposals / SSOT との役割分担を定義。 |
| [consultations/ILC/README.md](consultations/ILC/README.md) | **AiLC 相談データ**。今西さんからの加盟店向け月次集計表作成簡略化相談に関するデータ置き場。 |
| [consultations/ILC/consultation_imanishi_monthly_report_automation.md](consultations/ILC/consultation_imanishi_monthly_report_automation.md) | **今西さん AiLC 月次集計表作成簡略化相談**。TSV・Excel・手順 PDF の初期検証、自動化可能性、対応案、追加確認事項を整理。 |

### ワークショップ（docs/workshop/）

| ファイル | 説明 |
|----------|------|
| [workshop/README.md](workshop/README.md) | 本ディレクトリの用途（研修・WS向けメモ。SSOT とは分離）。 |
| [workshop/BNI_VisitorInvitation_workshop_notes_20260512.md](workshop/BNI_VisitorInvitation_workshop_notes_20260512.md) | **BNI ビジター招待ワークショップ受講メモ**（2026-05-12 18:00-20:00 JST）。本日のアジェンダ、講義メモ、今日から変える行動、招待候補・声かけ文を記録する当日用ノート。 |
| [workshop/BNI_KeySkills_Referral_Workshop_Prep_Tsugihiro_202604.md](workshop/BNI_KeySkills_Referral_Workshop_Prep_Tsugihiro_202604.md) | **KeySkills・リファーラルWS 実戦用台本**（即答・10/30/1分・紹介文型・RP）。**§⑧ 事例と効果**、個人事業主ターゲット。**1to1WSとは別。** |
| [workshop/BNI_DragonFly_BO_Step1_Referral_Minutes_20260402.md](workshop/BNI_DragonFly_BO_Step1_Referral_Minutes_20260402.md) | WS **ステップ1 BO** リファー視点議事録（紹介矢印・L推定・次廣アクション）。 |
| [workshop/BNI_KeySkills_Lesson2_Referral_Script_Tsugihiro_202604.md](workshop/BNI_KeySkills_Lesson2_Referral_Script_Tsugihiro_202604.md) | WS **レッスン2** 第三者紹介文（**AI業務改善システム構築の次廣**）。個人事業主・**事例と効果**の型。 |
| [workshop/BNI_KeySkills_Lesson2_Referral_Workflow_Tsugihiro_202604.md](workshop/BNI_KeySkills_Lesson2_Referral_Workflow_Tsugihiro_202604.md) | WS **レッスン2** 進め方4問（■①〜④）・**ウィークリー§2.1**・Script／事例参照。 |

### アカデミー（docs/academy/）

BNI アカデミー資料・受講用メモ（KeySkills 等）。教材 PDF と併せて参照。

| ファイル | 説明 |
|----------|------|
| [academy/キースキルズ/メインプレゼン/BNI_KeySkills_MainPresentation_5min_Tsugihiro_202604.md](academy/キースキルズ/メインプレゼン/BNI_KeySkills_MainPresentation_5min_Tsugihiro_202604.md) | **KeySkills・メインプレゼン（5分）**（次廣／tugilo）。**§4.1 リハ版（2026-06-08）** — 3部構成・**一人称「私」**・運命的な出会い／専門用語を社長の言葉に翻訳するSEを軸に5分へ圧縮。自己紹介末尾の重複を調整。今日のアジェンダ、事例改善効果（増本さん害虫ブロックFC・取扱店200社超→500店舗規模の土台・推薦文／防水工事LINE日報・請求/給与計算接続）、**§4.1.1 Gensark資料化プロンプト**（表紙カテゴリ・氏名、赤→グレー、成果物画像、文字少なめ・図多め）を追加。藤井さん **「あったらいいなを形にしてくれる」**。§4確定稿・PG・**DragonFly 本番 2026-06-23**・リハ 6/8・6/15（各20:00 JST）。**関連:** [BNI_Tsugihiro_Atsushi_Intro_Living_Document.md](strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md)。 |
| [academy/キースキルズ/メインプレゼン/BNI_MainPresentation_PopQuiz_Answers.md](academy/キースキルズ/メインプレゼン/BNI_MainPresentation_PopQuiz_Answers.md) | **メインプレゼン受講者ガイド・抜き打ちテスト**（5問）正解：**4／3／6／5／2週間前**（問題順）。時系列メモ付き。 |
| [academy/004_メンバーアクセラレーター/BNI_MemberAccelerator_workshop_notes_20260416.md](academy/004_メンバーアクセラレーター/BNI_MemberAccelerator_workshop_notes_20260416.md) | **メンバー・アクセラレーター WS 用メモ**（2026-04-16）。PDF「本日のアジェンダ」6項目ごとにメモ欄＋受講者ガイドのトピック目安。教材: [受講者ガイド PDF](academy/004_メンバーアクセラレーター/BNIメンバー・アクセラレーター（受講者ガイド）ver.1.0.pdf)。 |
| [academy/キースキルズ/ウィークリープレゼン/BNI_WeeklyPresentation_workshop_notes_20260424.md](academy/キースキルズ/ウィークリープレゼン/BNI_WeeklyPresentation_workshop_notes_20260424.md) | **KeySkills・ウィークリープレゼンテーション WS 用メモ**（2026-04-24）。受講者ガイドに沿って、**4つの要素・VCP・信頼構築・抜き打ちテスト4問・3分説明ワーク・次回改善** をそのまま書き込めるテンプレート。 |
| [academy/キースキルズ/ベーシック/BNI_BasicTraining_workshop_notes_20260427.md](academy/キースキルズ/ベーシック/BNI_BasicTraining_workshop_notes_20260427.md) | **BNI ベーシックトレーニング受講メモ**（2026-04-27）。スライドPDF（202405）のスライド番号1〜86ごとにメモ欄を用意し、ハンドブック10項目・5年後ビジョン・研修後アクションまで記録できる当日用テンプレート。 |
| [academy/005_パワーチームワークショップ/BNI_PowerTeam_workshop_notes_20260610.md](academy/005_パワーチームワークショップ/BNI_PowerTeam_workshop_notes_20260610.md) | **パワーチーム WS 受講メモ・議事録**（2026-06-10 **15:00–17:30 JST**、講師: 山崎勇一 ARD）。**ver3.1（27枚）** SSOT: [配布用 PDF](academy/005_パワーチームワークショップ/%E9%85%8D%E5%B8%83%E7%94%A8_Power%20Team%20Workshop%20ver3.1%EF%BC%88%E5%8F%97%E8%AC%9B%E8%80%85%E7%94%A8%EF%BC%89.pdf)。ThreeBiz TM・PALMS MTLR候補・初回1to1・BNI外招待ルール・9ステップ面談・目標2/6/7採用・Zoom文字起こし要約。チャプター外候補に石原氏・打田康平氏（KATANA・非BNI）を記録。教材: ターゲットマーケットWS・Referral Hub・スクリプト・プランニング・目標設定シート。 |
| [academy/トレーニングのおすすめ順番.docx](academy/トレーニングのおすすめ順番.docx) | BNI トレーニングのおすすめ順番（Word）。 |

### tugilo AI DevOS v4.3

| ファイル | 説明 |
|----------|------|
| [.cursor/rules/devos-v4.mdc](../.cursor/rules/devos-v4.mdc) | DevOS 本体ルール（alwaysApply: true）。Phase 管理・SSOT 起点・Merge Evidence。**プロジェクト共有ルールとして repo 管理。** |

### 仕様（docs/02_specifications/）

| ファイル | 説明 |
|----------|------|
| [SSOT_REGISTRY.md](02_specifications/SSOT_REGISTRY.md) | 仕様一覧（SSOT の起点）。AI は仕様参照時必ずここから。 |
| [workspace_vs_chapter_fit_gap_20260403.md](02_specifications/workspace_vs_chapter_fit_gap_20260403.md) | **調査:** `workspace` と **Chapter** を常に同義としない Fit & Gap。**前提:** Member は **1 Chapter にのみ所属**（複数兼務は現スコープ外）・Country>Region>Chapter。案A/B・推奨段階。**記録:** [PHASE_WORKSPACE_CHAPTER_FIT_GAP_P1_REPORT.md](process/phases/PHASE_WORKSPACE_CHAPTER_FIT_GAP_P1_REPORT.md)（2026-04-17 業務ルール追記）。 |

### アーキテクチャ（docs/01_architecture/）

| ファイル | 説明 |
|----------|------|
| [README.md](01_architecture/README.md) | アーキテクチャ関連ドキュメントの格納先。 |

### 運用（docs/03_operations/）

| ファイル | 説明 |
|----------|------|
| [README.md](03_operations/README.md) | 運用・デプロイ・監視ドキュメントの格納先。 |

### Git 運用（docs/git/）

| ファイル | 説明 |
|----------|------|
| [BRANCH_STRATEGY.md](git/BRANCH_STRATEGY.md) | ブランチ規約（main / develop / feature/phaseXXX-name）。DevOS v4.3。 |
| [PRLESS_MERGE_FLOW.md](git/PRLESS_MERGE_FLOW.md) | PR を介さない取り込みフロー（feature → develop のローカル merge、証跡の残し方、禁止事項、トラブル時）。 |

### SSOT（docs/SSOT/）

| ファイル | 説明 |
|----------|------|
| [DATA_MODEL.md](SSOT/DATA_MODEL.md) | Religo 会の地図（Relationship Map）データモデル。エンティティ・テーブル定義・**Workspace と User（BNI 1 user = 1 workspace）**・`users.religo_role`（SPEC-010）・派生指標・Phase 対応の SSOT。 |
| [MEMBERS_REQUIREMENTS.md](SSOT/MEMBERS_REQUIREMENTS.md) | Religo Members（メンバー一覧・詳細）要件の SSOT。List/Show/Edit の表示項目・操作・メモ・1to1・役職履歴・権限・非目標・DoD。 |
| [MEMBERS_REQUIREMENTS_REVIEW.md](SSOT/MEMBERS_REQUIREMENTS_REVIEW.md) | Members 要件整理結果。要件サマリ・現状との差分・不明点・推奨設計。実装前の参照用。 |
| [MEMBERS_MOCK_VS_UI_SUMMARY.md](SSOT/MEMBERS_MOCK_VS_UI_SUMMARY.md) | Members のモックと実装の差・要件まとめ。差分一覧・要件対応・チェックリスト。 |
| [ADMIN_UI_THEME_SSOT.md](SSOT/ADMIN_UI_THEME_SSOT.md) | Religo 管理画面 UI Theme の SSOT。Typography / Shape / Spacing / Components override / ReactAdmin ルール。 |
| [AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md](SSOT/AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md) | **SPEC-010** — ユーザーログイン導入時に **ログインアカウントと Owner（`users.owner_member_id`）を一貫**させる要件（認証・Authorization・UI・移行・DoD）。**active**／記録: Phase 126。 |
| [AUTH_REGISTRATION_EMAIL_REQUIREMENTS.md](SSOT/AUTH_REGISTRATION_EMAIL_REQUIREMENTS.md) | **SPEC-011** — 初回アカウント登録（members.email 照合）の **確認コードメール送信**要件。本番 `.env` MAIL 設定前提・debug_code 抑止・送信失敗時の扱い。**active**／記録: Phase 147。 |
| [ZOOM_ONETOONE_SYNC_REQUIREMENTS.md](SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md) | **SPEC-012** — Zoom 連携による **1 to 1 の予定起票・実績時刻反映・要約取得・相手の手動正規化**の要件整理。Zoom を正の情報源に二重入力と時刻 TODO を削減。相手未登録は M7/M8（CSV 取込）・SPEC-008 を流用し人の確認必須。カレンダー連携は当面非採用。段階1（読取取込）→2（要約）→3（Webhook）。**active**（実装: Phase 152・189 で per-user app credentials）。 |
| [ONETOONE_PREP_PROFILE_REQUIREMENTS.md](SSOT/ONETOONE_PREP_PROFILE_REQUIREMENTS.md) | **SPEC-013** — 1 to 1 事前準備。相手プロフィール（**PDF D&D / NCAS URL**）を 1to1 に添付・テキスト化し、**ユーザーごとの AI（BYO key・OpenAI 実装）**で原稿（基本プロフィール/共通点/リファーラル戦略/台本/次アクション）を生成→notes/メモ保存。Cursor のローカル md 作成を Religo サーバ上で再現。**active**（P1+P2・OpenAI）／記録: Phase 155。 |
| [ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md](SSOT/ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md) | **SPEC-015** — 121 **リファーラル提案**（§1.0 BNI/COMMON §0.8 参照）。MVP 190–192 済。Phase F=横断・つなぎ手経由（195）。 |
| [CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md](SSOT/CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md) | **SPEC-016** — 定例会議事録からのリファーラル提案。Meetings 入口・`meeting_id` 付き登録。MVP 190–192 済。COMMON §0.8 同様。 |
| [SONAE_REQUIREMENTS.md](SSOT/SONAE_REQUIREMENTS.md) | **SPEC-017** — SONAE 要件定義。Religo オプション・`sonae_*` DB・Member Roster Policy・JMAXML 9種・発報条件 UI・PoC L1/L2・将来の地域別回答義務。 |
| [SONAE_WALL_BOUNCE_DECISIONS.md](SSOT/SONAE_WALL_BOUNCE_DECISIONS.md) | **SPEC-017 補足** — PoC 着手前の壁打ち合意事項（Religo/単体両対応、members sync、JMA、閾値 UI、将来拡張）。 |
| [SONAE_IMPLEMENTATION_PLAN.md](SSOT/SONAE_IMPLEMENTATION_PLAN.md) | **SPEC-017 実装計画** — Religo 疎結合・tugilo Phase 244–252 ロードマップ（L1/L2・機能別分割）。 |
| [SONAE_POC_RUNBOOK.md](SSOT/SONAE_POC_RUNBOOK.md) | **SPEC-017 PoC Runbook** — DragonFly 導入5ステップ実行手順・fixture JMA 運用・L1/L2 達成基準。Phase 252。 |
| [SONAE_DEV_ENV_SETUP.md](SSOT/SONAE_DEV_ENV_SETUP.md) | **SPEC-017 開発環境手順** — religo-dev へのデプロイ・`db-replicate-prod-to-dev`・開発用 LINE（LIFF 不要）・L1/L2 検証の順序付き手順。 |
| [REFERRAL_SUGGESTION_COMMON.md](SSOT/REFERRAL_SUGGESTION_COMMON.md) | **リファーラル提案 共通 SSOT**（SPEC-015/016）。§0 理想・§0.5 フライホイール・§0.7 共有同意・§0.8 つなぎ手きっかけ・§0.8.6 二経路（自己履歴/他者NW）・**§0.8.7 Givers Gain**。MVP 190–192 済 → [ロードマップ](process/phases/REFERRAL_SUGGESTION_PHASE_ROADMAP.md)。 |
| [CHAPTER_MINUTES_REQUIREMENTS.md](SSOT/CHAPTER_MINUTES_REQUIREMENTS.md) | **SPEC-014** — チャプター定例会議事録の DB 化。`meeting_minutes`（meetings 1:1）、Markdown file→DB 一方向、`dragonfly:import-chapter-minutes`、Meetings 閲覧。**active**／記録: Phase 180。 |
| [TEAM_MEETING_MINUTES_REQUIREMENTS.md](SSOT/TEAM_MEETING_MINUTES_REQUIREMENTS.md) | **SPEC-018** — チーム MTG 議事録 DB 化。`meeting_types` マスタ、`meetings.team_id`、`dragonfly:import-team-minutes`、Meetings 種別/チーム履歴フィルタ。**active（要件確定・実装未着手）**／記録: Phase 234。 |
| [ONETOONE_MULTI_SESSION_IMPORT_REQUIREMENTS.md](SSOT/ONETOONE_MULTI_SESSION_IMPORT_REQUIREMENTS.md) | **SPEC-019** — 1to1 議事録の **マルチセッション取り込み**。1相手1ファイル・`### 【第N回】` ごとに `one_to_ones` 行を更新/作成（`dragonfly:import-1to1-notes` 拡張、`--create-missing`・セクション単位 `notes`）。**draft（要件確定・実装未着手）**。 |
| [ONBOARDING_AND_ACCOUNT_PROVISIONING.md](SSOT/ONBOARDING_AND_ACCOUNT_PROVISIONING.md) | **オンボーディング & アカウント発行**（SPEC-020 Phase E / 順位 9）。自己登録（email 一致 + 確認コード + owner 自動紐付け）を正式採用。admin による `members.email` 整備が前提。PoC 配布チェックリスト・Fit&Gap を記載。記録: Phase 266。 |
| [TEST_USER_ONBOARDING_FLOW.md](SSOT/TEST_USER_ONBOARDING_FLOW.md) | **テストユーザー追加 — 運用フロー & 要件**。管理者による `members.email` 登録 → ログイン案内 → 初回確認コードメール → パスワード作成 → 初回ログイン。Member 編集での email 設定可否・パスワード再発行 Gap・案内文テンプレート・エラー対応を記載。2026-06-27。 |
| [FIT_AND_GAP_MEMBER_EMAIL_REGISTRATION.md](SSOT/FIT_AND_GAP_MEMBER_EMAIL_REGISTRATION.md) | **メンバー email 登録機能の Fit&Gap**。UI（`MemberEdit`）/DataProvider（PUT members）/API（`DragonFlyMemberController::update`・workspace 内 unique）/テスト（`DragonFlyMemberEmailTest`）の全層を検証。**実装済み（Fit）**、Gap は一覧ドロワーからの直接編集導線のみ（軽微）。2026-06-27。 |
| [ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md](SSOT/ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md) | **SPEC-020** — 1to1 **実施後記録のマルチユーザー化**。要約コピペ（MVP）・Zoom API 取得（拡張）・**AI 校正（BYO key 設定者のみ）**・DB プライベート保存。「誰といつ 1to1」は本人のみ。定例会議事録は管理者運用のまま。**§11** に Religo 権限構造 As-Is（`religo_role` 適用範囲・未認証 fallback・Default user risk）、メンバー展開ブロッカー、優先順位（P0-A/B/C・順位1〜15）、フェーズ分割案、他チャプター・東京NE展開条件を記載。**draft**／記録: 2026-06-27 要件整理。 |
| [FIT_AND_GAP_ONETOONE_MULTIUSER_MINUTES.md](SSOT/FIT_AND_GAP_ONETOONE_MULTIUSER_MINUTES.md) | **SPEC-020** 実装比較。`one_to_ones`・Zoom/AI 基盤は Fit。認可境界・実施後記録 UX・`raw_summary`・`religo_role` 実効範囲が Gap。**§2.2.1 / §6** に権限構造・DragonFly メンバー展開時の横断問題、**§4** に優先順位（P0-A/B/C・順位1〜15）とフェーズ別実装計画案を整理。 |
| [MEETING_DOMAIN_IA.md](SSOT/MEETING_DOMAIN_IA.md) | 集会ドメイン IA（種別横断）。Meeting=集約ルート、Connections=BO 編集面（chapter_* のみ）、Meetings=管理ハブ（種別フィルタ・議事録モーダル）。SPEC-014 / SPEC-018 関連。 |
| [ZOOM_IMPORT_MEMBER_RESOLUTION_FIT_AND_GAP.md](SSOT/ZOOM_IMPORT_MEMBER_RESOLUTION_FIT_AND_GAP.md) | **Zoom 取り込み — 未登録相手の新規メンバー作成 & 過去履歴 Fit&Gap**。実機調査（過去は取得済み・未登録相手で `held`）、新規作成フロー案A/B/C・相手名推定改善・Open Questions。 |
| [ZOOM_IMPORT_DEDUP_REQUIREMENTS.md](SSOT/ZOOM_IMPORT_DEDUP_REQUIREMENTS.md) | **Zoom 取り込みと既存DBの重複解消 要件**。実機調査（セッション重複8組・メンバー重複〔御手洗等〕）、原因（zoom_* 一致のみ・氏名完全一致のみ）、再発防止（owner+target+同日 検知）＋クリーンアップ（member統合・重複1to1整理）・Open Questions。 |
| [ZOOM_INTEGRATION_SETUP.md](SSOT/ZOOM_INTEGRATION_SETUP.md) | **SPEC-012 運用手順（Runbook）** — Zoom Marketplace OAuth アプリ作成・最小スコープ・Redirect/Webhook 登録、HTTPS トンネル（ngrok）、`.env` 安全設定（`php -r`・手動編集禁止）、連携→取得→複数選択→1to1 登録→要約→Webhook 検証、運用注意・トラブルシュート。記録: Phase 153。 |
| [ADMIN_GLOBAL_OWNER_SELECTION.md](SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md) | **グローバルヘッダーでの Owner 選択**（SPEC-003）・全画面で同一 `owner_member_id` を基準にする要件。**記録:** [PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_REPORT.md](process/phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_REPORT.md)（実装・`ReligoOwnerContext`・follow-up 一括取り込み）。 |
| [MOCK_UI_VERIFICATION.md](SSOT/MOCK_UI_VERIFICATION.md) | モック比較による UI 検証ルール。手順・チェックリスト・参照 URL。UI 改修 Phase は PLAN に「モック比較」を必須。 |
| [FIT_AND_GAP_MOCK_VS_UI.md](SSOT/FIT_AND_GAP_MOCK_VS_UI.md) | モック vs 実装 UI のフィット＆ギャップ一覧（画面別）。 |
| [FIT_AND_GAP_BO_COPY_FROM_PREVIOUS.md](SSOT/FIT_AND_GAP_BO_COPY_FROM_PREVIOUS.md) | Connections **BO 追加時の直前 BO からメンバーコピー** Fit/Gap。**Phase 219:** BO3+ 永続化・コピー一般化済み。 |
| [FIT_AND_GAP_MENU_HEADER.md](SSOT/FIT_AND_GAP_MENU_HEADER.md) | メニュー・ヘッダーに特化したフィット＆ギャップ（モック v2 基準）。**2026-04-06:** カスタム AppBar・グローバル Owner（SPEC-003）・`/settings` ゲート例外を §4.1 に反映。 |
| [FIT_AND_GAP_MEETINGS.md](SSOT/FIT_AND_GAP_MEETINGS.md) | Meetings 画面のモック vs 実装のフィット＆ギャップ調査（#/meetings 基準）。 |
| [FIT_AND_GAP_MARKDOWN_VIEWER.md](SSOT/FIT_AND_GAP_MARKDOWN_VIEWER.md) | **Markdown ビューア**（議事録・1to1 notes・例会メモ・履歴メモ）の Fit/Gap。`MarkdownView` + `remark-gfm`（Phase 181–182）。P3: 相対リンク方針。 |
| [MEETINGS_CREATE_FIT_AND_GAP.md](SSOT/MEETINGS_CREATE_FIT_AND_GAP.md) | Meetings 例会マスタ（新規作成・編集・削除）の要否・現状実装・Fit/Gap・案A/B/C・推奨方針（調査 SSOT）。 |
| [MEETINGS_DELETE_FIT_AND_GAP.md](SSOT/MEETINGS_DELETE_FIT_AND_GAP.md) | Meetings **削除**の業務要否・子データ/FK影響・案A〜E・推奨・実装前の決定事項（調査のみ・コード変更なし）。 |
| [MEETINGS_ARCHIVE_FIT_AND_GAP.md](SSOT/MEETINGS_ARCHIVE_FIT_AND_GAP.md) | Meetings **Archive**（非表示/論理無効化/履歴保持）の要否・Delete 代替との関係・子データ/一覧/stats/Drawer 影響・設計案A〜F・推奨・実装前の決定事項。**補足前提:** 初回は `archived_at` のみ・`show` 非破壊・`next_meeting` は未アーカイブのみ・初回 restore 不要（調査のみ・コード変更なし）。 |
| [ONETOONES_DELETE_REQUIREMENTS.md](SSOT/ONETOONES_DELETE_REQUIREMENTS.md) | 1 to 1 **削除不採用**の製品方針・`canceled` の業務定義・`exclude_canceled` 一覧既定・物理削除を見送る理由（SSOT）。 |
| [ONETOONES_CANCEL_FIT_AND_GAP.md](SSOT/ONETOONES_CANCEL_FIT_AND_GAP.md) | 1 to 1 **予定キャンセル** Fit/Gap + **§10 合意済み**（POST cancel・専用列・UI「キャンセル」）。Phase 184 で DATA_MODEL / DELETE ポリシーへ反映。 |
| [ONETOONES_CREATE_UX_REQUIREMENTS.md](SSOT/ONETOONES_CREATE_UX_REQUIREMENTS.md) | 1 to 1 **Create** UX：相手サマリ・予定開始＋所要時間・例会 Autocomplete。Create P1 実装済み（要件 SSOT）。 |
| [ONETOONES_EDIT_UI_FIT_AND_GAP.md](SSOT/ONETOONES_EDIT_UI_FIT_AND_GAP.md) | 1 to 1 **Edit** 画面を Create と比較した Fit/Gap。**ONETOONES_EDIT_UX_P2** で主要 Gap を解消（§8）。 |
| [ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md](SSOT/ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md) | 1 to 1 **一覧 Quick Create Dialog** の Fit/Gap。**ONETOONES_QUICK_CREATE_UX_P3** で Create と同一フォーム・同一 payload に統一。 |
| [ONETOONES_TARGET_PREFILL_FIT_AND_GAP.md](SSOT/ONETOONES_TARGET_PREFILL_FIT_AND_GAP.md) | 1 to 1 作成時の **`target_member_id` プリフィル**（URL クエリ）。**ONETOONES_DASHBOARD_TARGET_PREFILL_P4**（Create 検証・Tasks・Quick Create）。 |
| [ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md](SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md) | **SPEC-006** — チャプター外 1 to 1 の **解釈A（記録コンテキスト）**・**国/リージョン/チャプター階層**・API/UI。**記録:** [PHASE_ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1_REPORT.md](process/phases/PHASE_ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1_REPORT.md)。 |
| [DASHBOARD_REQUIREMENTS.md](SSOT/DASHBOARD_REQUIREMENTS.md) | ダッシュボード画面をモック（religo-admin-mock2.html）に合わせるための要件。構成・ブロック・データ・チェックリスト。 |
| [DASHBOARD_DATA_SSOT.md](SSOT/DASHBOARD_DATA_SSOT.md) | Dashboard のデータ定義 SSOT。stats/tasks/activity の定義・owner_member_id（**SPA はクエリで owner を付与**）・**未接触 peer は owner と同一 workspace・guest/visitor 除外**・件数上限・実装紐づけ・**§6 実数検証**。今月1to1実施数は `COALESCE(started_at, scheduled_at, updated_at)`；`last_contact` の 1to1 は `created_at` フォールバック。 |
| [DASHBOARD_TASK_SOURCE_ANALYSIS.md](SSOT/DASHBOARD_TASK_SOURCE_ANALYSIS.md) | 「今日やること（Tasks）」の取得元トレース（UI・API・DashboardService・DB・workspace 未適用・SSOT ギャップ）。 |
| [DASHBOARD_FIT_AND_GAP.md](SSOT/DASHBOARD_FIT_AND_GAP.md) | Dashboard のモック v2 構造分解・データ要件・現行実装との Fit & Gap・実装方針・次 Phase。 |
| [DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md](SSOT/DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md) | **SPEC-004** — Dashboard に **ウィークリープレゼン（例:25秒）/ スタートダッシュ原稿**を表示する要件。Owner 紐づけ・UI 配置・タブ切替・データ案・DoD。 |
| [DASHBOARD_ONETOONE_LEADS_REQUIREMENTS.md](SSOT/DASHBOARD_ONETOONE_LEADS_REQUIREMENTS.md) | **SPEC-005** — Dashboard **次の1to1候補**の **カテゴリ表示**・API `category_label`・絞り込み・**guest/visitor を対象外**。 |
| [CONTACT_LOGIC_ALIGNMENT.md](SSOT/CONTACT_LOGIC_ALIGNMENT.md) | 接触ロジック整合（`last_contact_at`・**BO 同一ルーム同席＝接触**・999・1to1 completed のみ・改善 A/B/C）。 |
| [BO_AUDIT_LOG_DESIGN.md](SSOT/BO_AUDIT_LOG_DESIGN.md) | BO（breakout）割当保存の監査ログ設計・Dashboard `bo_assigned` のイベント源（BO-AUDIT-P1〜）。 |
| [USER_ME_AND_ACTOR_RESOLUTION.md](SSOT/USER_ME_AND_ACTOR_RESOLUTION.md) | `/api/users/me`・BO 監査 actor・**所属チャプター**（workspace）解決の SSOT（BO-AUDIT-P3〜P4・WORKSPACE-SINGLE-CHAPTER-ASSUMPTION）。 |
| [WORKSPACE_RESOLUTION_POLICY.md](SSOT/WORKSPACE_RESOLUTION_POLICY.md) | `workspace_id` 解決順（**所属** `default_workspace_id` → legacy 補完 → システムフォールバック）。BNI 1 user = 1 workspace 前提（BO-AUDIT-P4 / WORKSPACE-SINGLE-CHAPTER-ASSUMPTION）。 |
| [MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md](SSOT/MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md) | **`members.workspace_id`**（所属チャプター）の意味・backfill 順序・null。MEMBERS-WORKSPACE-BACKFILL-P1。 |
| [CONNECTIONS_REQUIREMENTS.md](SSOT/CONNECTIONS_REQUIREMENTS.md) | Connections 画面（会の地図）をモックに合わせるための要件。3 ペイン構成・Members/Meeting+BO/Relationship Log・チェックリスト。 |
| [CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md](SSOT/CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md) | Connections の BO 割当・Relationship Log 見出しで **メンバー名に加えカテゴリ表示**する要件・Fit/Gap（左ペインは既存 Fit）。 |
| [CONNECTIONS_INTELLIGENCE_SSOT.md](SSOT/CONNECTIONS_INTELLIGENCE_SSOT.md) | Connections 関係の知性（Relationship Summary / Next Action）の SSOT。表示項目・ルール・データソース・UI 配置。C-6。 |
| [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md) | **SPEC-007** — ビジター／ゲストの入会時の `members`／`participants` 方針、**代理出席**（`guest`/`proxy`）と BO の関係、Connections 左ペイン（`meeting_id` スコープ・5.4 表）・BO 保存との整合。**§0 Phase 0〜6**（整備の到達点・CONN-/MEMBERS- Phase ID 対応表）。 |
| [MEMBERS_DEDUPLICATION_RUNBOOK.md](SSOT/MEMBERS_DEDUPLICATION_RUNBOOK.md) | **SPEC-008** — `members` 重複の発生条件・業務影響・マージ運用（案 A/B/C）。§7.1 **MEMBERS-MERGE-ASSIST-P1**（トークン API・`/member-merge`）。**自動マージ・推測確定は対象外**。 |
| [RELATIONSHIP_SCORE_SSOT.md](SSOT/RELATIONSHIP_SCORE_SSOT.md) | Relationship Score（関係温度 0〜5・★表示）の SSOT。計算ルール・データソース・UI 配置。C-7。 |
| [REFERRAL_RECORDING_REQUIREMENTS.md](SSOT/REFERRAL_RECORDING_REQUIREMENTS.md) | **SPEC-009** — リファーラル記録（外部／内部）。§2.1 **Givers Gain・つなぎ手 from=A**（COMMON 連携）。Phase 122。提案 MVP 190–192 連携。 |
| [INTRODUCTION_HINT_SSOT.md](SSOT/INTRODUCTION_HINT_SSOT.md) | Introduction Hint（紹介候補・業種→業種 最大3件）の SSOT。members summary_lite と C-7 スコア利用。C-8。 |
| [ROADMAP.md](SSOT/ROADMAP.md) | Religo 全体ロードマップ SSOT。Phase 順序・DoD・依存・スコープロック・テスト規約・Execution Playbook・Next 3。 |
| [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md) | Meetings 参加者PDF取込の要件整理たたき台。業務フロー A/B/C・画面・データ・Phase 案・リスク・推奨方針。実装前参照用。 |
| [MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md](SSOT/MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md) | Meetings 参加者CSV取込（ChatGPT作成CSV連携）の要件整理たたき台。業務フロー・画面・データ・CSV仕様・既存連携・フェーズ案。実装前参照用。 |
| [MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md](SSOT/MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md) | Meetings 参加者CSV反映の差分更新方式の要件整理。全置換 vs 差分更新・BO保護・判定キー・UI/UX・フェーズ案。実装前参照用。 |
| [MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md](SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md) | Meetings 参加者CSV反映の participants 差分更新 + members 更新 + Role History 連携の要件整理。反映対象3層・members項目分類・カテゴリー・役割履歴・フェーズ案。実装前参照用。 |

### プロダクト要件（docs/product/）

| ファイル | 説明 |
|----------|------|
| [DRAGONFLY_REQUIREMENTS.md](product/DRAGONFLY_REQUIREMENTS.md) | DragonFly 要件定義（目的・Phase・UX・技術構成・Cursor 向けルール）。 |

### 詳細資料（docs/process/）

Phase 別の詳細な PLAN / WORKLOG / REPORT を置く場合は docs/process/ を使用し、この一覧に追記する。**develop への取り込み後**は REPORT に「取り込み証跡」を記録する。DevOS v4.3: 次番号は [PHASE_REGISTRY.md](process/PHASE_REGISTRY.md)、仕様起点は [SSOT_REGISTRY.md](02_specifications/SSOT_REGISTRY.md)。

| ファイル | 説明 |
|----------|------|
| [README.md](process/README.md) | process/ の必須ルール（進捗・INDEX 更新・**日付は時刻まで**・Phase 完了時は **develop merge 後に `git push origin develop`**・取得コマンド例）。 |
| [PROMPT_SSOT_IMPROVEMENT.md](process/PROMPT_SSOT_IMPROVEMENT.md) | **SSOT 改善用プロンプト**（実装ブレ防止・観点7・出力形式3部・任意のバグ想定オプション）。Cursor/人間レビュー兼用。 |
| [PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md](process/PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md) | **ADMIN_GLOBAL_OWNER_SELECTION 専用**の改善プロンプト（未設定・初期ロード・dataProvider・禁止パターン・Phase 順・出力4部）。 |
| [PHASE_REGISTRY.md](process/PHASE_REGISTRY.md) | Phase 履歴（全 Phase 一覧）。次番号取得はここを参照。 |
| [FEATURE_BRANCH_MERGE_PLAN.md](process/FEATURE_BRANCH_MERGE_PLAN.md) | feature/* 棚卸しと develop 取り込み計画（merge は実行しない）。 |
| [PHASE12T_AND_M4_MERGE_VERIFICATION_REPORT.md](process/PHASE12T_AND_M4_MERGE_VERIFICATION_REPORT.md) | phase12t 取り込み可否および M4D〜M4L Git 実態の最終確認報告（merge/push 未実行）。 |
| [templates/PHASE_REPORT_TEMPLATE.md](process/templates/PHASE_REPORT_TEMPLATE.md) | Phase REPORT の証跡欄テンプレート（merge commit id・変更ファイル一覧・テスト結果等）。 |
| [templates/TEMPLATE_PHASE_PLAN.md](process/templates/TEMPLATE_PHASE_PLAN.md) | Phase PLAN テンプレート（DevOS v4.3）。 |
| [templates/TEMPLATE_PHASE_WORKLOG.md](process/templates/TEMPLATE_PHASE_WORKLOG.md) | Phase WORKLOG テンプレート（DevOS v4.3）。 |
| [templates/TEMPLATE_PHASE_REPORT.md](process/templates/TEMPLATE_PHASE_REPORT.md) | Phase REPORT テンプレート（DevOS v4.3・Merge Evidence 含む）。 |
| [phases/PHASE_221_claude_code_setup_PLAN.md](process/phases/PHASE_221_claude_code_setup_PLAN.md) | Phase 221: Claude Code セットアップ（AI_TOOLING / CLAUDE.md / .claude）PLAN。 |
| [phases/PHASE_221_claude_code_setup_WORKLOG.md](process/phases/PHASE_221_claude_code_setup_WORKLOG.md) | Phase 221: 同 WORKLOG。 |
| [phases/PHASE_221_claude_code_setup_REPORT.md](process/phases/PHASE_221_claude_code_setup_REPORT.md) | Phase 221: 同 REPORT。 |
| [phases/PHASE_222_kumagai_ryusho_121_prep_PLAN.md](process/phases/PHASE_222_kumagai_ryusho_121_prep_PLAN.md) | Phase 222: 熊谷龍笙 121事前準備（株式会社Lifinity／通信費削減）PLAN。 |
| [phases/PHASE_222_kumagai_ryusho_121_prep_WORKLOG.md](process/phases/PHASE_222_kumagai_ryusho_121_prep_WORKLOG.md) | Phase 222: 同 WORKLOG。 |
| [phases/PHASE_222_kumagai_ryusho_121_prep_REPORT.md](process/phases/PHASE_222_kumagai_ryusho_121_prep_REPORT.md) | Phase 222: 同 REPORT。 |
| [phases/PHASE_223_kumagai_ryusho_121_minutes_PLAN.md](process/phases/PHASE_223_kumagai_ryusho_121_minutes_PLAN.md) | Phase 223: 熊谷龍笙 第1回121 Zoom要約反映 PLAN。 |
| [phases/PHASE_223_kumagai_ryusho_121_minutes_WORKLOG.md](process/phases/PHASE_223_kumagai_ryusho_121_minutes_WORKLOG.md) | Phase 223: 同 WORKLOG。 |
| [phases/PHASE_223_kumagai_ryusho_121_minutes_REPORT.md](process/phases/PHASE_223_kumagai_ryusho_121_minutes_REPORT.md) | Phase 223: 同 REPORT。 |
| [phases/PHASE_224_sonae_requirements_PLAN.md](process/phases/PHASE_224_sonae_requirements_PLAN.md) | Phase 224: SONAE 要件定義 PLAN。 |
| [phases/PHASE_224_sonae_requirements_WORKLOG.md](process/phases/PHASE_224_sonae_requirements_WORKLOG.md) | Phase 224: 同 WORKLOG。 |
| [phases/PHASE_224_sonae_requirements_REPORT.md](process/phases/PHASE_224_sonae_requirements_REPORT.md) | Phase 224: 同 REPORT。 |
| [phases/PHASE_225_sonae_iida_kaori_proposal_PLAN.md](process/phases/PHASE_225_sonae_iida_kaori_proposal_PLAN.md) | Phase 225: SONAE 飯田香さん向け提案書 PLAN。 |
| [phases/PHASE_225_sonae_iida_kaori_proposal_WORKLOG.md](process/phases/PHASE_225_sonae_iida_kaori_proposal_WORKLOG.md) | Phase 225: 同 WORKLOG。 |
| [phases/PHASE_225_sonae_iida_kaori_proposal_REPORT.md](process/phases/PHASE_225_sonae_iida_kaori_proposal_REPORT.md) | Phase 225: 同 REPORT。 |
| [phases/PHASE_226_fukushi_toshiaki_121_prep_PLAN.md](process/phases/PHASE_226_fukushi_toshiaki_121_prep_PLAN.md) | Phase 226: 福士利明 121事前準備（株式会社ユニバースプロダクツ／コンクリート内部防水テクノロジー）PLAN。 |
| [phases/PHASE_226_fukushi_toshiaki_121_prep_WORKLOG.md](process/phases/PHASE_226_fukushi_toshiaki_121_prep_WORKLOG.md) | Phase 226: 同 WORKLOG。 |
| [phases/PHASE_226_fukushi_toshiaki_121_prep_REPORT.md](process/phases/PHASE_226_fukushi_toshiaki_121_prep_REPORT.md) | Phase 226: 同 REPORT。 |
| [phases/PHASE_227_fukushi_toshiaki_121_minutes_PLAN.md](process/phases/PHASE_227_fukushi_toshiaki_121_minutes_PLAN.md) | Phase 227: 福士利明 第1回121 Zoom要約反映（CTP2000・国際物流・システム相談）PLAN。 |
| [phases/PHASE_227_fukushi_toshiaki_121_minutes_WORKLOG.md](process/phases/PHASE_227_fukushi_toshiaki_121_minutes_WORKLOG.md) | Phase 227: 同 WORKLOG。 |
| [phases/PHASE_227_fukushi_toshiaki_121_minutes_REPORT.md](process/phases/PHASE_227_fukushi_toshiaki_121_minutes_REPORT.md) | Phase 227: 同 REPORT。 |
| [phases/PHASE_228_hirano_masakuni_121_prep_PLAN.md](process/phases/PHASE_228_hirano_masakuni_121_prep_PLAN.md) | Phase 228: 平野眞邦 121事前準備（有限会社 美研テクノ／防水工事・害虫ブロック）PLAN。 |
| [phases/PHASE_228_hirano_masakuni_121_prep_WORKLOG.md](process/phases/PHASE_228_hirano_masakuni_121_prep_WORKLOG.md) | Phase 228: 同 WORKLOG。 |
| [phases/PHASE_228_hirano_masakuni_121_prep_REPORT.md](process/phases/PHASE_228_hirano_masakuni_121_prep_REPORT.md) | Phase 228: 同 REPORT。 |
| [phases/PHASE_229_yokoyama_taiki_121_prep_PLAN.md](process/phases/PHASE_229_yokoyama_taiki_121_prep_PLAN.md) | Phase 229: 横山太樹 121事前準備（株式会社ARATAS／資金調達支援）PLAN。 |
| [phases/PHASE_229_yokoyama_taiki_121_prep_WORKLOG.md](process/phases/PHASE_229_yokoyama_taiki_121_prep_WORKLOG.md) | Phase 229: 同 WORKLOG。 |
| [phases/PHASE_229_yokoyama_taiki_121_prep_REPORT.md](process/phases/PHASE_229_yokoyama_taiki_121_prep_REPORT.md) | Phase 229: 同 REPORT。 |
| [phases/PHASE_230_yokoyama_taiki_121_minutes_PLAN.md](process/phases/PHASE_230_yokoyama_taiki_121_minutes_PLAN.md) | Phase 230: 横山太樹 第1回121 Zoom要約反映（ARATAS財務顧問・法人化相談・DragonFly入会検討）PLAN。 |
| [phases/PHASE_230_yokoyama_taiki_121_minutes_WORKLOG.md](process/phases/PHASE_230_yokoyama_taiki_121_minutes_WORKLOG.md) | Phase 230: 同 WORKLOG。 |
| [phases/PHASE_230_yokoyama_taiki_121_minutes_REPORT.md](process/phases/PHASE_230_yokoyama_taiki_121_minutes_REPORT.md) | Phase 230: 同 REPORT。 |
| [phases/PHASE_231_dragonfly_weekly_20260623_minutes_PLAN.md](process/phases/PHASE_231_dragonfly_weekly_20260623_minutes_PLAN.md) | Phase 231: DragonFly 定例会 2026-06-23 議事録保存 PLAN。 |
| [phases/PHASE_231_dragonfly_weekly_20260623_minutes_WORKLOG.md](process/phases/PHASE_231_dragonfly_weekly_20260623_minutes_WORKLOG.md) | Phase 231: 同 WORKLOG。 |
| [phases/PHASE_231_dragonfly_weekly_20260623_minutes_REPORT.md](process/phases/PHASE_231_dragonfly_weekly_20260623_minutes_REPORT.md) | Phase 231: 同 REPORT。 |
| [phases/PHASE_232_sonae_community_strategy_update_PLAN.md](process/phases/PHASE_232_sonae_community_strategy_update_PLAN.md) | Phase 232: SONAE Community 戦略反映 PLAN。 |
| [phases/PHASE_232_sonae_community_strategy_update_WORKLOG.md](process/phases/PHASE_232_sonae_community_strategy_update_WORKLOG.md) | Phase 232: 同 WORKLOG。 |
| [phases/PHASE_232_sonae_community_strategy_update_REPORT.md](process/phases/PHASE_232_sonae_community_strategy_update_REPORT.md) | Phase 232: 同 REPORT。 |
| [phases/PHASE_233_threebiz_yokoyama_personal_axis_minutes_PLAN.md](process/phases/PHASE_233_threebiz_yokoyama_personal_axis_minutes_PLAN.md) | Phase 233: スリーバイス 2026-06-23 横山尚武 パーソナル軸議事録 PLAN。 |
| [phases/PHASE_233_threebiz_yokoyama_personal_axis_minutes_WORKLOG.md](process/phases/PHASE_233_threebiz_yokoyama_personal_axis_minutes_WORKLOG.md) | Phase 233: 同 WORKLOG。 |
| [phases/PHASE_233_threebiz_yokoyama_personal_axis_minutes_REPORT.md](process/phases/PHASE_233_threebiz_yokoyama_personal_axis_minutes_REPORT.md) | Phase 233: 同 REPORT。 |
| [phases/PHASE_234_team_meeting_minutes_requirements_PLAN.md](process/phases/PHASE_234_team_meeting_minutes_requirements_PLAN.md) | Phase 234: チームMTG議事録 DB 化 要件整理（SPEC-018）PLAN。 |
| [phases/PHASE_234_team_meeting_minutes_requirements_WORKLOG.md](process/phases/PHASE_234_team_meeting_minutes_requirements_WORKLOG.md) | Phase 234: 同 WORKLOG。 |
| [phases/PHASE_234_team_meeting_minutes_requirements_REPORT.md](process/phases/PHASE_234_team_meeting_minutes_requirements_REPORT.md) | Phase 234: 同 REPORT。 |
| [phases/PHASE_235_meeting_types_db_PLAN.md](process/phases/PHASE_235_meeting_types_db_PLAN.md) | Phase 235: meeting_types DB（SPEC-018 Phase A）PLAN。 |
| [phases/PHASE_235_meeting_types_db_WORKLOG.md](process/phases/PHASE_235_meeting_types_db_WORKLOG.md) | Phase 235: 同 WORKLOG。 |
| [phases/PHASE_235_meeting_types_db_REPORT.md](process/phases/PHASE_235_meeting_types_db_REPORT.md) | Phase 235: 同 REPORT。 |
| [phases/PHASE_236_import_team_minutes_PLAN.md](process/phases/PHASE_236_import_team_minutes_PLAN.md) | Phase 236: import-team-minutes（SPEC-018 Phase B）PLAN。 |
| [phases/PHASE_236_import_team_minutes_WORKLOG.md](process/phases/PHASE_236_import_team_minutes_WORKLOG.md) | Phase 236: 同 WORKLOG。 |
| [phases/PHASE_236_import_team_minutes_REPORT.md](process/phases/PHASE_236_import_team_minutes_REPORT.md) | Phase 236: 同 REPORT。 |
| [phases/PHASE_237_meetings_api_filters_PLAN.md](process/phases/PHASE_237_meetings_api_filters_PLAN.md) | Phase 237: Meetings API 種別フィルタ（SPEC-018 Phase C）PLAN。 |
| [phases/PHASE_237_meetings_api_filters_WORKLOG.md](process/phases/PHASE_237_meetings_api_filters_WORKLOG.md) | Phase 237: 同 WORKLOG。 |
| [phases/PHASE_237_meetings_api_filters_REPORT.md](process/phases/PHASE_237_meetings_api_filters_REPORT.md) | Phase 237: 同 REPORT。 |
| [phases/PHASE_238_meetings_list_ui_PLAN.md](process/phases/PHASE_238_meetings_list_ui_PLAN.md) | Phase 238: MeetingsList UI 種別対応（SPEC-018 Phase D）PLAN。 |
| [phases/PHASE_238_meetings_list_ui_WORKLOG.md](process/phases/PHASE_238_meetings_list_ui_WORKLOG.md) | Phase 238: 同 WORKLOG。 |
| [phases/PHASE_238_meetings_list_ui_REPORT.md](process/phases/PHASE_238_meetings_list_ui_REPORT.md) | Phase 238: 同 REPORT。 |
| [phases/PHASE_239_team_meeting_docs_sync_PLAN.md](process/phases/PHASE_239_team_meeting_docs_sync_PLAN.md) | Phase 239: チームMTG docs 同期（SPEC-018 Phase E）PLAN。 |
| [phases/PHASE_239_team_meeting_docs_sync_WORKLOG.md](process/phases/PHASE_239_team_meeting_docs_sync_WORKLOG.md) | Phase 239: 同 WORKLOG。 |
| [phases/PHASE_239_team_meeting_docs_sync_REPORT.md](process/phases/PHASE_239_team_meeting_docs_sync_REPORT.md) | Phase 239: 同 REPORT。 |
| [phases/PHASE_240_onetoone_multi_session_import_PLAN.md](process/phases/PHASE_240_onetoone_multi_session_import_PLAN.md) | Phase 240: 1to1 マルチセッション import + 一覧共通メモモーダル（SPEC-019 P1・P3）PLAN。 |
| [phases/PHASE_240_onetoone_multi_session_import_WORKLOG.md](process/phases/PHASE_240_onetoone_multi_session_import_WORKLOG.md) | Phase 240: 同 WORKLOG。 |
| [phases/PHASE_240_onetoone_multi_session_import_REPORT.md](process/phases/PHASE_240_onetoone_multi_session_import_REPORT.md) | Phase 240: 同 REPORT。 |
| [phases/PHASE_241_sonae_poc_proposal_sync_PLAN.md](process/phases/PHASE_241_sonae_poc_proposal_sync_PLAN.md) | Phase 241: SONAE PoC 提案同期 PLAN。 |
| [phases/PHASE_241_sonae_poc_proposal_sync_WORKLOG.md](process/phases/PHASE_241_sonae_poc_proposal_sync_WORKLOG.md) | Phase 241: 同 WORKLOG。 |
| [phases/PHASE_241_sonae_poc_proposal_sync_REPORT.md](process/phases/PHASE_241_sonae_poc_proposal_sync_REPORT.md) | Phase 241: 同 REPORT。 |
| [phases/PHASE_243_sonae_requirements_wall_bounce_PLAN.md](process/phases/PHASE_243_sonae_requirements_wall_bounce_PLAN.md) | Phase 243: SONAE 壁打ち要件 SSOT 反映 PLAN。 |
| [phases/PHASE_243_sonae_requirements_wall_bounce_WORKLOG.md](process/phases/PHASE_243_sonae_requirements_wall_bounce_WORKLOG.md) | Phase 243: 同 WORKLOG。 |
| [phases/PHASE_243_sonae_requirements_wall_bounce_REPORT.md](process/phases/PHASE_243_sonae_requirements_wall_bounce_REPORT.md) | Phase 243: 同 REPORT。 |
| [phases/PHASE_242_sonae_p1_db_foundation_PLAN.md](process/phases/PHASE_242_sonae_p1_db_foundation_PLAN.md) | Phase 242: SONAE P1 DB 基盤 PLAN。 |
| [phases/PHASE_242_sonae_p1_db_foundation_WORKLOG.md](process/phases/PHASE_242_sonae_p1_db_foundation_WORKLOG.md) | Phase 242: 同 WORKLOG。 |
| [phases/PHASE_242_sonae_p1_db_foundation_REPORT.md](process/phases/PHASE_242_sonae_p1_db_foundation_REPORT.md) | Phase 242: 同 REPORT。 |
| [phases/PHASE_244_sonae_roster_core_PLAN.md](process/phases/PHASE_244_sonae_roster_core_PLAN.md) | Phase 244: SONAE Roster Core（名簿 API・CSV・閾値マスタ）PLAN。 |
| [phases/PHASE_244_sonae_roster_core_WORKLOG.md](process/phases/PHASE_244_sonae_roster_core_WORKLOG.md) | Phase 244: 同 WORKLOG。 |
| [phases/PHASE_244_sonae_roster_core_REPORT.md](process/phases/PHASE_244_sonae_roster_core_REPORT.md) | Phase 244: 同 REPORT。 |
| [phases/PHASE_245_sonae_line_integration_PLAN.md](process/phases/PHASE_245_sonae_line_integration_PLAN.md) | Phase 245: SONAE LINE 連携 PLAN。 |
| [phases/PHASE_245_sonae_line_integration_WORKLOG.md](process/phases/PHASE_245_sonae_line_integration_WORKLOG.md) | Phase 245: 同 WORKLOG。 |
| [phases/PHASE_245_sonae_line_integration_REPORT.md](process/phases/PHASE_245_sonae_line_integration_REPORT.md) | Phase 245: 同 REPORT。 |
| [phases/PHASE_249_sonae_jma_fetch_PLAN.md](process/phases/PHASE_249_sonae_jma_fetch_PLAN.md) | Phase 249: SONAE JMA 取得基盤 PLAN。 |
| [phases/PHASE_249_sonae_jma_fetch_WORKLOG.md](process/phases/PHASE_249_sonae_jma_fetch_WORKLOG.md) | Phase 249: 同 WORKLOG。 |
| [phases/PHASE_249_sonae_jma_fetch_REPORT.md](process/phases/PHASE_249_sonae_jma_fetch_REPORT.md) | Phase 249: 同 REPORT。 |
| [phases/PHASE_250_sonae_jma_ingest_PLAN.md](process/phases/PHASE_250_sonae_jma_ingest_PLAN.md) | Phase 250: SONAE JMA Normalizer + Ingest PLAN。 |
| [phases/PHASE_250_sonae_jma_ingest_WORKLOG.md](process/phases/PHASE_250_sonae_jma_ingest_WORKLOG.md) | Phase 250: 同 WORKLOG。 |
| [phases/PHASE_250_sonae_jma_ingest_REPORT.md](process/phases/PHASE_250_sonae_jma_ingest_REPORT.md) | Phase 250: 同 REPORT。 |
| [phases/PHASE_251_sonae_alert_auto_dispatch_PLAN.md](process/phases/PHASE_251_sonae_alert_auto_dispatch_PLAN.md) | Phase 251: SONAE 発報条件 + 自動発報 PLAN。 |
| [phases/PHASE_251_sonae_alert_auto_dispatch_WORKLOG.md](process/phases/PHASE_251_sonae_alert_auto_dispatch_WORKLOG.md) | Phase 251: 同 WORKLOG。 |
| [phases/PHASE_251_sonae_alert_auto_dispatch_REPORT.md](process/phases/PHASE_251_sonae_alert_auto_dispatch_REPORT.md) | Phase 251: 同 REPORT。 |
| [phases/PHASE_252_sonae_poc_runbook_PLAN.md](process/phases/PHASE_252_sonae_poc_runbook_PLAN.md) | Phase 252: SONAE PoC Runbook PLAN。 |
| [phases/PHASE_252_sonae_poc_runbook_WORKLOG.md](process/phases/PHASE_252_sonae_poc_runbook_WORKLOG.md) | Phase 252: 同 WORKLOG。 |
| [phases/PHASE_252_sonae_poc_runbook_REPORT.md](process/phases/PHASE_252_sonae_poc_runbook_REPORT.md) | Phase 252: 同 REPORT。 |
| [phases/PHASE_253_threebiz_religo_main_speaker_prep_PLAN.md](process/phases/PHASE_253_threebiz_religo_main_speaker_prep_PLAN.md) | Phase 253: スリーバイス 2026-06-30 Religo共有 メインスピーカー準備 PLAN。 |
| [phases/PHASE_253_threebiz_religo_main_speaker_prep_WORKLOG.md](process/phases/PHASE_253_threebiz_religo_main_speaker_prep_WORKLOG.md) | Phase 253: 同 WORKLOG。 |
| [phases/PHASE_253_threebiz_religo_main_speaker_prep_REPORT.md](process/phases/PHASE_253_threebiz_religo_main_speaker_prep_REPORT.md) | Phase 253: 同 REPORT。 |
| [phases/PHASE_254_takemura_yuji_onode_121_PLAN.md](process/phases/PHASE_254_takemura_yuji_onode_121_PLAN.md) | Phase 254: 竹村裕司 第1回121 Zoom要約反映（ONODE／チアプリント）PLAN。 |
| [phases/PHASE_254_takemura_yuji_onode_121_WORKLOG.md](process/phases/PHASE_254_takemura_yuji_onode_121_WORKLOG.md) | Phase 254: 同 WORKLOG。 |
| [phases/PHASE_254_takemura_yuji_onode_121_REPORT.md](process/phases/PHASE_254_takemura_yuji_onode_121_REPORT.md) | Phase 254: 同 REPORT。 |
| [phases/PHASE_255_kimura_kengo_second_121_PLAN.md](process/phases/PHASE_255_kimura_kengo_second_121_PLAN.md) | Phase 255: 木村健悟 第2回121 Zoom要約反映（ハート・プランニング／Tシャツプリント・Religo・社内システム相談）PLAN。 |
| [phases/PHASE_255_kimura_kengo_second_121_WORKLOG.md](process/phases/PHASE_255_kimura_kengo_second_121_WORKLOG.md) | Phase 255: 同 WORKLOG。 |
| [phases/PHASE_255_kimura_kengo_second_121_REPORT.md](process/phases/PHASE_255_kimura_kengo_second_121_REPORT.md) | Phase 255: 同 REPORT。 |
| [phases/PHASE_256_ohta_issei_121_PLAN.md](process/phases/PHASE_256_ohta_issei_121_PLAN.md) | Phase 256: 太田一誠 第1回121 Zoom要約反映（ファインバブル／雑につなぐ相互紹介）PLAN。 |
| [phases/PHASE_256_ohta_issei_121_WORKLOG.md](process/phases/PHASE_256_ohta_issei_121_WORKLOG.md) | Phase 256: 同 WORKLOG。 |
| [phases/PHASE_256_ohta_issei_121_REPORT.md](process/phases/PHASE_256_ohta_issei_121_REPORT.md) | Phase 256: 同 REPORT。 |
| [phases/PHASE_257_gunji_atsuya_first_121_PLAN.md](process/phases/PHASE_257_gunji_atsuya_first_121_PLAN.md) | Phase 257: 軍司敦哉 第1回121 Zoom要約反映（Conduct／LINE公式アカウント運用代行・AIチャットボット協業）PLAN。 |
| [phases/PHASE_257_gunji_atsuya_first_121_WORKLOG.md](process/phases/PHASE_257_gunji_atsuya_first_121_WORKLOG.md) | Phase 257: 同 WORKLOG。 |
| [phases/PHASE_257_gunji_atsuya_first_121_REPORT.md](process/phases/PHASE_257_gunji_atsuya_first_121_REPORT.md) | Phase 257: 同 REPORT。 |
| [phases/PHASE_258_gunji_atsuya_second_121_PLAN.md](process/phases/PHASE_258_gunji_atsuya_second_121_PLAN.md) | Phase 258: 軍司敦哉 第2回121 Zoom要約反映（リンクアットジャパン／Lステップ + AIチャットボット提案）PLAN。 |
| [phases/PHASE_258_gunji_atsuya_second_121_WORKLOG.md](process/phases/PHASE_258_gunji_atsuya_second_121_WORKLOG.md) | Phase 258: 同 WORKLOG。 |
| [phases/PHASE_258_gunji_atsuya_second_121_REPORT.md](process/phases/PHASE_258_gunji_atsuya_second_121_REPORT.md) | Phase 258: 同 REPORT。 |
| [phases/PHASE_259_takatsuki_yuuka_121_PLAN.md](process/phases/PHASE_259_takatsuki_yuuka_121_PLAN.md) | Phase 259: 髙月佑果 第1回121 Zoom要約反映（イートムラボ／ロジカルクッキング・包丁の持ち方レッスン）PLAN。 |
| [phases/PHASE_259_takatsuki_yuuka_121_WORKLOG.md](process/phases/PHASE_259_takatsuki_yuuka_121_WORKLOG.md) | Phase 259: 同 WORKLOG。 |
| [phases/PHASE_259_takatsuki_yuuka_121_REPORT.md](process/phases/PHASE_259_takatsuki_yuuka_121_REPORT.md) | Phase 259: 同 REPORT。 |
| [phases/PHASE_260_tabuchi_kyohei_121_PLAN.md](process/phases/PHASE_260_tabuchi_kyohei_121_PLAN.md) | Phase 260: 田渕恭平 第1回121 Zoom要約反映（田渕石材／庵治石・令和の新石器時代）PLAN。 |
| [phases/PHASE_260_tabuchi_kyohei_121_WORKLOG.md](process/phases/PHASE_260_tabuchi_kyohei_121_WORKLOG.md) | Phase 260: 同 WORKLOG。 |
| [phases/PHASE_260_tabuchi_kyohei_121_REPORT.md](process/phases/PHASE_260_tabuchi_kyohei_121_REPORT.md) | Phase 260: 同 REPORT。 |
| [phases/PHASE_261_kadomatsu_naoyuki_121_PLAN.md](process/phases/PHASE_261_kadomatsu_naoyuki_121_PLAN.md) | Phase 261: 門松直幸 初回121事前準備（株式会社サイクス／社外情シス担当・同業協業）PLAN。 |
| [phases/PHASE_261_kadomatsu_naoyuki_121_WORKLOG.md](process/phases/PHASE_261_kadomatsu_naoyuki_121_WORKLOG.md) | Phase 261: 同 WORKLOG。 |
| [phases/PHASE_261_kadomatsu_naoyuki_121_REPORT.md](process/phases/PHASE_261_kadomatsu_naoyuki_121_REPORT.md) | Phase 261: 同 REPORT。 |
| [phases/PHASE_262_auth_boundary_hardening_PLAN.md](process/phases/PHASE_262_auth_boundary_hardening_PLAN.md) | Phase 262: Auth Boundary Hardening（SPEC-020 Phase A・sanctum 化）PLAN。 |
| [phases/PHASE_262_auth_boundary_hardening_WORKLOG.md](process/phases/PHASE_262_auth_boundary_hardening_WORKLOG.md) | Phase 262: 同 WORKLOG。 |
| [phases/PHASE_262_auth_boundary_hardening_REPORT.md](process/phases/PHASE_262_auth_boundary_hardening_REPORT.md) | Phase 262: 同 REPORT。 |
| [phases/PHASE_263_owner_enforcement_PLAN.md](process/phases/PHASE_263_owner_enforcement_PLAN.md) | Phase 263: Owner Enforcement（SPEC-020 Phase B・owner サーバ固定/route model 403）PLAN。 |
| [phases/PHASE_263_owner_enforcement_WORKLOG.md](process/phases/PHASE_263_owner_enforcement_WORKLOG.md) | Phase 263: 同 WORKLOG。 |
| [phases/PHASE_263_owner_enforcement_REPORT.md](process/phases/PHASE_263_owner_enforcement_REPORT.md) | Phase 263: 同 REPORT。 |
| [phases/PHASE_264_admin_role_enforcement_PLAN.md](process/phases/PHASE_264_admin_role_enforcement_PLAN.md) | Phase 264: Admin API Role Enforcement（SPEC-020 Phase C・編集系 admin 限定）PLAN。 |
| [phases/PHASE_264_admin_role_enforcement_WORKLOG.md](process/phases/PHASE_264_admin_role_enforcement_WORKLOG.md) | Phase 264: 同 WORKLOG。 |
| [phases/PHASE_264_admin_role_enforcement_REPORT.md](process/phases/PHASE_264_admin_role_enforcement_REPORT.md) | Phase 264: 同 REPORT。 |
| [phases/PHASE_265_member_ui_separation_PLAN.md](process/phases/PHASE_265_member_ui_separation_PLAN.md) | Phase 265: Member UI Separation（SPEC-020 Phase D・role で UI 分離）PLAN。 |
| [phases/PHASE_265_member_ui_separation_WORKLOG.md](process/phases/PHASE_265_member_ui_separation_WORKLOG.md) | Phase 265: 同 WORKLOG。 |
| [phases/PHASE_265_member_ui_separation_REPORT.md](process/phases/PHASE_265_member_ui_separation_REPORT.md) | Phase 265: 同 REPORT。 |
| [phases/PHASE_266_onboarding_preparation_PLAN.md](process/phases/PHASE_266_onboarding_preparation_PLAN.md) | Phase 266: Onboarding Preparation（SPEC-020 Phase E・自己登録方式確定）PLAN。 |
| [phases/PHASE_266_onboarding_preparation_WORKLOG.md](process/phases/PHASE_266_onboarding_preparation_WORKLOG.md) | Phase 266: 同 WORKLOG。 |
| [phases/PHASE_266_onboarding_preparation_REPORT.md](process/phases/PHASE_266_onboarding_preparation_REPORT.md) | Phase 266: 同 REPORT。 |
| [phases/PHASE_267_onetoone_minutes_mvp_PLAN.md](process/phases/PHASE_267_onetoone_minutes_mvp_PLAN.md) | Phase 267: 1to1 Minutes MVP（SPEC-020 Phase F・コピペ → notes 保存・owner 本人固定）PLAN。 |
| [phases/PHASE_267_onetoone_minutes_mvp_WORKLOG.md](process/phases/PHASE_267_onetoone_minutes_mvp_WORKLOG.md) | Phase 267: 同 WORKLOG。 |
| [phases/PHASE_267_onetoone_minutes_mvp_REPORT.md](process/phases/PHASE_267_onetoone_minutes_mvp_REPORT.md) | Phase 267: 同 REPORT。 |
| [phases/PHASE_268_remove_global_owner_selector_PLAN.md](process/phases/PHASE_268_remove_global_owner_selector_PLAN.md) | Phase 268: グローバル Owner セレクタ廃止（ログインユーザー固定）PLAN。 |
| [phases/PHASE_268_remove_global_owner_selector_WORKLOG.md](process/phases/PHASE_268_remove_global_owner_selector_WORKLOG.md) | Phase 268: 同 WORKLOG。 |
| [phases/PHASE_268_remove_global_owner_selector_REPORT.md](process/phases/PHASE_268_remove_global_owner_selector_REPORT.md) | Phase 268: 同 REPORT。 |
| [phases/PHASE_269_matsukura_kenji_121_PLAN.md](process/phases/PHASE_269_matsukura_kenji_121_PLAN.md) | Phase 269: 松倉健治 第1回121 Zoom要約反映 PLAN。 |
| [phases/PHASE_269_matsukura_kenji_121_WORKLOG.md](process/phases/PHASE_269_matsukura_kenji_121_WORKLOG.md) | Phase 269: 同 WORKLOG。 |
| [phases/PHASE_269_matsukura_kenji_121_REPORT.md](process/phases/PHASE_269_matsukura_kenji_121_REPORT.md) | Phase 269: 同 REPORT。 |
| （必要に応じて PHASE_<内容>_PLAN.md 等を追加） | |
| [phases/PHASE_120_1TO1_DB_REGISTRATION_PLAN.md](process/phases/PHASE_120_1TO1_DB_REGISTRATION_PLAN.md) | Phase 120: 1to1議事録のDB登録 PLAN。 |
| [phases/PHASE_120_1TO1_DB_REGISTRATION_WORKLOG.md](process/phases/PHASE_120_1TO1_DB_REGISTRATION_WORKLOG.md) | Phase 120: 1to1議事録のDB登録 WORKLOG。 |
| [phases/PHASE_120_1TO1_DB_REGISTRATION_REPORT.md](process/phases/PHASE_120_1TO1_DB_REGISTRATION_REPORT.md) | Phase 120: 1to1議事録のDB登録 REPORT。 |
| [phases/PHASE_131_1TO1_DB_REGISTRATION_FOLLOWUP_PLAN.md](process/phases/PHASE_131_1TO1_DB_REGISTRATION_FOLLOWUP_PLAN.md) | Phase 131: 1to1議事録のDB登録フォローアップ PLAN。 |
| [phases/PHASE_131_1TO1_DB_REGISTRATION_FOLLOWUP_WORKLOG.md](process/phases/PHASE_131_1TO1_DB_REGISTRATION_FOLLOWUP_WORKLOG.md) | Phase 131: 1to1議事録のDB登録フォローアップ WORKLOG。 |
| [phases/PHASE_131_1TO1_DB_REGISTRATION_FOLLOWUP_REPORT.md](process/phases/PHASE_131_1TO1_DB_REGISTRATION_FOLLOWUP_REPORT.md) | Phase 131: 1to1議事録のDB登録フォローアップ REPORT。 |
| [phases/PHASE_132_CROSS_CHAPTER_WORKSPACE_CORRECTION_PLAN.md](process/phases/PHASE_132_CROSS_CHAPTER_WORKSPACE_CORRECTION_PLAN.md) | Phase 132: 他チャプター1to1相手の所属補正 PLAN。 |
| [phases/PHASE_132_CROSS_CHAPTER_WORKSPACE_CORRECTION_WORKLOG.md](process/phases/PHASE_132_CROSS_CHAPTER_WORKSPACE_CORRECTION_WORKLOG.md) | Phase 132: 他チャプター1to1相手の所属補正 WORKLOG。 |
| [phases/PHASE_132_CROSS_CHAPTER_WORKSPACE_CORRECTION_REPORT.md](process/phases/PHASE_132_CROSS_CHAPTER_WORKSPACE_CORRECTION_REPORT.md) | Phase 132: 他チャプター1to1相手の所属補正 REPORT。 |
| [phases/PHASE_133_TSUJI_TRESTELLA_WORKSPACE_CORRECTION_PLAN.md](process/phases/PHASE_133_TSUJI_TRESTELLA_WORKSPACE_CORRECTION_PLAN.md) | Phase 133: 辻亮さん所属チャプター補正 PLAN。 |
| [phases/PHASE_133_TSUJI_TRESTELLA_WORKSPACE_CORRECTION_WORKLOG.md](process/phases/PHASE_133_TSUJI_TRESTELLA_WORKSPACE_CORRECTION_WORKLOG.md) | Phase 133: 辻亮さん所属チャプター補正 WORKLOG。 |
| [phases/PHASE_133_TSUJI_TRESTELLA_WORKSPACE_CORRECTION_REPORT.md](process/phases/PHASE_133_TSUJI_TRESTELLA_WORKSPACE_CORRECTION_REPORT.md) | Phase 133: 辻亮さん所属チャプター補正 REPORT。 |
| [phases/PHASE_134_MITARAI_FUDOTECH_1TO1_PREP_PLAN.md](process/phases/PHASE_134_MITARAI_FUDOTECH_1TO1_PREP_PLAN.md) | Phase 134: 御手洗さん 1to1 事前準備 PLAN。 |
| [phases/PHASE_134_MITARAI_FUDOTECH_1TO1_PREP_WORKLOG.md](process/phases/PHASE_134_MITARAI_FUDOTECH_1TO1_PREP_WORKLOG.md) | Phase 134: 御手洗さん 1to1 事前準備 WORKLOG。 |
| [phases/PHASE_134_MITARAI_FUDOTECH_1TO1_PREP_REPORT.md](process/phases/PHASE_134_MITARAI_FUDOTECH_1TO1_PREP_REPORT.md) | Phase 134: 御手洗さん 1to1 事前準備 REPORT。 |
| [phases/PHASE_135_MITARAI_FUDOTECH_1TO1_MINUTES_PLAN.md](process/phases/PHASE_135_MITARAI_FUDOTECH_1TO1_MINUTES_PLAN.md) | Phase 135: 御手洗さん 1to1 実施後議事録 PLAN。 |
| [phases/PHASE_135_MITARAI_FUDOTECH_1TO1_MINUTES_WORKLOG.md](process/phases/PHASE_135_MITARAI_FUDOTECH_1TO1_MINUTES_WORKLOG.md) | Phase 135: 御手洗さん 1to1 実施後議事録 WORKLOG。 |
| [phases/PHASE_135_MITARAI_FUDOTECH_1TO1_MINUTES_REPORT.md](process/phases/PHASE_135_MITARAI_FUDOTECH_1TO1_MINUTES_REPORT.md) | Phase 135: 御手洗さん 1to1 実施後議事録 REPORT。 |
| [phases/PHASE_136_MITARAI_FUDOTECH_1TO1_DB_REGISTRATION_PLAN.md](process/phases/PHASE_136_MITARAI_FUDOTECH_1TO1_DB_REGISTRATION_PLAN.md) | Phase 136: 御手洗さん 1to1 DB登録 + 西岡さん紹介進行記録 PLAN。 |
| [phases/PHASE_136_MITARAI_FUDOTECH_1TO1_DB_REGISTRATION_WORKLOG.md](process/phases/PHASE_136_MITARAI_FUDOTECH_1TO1_DB_REGISTRATION_WORKLOG.md) | Phase 136: 御手洗さん 1to1 DB登録 + 西岡さん紹介進行記録 WORKLOG。 |
| [phases/PHASE_136_MITARAI_FUDOTECH_1TO1_DB_REGISTRATION_REPORT.md](process/phases/PHASE_136_MITARAI_FUDOTECH_1TO1_DB_REGISTRATION_REPORT.md) | Phase 136: 御手洗さん 1to1 DB登録 + 西岡さん紹介進行記録 REPORT。 |
| [phases/PHASE_138_BNI_ENTRY_DESIGN_PLAN.md](process/phases/PHASE_138_BNI_ENTRY_DESIGN_PLAN.md) | Phase 138: Living Document §10.3 入口設計追記 PLAN。 |
| [phases/PHASE_138_BNI_ENTRY_DESIGN_WORKLOG.md](process/phases/PHASE_138_BNI_ENTRY_DESIGN_WORKLOG.md) | Phase 138: Living Document §10.3 入口設計追記 WORKLOG。 |
| [phases/PHASE_138_BNI_ENTRY_DESIGN_REPORT.md](process/phases/PHASE_138_BNI_ENTRY_DESIGN_REPORT.md) | Phase 138: Living Document §10.3 入口設計追記 REPORT。 |
| [phases/PHASE_139_BNI_WEEKLY_EXPERIMENT_CYCLE_PLAN.md](process/phases/PHASE_139_BNI_WEEKLY_EXPERIMENT_CYCLE_PLAN.md) | Phase 139: Living Document §10.7 今週の実験サイクル PLAN。 |
| [phases/PHASE_139_BNI_WEEKLY_EXPERIMENT_CYCLE_WORKLOG.md](process/phases/PHASE_139_BNI_WEEKLY_EXPERIMENT_CYCLE_WORKLOG.md) | Phase 139: Living Document §10.7 今週の実験サイクル WORKLOG。 |
| [phases/PHASE_139_BNI_WEEKLY_EXPERIMENT_CYCLE_REPORT.md](process/phases/PHASE_139_BNI_WEEKLY_EXPERIMENT_CYCLE_REPORT.md) | Phase 139: Living Document §10.7 今週の実験サイクル REPORT。 |
| [phases/PHASE_121_CROSS_CHAPTER_MEMBER_WORKSPACE_BACKFILL_PLAN.md](process/phases/PHASE_121_CROSS_CHAPTER_MEMBER_WORKSPACE_BACKFILL_PLAN.md) | Phase 121: チャプター外1to1相手の所属チャプター補正 PLAN。 |
| [phases/PHASE_121_CROSS_CHAPTER_MEMBER_WORKSPACE_BACKFILL_WORKLOG.md](process/phases/PHASE_121_CROSS_CHAPTER_MEMBER_WORKSPACE_BACKFILL_WORKLOG.md) | Phase 121: チャプター外1to1相手の所属チャプター補正 WORKLOG。 |
| [phases/PHASE_121_CROSS_CHAPTER_MEMBER_WORKSPACE_BACKFILL_REPORT.md](process/phases/PHASE_121_CROSS_CHAPTER_MEMBER_WORKSPACE_BACKFILL_REPORT.md) | Phase 121: チャプター外1to1相手の所属チャプター補正 REPORT。 |
| [phases/PHASE_122_REFERRAL_SPEC009_DATAMODEL_PLAN.md](process/phases/PHASE_122_REFERRAL_SPEC009_DATAMODEL_PLAN.md) | Phase 122: SPEC-009 製品既定 + DATA_MODEL（internal_referrals）PLAN。 |
| [phases/PHASE_122_REFERRAL_SPEC009_DATAMODEL_WORKLOG.md](process/phases/PHASE_122_REFERRAL_SPEC009_DATAMODEL_WORKLOG.md) | Phase 122: 同 WORKLOG。 |
| [phases/PHASE_123_REFERRAL_API_IMPLEMENT_PLAN.md](process/phases/PHASE_123_REFERRAL_API_IMPLEMENT_PLAN.md) | Phase 123: SPEC-009 リファーラル API・マイグレーション PLAN。 |
| [phases/PHASE_123_REFERRAL_API_IMPLEMENT_WORKLOG.md](process/phases/PHASE_123_REFERRAL_API_IMPLEMENT_WORKLOG.md) | Phase 123: 同 WORKLOG。 |
| [phases/PHASE_123_REFERRAL_API_IMPLEMENT_REPORT.md](process/phases/PHASE_123_REFERRAL_API_IMPLEMENT_REPORT.md) | Phase 123: 同 REPORT。 |
| [phases/PHASE_124_BO_OWNER_AUTO_INCLUDE_PLAN.md](process/phases/PHASE_124_BO_OWNER_AUTO_INCLUDE_PLAN.md) | Phase 124: Connections BO 保存時 Owner を BO1 に自動追加 PLAN。 |
| [phases/PHASE_124_BO_OWNER_AUTO_INCLUDE_WORKLOG.md](process/phases/PHASE_124_BO_OWNER_AUTO_INCLUDE_WORKLOG.md) | Phase 124: 同 WORKLOG。 |
| [phases/PHASE_124_BO_OWNER_AUTO_INCLUDE_REPORT.md](process/phases/PHASE_124_BO_OWNER_AUTO_INCLUDE_REPORT.md) | Phase 124: 同 REPORT。 |
| [phases/PHASE_125_CONTACT_CHANNELS_SUMMARY_LITE_PLAN.md](process/phases/PHASE_125_CONTACT_CHANNELS_SUMMARY_LITE_PLAN.md) | Phase 125: summary_lite に BO/1to1/メモの最終日時 PLAN。 |
| [phases/PHASE_125_CONTACT_CHANNELS_SUMMARY_LITE_WORKLOG.md](process/phases/PHASE_125_CONTACT_CHANNELS_SUMMARY_LITE_WORKLOG.md) | Phase 125: 同 WORKLOG。 |
| [phases/PHASE_125_CONTACT_CHANNELS_SUMMARY_LITE_REPORT.md](process/phases/PHASE_125_CONTACT_CHANNELS_SUMMARY_LITE_REPORT.md) | Phase 125: 同 REPORT。 |
| [phases/PHASE_126_AUTH_SPEC010_OWNER_BINDING_PLAN.md](process/phases/PHASE_126_AUTH_SPEC010_OWNER_BINDING_PLAN.md) | Phase 126: SPEC-010 ログインと Owner 紐づけ要件の Registry 同期・**active** 化 PLAN。 |
| [phases/PHASE_126_AUTH_SPEC010_OWNER_BINDING_WORKLOG.md](process/phases/PHASE_126_AUTH_SPEC010_OWNER_BINDING_WORKLOG.md) | Phase 126: 同 WORKLOG。 |
| [phases/PHASE_126_AUTH_SPEC010_OWNER_BINDING_REPORT.md](process/phases/PHASE_126_AUTH_SPEC010_OWNER_BINDING_REPORT.md) | Phase 126: 同 REPORT。 |
| [phases/PHASE_147_AUTH_REGISTRATION_EMAIL_PLAN.md](process/phases/PHASE_147_AUTH_REGISTRATION_EMAIL_PLAN.md) | Phase 147: SPEC-011 初回登録 — 確認コードメール送信要件 PLAN。 |
| [phases/PHASE_147_AUTH_REGISTRATION_EMAIL_WORKLOG.md](process/phases/PHASE_147_AUTH_REGISTRATION_EMAIL_WORKLOG.md) | Phase 147: 同 WORKLOG。 |
| [phases/PHASE_147_AUTH_REGISTRATION_EMAIL_REPORT.md](process/phases/PHASE_147_AUTH_REGISTRATION_EMAIL_REPORT.md) | Phase 147: 同 REPORT。 |
| [phases/PHASE_148_AUTH_REGISTRATION_EMAIL_PLAN.md](process/phases/PHASE_148_AUTH_REGISTRATION_EMAIL_PLAN.md) | Phase 148: SPEC-011 確認コードメール送信 implement PLAN。 |
| [phases/PHASE_148_AUTH_REGISTRATION_EMAIL_WORKLOG.md](process/phases/PHASE_148_AUTH_REGISTRATION_EMAIL_WORKLOG.md) | Phase 148: 同 WORKLOG。 |
| [phases/PHASE_148_AUTH_REGISTRATION_EMAIL_REPORT.md](process/phases/PHASE_148_AUTH_REGISTRATION_EMAIL_REPORT.md) | Phase 148: 同 REPORT。 |
| [phases/PHASE_149_REGISTER_UNKNOWN_EMAIL_ERROR_PLAN.md](process/phases/PHASE_149_REGISTER_UNKNOWN_EMAIL_ERROR_PLAN.md) | Phase 149: member 未一致 — 初回登録 422 エラー表示要件 PLAN。 |
| [phases/PHASE_149_REGISTER_UNKNOWN_EMAIL_ERROR_WORKLOG.md](process/phases/PHASE_149_REGISTER_UNKNOWN_EMAIL_ERROR_WORKLOG.md) | Phase 149: 同 WORKLOG。 |
| [phases/PHASE_149_REGISTER_UNKNOWN_EMAIL_ERROR_REPORT.md](process/phases/PHASE_149_REGISTER_UNKNOWN_EMAIL_ERROR_REPORT.md) | Phase 149: 同 REPORT。 |
| [phases/PHASE_150_REGISTER_UNKNOWN_EMAIL_ERROR_PLAN.md](process/phases/PHASE_150_REGISTER_UNKNOWN_EMAIL_ERROR_PLAN.md) | Phase 150: member 未一致 422 implement PLAN。 |
| [phases/PHASE_150_REGISTER_UNKNOWN_EMAIL_ERROR_WORKLOG.md](process/phases/PHASE_150_REGISTER_UNKNOWN_EMAIL_ERROR_WORKLOG.md) | Phase 150: 同 WORKLOG。 |
| [phases/PHASE_150_REGISTER_UNKNOWN_EMAIL_ERROR_REPORT.md](process/phases/PHASE_150_REGISTER_UNKNOWN_EMAIL_ERROR_REPORT.md) | Phase 150: 同 REPORT。 |
| [phases/PHASE_151_ZOOM_ONETOONE_SYNC_REQUIREMENTS_PLAN.md](process/phases/PHASE_151_ZOOM_ONETOONE_SYNC_REQUIREMENTS_PLAN.md) | Phase 151: SPEC-012 Zoom 連携 1to1 予定・実施・要約取り込み 要件整理 PLAN。 |
| [phases/PHASE_151_ZOOM_ONETOONE_SYNC_REQUIREMENTS_WORKLOG.md](process/phases/PHASE_151_ZOOM_ONETOONE_SYNC_REQUIREMENTS_WORKLOG.md) | Phase 151: 同 WORKLOG。 |
| [phases/PHASE_151_ZOOM_ONETOONE_SYNC_REQUIREMENTS_REPORT.md](process/phases/PHASE_151_ZOOM_ONETOONE_SYNC_REQUIREMENTS_REPORT.md) | Phase 151: 同 REPORT。 |
| [phases/PHASE_152_ZOOM_ONETOONE_SYNC_IMPLEMENT_PLAN.md](process/phases/PHASE_152_ZOOM_ONETOONE_SYNC_IMPLEMENT_PLAN.md) | Phase 152: SPEC-012 Zoom 連携 implement（OAuth・取り込み・要約・Webhook）PLAN。 |
| [phases/PHASE_152_ZOOM_ONETOONE_SYNC_IMPLEMENT_WORKLOG.md](process/phases/PHASE_152_ZOOM_ONETOONE_SYNC_IMPLEMENT_WORKLOG.md) | Phase 152: 同 WORKLOG。 |
| [phases/PHASE_152_ZOOM_ONETOONE_SYNC_IMPLEMENT_REPORT.md](process/phases/PHASE_152_ZOOM_ONETOONE_SYNC_IMPLEMENT_REPORT.md) | Phase 152: 同 REPORT。 |
| [phases/PHASE_153_ZOOM_INTEGRATION_SETUP_DOC_PLAN.md](process/phases/PHASE_153_ZOOM_INTEGRATION_SETUP_DOC_PLAN.md) | Phase 153: SPEC-012 Zoom 連携 セットアップ・運用手順（Runbook）PLAN。 |
| [phases/PHASE_153_ZOOM_INTEGRATION_SETUP_DOC_WORKLOG.md](process/phases/PHASE_153_ZOOM_INTEGRATION_SETUP_DOC_WORKLOG.md) | Phase 153: 同 WORKLOG。 |
| [phases/PHASE_153_ZOOM_INTEGRATION_SETUP_DOC_REPORT.md](process/phases/PHASE_153_ZOOM_INTEGRATION_SETUP_DOC_REPORT.md) | Phase 153: 同 REPORT。 |
| [phases/PHASE_154_ZOOM_PER_USER_ACCESS_PLAN.md](process/phases/PHASE_154_ZOOM_PER_USER_ACCESS_PLAN.md) | Phase 154: Zoom アクセスをユーザー単位（auth:sanctum）PLAN/WORKLOG/REPORT。 |
| [phases/PHASE_189_ZOOM_USER_CREDENTIALS_PLAN.md](process/phases/PHASE_189_ZOOM_USER_CREDENTIALS_PLAN.md) | Phase 189: Zoom ユーザー資格情報（BYO app credentials・暗号化）PLAN。 |
| [phases/PHASE_189_ZOOM_USER_CREDENTIALS_WORKLOG.md](process/phases/PHASE_189_ZOOM_USER_CREDENTIALS_WORKLOG.md) | Phase 189: 同 WORKLOG。 |
| [phases/PHASE_189_ZOOM_USER_CREDENTIALS_REPORT.md](process/phases/PHASE_189_ZOOM_USER_CREDENTIALS_REPORT.md) | Phase 189: 同 REPORT。 |
| [phases/REFERRAL_SUGGESTION_PHASE_ROADMAP.md](process/phases/REFERRAL_SUGGESTION_PHASE_ROADMAP.md) | **リファーラル提案 ロードマップ**（190–195・§0.8.6 二経路・§0.8.7 Givers Gain・195 DoD）。 |
| [phases/PHASE_190_REFERRAL_SUGGESTION_MVP_API_PLAN.md](process/phases/PHASE_190_REFERRAL_SUGGESTION_MVP_API_PLAN.md) | Phase 190: リファーラル提案 MVP API（121＋定例会）PLAN。 |
| [phases/PHASE_190_REFERRAL_SUGGESTION_MVP_API_WORKLOG.md](process/phases/PHASE_190_REFERRAL_SUGGESTION_MVP_API_WORKLOG.md) | Phase 190: 同 WORKLOG。 |
| [phases/PHASE_190_REFERRAL_SUGGESTION_MVP_API_REPORT.md](process/phases/PHASE_190_REFERRAL_SUGGESTION_MVP_API_REPORT.md) | Phase 190: 同 REPORT。 |
| [phases/PHASE_191_REFERRAL_SUGGESTION_MVP_UI_PLAN.md](process/phases/PHASE_191_REFERRAL_SUGGESTION_MVP_UI_PLAN.md) | Phase 191: リファーラル提案 MVP UI PLAN。 |
| [phases/PHASE_191_REFERRAL_SUGGESTION_MVP_UI_WORKLOG.md](process/phases/PHASE_191_REFERRAL_SUGGESTION_MVP_UI_WORKLOG.md) | Phase 191: 同 WORKLOG。 |
| [phases/PHASE_191_REFERRAL_SUGGESTION_MVP_UI_REPORT.md](process/phases/PHASE_191_REFERRAL_SUGGESTION_MVP_UI_REPORT.md) | Phase 191: 同 REPORT。 |
| [phases/PHASE_192_REFERRAL_SUGGESTION_REGISTER_STALE_PLAN.md](process/phases/PHASE_192_REFERRAL_SUGGESTION_REGISTER_STALE_PLAN.md) | Phase 192: register-introduction・stale・過去 run PLAN。 |
| [phases/PHASE_192_REFERRAL_SUGGESTION_REGISTER_STALE_WORKLOG.md](process/phases/PHASE_192_REFERRAL_SUGGESTION_REGISTER_STALE_WORKLOG.md) | Phase 192: 同 WORKLOG。 |
| [phases/PHASE_192_REFERRAL_SUGGESTION_REGISTER_STALE_REPORT.md](process/phases/PHASE_192_REFERRAL_SUGGESTION_REGISTER_STALE_REPORT.md) | Phase 192: 同 REPORT。 |
| [phases/PHASE_193_REFERRAL_SUGGESTION_REPORTING_PLAN.md](process/phases/PHASE_193_REFERRAL_SUGGESTION_REPORTING_PLAN.md) | Phase 193: レポート・フィルタ PLAN。 |
| [phases/PHASE_193_REFERRAL_SUGGESTION_REPORTING_WORKLOG.md](process/phases/PHASE_193_REFERRAL_SUGGESTION_REPORTING_WORKLOG.md) | Phase 193: 同 WORKLOG。 |
| [phases/PHASE_193_REFERRAL_SUGGESTION_REPORTING_REPORT.md](process/phases/PHASE_193_REFERRAL_SUGGESTION_REPORTING_REPORT.md) | Phase 193: 同 REPORT。 |
| [phases/PHASE_194_REFERRAL_SUGGESTION_RULES_P2_PLAN.md](process/phases/PHASE_194_REFERRAL_SUGGESTION_RULES_P2_PLAN.md) | Phase 194: ルール前処理 P2 PLAN。 |
| [phases/PHASE_194_REFERRAL_SUGGESTION_RULES_P2_WORKLOG.md](process/phases/PHASE_194_REFERRAL_SUGGESTION_RULES_P2_WORKLOG.md) | Phase 194: 同 WORKLOG。 |
| [phases/PHASE_194_REFERRAL_SUGGESTION_RULES_P2_REPORT.md](process/phases/PHASE_194_REFERRAL_SUGGESTION_RULES_P2_REPORT.md) | Phase 194: 同 REPORT。 |
| [phases/PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_PLAN.md](process/phases/PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_PLAN.md) | Phase 195: 横断マッチング・共有同意・つなぎ手経由 PLAN。 |
| [phases/PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_WORKLOG.md](process/phases/PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_WORKLOG.md) | Phase 195: 同 WORKLOG。 |
| [phases/PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_REPORT.md](process/phases/PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_REPORT.md) | Phase 195: 同 REPORT。 |
| [phases/PHASE_155_ONETOONE_PREP_AI_OPENAI_PLAN.md](process/phases/PHASE_155_ONETOONE_PREP_AI_OPENAI_PLAN.md) | Phase 155: SPEC-013 1to1 事前準備（PDF/URL 添付・AI 原稿生成・OpenAI）PLAN。 |
| [phases/PHASE_155_ONETOONE_PREP_AI_OPENAI_WORKLOG.md](process/phases/PHASE_155_ONETOONE_PREP_AI_OPENAI_WORKLOG.md) | Phase 155: 同 WORKLOG。 |
| [phases/PHASE_155_ONETOONE_PREP_AI_OPENAI_REPORT.md](process/phases/PHASE_155_ONETOONE_PREP_AI_OPENAI_REPORT.md) | Phase 155: 同 REPORT。 |
| [phases/PHASE_162_1TO1_HISTORY_DB_SYNC_PLAN.md](process/phases/PHASE_162_1TO1_HISTORY_DB_SYNC_PLAN.md) | Phase 162: 原田里織・小中貴晃 第1回121履歴DB反映 PLAN。 |
| [phases/PHASE_162_1TO1_HISTORY_DB_SYNC_WORKLOG.md](process/phases/PHASE_162_1TO1_HISTORY_DB_SYNC_WORKLOG.md) | Phase 162: 同 WORKLOG。 |
| [phases/PHASE_162_1TO1_HISTORY_DB_SYNC_REPORT.md](process/phases/PHASE_162_1TO1_HISTORY_DB_SYNC_REPORT.md) | Phase 162: 同 REPORT。 |
| [phases/PHASE_DF_RA_01_SETUP_PLAN.md](process/phases/PHASE_DF_RA_01_SETUP_PLAN.md) | Phase DF-RA-01: ReactAdmin 基盤導入 PLAN。 |
| [phases/PHASE_DF_RA_01_SETUP_WORKLOG.md](process/phases/PHASE_DF_RA_01_SETUP_WORKLOG.md) | Phase DF-RA-01: ReactAdmin 基盤導入 WORKLOG。 |
| [phases/PHASE_DF_RA_01_SETUP_REPORT.md](process/phases/PHASE_DF_RA_01_SETUP_REPORT.md) | Phase DF-RA-01: ReactAdmin 基盤導入 REPORT。 |
| [phases/PHASE_DF_RA_02_DATAPROVIDER_PLAN.md](process/phases/PHASE_DF_RA_02_DATAPROVIDER_PLAN.md) | Phase DF-RA-02: DataProvider 最小実装 PLAN。 |
| [phases/PHASE_DF_RA_02_DATAPROVIDER_WORKLOG.md](process/phases/PHASE_DF_RA_02_DATAPROVIDER_WORKLOG.md) | Phase DF-RA-02: DataProvider 最小実装 WORKLOG。 |
| [phases/PHASE_DF_RA_02_DATAPROVIDER_REPORT.md](process/phases/PHASE_DF_RA_02_DATAPROVIDER_REPORT.md) | Phase DF-RA-02: DataProvider 最小実装 REPORT。 |
| [phases/PHASE_DF_BOARD_01_MVP_PLAN.md](process/phases/PHASE_DF_BOARD_01_MVP_PLAN.md) | Phase DF-BOARD-01: DragonFlyBoard MVP PLAN。 |
| [phases/PHASE_DF_BOARD_01_MVP_WORKLOG.md](process/phases/PHASE_DF_BOARD_01_MVP_WORKLOG.md) | Phase DF-BOARD-01: DragonFlyBoard MVP WORKLOG。 |
| [phases/PHASE_DF_BOARD_01_MVP_REPORT.md](process/phases/PHASE_DF_BOARD_01_MVP_REPORT.md) | Phase DF-BOARD-01: DragonFlyBoard MVP REPORT。 |
| [phases/PHASE04_RELIGO_MEMBERS_LIST_SUMMARY_PLAN.md](process/phases/PHASE04_RELIGO_MEMBERS_LIST_SUMMARY_PLAN.md) | Phase04 Religo: Members一覧に summary 統合 PLAN。 |
| [phases/PHASE04_RELIGO_MEMBERS_LIST_SUMMARY_WORKLOG.md](process/phases/PHASE04_RELIGO_MEMBERS_LIST_SUMMARY_WORKLOG.md) | Phase04 Religo: Members一覧に summary 統合 WORKLOG。 |
| [phases/PHASE04_RELIGO_MEMBERS_LIST_SUMMARY_REPORT.md](process/phases/PHASE04_RELIGO_MEMBERS_LIST_SUMMARY_REPORT.md) | Phase04 Religo: Members一覧に summary 統合 REPORT。 |
| [phases/PHASE05_RELIGO_RELATIONSHIP_LOG_CREATE_PLAN.md](process/phases/PHASE05_RELIGO_RELATIONSHIP_LOG_CREATE_PLAN.md) | Phase05 Religo: メモ追加API / 1to1 登録API PLAN。 |
| [phases/PHASE05_RELIGO_RELATIONSHIP_LOG_CREATE_WORKLOG.md](process/phases/PHASE05_RELIGO_RELATIONSHIP_LOG_CREATE_WORKLOG.md) | Phase05 Religo: メモ追加API / 1to1 登録API WORKLOG。 |
| [phases/PHASE05_RELIGO_RELATIONSHIP_LOG_CREATE_REPORT.md](process/phases/PHASE05_RELIGO_RELATIONSHIP_LOG_CREATE_REPORT.md) | Phase05 Religo: メモ追加API / 1to1 登録API REPORT。 |
| [phases/PHASE06_RELIGO_BOARD_ADD_MEMO_PLAN.md](process/phases/PHASE06_RELIGO_BOARD_ADD_MEMO_PLAN.md) | Phase06 Religo: DragonFlyBoard からメモ追加 PLAN。 |
| [phases/PHASE06_RELIGO_BOARD_ADD_MEMO_WORKLOG.md](process/phases/PHASE06_RELIGO_BOARD_ADD_MEMO_WORKLOG.md) | Phase06 Religo: DragonFlyBoard からメモ追加 WORKLOG。 |
| [phases/PHASE06_RELIGO_BOARD_ADD_MEMO_REPORT.md](process/phases/PHASE06_RELIGO_BOARD_ADD_MEMO_REPORT.md) | Phase06 Religo: DragonFlyBoard からメモ追加 REPORT。 |
| [phases/PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_PLAN.md](process/phases/PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_PLAN.md) | Phase07 Religo: DragonFlyBoard から 1 to 1 登録 PLAN。 |
| [phases/PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_WORKLOG.md](process/phases/PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_WORKLOG.md) | Phase07 Religo: DragonFlyBoard から 1 to 1 登録 WORKLOG。 |
| [phases/PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_REPORT.md](process/phases/PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_REPORT.md) | Phase07 Religo: DragonFlyBoard から 1 to 1 登録 REPORT。 |
| [phases/PHASE08_RELIGO_AUTO_WORKSPACE_ID_PLAN.md](process/phases/PHASE08_RELIGO_AUTO_WORKSPACE_ID_PLAN.md) | Phase08 Religo: workspace_id 自動取得（1to1 登録）PLAN。 |
| [phases/PHASE08_RELIGO_AUTO_WORKSPACE_ID_WORKLOG.md](process/phases/PHASE08_RELIGO_AUTO_WORKSPACE_ID_WORKLOG.md) | Phase08 Religo: workspace_id 自動取得 WORKLOG。 |
| [phases/PHASE08_RELIGO_AUTO_WORKSPACE_ID_REPORT.md](process/phases/PHASE08_RELIGO_AUTO_WORKSPACE_ID_REPORT.md) | Phase08 Religo: workspace_id 自動取得 REPORT。 |
| [phases/PHASE09_RELIGO_WORKSPACE_BOOTSTRAP_PLAN.md](process/phases/PHASE09_RELIGO_WORKSPACE_BOOTSTRAP_PLAN.md) | Phase09 Religo: Workspace 初期化（Seeder）と API テスト PLAN。 |
| [phases/PHASE09_RELIGO_WORKSPACE_BOOTSTRAP_WORKLOG.md](process/phases/PHASE09_RELIGO_WORKSPACE_BOOTSTRAP_WORKLOG.md) | Phase09 Religo: Workspace 初期化 WORKLOG。 |
| [phases/PHASE09_RELIGO_WORKSPACE_BOOTSTRAP_REPORT.md](process/phases/PHASE09_RELIGO_WORKSPACE_BOOTSTRAP_REPORT.md) | Phase09 Religo: Workspace 初期化 REPORT。 |
| [phases/PHASE10_RELIGO_BREAKOUT_ROOM_BUILDER_PLAN.md](process/phases/PHASE10_RELIGO_BREAKOUT_ROOM_BUILDER_PLAN.md) | Phase10 Religo: Meeting Breakout Room Builder（BO1/BO2）PLAN。 |
| [phases/PHASE10_RELIGO_BREAKOUT_ROOM_BUILDER_WORKLOG.md](process/phases/PHASE10_RELIGO_BREAKOUT_ROOM_BUILDER_WORKLOG.md) | Phase10 Religo: Breakout Room Builder WORKLOG。 |
| [phases/PHASE10_RELIGO_BREAKOUT_ROOM_BUILDER_REPORT.md](process/phases/PHASE10_RELIGO_BREAKOUT_ROOM_BUILDER_REPORT.md) | Phase10 Religo: Breakout Room Builder REPORT。 |
| [phases/PHASE10R_RELIGO_BREAKOUT_ROUNDS_PLAN.md](process/phases/PHASE10R_RELIGO_BREAKOUT_ROUNDS_PLAN.md) | Phase10R Religo: Breakout Round 可変（複数回対応）PLAN。 |
| [phases/PHASE10R_RELIGO_BREAKOUT_ROUNDS_WORKLOG.md](process/phases/PHASE10R_RELIGO_BREAKOUT_ROUNDS_WORKLOG.md) | Phase10R Religo: Breakout Rounds WORKLOG。 |
| [phases/PHASE10R_RELIGO_BREAKOUT_ROUNDS_REPORT.md](process/phases/PHASE10R_RELIGO_BREAKOUT_ROUNDS_REPORT.md) | Phase10R Religo: Breakout Rounds REPORT。 |
| [phases/PHASE11A_RELIGO_ADMIN_MENU_IA_PLAN.md](process/phases/PHASE11A_RELIGO_ADMIN_MENU_IA_PLAN.md) | Phase11A Religo: 管理画面メニュー整理（IA）PLAN。 |
| [phases/PHASE11A_RELIGO_ADMIN_MENU_IA_WORKLOG.md](process/phases/PHASE11A_RELIGO_ADMIN_MENU_IA_WORKLOG.md) | Phase11A Religo: メニュー IA WORKLOG。 |
| [phases/PHASE11A_RELIGO_ADMIN_MENU_IA_REPORT.md](process/phases/PHASE11A_RELIGO_ADMIN_MENU_IA_REPORT.md) | Phase11A Religo: メニュー IA REPORT。 |
| [phases/PHASE11B_RELIGO_ONE_TO_ONE_LIST_PLAN.md](process/phases/PHASE11B_RELIGO_ONE_TO_ONE_LIST_PLAN.md) | Phase11B Religo: 1 to 1 独立一覧 PLAN。 |
| [phases/PHASE11B_RELIGO_ONE_TO_ONE_LIST_WORKLOG.md](process/phases/PHASE11B_RELIGO_ONE_TO_ONE_LIST_WORKLOG.md) | Phase11B Religo: 1 to 1 一覧 WORKLOG。 |
| [phases/PHASE11B_RELIGO_ONE_TO_ONE_LIST_REPORT.md](process/phases/PHASE11B_RELIGO_ONE_TO_ONE_LIST_REPORT.md) | Phase11B Religo: 1 to 1 一覧 REPORT。 |
| [phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_PLAN.md](process/phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_PLAN.md) | ONETOONES-P1: 1 to 1 一覧フィルタ＋行アクション PLAN。 |
| [phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_WORKLOG.md](process/phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_WORKLOG.md) | ONETOONES-P1: WORKLOG。 |
| [phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_REPORT.md](process/phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_REPORT.md) | ONETOONES-P1: REPORT。 |
| [phases/PHASE_ONETOONES_STATS_DISPLAY_PLAN.md](process/phases/PHASE_ONETOONES_STATS_DISPLAY_PLAN.md) | ONETOONES-P2: 統計カード＋表示品質 PLAN。 |
| [phases/PHASE_ONETOONES_STATS_DISPLAY_WORKLOG.md](process/phases/PHASE_ONETOONES_STATS_DISPLAY_WORKLOG.md) | ONETOONES-P2: WORKLOG。 |
| [phases/PHASE_ONETOONES_STATS_DISPLAY_REPORT.md](process/phases/PHASE_ONETOONES_STATS_DISPLAY_REPORT.md) | ONETOONES-P2: REPORT。 |
| [phases/PHASE_ONETOONES_CREATE_EDIT_UX_PLAN.md](process/phases/PHASE_ONETOONES_CREATE_EDIT_UX_PLAN.md) | ONETOONES-P3: Create/Edit UX PLAN。 |
| [phases/PHASE_ONETOONES_CREATE_EDIT_UX_WORKLOG.md](process/phases/PHASE_ONETOONES_CREATE_EDIT_UX_WORKLOG.md) | ONETOONES-P3: WORKLOG。 |
| [phases/PHASE_ONETOONES_CREATE_EDIT_UX_REPORT.md](process/phases/PHASE_ONETOONES_CREATE_EDIT_UX_REPORT.md) | ONETOONES-P3: REPORT。 |
| [phases/PHASE_ONETOONES_P4_STATS_FILTER_MEMO_PLAN.md](process/phases/PHASE_ONETOONES_P4_STATS_FILTER_MEMO_PLAN.md) | ONETOONES-P4: 統計フィルタ連動＋メモ本流 PLAN。 |
| [phases/PHASE_ONETOONES_P4_STATS_FILTER_MEMO_WORKLOG.md](process/phases/PHASE_ONETOONES_P4_STATS_FILTER_MEMO_WORKLOG.md) | ONETOONES-P4: WORKLOG。 |
| [phases/PHASE_ONETOONES_P4_STATS_FILTER_MEMO_REPORT.md](process/phases/PHASE_ONETOONES_P4_STATS_FILTER_MEMO_REPORT.md) | ONETOONES-P4: REPORT。 |
| [phases/PHASE_ONETOONES_DELETE_POLICY_P1_PLAN.md](process/phases/PHASE_ONETOONES_DELETE_POLICY_P1_PLAN.md) | ONETOONES-DELETE-POLICY-P1: 1 to 1 削除不採用 SSOT・`canceled` 正規運用・一覧 `exclude_canceled` PLAN。 |
| [phases/PHASE_ONETOONES_DELETE_POLICY_P1_WORKLOG.md](process/phases/PHASE_ONETOONES_DELETE_POLICY_P1_WORKLOG.md) | ONETOONES-DELETE-POLICY-P1: WORKLOG。 |
| [phases/PHASE_ONETOONES_DELETE_POLICY_P1_REPORT.md](process/phases/PHASE_ONETOONES_DELETE_POLICY_P1_REPORT.md) | ONETOONES-DELETE-POLICY-P1: REPORT（Merge Evidence）。 |
| [phases/PHASE_ONETOONES_EDIT_UX_P2_PLAN.md](process/phases/PHASE_ONETOONES_EDIT_UX_P2_PLAN.md) | ONETOONES_EDIT_UX_P2: Edit を Create UX に揃える PLAN（[ONETOONES_EDIT_UI_FIT_AND_GAP](SSOT/ONETOONES_EDIT_UI_FIT_AND_GAP.md) §8 と対応）。 |
| [phases/PHASE_ONETOONES_EDIT_UX_P2_WORKLOG.md](process/phases/PHASE_ONETOONES_EDIT_UX_P2_WORKLOG.md) | ONETOONES_EDIT_UX_P2: WORKLOG。 |
| [phases/PHASE_ONETOONES_EDIT_UX_P2_REPORT.md](process/phases/PHASE_ONETOONES_EDIT_UX_P2_REPORT.md) | ONETOONES_EDIT_UX_P2: REPORT（Merge Evidence）。 |
| [phases/PHASE_ONETOONES_QUICK_CREATE_UX_P3_PLAN.md](process/phases/PHASE_ONETOONES_QUICK_CREATE_UX_P3_PLAN.md) | ONETOONES_QUICK_CREATE_UX_P3: 一覧 Quick Create を Create/Edit に揃える PLAN（[ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP](SSOT/ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md)）。 |
| [phases/PHASE_ONETOONES_QUICK_CREATE_UX_P3_WORKLOG.md](process/phases/PHASE_ONETOONES_QUICK_CREATE_UX_P3_WORKLOG.md) | ONETOONES_QUICK_CREATE_UX_P3: WORKLOG。 |
| [phases/PHASE_ONETOONES_QUICK_CREATE_UX_P3_REPORT.md](process/phases/PHASE_ONETOONES_QUICK_CREATE_UX_P3_REPORT.md) | ONETOONES_QUICK_CREATE_UX_P3: REPORT（Merge Evidence）。 |
| [phases/PHASE_ONETOONES_DASHBOARD_TARGET_PREFILL_P4_PLAN.md](process/phases/PHASE_ONETOONES_DASHBOARD_TARGET_PREFILL_P4_PLAN.md) | ONETOONES_DASHBOARD_TARGET_PREFILL_P4: target プリフィル PLAN（[ONETOONES_TARGET_PREFILL_FIT_AND_GAP](SSOT/ONETOONES_TARGET_PREFILL_FIT_AND_GAP.md)）。 |
| [phases/PHASE_ONETOONES_DASHBOARD_TARGET_PREFILL_P4_WORKLOG.md](process/phases/PHASE_ONETOONES_DASHBOARD_TARGET_PREFILL_P4_WORKLOG.md) | ONETOONES_DASHBOARD_TARGET_PREFILL_P4: WORKLOG。 |
| [phases/PHASE_ONETOONES_DASHBOARD_TARGET_PREFILL_P4_REPORT.md](process/phases/PHASE_ONETOONES_DASHBOARD_TARGET_PREFILL_P4_REPORT.md) | ONETOONES_DASHBOARD_TARGET_PREFILL_P4: REPORT（Merge Evidence）。 |
| [phases/PHASE_ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1_PLAN.md](process/phases/PHASE_ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1_PLAN.md) | ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1: クロスチャプター1to1＋国/リージョン/チャプター階層 PLAN（SPEC-006）。 |
| [phases/PHASE_ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1_WORKLOG.md](process/phases/PHASE_ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1_WORKLOG.md) | ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1: WORKLOG。 |
| [phases/PHASE_ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1_REPORT.md](process/phases/PHASE_ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1_REPORT.md) | ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1: REPORT（Merge Evidence は develop merge 後に追記）。 |
| [phases/PHASE_WORKSPACE_CHAPTER_FIT_GAP_P1_PLAN.md](process/phases/PHASE_WORKSPACE_CHAPTER_FIT_GAP_P1_PLAN.md) | WORKSPACE_CHAPTER_FIT_GAP_P1: workspace vs Chapter 調査 PLAN。 |
| [phases/PHASE_WORKSPACE_CHAPTER_FIT_GAP_P1_WORKLOG.md](process/phases/PHASE_WORKSPACE_CHAPTER_FIT_GAP_P1_WORKLOG.md) | WORKSPACE_CHAPTER_FIT_GAP_P1: WORKLOG。 |
| [phases/PHASE_WORKSPACE_CHAPTER_FIT_GAP_P1_REPORT.md](process/phases/PHASE_WORKSPACE_CHAPTER_FIT_GAP_P1_REPORT.md) | WORKSPACE_CHAPTER_FIT_GAP_P1: REPORT。 |
| [phases/PHASE_ONETOONES_P5_LEADS_PLAN.md](process/phases/PHASE_ONETOONES_P5_LEADS_PLAN.md) | ONETOONES-P5: Members/Dashboard 導線・次の 1to1 PLAN。 |
| [phases/PHASE_ONETOONES_P5_LEADS_WORKLOG.md](process/phases/PHASE_ONETOONES_P5_LEADS_WORKLOG.md) | ONETOONES-P5: WORKLOG。 |
| [phases/PHASE_ONETOONES_P5_LEADS_REPORT.md](process/phases/PHASE_ONETOONES_P5_LEADS_REPORT.md) | ONETOONES-P5: REPORT。 |
| [phases/PHASE_DASHBOARD_P7_1_UI_PLAN.md](process/phases/PHASE_DASHBOARD_P7_1_UI_PLAN.md) | DASHBOARD-P7-1: Dashboard モック寄せ UI 再構成 PLAN。 |
| [phases/PHASE_DASHBOARD_P7_1_UI_WORKLOG.md](process/phases/PHASE_DASHBOARD_P7_1_UI_WORKLOG.md) | DASHBOARD-P7-1: WORKLOG。 |
| [phases/PHASE_DASHBOARD_P7_1_UI_REPORT.md](process/phases/PHASE_DASHBOARD_P7_1_UI_REPORT.md) | DASHBOARD-P7-1: REPORT。 |
| [phases/PHASE_DASHBOARD_P7_2_DATA_ACTIONS_PLAN.md](process/phases/PHASE_DASHBOARD_P7_2_DATA_ACTIONS_PLAN.md) | DASHBOARD-P7-2: Dashboard データ・導線 PLAN。 |
| [phases/PHASE_DASHBOARD_P7_2_DATA_ACTIONS_WORKLOG.md](process/phases/PHASE_DASHBOARD_P7_2_DATA_ACTIONS_WORKLOG.md) | DASHBOARD-P7-2: WORKLOG。 |
| [phases/PHASE_DASHBOARD_P7_2_DATA_ACTIONS_REPORT.md](process/phases/PHASE_DASHBOARD_P7_2_DATA_ACTIONS_REPORT.md) | DASHBOARD-P7-2: REPORT。 |
| [phases/PHASE_DASHBOARD_P7_3_FINISHING_PLAN.md](process/phases/PHASE_DASHBOARD_P7_3_FINISHING_PLAN.md) | DASHBOARD-P7-3: Dashboard 仕上げ PLAN。 |
| [phases/PHASE_DASHBOARD_P7_3_FINISHING_WORKLOG.md](process/phases/PHASE_DASHBOARD_P7_3_FINISHING_WORKLOG.md) | DASHBOARD-P7-3: WORKLOG。 |
| [phases/PHASE_DASHBOARD_P7_3_FINISHING_REPORT.md](process/phases/PHASE_DASHBOARD_P7_3_FINISHING_REPORT.md) | DASHBOARD-P7-3: REPORT。 |
| [phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_PLAN.md](process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_PLAN.md) | DASHBOARD-TASKS-ALIGNMENT-P1: Dashboard 役割・Tasks 再定義 PLAN。 |
| [phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_WORKLOG.md](process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_WORKLOG.md) | DASHBOARD-TASKS-ALIGNMENT-P1: WORKLOG。 |
| [phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_REPORT.md](process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_REPORT.md) | DASHBOARD-TASKS-ALIGNMENT-P1: REPORT。 |
| [phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P2_PLAN.md](process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P2_PLAN.md) | DASHBOARD-TASKS-ALIGNMENT-P2: meeting_follow_up 突合 PLAN。 |
| [phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P2_WORKLOG.md](process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P2_WORKLOG.md) | DASHBOARD-TASKS-ALIGNMENT-P2: WORKLOG。 |
| [phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P2_REPORT.md](process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P2_REPORT.md) | DASHBOARD-TASKS-ALIGNMENT-P2: REPORT。 |
| [phases/PHASE_DASHBOARD_STALE_WORKSPACE_SCOPE_P1_PLAN.md](process/phases/PHASE_DASHBOARD_STALE_WORKSPACE_SCOPE_P1_PLAN.md) | DASHBOARD-STALE-WORKSPACE-SCOPE-P1: stale×workspace 設計 PLAN。 |
| [phases/PHASE_DASHBOARD_STALE_WORKSPACE_SCOPE_P1_WORKLOG.md](process/phases/PHASE_DASHBOARD_STALE_WORKSPACE_SCOPE_P1_WORKLOG.md) | DASHBOARD-STALE-WORKSPACE-SCOPE-P1: WORKLOG。 |
| [phases/PHASE_DASHBOARD_STALE_WORKSPACE_SCOPE_P1_REPORT.md](process/phases/PHASE_DASHBOARD_STALE_WORKSPACE_SCOPE_P1_REPORT.md) | DASHBOARD-STALE-WORKSPACE-SCOPE-P1: REPORT。 |
| [phases/PHASE_MEMBER_SUMMARY_WORKSPACE_NULL_P1_PLAN.md](process/phases/PHASE_MEMBER_SUMMARY_WORKSPACE_NULL_P1_PLAN.md) | MEMBER-SUMMARY-WORKSPACE-NULL-P1: MemberSummaryQuery workspace OR NULL PLAN。 |
| [phases/PHASE_MEMBER_SUMMARY_WORKSPACE_NULL_P1_WORKLOG.md](process/phases/PHASE_MEMBER_SUMMARY_WORKSPACE_NULL_P1_WORKLOG.md) | MEMBER-SUMMARY-WORKSPACE-NULL-P1: WORKLOG。 |
| [phases/PHASE_MEMBER_SUMMARY_WORKSPACE_NULL_P1_REPORT.md](process/phases/PHASE_MEMBER_SUMMARY_WORKSPACE_NULL_P1_REPORT.md) | MEMBER-SUMMARY-WORKSPACE-NULL-P1: REPORT。 |
| [phases/PHASE_DASHBOARD_STALE_WORKSPACE_P2_PLAN.md](process/phases/PHASE_DASHBOARD_STALE_WORKSPACE_P2_PLAN.md) | DASHBOARD-STALE-WORKSPACE-P2: stale peer / workspace 整理 PLAN。 |
| [phases/PHASE_DASHBOARD_STALE_WORKSPACE_P2_WORKLOG.md](process/phases/PHASE_DASHBOARD_STALE_WORKSPACE_P2_WORKLOG.md) | DASHBOARD-STALE-WORKSPACE-P2: WORKLOG。 |
| [phases/PHASE_DASHBOARD_STALE_WORKSPACE_P2_REPORT.md](process/phases/PHASE_DASHBOARD_STALE_WORKSPACE_P2_REPORT.md) | DASHBOARD-STALE-WORKSPACE-P2: REPORT。 |
| [phases/PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1_PLAN.md](process/phases/PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1_PLAN.md) | DASHBOARD-ONETOONES-SUMMARY-EXPANSION-P1: 1to1 KPI 総登録/予定/キャンセル補助表示 PLAN。 |
| [phases/PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1_WORKLOG.md](process/phases/PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1_WORKLOG.md) | DASHBOARD-ONETOONES-SUMMARY-EXPANSION-P1: WORKLOG。 |
| [phases/PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1_REPORT.md](process/phases/PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1_REPORT.md) | DASHBOARD-ONETOONES-SUMMARY-EXPANSION-P1: REPORT（Merge Evidence）。 |
| [phases/PHASE_MEMBERS_WORKSPACE_BACKFILL_P1_PLAN.md](process/phases/PHASE_MEMBERS_WORKSPACE_BACKFILL_P1_PLAN.md) | MEMBERS-WORKSPACE-BACKFILL-P1: members.workspace_id PLAN。 |
| [phases/PHASE_MEMBERS_WORKSPACE_BACKFILL_P1_WORKLOG.md](process/phases/PHASE_MEMBERS_WORKSPACE_BACKFILL_P1_WORKLOG.md) | MEMBERS-WORKSPACE-BACKFILL-P1: WORKLOG。 |
| [phases/PHASE_MEMBERS_WORKSPACE_BACKFILL_P1_REPORT.md](process/phases/PHASE_MEMBERS_WORKSPACE_BACKFILL_P1_REPORT.md) | MEMBERS-WORKSPACE-BACKFILL-P1: REPORT。 |
| [phases/PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_PLAN.md](process/phases/PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_PLAN.md) | M8.6: members.ncast_profile_url SSOT反映 PLAN。 |
| [phases/PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_WORKLOG.md](process/phases/PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_WORKLOG.md) | M8.6: WORKLOG。 |
| [phases/PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_REPORT.md](process/phases/PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_REPORT.md) | M8.6: REPORT。 |
| [phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_PLAN.md](process/phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_PLAN.md) | ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP: `/settings` 例外・1to1 owner フィルタ削除・§5.1 補足・死蔵 JS 削除 PLAN。 |
| [phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_WORKLOG.md](process/phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_WORKLOG.md) | ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP: WORKLOG。 |
| [phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_REPORT.md](process/phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_REPORT.md) | ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP: REPORT（Merge Evidence 記載）。 |
| [phases/PHASE_DASHBOARD_WEEKLY_P1_PLAN.md](process/phases/PHASE_DASHBOARD_WEEKLY_P1_PLAN.md) | **DASHBOARD-WEEKLY-P1:** Dashboard ウィークリープレゼン原稿（SPEC-004）最小実装 PLAN。 |
| [phases/PHASE_DASHBOARD_WEEKLY_P1_WORKLOG.md](process/phases/PHASE_DASHBOARD_WEEKLY_P1_WORKLOG.md) | DASHBOARD-WEEKLY-P1: WORKLOG。 |
| [phases/PHASE_DASHBOARD_WEEKLY_P1_REPORT.md](process/phases/PHASE_DASHBOARD_WEEKLY_P1_REPORT.md) | DASHBOARD-WEEKLY-P1: REPORT。 |
| [phases/PHASE_119_dashboard_weekly_tabs_PLAN.md](process/phases/PHASE_119_dashboard_weekly_tabs_PLAN.md) | Phase 119: Dashboard プレゼン原稿タブ化 PLAN。 |
| [phases/PHASE_119_dashboard_weekly_tabs_WORKLOG.md](process/phases/PHASE_119_dashboard_weekly_tabs_WORKLOG.md) | Phase 119: Dashboard プレゼン原稿タブ化 WORKLOG。 |
| [phases/PHASE_119_dashboard_weekly_tabs_REPORT.md](process/phases/PHASE_119_dashboard_weekly_tabs_REPORT.md) | Phase 119: Dashboard プレゼン原稿タブ化 REPORT。 |
| [phases/PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_PLAN.md](process/phases/PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_PLAN.md) | AXIOS-SC-2026-03: axios サプライチェーン侵害 影響調査 PLAN。 |
| [phases/PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_WORKLOG.md](process/phases/PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_WORKLOG.md) | AXIOS-SC-2026-03: WORKLOG（コマンド・証拠）。 |
| [phases/PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_REPORT.md](process/phases/PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_REPORT.md) | AXIOS-SC-2026-03: REPORT（結論 SAFE・根拠）。 |
| [phases/PHASE_BO_AUDIT_P1_PLAN.md](process/phases/PHASE_BO_AUDIT_P1_PLAN.md) | BO-AUDIT-P1: BO 保存監査ログ設計・Dashboard `bo_assigned` PLAN。 |
| [phases/PHASE_BO_AUDIT_P1_WORKLOG.md](process/phases/PHASE_BO_AUDIT_P1_WORKLOG.md) | BO-AUDIT-P1: WORKLOG。 |
| [phases/PHASE_BO_AUDIT_P1_REPORT.md](process/phases/PHASE_BO_AUDIT_P1_REPORT.md) | BO-AUDIT-P1: REPORT。 |
| [phases/PHASE_BO_AUDIT_P2_PLAN.md](process/phases/PHASE_BO_AUDIT_P2_PLAN.md) | BO-AUDIT-P2: レガシー BO 監査・workspace・actor PLAN。 |
| [phases/PHASE_BO_AUDIT_P2_WORKLOG.md](process/phases/PHASE_BO_AUDIT_P2_WORKLOG.md) | BO-AUDIT-P2: WORKLOG。 |
| [phases/PHASE_BO_AUDIT_P2_REPORT.md](process/phases/PHASE_BO_AUDIT_P2_REPORT.md) | BO-AUDIT-P2: REPORT。 |
| [phases/PHASE_BO_AUDIT_P3_PLAN.md](process/phases/PHASE_BO_AUDIT_P3_PLAN.md) | BO-AUDIT-P3: users/me と BO actor 一本化・workspace PLAN。 |
| [phases/PHASE_BO_AUDIT_P3_WORKLOG.md](process/phases/PHASE_BO_AUDIT_P3_WORKLOG.md) | BO-AUDIT-P3: WORKLOG。 |
| [phases/PHASE_BO_AUDIT_P3_REPORT.md](process/phases/PHASE_BO_AUDIT_P3_REPORT.md) | BO-AUDIT-P3: REPORT。 |
| [phases/PHASE_BO_AUDIT_P4_PLAN.md](process/phases/PHASE_BO_AUDIT_P4_PLAN.md) | BO-AUDIT-P4: `default_workspace_id`・me/actor 整合・Dashboard workspace 表示方針 PLAN。 |
| [phases/PHASE_BO_AUDIT_P4_WORKLOG.md](process/phases/PHASE_BO_AUDIT_P4_WORKLOG.md) | BO-AUDIT-P4: WORKLOG。 |
| [phases/PHASE_BO_AUDIT_P4_REPORT.md](process/phases/PHASE_BO_AUDIT_P4_REPORT.md) | BO-AUDIT-P4: REPORT。 |
| [phases/PHASE_BO_AUDIT_P5_PLAN.md](process/phases/PHASE_BO_AUDIT_P5_PLAN.md) | BO-AUDIT-P5: 所属チャプター設定 UI・me 連携 PLAN。 |
| [phases/PHASE_BO_AUDIT_P5_WORKLOG.md](process/phases/PHASE_BO_AUDIT_P5_WORKLOG.md) | BO-AUDIT-P5: WORKLOG。 |
| [phases/PHASE_BO_AUDIT_P5_REPORT.md](process/phases/PHASE_BO_AUDIT_P5_REPORT.md) | BO-AUDIT-P5: REPORT。 |
| [phases/PHASE_CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT_PLAN.md](process/phases/PHASE_CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT_PLAN.md) | CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT: BO/Autocomplete/Relationship Log にカテゴリ副行 PLAN（[SSOT](SSOT/CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md)）。 |
| [phases/PHASE_CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT_WORKLOG.md](process/phases/PHASE_CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT_WORKLOG.md) | CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT: WORKLOG。 |
| [phases/PHASE_CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT_REPORT.md](process/phases/PHASE_CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT_REPORT.md) | CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT: REPORT。 |
| [phases/PHASE_CONTACT_LOGIC_ALIGNMENT_ANALYSIS_PLAN.md](process/phases/PHASE_CONTACT_LOGIC_ALIGNMENT_ANALYSIS_PLAN.md) | CONTACT_LOGIC_ALIGNMENT_ANALYSIS: SSOT 整理 PLAN。 |
| [phases/PHASE_CONTACT_LOGIC_ALIGNMENT_ANALYSIS_WORKLOG.md](process/phases/PHASE_CONTACT_LOGIC_ALIGNMENT_ANALYSIS_WORKLOG.md) | CONTACT_LOGIC_ALIGNMENT_ANALYSIS: WORKLOG。 |
| [phases/PHASE_CONTACT_LOGIC_ALIGNMENT_ANALYSIS_REPORT.md](process/phases/PHASE_CONTACT_LOGIC_ALIGNMENT_ANALYSIS_REPORT.md) | CONTACT_LOGIC_ALIGNMENT_ANALYSIS: REPORT。 |
| [phases/PHASE_CONN_PARTICIPANTS_ALIGNMENT_P0_PLAN.md](process/phases/PHASE_CONN_PARTICIPANTS_ALIGNMENT_P0_PLAN.md) | CONN-PARTICIPANTS-ALIGN-P0: SPEC-007 関連・Connections/BO/participants 整合 **調査** PLAN（実装なし）。 |
| [phases/PHASE_CONN_PARTICIPANTS_ALIGNMENT_P0_WORKLOG.md](process/phases/PHASE_CONN_PARTICIPANTS_ALIGNMENT_P0_WORKLOG.md) | CONN-PARTICIPANTS-ALIGN-P0: WORKLOG。 |
| [phases/PHASE_CONN_PARTICIPANTS_ALIGNMENT_P0_REPORT.md](process/phases/PHASE_CONN_PARTICIPANTS_ALIGNMENT_P0_REPORT.md) | CONN-PARTICIPANTS-ALIGN-P0: REPORT（現状・ギャップ・最小変更単位・次 Phase 対象ファイル）。 |
| [phases/PHASE_CONN_BO_PARTICIPANT_REQUIRED_P1_PLAN.md](process/phases/PHASE_CONN_BO_PARTICIPANT_REQUIRED_P1_PLAN.md) | CONN-BO-PARTICIPANT-REQUIRED-P1: BO 保存で participant 未存在を 422（SPEC-007）PLAN。 |
| [phases/PHASE_CONN_BO_PARTICIPANT_REQUIRED_P1_WORKLOG.md](process/phases/PHASE_CONN_BO_PARTICIPANT_REQUIRED_P1_WORKLOG.md) | CONN-BO-PARTICIPANT-REQUIRED-P1: WORKLOG。 |
| [phases/PHASE_CONN_BO_PARTICIPANT_REQUIRED_P1_REPORT.md](process/phases/PHASE_CONN_BO_PARTICIPANT_REQUIRED_P1_REPORT.md) | CONN-BO-PARTICIPANT-REQUIRED-P1: REPORT（禁止内容・責務・互換・UI 引き継ぎ）。 |
| [phases/PHASE_CONN_LEFT_PANE_MEETING_P1_PLAN.md](process/phases/PHASE_CONN_LEFT_PANE_MEETING_P1_PLAN.md) | CONN-LEFT-PANE-MEETING-P1: Connections 左ペインを参加者のみ表示 PLAN。 |
| [phases/PHASE_CONN_LEFT_PANE_MEETING_P1_WORKLOG.md](process/phases/PHASE_CONN_LEFT_PANE_MEETING_P1_WORKLOG.md) | CONN-LEFT-PANE-MEETING-P1: WORKLOG。 |
| [phases/PHASE_CONN_LEFT_PANE_MEETING_P1_REPORT.md](process/phases/PHASE_CONN_LEFT_PANE_MEETING_P1_REPORT.md) | CONN-LEFT-PANE-MEETING-P1: REPORT（API/フロント方針・type 表・残課題）。 |
| [phases/PHASE_CONN_BO_UX_GUARDS_P1_PLAN.md](process/phases/PHASE_CONN_BO_UX_GUARDS_P1_PLAN.md) | CONN-BO-UX-GUARDS-P1: Connections BO 割当 UX ガード（保存前・422・コピー）PLAN（SPEC-007）。 |
| [phases/PHASE_CONN_BO_UX_GUARDS_P1_WORKLOG.md](process/phases/PHASE_CONN_BO_UX_GUARDS_P1_WORKLOG.md) | CONN-BO-UX-GUARDS-P1: WORKLOG。 |
| [phases/PHASE_CONN_BO_UX_GUARDS_P1_REPORT.md](process/phases/PHASE_CONN_BO_UX_GUARDS_P1_REPORT.md) | CONN-BO-UX-GUARDS-P1: REPORT（保存前/API ガード・文言・proxy 将来影響）。 |
| [phases/PHASE_MEMBERS_DEDUP_RUNBOOK_P0_PLAN.md](process/phases/PHASE_MEMBERS_DEDUP_RUNBOOK_P0_PLAN.md) | MEMBERS-DEDUP-RUNBOOK-P0: members 重複・マージ運用 Runbook（SPEC-008）PLAN（実装なし）。 |
| [phases/PHASE_MEMBERS_DEDUP_RUNBOOK_P0_WORKLOG.md](process/phases/PHASE_MEMBERS_DEDUP_RUNBOOK_P0_WORKLOG.md) | MEMBERS-DEDUP-RUNBOOK-P0: WORKLOG。 |
| [phases/PHASE_MEMBERS_DEDUP_RUNBOOK_P0_REPORT.md](process/phases/PHASE_MEMBERS_DEDUP_RUNBOOK_P0_REPORT.md) | MEMBERS-DEDUP-RUNBOOK-P0: REPORT（発生条件・影響・案 A/B/C・次実装）。 |
| [phases/PHASE_MEMBERS_MERGE_ASSIST_P1_PLAN.md](process/phases/PHASE_MEMBERS_MERGE_ASSIST_P1_PLAN.md) | MEMBERS-MERGE-ASSIST-P1: 管理者 member マージ API・UI PLAN（SPEC-008）。 |
| [phases/PHASE_MEMBERS_MERGE_ASSIST_P1_WORKLOG.md](process/phases/PHASE_MEMBERS_MERGE_ASSIST_P1_WORKLOG.md) | MEMBERS-MERGE-ASSIST-P1: WORKLOG。 |
| [phases/PHASE_MEMBERS_MERGE_ASSIST_P1_REPORT.md](process/phases/PHASE_MEMBERS_MERGE_ASSIST_P1_REPORT.md) | MEMBERS-MERGE-ASSIST-P1: REPORT（付け替え表・リスク・未対応）。 |
| [phases/PHASE_CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT_PLAN.md](process/phases/PHASE_CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT_PLAN.md) | CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT: 999 表示・補助文 PLAN。 |
| [phases/PHASE_CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT_WORKLOG.md](process/phases/PHASE_CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT_WORKLOG.md) | CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT: WORKLOG。 |
| [phases/PHASE_CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT_REPORT.md](process/phases/PHASE_CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT_REPORT.md) | CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT: REPORT。 |
| [phases/PHASE_MEMBER_DISPLAY_HELPER_UNIFICATION_PLAN.md](process/phases/PHASE_MEMBER_DISPLAY_HELPER_UNIFICATION_PLAN.md) | MEMBER_DISPLAY_HELPER_UNIFICATION: `memberDisplay.js` 共通化 PLAN。 |
| [phases/PHASE_MEMBER_DISPLAY_HELPER_UNIFICATION_WORKLOG.md](process/phases/PHASE_MEMBER_DISPLAY_HELPER_UNIFICATION_WORKLOG.md) | MEMBER_DISPLAY_HELPER_UNIFICATION: WORKLOG。 |
| [phases/PHASE_MEMBER_DISPLAY_HELPER_UNIFICATION_REPORT.md](process/phases/PHASE_MEMBER_DISPLAY_HELPER_UNIFICATION_REPORT.md) | MEMBER_DISPLAY_HELPER_UNIFICATION: REPORT。 |
| [phases/PHASE_WORKSPACE_SINGLE_CHAPTER_ASSUMPTION_PLAN.md](process/phases/PHASE_WORKSPACE_SINGLE_CHAPTER_ASSUMPTION_PLAN.md) | WORKSPACE-SINGLE-CHAPTER-ASSUMPTION: BNI 前提 1 user=1 workspace SSOT 固定 PLAN。 |
| [phases/PHASE_WORKSPACE_SINGLE_CHAPTER_ASSUMPTION_WORKLOG.md](process/phases/PHASE_WORKSPACE_SINGLE_CHAPTER_ASSUMPTION_WORKLOG.md) | WORKSPACE-SINGLE-CHAPTER-ASSUMPTION: WORKLOG。 |
| [phases/PHASE_WORKSPACE_SINGLE_CHAPTER_ASSUMPTION_REPORT.md](process/phases/PHASE_WORKSPACE_SINGLE_CHAPTER_ASSUMPTION_REPORT.md) | WORKSPACE-SINGLE-CHAPTER-ASSUMPTION: REPORT。 |
| [process/ONETOONES_P1_P4_SUMMARY.md](process/ONETOONES_P1_P4_SUMMARY.md) | **ONETOONES P1〜P4 総括**（実運用到達・設計決定・Gap・優先順位）。 |
| [phases/PHASE12_RELIGO_BOARD_UX_REFRESH_PLAN.md](process/phases/PHASE12_RELIGO_BOARD_UX_REFRESH_PLAN.md) | Phase12 Religo: Board UX Refresh PLAN。 |
| [phases/PHASE12_RELIGO_BOARD_UX_REFRESH_WORKLOG.md](process/phases/PHASE12_RELIGO_BOARD_UX_REFRESH_WORKLOG.md) | Phase12 Religo: Board UX WORKLOG。 |
| [phases/PHASE12_RELIGO_BOARD_UX_REFRESH_REPORT.md](process/phases/PHASE12_RELIGO_BOARD_UX_REFRESH_REPORT.md) | Phase12 Religo: Board UX REPORT。 |
| [phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_PLAN.md](process/phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_PLAN.md) | Phase12S Religo: Board MUI 骨格・余白・階層 PLAN。 |
| [phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_WORKLOG.md](process/phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_WORKLOG.md) | Phase12S Religo: Board MUI Polish WORKLOG。 |
| [phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_REPORT.md](process/phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_REPORT.md) | Phase12S Religo: Board MUI Polish REPORT。 |
| [phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_PLAN.md](process/phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_PLAN.md) | Phase12T Religo: Admin Theme SSOT + 適用 PLAN。 |
| [phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_WORKLOG.md](process/phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_WORKLOG.md) | Phase12T Religo: Admin Theme SSOT WORKLOG。 |
| [phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_REPORT.md](process/phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_REPORT.md) | Phase12T Religo: Admin Theme SSOT REPORT。 |
| [phases/PHASE_G1_PHASE12T_AND_M4_INTEGRATION_PLAN.md](process/phases/PHASE_G1_PHASE12T_AND_M4_INTEGRATION_PLAN.md) | Phase G1: phase12t と M4 UI suite の Git 整合 PLAN。 |
| [phases/PHASE_G1_PHASE12T_AND_M4_INTEGRATION_WORKLOG.md](process/phases/PHASE_G1_PHASE12T_AND_M4_INTEGRATION_WORKLOG.md) | Phase G1: Git 整合 WORKLOG。 |
| [phases/PHASE_G1_PHASE12T_AND_M4_INTEGRATION_REPORT.md](process/phases/PHASE_G1_PHASE12T_AND_M4_INTEGRATION_REPORT.md) | Phase G1: Git 整合 REPORT。 |
| [phases/PHASE_G2_SSOT_DOCS_ALIGNMENT_PLAN.md](process/phases/PHASE_G2_SSOT_DOCS_ALIGNMENT_PLAN.md) | Phase G2: SSOT / docs alignment after G1 PLAN。 |
| [phases/PHASE_G2_SSOT_DOCS_ALIGNMENT_WORKLOG.md](process/phases/PHASE_G2_SSOT_DOCS_ALIGNMENT_WORKLOG.md) | Phase G2: SSOT/docs alignment WORKLOG。 |
| [phases/PHASE_G2_SSOT_DOCS_ALIGNMENT_REPORT.md](process/phases/PHASE_G2_SSOT_DOCS_ALIGNMENT_REPORT.md) | Phase G2: SSOT/docs alignment REPORT。 |
| [phases/PHASE_G3_IMPLEMENTATION_RESIDUE_TRIAGE_PLAN.md](process/phases/PHASE_G3_IMPLEMENTATION_RESIDUE_TRIAGE_PLAN.md) | Phase G3: Implementation residue triage PLAN。 |
| [phases/PHASE_G3_IMPLEMENTATION_RESIDUE_TRIAGE_WORKLOG.md](process/phases/PHASE_G3_IMPLEMENTATION_RESIDUE_TRIAGE_WORKLOG.md) | Phase G3: Implementation residue triage WORKLOG。 |
| [phases/PHASE_G3_IMPLEMENTATION_RESIDUE_TRIAGE_REPORT.md](process/phases/PHASE_G3_IMPLEMENTATION_RESIDUE_TRIAGE_REPORT.md) | Phase G3: Implementation residue triage REPORT。 |
| [phases/PHASE_G4_CSV_IMPORT_IMPLEMENTATION_BUNDLE_PLAN.md](process/phases/PHASE_G4_CSV_IMPORT_IMPLEMENTATION_BUNDLE_PLAN.md) | Phase G4: CSV import implementation bundle PLAN。 |
| [phases/PHASE_G4_CSV_IMPORT_IMPLEMENTATION_BUNDLE_WORKLOG.md](process/phases/PHASE_G4_CSV_IMPORT_IMPLEMENTATION_BUNDLE_WORKLOG.md) | Phase G4: CSV import implementation bundle WORKLOG。 |
| [phases/PHASE_G4_CSV_IMPORT_IMPLEMENTATION_BUNDLE_REPORT.md](process/phases/PHASE_G4_CSV_IMPORT_IMPLEMENTATION_BUNDLE_REPORT.md) | Phase G4: CSV import implementation bundle REPORT。 |
| [phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_PLAN.md](process/phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_PLAN.md) | Phase G5: mock asset / reference file alignment PLAN。 |
| [phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_WORKLOG.md](process/phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_WORKLOG.md) | Phase G5: mock asset / reference file alignment WORKLOG。 |
| [phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_REPORT.md](process/phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_REPORT.md) | Phase G5: mock asset / reference file alignment REPORT。 |
| [phases/PHASE_G6_CURSOR_TOOLING_POLICY_ALIGNMENT_PLAN.md](process/phases/PHASE_G6_CURSOR_TOOLING_POLICY_ALIGNMENT_PLAN.md) | Phase G6: .cursor tooling policy alignment PLAN。 |
| [phases/PHASE_G6_CURSOR_TOOLING_POLICY_ALIGNMENT_WORKLOG.md](process/phases/PHASE_G6_CURSOR_TOOLING_POLICY_ALIGNMENT_WORKLOG.md) | Phase G6: .cursor tooling policy alignment WORKLOG。 |
| [phases/PHASE_G6_CURSOR_TOOLING_POLICY_ALIGNMENT_REPORT.md](process/phases/PHASE_G6_CURSOR_TOOLING_POLICY_ALIGNMENT_REPORT.md) | Phase G6: .cursor tooling policy alignment REPORT。 |
| [phases/PHASE_G10_PHASE13_REMOVE_ROUND_REWORK_PLAN.md](process/phases/PHASE_G10_PHASE13_REMOVE_ROUND_REWORK_PLAN.md) | Phase G10: phase13 remove round rework PLAN。 |
| [phases/PHASE_G10_PHASE13_REMOVE_ROUND_REWORK_WORKLOG.md](process/phases/PHASE_G10_PHASE13_REMOVE_ROUND_REWORK_WORKLOG.md) | Phase G10: phase13 remove round rework WORKLOG。 |
| [phases/PHASE_G10_PHASE13_REMOVE_ROUND_REWORK_REPORT.md](process/phases/PHASE_G10_PHASE13_REMOVE_ROUND_REWORK_REPORT.md) | Phase G10: phase13 remove round rework REPORT。 |
| [phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_PLAN.md](process/phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_PLAN.md) | Phase G11: DragonFly breakout duplicate member support PLAN。 |
| [phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_WORKLOG.md](process/phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_WORKLOG.md) | Phase G11: DragonFly breakout duplicate member support WORKLOG。 |
| [phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_REPORT.md](process/phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_REPORT.md) | Phase G11: DragonFly breakout duplicate member support REPORT。 |
| [phases/PHASE_G13_REPOSITORY_BRANCH_CLEANUP_FINAL_PLAN.md](process/phases/PHASE_G13_REPOSITORY_BRANCH_CLEANUP_FINAL_PLAN.md) | Phase G13: Repository Branch Cleanup Final PLAN。 |
| [phases/PHASE_G13_REPOSITORY_BRANCH_CLEANUP_FINAL_WORKLOG.md](process/phases/PHASE_G13_REPOSITORY_BRANCH_CLEANUP_FINAL_WORKLOG.md) | Phase G13: Repository Branch Cleanup Final WORKLOG。 |
| [phases/PHASE_G13_REPOSITORY_BRANCH_CLEANUP_FINAL_REPORT.md](process/phases/PHASE_G13_REPOSITORY_BRANCH_CLEANUP_FINAL_REPORT.md) | Phase G13: Repository Branch Cleanup Final REPORT。 |
| [phases/PHASE12R_RELIGO_ROADMAP_SSOT_PLAN.md](process/phases/PHASE12R_RELIGO_ROADMAP_SSOT_PLAN.md) | Phase12R Religo: 全体ロードマップ SSOT PLAN。 |
| [phases/PHASE12R_RELIGO_ROADMAP_SSOT_WORKLOG.md](process/phases/PHASE12R_RELIGO_ROADMAP_SSOT_WORKLOG.md) | Phase12R Religo: ロードマップ SSOT WORKLOG。 |
| [phases/PHASE12R_RELIGO_ROADMAP_SSOT_REPORT.md](process/phases/PHASE12R_RELIGO_ROADMAP_SSOT_REPORT.md) | Phase12R Religo: ロードマップ SSOT REPORT。 |
| [phases/PHASE12U_RELIGO_BOARD_3PANE_IA_PLAN.md](process/phases/PHASE12U_RELIGO_BOARD_3PANE_IA_PLAN.md) | Phase12U Religo: Board 3ペイン IA PLAN。 |
| [phases/PHASE12U_RELIGO_BOARD_3PANE_IA_WORKLOG.md](process/phases/PHASE12U_RELIGO_BOARD_3PANE_IA_WORKLOG.md) | Phase12U Religo: Board 3ペイン IA WORKLOG。 |
| [phases/PHASE12U_RELIGO_BOARD_3PANE_IA_REPORT.md](process/phases/PHASE12U_RELIGO_BOARD_3PANE_IA_REPORT.md) | Phase12U Religo: Board 3ペイン IA REPORT。 |
| [phases/PHASE12V_RELIGO_MEMBERS_MEETINGS_LIST_PLAN.md](process/phases/PHASE12V_RELIGO_MEMBERS_MEETINGS_LIST_PLAN.md) | Phase12V Religo: Members/Meetings List PLAN。 |
| [phases/PHASE12V_RELIGO_MEMBERS_MEETINGS_LIST_WORKLOG.md](process/phases/PHASE12V_RELIGO_MEMBERS_MEETINGS_LIST_WORKLOG.md) | Phase12V Religo: Members/Meetings List WORKLOG。 |
| [phases/PHASE12V_RELIGO_MEMBERS_MEETINGS_LIST_REPORT.md](process/phases/PHASE12V_RELIGO_MEMBERS_MEETINGS_LIST_REPORT.md) | Phase12V Religo: Members/Meetings List REPORT。 |
| [phases/PHASE12W_RELIGO_BOARD_SHORTCUT_PLAN.md](process/phases/PHASE12W_RELIGO_BOARD_SHORTCUT_PLAN.md) | Phase12W Religo: Board ショートカット導線 PLAN。 |
| [phases/PHASE12W_RELIGO_BOARD_SHORTCUT_WORKLOG.md](process/phases/PHASE12W_RELIGO_BOARD_SHORTCUT_WORKLOG.md) | Phase12W Religo: Board ショートカット WORKLOG。 |
| [phases/PHASE12W_RELIGO_BOARD_SHORTCUT_REPORT.md](process/phases/PHASE12W_RELIGO_BOARD_SHORTCUT_REPORT.md) | Phase12W Religo: Board ショートカット REPORT。 |
| [phases/PHASE16A_MEMBERS_REQUIREMENTS_PLAN.md](process/phases/PHASE16A_MEMBERS_REQUIREMENTS_PLAN.md) | Phase16A Religo: Members 要件棚卸し（SSOT 化）PLAN。 |
| [phases/PHASE16A_MEMBERS_REQUIREMENTS_WORKLOG.md](process/phases/PHASE16A_MEMBERS_REQUIREMENTS_WORKLOG.md) | Phase16A Religo: Members 要件 SSOT WORKLOG。 |
| [phases/PHASE16A_MEMBERS_REQUIREMENTS_REPORT.md](process/phases/PHASE16A_MEMBERS_REQUIREMENTS_REPORT.md) | Phase16A Religo: Members 要件 SSOT REPORT。 |
| [phases/PHASE16B_RELIGO_ADMIN_UI_MOCK_SYNC_PLAN.md](process/phases/PHASE16B_RELIGO_ADMIN_UI_MOCK_SYNC_PLAN.md) | Phase16B Religo: 管理画面 UI モック同期 PLAN。 |
| [phases/PHASE16B_RELIGO_ADMIN_UI_MOCK_SYNC_WORKLOG.md](process/phases/PHASE16B_RELIGO_ADMIN_UI_MOCK_SYNC_WORKLOG.md) | Phase16B Religo: 管理画面 UI モック同期 WORKLOG。 |
| [phases/PHASE16B_RELIGO_ADMIN_UI_MOCK_SYNC_REPORT.md](process/phases/PHASE16B_RELIGO_ADMIN_UI_MOCK_SYNC_REPORT.md) | Phase16B Religo: 管理画面 UI モック同期 REPORT。 |
| [phases/PHASE16C_SETTINGS_CRUD_AND_MEMBER_ACTIONS_PLAN.md](process/phases/PHASE16C_SETTINGS_CRUD_AND_MEMBER_ACTIONS_PLAN.md) | Phase16C Religo: Settings CRUD + RoleHistory + Members 最短操作 PLAN。 |
| [phases/PHASE16C_SETTINGS_CRUD_AND_MEMBER_ACTIONS_WORKLOG.md](process/phases/PHASE16C_SETTINGS_CRUD_AND_MEMBER_ACTIONS_WORKLOG.md) | Phase16C Religo: Settings CRUD + Members 仕上げ WORKLOG。 |
| [phases/PHASE16C_SETTINGS_CRUD_AND_MEMBER_ACTIONS_REPORT.md](process/phases/PHASE16C_SETTINGS_CRUD_AND_MEMBER_ACTIONS_REPORT.md) | Phase16C Religo: Settings CRUD + Members 仕上げ REPORT。 |
| [phases/PHASE17A_RELIGO_MEMBER_DRAWER_PLAN.md](process/phases/PHASE17A_RELIGO_MEMBER_DRAWER_PLAN.md) | Phase17A Religo: Members 詳細 Drawer + Memos/1to1 タブ PLAN。 |
| [phases/PHASE17A_RELIGO_MEMBER_DRAWER_WORKLOG.md](process/phases/PHASE17A_RELIGO_MEMBER_DRAWER_WORKLOG.md) | Phase17A Religo: Member Drawer WORKLOG。 |
| [phases/PHASE17A_RELIGO_MEMBER_DRAWER_REPORT.md](process/phases/PHASE17A_RELIGO_MEMBER_DRAWER_REPORT.md) | Phase17A Religo: Member Drawer REPORT。 |
| [phases/PHASE17B_RELIGO_MEETING_DRAWER_PLAN.md](process/phases/PHASE17B_RELIGO_MEETING_DRAWER_PLAN.md) | Phase17B Religo: Meetings 詳細 Drawer + 例会メモ PLAN。 |
| [phases/PHASE17B_RELIGO_MEETING_DRAWER_WORKLOG.md](process/phases/PHASE17B_RELIGO_MEETING_DRAWER_WORKLOG.md) | Phase17B Religo: Meeting Drawer WORKLOG。 |
| [phases/PHASE17B_RELIGO_MEETING_DRAWER_REPORT.md](process/phases/PHASE17B_RELIGO_MEETING_DRAWER_REPORT.md) | Phase17B Religo: Meeting Drawer REPORT。 |
| [phases/PHASE_M1_MEMBERS_GAP_PLAN.md](process/phases/PHASE_M1_MEMBERS_GAP_PLAN.md) | Phase M-1: Members Gap 解消（Docs）PLAN。 |
| [phases/PHASE_M1_MEMBERS_GAP_WORKLOG.md](process/phases/PHASE_M1_MEMBERS_GAP_WORKLOG.md) | Phase M-1: Members Gap WORKLOG。 |
| [phases/PHASE_M1_MEMBERS_GAP_REPORT.md](process/phases/PHASE_M1_MEMBERS_GAP_REPORT.md) | Phase M-1: Members Gap REPORT。 |
| [phases/PHASE_M2_MEMBERS_REQUIRED_COLUMNS_REPORT.md](process/phases/PHASE_M2_MEMBERS_REQUIRED_COLUMNS_REPORT.md) | Phase M-2: Members 必須列・サブタイトル REPORT。 |
| [phases/PHASE_M3_MEMBERS_FILTER_SORT_PLAN.md](process/phases/PHASE_M3_MEMBERS_FILTER_SORT_PLAN.md) | Phase M-3: Members 検索/フィルタ/ソート PLAN。 |
| [phases/PHASE_M3_MEMBERS_FILTER_SORT_WORKLOG.md](process/phases/PHASE_M3_MEMBERS_FILTER_SORT_WORKLOG.md) | Phase M-3: Members 検索/フィルタ/ソート WORKLOG。 |
| [phases/PHASE_M3_MEMBERS_FILTER_SORT_REPORT.md](process/phases/PHASE_M3_MEMBERS_FILTER_SORT_REPORT.md) | Phase M-3: Members 検索/フィルタ/ソート REPORT。 |
| [phases/PHASE_M4_MEMBERS_LAYOUT_PLAN.md](process/phases/PHASE_M4_MEMBERS_LAYOUT_PLAN.md) | Phase M-4: Members パッと見レイアウト（モック準拠）PLAN。統計カード・横並びフィルタバー・ブロック構成。 |
| [phases/PHASE_M4_MEMBERS_LAYOUT_WORKLOG.md](process/phases/PHASE_M4_MEMBERS_LAYOUT_WORKLOG.md) | Phase M-4: Members パッと見レイアウト WORKLOG。 |
| [phases/PHASE_M4_MEMBERS_LAYOUT_REPORT.md](process/phases/PHASE_M4_MEMBERS_LAYOUT_REPORT.md) | Phase M-4: Members パッと見レイアウト REPORT。 |
| [phases/PHASE_M4D_MEMBERS_LIST_CARD_PLAN.md](process/phases/PHASE_M4D_MEMBERS_LIST_CARD_PLAN.md) | Phase M4D: Members List/Card 表示切替 PLAN。 |
| [phases/PHASE_M4D_MEMBERS_LIST_CARD_WORKLOG.md](process/phases/PHASE_M4D_MEMBERS_LIST_CARD_WORKLOG.md) | Phase M4D: Members List/Card 表示切替 WORKLOG。 |
| [phases/PHASE_M4D_MEMBERS_LIST_CARD_REPORT.md](process/phases/PHASE_M4D_MEMBERS_LIST_CARD_REPORT.md) | Phase M4D: Members List/Card 表示切替 REPORT。 |
| [phases/PHASE_M4E_MEMBERS_CARD_LOGS_PLAN.md](process/phases/PHASE_M4E_MEMBERS_CARD_LOGS_PLAN.md) | Phase M4E: Members Card 関係ログ表示 PLAN。 |
| [phases/PHASE_M4E_MEMBERS_CARD_LOGS_WORKLOG.md](process/phases/PHASE_M4E_MEMBERS_CARD_LOGS_WORKLOG.md) | Phase M4E: Members Card 関係ログ表示 WORKLOG。 |
| [phases/PHASE_M4E_MEMBERS_CARD_LOGS_REPORT.md](process/phases/PHASE_M4E_MEMBERS_CARD_LOGS_REPORT.md) | Phase M4E: Members Card 関係ログ表示 REPORT。 |
| [phases/PHASE_M4F_MEMBERS_NAME_KANA_PLAN.md](process/phases/PHASE_M4F_MEMBERS_NAME_KANA_PLAN.md) | Phase M4F: Members 一覧かな表示 PLAN。 |
| [phases/PHASE_M4F_MEMBERS_NAME_KANA_WORKLOG.md](process/phases/PHASE_M4F_MEMBERS_NAME_KANA_WORKLOG.md) | Phase M4F: Members 一覧かな表示 WORKLOG。 |
| [phases/PHASE_M4F_MEMBERS_NAME_KANA_REPORT.md](process/phases/PHASE_M4F_MEMBERS_NAME_KANA_REPORT.md) | Phase M4F: Members 一覧かな表示 REPORT。 |
| [phases/PHASE_M4G_MEMBERS_GROUP_FILTER_PLAN.md](process/phases/PHASE_M4G_MEMBERS_GROUP_FILTER_PLAN.md) | Phase M4G: Members 大カテゴリ単独フィルタ追加 PLAN。 |
| [phases/PHASE_M4G_MEMBERS_GROUP_FILTER_WORKLOG.md](process/phases/PHASE_M4G_MEMBERS_GROUP_FILTER_WORKLOG.md) | Phase M4G: Members 大カテゴリ単独フィルタ追加 WORKLOG。 |
| [phases/PHASE_M4G_MEMBERS_GROUP_FILTER_REPORT.md](process/phases/PHASE_M4G_MEMBERS_GROUP_FILTER_REPORT.md) | Phase M4G: Members 大カテゴリ単独フィルタ追加 REPORT。 |
| [phases/PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_PLAN.md](process/phases/PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_PLAN.md) | Phase M4H: Members Card Relationship Score 表示 PLAN。 |
| [phases/PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_WORKLOG.md](process/phases/PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_WORKLOG.md) | Phase M4H: Members Card Relationship Score 表示 WORKLOG。 |
| [phases/PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_REPORT.md](process/phases/PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_REPORT.md) | Phase M4H: Members Card Relationship Score 表示 REPORT。 |
| [phases/PHASE_M4I_MEMBERS_DEFAULT_CARD_PLAN.md](process/phases/PHASE_M4I_MEMBERS_DEFAULT_CARD_PLAN.md) | Phase M4I: Members デフォルト表示を Card に変更 PLAN。 |
| [phases/PHASE_M4I_MEMBERS_DEFAULT_CARD_WORKLOG.md](process/phases/PHASE_M4I_MEMBERS_DEFAULT_CARD_WORKLOG.md) | Phase M4I: Members デフォルト表示を Card に変更 WORKLOG。 |
| [phases/PHASE_M4I_MEMBERS_DEFAULT_CARD_REPORT.md](process/phases/PHASE_M4I_MEMBERS_DEFAULT_CARD_REPORT.md) | Phase M4I: Members デフォルト表示を Card に変更 REPORT。 |
| [phases/PHASE_M4J_MEMBERS_FILTERBAR_IMPROVEMENT_PLAN.md](process/phases/PHASE_M4J_MEMBERS_FILTERBAR_IMPROVEMENT_PLAN.md) | Phase M4J: Members FilterBar 改善 PLAN。 |
| [phases/PHASE_M4J_MEMBERS_FILTERBAR_IMPROVEMENT_WORKLOG.md](process/phases/PHASE_M4J_MEMBERS_FILTERBAR_IMPROVEMENT_WORKLOG.md) | Phase M4J: Members FilterBar 改善 WORKLOG。 |
| [phases/PHASE_M4J_MEMBERS_FILTERBAR_IMPROVEMENT_REPORT.md](process/phases/PHASE_M4J_MEMBERS_FILTERBAR_IMPROVEMENT_REPORT.md) | Phase M4J: Members FilterBar 改善 REPORT。 |
| [phases/PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_PLAN.md](process/phases/PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_PLAN.md) | Phase M4K: Members Card向け並び順の強化 PLAN。 |
| [phases/PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_WORKLOG.md](process/phases/PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_WORKLOG.md) | Phase M4K: Members Card向け並び順の強化 WORKLOG。 |
| [phases/PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_REPORT.md](process/phases/PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_REPORT.md) | Phase M4K: Members Card向け並び順の強化 REPORT。 |
| [phases/PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_PLAN.md](process/phases/PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_PLAN.md) | Phase M4L: Members から Connections への導線強化 PLAN。 |
| [phases/PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_WORKLOG.md](process/phases/PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_WORKLOG.md) | Phase M4L: Members から Connections への導線強化 WORKLOG。 |
| [phases/PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_REPORT.md](process/phases/PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_REPORT.md) | Phase M4L: Members から Connections への導線強化 REPORT。 |
| [phases/PHASE_MEETINGS_LIST_ENHANCEMENT_PLAN.md](process/phases/PHASE_MEETINGS_LIST_ENHANCEMENT_PLAN.md) | Phase M1: Meetings 一覧改善（API 拡張・サブ説明・BO数/メモ列）PLAN。 |
| [phases/PHASE_MEETINGS_LIST_ENHANCEMENT_WORKLOG.md](process/phases/PHASE_MEETINGS_LIST_ENHANCEMENT_WORKLOG.md) | Phase M1: Meetings 一覧改善 WORKLOG。 |
| [phases/PHASE_MEETINGS_LIST_ENHANCEMENT_REPORT.md](process/phases/PHASE_MEETINGS_LIST_ENHANCEMENT_REPORT.md) | Phase M1: Meetings 一覧改善 REPORT。 |
| [phases/PHASE_MEETINGS_ROW_ACTIONS_PLAN.md](process/phases/PHASE_MEETINGS_ROW_ACTIONS_PLAN.md) | Phase M2: Meetings 一覧行アクション（📝メモ・🗺BO編集）PLAN。 |
| [phases/PHASE_MEETINGS_ROW_ACTIONS_WORKLOG.md](process/phases/PHASE_MEETINGS_ROW_ACTIONS_WORKLOG.md) | Phase M2: Meetings 行アクション WORKLOG。 |
| [phases/PHASE_MEETINGS_ROW_ACTIONS_REPORT.md](process/phases/PHASE_MEETINGS_ROW_ACTIONS_REPORT.md) | Phase M2: Meetings 行アクション REPORT。 |
| [phases/PHASE_MEETINGS_DETAIL_DRAWER_PLAN.md](process/phases/PHASE_MEETINGS_DETAIL_DRAWER_PLAN.md) | Phase M3: Meetings 例会詳細 Drawer PLAN。 |
| [phases/PHASE_MEETINGS_DETAIL_DRAWER_WORKLOG.md](process/phases/PHASE_MEETINGS_DETAIL_DRAWER_WORKLOG.md) | Phase M3: Meetings 詳細 Drawer WORKLOG。 |
| [phases/PHASE_MEETINGS_DETAIL_DRAWER_REPORT.md](process/phases/PHASE_MEETINGS_DETAIL_DRAWER_REPORT.md) | Phase M3: Meetings 詳細 Drawer REPORT。 |
| [phases/PHASE_MEETINGS_MEMO_MODAL_PLAN.md](process/phases/PHASE_MEETINGS_MEMO_MODAL_PLAN.md) | Phase M4: Meetings 例会メモ編集モーダル PLAN。 |
| [phases/PHASE_MEETINGS_MEMO_MODAL_WORKLOG.md](process/phases/PHASE_MEETINGS_MEMO_MODAL_WORKLOG.md) | Phase M4: Meetings メモモーダル WORKLOG。 |
| [phases/PHASE_MEETINGS_MEMO_MODAL_REPORT.md](process/phases/PHASE_MEETINGS_MEMO_MODAL_REPORT.md) | Phase M4: Meetings メモモーダル REPORT。 |
| [phases/PHASE_MEETINGS_TOOLBAR_FILTERS_PLAN.md](process/phases/PHASE_MEETINGS_TOOLBAR_FILTERS_PLAN.md) | Phase M5: Meetings 一覧ツールバー・フィルタ PLAN。 |
| [phases/PHASE_MEETINGS_TOOLBAR_FILTERS_WORKLOG.md](process/phases/PHASE_MEETINGS_TOOLBAR_FILTERS_WORKLOG.md) | Phase M5: Meetings ツールバー・フィルタ WORKLOG。 |
| [phases/PHASE_MEETINGS_TOOLBAR_FILTERS_REPORT.md](process/phases/PHASE_MEETINGS_TOOLBAR_FILTERS_REPORT.md) | Phase M5: Meetings ツールバー・フィルタ REPORT。 |
| [phases/PHASE_MEETINGS_STATS_CARDS_PLAN.md](process/phases/PHASE_MEETINGS_STATS_CARDS_PLAN.md) | Phase M6: Meetings 統計カード PLAN。 |
| [phases/PHASE_MEETINGS_STATS_CARDS_WORKLOG.md](process/phases/PHASE_MEETINGS_STATS_CARDS_WORKLOG.md) | Phase M6: Meetings 統計カード WORKLOG。 |
| [phases/PHASE_MEETINGS_STATS_CARDS_REPORT.md](process/phases/PHASE_MEETINGS_STATS_CARDS_REPORT.md) | Phase M6: Meetings 統計カード REPORT。 |
| [phases/PHASE_MEETINGS_FIT_AND_GAP_FINAL_UPDATE_PLAN.md](process/phases/PHASE_MEETINGS_FIT_AND_GAP_FINAL_UPDATE_PLAN.md) | Meetings FIT&GAP Final Update PLAN。 |
| [phases/PHASE_MEETINGS_FIT_AND_GAP_FINAL_UPDATE_WORKLOG.md](process/phases/PHASE_MEETINGS_FIT_AND_GAP_FINAL_UPDATE_WORKLOG.md) | Meetings FIT&GAP Final Update WORKLOG。 |
| [phases/PHASE_MEETINGS_FIT_AND_GAP_FINAL_UPDATE_REPORT.md](process/phases/PHASE_MEETINGS_FIT_AND_GAP_FINAL_UPDATE_REPORT.md) | Meetings FIT&GAP Final Update REPORT。 |
| [phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_PLAN.md](process/phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_PLAN.md) | Meetings 例会マスタ作成 Fit & Gap 調査 PLAN（実装なし）。 |
| [phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_WORKLOG.md](process/phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_REPORT.md](process/phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_CREATE_IMPLEMENT_PLAN.md](process/phases/PHASE_MEETINGS_CREATE_IMPLEMENT_PLAN.md) | Meetings 新規作成（POST / 一覧 Dialog）実装 PLAN。 |
| [phases/PHASE_MEETINGS_CREATE_IMPLEMENT_WORKLOG.md](process/phases/PHASE_MEETINGS_CREATE_IMPLEMENT_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_CREATE_IMPLEMENT_REPORT.md](process/phases/PHASE_MEETINGS_CREATE_IMPLEMENT_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_UPDATE_IMPLEMENT_PLAN.md](process/phases/PHASE_MEETINGS_UPDATE_IMPLEMENT_PLAN.md) | Meetings 更新（PATCH・一覧編集 Dialog）実装 PLAN。 |
| [phases/PHASE_MEETINGS_UPDATE_IMPLEMENT_WORKLOG.md](process/phases/PHASE_MEETINGS_UPDATE_IMPLEMENT_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_UPDATE_IMPLEMENT_REPORT.md](process/phases/PHASE_MEETINGS_UPDATE_IMPLEMENT_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_PLAN.md](process/phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_PLAN.md) | Meetings 削除 Fit & Gap / ポリシー整理 PLAN（docs のみ）。 |
| [phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_WORKLOG.md](process/phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_REPORT.md](process/phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_PLAN.md) | Meetings 参加者PDF取込 要件整理 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_WORKLOG.md) | Meetings 参加者PDF取込 要件整理 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_REPORT.md) | Meetings 参加者PDF取込 要件整理 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_PLAN.md) | Phase M7-P1: Meetings 参加者PDFアップロード PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_WORKLOG.md) | Phase M7-P1: 参加者PDFアップロード WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_REPORT.md) | Phase M7-P1: 参加者PDFアップロード REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_INVESTIGATION_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_INVESTIGATION_PLAN.md) | M7-P1 参加者PDF登録ダイアログ「ファイル選択が開かない」事象 調査 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_INVESTIGATION_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_INVESTIGATION_WORKLOG.md) | 同上 調査 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_INVESTIGATION_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_INVESTIGATION_REPORT.md) | 同上 調査 REPORT（原因・最小修正方針・次アクション）。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_PLAN.md) | M7-P1 参加者PDF登録ダイアログ「ファイル選択が開かない」修正 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_WORKLOG.md) | 同上 修正 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_REPORT.md) | 同上 修正 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_LIST_INDICATOR_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_LIST_INDICATOR_PLAN.md) | M7-P1 一覧に参加者PDF有無表示 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_LIST_INDICATOR_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_LIST_INDICATOR_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_LIST_INDICATOR_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_LIST_INDICATOR_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_SSOT_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_SSOT_PLAN.md) | M7-P1-SSOT: 参加者PDF列の仕様反映 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_SSOT_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_SSOT_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_SSOT_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_SSOT_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_PLAN.md) | M7-P1-FILTER: 参加者PDFあり/なしフィルタ PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UX_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UX_PLAN.md) | M7-P1-UX: PDF状態の視認性改善 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UX_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UX_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UX_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UX_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_PREP_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_PREP_PLAN.md) | M7-P2-PREP: PDF解析のための基盤準備 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_PREP_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_PREP_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_PREP_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_PREP_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_DESIGN_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_DESIGN_PLAN.md) | M7-P2-DESIGN: PDF解析・参加者抽出 設計 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_DESIGN_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_DESIGN_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_DESIGN_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_DESIGN_REPORT.md) | 同上 REPORT。 |
| [design/MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md](design/MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md) | Meetings 参加者PDF P2: PDF解析・参加者抽出 設計（実装なし）。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_PLAN.md) | M7-P2-IMPLEMENT-1: PDFテキスト抽出と解析結果保存 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_PLAN.md) | M7-P2-IMPLEMENT-2: PDF解析候補表示UI PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_PLAN.md) | M7-P3-IMPLEMENT-1: 候補確認・修正UI PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_PLAN.md) | M7-P3-IMPLEMENT-2: 候補を participants に反映する確定フロー PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P4_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P4_PLAN.md) | M7-P4: member 照合と反映前確認の強化 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P4_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P4_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P4_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P4_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P5_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P5_PLAN.md) | M7-P5: 手動マッチングUI PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P5_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P5_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P5_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P5_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_PLAN.md) | M7-P6: 反映履歴の記録 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P7_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P7_PLAN.md) | M7-P7: 内容ベースのページ判定（ignore / members / participants）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P7_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P7_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P7_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P7_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P8_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P8_PLAN.md) | M7-P8: participants / members 専用パーサ強化 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P8_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P8_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P8_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P8_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P9_INVESTIGATION_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P9_INVESTIGATION_REPORT.md) | M7-P9-INVESTIGATION: 解析結果クリア機能の調査 REPORT（実装なし）。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_PLAN.md) | M7-P10: 再解析導線の追加（UI中心）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_PLAN.md) | M7-P11-REQUIREMENTS: ChatGPT作成CSVアップロード連携 要件整理 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_PLAN.md) | M7-C2: 参加者CSVプレビュー PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_WORKLOG.md) | M7-C2: 参加者CSVプレビュー WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_REPORT.md) | M7-C2: 参加者CSVプレビュー REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C3_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C3_PLAN.md) | M7-C3: 参加者CSVを participants/members に反映 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C3_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C3_WORKLOG.md) | M7-C3: 参加者CSV反映 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C3_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C3_REPORT.md) | M7-C3: 参加者CSV反映 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_PLAN.md) | M7-C4-REQUIREMENTS: participants 差分更新 要件整理 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_WORKLOG.md) | M7-C4-REQUIREMENTS: participants 差分更新 要件整理 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_REPORT.md) | M7-C4-REQUIREMENTS: participants 差分更新 要件整理 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_PLAN.md) | M7-C4.5-REQUIREMENTS: participants 差分更新 + members 更新 + Role History 連携 要件整理 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_WORKLOG.md) | M7-C4.5-REQUIREMENTS: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_REPORT.md) | M7-C4.5-REQUIREMENTS: 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_PLAN.md) | M7-M1: participants 差分更新（BO保護あり）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_WORKLOG.md) | M7-M1: participants 差分更新 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_REPORT.md) | M7-M1: participants 差分更新 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_PLAN.md) | M7-M2: members 基本情報更新候補プレビュー PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_WORKLOG.md) | M7-M2: members 基本情報更新候補 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_REPORT.md) | M7-M2: members 基本情報更新候補 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_PLAN.md) | M7-M3: members 基本情報の確定反映 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_WORKLOG.md) | M7-M3: members 基本情報の確定反映 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_REPORT.md) | M7-M3: members 基本情報の確定反映 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_PLAN.md) | M7-M4: Role History 差分検知（role-diff-preview・表示のみ）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_WORKLOG.md) | M7-M4: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_REPORT.md) | M7-M4: 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_PLAN.md) | M7-M5（M5）: Role History の確定反映（role-apply）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_WORKLOG.md) | M7-M5: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_REPORT.md) | M7-M5: 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_AUDIT_AND_EFFECTIVE_DATE_M6_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_AUDIT_AND_EFFECTIVE_DATE_M6_PLAN.md) | M7-M6（M6）: CSV反映監査ログ・Role基準日 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_AUDIT_AND_EFFECTIVE_DATE_M6_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_AUDIT_AND_EFFECTIVE_DATE_M6_WORKLOG.md) | M7-M6: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_AUDIT_AND_EFFECTIVE_DATE_M6_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_AUDIT_AND_EFFECTIVE_DATE_M6_REPORT.md) | M7-M6: 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_PLAN.md) | D2: participants 差分プレビューUI（名前解決ベース）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_WORKLOG.md) | D2: 差分プレビューUI WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_REPORT.md) | D2: 差分プレビューUI REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_PLAN.md) | D3: 削除候補 + BO保護付き削除オプション PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_WORKLOG.md) | D3: 削除候補 + BO保護付き削除オプション WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_REPORT.md) | D3: 削除候補 + BO保護付き削除オプション REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_PLAN.md) | M7-M7: CSV 未解決データのガイド付き解決フロー PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_WORKLOG.md) | M7-M7: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_REPORT.md) | M7-M7: 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_PLAN.md) | M7-FINAL-CHECK: CSV 同期フロー最終確認（横断レビュー）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_WORKLOG.md) | M7-FINAL-CHECK: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_REPORT.md) | M7-FINAL-CHECK: 同上 REPORT（14 観点の結果）。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_SUGGESTION_M8_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_SUGGESTION_M8_PLAN.md) | M8: CSV 未解決向けあいまい一致候補（suggestions API・UI）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_SUGGESTION_M8_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_SUGGESTION_M8_WORKLOG.md) | M8: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_SUGGESTION_M8_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_SUGGESTION_M8_REPORT.md) | M8: 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_PLAN.md) | M8.5: CSV member 解決順（resolution→名前）の preview/apply 統一 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_WORKLOG.md) | M8.5: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_REPORT.md) | M8.5: 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_MANAGEMENT_M9_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_MANAGEMENT_M9_PLAN.md) | M9: resolution 管理UI強化 + 同名member警告 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_MANAGEMENT_M9_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_MANAGEMENT_M9_WORKLOG.md) | M9: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_MANAGEMENT_M9_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_MANAGEMENT_M9_REPORT.md) | M9: 同上 REPORT。 |
| [phases/PHASE_M5_MEMBERS_FLAG_EDIT_PLAN.md](process/phases/PHASE_M5_MEMBERS_FLAG_EDIT_PLAN.md) | Phase M-5: Members フラグ編集（Interested / Want 1on1）PLAN。 |
| [phases/PHASE_M5_MEMBERS_FLAG_EDIT_WORKLOG.md](process/phases/PHASE_M5_MEMBERS_FLAG_EDIT_WORKLOG.md) | Phase M-5: Members フラグ編集 WORKLOG。 |
| [phases/PHASE_M5_MEMBERS_FLAG_EDIT_REPORT.md](process/phases/PHASE_M5_MEMBERS_FLAG_EDIT_REPORT.md) | Phase M-5: Members フラグ編集 REPORT。 |
| [phases/PHASE_M6_MEMBER_SHOW_PLAN.md](process/phases/PHASE_M6_MEMBER_SHOW_PLAN.md) | Phase M-6: Member Show / Drawer 履歴強化 PLAN。 |
| [phases/PHASE_M6_MEMBER_SHOW_WORKLOG.md](process/phases/PHASE_M6_MEMBER_SHOW_WORKLOG.md) | Phase M-6: Member Show / Drawer 履歴強化 WORKLOG。 |
| [phases/PHASE_M6_MEMBER_SHOW_REPORT.md](process/phases/PHASE_M6_MEMBER_SHOW_REPORT.md) | Phase M-6: Member Show / Drawer 履歴強化 REPORT。 |
| [phases/PHASE_MEMBERS_CSV_IMPORT_200_PLAN.md](process/phases/PHASE_MEMBERS_CSV_IMPORT_200_PLAN.md) | Phase Members CSV Import 200: 第200回参加者CSV 汎用コマンド PLAN。 |
| [phases/PHASE_MEMBERS_CSV_IMPORT_200_WORKLOG.md](process/phases/PHASE_MEMBERS_CSV_IMPORT_200_WORKLOG.md) | Phase Members CSV Import 200 WORKLOG。 |
| [phases/PHASE_MEMBERS_CSV_IMPORT_200_REPORT.md](process/phases/PHASE_MEMBERS_CSV_IMPORT_200_REPORT.md) | Phase Members CSV Import 200 REPORT。 |
| [phases/PHASE_DASHBOARD_MOCK_ALIGN_PLAN.md](process/phases/PHASE_DASHBOARD_MOCK_ALIGN_PLAN.md) | Phase D: Dashboard モック一致 PLAN。 |
| [phases/PHASE_DASHBOARD_MOCK_ALIGN_WORKLOG.md](process/phases/PHASE_DASHBOARD_MOCK_ALIGN_WORKLOG.md) | Phase D: Dashboard モック一致 WORKLOG。 |
| [phases/PHASE_DASHBOARD_MOCK_ALIGN_REPORT.md](process/phases/PHASE_DASHBOARD_MOCK_ALIGN_REPORT.md) | Phase D: Dashboard モック一致 REPORT。 |
| [phases/PHASE_RELIGO_SIDEBAR_MOCK_ALIGN_PLAN.md](process/phases/PHASE_RELIGO_SIDEBAR_MOCK_ALIGN_PLAN.md) | Phase 1: Religo Sidebar モック準拠化 PLAN。 |
| [phases/PHASE_RELIGO_SIDEBAR_MOCK_ALIGN_WORKLOG.md](process/phases/PHASE_RELIGO_SIDEBAR_MOCK_ALIGN_WORKLOG.md) | Phase 1: Religo Sidebar モック準拠化 WORKLOG。 |
| [phases/PHASE_RELIGO_SIDEBAR_MOCK_ALIGN_REPORT.md](process/phases/PHASE_RELIGO_SIDEBAR_MOCK_ALIGN_REPORT.md) | Phase 1: Religo Sidebar モック準拠化 REPORT。 |
| [phases/PHASE_RELIGO_APPBAR_MOCK_ALIGN_PLAN.md](process/phases/PHASE_RELIGO_APPBAR_MOCK_ALIGN_PLAN.md) | Phase 2: Religo AppBar モック準拠化 PLAN。 |
| [phases/PHASE_RELIGO_APPBAR_MOCK_ALIGN_WORKLOG.md](process/phases/PHASE_RELIGO_APPBAR_MOCK_ALIGN_WORKLOG.md) | Phase 2: Religo AppBar モック準拠化 WORKLOG。 |
| [phases/PHASE_RELIGO_APPBAR_MOCK_ALIGN_REPORT.md](process/phases/PHASE_RELIGO_APPBAR_MOCK_ALIGN_REPORT.md) | Phase 2: Religo AppBar モック準拠化 REPORT。 |
| [phases/PHASE_E1_DASHBOARD_API_WORKLOG.md](process/phases/PHASE_E1_DASHBOARD_API_WORKLOG.md) | Phase E-1: Dashboard API 動的化 WORKLOG。 |
| [phases/PHASE_E1_DASHBOARD_API_REPORT.md](process/phases/PHASE_E1_DASHBOARD_API_REPORT.md) | Phase E-1: Dashboard API 動的化 REPORT。 |
| [phases/PHASE_E4_OWNER_SETTINGS_PLAN.md](process/phases/PHASE_E4_OWNER_SETTINGS_PLAN.md) | Phase E-4: Owner 設定（永続化）PLAN。 |
| [phases/PHASE_E4_OWNER_SETTINGS_WORKLOG.md](process/phases/PHASE_E4_OWNER_SETTINGS_WORKLOG.md) | Phase E-4: Owner 設定 WORKLOG。 |
| [phases/PHASE_E4_OWNER_SETTINGS_REPORT.md](process/phases/PHASE_E4_OWNER_SETTINGS_REPORT.md) | Phase E-4: Owner 設定 REPORT。 |
| [phases/PHASE_C1_CONNECTIONS_LAYOUT_REPORT.md](process/phases/PHASE_C1_CONNECTIONS_LAYOUT_REPORT.md) | Phase C-1: Connections レイアウト REPORT。 |
| [phases/PHASE_C2_CONNECTIONS_MEMBERS_REPORT.md](process/phases/PHASE_C2_CONNECTIONS_MEMBERS_REPORT.md) | Phase C-2: Connections Members ペイン REPORT。 |
| [phases/PHASE_C3_CONNECTIONS_MEETING_BO_REPORT.md](process/phases/PHASE_C3_CONNECTIONS_MEETING_BO_REPORT.md) | Phase C-3: Connections Meeting + BO REPORT。 |
| [phases/PHASE_C4_CONNECTIONS_RELATIONSHIP_LOG_REPORT.md](process/phases/PHASE_C4_CONNECTIONS_RELATIONSHIP_LOG_REPORT.md) | Phase C-4: Connections Relationship Log REPORT。 |
| [phases/PHASE_C6_CONNECTIONS_INTELLIGENCE_PLAN.md](process/phases/PHASE_C6_CONNECTIONS_INTELLIGENCE_PLAN.md) | Phase C-6: Connections Intelligence（Relationship Summary / Next Action）PLAN。 |
| [phases/PHASE_C6_CONNECTIONS_INTELLIGENCE_WORKLOG.md](process/phases/PHASE_C6_CONNECTIONS_INTELLIGENCE_WORKLOG.md) | Phase C-6: Connections Intelligence WORKLOG。 |
| [phases/PHASE_C6_CONNECTIONS_INTELLIGENCE_REPORT.md](process/phases/PHASE_C6_CONNECTIONS_INTELLIGENCE_REPORT.md) | Phase C-6: Connections Intelligence REPORT。 |
| [phases/PHASE_C7_RELATIONSHIP_SCORE_PLAN.md](process/phases/PHASE_C7_RELATIONSHIP_SCORE_PLAN.md) | Phase C-7: Relationship Score PLAN。 |
| [phases/PHASE_C7_RELATIONSHIP_SCORE_WORKLOG.md](process/phases/PHASE_C7_RELATIONSHIP_SCORE_WORKLOG.md) | Phase C-7: Relationship Score WORKLOG。 |
| [phases/PHASE_C7_RELATIONSHIP_SCORE_REPORT.md](process/phases/PHASE_C7_RELATIONSHIP_SCORE_REPORT.md) | Phase C-7: Relationship Score REPORT。 |
| [phases/PHASE_C8_INTRODUCTION_HINT_PLAN.md](process/phases/PHASE_C8_INTRODUCTION_HINT_PLAN.md) | Phase C-8: Introduction Hint PLAN。 |
| [phases/PHASE_C8_INTRODUCTION_HINT_WORKLOG.md](process/phases/PHASE_C8_INTRODUCTION_HINT_WORKLOG.md) | Phase C-8: Introduction Hint WORKLOG。 |
| [phases/PHASE_C8_INTRODUCTION_HINT_REPORT.md](process/phases/PHASE_C8_INTRODUCTION_HINT_REPORT.md) | Phase C-8: Introduction Hint REPORT。 |

### BNI 活動戦略（docs/strategy/networking/）

|| ファイル | 説明 |
||----------|------|
|| [BNI_DragonFly_Guest_Strategy_202603.md](strategy/networking/BNI_DragonFly_Guest_Strategy_202603.md) | BNI DragonFly ゲスト招待戦略（2026/03）。 |
|| [BNI_DragonFly_Joining_Speeches_202603.md](strategy/networking/BNI_DragonFly_Joining_Speeches_202603.md) | BNI 入会スピーチ集（25秒プレゼン・朝礼・例会・選んだ理由・tugilo思想）。2026/03 入会時確定版。 |
|| [BNI_Tugilo_Usage_Strategy.md](strategy/networking/BNI_Tugilo_Usage_Strategy.md) | **tugilo 今後のBNI活用方針:** BNIを困りごと・入口・商品導線のPDCAラボとして使う運用方針。Track C（診断→PoC→伴走）/ Track P（月額クラウド）・**CAL/tugical予約はBNIフロントカテゴリ候補**（自社導線・再来店・失客防止・集客パワーチームの予約基盤）・小中さんカテゴリ棲み分け・週次運用・121確認事項。Track P 商品SSOTは [tugilo Cloud モジュールカタログ](../../tugilo_site/www/tugilo_site/docs/business/tugilo_cloud_module_catalog.md)（tugilo_site）。 |
|| [BNI_Tsugihiro_Atsushi_Intro_Living_Document.md](strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md) | **次廣淳（tugilo）常設:** 冒頭 **提示用サマリー**・**§12 DragonFly Instagramアンケート回答案**・**§11 BNI特化BM（小中モデル参照・Track P/C・予約管理思想・フロントカテゴリ候補）**・BO・25秒WP（**§2.5 症状型**）・**§10 BNI活用**（入口設計・実験サイクル・1本化モデル）・**§8 121**・**§9 人間×AI**・変更ログ。 |

### BNI DragonFly（docs/networking/bni/dragonfly/）

| ファイル | 説明 |
|----------|------|
| [REQUIREMENTS_MEMBER_PARTICIPANTS.md](networking/bni/dragonfly/REQUIREMENTS_MEMBER_PARTICIPANTS.md) | メンバーマスター・参加者・ブレイクアウトメモの要件定義。 |
| [REQUIREMENTS_MEMBERS_CSV_200.md](networking/bni/dragonfly/REQUIREMENTS_MEMBERS_CSV_200.md) | 第200回メンバー表 CSV（dragonfly_59people.csv）の要件整理。関連 SSOT・実装・種別対応・DoD 案。 |
| [STATUS_MVP_199.md](networking/bni/dragonfly/STATUS_MVP_199.md) | 第199回 MVP の完了範囲・未実装・技術的注意点。 |
| [api/DRAGONFLY_MVP_API_GUIDE.md](networking/bni/dragonfly/api/DRAGONFLY_MVP_API_GUIDE.md) | DragonFly MVP API のエンドポイント・curl 例・レスポンス・エラー仕様。 |
| [breakout/DRAGONFLY_BREAKOUT_SEEDING_POLICY_20260303.md](networking/bni/dragonfly/breakout/DRAGONFLY_BREAKOUT_SEEDING_POLICY_20260303.md) | 第199回ブレイクアウトの暫定割当ルールと冪等性・正式割当反映手順。 |

### 実装設計（docs/design/）

| ファイル | 説明 |
|----------|------|
| [bni/dragonfly/BNI_MEMBER_PARTICIPANTS_IMPLEMENTATION_DESIGN.md](design/bni/dragonfly/BNI_MEMBER_PARTICIPANTS_IMPLEMENTATION_DESIGN.md) | メンバー・参加者管理のDB設計・リレーション・実装順序。 |
| [dragonfly/DRAGONFLY_DATA_MODEL_V1.md](design/dragonfly/DRAGONFLY_DATA_MODEL_V1.md) | DragonFly SPA 用データモデル v1.1（恒久フラグ・理由ログ、ハイブリッドフラグ、1on1 履歴、既存スキーマとの住み分け）。 |
| [dragonfly/DRAGONFLY_API_DESIGN_V1.md](design/dragonfly/DRAGONFLY_API_DESIGN_V1.md) | DragonFly SPA 用 API 設計 v1（flags / contact events / 1on1 sessions / summary）。 |
| [dragonfly/DRAGONFLY_MIGRATION_PLAN_V1.md](design/dragonfly/DRAGONFLY_MIGRATION_PLAN_V1.md) | DragonFly 新規テーブル Migration 計画 v1（contact_flags / contact_events / one_on_one_sessions）。 |
| [dragonfly/DRAGONFLY_REACT_ADMIN_ARCHITECTURE_V1.md](design/dragonfly/DRAGONFLY_REACT_ADMIN_ARCHITECTURE_V1.md) | DragonFly ReactAdmin 構成設計 v1（Resources / DragonFlyBoard 3 ペイン / DataProvider / 状態管理）。 |

### 決定事項（docs/decisions/）

| ファイル | 説明 |
|----------|------|
| [dragonfly/DRAGONFLY_DECISIONS_V1.md](decisions/dragonfly/DRAGONFLY_DECISIONS_V1.md) | DragonFly V1 未決事項の確定（D-01〜D-08: owner の渡し方、extra_status、1on1 自動ON、contact_events、FK、URL、Summary 責務）。 |

### 要件（docs/requirements/）

| ファイル | 説明 |
|----------|------|
| [dragonfly/DRAGONFLY_SPA_REQUIREMENTS_V1.md](requirements/dragonfly/DRAGONFLY_SPA_REQUIREMENTS_V1.md) | DragonFly SPA（Laravel API + ReactAdmin + MUI）の SSOT 要件書 v1（1on1 候補・1on1 履歴含む）。 |
| [myria_mu_exterior_referral_system_requirements.md](requirements/myria_mu_exterior_referral_system_requirements.md) | **Myria-mu 外構紹介管理プラットフォーム 要件定義書**。インフルエンサー・顧客・Myria-mu担当者・施工店の業務要件として、ペルソナ、業務フロー、機能要件、データ要件、権限要件、非機能要件、スコープ、スコープ外を整理。施工店ステータス、案件履歴、施工店評価を集計可能にする構造、イラスト制作管理、施工店対応エリア、NPS相当アンケート項目を定義。 |
| [printing_order_management_system_requirements.md](requirements/printing_order_management_system_requirements.md) | **印刷業向け** 受発注・見積・請求の Web 統合。As-Is / To-Be、必須機能、MVP・段階案（A/B/C）、補助金・パッケージ化、tugilo 原則（提案・Fit&Gap のベース）。 |
| [printing_excel_vba_fit_gap_report.md](requirements/printing_excel_vba_fit_gap_report.md) | **印刷業向け既存 Excel/VBA 調査**（4 ブック実解析）。シート・VBA 構成、業務ロジック、連携、Fit&Gap 表、DB 候補、120 万円 MVP スコープ、提案書要点。 |
| [printing_order_management_system_requirements_final.md](requirements/printing_order_management_system_requirements_final.md) | **印刷業向け要件整理 正規版**（提案書前段）。良い点→課題→リスク→目的→解決方針、必須要件、初期スコープ／除外、補助金観点、ヒアリング一覧。 |
