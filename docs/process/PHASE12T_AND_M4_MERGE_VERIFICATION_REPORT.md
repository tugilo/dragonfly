# phase12t 取り込み可否 および M4D〜M4L Git 実態 最終確認報告

**作成日:** 2026-03-10  
**前提:** merge / push は未実行。確認と報告のみ。

---

## 1. phase12t 最終確認結果

### 1.1 develop との差分ファイル

`git diff --name-only develop...origin/feature/phase12t-admin-theme-ssot-v1` の結果（主要なもの）:

| 種別 | ファイル |
|------|----------|
| docs | docs/INDEX.md, docs/dragonfly_progress.md, docs/SSOT/ADMIN_UI_THEME_SSOT.md, docs/process/phases/PHASE12S_*, PHASE12T_* |
| フロント | www/resources/js/admin/ReligoLayout.jsx, app.jsx, pages/DragonFlyBoard.jsx, theme/religoTheme.js（新規） |
| パッケージ | www/package.json, www/package-lock.json |

**注意:** 三項 diff（develop...phase12t）のため、phase12t が **触っていない** が develop で追加されたファイル（例: MembersList.jsx）は「phase12t 側に存在しない」として差分に現れる。phase12t の 1 コミットで変更しているのは上記の 15 ファイルのみ。

### 1.2 直近コミット

- **phase12t 先端:** `54acc2a ui: establish Religo admin theme SSOT and apply globally`
- **phase12t の 1 コミットで変更したファイル:**  
  docs（INDEX, progress, ADMIN_UI_THEME_SSOT, PHASE12S/12T 関連）, www/package*.json, ReligoLayout.jsx, app.jsx, DragonFlyBoard.jsx, theme/religoTheme.js（新規）

### 1.3 競合しそうなファイル

- **DragonFlyBoard.jsx**  
  - phase12t は merge-base（4efbd52）時点の Board に Theme 適用のみ行っている。  
  - develop は 4efbd52 以降に C-6/C-7/C-8（Relationship Summary, Relationship Score, Introduction Hint）、member_id クエリ、breakout-rounds 等を追加済み。  
  - **merge 時に競合が発生する可能性が高い。** 解決時に develop 側のロジックを残し、Theme 適用だけ取り込む必要あり。
- **ReligoLayout.jsx, app.jsx**  
  - Theme の import / 適用の差分。同一箇所を両方で触っていれば競合しうる。
- **docs/INDEX.md, docs/dragonfly_progress.md**  
  - 内容のずれで競合しうる（マージ時は develop を優先しつつ 12T の追記を反映する形が無難）。

### 1.4 docs only か implement か

- **implement + docs.**  
  - 実装: religoTheme.js 新規、ReligoLayout.jsx / app.jsx / DragonFlyBoard.jsx の Theme 適用。  
  - ドキュメント: ADMIN_UI_THEME_SSOT.md、PHASE12S/12T の PLAN/WORKLOG/REPORT。

### 1.5 php artisan test / npm run build

- **implement を触っているため、merge 解決後に両方実行推奨.**  
  - `php artisan test`  
  - `cd www && npm run build`

### 1.6 今すぐ merge 候補として安全か

- **条件付きで可。そのまま fast-forward は危険。**  
  - DragonFlyBoard.jsx で競合が起きる想定。  
  - 解決時は **develop 側の C-6/C-7/C-8 および member_id・breakout 周りを維持** し、Theme 関連の変更だけ phase12t から取り込む必要あり。  
  - MembersList.jsx は phase12t が触っていないため、merge で消えることはない（develop のまま残る）。

---

## 2. M4D〜M4L の Git 実態確認結果

### 2.1 PHASE_REGISTRY の branch 名

| Phase ID | Branch（REGISTRY 記載） |
|----------|--------------------------|
| M4D | feature/m4d-members-list-card |
| M4E | feature/m4e-members-card-logs |
| M4F | feature/m4f-members-name-kana |
| M4G | feature/m4g-members-group-filter |
| M4H | feature/m4h-members-card-relationship-score |
| M4I | feature/m4i-members-default-card |
| M4J | feature/m4j-members-filterbar-improvement |
| M4K | feature/m4k-members-card-sort-improvement |
| M4L | feature/m4l-members-to-connections-nav |

### 2.2 origin にその branch が存在するか

- **すべて origin に存在しない.**  
  - `git branch -r | grep -E 'm4[d-l]'` → 該当なし。  
  - 存在するのは `origin/feature/phase12t-admin-theme-ssot-v1` のみ（M4 以外）。

### 2.3 develop の git log に該当変更が入っているか

- **develop（ローカル）:**  
  - MembersList.jsx を触っている直近は M-6b, M-5b, M-4b, M-3b, M-2, phase17a, phase16c, phase16b, Phase12V。  
  - いずれも「M4D」「M4E」等のブランチ名や Phase ID では出てこない。  
- **origin/develop:**  
  - ローカル develop より古い（81d2aa0）。MembersList.jsx は 627 行で、ViewMode/Card/Relationship Score 等の M4 機能は含まれていない。  
- **結論:** M4D〜M4L に相当する **merge commit は develop の log にない**。別名ブランチの merge も確認できず。

### 2.4 変更ファイル（MembersList.jsx, DragonFlyBoard.jsx）に反映済みか

- **develop 上の MembersList.jsx（git show develop: で確認）:**  
  - 827 行。  
  - `ViewModeContext`, `MembersCardGrid`, `viewMode === 'card'`, `relationshipScoreFromSummaryLite`, `RELATIONSHIP_SCORE_STARS`, `/connections?member_id=` 等の M4 機能は **含まれていない**（grep で 0 件）。  
  - あるのは Datagrid、MembersFilterBar、Connections ヘッダボタン等（M-4b 以降の範囲）。  
- **DragonFlyBoard.jsx（develop）:**  
  - `member_id`（searchParams）、Relationship Score、Introduction Hint 等は **develop 側に存在**（C-6/C-7/C-8 で入ったもの）。  
- **結論:**  
  - **MembersList.jsx:** M4D〜M4L の機能は **develop 上には反映されていない**。  
  - **DragonFlyBoard.jsx:** member_id 受け取り等は develop にあり、M4L の「Connections 導線」の受け側は実装済み。

### 2.5 completed = merge 済みと見て問題ないか

- **問題あり.**  
  - REGISTRY の「completed」は「REPORT 完了・merge 済み」を指すが、  
  - M4D〜M4L のブランチは origin に存在せず、develop の history にも該当 merge がなく、  
  - **develop 上の MembersList.jsx に List/Card 切替・Card ログ・かな・大カテゴリフィルタ・Relationship Score・Card デフォルト・FilterBar 改善・Card 並び順・Connections 導線は入っていない。**  
  - したがって「merge 済み」とは言えず、**C. 見直しが必要** と判断する。

---

## 3. 変更実体ベースの確認（Step3）

### 3.1 MembersList.jsx（develop コミット版）

| 確認観点 | develop 上の有無 |
|----------|------------------|
| List/Card 切替 | なし（ViewModeContext / List・Card ボタンなし） |
| Card 関係ログ | なし（CARD_LOGS_LIMIT / カード内メモ・1to1 表示なし） |
| かな表示 | なし（name_kana 表示なし） |
| 大カテゴリ単独フィルタ | あり（MembersFilterBar で group_name 等は M-3/M-4 で存在） |
| Relationship Score | なし（Card 内スコア・RELATIONSHIP_SCORE_STARS なし） |
| Card デフォルト | なし（useState('card') なし、Datagrid のみ） |
| FilterBar 改善 | あり（FilterBar は存在、M4J レベルかは未突き合わせ） |
| Card 向け並び順 | なし（displaySortKey / Card 用ソートなし） |
| Connections 導線 | ヘッダの「Connectionsへ」のみ（カード内「Connections で見る」/ member_id 付きリンクなし） |

※ 上記は **git show develop:www/resources/js/admin/pages/MembersList.jsx** および grep による確認に基づく。  
※ **ワークツリーの MembersList.jsx（1111 行）** には上記 M4 機能が含まれている（grep で 12 件）。develop に commit されていない別作業（ローカル or 他ブランチ）の状態と考えられる。

### 3.2 DragonFlyBoard.jsx（develop）

- **member_id 受け取り:** あり。`useSearchParams()` と `searchParams.get('member_id')` で URL から取得し、Connections 導線の受け側として利用されている。

---

## 4. completed のままでよい Phase（A / B）

- **A. develop に反映済みで completed のままでよい:** 該当なし（M4D〜M4L は develop の MembersList に未反映）。  
- **B. branch はないが develop 反映済みなので completed のままでよい:** 該当なし。

※ DragonFlyBoard の member_id は develop にあるが、これは C-6/C-7/C-8 等の Connections 系で入ったもので、M4L の「Members 側の導線」は develop の MembersList には入っていない。

---

## 5. 見直しが必要な Phase（C）

- **M4D, M4E, M4F, M4G, M4H, M4I, M4J, M4K, M4L のすべて（C）**  
  - 理由:  
    - 記載ブランチは origin に存在しない。  
    - develop の git log に該当 merge がなく、MembersList.jsx の実体にも M4D〜M4L の機能が入っていない。  
  - REGISTRY の「completed」は「REPORT 完了・merge 済み」だが、現状は「merge 済み」を満たしていない。  
  - 対応案:  
    - 実際に M4D〜M4L を develop に merge する予定があるなら、該当作業をブランチにまとめて merge したうえで、REGISTRY の branch / 日付を実態に合わせる。  
    - もしくは、REGISTRY の Status を「completed」のまま「merge 済み」ではなく「作業完了（未 merge / ローカルのみ）」のような注釈を付ける、または branch 列を「—」等にして「origin にブランチなし」を明示する。

---

## 6. 次に実行すべき作業（merge / push はまだ行わない）

1. **phase12t について**  
   - develop を最新化したうえで `git merge --no-ff origin/feature/phase12t-admin-theme-ssot-v1` を実行。  
   - **DragonFlyBoard.jsx のコンフリクト**を解消する際は、develop 側の C-6/C-7/C-8 および member_id・breakout 周りを残し、Theme（religoTheme の適用・import 等）だけ phase12t から取り込む。  
   - 解消後に `php artisan test` と `npm run build` を実行。  
   - 問題なければ REPORT に Merge Evidence を記載し、`git push origin develop`（本報告ではまだ実行しない）。

2. **M4D〜M4L について**  
   - REGISTRY と実態のずれをどう扱うか方針を決める（「merge 済み」と見なさず branch 列を空にする、注釈を足す、または該当作業を改めて develop に取り込んでから REGISTRY を更新する等）。  
   - ワークツリーに M4 機能が含まれた MembersList.jsx がある場合、その変更をどのブランチにどのタイミングで commit/merge するか整理する。

---

## 7. 注意点

- **phase12t:**  
  - merge 時に DragonFlyBoard.jsx で競合する可能性が高い。phase12t 側をそのまま採用すると、develop の Relationship Summary / Score / Introduction Hint / member_id 受け取り等が消えるため、**必ず develop 側を基準に解決すること。**  
- **M4D〜M4L:**  
  - REGISTRY 上はすべて completed だが、Git 上は merge されておらず、develop の MembersList.jsx にその機能はない。  
  - 運用上「completed = 作業完了（未 push/未 merge 含む）」としている場合は、REGISTRY の説明または branch 列でそれを明示した方がよい。  
- **ローカルと origin の develop:**  
  - 確認時点で origin/develop (81d2aa0) はローカル develop (ab21ad0) より古い。merge/push 前には `git pull origin develop` で最新化すること。  
- 本報告では **merge も push も行っていない。**
