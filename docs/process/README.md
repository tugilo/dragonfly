# docs/process/ — 詳細資料（Phase 別）

このディレクトリには **Phase 別の詳細な PLAN / WORKLOG / REPORT** を置く（任意）。  
**メインの進捗は必ず `docs/<プロジェクト名>_progress.md` に記録する。**

## 必須ルール

1. **進捗の主役は docs/<プロジェクト名>_progress.md**  
   どのプロジェクトでも、進捗は `docs/<プロジェクト名>_progress.md` に記録する。例: fluo なら `docs/fluo_progress.md`。

2. **process/ は詳細用**  
   ここ（docs/process/）には、必要に応じて Phase 別の PLAN / WORKLOG / REPORT を追加してよい。ファイル名例: `PHASE_<内容>_PLAN.md`, `_WORKLOG.md`, `_REPORT.md`。

3. **INDEX を必ず更新する**  
   docs/ 以下にドキュメントを追加・変更・削除したら、**必ず** [docs/INDEX.md](../INDEX.md) の一覧を更新する。

## 例

- 進捗の要約・履歴 → `docs/fluo_progress.md` に追記
- Phase ごとの詳細な計画・ログ・報告 → `docs/process/PHASE_AUTH_PLAN.md` 等を作成し、INDEX に追記
