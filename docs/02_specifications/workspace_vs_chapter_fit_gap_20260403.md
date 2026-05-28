# Workspace と Chapter の関係 — Fit & Gap 調査（2026-04-03）

**種別:** 調査メモ（SSOT の代替ではない。次 Phase の意思決定用）  
**関連:** [DATA_MODEL.md](../SSOT/DATA_MODEL.md)、[WORKSPACE_RESOLUTION_POLICY.md](../SSOT/WORKSPACE_RESOLUTION_POLICY.md)、[MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md](../SSOT/MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md)、[USER_ME_AND_ACTOR_RESOLUTION.md](../SSOT/USER_ME_AND_ACTOR_RESOLUTION.md)、[ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md](../SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md)  
**記録:** Phase **WORKSPACE_CHAPTER_FIT_GAP_P1**（PLAN / WORKLOG / REPORT）

---

## 0. 確定業務ルール（本調査の前提）

以下は **業務ルール**として本ドキュメント全体の前提とする（実装の有無とは別）。

1. **Chapter は業務上の正式な所属単位**である。
2. **Member は 1 つの Chapter にのみ所属する。** 複数 Chapter 兼務は **現スコープでは認めない**。
3. **workspace は chapter と常に同義ではない。** workspace はシステム上のコンテキスト概念として残りうる。chapter は業務概念として正式に扱う。
4. **Country > Region > Chapter** の階層は今後も前提とする（Region は Country 配下、Chapter は Region 配下として説明可能な形）。

### 0.1 定義（明文化）

本プロダクトにおいて、**Member の正式所属先は Chapter** とする。**Member は 1 つの Chapter にのみ所属でき、複数 Chapter 兼務は現スコープでは扱わない。**  
Country / Region は **Chapter を通じて解決される所属階層**であり、Member が **所属として** Country や Region を複数持つことは前提にしない（参照・検索・表示のための階層は Chapter 経由で辿るのが基本）。

**補足:** 国・リージョン・チャプターを**横断した名簿の検索・参照**は可能だが、それは **「検索・参照範囲が広い」**ことを意味し、**Member の所属が複数になる**ことを意味しない。所属の複雑化と、データ閲覧範囲の拡張は **混同しない**。

---

## 1. 背景

### 1.1 なぜ `workspace = chapter` の固定が危険か

- **workspace** はソフトウェア一般語として「作業・権限・データ境界のコンテキスト」を指しうる。マルチテナント製品では **テナント**や**組織単位**と混同されやすい。
- **chapter** は BNI 固有の業務概念（会員が所属する会の単位）であり、**国・リージョン・チャプター**の階層と結びついて説明される。
- 現行リポジトリでは **`workspaces` テーブル 1 行を「チャプター相当」として運用**してきたが、テーブル名・API 名が **業務語と 1:1 で固定**されていると、将来「workspace = テナント（Religo 全体）」「chapter = BNI 会」など**概念を分離したくなったときにリネーム・移行コストが爆発**する。

### 1.2 なぜ Chapter を正式概念として持ちたいか

- 業務・教育・オンボーディングでは **日本 → 東京NEリージョン → DragonFly チャプター** のような説明が自然。
- **Member の所属単位を業務上明快にするため** — 所属の正は **Chapter** とし、SSOT・UI・API の読み手が毎回「これはチャプターか workspace か」と推測しないようにする。
- 既に DB には **Country > Region > Workspace（葉がチャプター相当のマスタ行）** の土台が入りつつある（`countries`, `regions`, `workspaces.region_id`）。**「workspace」という語がチャプターと同義かどうか**を揃えないと、SSOT・UI・API の読み手が毎回推測する。

---

## 2. 調査対象

### 2.1 読んだ SSOT（主要）

| ドキュメント | 要点 |
|--------------|------|
| DATA_MODEL.md | チャプター ≒ workspace、User 1 = 1 workspace、§5.1 スコープ |
| WORKSPACE_RESOLUTION_POLICY.md | **1 チャプター = 1 workspaces 行**を明示 |
| MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md | **members.workspace_id = チャプター相当の workspace** |
| USER_ME_AND_ACTOR_RESOLUTION.md | **chapter と workspaces は 1:1 対応を運用前提**と明記 |
| ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md | `one_to_ones.workspace_id` = 記録コンテキスト（解釈 A） |
| DASHBOARD_DATA_SSOT.md / DASHBOARD_TASK_SOURCE_ANALYSIS.md | Dashboard と `MemberSummaryQuery` の workspace 引数 |
| DASHBOARD_ONETOONE_LEADS_REQUIREMENTS.md（SPEC-005） | リード候補（guest/visitor）— workspace 名より type 依存 |

### 2.2 確認した実装・ファイル（grep / 読了）

**DB / Migration**

- `create_workspaces_table`, `add_workspace_id_to_members_table`, `create_one_to_ones_table`, `add_workspace_id_to_contact_memos_introductions_flags`, `add_default_workspace_id_to_users_table`, `create_bo_assignment_audit_logs_table`, `create_countries_regions_add_region_id_to_workspaces`

**Backend（workspace 文字列・カラム参照の多い順）**

- `ReligoActorContext`, `UserController`, `MemberSummaryQuery`, `OneToOneIndexService`, `MemberWorkspaceBackfillService`, `DragonFlyMemberController`, `WorkspaceController`, `DashboardService`, `BoAssignmentAuditLogWriter`, `StoreOneToOneRequest`, 各 Model（`Workspace`, `Member`, `OneToOne`, `User`, `ContactMemo`, …）

**Frontend**

- `ReligoSettings.jsx`（所属チャプター表記・`GET /api/workspaces`）, `ReligoOwnerContext.jsx`, `dataProvider.js`, `OneToOnesCreate.jsx` / `OneToOnesList.jsx`（Quick Create の workspaceId）, `Dashboard.jsx`, `MembersList.jsx`, `memberDisplay.js`, `app.jsx` / CustomAppBar（所属表示）

### 2.3 grep 観点

- `workspace` / `workspace_id` / `default_workspace_id` を `www/` 配下の `.php` / `.jsx` / `.js` で検索し、上記に分類。

---

## 3. 現状整理

### 3.1 Member と Chapter（As-Is の位置づけ）

- **`members` は単一メンバーマスタ**として扱われ、**1 行あたりの正式な所属は 1 つの Chapter に対応する `workspace_id`（現行）**で表現されている（業務ルール上も **1 Member : 1 Chapter**）。
- **複数 Chapter 兼務**は **現スコープでは業務上認めない**ため、**多所属用のスキーマは不要**という前提で Fit & Gap を読む。
- Country / Region は **Chapter（現行では `workspaces` 行＋`region_id`）経由**で説明するのが自然であり、Member が **所属として** Region を複数持つ想定はしない。

### 3.2 用語の意味（4 層）

| 層 | workspace の意味 |
|----|------------------|
| **業務（BNI）** | 所属の正は **Chapter**。UI では「所属チャプター」と説明されることが多い。 |
| **SSOT** | **「1 チャプター = 1 workspaces 行」**、**members / users の所属はその行**と明記されている箇所が多い。 |
| **コード** | 物理 FK はすべて **`workspaces.id`**。名前は歴史的に `Workspace` モデル・`GET /api/workspaces`。 |
| **UI** | **「所属チャプター」** と表示し、選択肢は workspace 一覧（`ReligoSettings.jsx` のコメント・文言）。 |

### 3.3 DB: `workspace_id` を持つテーブル（As-Is）

| テーブル | 役割（実装コメント・SSOT ベース） |
|----------|-------------------------------------|
| **users.default_workspace_id** | ログインユーザーの **所属チャプター**（意味論） |
| **members.workspace_id** | メンバーの **所属 Chapter に相当する workspace 行**（**1:1**） |
| **one_to_ones.workspace_id** | **記録コンテキスト**（通常オーナー側チャプター; SPEC-006）。**所属とは別概念**になりうる。 |
| **contact_memos.workspace_id** | 関係データのスコープ列（§5.1 OR NULL 規則） |
| **dragonfly_contact_flags.workspace_id** | 同上 |
| **introductions** | migration で **workspace_id 追加**（DATA_MODEL 参照） |
| **bo_assignment_audit_logs.workspace_id** | 監査の文脈（`ReligoActorContext` 解決値） |

### 3.4 階層（Country / Region / Chapter）

- **2026-04 時点:** `countries` → `regions` → `workspaces.region_id` が存在。**Chapter に相当する葉のマスタ行は現状 `workspaces`**。
- **API:** `MemberWorkspaceAttributes` 等で **workspace_name / region / country** をフラット返却。**「chapter」というキー名は未使用**（`workspace_name` がチャプター名相当）。

### 3.5 `workspace = chapter` と読める箇所（明示的）

- [WORKSPACE_RESOLUTION_POLICY.md](../SSOT/WORKSPACE_RESOLUTION_POLICY.md): 「**1 チャプター = 1 workspaces 行**」
- [USER_ME_AND_ACTOR_RESOLUTION.md](../SSOT/USER_ME_AND_ACTOR_RESOLUTION.md): 「**chapter（DragonFly チャプター名）と DB 上の workspaces は 1:1 対応を運用前提**」
- [MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md](../SSOT/MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md): **members.workspace_id = BNI チャプター相当の workspace**
- `ReligoSettings.jsx` コメント: **所属チャプター（workspace）設定**

### 3.6 `workspace` がチャプター以外の意味でも使われうる箇所

| 観点 | 内容 |
|------|------|
| **DATA_MODEL 原文** | workspace は「**会／チャプターやプロジェクト単位**」とあり、**理論上は chapter 以外のコンテキスト**も載せうる（現行 BNI 運用ではチャプターに寄せている）。 |
| **one_to_ones.workspace_id** | **記録コンテキスト** — 所属とは別（クロスチャプター 1to1 等）。**Member の所属多様化とは無関係**。 |
| **MemberSummaryQuery** | `workspace_id` は **クエリスコープ用**（所属チャプターに紐づく legacy 行の OR NULL）。「表示スコープ」としての workspace。 |
| **将来マルチテナント** | DATA_MODEL に **multi-workspace** の記述あり。**workspace = テナント**の別製品では `workspaces` 名が衝突しうる（現状スコープ外）。 |

---

## 4. 問題点

| # | 内容 |
|---|------|
| P1 | **同一語 `workspace` が「所属チャプター」「記録コンテキスト」「クエリスコープ」「監査文脈」**に跨る。 |
| P2 | SSOT 上 **chapter と workspaces の 1:1** が強く、**Country/Region 導入後**は「チャプター = workspaces 行」は成り立つが**用語として chapter が DB に無い**。 |
| P3 | UI は **チャプター**と表示し API は **workspaces** — 学習コストとドキュメント重複。 |
| P4 | **Member の所属概念を業務上「Chapter」として固定し、システム上の `workspace` 語と揃えたい**一方、**workspace が所属以外の意味（記録コンテキスト等）にも使われている**ため、読み手が混線しうる。 |
| P5 | **名簿・検索の横断**と **Member の複数 Chapter 所属**を混同しうる — 業務ルール上 **複数兼務は認めない**ため、後者は設計対象外。前者は「閲覧・検索範囲」の話。 |

---

## 5. To-Be 案（比較）— Member 単一 Chapter 所属との相性

**前提:** Member は **常に 1 Chapter にのみ所属**。多所属用スキーマは要らない。むしろ **所属が単一**だからこそ、**Chapter を正式名義に寄せる移行**（案 B・C）や **将来の `chapter_id` 列名**が説明しやすい。

### 案 A: 既存 workspace を活かし、**chapter を新設**して意味を分離

- **`chapters` テーブル新設**（または **workspaces を改名・意味分割**する大移行）。
- **Member 単一所属との相性:** **高い** — `members` は **1 本の FK**（`chapter_id` 等）で足り、多所属を想定しないためモデルが単純。
- **長所:** 概念をコード上で分けられる。**短所:** FK の張り替え・移行 Phase が複数必要。

### 案 B: 現行 **workspace を段階的に chapter 相当へ寄せる**（読み替え・リネーム）

- **DB テーブル名は `workspaces` のまま**、SSOT・UI・API 応答キーに **`chapter_id` / `chapter` エイリアス**を足す、最終的に **`workspaces` → `chapters` リネーム**（またはビュー）。
- **Member 単一所属との相性:** **高い** — 既存の **1 列**の意味を「Chapter への所属」に寄せるだけでよく、**兼務のための追加テーブルは不要**。
- **長所:** 既存 FK を活かしつつ業務語に寄せられる。**短所:** 長期間「workspace = chapter」の二重表記が残る。

### 案 C（補助）: **用語のみ整理**（スキーマは現状維持）

- SSOT に **「本プロダクトでは workspaces の 1 行を BNI Chapter として扱う。Member の所属はその 1 行に対応する。workspace という語は歴史的名称」**と明記。
- **Member 単一所属との相性:** **最も即効** — スキーマ変更なしで業務ルールと整合する説明ができる。
- **長所:** 実装コスト最小。**短所:** 他プロダクトで workspace ≠ chapter になると再混乱。

---

## 6. Fit & Gap（表）

| 項目 | As-Is | To-Be（方向性） | Gap | 重さ | 備考 |
|------|--------|-----------------|-----|------|------|
| **Member → 所属** | `members.workspace_id`（nullable FK、**1 列で単一所属**） | 業務上の正は **Chapter**；列名は `chapter_id` または **「この列 = Chapter」**の明示 | 用語・SSOT・API キー；スキーマは **単一 FK のまま**移行しやすい | **中**（多所属が無いため **中〜大から一段下がる**） | **単一所属だからこそ** chapter 正式化の説明・移行がしやすい |
| **テーブル名** | `workspaces` | `chapters` または併存 | リネーム or 新設 + FK 移行 | **大** | 外部キー多数 |
| **users 所属** | `default_workspace_id` | `chapter_id` または意味固定の workspace | カラムエイリアス or migration | **中** | API 互換；**1 user = 1 chapter 前提**と整合 |
| **one_to_ones** | `workspace_id`（記録コンテキスト） | 明示名 `recording_context_id` 等 | 意味の SSOT 分離・必要なら列 | **中** | SPEC-006；**所属多様化とは無関係** |
| **MemberSummaryQuery** | `workspace_id` OR NULL | chapter 境界の明文化 | クエリ・変数名 | **中** | Dashboard 説明と一体 |
| **GET /api/workspaces** | 一覧 | `/api/chapters` エイリアス | ルート・ドキュメント | **小** | 後方互換で並走可 |
| **ReligoSettings** | workspace Select | ラベルのみ「チャプター」 | **済**（文言） / データソース名は gap | **小** | 既に「所属チャプター」 |
| **SSOT DATA_MODEL** | チャプター ≒ workspace | chapter 用語の正式定義 | 章立ての全面更新 | **大** | 依存 SSOT 連鎖 |
| **USER_ME** | `workspace_id` 解決 | `chapter_id` 応答 | キー名・クライアント | **中** | フロント一括 |
| **countries/regions** | `workspaces.region_id` | Chapter が workspace 行と 1:1 なら整合 | ほぼ **Fit** | **小** | 階層は **Country > Region > Chapter** で固定 |

---

## 7. 推奨方針（調査時点の提案）

### 7.1 今すぐやること（小さく始める）

1. **SSOT に「workspace（テーブル名）と BNI Chapter の関係」節を 1 ページ追加** — *本リポジトリでは現状 `workspaces.id` がチャプター単位のマスタである*、*Member の所属は 1 Chapter のみ*、*将来分離する場合の予約語は chapter*、と書く。
2. **USER_ME_AND_ACTOR_RESOLUTION の「1:1 対応を運用前提」**を、**「データモデル上は同一行を指すが、概念名は Chapter を正とする」**に言い換え案を用意（次 docs Phase）。
3. **API 後方互換を維持したまま**、`GET /api/workspaces` のレスポンスに **`kind: "chapter"`** のようなメタ（任意）を足すかどうか **だけ**検討（実装は別 Phase）。

### 7.2 後続 Phase に分けること

- **`chapters` 新設（案 A）** または **`workspaces` リネーム（案 B）** の migration 設計
- **`users` / `members` のカラム名**の段階移行（`default_chapter_id` 等）— **いずれも単一 FK でよい**
- **フロントの `workspace` 変数名**の一括整理（`resolvedChapterId` 等）

### 7.3 非推奨（現時点）

- **コード変更なしで「workspace をチャプターと呼ばない」**と運用だけ縛る — SSOT と実装の乖離が再発する。
- **Member の複数 Chapter 兼務用スキーマを先に用意する** — **現業務ルールと矛盾**するため、本 Fit & Gap の前提としない。

---

## 8. 次 Phase 候補

| Phase 名候補 | スコープ案 | DoD 案 |
|--------------|------------|--------|
| **WORKSPACE_CHAPTER_TERMINOLOGY_P1** | SSOT 用語統一 + INDEX + 開発者向け README 1 節；**Member 1 Chapter 専属**の明記 | DATA_MODEL / USER_ME SSOT に Chapter 定義 |
| **WORKSPACE_CHAPTER_API_ALIAS_P1** | `GET /api/chapters` = `workspaces` のエイリアス + 応答に `label` | テスト・INDEX・後方互換 |
| **CHAPTERS_TABLE_MIGRATION_P1** | `chapters` 新設と FK 移行設計のみ（実装スパイク）；**単一所属 FK のみ** | 設計書 + リスク一覧 |

**変更（2026-04-17 追記）:** 多所属対応 Phase は **候補から外す**（業務ルール上不要）。上記 3 本を維持。

---

## 9. 結論（3 段階）

| レベル | 内容 | 第一候補 |
|--------|------|----------|
| **小さく始める** | SSOT・UI 用語で **Chapter を正**、**workspace は DB 識別子**と明記。**Member は 1 Chapter 専属**を SSOT に書く。API は現状維持。 | **採用しやすい（即着手）** |
| **現実的な本命** | **案 B 寄り:** テーブルは `workspaces` のまま、**API・JSON では `chapter` キーを併記**し、クライアントを段階移行。**所属は 1 列のまま**。 | **中期的に第一候補** |
| **将来理想** | **案 A:** `chapters` を業務マスタとし、**workspace を「Religo テナント／スコープ」**に分離。**Member 所属は引き続き 1 Chapter のみ**。 | **大規模・権限設計とセット** |

**補強された論点:** Member が **複数 Chapter に所属しない**ため、**「所属の複雑化」ではなく「業務語 Chapter を正にする」**ことが設計の主題になる。**Chapter を正式概念として立てる意義はむしろ強い**（スキーマが単純なまま説明可能）。

**名簿・検索について:** 国・リージョン・チャプターを**横断してメンバーを探す**ことは、**閲覧・検索範囲の話**であり、**1 Member が複数 Chapter に所属する**こととは切り離す。

**今どこから着手するか:** **用語・SSOT の整理（小）** → **API エイリアスと応答メタ（中）** → **スキーマ分離（大）**の順が、既存運用・ONETOONES_CROSS_CHAPTER・countries/regions 追加との **衝突が最も少ない**。

---

## 10. 付録: workspace 依存の分類一覧

| 分類 | 例 |
|------|-----|
| **所属管理** | `users.default_workspace_id`, `members.workspace_id`（**各 1 本で単一 Chapter**） |
| **データ可視範囲** | `MemberSummaryQuery` の第 3 引数、`(workspace_id = X OR NULL)` |
| **1 to 1 記録コンテキスト** | `one_to_ones.workspace_id`（SPEC-006） |
| **Dashboard 集計** | 原則 workspace をクエリに付けない；stale は `null` |
| **オーナー選択** | Owner は member 軸；workspace は `/me` とは別 |
| **メンバー検索** | `IndexDragonFlyMembersRequest` の `workspace_id` クエリ（あれば） |
| **API 絞り込み** | 1 to 1 一覧 `workspace_id`, stats 同様 |
| **権限・表示制御** | 明示的 RBAC は薄い；**所属は settings** |
| **文言** | 「所属チャプター」、Settings のエラー「チャプターを選択」 |
| **DB 構造** | 全関係データに `workspace_id` 列が散在 |

---

## 11. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-04-03 | 初版（WORKSPACE_CHAPTER_FIT_GAP_P1） |
| 2026-04-17 | **業務ルール反映:** Member は **1 Chapter にのみ所属**（複数兼務は現スコープ外）。§0 追加、P4/P5・案の相性・Fit & Gap members 行・§7.3・§8・§9 を整合。検索範囲と複数所属の区別を明記。 |
