# フィット＆ギャップ：リージョン・チャプターマスタとクロスチャプター 1to1 相手選択（SPEC-021）

**調査日:** 2026-06-27 17:11 JST  
**要件 SSOT:** [REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md](REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md)（SPEC-021）  
**比較対象:** 現行 DB（`dragonfly.sql`）、`www/` 実装、SPEC-006、SPEC-020 G17–G19

---

## 1. サマリ

| 領域 | Fit（既にある） | Gap（足りない） |
|------|----------------|-----------------|
| **DB 階層** | `countries` / `regions` / `workspaces.region_id` マイグレーション済み。Phase 272 で東京NE・東京南・千葉セントラル・静岡セントラルをシード | — |
| **クロスチャプター 1to1 行** | `target_member_id` 別 workspace 可・API に `is_cross_chapter` 等。既存 121 の NE 外相手も正しいリージョンへ紐付け | — |
| **メンバー所属表示** | `MemberWorkspaceAttributes`・1to1 サマリカード | — |
| **workspace 一覧 API** | `GET /api/workspaces`（region 付き） | `region_id` フィルタ・`GET /api/regions` なし |
| **1to1 相手選択 UI** | `OwnerScopedTargetSelect`・Autocomplete | **チャプター／リージョン切替なし**。全メンバーが候補になり得る |
| **マスタ運用** | 東京 NE 25（EduTech 含む） + 既存 121 の NE 外 3チャプターを正規化 | 新規に登場する NE 外チャプターは正しいリージョン確認後に追加 |
| **権限** | `chapter_admin` | `region_admin` 未定義（G19） |

**結論:** SPEC-006 で「記録と表示」の土台はある。**マスタシードと相手選択 UX** が本丸。全国事前登録はせず、東京 NE 25 + 既存 121 で登場した NE 外チャプターを正しいリージョンで追加する方針が現状 DB と整合する。

---

## 2. 機能別 Fit / Gap

### 2.1 リージョン・チャプターマスタ（DB）

| 要件（SPEC-021） | 現状 | Fit/Gap |
|------------------|------|---------|
| Country > Region > Workspace | テーブル・FK あり（migration `2026_04_08_090000`） | **Fit（スキーマ）** |
| Japan + 東京 NE リージョン | Phase 272 で `Japan` + `BNI 東京 N.E.リージョン` 作成 | **Fit** |
| 東京 NE 25 workspace シード | Phase 272 で EduTech を含む 25 件をシード | **Fit** |
| 既存 workspace に `region_id` | Phase 272 で正しいリージョンを付与 | **Fit** |
| 全国網羅しない | 12 件のみ ad-hoc — 方針と一致 | **Fit（運用実態）** |

**参照:** `www/database/migrations/2026_04_08_090000_create_countries_regions_add_region_id_to_workspaces.php`、`WorkspaceSeeder.php`、`dragonfly.sql` workspaces INSERT

---

### 2.2 既存 workspace と東京 NE 公式名の対応

`dragonfly.sql`（2026-06 時点）の workspace と [BNI 東京 N.E. 公式一覧](https://bni-tne.com/ja/findachapter) の突合:

| workspace.id | DB name | slug | 東京 NE 公式 | 判定 |
|-------------|---------|------|-------------|------|
| 1 | DragonFly | bni_dragonfly | DragonFly | **Fit** |
| 2 | BNI Diana | bni_diana | DIANA | **Fit**（表記ゆれ） |
| 3 | BNI 大人なじみ | bni_otona_najimi | （公式 25 に無し） | **Fit（NE外）** — BNI 東京南リージョン |
| 4 | BNI カーネル | bni_kernel | KerNel | **Fit**（表記ゆれ） |
| 5 | BNI レブリー | bni_reverie | Reverie | **Fit** |
| 6 | BNI パッシオーネ | bni_passione | PASSIONE | **Fit** |
| 7 | BNI SPREAD | bni_spread | SPREAD | **Fit** |
| 8 | BNI トレスステラ | bni_trestella | TRES STELLAS | **Fit** |
| 9 | BNI VORTEX | bni_vortex | VORTEX | **Fit** |
| 10 | BNI Tifonet | bni_tifonet | Tifonet | **Fit** |
| 11 | BNI SILVIS | bni_silvis | SILVIS | **Fit** |
| 12 | BNI クリエーションズ | bni_creations | （公式 25 に無し） | **Fit（NE外）** — BNI 千葉セントラルリージョン |

**Phase 272 後:** 東京 NE は EduTech（立ち上げ中）を含む 25 件。NE 外は既存 121 に登場した 大人なじみ・クリエーションズ・インフィニティ を正しいリージョンで登録。

| 集計 | 件数 |
|------|------|
| 東京 NE | 25（EduTech 含む） |
| NE 外（既存 121 由来） | 3（大人なじみ、クリエーションズ、インフィニティ） |
| BNI 会員外 | 田辺光さんは workspace/region 未設定 |

---

### 2.3 1to1 クロスチャプター（記録・API）

| 要件 | 現状 | Fit/Gap |
|------|------|---------|
| 他チャプター `target_member_id` | バリデーション `exists:members,id` のみ | **Fit**（SPEC-006 R1） |
| `is_cross_chapter` 等の API フィールド | `OneToOneCrossChapterHierarchyTest`・一覧/詳細に付与 | **Fit** |
| 一覧フィルタ「他チャプターのみ」 | 未実装 | **Gap**（R2・将来） |
| 未登録相手の 1to1 | POST 不可 | **Gap**（R3） |

**参照:** `ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md`、`OneToOneCrossChapterHierarchyTest.php`

---

### 2.4 1to1 相手選択 UI

| 要件（SPEC-021） | 現状 | Fit/Gap |
|------------------|------|---------|
| デフォルト自チャプター候補 | `ScopedTargetSelect` は `GET /api/dragonfly/members?owner_member_id=` のみ。**workspace フィルタなし** | **Gap** — 実質全メンバーが候補になり得る |
| リージョン／チャプター切替 | UI なし | **Gap** |
| 相手サマリ（チャプター・リージョン） | `TargetMemberSummaryById` 実装済み | **Fit** |
| 手動追加フロー | なし | **Gap** |

**参照:** `OneToOnesFormParts.jsx` L131–196、`DragonFlyMemberController::index`

```153:153:www/resources/js/admin/pages/OneToOnesFormParts.jsx
        fetchJson(`/api/dragonfly/members?owner_member_id=${encodeURIComponent(String(ownerMemberId))}`)
```

`owner_member_id` は interested / want_1on1 フィルタにのみ使用され、**workspace スコープは API 側に無い**。

---

### 2.5 マスタ API・管理画面

| 要件 | 現状 | Fit/Gap |
|------|------|---------|
| `GET /api/workspaces` | 実装済み（`region.country` eager load） | **Fit** |
| `GET /api/workspaces?region_id=` | 未対応 | **Gap** |
| `GET /api/regions` | route なし | **Gap** |
| リージョン・チャプター CRUD UI | なし | **Gap** |
| Members 編集で `workspace_id` 変更 | 要確認（admin のみ） | **部分 Fit** |

**参照:** `WorkspaceController.php`、`routes/api.php`

---

### 2.6 権限・横断展開（SPEC-020 より）

| Gap ID | 内容 | 本 Spec との関係 |
|--------|------|-----------------|
| G17 | `/api/dragonfly/*` 固有命名 | マスタ API 追加時に `/api/regions` は汎用名で設計可 |
| G18 | workspace / region 境界の揺れ | **本 Spec の実装で T1–T2 が境界を明確化** |
| G19 | `region_admin` 未定義 | M3・R1 で将来対応 |

---

## 3. Gap 一覧（実装優先度付き）

| ID | Gap | 優先 | 対応案 |
|----|-----|------|--------|
| G1 | `regions` / `countries` シード空 | P0 | Seeder: Japan + 東京 NE | **Fit（Phase 272）** — `religo:seed-tokyo-ne-region` |
| G2 | 東京 NE 25 workspace 未シード | P0 | Idempotent upsert by slug | **Fit（Phase 272）** — EduTech 含む 25 件 |
| G3 | 既存 12 workspace の `region_id` NULL | P0 | バックフィル migration | **Fit（Phase 272）** — seeder で付与 |
| G4 | 公式外 workspace / 既存 121 の NE 外チャプター | P1 | 正しい region を確認して登録 | **Fit（Phase 272）** — 東京南・千葉セントラル・静岡セントラル |
| G5 | 1to1 相手が workspace 未スコープ | P0 | API `workspace_id` + UI デフォルト自チャプター | **Fit（Phase 272）** |
| G6 | リージョン内他チャプター切替 UI | P1 | 自/他チャプター + リージョン・チャプター・名前 | **Fit（Phase 272 追記）** |
| G7 | 未登録相手の手動追加 | P2 | `cross-chapter-targets/resolve` | **Fit（Phase 272 追記）** — `visitor` 最小登録 |
| G8 | `GET /api/regions` | P2 | RegionController | **Fit（Phase 272）** |
| G9 | workspace `region_id` フィルタ | P1 | WorkspaceController 拡張 |
| G10 | リージョン・チャプター管理 UI | P2 | admin Settings または専用 Resource |
| G11 | `region_admin` | P3 | User religo_role 拡張・別 Spec |
| G12 | 他チャプター 1to1 一覧フィルタ | P3 | SPEC-006 R2 |

---

## 4. 推奨実装順序

1. **G1–G3** — Tokyo NE マスタシード（Phase 273 想定）
2. **G5** — 相手候補を自チャプターに限定（セキュリティ・UX 両面）
3. **G6, G9** — 東京 NE 内チャプター切替
4. **G7** — 手動 ad-hoc 相手（全国・未登録）
5. **G8, G10, G11** — 運用・権限の整備

---

## 5. テスト観点（implement Phase 用）

| 観点 | 既存 | 追加必要 |
|------|------|----------|
| クロスチャプター API フィールド | `OneToOneCrossChapterHierarchyTest` | — |
| Seeder 冪等性 | — | RegionChapterSeederTest |
| members index `workspace_id` | — | Feature test |
| 1to1 作成 UI スコープ | — | E2E または JS 結合テスト（任意） |

---

## 6. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-06-27 17:11 JST | 初版。DB・既存 workspace 突合・1to1 UI・API・Gap 一覧を記載。 |
| 2026-06-27 17:30 JST | Phase 272 実装反映。G1–G3, G5–G6, G8 を Fit に更新。 |
| 2026-06-27 17:50 JST | 既存 121 再調査結果を反映。EduTech（東京NE・立ち上げ中）を25件目に追加。古屋周治=インフィニティ/静岡セントラル、田辺光=BNI会員外、門松直幸=EduTech/東京NEを反映。 |
