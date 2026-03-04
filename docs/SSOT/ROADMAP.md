# Religo 全体ロードマップ — SSOT

**目的:** Religo の開発を迷いなく継続するため、順番・DoD・依存・スコープロック・テスト規約を一枚に固定する全体ロードマップの SSOT。  
**前提:** 命名は [PROJECT_NAMING.md](../PROJECT_NAMING.md) に従う（**Religo＝プロダクト名**、DragonFly＝チャプター名、dragonfly＝リポジトリ名）。  
**作成日:** 2026-03-05

---

## 1. Purpose

Religo の目的は「会の地図（Relationship Map）」を作り、BNI などのコミュニティにおいて人間関係の理解と紹介発想を支援することである。本ロードマップは、**次にやる順番・各 Phase の DoD・依存・スコープロック・テスト規約**を固定する SSOT であり、Cursor および開発者が迷わず実装を進めるための唯一の参照とする。

---

## 2. Scope Lock（絶対に守る）

- **SSOT 参照ルール:** 実装・設計は次の優先順位で従う。  
  - [DATA_MODEL.md](DATA_MODEL.md)（エンティティ・テーブル・派生指標・Phase 対応）  
  - [ADMIN_UI_THEME_SSOT.md](ADMIN_UI_THEME_SSOT.md)（Theme・Typography・Components）  
  - 本 ROADMAP.md（Phase 順序・DoD・依存・スコープ外）
- **勝手に仕様を増やさない:** 上記 SSOT にない機能・テーブル・API は Phase のスコープに含めず、必要なら別 Phase または Future extensions で計画する。
- **Phase をまたいで混ぜない:** 1 Phase ＝ 1 目的。複数目的を 1 ブランチに混在させない。
- **PR なし運用のマージ手順:** 機能・修正は必ず feature ブランチで行い、develop への取り込みは「ローカルで merge → テスト → push」で行う。PR は使わない。手順は [PRLESS_MERGE_FLOW.md](../git/PRLESS_MERGE_FLOW.md) および [.cursorrules](../../.cursorrules) の取り込み用固定手順に従う。

---

## 3. 現在地（As-Is Snapshot）

### 3.1 完了済み主要 Phase（機能別）

| 機能領域 | 完了 Phase | 内容 |
|----------|------------|------|
| 関係ログ（メモ・1to1） | Phase04, 05, 06, 07, 08 | Members 一覧に summary 統合、メモ追加 API・1to1 登録 API、Board からメモ追加・1to1 登録、workspace_id 自動取得 |
| BO 割当 | Phase10, 10R | Breakout Room Builder（BO1/BO2）、Round 可変（単回→複数 round 対応） |
| ReactAdmin メニュー IA | Phase11A | Board → Members → 区切り → Meetings → 区切り → 1 to 1 の順に整理、プレースホルダー導線 |
| 1to1 独立一覧 | Phase11B | GET /api/one-to-ones、ReactAdmin Resource one-to-ones の List/Create |
| Board UX | Phase12, 12S | 固定 BO 撤去・Round UI 統一、MUI 骨格・余白・階層の polish |
| Theme（OS 化） | Phase12T | Admin Theme SSOT 化と全ページ適用（religoTheme.js、CssBaseline） |
| Workspace seed | Phase09 | WorkspaceSeeder 冪等、GET /api/workspaces、Feature テスト |

### 3.2 重要な API 一覧

| API | 用途 |
|-----|------|
| GET /api/members（summary 統合） | メンバー一覧・関係指標（same_room_count, last_memo, one_to_one_count 等） |
| GET/POST /api/contact-memos（memos） | メモ登録・一覧 |
| GET/POST /api/one-to-ones | 1 to 1 登録・一覧 |
| GET/PUT /api/meetings, /api/meetings/{id}/breakout-rounds | 例会・Breakout Round 割当 |
| GET /api/workspaces | workspace 一覧（1to1 登録時の workspace_id 取得用） |

### 3.3 テスト状況

- Feature テストが存在（MemberSummaryTest, OneToOneIndexTest 等）。  
- 現状: `php artisan test` で passed（目安: 27 passed 前後）。Phase 取り込み前後でテスト実行が必須。

---

## 4. Target UX（To-Be）

- **「直感的に速い」の定義:** 選択 → 入力 → 保存 → 反映が迷わない。余計な画面遷移をせず、状態（未保存／保存済み／エラー）が一目で見える。Board 上でメンバー選択・BO 割当・関係ログ（メモ／1to1／紹介）への導線が最短である。
- **UI の OS の順序:** Theme SSOT（Phase12T）→ IA（Phase12U）→ 運用機能 の順で整える。Theme を土台にし、その上で 3 ペイン IA と List 実装・ショートカット導線を積む。

---

## 5. Roadmap（Phase Map）

Phase は「大きく 4 レーン」で並べる。Phase 番号はここで確定し、今後ブレ禁止とする。

### A. UI/IA（操作性）

| Phase ID | 目的（1行） | 主要成果物 | 依存 | DoD | テスト | スコープ外 |
|----------|-------------|------------|------|-----|--------|------------|
| **12T** | Admin Theme SSOT と全ページ適用（OS 化） | ADMIN_UI_THEME_SSOT.md, religoTheme.js, CssBaseline 適用 | — | Theme 1 箇所集約・全ページ反映・既存テスト green | 必須 | 機能追加・新 npm パッケージ |
| **12U** | Board 3 ペイン IA（メンバー選択／BO／関係ログ） | Board 左・中央・右のペイン構成、関係ログ表示 | 12T, DATA_MODEL | 3 ペイン構成確定・選択→BO→ログの導線が明確・既存テスト green | 必須 | 紹介 UI の詳細・グラフ |
| **12V** | Members / Meetings の List 実装（placeholder 卒業） | Members List, Meetings List の実データ表示 | 12T, 既存 API | List が実データで表示・フィルタ・並び順が使える | 必須 | 新 API 追加 |
| **12W** | Board ショートカット導線（メモ／1to1／紹介を最短化） | Board 上からメモ・1to1・紹介への 1 クリック導線 | 12U | 選択メンバーからメモ／1to1／紹介登録へ最短で遷移・既存テスト green | 必須 | 紹介の登録フォーム詳細は 14A |

### B. データ/整合（SSOT 運用）

| Phase ID | 目的（1行） | 主要成果物 | 依存 | DoD | テスト | スコープ外 |
|----------|-------------|------------|------|-----|--------|------------|
| **13A** | B 項目の DATA_MODEL 反映（introductions 拡張など必要最小限） | DATA_MODEL 更新、migration（必要な場合のみ） | DATA_MODEL | 仕様と実装が DATA_MODEL と一致・既存テスト green | 必須 | 過剰なスキーマ変更 |
| **13B** | workspace multi 対応の設計のみ（実装は後ろへ） | docs 上の multi-workspace 設計・クエリ方針 | DATA_MODEL, 13A | 設計 SSOT が docs に存在・実装は行わない | 任意 | 実装・migration |
| **13C** | 監査・復元（論理削除／編集履歴）方針の SSOT 化 | docs 上の方針・Future extensions 追記 | DATA_MODEL | 論理削除・履歴の扱いが docs で確定 | 任意 | 実装 |

### C. 機能拡張（紹介発想支援）

| Phase ID | 目的（1行） | 主要成果物 | 依存 | DoD | テスト | スコープ外 |
|----------|-------------|------------|------|-----|--------|------------|
| **14A** | introductions 登録／一覧 API + UI | GET/POST /api/introductions、ReactAdmin Resource または Board 導線 | DATA_MODEL, 13A | API と UI で紹介を登録・一覧表示できる | 必須 | 紹介推論・スコア算出 |
| **14B** | 紹介関係の可視化（まずは表） | 紹介一覧・フィルタ・owner/from/to 表示 | 14A | 紹介が表で見える・簡易グラフは将来扱い | 必須 | グラフ・可視化ライブラリ |
| **14C** | relationship_score 定義 SSOT 作成のみ（実装禁止） | docs 上の定義・数式・入力候補の列挙 | DATA_MODEL | SSOT に定義が書かれている・コード実装はしない | 任意 | スコア算出の実装 |

### D. 運用/品質

| Phase ID | 目的（1行） | 主要成果物 | 依存 | DoD | テスト | スコープ外 |
|----------|-------------|------------|------|-----|--------|------------|
| **15A** | シード／初期データの整備（owner/member/meeting の最小セット） | Seeder 拡張・docs 手順 | Phase09 | 新規環境で最小データが投入できる | 必須 | 本番データ移行 |
| **15B** | E2E 手動チェックシート（docs） | docs 上のチェックリスト・観点 | — | リリース前の手動確認項目が docs に固定されている | 任意 | 自動 E2E |
| **15C** | リリース手順 SSOT（develop→main、証跡の残し方） | docs 上のリリース手順・証跡テンプレ | PRLESS_MERGE_FLOW | 手順が docs にあり、証跡の残し方が明文化されている | 任意 | CI/CD の必須化 |

---

## 6. Execution Playbook（Cursor が迷わない実行手順）

### 1 Phase の進め方

1. **Plan:** 該当 Phase の PLAN を `docs/process/phases/` に作成（目的・スコープ・DoD・リスク・ロールバック）。
2. **Impl:** feature ブランチで実装。WORKLOG に Step0〜Step4 で作業ログを記録。
3. **Test:** `php artisan test`（または Phase で定めたテスト）を実行し、REPORT に結果を記載。
4. **Docs:** INDEX.md・dragonfly_progress.md を更新。REPORT に変更ファイル一覧・DoD 達成状況を記載。
5. **Closeout:** 1 コミットで push。develop に merge（--no-ff）→ テスト → push。REPORT に取り込み証跡（merge commit id、変更ファイル一覧、テスト結果）を追記。

### ブランチ命名

- `feature/phase<ID>-<短い識別子>-v1`  
- 例: `feature/phase12t-admin-theme-ssot-v1`, `feature/phase12r-roadmap-ssot-v1`

### 1 コミット規約

- 1 Phase ＝ 1 目的 ＝ 1 コミットで push（Phase 内で複数コミットしても、push 前に squash するか、1 まとまりで push する運用可）。  
- コミットメッセージ: `docs: ...` / `ui: ...` / `feat: ...` など接頭辞で種別を明示。

### テストコマンド

- `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test`  
- 取り込み前（feature 上）と取り込み後（develop 上）の両方で実行する。

### 証跡の残し方

- Phase の REPORT に「取り込み証跡」セクションを追加。  
- 記載項目: merge commit id（`git log -1 --format=%H develop`）、merge 元ブランチ名、`git diff --name-only develop^1...develop` の結果、テスト結果。  
- テンプレート: [PHASE_REPORT_TEMPLATE.md](../process/templates/PHASE_REPORT_TEMPLATE.md)。

---

## 7. 「今週の Next 3」（短期）

直近でやる Phase を 3 つに固定する。依存関係と UI の OS の順序に従う。

| 順 | Phase | 理由 |
|----|-------|------|
| 1 | **12T** | Theme SSOT と適用が「OS 化」の土台。完了済みの場合は次へ。 |
| 2 | **12U** | Board 3 ペイン IA（メンバー選択／BO／関係ログ）で操作性の基盤を固める。 |
| 3 | **12V** | Members / Meetings の List を placeholder から実データ表示にし、一覧の価値を出す。 |

※ 12T が完了しているため、実質の Next 3 は **12U → 12V → 12W** の順で進めるのが自然。
