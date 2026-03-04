# PHASE12R Religo 全体ロードマップ SSOT — REPORT

**Phase:** Religo 全体ロードマップ SSOT 確立  
**完了日:** 2026-03-05

---

## 実施内容

- Religo の全体ロードマップを SSOT として docs/SSOT/ROADMAP.md に固定。
- 順番・DoD・依存・スコープロック・テスト規約を一枚にまとめ、Cursor が迷わない実行手順（Execution Playbook）と「今週の Next 3」を明示。
- 既存 SSOT（DATA_MODEL, ADMIN_UI_THEME_SSOT）と矛盾しない範囲で 4 レーン（UI/IA, データ整合, 機能拡張, 運用品質）の Phase 表を確定。

## 変更ファイル一覧

- docs/SSOT/ROADMAP.md（新規）
- docs/process/phases/PHASE12R_RELIGO_ROADMAP_SSOT_PLAN.md（新規）
- docs/process/phases/PHASE12R_RELIGO_ROADMAP_SSOT_WORKLOG.md（新規）
- docs/process/phases/PHASE12R_RELIGO_ROADMAP_SSOT_REPORT.md（新規）
- docs/INDEX.md（SSOT セクションに ROADMAP.md 追加）
- docs/dragonfly_progress.md（ロードマップ SSOT 確定を記録）

## ROADMAP.md の要点

- **Purpose:** 会の地図を実現する Religo の開発順序・DoD・依存・禁止事項を固定する SSOT。
- **Scope Lock:** SSOT 参照ルール、仕様の勝手な増やし禁止、1 Phase＝1 目的、PR なし運用（feature→develop merge）の固定。
- **現在地:** 完了 Phase（関係ログ・BO 割当・メニュー IA・Board UX・Theme・Workspace seed）と主要 API・テスト状況の一覧。
- **Target UX:** 直感的に速い（選択→入力→保存→反映が迷わない）。UI の OS は Theme→IA→運用機能の順。
- **Roadmap 表:** Phase12T〜15C を 4 レーンで表形式にし、依存・DoD・テスト・スコープ外を明示。
- **Execution Playbook:** 1 Phase の進め方、ブランチ命名、1 コミット規約、テストコマンド、証跡の残し方。
- **Next 3:** 12T（完了済みなら 12U）→ 12U → 12V。実質は 12U → 12V → 12W。

## DoD 達成状況

- [x] docs/SSOT/ROADMAP.md が指定章立てで存在する
- [x] Roadmap 表が 4 レーンで矛盾していない
- [x] 既存 SSOT と矛盾していない
- [x] docs/INDEX.md に ROADMAP.md を追加した
- [x] docs/dragonfly_progress.md にロードマップ SSOT 確定を記録した
- [x] PLAN / WORKLOG / REPORT を tugilo 式で作成した

## テスト結果

- docs のみの変更のため、php artisan test は任意。実施した場合はここに記載する。
- 例: （実施した場合）`docker compose ... exec app php artisan test` — XX passed

## 取り込み証跡（develop への merge 後に追記）

| 項目 | 内容 |
|------|------|
| **merge commit id** | （merge 後に `git log -1 --format=%H develop` で取得して記入） |
| **merge 元ブランチ名** | feature/phase12r-roadmap-ssot-v1 |
| **変更ファイル一覧** | （merge 後に `git diff --name-only develop^1...develop` の結果を記入） |
| **テスト結果** | docs のみのため任意。実施したら記載。 |
| **手動確認** | INDEX のリンク・ROADMAP 表の依存関係を目視確認。 |
