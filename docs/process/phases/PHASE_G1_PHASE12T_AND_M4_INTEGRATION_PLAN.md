# Phase G1: phase12t と M4 UI suite の Git 整合 PLAN

| 項目 | 内容 |
|------|------|
| Phase ID | G1 |
| Name | phase12t と M4 Members UI の取り込み・REGISTRY 整合 |
| Type | implement (Git/docs 整合) |
| Related SSOT | ADMIN_UI_THEME_SSOT, MEMBERS_REQUIREMENTS |

---

## Purpose

1. **feature/phase12t-admin-theme-ssot-v1** を develop に安全に取り込み、Theme SSOT を反映する。
2. ローカルワークツリーに存在する **M4D〜M4L** の Members UI 改善を、1 本の feature ブランチ **feature/m4-members-ui-suite** にまとめ、develop に取り込める状態にする。
3. **PHASE_REGISTRY** および docs（INDEX, REPORT, Merge Evidence）の整合を修正する。

---

## Background

- phase12t は Theme SSOT 策定と Admin への Theme 適用を行うが、ブランチが merge-base（4efbd52）より古く、app.jsx / DragonFlyBoard.jsx が develop と大きく乖離している。DragonFlyBoard は develop 側の C-6/C-7/C-8・member_id・breakout を必ず残す必要がある。
- M4D〜M4L は PHASE_REGISTRY 上 completed だが、対応ブランチは origin に存在せず、変更は develop に未 merge。ローカルに実装と Phase ドキュメントが存在するため、1 本の feature にまとめて取り込む。

---

## Scope

- **変更可能:** Git 操作（merge, branch, commit, push）、docs/process/（PHASE_REGISTRY, INDEX, phases/*, REPORT の Merge Evidence）、www/resources/js/admin（Theme 適用・MembersList は M4 ブランチで扱う）。
- **変更禁止:** develop 側の DragonFlyBoard ロジック（C-6/C-7/C-8, member_id, breakout）の削除・上書き。勝手な rebase・branch 削除。

---

## Target Branches

| ブランチ | 役割 |
|----------|------|
| develop | 取り込み先。phase12t を先に merge、続けて M4 suite を merge。 |
| origin/feature/phase12t-admin-theme-ssot-v1 | Theme SSOT 取り込み元。no-ff merge。 |
| feature/m4-members-ui-suite | M4D〜M4L を 1 本にまとめたブランチ。develop から分岐し、M4 のみ commit して push。 |

---

## Target Files

**phase12t から取り込む（安全に）:**

- `www/resources/js/admin/theme/religoTheme.js`（新規）
- `ReligoLayout.jsx`: CssBaseline 追加のみ（develop に手で足すか、phase12t の該当部分のみ採用）
- `app.jsx`: `import { religoTheme } from './theme/religoTheme';` と `<Admin ... theme={religoTheme}>` のみ
- docs: ADMIN_UI_THEME_SSOT.md, PHASE12S_*, PHASE12T_*（必要なら INDEX に追加）

**phase12t から取り込まない:**

- `DragonFlyBoard.jsx` の実体（develop を 100% 維持）
- `app.jsx` の Resource/import 構造（MembersPlaceholder 等への差し替え禁止）
- package.json の @mui/lab は未使用のため必須でない（必要なら別途対応）

**M4 suite で扱う:**

- `www/resources/js/admin/pages/MembersList.jsx`（M4D〜M4L 実装）
- docs/process/phases/PHASE_M4D_* 〜 PHASE_M4L_*
- PHASE_REGISTRY の M4D〜M4L 行（branch を feature/m4-members-ui-suite に統一）
- INDEX の M4 関連リンク

---

## Implementation Strategy

1. **事前:** 作業ツリーの M4 変更を stash し、develop をクリーンな状態で phase12t を merge。
2. **phase12t merge:** conflict 時は DragonFlyBoard.jsx は develop 維持。app.jsx は develop 構造を維持し、theme と religoTheme の import のみ phase12t から取り込む。ReligoLayout は CssBaseline 追加。religoTheme.js を新規追加。
3. **検証:** `php artisan test` と `npm run build` で問題なしとする。
4. **M4 ブランチ:** stash pop 後、feature/m4-members-ui-suite を切り、M4 関連のみ add/commit/push。
5. **M4 merge:** develop に no-ff merge。競合がなければそのまま、あれば解決後に test/build → push。
6. **docs:** PHASE_REGISTRY に G1 追加、M4D〜M4L の branch を feature/m4-members-ui-suite に統一。INDEX と各 REPORT の Merge Evidence を更新。

---

## Tasks

| # | Task | 内容 |
|---|------|------|
| 1 | phase12t の安全 merge | develop を最新化 → no-ff merge → DragonFlyBoard は develop 維持、Theme のみ phase12t から。test/build。 |
| 2 | M4 UI suite 用 feature branch 作成 | feature/m4-members-ui-suite を現在の develop（phase12t merge 後）から作成。 |
| 3 | M4 実装の commit / push | M4 関連ファイルのみ add/commit、push origin feature/m4-members-ui-suite。 |
| 4 | M4 UI suite の develop 取り込み | no-ff merge、test/build、push origin develop。 |
| 5 | PHASE_REGISTRY 整合修正 | G1 追加、M4D〜M4L の branch を feature/m4-members-ui-suite に統一。completed を merge 済みとして読める状態に。 |
| 6 | INDEX / REPORT / Merge Evidence 更新 | G1 の REPORT、phase12t REPORT、M4D〜M4L の REPORT に Merge Evidence を反映。INDEX に G1 と必要 doc を追加。 |

---

## Risks

- **DragonFlyBoard 競合:** phase12t 側を採用すると C-6/C-7/C-8 等が消える。必ず develop 側を基準に解決する。
- **作業ツリーの汚れ:** 未コミット変更が多いため、stash → merge → stash pop の順で実施。pop 時に MembersList 等で競合する可能性あり。
- **M4 と無関係な変更の混入:** M4 ブランチには MembersList、M4D〜M4L の docs、REGISTRY/INDEX の M4 関連のみを含め、bootstrap/app.php や CSV インポート等は含めない。

---

## DoD

- [ ] phase12t が develop に no-ff merge され、DragonFlyBoard は develop 版のままであること。
- [ ] Admin に religoTheme が適用され、ReligoLayout に CssBaseline が入っていること。
- [ ] feature/m4-members-ui-suite が存在し、M4D〜M4L の実装と Phase ドキュメントが commit されていること。
- [ ] M4 suite が develop に merge され、php artisan test と npm run build が通っていること。
- [ ] PHASE_REGISTRY に G1 が追加され、M4D〜M4L の branch が feature/m4-members-ui-suite に統一されていること。
- [ ] INDEX および該当 REPORT に Merge Evidence が記載されていること。
