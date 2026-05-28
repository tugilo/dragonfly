# feature/* ブランチ棚卸しと develop 取り込み計画

**作成日:** 2026-03-10  
**前提:** merge は実行しない。整理と計画のみ。

---

## 1. feature/* ブランチ一覧（origin）

origin に存在する feature ブランチは **49 本**。一覧は以下（`git branch -r | grep 'origin/feature/'` の結果に相当）。

| # | ブランチ名 |
|---|------------|
| 1 | origin/feature/c6-c8-report-evidence-close |
| 2 | origin/feature/c6a-connections-intelligence-docs |
| 3 | origin/feature/c6b-connections-intelligence-impl |
| 4 | origin/feature/c6c-connections-intelligence-close |
| 5 | origin/feature/c7a-relationship-score-docs |
| 6 | origin/feature/c7b-relationship-score-impl |
| 7 | origin/feature/c7c-relationship-score-close |
| 8 | origin/feature/c8a-introduction-hint-docs |
| 9 | origin/feature/c8b-introduction-hint-impl |
| 10 | origin/feature/c8c-introduction-hint-close |
| 11 | origin/feature/connections-closeout-docs |
| 12 | origin/feature/dashboard-api-e1 |
| 13 | origin/feature/dashboard-data-ssot-e2 |
| 14 | origin/feature/dashboard-mock-align-close |
| 15 | origin/feature/dashboard-mock-align-docs |
| 16 | origin/feature/dashboard-mock-align-impl |
| 17 | origin/feature/dashboard-ui-api-e3 |
| 18 | origin/feature/e4-owner-settings-close |
| 19 | origin/feature/e4-owner-settings-docs |
| 20 | origin/feature/e4-owner-settings-impl |
| 21 | origin/feature/index-add-git-workflow |
| 22 | origin/feature/m1-members-gap-docs |
| 23 | origin/feature/m2-members-required-columns |
| 24 | origin/feature/m3-report-evidence-close |
| 25 | origin/feature/m3a-members-filter-sort-docs |
| 26 | origin/feature/m3b-members-filter-sort-ui |
| 27 | origin/feature/m3c-members-filter-sort-api |
| 28 | origin/feature/members-list-summary-v1 |
| 29 | origin/feature/members-mock-vs-ui-summary-docs |
| 30 | origin/feature/phase-mock-ui-verification-ssot |
| 31 | origin/feature/phase06-board-add-memo-v1 |
| 32 | origin/feature/phase07-board-add-1to1-v1 |
| 33 | origin/feature/phase08-auto-workspace-id-v1 |
| 34 | origin/feature/phase09-workspace-seed-and-test-v1 |
| 35 | origin/feature/phase10-breakout-room-builder-v1 |
| 36 | origin/feature/phase10r-breakout-rounds-v1 |
| 37 | origin/feature/phase11a-admin-menu-ia-v1 |
| 38 | origin/feature/phase11b-one-to-one-list-v1 |
| 39 | origin/feature/phase12-board-ux-refresh-v1 |
| 40 | origin/feature/phase12r-roadmap-ssot-v1 |
| 41 | origin/feature/phase12t-admin-theme-ssot-v1 |
| 42 | origin/feature/phase12u-board-3pane-ia-v1 |
| 43 | origin/feature/phase12v-members-meetings-list-v1 |
| 44 | origin/feature/phase12w-board-shortcut-v1 |
| 45 | origin/feature/phase16b-admin-ui-mock-sync-v1 |
| 46 | origin/feature/phase16c-settings-crud-and-member-actions-v1 |
| 47 | origin/feature/phase17a-member-drawer |
| 48 | origin/feature/readme-and-branching |
| 49 | origin/feature/relationship-log-create-v1 |

**補足:** PHASE_REGISTRY に記載の `feature/m4d-members-list-card` ～ `feature/m4l-members-to-connections-nav` および `feature/phase001-devos-setup` は **origin に存在しない**。これらはローカルのみで push されていないか、別の運用で develop に取り込まれている。

---

## 2. develop 未取り込みブランチ一覧

**origin 上で develop に未マージの feature ブランチは 1 本のみ。**

| ブランチ | develop との差分 |
|----------|------------------|
| **origin/feature/phase12t-admin-theme-ssot-v1** | 1 commit 先行 |

**ローカルのみ（origin に未 push）で develop 未マージ:**

| ブランチ | 備考 |
|----------|------|
| feature/phase13-remove-round | ローカルのみ。refactor: remove round concept introduce BO structure |

上記以外の 48 本の origin/feature/* は、いずれも **develop にすでに取り込まれている**（`git branch -r --merged develop` で確認済み）。

---

## 3. Phase 対応表

**docs/process/PHASE_REGISTRY.md の内容（抜粋）**

| Phase ID | Name | Type | Status | Branch（REGISTRY 記載） | origin に存在するか |
|----------|------|------|--------|-------------------------|----------------------|
| 001 | DevOS Setup | docs | completed | feature/phase001-devos-setup | 否 |
| M4D | Members List/Card 表示切替 | implement | completed | feature/m4d-members-list-card | 否 |
| M4E | Members Card 関係ログ表示 | implement | completed | feature/m4e-members-card-logs | 否 |
| M4F | Members 一覧かな表示 | implement | completed | feature/m4f-members-name-kana | 否 |
| M4G | Members 大カテゴリ単独フィルタ追加 | implement | completed | feature/m4g-members-group-filter | 否 |
| M4H | Members Card Relationship Score 表示 | implement | completed | feature/m4h-members-card-relationship-score | 否 |
| M4I | Members デフォルト表示を Card に変更 | implement | completed | feature/m4i-members-default-card | 否 |
| M4J | Members FilterBar 改善 | implement | completed | feature/m4j-members-filterbar-improvement | 否 |
| M4K | Members Card向け並び順の強化 | implement | completed | feature/m4k-members-card-sort-improvement | 否 |
| M4L | Members から Connections への導線強化 | implement | completed | feature/m4l-members-to-connections-nav | 否 |

**origin に存在する主な feature と Phase の対応（develop にすでに merge 済みのもの）**

| ブランチ | 想定 Phase | Type | develop 取り込み |
|----------|------------|------|-------------------|
| feature/m1-members-gap-docs | M-1 | docs | 済 |
| feature/m2-members-required-columns | M-2 | implement | 済 |
| feature/m3a-members-filter-sort-docs 等 | M-3 | docs/implement | 済 |
| feature/m4a-members-layout-docs 等 | M-4a/b/c | docs/implement | 済 |
| feature/m5a-members-flag-edit-docs 等 | M-5 | docs/implement | 済 |
| feature/m6a-member-show-docs 等 | M-6 | docs/implement | 済 |
| feature/c6a-connections-intelligence-docs 等 | C-6 | docs/implement | 済 |
| feature/c7a-relationship-score-docs 等 | C-7 | docs/implement | 済 |
| feature/c8a-introduction-hint-docs 等 | C-8 | docs/implement | 済 |
| feature/phase12t-admin-theme-ssot-v1 | 12T | implement + docs | **未** |

---

## 4. 依存関係があるブランチの順序

**Members 系（M4D～M4L）**

- PHASE_REGISTRY 上の順序:  
  **M4D → M4E → M4F → M4G → M4H → M4I → M4J → M4K → M4L**
- 依存理由: いずれも MembersList.jsx / Members 周りを扱い、List/Card 切替（M4D）→ Card 関係ログ（M4E）→ かな表示（M4F）→ 大カテゴリフィルタ（M4G）→ Card Relationship Score（M4H）→ デフォルト Card（M4I）→ FilterBar 改善（M4J）→ 並び順強化（M4K）→ Connections 導線（M4L）と、前の Phase の UI/データの上に次の Phase が乗る。
- **注意:** 上記ブランチ名（feature/m4d-* 等）は origin に存在しない。develop には M-4a/b/c, M-5, M-6 までが merge 済み。M4D～M4L に相当する作業が develop に別経路で入っている可能性があるため、REGISTRY と実ブランチの対応は要確認。

**origin で未マージの phase12t**

- Phase 12S（Board MUI Polish）の後、Theme SSOT を導入する 12T。develop に 12S が含まれていれば、phase12t は **単独で merge 可能**（他 feature への依存は名前上なし）。

---

## 5. 単独 merge 可 / 順番必要 / 保留 の分類

**A. 単独で安全に merge できる**

| ブランチ | 理由 |
|----------|------|
| **origin/feature/phase12t-admin-theme-ssot-v1** | 1 commit のみ。Theme SSOT 追加と Theme 適用。develop に 12S が含まれている前提で単独で取り込み可能。 |

**B. 順番に merge すべき依存あり**

- **origin 上には該当なし。**  
- （PHASE_REGISTRY の M4D～M4L はブランチが origin にないため、取り込み順の対象外。）

**C. 保留（競合・未完成・要確認）**

| ブランチ | 理由 |
|----------|------|
| **feature/phase13-remove-round**（ローカルのみ） | origin に未 push。BO の round 概念削除の refactor。develop の現状（phase10r 等）との整合・テスト要確認。 |

---

## 6. 推奨マージ順（バッチ単位）

- **第1バッチ（origin で未マージの 1 本）**  
  - `feature/phase12t-admin-theme-ssot-v1`  
  - 内容: Admin Theme SSOT 策定と Theme 適用（ReligoLayout, app.jsx, DragonFlyBoard.jsx, religoTheme.js, docs）。  
  - 手順: `git checkout develop && git pull origin develop` のあと、`git merge --no-ff origin/feature/phase12t-admin-theme-ssot-v1 -m "Merge feature/phase12t-admin-theme-ssot-v1 into develop"`。必要なら `php artisan test` / `npm run build` を実行してから `git push origin develop`。

- **第2バッチ（保留・要確認）**  
  - `feature/phase13-remove-round`  
  - 対応: まず origin に push するかどうか、および develop との diff・テスト結果を確認してから取り込み可否を判断する。

- **第3バッチ（docs / 安全な単独ブランチ）**  
  - **該当なし。** 上記以外の origin/feature/* はすでに develop にマージ済み。

- **第4バッチ（Members 系 M4D～M4L）**  
  - **origin にブランチが存在しない**ため、現時点の「origin の feature 棚卸し」のマージ対象外。  
  - これらが別ブランチ名で存在する場合や、develop に直接コミットされている場合は、REGISTRY と git log の突き合わせで取り込み済みかどうかを別途確認する必要あり。

---

## 7. 注意点

- **競合しそうなファイル**  
  - **phase12t:** `www/resources/js/admin/pages/DragonFlyBoard.jsx`（348 行変更）、`www/resources/js/admin/ReligoLayout.jsx`、`www/resources/js/admin/app.jsx`、新規 `www/resources/js/admin/theme/religoTheme.js`。develop 側で同じファイルを別 feature で変更していなければ競合は起きにくいが、merge 前に `git merge --no-commit --no-ff origin/feature/phase12t-admin-theme-ssot-v1` で確認推奨。

- **先に確認すべき点**  
  1. **phase12t:** develop に Phase 12S（Board MUI Polish）が含まれているか。含まれていれば 12T はその延長として取り込み可能。  
  2. **M4D～M4L:** PHASE_REGISTRY の「Branch」に記載の feature/m4d-* ～ feature/m4l-* が、別名で push されているか、または develop に直接入っているかを `git log develop --oneline --all --grep="M4D\|M4E\|List/Card\|FilterBar\|導線"` 等で確認するとよい。  
  3. **phase13:** round 削除が develop の breakout/round 系と矛盾しないか、テストとコードレビューで確認してから取り込み判断する。

- **merge は実行しない**  
  - 本ドキュメントは「整理と計画」のみ。実際の `git merge` / `git push` は行わない。

---

## 実行コマンド例（参照用・実行しない）

```bash
# develop を最新化
git checkout develop
git pull origin develop

# 第1バッチ（phase12t のみ）
git merge --no-ff origin/feature/phase12t-admin-theme-ssot-v1 -m "Merge feature/phase12t-admin-theme-ssot-v1 into develop"
# 必要に応じて
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test
cd www && npm run build
git push origin develop
```
