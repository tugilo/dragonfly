# Phase 317 PLAN — 国宝社 第4回121反映 改訂提案・機能別見積・構成図・基本設計・仕様・スケジュール

**作成:** 2026-10-10 07:19 JST  
**Phase Type:** docs  
**Branch:** 作業ツリー未分離（現在 `feature/phase315-okamoto-sorosoro-concept-prep` 上。commit 時に develop から切り直し可）  
**Related SSOT:** `docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md`（第4回 2026-10-05 19:00–19:40）、`docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha_requirements_20260529.md`、`docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha_requirements_20260826.md`、`docs/PROJECT_NAMING.md`

---

## Purpose

第4回121で合意した内容（Oracle 直接書き込み → **補助DB → CSV → VB 側取り込み**、2機能、ルールベース自動配置、メール添付 Excel は手動登録から、10〜12月開発・1月並行テスト・2月検収）と、木村さんから 2026-10-10 に受領した3点（開発会社の「注文データ取込プログラム ご要望事項イメージ図」2026-09-29、生産依頼表 Excel テンプレート、判型リスト・一覧シート）をもとに、提出用の文書一式を **提案書 → 機能別見積 → システム構成図 → 基本設計書 → 仕様書 → スケジュール表** の順で作る。

---

## Scope

- `docs/proposals/木村さん用/注文データ取込プログラム_要望事項イメージ図_20260929.pdf`（受領）
- `docs/proposals/木村さん用/生産依頼表_Excelテンプレート_20261010.png`（受領）
- `docs/proposals/木村さん用/判型リスト_20261010.png`（受領）
- `docs/proposals/木村さん用/生産依頼表_一覧シート_20261010.png`（受領）
- `docs/proposals/木村さん用/README.md`
- `docs/proposals/kimura_kokuhosha_proposal_v3_20261010.md`（改訂提案書）
- `docs/proposals/kimura_kokuhosha_estimate_v3_20261010.md`（機能別見積・必須／あれば便利）
- `docs/proposals/kimura_kokuhosha_system_architecture_20261010.md`（システム構成図）
- `docs/proposals/kimura_kokuhosha_basic_design_20261010.md`（基本設計書）
- `docs/proposals/kimura_kokuhosha_specification_20261010.md`（仕様書）
- `docs/proposals/kimura_kokuhosha_schedule_20261010.md`（スケジュール表）
- `docs/proposals/kimura_kokuhosha_{proposal_v3,estimate_v3,system_architecture,basic_design,specification,schedule}_slides_20261011.html`（6文書の HTML スライド。2026-10-11 追加依頼）
- `docs/proposals/kimura_kokuhosha_{同上}_slides_20261011.pdf`（提出用 PDF。2026-10-12 追加依頼）
- `docs/proposals/木村さん用/助成金専門家_開発会社を確認するときの観点_花村_20261013_v1.pdf`（2026-10-14 受領）
- `docs/proposals/kimura_kokuhosha_subsidy_consultant_checklist_response_20261014.md`（25観点への回答案。2026-10-14 追加）
- `docs/proposals/kimura_kokuhosha_v3_change_memo_ai_20261014.{md,html,pdf}`（v3 からの変更点メモ・予定表への AI 組み込み。2026-10-14 追加）
- `docs/proposals/kimura_kokuhosha_checklist_answers_20261014.{html,pdf}`（25項目回答一覧 外部向け。2026-10-14 追加）
- `docs/proposals/README.md`
- `docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md`（第4回アクションの状態更新・成果物リンク）
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_317_kimura_kokuhosha_proposal_v3_{PLAN,WORKLOG,REPORT}.md`

---

## DoD

- 提案書: 第4回の決定事項（CSV 連携・2機能・ルールベース自動配置・Excel 手動登録から・予定表の出力と印刷は作らない）を本文に反映し、7月提案・8月改訂との差分を明記する。契約・採択の断定をしない。
- 見積: 機能別に **必須** と **あれば便利** を分け、税別で金額・前提・含めないものを書く。サーバー構築は別枠。保守は月額の目安。ROI は木村さん申告の時間（手入力 1日1.5時間・予定組み 1日2時間）を使った試算と明記。
- 構成図: 開発会社資料の役割分担（別ベンダー＝tugilo／弊社＝開発会社）を踏まえ、PDF → 補助DB → CSV → 取込プログラム → Oracle の流れ、AP／Web／DB、置き場所の2案を Mermaid で描く。
- 基本設計書: 機能一覧、画面一覧、データ（補助DB の主要テーブル）、CSV 連携の方式（既定フォルダ・手動実行・同一ファイル名エラー・UPDATE／DELETE の確認事項）、自動配置ルール v1、権限、ログ、非機能。
- 仕様書: 画面ごとの項目・操作・状態遷移、CSV レイアウト案（開発会社設計待ちの前提）、生産依頼表の入力項目（Excel テンプレートと判型リストに合わせる）、自動配置の入力・出力・制約。
- スケジュール表: 10月中ヒアリング・契約手続き → 10〜12月開発 → 12月末テスト準備 → 1月並行テスト → 2月検収。週単位。開発会社側（取込口）とのマイルストーンを並記。
- HTML スライド: 6文書それぞれを 1280×720 の単一 HTML（外部依存なし・ブラウザ印刷で PDF 化）にする。md 版と内容を一致させ、全スライドで枠からのはみ出しが無いことを確認する。
- 受領資料を `木村さん用/` に保存し README に載せる。INDEX・進捗・PHASE_REGISTRY を同期する。
- docs フェーズのため Laravel テスト・React ビルド・`db-push` は実行しない。

---

## Tasks

1. 受領3点を保存し README を更新する。
2. 改訂提案書を作る。
3. 機能別見積を作る。
4. システム構成図を作る。
5. 基本設計書を作る。
6. 仕様書を作る。
7. スケジュール表を作る。
8. 1to1 議事録のアクション・INDEX・進捗・PHASE_REGISTRY を同期する。
9. 6文書を HTML スライドにする（2026-10-11 追加）。
10. 6デッキを PDF にし、提出用フォルダと送付文を用意する（2026-10-12 追加。送信は人が行う）。
11. 助成金専門家の25観点チェックリストへの回答案と打合せ準備を作る（2026-10-14 追加）。
