# Phase 317 REPORT — 国宝社 第4回121反映 改訂提案一式

**状態:** in_progress（文書作成 2026-10-10 07:29 JST 完了。HTML スライド 2026-10-11 02:04 JST 完了。PDF・送付文 2026-10-12 01:19 JST 完了。提出一式は送付済み・木村さん 2026-10-14 受領確認。専門家チェックリスト回答案 2026-10-14 18:05 JST 作成。commit・merge は未）

## Summary

第4回 1to1（2026-10-05）の合意と、2026-10-10 受領の3点（開発会社の CSV 取込イメージ図・生産依頼表 Excel テンプレート・判型リスト／一覧シート）をもとに、提出用の6文書を **提案書 → 見積 → 構成図 → 基本設計 → 仕様 → スケジュール** の順で作った。

主な判断（WORKLOG 参照）:

- 旧金額（7月 A/B/C、8月 214／289／379万）は据え置かず **組み直し**。必須 M0〜M7 アプリ ¥2,350,000 ＋ サーバー ¥300,000 ＝ **¥2,650,000**（税別・案）。あれば便利 O1〜O6 を別表。
- CSV はファイル名を常に一意にし（取込側の同一ファイル名エラーに合わせる）、出力履歴を補助DB に残す。初回は **INSERT のみ**、修正・取消は VB 側、を案として提示。レイアウトは開発会社提示を正とし、仕様書は「たたき台」。
- 手動入力画面の項目は Excel テンプレートの並び、判型は受領リスト 25種のドロップダウン。
- 助成金は 2026-10-08 確認の制度名（板橋区 デジタル化・データ利活用推進助成金 業務管理システムコース）で記載。採択未確定・契約扱いにしない、を各文書に明記。

## Deliverables

| 文書 | パス |
|------|------|
| 改訂提案書 v3 | `docs/proposals/kimura_kokuhosha_proposal_v3_20261010.md` |
| 機能別見積 v3 | `docs/proposals/kimura_kokuhosha_estimate_v3_20261010.md` |
| システム構成図 | `docs/proposals/kimura_kokuhosha_system_architecture_20261010.md` |
| 基本設計書 | `docs/proposals/kimura_kokuhosha_basic_design_20261010.md` |
| 仕様書 | `docs/proposals/kimura_kokuhosha_specification_20261010.md` |
| スケジュール表 | `docs/proposals/kimura_kokuhosha_schedule_20261010.md` |
| HTML スライド（6デッキ・計55枚） | `docs/proposals/kimura_kokuhosha_{proposal_v3(11),estimate_v3(8),system_architecture(7),basic_design(10),specification(11),schedule(8)}_slides_20261011.html` |
| 専門家チェックリスト25観点への回答案 | `docs/proposals/kimura_kokuhosha_subsidy_consultant_checklist_response_20261014.md`（受領原本は `木村さん用/助成金専門家_…_20261013_v1.pdf`） |
| v3 からの変更点メモ（予定表への AI 組み込み・A4 1枚） | `docs/proposals/kimura_kokuhosha_v3_change_memo_ai_20261014.{md,html,pdf}`。提出用コピー `tugilo-os/deliverables/kokuhosha/20261014_専門家打合せ/07_…pdf` |
| 25項目回答一覧（外部向け・A4 3枚） | `docs/proposals/kimura_kokuhosha_checklist_answers_20261014.{html,pdf}`。提出用コピー `…/20261014_専門家打合せ/08_…pdf` |
| 提出用 PDF（6本・計55ページ） | `docs/proposals/kimura_kokuhosha_*_slides_20261011.pdf`。日本語名コピー＋送付文: `tugilo-os/deliverables/kokuhosha/20261012_提出一式/`（リポジトリ外） |
| 受領資料（4点）＋ README | `docs/proposals/木村さん用/` |
| 同期 | `docs/proposals/README.md`、`docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md`（サマリー・アクション表）、`docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md` |

## DoD 照合

| DoD | 結果 |
|-----|------|
| 提案書に第4回決定事項と 7月・8月との差分 | OK（§1・§10） |
| 見積: 必須／あれば便利・税別・前提・含めないもの・サーバー別枠・保守・ROI 試算 | OK |
| 構成図: 役割分担・データの流れ・AP/Web/DB・置き場所2案・Mermaid | OK |
| 基本設計: 機能・画面・データ・CSV 方式・自動配置 v1・権限・ログ・非機能 | OK |
| 仕様書: 画面項目・操作・状態・CSV たたき台・生産依頼表項目・自動配置の入出力 | OK |
| スケジュール: 10月〜2027-02 週別・開発会社マイルストーン並記 | OK |
| HTML スライド: 6文書×単一 HTML・外部依存なし・はみ出し無し | OK（全55枚を DOM 計測。Gantt の行高を調整して解消） |
| 受領資料保存・README・INDEX・進捗・REGISTRY 同期 | OK |
| テスト・ビルド・db-push は実行しない | OK（未実行） |

## 残課題（Phase 外）

- 木村さんへの送付文（6文書の案内）。送付後に 1to1 アクション表の「送付は未」を更新
- CSV レイアウト受領後に仕様書 §5 を置き換え
- 助成金書類の粒度が分かり次第、基本設計・仕様書を合わせる
- 第3回・第4回の Religo `one_to_ones` 行（Zoom planned 検出後）

## Merge Evidence

merge commit id: （未。commit は明示依頼時）  
source branch: （作業ツリー未分離。現在 `feature/phase315-okamoto-sorosoro-concept-prep` 上）  
target branch: develop  
phase id: 317  
phase type: docs  
related ssot: 1to1_kimura_hidetsugu_kokuhosha.md（第4回）、requirements_20260529 / 20260826、PROJECT_NAMING.md

test command: スキップ（docs フェーズ）  
test result: スキップ（docs フェーズ）

changed files:
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_317_kimura_kokuhosha_proposal_v3_{PLAN,WORKLOG,REPORT}.md
- docs/proposals/README.md
- docs/proposals/kimura_kokuhosha_proposal_v3_20261010.md
- docs/proposals/kimura_kokuhosha_estimate_v3_20261010.md
- docs/proposals/kimura_kokuhosha_system_architecture_20261010.md
- docs/proposals/kimura_kokuhosha_basic_design_20261010.md
- docs/proposals/kimura_kokuhosha_specification_20261010.md
- docs/proposals/kimura_kokuhosha_schedule_20261010.md
- docs/proposals/kimura_kokuhosha_proposal_v3_slides_20261011.html
- docs/proposals/kimura_kokuhosha_estimate_v3_slides_20261011.html
- docs/proposals/kimura_kokuhosha_system_architecture_slides_20261011.html
- docs/proposals/kimura_kokuhosha_basic_design_slides_20261011.html
- docs/proposals/kimura_kokuhosha_specification_slides_20261011.html
- docs/proposals/kimura_kokuhosha_schedule_slides_20261011.html
- docs/proposals/kimura_kokuhosha_{proposal_v3,estimate_v3,system_architecture,basic_design,specification,schedule}_slides_20261011.pdf
- docs/proposals/kimura_kokuhosha_subsidy_consultant_checklist_response_20261014.md
- docs/proposals/木村さん用/助成金専門家_開発会社を確認するときの観点_花村_20261013_v1.pdf
- docs/proposals/木村さん用/README.md
- docs/proposals/木村さん用/注文データ取込プログラム_要望事項イメージ図_20260929.pdf
- docs/proposals/木村さん用/生産依頼表_Excelテンプレート_20261010.png
- docs/proposals/木村さん用/判型リスト_20261010.png
- docs/proposals/木村さん用/生産依頼表_一覧シート_20261010.png

scope check: OK（docs/** のみ）  
ssot check: OK（新 SPEC 不要。1to1 第4回・要件文書に矛盾なし）  
dod check: OK（文書作成分。merge は未）
