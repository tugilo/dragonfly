# Phase 273 PLAN: ウィークリープレゼン リテラシ配慮版へ差し替え

## Phase 情報

| 項目 | 内容 |
|------|------|
| Phase ID | 273 |
| Phase 種別 | implement |
| ブランチ | feature/phase273-weekly-presentation-plain |
| 開始 | 2026-06-28 09:20 JST |

## 背景・目的

木村杏那さん（建設業の業務改善パートナー）とウィークリープレゼンのターゲット・説明が重なり、メンバー・ビジターから見て「杏那さんに紹介するのか次廣に紹介するのか」が分かりにくい。
さらに、現行ウィークリー稿は「データベース」「Webシステム」などIT用語に寄っており、ITリテラシが高くない聞き手に伝わりにくい。

121履歴（[`1to1_kimura_anna_andirich.md`](../../meetings/1to1/1to1_kimura_anna_andirich.md) 第1回・第2回）では、競合ではなく **入口（現場に近い軽量改善）と深さ（本格システム化）で役割分担** する整理ができている。これを踏まえ、専門用語を使わず **症状（探す・書き写す・確認する）** で覚えてもらうウィークリー稿に差し替える。

## Related SSOT

- SPEC-004 Dashboard ウィークリープレゼン原稿表示（[`SSOT/DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md`](../../SSOT/DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md)）— ダッシュボードは `members.weekly_presentation_body` を表示
- [`strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md`](../../strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md) §2 ウィークリープレゼン（台本SSOT）
- [`meetings/1to1/1to1_kimura_anna_andirich.md`](../../meetings/1to1/1to1_kimura_anna_andirich.md)（木村杏那さんとの役割分担）

## Scope

- `docs/strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md`（§2.5 にリテラシ配慮版を追記・場面別ナビ調整）
- `www/database/sync/dragonfly.sql`（`members.id=37` の `weekly_presentation_body` 差し替え・db-export 結果）
- `docs/INDEX.md` / `docs/dragonfly_progress.md` / `docs/process/PHASE_REGISTRY.md`
- Phase 273 三点セット

アプリのコード（React/PHP）は変更しない。DBデータ（member 37 の原稿カラム）のみ更新する。

## DoD

- [ ] Intro Living Document §2.5 に「リテラシ配慮版（やさしい言葉・推奨ウィークリー）」を追記し、ダッシュボード採用稿であることを明記
- [ ] member id=37 の `weekly_presentation_body` を新稿へ更新（DB反映）
- [ ] `bin/db-export.sh` 相当で `www/database/sync/dragonfly.sql` を更新
- [ ] ダッシュボード API（GET /api/dashboard/weekly-presentation）で新稿が返ることを確認
- [ ] `php artisan test` 実行（implement フェーズ）
- [ ] INDEX / progress / PHASE_REGISTRY 同期、REPORT に Merge Evidence 記入

## 注意（要報告事項）

作業開始時点で develop 作業ツリーに、本Phaseと無関係な `www/database/sync/dragonfly.sql` の未コミット差分（`countries` Japan シード、複数 guest→member 区分変更、古屋周治の会社紐付け 等・2026-06-28 09:10 エクスポート分）が存在した。db-export は現DB全体を再生成するため、この差分も同ファイルに含まれる。commit/merge は本Phaseでは行わず、グルーピングはユーザー判断に委ねる。
