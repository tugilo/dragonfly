# PHASE_S_003_FLOU_BOOTSTRAP_PLAN.md

## 目的

新規プロジェクト **flou** を、tugilo Infrastructure Constitution v1.0 に **完全準拠** した形で安全に立ち上げる。既存案件に一切影響を与えず、憲章準拠の最初の実戦プロジェクトとして実証する。

## 背景

- 憲章 v1.0 および MIGRATION_GUIDE は確定済み。**新規成功例** がまだない。
- 既存案件（protectlab / tsuboi / muraconet / dandreez）に触れず、テンプレートから `make new-project` で flou を生成し、PORT_GUARD 有効のまま `make setup` → `make doctor` で全項目 OK となることを確認する。
- 本 Phase は **基盤変更ではない**。docker-compose.yml / bin/ / Makefile は触らない。変更は docs と flou プロジェクトのみ。

## 成果物

- flou プロジェクト（テンプレート隣に生成。infra / bin / Makefile / project.env / .cursorrules を含む）。
- docs/process/PHASE_S_003_FLOU_BOOTSTRAP_PLAN.md（本ファイル）。
- docs/process/PHASE_S_003_FLOU_BOOTSTRAP_WORKLOG.md。
- docs/process/PHASE_S_003_FLOU_BOOTSTRAP_REPORT.md（使用ポート・PORT_GUARD 挙動・doctor 結果・既存案件影響・Constitution 準拠確認を記載）。
- docs/INDEX.md の process 一覧への追加。
- docs/flou_progress.md（flou 用進捗ファイル。必要に応じて作成）。

## 絶対遵守

- docker-compose.yml / bin/ / Makefile を編集しない。
- 既存案件（protectlab / tsuboi / muraconet / dandreez）には触れない。
- 変更は docs と flou プロジェクトのみ。
- 1 Phase = 1 commit。

## DoD

- [ ] flou が起動している（compose up 成功）。
- [ ] 既存案件のポートに影響なし。
- [ ] make doctor が全項目 PASS（または許容できる警告のみ）。
- [ ] PLAN / WORKLOG / REPORT 完成。
- [ ] INDEX 更新済み。
- [ ] 1 commit にまとめている。
