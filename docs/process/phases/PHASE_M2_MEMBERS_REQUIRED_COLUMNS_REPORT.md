# Phase M-2 Members 必須列・サブタイトル — REPORT

**Phase:** M-2（tugilo式 Members Gap 解消 Runner）  
**完了日:** 2026-03-06

---

## 実施内容

- **Step1:** ページヘッダにサブタイトルを追加（モック文言「仕事 / 役職 / 関係性を把握し、1to1とメモで接点を増やす」）。List の title を React ノード（Box + Typography）に変更。
- **Step2:** 一覧に **1to1回数** 列を追加。`record.summary_lite?.one_to_one_count` を表示。無い場合は "—"。同室回数の直後に配置。
- **Step3:** **interested / want_1on1** を一覧に表示（任意・簡易）。Chip で「Interested」「1on1」を表示。値が無い場合は何も表示しない（フラグ列は空）。
- 既存ヘッダーアクション（Connectionsへ、＋メンバー追加 disabled）は維持。

---

## 変更ファイル一覧

```
www/resources/js/admin/pages/MembersList.jsx
```

---

## テスト結果

```
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test
Tests: 66 passed (243 assertions)
```

---

## ビルド結果

```
cd www && npm run build
Exit code: 0（成功）
```

---

## DoD チェック

| 項目 | 結果 |
|------|------|
| one_to_one_count が一覧に表示されている | ○（列「1to1回数」で表示） |
| 値が無い場合は "—" | ○（OneToOneCountField で実装） |
| サブタイトル追加 | ○ |
| interested / want_1on1 表示（任意） | ○（Chip で表示） |
| test / build 成功 | ○ |

---

## 取り込み証跡（develop への merge 後）

| 項目 | 内容 |
|------|------|
| **merge commit id** | （merge 後に `git log -1 --format=%H develop` で取得） |
| **merge 元ブランチ名** | feature/m2-members-required-columns |
| **変更ファイル一覧** | www/resources/js/admin/pages/MembersList.jsx |
| **テスト結果** | php artisan test — 66 passed |
| **ビルド結果** | npm run build — 成功 |
