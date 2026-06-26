# Phase 254 PLAN: 竹村裕司 第1回121 Zoom要約反映

## Phase Overview

| Item | Value |
|------|-------|
| Phase ID | 254 |
| Name | takemura_yuji_onode_121 |
| Phase Type | docs |
| Status | completed |
| Started At | 2026-06-26 10:12 JST |
| Branch | develop（commit / merge 未実施） |

## Purpose

2026-06-26 JST 09:00-10:00 に実施された竹村裕司さんとの第1回121について、ユーザー提供のZoom文字起こし要約をもとに、1to1シリーズ文書として保存する。

芳賀崇利さん紹介ゲストとして参加し、2026-07-07からDragonFlyメンバー予定であること、元大阪GaiYenチャプターのメンバー、株式会社ONODE 代表取締役、ゲスト登録カテゴリーのプロモーション動画制作、121で共有されたチアプリント、次廣とのReligo / 予約管理 / AI開発 / マーケティング協業余地を整理する。

## Related SSOT

| Spec ID | File | Relevance |
|---------|------|-----------|
| SPEC-006 | `docs/SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md` | 1to1相手・チャプター文脈の扱い |
| SPEC-012 | `docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md` | Zoom由来の1to1要約を履歴化する方針 |
| SPEC-019 | `docs/SSOT/ONETOONE_MULTI_SESSION_IMPORT_REQUIREMENTS.md` | 1相手1ファイル・複数セッション管理方針 |
| — | `docs/meetings/1to1/README.md` | 1to1文書の命名・front matter・DB取り込み運用 |
| — | `docs/PROJECT_NAMING.md` | Religo / DragonFly / dragonfly の命名区別 |

## Scope

### In Scope

- `docs/meetings/1to1/1to1_takemura_yuji_onode.md` の新規作成
- 2026-06-26 09:00-10:00 の第1回121要約反映
- DragonFlyゲストプロフィール、アンケート、対応履歴の反映
- チアプリント、株式会社ONODE、プロモーション動画制作、Dリーグ・ダンス業界接点、相互協力・リファーラル戦略の整理
- `docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md` の同期
- Phase 254 の PLAN / WORKLOG / REPORT 作成

### Out of Scope

- Religo DB への取り込み
- `www/` 配下の実装変更
- 竹村さんの正式プロフィール・NCAS情報の追加調査
- チアプリント公式資料の外部調査

## DoD

- 竹村裕司さんとの第1回121が、1to1シリーズ文書として時刻付きで保存されている。
- チアプリントの強み、ONODE事業、BNI登録方針、DragonFlyゲストプロフィール、次廣との協業余地、Action Items が後から参照できる形で整理されている。
- docs変更に合わせて INDEX / progress / PHASE_REGISTRY が同期されている。
- docsフェーズのためテストはスキップし、その理由を REPORT に記録する。

## Tasks

- [x] 既存1to1 README・テンプレート・INDEXを確認する
- [x] Phase 254 PLAN / WORKLOG / REPORT を作成する
- [x] 竹村裕司さん用 1to1 シリーズ文書を作成する
- [x] 前回ゲストプロフィール・アンケート・対応履歴を追記する
- [x] INDEX / progress / PHASE_REGISTRY を同期する

## Risks / Notes

- チアプリント英字表記は未確認のため TODO とする。
- Religo `one_to_ones.id` は未確認のため TODO とし、DB取り込みは今回スコープ外とする。
- 2026-07-07 入会後、NCAS情報や正式カテゴリーが確認できたら本文とYAMLを更新する。
