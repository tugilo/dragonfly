# PHASE_S_002_INFRASTRUCTURE_CONSTITUTION_PLAN.md

## 背景

- 標準（GLOBAL_STANDARD_DECLARATION・GLOBAL_DIFF_MATRIX・MIGRATION_GUIDE）はすでに「思想」として明文化されている。
- 思想だけでは属人化・AI の独自解釈・案件ごとの逸脱を防ぎきれない。**制度として固定**し、「戻れない」状態にする必要がある。

## 目的

- **docs/SUMMARY_REPORT.md** を「基盤憲章（Infrastructure Constitution v1.0）」へ昇格させる。
- tugilo Standard Docker Infrastructure を **制度** として固定する。改善ではなく、思想を制度にするフェーズ。

## 追加する要素一覧

| 要素 | 内容 |
|------|------|
| タイトル変更 | `# tugilo Infrastructure Constitution v1.0` |
| 宣誓文 | 冒頭に追加。全プロジェクトが本基盤を唯一の Docker 標準とし、個別最適ではなく全体最適を優先し、SSOT は本リポジトリのみとする旨。 |
| 制度としての目的 | なぜ制度化したか（属人化防止・AI 暴走防止・案件間の一貫性・長期的保守性）を明文化。 |
| Versioning Policy | v1.x は互換性維持。v2.0 は破壊的変更。破壊的変更は Phase 管理＋宣言必須。GLOBAL_DIFF_MATRIX 更新必須。 |
| Change Control Matrix | 項目（project.env / docker-compose.yml / bin/ / Makefile / docs/process）ごとに変更可否と条件を表で定義。 |
| Change Approval Flow | PLAN → WORKLOG → REPORT → INDEX 更新 → 1 Phase = 1 commit を明文化。 |

## 絶対遵守

- docker-compose.yml / bin/ / Makefile / README は変更しない。
- ドキュメントのみ編集。既存 SUMMARY_REPORT の内容は **削らない**（追記方式）。

## 成果物

- docs/SUMMARY_REPORT.md の昇格（憲章化・宣誓文・Versioning Policy・Change Control Matrix・Change Approval Flow・制度としての目的を追記）。
- PHASE_S_002_INFRASTRUCTURE_CONSTITUTION_WORKLOG.md。
- PHASE_S_002_INFRASTRUCTURE_CONSTITUTION_REPORT.md。
- docs/INDEX.md の更新（PLAN・WORKLOG・REPORT を process 一覧に追加。SUMMARY_REPORT の説明を憲章に変更）。

## DoD

- [x] SUMMARY_REPORT が Constitution へ昇格
- [x] 宣誓文追加済み
- [x] Versioning Policy 追加済み
- [x] Change Control Matrix 追加済み
- [x] Change Approval Flow 明文化済み
- [x] INDEX 更新済み
- [x] 1 commit
