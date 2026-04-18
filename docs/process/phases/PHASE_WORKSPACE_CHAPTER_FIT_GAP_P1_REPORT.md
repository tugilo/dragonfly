# REPORT — WORKSPACE_CHAPTER_FIT_GAP_P1

| 項目 | 内容 |
|------|------|
| **Phase ID** | WORKSPACE_CHAPTER_FIT_GAP_P1 |
| **種別** | docs |
| **ステータス** | completed（2026-04-17 に業務ルール追記で再整合） |

## 最終結果

- [workspace_vs_chapter_fit_gap_20260403.md](../../02_specifications/workspace_vs_chapter_fit_gap_20260403.md) を作成し、**2026-04-17** に以下を反映した。
- workspace 依存を **所属 / スコープ / 1to1 記録 / 監査 / 文言** に分類。
- **案 A・B・C** と **Fit & Gap 表**、**小／本命／理想**の 3 段階結論を記載。
- **業務ルール（確定）:** **Chapter は正式な所属単位**。**Member は 1 つの Chapter にのみ所属**（複数兼務は現スコープ外）。**workspace は chapter と常に同義ではない**。**Country > Region > Chapter** を維持。

### 今回の追記で明確にしたこと

- **Member の正式所属先は Chapter**、**1 Member : 1 Chapter** を §0・本文に明記。
- Fit & Gap から **多所属を前提にした含み**を整理し、**検索・参照範囲の広がり**と **複数所属**を区別。
- **members.workspace_id** 行を **単一 FK のまま chapter 正式化しやすい**旨で補強（Gap の重さを **中** に再評価）。
- 推奨方針は **「所属の複雑化」ではなく「Chapter を業務の正にする」**方向で補強。
- **次 Phase 候補**から **多所属対応**を外し、用語・エイリアス・単一 FK の migration 設計に集中する旨を記載。

### Fit & Gap で明確になった論点

- **workspace の多義性**（所属／記録コンテキスト／クエリスコープ／監査）は **維持**して論じる。
- **Member 所属**は **業務上 Chapter の 1 対 1** に固定してよいため、**chapter 正式概念化の必要性はむしろ強い**。
- 実装判断は **多所属を捨てて単純化できる**（兼務用テーブル不要）。

## 変更ファイル

**初回（2026-04-03）**

- `docs/02_specifications/workspace_vs_chapter_fit_gap_20260403.md`（新規）
- `docs/process/phases/PHASE_WORKSPACE_CHAPTER_FIT_GAP_P1_PLAN.md`（新規）
- `docs/process/phases/PHASE_WORKSPACE_CHAPTER_FIT_GAP_P1_WORKLOG.md`（新規）
- `docs/process/phases/PHASE_WORKSPACE_CHAPTER_FIT_GAP_P1_REPORT.md`（新規）
- `docs/INDEX.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/dragonfly_progress.md`

**再整合（2026-04-17）**

- `docs/02_specifications/workspace_vs_chapter_fit_gap_20260403.md`（§0 追加・全文整合）
- `docs/process/phases/PHASE_WORKSPACE_CHAPTER_FIT_GAP_P1_PLAN.md`
- `docs/process/phases/PHASE_WORKSPACE_CHAPTER_FIT_GAP_P1_WORKLOG.md`
- `docs/process/phases/PHASE_WORKSPACE_CHAPTER_FIT_GAP_P1_REPORT.md`
- `docs/INDEX.md`（該当行の説明更新）
- `docs/dragonfly_progress.md`（追記）

## テスト

- 該当なし（ドキュメントのみ）

## Merge Evidence

- docs Phase のため **develop 直コミット想定**。merge 後に取り込み証跡を追記する場合は本 REPORT に記載。
