# リージョン・チャプターマスタとクロスチャプター 1to1 相手選択 — 要件（SSOT）

**Spec ID:** SPEC-021（[SSOT_REGISTRY.md](../02_specifications/SSOT_REGISTRY.md) 参照）  
**作成:** 2026-06-27 17:11 JST  
**ステータス:** draft（要件確定・実装未着手）  
**種別:** データマスタ / 1to1 UX 要件 SSOT

**関連 SSOT:** [SPEC-006 ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md](ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md)、[DATA_MODEL.md](DATA_MODEL.md) §4.0.1–4.1、[MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md](MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md)、[SPEC-020 ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md](ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md) §11（G17–G19）、[FIT_AND_GAP_REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1.md](FIT_AND_GAP_REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1.md)

---

## 1. 背景・課題

Religo は DragonFly チャプター内の PoC から、**東京 NE リージョン内の他チャプター**との 1to1 記録へ拡張する。全国の BNI チャプターをすべて事前登録するのは現実的でない一方、**東京 NE は合同例会・ビジター往来が多く、相手選択の母集団をリージョン単位で揃える価値**がある。

現状は `workspaces` に他チャプター名が **個別に ad-hoc 追加**されているが、`regions` は空、`region_id` は未設定。マスタ整備と 1to1 相手選択 UX の方針を先に文書化する。

---

## 2. 目的

| 目的 | 説明 |
|------|------|
| **マスタの正規化** | Country > Region > Workspace（チャプター）の階層を、運用可能な粒度で DB に持つ |
| **東京 NE を第一シード** | 公式一覧に基づき **25 チャプター**をリージョンマスタ配下に登録する |
| **全国は必要時のみ** | 東京 NE 以外は **手動 ad-hoc 登録**し、後から正規化・マージする |
| **1to1 相手選択** | デフォルトは自チャプター。必要に応じ **東京 NE 内の他チャプター**へ切替。それ以外は **手動追加** |

---

## 3. 確定方針（ユーザー合意・2026-06-27）

> テーブルで管理。全国様々なチャプターがあるが、全て登録するのは意味がない。まずリージョン・チャプターマスタを作成し、東京 NE リージョンの〜チャプターみたいに設定。東京 NE 以外は手動登録して後で正規化。

| ID | 方針 | 内容 |
|----|------|------|
| P1 | **全件事前登録しない** | 全国チャプターの網羅シードは行わない |
| P2 | **東京 NE を優先シード** | `regions` + `workspaces` に公式 25 チャプターを登録 |
| P3 | **既存 workspace はマージ** | DragonFly 等、既存行は `region_id` 付与・名称正規化で統合（重複 slug/name は Runbook 化） |
| P4 | **東京 NE 外は ad-hoc** | 必要になったチャプター／相手のみ手動登録。後日リージョン紐付け・重複解消 |
| P5 | **1to1 相手のデフォルト** | 自チャプター（owner の `workspace_id`）メンバー |
| P6 | **1to1 相手の拡張** | 同一リージョン（初期は東京 NE）内の他チャプターメンバーを選択可能 |
| P7 | **未登録相手** | DB にいない相手は **仮メンバー／手動追加**フロー（SPEC-006 R3 の具体化） |

---

## 4. データモデル（既存テーブル活用）

[DATA_MODEL.md](DATA_MODEL.md) §4.0.1–4.1 のとおり、**新規テーブルは原則不要**。

| テーブル | 役割 | 本 Spec での使い方 |
|----------|------|-------------------|
| `countries` | 国 | 初期値: `Japan`（1 行） |
| `regions` | リージョン | 初期値: `BNI 東京 N.E.リージョン`（`country_id` = Japan） |
| `workspaces` | チャプター | 東京 NE 25 件 + 既存行の `region_id` 更新。`slug` は `bni_<normalized>` 推奨 |
| `members` | 名簿 | `workspace_id` で所属チャプターを表現。クロスチャプター 1to1 は `target_member_id` のみで表現（SPEC-006 解釈 A） |

**命名規則（シード時）:**

- `workspaces.name`: 公式表記に近い表示名（例: `DragonFly`、`TRES STELLAS`、`BNI カーネル` は `KerNel` へ正規化検討）
- `workspaces.slug`: 英小文字・スネーク（例: `bni_dragonfly`、`bni_tres_stellas`）
- 既存 12 workspace との対応は [FIT_AND_GAP §3.2](FIT_AND_GAP_REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1.md) を参照

---

## 5. 東京 NE リージョン — 公式 25 チャプター（シード対象）

**出典:** [BNI 東京 N.E. チャプター検索](https://bni-tne.com/ja/findachapter)（2026-06-27 確認・「25個のチャプター」）

| # | チャプター名 | 曜日・時間（参考） |
|---|-------------|-------------------|
| 1 | TRES STELLAS | 火 7:00–9:00 |
| 2 | PASSIONE | 火 9:00–10:30 |
| 3 | DragonFly | 火 10:00–11:30 |
| 4 | BRIDGET | 火 19:00–20:30 |
| 5 | KerNel | 火 19:15–20:45 |
| 6 | Tifonet | 火 20:30–22:00 |
| 7 | Confioir | 水 7:00–8:30 |
| 8 | EAGLE | 水 7:15–8:45 |
| 9 | SILVIS | 水 7:30–9:00 |
| 10 | DIANA | 水 9:00–10:30 |
| 11 | TRINITY | 水 9:00–11:00 |
| 12 | LAPIS | 水 10:00–11:30 |
| 13 | SPREAD | 水 16:00–17:30 |
| 14 | ETOILE | 水 19:00–20:30 |
| 15 | OuVrir | 水 19:00–20:30 |
| 16 | VORTEX | 木 7:15–9:00 |
| 17 | ThunderVolt | 木 9:00–10:30 |
| 18 | Reverie | 木 19:00–20:30 |
| 19 | IMPROVE | 金 7:00–8:30 |
| 20 | bonheur | 金 7:15–9:00 |
| 21 | Abundance | 金 9:15–10:45 |
| 22 | GRANDIR | 金 9:30–11:00 |
| 23 | NATION DRIVE | 金 15:00–16:30 |
| 24 | LUMINOUS | 土 9:00–10:30 |
| 25 | EduTech | 立ち上げ中（2026-06-27 ユーザー確認） |

**件数メモ:** 公式ページ見出しは「25個のチャプター」。2026-06-27 時点の [findachapter](https://bni-tne.com/ja/findachapter) 本文から抽出できた名称は 24 件だったが、ユーザー確認により **EduTech（東京 NE リージョン・立ち上げ中）**を 25 件目として扱う。

### 5.1 NE 以外の既存 121 相手チャプター（正しいリージョンで登録）

全国を事前登録しない方針は維持する。ただし、既存 121 履歴で登場済みの NE 以外チャプターは、**正しいリージョンを設定した上で**登録する。

| チャプター | リージョン | 対象 121 相手 |
|------------|------------|---------------|
| 大人なじみ | BNI 東京南リージョン | 飯塚氏、伊藤隆夫 |
| クリエーションズ | BNI 千葉セントラルリージョン | 平野眞邦 |
| インフィニティ | BNI 静岡セントラルリージョン | 古屋周治 |

**BNI会員外:** 田辺光さんは BNI 会員ではないため、リージョン／チャプターを設定しない。

---

## 6. 機能要件

### 6.1 マスタ管理

| ID | 要件 | 優先 | 備考 |
|----|------|------|------|
| M1 | `countries` / `regions` / `workspaces` の **シード**（東京 NE 25 + Japan） | P1 | Seeder または migration + idempotent upsert |
| M2 | 既存 `workspaces` の **`region_id` バックフィル** | P1 | DragonFly 等。全件必須ではない（SPEC-006）だが東京 NE 分は付与 |
| M3 | **リージョン・チャプター管理 UI** | P2 | chapter_admin または将来 `region_admin`。初期は Seeder + 手動 SQL で可 |
| M4 | 東京 NE 外 workspace の **手動作成 API** | P2 | `name` + 任意 `region_id`（null 可）。後から正規化 |
| M5 | 重複 workspace / 別名の **マージ Runbook** | P2 | [MEMBERS_DEDUPLICATION_RUNBOOK.md](MEMBERS_DEDUPLICATION_RUNBOOK.md) と整合 |

### 6.2 1to1 相手選択 UX

| ID | 要件 | 優先 | 備考 |
|----|------|------|------|
| T1 | デフォルト: **自チャプター**のメンバーのみ候補 | P1 | owner の `workspace_id` でフィルタ |
| T2 | **他チャプター**: リージョン選択（手動入力可）→ チャプター選択（手動登録可）→ **相手の名前**入力 | P1 | 他チャプター名簿は一覧表示しない |
| T3 | 自チャプター候補ラベルに **チャプター名**を表示 | P1 | 既存 `MemberWorkspaceAttributes` 活用 |
| T4 | **手動追加**: `POST /api/dragonfly/cross-chapter-targets/resolve` で region/workspace/member を解決 | P1 | Phase 272 追記で実装 |
| T5 | 作成後サマリに **所属チャプター / リージョン**表示 | P1 | 実装済み（`TargetMemberSummaryById`）— 維持 |

### 6.3 API

| ID | 要件 | 優先 | 備考 |
|----|------|------|------|
| A1 | `GET /api/workspaces?region_id=` フィルタ | P1 | 既存 index の拡張 |
| A2 | `GET /api/regions` 一覧（country 含む） | P2 | 現状 route なし |
| A3 | `GET /api/dragonfly/members?workspace_id=` または `region_id=` | P1 | 1to1 相手候補用。owner スコープと併用 |
| A4 | クロスチャプター識別フィールド維持 | — | SPEC-006 実装済み（`is_cross_chapter` 等） |

### 6.4 権限（将来）

| ID | 要件 | 優先 | 備考 |
|----|------|------|------|
| R1 | `region_admin` ロール定義 | P3 | SPEC-020 G19。東京 NE 横断管理用 |
| R2 | chapter_admin は **自チャプター**の名簿編集 | — | 現行維持 |
| R3 | 手動追加メンバーの編集権限 | P2 | 作成者 owner のみ / admin のみ等を Phase で確定 |

---

## 7. 非スコープ（本 Spec ではやらない）

- 全国 BNI チャプターの自動クロール・全件シード
- 他リージョン（東京 NE 以外）の一括インポート
- Categories / Roles のリージョン共通化（SPEC-020 G18 参照・別 Spec）
- Dashboard リージョン横断 KPI（別 Phase）
- `/api/dragonfly/*` の Religo 汎用 API への全面リネーム（G17・Phase J）

---

## 8. 実装フェーズ案（参考）

| Phase | 内容 | DoD 案 |
|-------|------|--------|
| **272**（docs または implement） | 本 Spec + Fit&Gap 確定、25 チャプター突合 | ドキュメント merge |
| **273** | Tokyo NE Seeder + 既存 workspace `region_id` バックフィル | migration/seeder テスト、dragonfly.sql 更新方針 |
| **274** | 1to1 相手選択: 自チャプター / リージョン内他チャプター切替 | UI + members API フィルタ、Feature テスト |
| **275** | 未登録相手の手動追加（最小） | POST member stub + 1to1 作成 E2E |

**前提:** SPEC-020 の P0 認可（owner enforcement 等）は Phase 263–271 で着手済み。クロスチャプター UX は **認可境界の上**に載せる。

---

## 9. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-06-27 17:11 JST | 初版。リージョン・チャプターマスタ方針、東京 NE 25 シード、1to1 相手選択、フェーズ案を記載。 |
