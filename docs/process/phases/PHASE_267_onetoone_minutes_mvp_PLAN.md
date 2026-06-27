# Phase 267 PLAN — 1to1 Minutes MVP（SPEC-020 Phase F）

**作成:** 2026-06-27 12:13 JST  
**Phase Type:** implement  
**Branch:** `feature/phase267-onetoone-minutes-mvp`  
**Related SSOT:** SPEC-020 §5.1 / §8 / §9（MVP）/ §11.6 順位 11 / §11.8 Phase F（[ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md](../../SSOT/ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md)）  
**Status:** completed  

---

## Purpose

SPEC-020 の MVP（順位 11）を実装する。各メンバーが **自分の 1to1 実施後記録**を、要約のコピペで `notes` に保存できるようにする。owner はサーバ（Phase 263）・UI 双方で本人固定とし、一覧/編集は本人分のみ（Phase 263 / 265 で確立済み）。

- **コピペ取込（§5.1 Must）:** Zoom / Meet / My Notes / 手書き要約をテキストエリアに貼り付け → `notes` に保存。
- **owner 固定（§10 DoD）:** 一般 member は Create / Edit の Owner 欄を変更不可。
- **本人スコープ:** 一覧・取得・編集は本人の owner のみ（既存サーバ強制を UI でも崩さない）。

---

## 設計

- MVP のデータ保存先は既存 `one_to_ones.notes`（新規列 `raw_summary` は P1 / Phase G）。`notes` は Markdown 表示・プレビュー対応済み。
- `OneToOnesCreate` / `OneToOnesEdit` から `OneToOneFormFields` に `ownerInputDisabled={!isChapterAdmin}` を渡し、member は Owner 欄を disabled・validate 解除（初期値＝自分の owner）。
- Create は `suppressCreateOwnerHint={!isChapterAdmin}` で「別メンバーで記録」案内を member には出さない。
- `notes` の label / helperText を「実施後記録・要約コピペ可」と明示し、入力ハードルを下げる。
- バックエンドは Phase 263（owner 403 強制）で完了済みのため非変更。

---

## Scope

### 変更可

| 領域 | ファイル |
|------|----------|
| Create | `www/resources/js/admin/pages/OneToOnesCreate.jsx` |
| Edit | `www/resources/js/admin/pages/OneToOnesEdit.jsx` |
| Form | `www/resources/js/admin/pages/OneToOneFormFields.jsx` |
| Docs | `PHASE_267_*`、`PHASE_REGISTRY.md`、`INDEX.md`、`dragonfly_progress.md` |

### 変更しない

- バックエンド API（owner / role 強制は Phase 263/264 で完了）
- `raw_summary` / `summary_source` 列（Phase G）
- AI 校正 / Zoom 要約取得（Phase H / I）

---

## DoD

- [ ] member は Create / Edit で Owner 欄を変更できない（自分固定）
- [ ] member が要約をコピペ → `notes` 保存できる（label / helper で明示）
- [ ] admin は従来どおり owner を選んで記録できる
- [ ] `npm run build` 成功
- [ ] 既存 `php artisan test` 全 pass（バックエンド非変更の回帰確認）

---

## Tasks

| # | Task | 完了条件 |
|---|------|----------|
| 1 | Create で owner 固定 | member は disabled |
| 2 | Edit で owner 固定 | member は disabled |
| 3 | notes label / helper 明示 | コピペ・実施後記録を明記 |
| 4 | `npm run build` | 成功 |
| 5 | `php artisan test` | 全 pass |

---

## リスク

- MVP は `notes` 直保存のため、原文と整形後を分離しない（P1/Phase G で `raw_summary` を導入予定）。
- owner 固定は UI 側の利便性目的。実体の防御はサーバ（Phase 263）で担保済み。
