# Phase G6: .cursor tooling policy alignment — WORKLOG

| Phase ID | G6 |
|----------|-----|
| 作業日 | 2026-03-11 |

---

## 方針

- .cursor 配下は devos-v4.mdc のみ対象。実装・mock・他残差は触らない。
- 内容確認のうえ、秘密・ローカルパスが無ければ「track in repo」とする。

---

## Task 別メモ

- Task1: devos-v4.mdc は tugilo AI DevOS v4.3 の絶対ルール・Phase 手順・Merge Evidence 等。パスは docs/… や .cursorrules 等のプロジェクト相対のみ。個人名・秘密・ローカルパスなし。
- Task2: チーム共通の開発プロセスルールとして再現性に寄与。safe to track in repo = yes。
- Task3: REPORT に Decision summary を記載。track する場合、INDEX の .cursor 参照説明で「プロジェクト共有ルール」と明記可能。
- Task4: ケース A で .cursor/rules/devos-v4.mdc + G6 docs + REGISTRY + INDEX を commit。.gitignore は変更しない。
- Task5–6: test → build → push → REPORT 証跡。
