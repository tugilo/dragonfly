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

4. **日時は時刻まで（必須・新規追記時）**  
   進捗・変更履歴・Phase の PLAN/WORKLOG/REPORT・SSOT の変更履歴表に **新しく行を足すとき**は、**その作業をした現在の日付と時刻**まで入れる。日付のみ（例: `2026-03-31`）で placeholder 的に書かない。  
   - **取得例（ターミナル・JST）:** `TZ=Asia/Tokyo date '+%Y-%m-%d %H:%M JST'`  
   - 表記例: `2026-04-20 22:18 JST`  
   - **過去に実際に起きた事実**の日付で、当時の時刻が不明な場合は `2026-03-31 12:00 JST` のように **日付＋時刻を補う**か、本文で **TODO** と明記する。  
   打合せ・1to1 等の記録でも同様。リポジトリ直下の `.cursorrules`（ドキュメント節）も参照。

## 例

- 進捗の要約・履歴 → `docs/fluo_progress.md` に追記
- Phase ごとの詳細な計画・ログ・報告 → `docs/process/PHASE_AUTH_PLAN.md` 等を作成し、INDEX に追記
