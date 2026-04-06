# M8.6: members.ncast_profile_url SSOT反映 — WORKLOG

**Phase ID:** M8.6  
**種別:** docs  
**作成日:** 2026-03-31  

---

## 作業記録（時系列）

1. **DATA_MODEL.md** の §4.2 members を開き、既存の表（目的・主キー・外部キー・主要カラム・インデックス）の書式を確認した。
2. **主要カラム** 行はカンマ区切りで列名を列挙し、nullable は `(nullable)`、補足は em dash（—）で短い説明を付けるスタイルであることを確認した。
3. `display_no (nullable)` の直後（マイグレーション上も `display_no` の次）に、**ncast_profile_url (nullable, string 2048)** — Nキャスの自己紹介ページ URL を挿入する方針とした。
4. `DATA_MODEL.md` を上記方針で編集し、他セル・他節には手を入れないように差分を限定した。
5. **PLAN / WORKLOG / REPORT** を `docs/process/phases/` に新規作成し、目的・背景・DoD・仕様整合・Merge Evidence（docs のみ）を REPORT に集約した。
6. **INDEX.md** の process/phases 一覧に、M8.6 の PLAN / WORKLOG / REPORT への 3 リンクを追加した。
7. **PHASE_REGISTRY.md** に M8.6 行（type: docs, status: completed, date: 2026-03-31）を追加した。
