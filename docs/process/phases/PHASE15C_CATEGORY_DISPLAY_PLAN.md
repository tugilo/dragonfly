# PHASE15C Religo Members カテゴリ表示最適化 — PLAN

**Phase:** Members 一覧・編集でのカテゴリ「大/実」表示を直感的にする  
**作成日:** 2026-03-05  
**SSOT:** [DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.3 categories

---

## 1. 目的

- MembersList で「大カテゴリ / 実カテゴリ」が一目で分かるようにする。
- MemberEdit のカテゴリ Select の option を group_name + " / " + name にし、選択時に迷わないようにする。
- 既存 API（category オブジェクト）を前提に、表示だけ整える。

## 2. 実装方針

- MembersList の CategoryField: group_name と name を常に「group_name / name」形式で併記（name が無い場合は group_name のみ）。
- MemberEdit の category choices: optionText を group_name + " / " + name（name がある場合）、name が無い場合は group_name のみ。
- Board のメンバー表示は現状のまま（表示のみのためロジック変更は最小）。

## 3. DoD

- [x] MembersList でグループと実カテゴリが一目で分かる
- [x] MemberEdit のカテゴリ選択が迷わない
- [x] 既存テスト green

## 4. Git

- ブランチ: `feature/phase15c-category-display`
- コミット: 1 コミット
