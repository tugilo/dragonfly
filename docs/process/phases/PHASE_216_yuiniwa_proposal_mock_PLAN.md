# PHASE_216_yuiniwa_proposal_mock PLAN

## Phase Type
implement

## Purpose
YUINIWA（株式会社Myria-mu）の初期導入版提案書を元に、西浦さんとの商談で見せられるクリッカブルなHTMLモックを作成する。

## Background
ユーザーから「モックは作れるか」との依頼があり、作成範囲を確認した結果、以下に決定した。
- 範囲: 1画面に主要要素を詰めた概要モック（商談用の雰囲気重視）
- 形式: プロジェクト流儀で `www/public/mock/` に静的HTML（既存 religo モックと同じ場所）
- 操作感: タブ切替で画面遷移するクリッカブルモック

## Related SSOT
SPEC-013 1 to 1 事前準備（NCAS/PDF 添付・テキスト化・AI 原稿生成・BYO key）

補足: 本成果物は Religo 本体仕様ではなく、YUINIWA 提案用の静的モックである。根拠は初期導入版提案書。

## Scope
`www/public/mock/` への静的HTMLモック追加と、docs の Phase 記録・INDEX・progress 更新のみ。アプリ実装（PHP/React）、DB変更、ルーティング追加、ビルドは行わない。

## Target Files
- www/public/mock/yuiniwa-proposal-mock.html
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_216_yuiniwa_proposal_mock_PLAN.md
- docs/process/phases/PHASE_216_yuiniwa_proposal_mock_WORKLOG.md
- docs/process/phases/PHASE_216_yuiniwa_proposal_mock_REPORT.md

## Implementation Strategy
単一HTMLファイルで、上部タブにより4ビューを切り替えるクリッカブルモックを作成する。
- Myria-mu管理ダッシュボード（KPI・案件一覧・流入元）
- 案件詳細（施工店候補・契約・完了報告・アンケート・イラスト・報酬）
- 施工店ポータル（担当案件・契約登録・完了報告）
- インフルエンサーマイページ（成果・報酬・支払状況）
JSは素のshow/hide切替のみ。外部依存なし。YUINIWAらしい柔らかいグリーン系デザイン。

## Tasks
- [x] 作成範囲をユーザーに確認する
- [ ] クリッカブルモックHTMLを作成する
- [ ] INDEX / progress / PHASE_REGISTRY を更新する
- [ ] WORKLOG / REPORT を作成する

## DoD
- `www/public/mock/yuiniwa-proposal-mock.html` が単体で開ける
- タブで Myria-mu管理 / 案件詳細 / 施工店 / インフルエンサー を切り替えられる
- 初期導入版提案書の範囲（問い合わせ〜契約〜完了報告〜アンケート〜写真〜イラスト〜報酬）が画面として表現されている
- 外部依存なしで動作する
- docs/INDEX.md と docs/dragonfly_progress.md と docs/process/PHASE_REGISTRY.md が更新されている
