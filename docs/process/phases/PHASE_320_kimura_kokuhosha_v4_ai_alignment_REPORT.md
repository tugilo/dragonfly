# Phase 320 REPORT — 国宝社 v4（予定表 AI 三層・見積点検・送信セキュリティ方針・運営保守・専門家回答の整合）

**Phase type:** docs  
**Status:** in_progress（資料整備は完了。commit・merge・push は指示により未実施）  
**追記 2026-10-26 13:35 JST:** 第5回打合せで **「今回は AI は不要」と決定**。本 Phase の v4 は AI を入れる場合の参考案として保持（各文書に追記）。正式見積は v3 必須 ¥2,650,000＋第5回新要件を基準に別途作成。  
**作成:** 2026-10-26 10:15 JST  
**PLAN:** [PHASE_320_kimura_kokuhosha_v4_ai_alignment_PLAN.md](PHASE_320_kimura_kokuhosha_v4_ai_alignment_PLAN.md) · **WORKLOG:** [PHASE_320_kimura_kokuhosha_v4_ai_alignment_WORKLOG.md](PHASE_320_kimura_kokuhosha_v4_ai_alignment_WORKLOG.md)

---

## Summary

木村秀継さん（株式会社国宝社）向け提案一式を v3（2026-10-10）から **v4（2026-10-26）** に更新し、助成金専門家（花村氏）のヒアリングシートへの回答と、実際に提供する機能・費用・保守体制の整合を取った。v4 は既存に無かったため v3 ＋ 10/14 変更メモを基に新規作成（重複版なし）。主な変更は、①予定表の自動配置を「ルール＋AI＋人」の三層とし AI 連携を必須 M6A ¥250,000（旧 O4 の移動）に含めたこと、②AI に渡す情報の守り方を「設計方針」として明記したこと、③日程を発注可能時期起点の 3 シナリオに引き直したこと。受領 PDF サンプルが画像のみ（テキスト層なし）である事実を最優先確認事項に格上げした。

---

## Deliverables

### 新規（docs/proposals）

| ファイル | 内容 |
|---|---|
| `kimura_kokuhosha_proposal_v4_20261026.md` | 提案書 v4。§1 変更点、§3.2 PDF 読み方、§4.2 三層、§7 AI に渡す情報、§8 運営保守体制、§12 専門家資料との認識合わせ、§13 確認事項 13 件 |
| `kimura_kokuhosha_estimate_v4_20261026.md` | 見積 v4。必須 ¥2,900,000／任意 ¥1,100,000〜¥1,160,000。§5 M6A 作業内訳 A-1〜A-8・分担・二重計上確認、§5.1 価格判断 案A/B/C、§4 既存基盤再利用 |
| `kimura_kokuhosha_system_architecture_v4_20261026.md` | 構成図 v4。AI 連携経路・HTTPS 1 宛先・鍵設定・シーケンス |
| `kimura_kokuhosha_basic_design_v4_20261026.md` | 基本設計 v4。F-15 必須化・F-17〜F-20、AI テーブル案、§7 三層、§7A セキュリティ設計方針 14 項目、§12 納品物、§13 継続体制、§14 未確定 |
| `kimura_kokuhosha_specification_v4_20261026.md` | 仕様 v4。解析方式前提、三層処理、言葉での指示 ①〜⑥、AI 入出力、管理、例外、検収案 (a)〜(e) |
| `kimura_kokuhosha_schedule_v4_20261026.md` | スケジュール v4。3 シナリオ・範囲調整案 A〜F・固定点 2/19・2/22・2/26 |
| `kimura_kokuhosha_hearing_sheet_answers_20261026.md` | 専門家ヒアリングシート（シート1 1-1〜11-1／シート2 No.1〜25）回答案・v4 章参照・未決一覧 |
| `kimura_kokuhosha_hearing_sheet_tugilo_answers_20261026.xlsx` | 回答案 xlsx の写し |
| `kimura_kokuhosha_checklist_answers_20261026.html` / `.pdf` | 外部向け 25 項目回答一覧 20261026 版（A4 4 枚） |
| `木村さん用/助成金専門家_提案書ヒアリングシート_花村_20261013_v1.xlsx` | 専門家元シートの写し（公開禁止） |
| `kimura_kokuhosha_proposal_v5_20261026.md` | **提案書 v5（提出版候補・送付前）。** 第4回・第5回を通した全面改訂。AI なし。OCR＋座標テンプレート、複数ページ分割、再発行差分、製本日入力、VB 項目対応、まとめ製本・週／月切替、人の判断の言語化 → 条件管理、助成金起点の日程 2 案、ROI 実測ベース、v3→v5 差分 |
| `kimura_kokuhosha_estimate_v5_20261026.md` | **正式見積書 v5（案・次廣確定前）。** 作業 × 人日 × ¥35,000（案）。必須 81 人日 ¥2,835,000（税込 ¥3,118,500）。区分別、含む／含まない、任意、v3 差分、納品物、支払、条件案、次廣確定事項。見積書体裁の `.html`／`.pdf`（A4 3 枚・「案・送付不可」枠つき）も作成 |
| `kimura_kokuhosha_proposal_v5_slides_20261026.{html,pdf}`／`kimura_kokuhosha_estimate_v5_slides_20261026.{html,pdf}` | 提案書 v5 スライド 13 枚・見積書 v5 スライド 8 枚（960×540pt）。v4 スライドの CSS を流用。「案・送付前」hint つき |
| `docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha_hearing_20261026.md` | 第5回 聞くことリスト・進行原稿。各設問に Zoom 要約からの回答と次廣補記を追記 |
| `docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha_requirements_20261026.md` | 注文書 PDF の読取方式（OCR＋テンプレート）と VB 入力項目の対応 |
| `木村さん用/現行VB受注入力画面_*_20261026.{pdf,png}` | 現行 VB 受注入力画面スクショ（公開禁止） |

### 更新

| ファイル | 変更 |
|---|---|
| v3 6 文書（`*_20261010.md`） | 先頭に「履歴版・v4 に更新済み」案内 |
| `kimura_kokuhosha_v3_change_memo_ai_20261014.{md,html,pdf}` | v4 反映済みの追記。PDF 再出力（A4 1 枚維持） |
| `kimura_kokuhosha_checklist_answers_20261014.{html,pdf}` | 20261026 版への案内追記。PDF 再出力（3 枚） |
| `kimura_kokuhosha_subsidy_consultant_checklist_response_20261014.md` | 最新回答への案内 |
| `木村さん用/README.md` | xlsx 行追加、注文書.pdf 画像のみ注記、v4 リンク、10/26 注記 |
| `docs/proposals/README.md`、`docs/INDEX.md` | v4・回答・xlsx・Phase 320 行追加、v3 を履歴表記 |
| `docs/dragonfly_progress.md` | 2026-10-26 10:10 JST 行 |
| `docs/process/PHASE_REGISTRY.md` | 320 in_progress |
| `docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md` | サマリー先頭に 10/26 節、アクション表 2 行 |

### 変更しない（PLAN どおり）

`www/**`、DB、v3 スライド HTML／PDF、提出用フォルダ `tugilo-os/deliverables` への新規コピー、他案件の未コミット変更。

---

## 金額の照合（必須・任意）

| 区分 | v3 | v4 | 差 |
|---|---|---|---|
| アプリ必須 M0〜M7 | ¥2,350,000 | ¥2,350,000 | 0 |
| M6A AI 連携（旧 O4） | （任意 ¥250,000） | ¥250,000 | +¥250,000（移動） |
| サーバー S | ¥300,000 | ¥300,000 | 0 |
| **必須 合計** | **¥2,650,000** | **¥2,900,000** | **+¥250,000** |
| 任意 O1〜O6 | ¥1,350,000〜¥1,410,000 | ¥1,100,000〜¥1,160,000 | −¥250,000 |
| **全部** | **¥4,000,000〜¥4,060,000** | **¥4,000,000〜¥4,060,000** | **0（二重計上なし）** |

- 区分: 設計 ¥200,000（6.9%）／開発 ¥2,150,000（74.1%）／検証・導入 ¥250,000（8.6%）／サーバー ¥300,000（10.3%）＝ ¥2,900,000。
- ROI: 840h/年 × 削減率 × ¥2,500 → 50%: 約 2.8 年／70%: 約 2.0 年／85%: 約 1.6 年（検算済み）。
- M6A ¥250,000 に含める作業 A-1〜A-8 と、M1（権限・ログ）、M6（配置制約）、M7（並行テスト）、S（サーバー・FW）に属する作業を分けた。O3 から理由表示・修正例参照を外し必須との重複を解消。
- 人日・単価は未確定のため「積算案・要確認」。逆算した人日は置いていない。

---

## DoD 照合

| DoD | 結果 |
|---|---|
| v4 6 文書が Purpose 1〜6 を反映し、案／未確定／判断主体の区別がある | OK |
| 見積 v4 の金額が表・組み合わせ例・ROI・内訳で一致。AI 作業内訳と分担表。人日・単価は積算案 | OK（上表） |
| 基本設計 v4 に三層・検証・切替・履歴参照・版管理・送信制御・鍵管理・ログ・異常時手順を「設計方針」として記載 | OK（§7・§7A） |
| 仕様 v4 に AI 入出力・自然言語指示・例外・検収案を決定済み／未確定で区別 | OK（§6.3〜6.5・§9〜11） |
| スケジュール v4 に 10月契約・11/2 着手を過去計画と明記、複数シナリオ、2/28 支払制約 | OK |
| 専門家回答が v4 と一致し外部向け HTML／PDF を再出力 | OK（20261026 版 新規・10/14 版は案内つきで再出力） |
| 旧版への案内、INDEX・README・進捗・PHASE_REGISTRY・1to1 の同期 | OK |
| docs フェーズ: テスト・ビルド・db 不実行。/tmp 一時ファイル削除 | OK |

---

## 残課題（次廣判断・Phase 外）

1. **言葉での指示の範囲:** 案A（定型 ①〜⑥ に限定・¥250,000 据え置き・推奨）／B（自由度高・人日積算後に増額）／C（任意へ移動）。
2. **AI サービスの選定**（OpenAI／Anthropic／Google）。申請書類での記載との整合。Anthropic・Google のデータ取扱条件は未確認。
3. **正式見積 v5（案）の確定:** 単価 ¥35,000／人日・各行の人日（81）・有効期限・支払条件・瑕疵 6 か月・権利・発行者表記（見積 v5 §13）。確定後に発行し送付（10/30 目安）。v5 スライド HTML／PDF の要否。
4. **v4 本体の HTML／PDF 化と送付時期:** Mermaid 図を描画する環境がローカルに無い。選択肢は (a) v3 スライド HTML を v4 に改訂して Chrome で PDF 化、(b) 構成図のみ画像化して md→HTML、(c) 当面は 25 項目回答 PDF＋変更点メモ PDF で説明し本体は打合せ後に出す。
5. **Phase 320 の commit・merge・Phase 317 の扱い**（317 は v3 一式として閉じるか、320 に統合するか）。
6. ~~提出用フォルダへの 20261026 版コピー~~ → **実施（2026-10-26 16:02 JST）:** `/Volumes/SSD1TB/tugilo-os/deliverables/kokuhosha/20261026_提出一式/` に 01 提案書 v5 スライド／02 見積書 v5 A4／02s 見積書 v5 スライド／03 25 項目回答 20261026／04 ヒアリングシート回答案 xlsx／messenger-draft-20261026.md（未送信・案）。見積確定後に 01・02・02s を差し替える。

---

## Merge Evidence

```
merge commit id: （未。commit・merge は指示により未実施）
source branch: 作業ツリー未分離（develop 上、他案件の未コミット変更と混在）
target branch: develop
phase id: 320
phase type: docs
related ssot: なし（クライアント提案資料。Religo アプリ仕様の変更なし）

test command: スキップ（docs フェーズ）
test result: スキップ

changed files: WORKLOG「同期」節および本 REPORT「Deliverables」参照（git diff は commit 時に取得）

scope check: OK（www・DB・v3 スライド・提出用フォルダに変更なし）
ssot check: OK（SSOT_REGISTRY 更新不要）
dod check: OK（資料整備分）／INCOMPLETE（commit・merge は保留）
```
