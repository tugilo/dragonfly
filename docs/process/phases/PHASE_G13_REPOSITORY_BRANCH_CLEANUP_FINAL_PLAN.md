# Phase G13: Repository Branch Cleanup Final — PLAN

| Phase ID | G13 |
|----------|-----|
| Name | Repository Branch Cleanup Final |
| Type | docs |

---

## Purpose

- Repository の feature ブランチを整理する。
- merge 済み feature を削除する。
- 参照用ブランチ（feature/phase13-remove-round）を含め、不要ブランチを削除して最終整理する。

---

## Background

G10 / G11 / G12 まで完了済み。前回の G13 棚卸しで merge 済み feature は削除済み。参照用として残していた feature/phase13-remove-round を今回削除し、main / develop のみの安定状態で Phase をクローズする。

---

## Scope

- ローカルブランチ feature/phase13-remove-round の削除（remote は存在しない）。
- G13 の PLAN / WORKLOG / REPORT を docs/process/phases/ に作成。
- PHASE_REGISTRY.md に G13 を追加。
- docs/INDEX.md の process/phases に G13 を追加。

---

## Out of Scope

- main / develop の削除・変更。
- rebase / force push。
- add -A による一括 add。

---

## DoD

- [ ] working tree clean の状態で安全確認を実施した。
- [ ] feature/phase13-remove-round を削除した（未 merge のため -D で削除）。
- [ ] 最終状態が local: develop, main / remote: origin/develop, origin/main である。
- [ ] PHASE_G13_*_PLAN.md / WORKLOG.md / REPORT.md を作成した。
- [ ] PHASE_REGISTRY.md に G13 を追加した。
- [ ] docs/INDEX.md に G13 を追加した。
- [ ] 対象ファイルのみ add して commit し、develop を push した。
