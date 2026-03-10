# Phase G3: Implementation residue triage after G2 — PLAN

| Phase ID | G3 |
|----------|-----|
| Name | Implementation residue triage after G2 |
| Type | docs（調査・分類のみ） |

---

## Purpose

G2 後に残った実装寄りの差分を、安全に分類し、**次の commit 単位**を決める。

---

## Background

G2 では docs/SSOT のみを commit し、実装差分（bootstrap/app.php、Console コマンド、CSV、テスト、mock、.cursor 等）を意図的に残した。これらを「何をどの単位で commit するか」まで整理する。

---

## Scope

- **In scope:** 未コミット変更・未追跡ファイルのうち、実装寄り差分の**調査と分類**。commit 候補グループの特定、保留・除外候補の明確化、次 Phase 提案。
- **Out of scope:** 本 G3 では原則 **commit / merge / push は行わない**。削除や .gitignore 変更の提案はするが、実行は行わない。

---

## Investigation Targets

| 対象 | 種別 | 確認観点 |
|------|------|----------|
| www/bootstrap/app.php | modified | 何の実装か、単独 commit 可能か、属する feature |
| www/app/Console/ | untracked | コマンド実装。CSV import とセットか |
| www/database/csv/ | untracked | サンプル CSV。テスト・コマンドとセットか |
| www/tests/Feature/ImportParticipantsCsvCommandTest.php | untracked | コマンドの Feature テスト |
| www/public/mock/religo-admin-mock-v2.html | untracked | docs 参照のモック。repo 管理するか |
| .cursor/ | untracked | ルール等。repo 管理方針 |

---

## Classification Policy

- **A. 次の Phase でそのまま commit 候補** — 1 機能単位で意味があり、関連ファイルが揃い、意図が明確で、他と切り離せる。
- **B. 別 Phase に分けるべき候補** — 有用だが別テーマ、まとめると大きい、docs/test と分けた方がよい。
- **C. repo 管理方針確認が必要** — .cursor/、mock、generated、ローカル補助データ。
- **D. 保留** — 意図不明、依存不明、単体では危険。

---

## Tasks

| # | Task | 内容 |
|---|------|------|
| 1 | 変更ファイル一覧化 | modified / untracked を漏れなくリスト。 |
| 2 | 各ファイルの内容確認 | 何のためか、どの Phase か、単独成立か、セットか。 |
| 3 | 機能単位で分類 | kind（implementation / test / mock / docs-like / tooling / generated / unknown）、related feature、safe to commit now。 |
| 4 | commit 候補 / 保留 / 除外に整理 | A/B/C/D で整理。 |
| 5 | 次 Phase 提案 | 1〜3 個の候補 Phase を提案。 |
| 6 | REPORT 作成 | Summary、Investigated Files、Classification、Next Phases、Notes。 |

---

## Risks

- **無関係ファイルの混在:** 1 commit に複数機能を入れない。単位を分ける。
- **生成物・IDE の誤 commit:** .DS_Store、.cursor の扱いを方針化する。
- **mock / test / 実装の混線:** CSV import は「実装 + テスト + サンプル CSV」で 1 セット。mock は別扱い。

---

## DoD

- [ ] 各ファイルの分類理由が説明できる。
- [ ] 次に commit すべき単位が明確になっている。
- [ ] commit しないもの（保留・除外候補）が明確になっている。
- [ ] 推奨 Next Phases が 1〜3 個提案されている。
