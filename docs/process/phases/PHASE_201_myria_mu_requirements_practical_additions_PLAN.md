# PHASE_201_myria_mu_requirements_practical_additions PLAN

## Phase Type
docs

## Purpose
Myria-mu 外構紹介管理プラットフォーム要件定義書に、Laravelでの設計・開発時に後から困りにくい実践的な要件を追加する。

## Background
ユーザーから、要件定義書の完成度は高いが、施工店ステータス、案件履歴、施工店評価、イラスト制作管理、施工店候補テーブル、NPSアンケート項目を追加すると、150〜180万円規模の要件定義としてより実践的になるとの指示があった。

## Related SSOT
SPEC-013 1 to 1 事前準備（NCAS/PDF 添付・テキスト化・AI 原稿生成・BYO key）

補足: 本成果物は Religo 本体仕様ではなく、西浦雅さんとの相談記録を元にしたクライアント向け要件定義書である。

## Scope
docs のみ変更する。アプリ実装、DB変更、外部サービス連携調査、見積金額の契約確定は行わない。

## Target Files
- docs/requirements/myria_mu_exterior_referral_system_requirements.md
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_201_myria_mu_requirements_practical_additions_PLAN.md
- docs/process/phases/PHASE_201_myria_mu_requirements_practical_additions_WORKLOG.md
- docs/process/phases/PHASE_201_myria_mu_requirements_practical_additions_REPORT.md

## Implementation Strategy
要件定義書の営業色は増やさず、実装時に必要となる状態・履歴・集計・関連テーブルを追加する。施工店ステータス、案件履歴、施工店対応エリアテーブル、施工店評価指標、イラスト制作ステータス、NPS項目を機能要件・データ要件・スコープへ反映する。

## Tasks
- [x] 施工店ステータスを追加する
- [x] 案件履歴要件とデータ構造を追加する
- [x] 施工店評価指標のデータ構造を追加する
- [x] イラスト制作管理と `illustration_status` を追加する
- [x] `contractor_service_areas` 前提の施工店候補テーブルを追加する
- [x] 顧客アンケートにNPS相当項目を追加する
- [x] INDEX / progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する

## DoD
- 施工店ステータス（審査中 / 有効 / 一時停止 / 解約）が定義されている
- 案件履歴が「誰がいつ何を変更したか」を追跡できる要件として定義されている
- 施工店評価指標（契約件数 / 契約率 / 平均満足度）が定義されている
- イラスト制作ステータス（未依頼 / 制作待ち / 制作中 / 送付済）が定義されている
- `contractor_service_areas` 相当の対応エリアデータ構造が定義されている
- 顧客アンケートに「施工店を知人に勧めたいですか？」のNPS相当項目が追加されている
- 初期スコープとスコープ外の整合が取れている
