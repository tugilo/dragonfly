# Phase G6: .cursor tooling policy alignment — PLAN

| Phase ID | G6 |
|----------|-----|
| Name | .cursor tooling policy alignment |
| Type | docs |

---

## Purpose

.cursor/rules/devos-v4.mdc を repo 管理対象にするか判断し、チーム共有ルールとして扱うか、ローカル専用とするかを明確化する。

---

## Background

G3 で .cursor は「repo 管理方針確認が必要な tooling」として分類された。G4・G5 では CSV と mock を整理し、.cursor は未着手。本 Phase で方針を決め、docs と Git に反映する。

---

## Scope

- .cursor/rules/devos-v4.mdc（内容確認・管理可否判断）
- 必要なら .gitignore（track しない場合のみ）
- 方針を記載する docs（process または git）
- docs/process/phases/PHASE_G6_*
- docs/process/PHASE_REGISTRY.md
- docs/INDEX.md

---

## Out of Scope

- 実装コード
- mock
- 他の tooling（IDE 設定等）
- .cursor 以外の残差

---

## Investigation Targets

- .cursor/rules/devos-v4.mdc の内容（個人依存か、チーム共通ルールか）
- ローカルパス・秘密情報・個人識別情報の有無
- .gitignore での .cursor 扱い（現状未指定なら追記の要否）
- プロジェクト再現性への寄与

---

## Decision Criteria

- **個人環境依存情報を含むか** → 含むなら track しない
- **プロジェクト共通ルールとして有益か** → 有益なら track を検討
- **再現性向上に寄与するか** → 寄与するなら track を検討
- **秘密情報やローカルパスを含まないか** → 含まない場合のみ track 可

---

## Tasks

| # | Task | 内容 |
|---|------|------|
| 1 | .cursor 内容確認 | devos-v4.mdc の記載を確認。 |
| 2 | repo 管理可否判断 | Decision Criteria に基づき track / local only を決定。 |
| 3 | 方針 docs 作成/更新 | 決定内容を docs に明記。track する場合は「プロジェクト共有ルール」旨を記載。 |
| 4 | 必要なら .cursor または .gitignore を commit | ケース A: devos-v4.mdc を commit。ケース B: .gitignore 更新＋方針 docs のみ。 |
| 5 | test/build 実行 | php artisan test、npm run build。 |
| 6 | REGISTRY / INDEX / REPORT 更新 | G6 行追加、INDEX に G6 リンク、REPORT に Decision summary と証跡。 |

---

## Risks

- **個人環境依存設定の誤 commit:** 内容を精査し、秘密・ローカルパスが無いことを確認する。
- **チーム共通ルールとローカル設定の混同:** Scope に「devos-v4.mdc のみ」と限定し、他 .cursor 配下は触らない。
- **.gitignore 方針の不整合:** track する場合は .gitignore に .cursor を追加しない。track しない場合は必要に応じ追記。

---

## DoD

- [ ] .cursor の扱い方針が明文化されている（REPORT および必要なら docs/git 等）。
- [ ] track する場合: devos-v4.mdc が安全に repo 管理下に入っている。
- [ ] track しない場合: その理由が REPORT に残っている。
- [ ] PHASE_REGISTRY / INDEX / REPORT が更新されている。
