# 提案・クライアント向け素案（docs/proposals/）

**用途:** クライアント／パートナー共有を想定した **提案書・ブリーフ・PDF** の置き場。  
**議事録・1to1** は [`docs/meetings/`](../meetings/README.md) と役割を分ける。

| 種別 | 置き場の目安 |
|------|----------------|
| 打合せ・複数者ミーティングのメモ | `docs/meetings/`（直下） |
| 1対1 の履歴 | `docs/meetings/1to1/` |
| **提案のたたき台・正式提案・エクスポート PDF** | **`docs/proposals/`（本ディレクトリ）** |

既存の PDF など、拡張子を問わず同じフォルダで管理してよい。

> **国宝社（kimura_kokuhosha_*・木村さん用/）は 2026-11-04 に `~/docker/kokuhosha/docs/` へコピーし、以後はそちらを正とする。** 本リポジトリ側は履歴として据え置く（Tugilo OS: proj_kokuhosha）。

| 資料 | メモ |
|------|------|
| [takemura_scaffold_rental_aws_hearing_estimate.md](takemura_scaffold_rental_aws_hearing_estimate.md) | **竹村裕司・足場レンタルのインフラ構築（新規）**。1to1とは別管理のプロポーザル案件。概算は構築38万／AWS等月3〜6万／稼働維持保守月1〜2万。システム会社への環境質問を収録。 |
| [AI時代に_企業が必要とするエンジニアとは_20260814132404.pdf](AI時代に_企業が必要とするエンジニアとは_20260814132404.pdf) | **小中貴晃さん共有用**（2026-08-14 修正版・11枚）。AI時代のエンジニア定義を二人で検討するたたき台。初版: [同名.pdf](AI時代に_企業が必要とするエンジニアとは.pdf)。 |
| [takemura_cheer_print_loadtest_report_20260808_genspark_slide_prompt.md](takemura_cheer_print_loadtest_report_20260808_genspark_slide_prompt.md) | **負荷試験結果スライド用 Gensparkプロンプト**（15枚・非技術者＋技術者）。金額なし。 |
| [takemura_cheer_print_loadtest_report_20260808_client.md](takemura_cheer_print_loadtest_report_20260808_client.md) | **負荷試験結果・非技術者向けご報告**（2026-08-08実施）。総合危険／具体提案・期限・ToDo。[HTML](takemura_cheer_print_loadtest_report_20260808_client.html)。 |
| [takemura_cheer_print_loadtest_program_requirements.md](takemura_cheer_print_loadtest_program_requirements.md) | **Cheer Print 負荷試験プログラム要件**（k6・**ローカルDocker推奨**・Stage A/B/C・静的／WP分離・自動報告書）。Phase 300。ツール: `tools/cheer-print-loadtest/`。 |
| [takemura_cheer_print_event_access_plan.md](takemura_cheer_print_event_access_plan.md) | **Cheer Print イベント時アクセス集中対策 — 目的・要件・実施計画（実行 SSOT）**。予算税別12万・約2週間・役割分担・Day1–14・負荷試験 Stage・制作会社確認文面。 |
| [takemura_cheer_print_access_load_proposal.md](takemura_cheer_print_access_load_proposal.md) | **Cheer Print アクセス集中対策・負荷試験のご提案（外向け）**。簡易診断3〜5万／負荷試験8〜15万／再試験3〜5万。実行時は上記 plan を優先。 |
| [takemura_asobisystem_wp_load_test_proposal.md](takemura_asobisystem_wp_load_test_proposal.md) | **Cheer Print 技術別紙**（詳細）。外向け提出はご提案を、実行計画は event_access_plan を正とする。 |
| [takemura_cheer_print_load_test_genspark_slide_prompt.md](takemura_cheer_print_load_test_genspark_slide_prompt.md) | **外向け提案の Gensparkスライドプロンプト**（12枚前後）。 |
| [printing_business_improvement_estimate.md](printing_business_improvement_estimate.md) | 印刷業務改善の **概算見積（案・税別）**。overview / PDF スライドとセットで共有用。 |
| [ilc_monthly_report_automation_proposal_imanishi.md](ilc_monthly_report_automation_proposal_imanishi.md) | **AiLC 月次集計表作成 自動化提案メモ**。今西さん向け。検証結果、削減効果、AI駆動Web MVP、概算費用、ROI、返信案を整理。 |
| [ilc_monthly_report_automation_genspark_slide_prompt.md](ilc_monthly_report_automation_genspark_slide_prompt.md) | **Genspark用スライド生成プロンプト**。AiLC 月次集計表作成 自動化提案メモを、経営者向けスライドに変換するための構成・デザイン・強調点・元資料。 |
| [木村さん用/README.md](木村さん用/README.md) | **木村秀継（国宝社）共有資料**のインデックス。TTJUCUHD/DT 定義 PDF、サンプル Excel、注文書 PDF、予定表・依頼表、**開発会社 CSV 取込資料・Excel テンプレート・判型リスト（2026-10-10）**。 |
| [kimura_kokuhosha_pdf_order_input_proposal.md](kimura_kokuhosha_pdf_order_input_proposal.md) | **木村秀継（国宝社）向け PDF注文書入力支援 提案書（たたき台）**。As-Is / 改善案 / To-Be。 |
| [kimura_kokuhosha_pdf_order_input_genspark_slide_prompt.md](kimura_kokuhosha_pdf_order_input_genspark_slide_prompt.md) | **Genspark用** 国宝社 PDF入力支援提案スライド生成プロンプト。出力: [木村さん用/PDF注文書入力支援システム_ご提案_20260705122750.pdf](木村さん用/PDF注文書入力支援システム_ご提案_20260705122750.pdf)（16枚）。 |
| [kimura_kokuhosha_pdf_order_input_estimate.md](kimura_kokuhosha_pdf_order_input_estimate.md) | **国宝社 PDF入力支援 概算見積（案・税別）**。7月入口のみ。v3 で組み直し。 |
| [kimura_kokuhosha_proposal_v5_20261026.md](kimura_kokuhosha_proposal_v5_20261026.md) | **国宝社 改訂提案書 v5（2026-10-26・提出版候補・送付前）**。第4回・第5回を通した全面改訂。AI なし。注文書 PDF は **OCR＋座標テンプレート**、複数ページ分割、再発行の差分表示、製本日カレンダー入力、VB 基本情報・詳細情報に合わせた項目、まとめ製本 1 行表示・週／月切替、**人の判断を言語化した条件管理**で自動配置。助成金起点の日程 2 案、ROI を実測ベース（年 600h）に修正、v3→v5 差分表、確認事項 8 件。 |
| [kimura_kokuhosha_estimate_v5_20261026.md](kimura_kokuhosha_estimate_v5_20261026.md) | **国宝社 正式見積書 v5（案・2026-10-26・次廣確定前）**。作業項目ごとの定額（数量 1 式・工数を根拠にしない）に展開。必須 **¥2,835,000**（M0 6／M1 5／M2 19／M3 3／M4 6／M5 14／M6 12／M7 8／S 8）、区分別（設計 7.4%／開発 72.8%／検証・導入 9.9%／サーバー 9.9%）、含む／含まない、任意 O1〜O6（O4 AI は参考）、v3 との差分 +¥185,000、納品物、支払 30/40/30、条件案、**次廣確定事項一覧**。 |
| [kimura_kokuhosha_proposal_v5_slides_20261026.html](kimura_kokuhosha_proposal_v5_slides_20261026.html) | **国宝社 提案書 v5 HTML スライド（13 枚）**。表紙／結論と v3 からの変更 4 点／第5回で確認した現状／機能1 流れと OCR＋テンプレート／入力項目／予定表画面（週月・まとめ製本・仮確定）／人の判断の言語化 → 条件／つながり・分担／進め方 A・B／費用 ¥2,835,000 と ROI／助成金／v3→v5 差分／確認事項。[PDF](kimura_kokuhosha_proposal_v5_slides_20261026.pdf)（960×540pt・13 ページ）。送付前。 |
| [kimura_kokuhosha_estimate_v5_slides_20261026.html](kimura_kokuhosha_estimate_v5_slides_20261026.html) | **国宝社 見積書 v5 HTML スライド（8 枚）**。金額と前提／内訳 M0〜M4／M5〜S／含む・含まない／任意と v3 差分／納品物・支払・条件・保守／ROI・助成金。[PDF](kimura_kokuhosha_estimate_v5_slides_20261026.pdf)（960×540pt・8 ページ）。「案・送付前」hint つき。 |
| [kimura_kokuhosha_estimate_v5_20261026.html](kimura_kokuhosha_estimate_v5_20261026.html) | **国宝社 御見積書 v5（案）A4 HTML**。md 版 §1〜§4・§7・§12 を見積書体裁に整形（宛先・金額・内訳 M0-1〜S-2・含む／含まない・条件）。先頭に「案・社内確認用・送付不可」枠。[PDF](kimura_kokuhosha_estimate_v5_20261026.pdf)（A4 3 枚）。確定後に枠を外して発行。 |
| [kimura_kokuhosha_proposal_v4_20261026.md](kimura_kokuhosha_proposal_v4_20261026.md) | **国宝社 改訂提案書 v4（2026-10-26）・AI を入れる場合の参考案**（第5回 10/26 で「今回は AI は不要」と決定。正式見積は v3 必須 ¥2,650,000＋第5回新要件が基準）。予定表の自動配置を「ルール＋AI＋人」の三層・AI 連携を必須に。PDF 読み方（画像サンプル）の最優先確認、AI に渡す情報と守り方、運営保守体制、専門家資料との認識合わせ表、確認事項（国宝社／専門家／開発会社）。 |
| [kimura_kokuhosha_proposal_v4_slides_20261026.html](kimura_kokuhosha_proposal_v4_slides_20261026.html) | **国宝社 改訂提案書 v4 HTML スライド（13枚）**。v3 スライドを v4 に更新。AI 三層（p.5〜6）、発注時期起点の 3 シナリオと助成金（p.9）、体制と専門家資料との認識合わせ（p.10）、必須 ¥2,900,000（p.11）、差分表（p.12）、確認事項（p.13）。[PDF](kimura_kokuhosha_proposal_v4_slides_20261026.pdf)（960×540pt・13ページ）。②〜⑥の v4 スライドは未作成（md 版を参照）。 |
| [kimura_kokuhosha_estimate_v4_20261026.md](kimura_kokuhosha_estimate_v4_20261026.md) | **国宝社 機能別見積 v4（税別・概算）**。必須 M0〜M7＋M6A「AI 連携」¥250,000＋サーバー＝**¥2,900,000**／任意 O1〜O6（O4 は必須へ移動・O3 再定義）¥1,100,000〜¥1,160,000。M6A 作業内訳 A-1〜A-8・二重計上確認・既存基盤再利用・価格判断（案A/B/C）・API 利用料未確定・ROI。 |
| [kimura_kokuhosha_system_architecture_v4_20261026.md](kimura_kokuhosha_system_architecture_v4_20261026.md) | **国宝社 システム構成図 v4**。v3 に AI 連携経路（ルール層・ガード・AI API）、外向き HTTPS 1 宛先、鍵設定、AI 連携シーケンスと守りの表を追加。Mermaid。 |
| [kimura_kokuhosha_basic_design_v4_20261026.md](kimura_kokuhosha_basic_design_v4_20261026.md) | **国宝社 基本設計書 v4**。F-15 必須化・F-17〜F-20 追加、AI 関連テーブル、三層構成 §7、**AI 送信セキュリティ設計方針 §7A（14項目＋OpenAI 公式条件）**、納品物一覧、継続体制、未確定事項。 |
| [kimura_kokuhosha_specification_v4_20261026.md](kimura_kokuhosha_specification_v4_20261026.md) | **国宝社 仕様書 v4**。PDF 解析方式の前提、三層処理の手順、言葉での指示の定型範囲①〜⑥と曖昧時確認、AI 入出力（送る／送らない）、AI 設定・プロンプト・鍵・送信ログの管理、例外、検収案 (a)〜(e)。 |
| [kimura_kokuhosha_schedule_v4_20261026.md](kimura_kokuhosha_schedule_v4_20261026.md) | **国宝社 スケジュール表 v4**。「10月契約・11/2 着手」は過去計画。発注可能時期起点の 3 シナリオ（11/16 週／11/30 週／12/14 週以降）、範囲調整案 A〜F、2/26 支払完了を固定点。 |
| [kimura_kokuhosha_hearing_sheet_answers_20261026.md](kimura_kokuhosha_hearing_sheet_answers_20261026.md) | **国宝社 専門家ヒアリングシート（シート1 1-1〜11-1・シート2 No.1〜25）への tugilo 回答案（v4 整合）**。決めていないと明記したもの一覧。元 xlsx: [木村さん用/助成金専門家_提案書ヒアリングシート_花村_20261013_v1.xlsx](木村さん用/助成金専門家_提案書ヒアリングシート_花村_20261013_v1.xlsx)、回答 xlsx 写し: [kimura_kokuhosha_hearing_sheet_tugilo_answers_20261026.xlsx](kimura_kokuhosha_hearing_sheet_tugilo_answers_20261026.xlsx)。 |
| [kimura_kokuhosha_checklist_answers_20261026.html](kimura_kokuhosha_checklist_answers_20261026.html) | **国宝社 25項目回答一覧 2026-10-26 版（外部向け A4 4枚・v4 資料の該当章つき）**。10/14 版を置き換え。[PDF](kimura_kokuhosha_checklist_answers_20261026.pdf)。 |
| [kimura_kokuhosha_proposal_v3_20261010.md](kimura_kokuhosha_proposal_v3_20261010.md) | **国宝社 改訂提案書 v3（第4回121反映）・履歴版（v4 に更新済み）**。2機能・CSV連携・ルールベース自動配置・10〜12月開発・2月検収。 |
| [kimura_kokuhosha_estimate_v3_20261010.md](kimura_kokuhosha_estimate_v3_20261010.md) | **国宝社 機能別見積 v3（税別・案）・履歴版**。必須 M0〜M7＋サーバー ¥2,650,000／あれば便利 O1〜O6。ROI 試算。 |
| [kimura_kokuhosha_system_architecture_20261010.md](kimura_kokuhosha_system_architecture_20261010.md) | **国宝社 システム構成図 v3・履歴版**。PDF→補助DB→CSV→取込プログラム→Oracle。置き場所 案A／B。Mermaid。 |
| [kimura_kokuhosha_basic_design_20261010.md](kimura_kokuhosha_basic_design_20261010.md) | **国宝社 基本設計書 v3・履歴版**。機能・画面・補助DB テーブル・CSV 連携方式・自動配置 v1・権限・非機能・開発会社確認事項。 |
| [kimura_kokuhosha_specification_20261010.md](kimura_kokuhosha_specification_20261010.md) | **国宝社 仕様書 v3・履歴版**。画面項目・操作・CSV レイアウトたたき台・自動配置ルール・判型25種マスタ。 |
| [kimura_kokuhosha_schedule_20261010.md](kimura_kokuhosha_schedule_20261010.md) | **国宝社 スケジュール表 v3・履歴版**。2026-10〜2027-02 週別・Gantt・マイルストーン・遅れ要因。 |
| [kimura_kokuhosha_proposal_v3_slides_20261011.html](kimura_kokuhosha_proposal_v3_slides_20261011.html) | **国宝社 改訂提案書 v3 HTML スライド（11枚）**。1280×720・印刷で PDF 化。上部リンクで6デッキを行き来。 |
| [kimura_kokuhosha_estimate_v3_slides_20261011.html](kimura_kokuhosha_estimate_v3_slides_20261011.html) | **国宝社 機能別見積 v3 HTML スライド（8枚）**。必須／あれば便利／組み合わせ例／ROI／助成金・支払い。 |
| [kimura_kokuhosha_system_architecture_slides_20261011.html](kimura_kokuhosha_system_architecture_slides_20261011.html) | **国宝社 システム構成図 HTML スライド（7枚）**。全体像・CSV 連携・置き場所 案A／B・層・境界（CSS 図）。 |
| [kimura_kokuhosha_basic_design_slides_20261011.html](kimura_kokuhosha_basic_design_slides_20261011.html) | **国宝社 基本設計書 HTML スライド（10枚）**。原則・機能・画面・データ・CSV 方式・自動配置・権限・確認事項。 |
| [kimura_kokuhosha_specification_slides_20261011.html](kimura_kokuhosha_specification_slides_20261011.html) | **国宝社 仕様書 HTML スライド（11枚）**。画面項目・ワイヤー・CSV レイアウト・予定表・自動配置ルール・マスタ。 |
| [kimura_kokuhosha_schedule_slides_20261011.html](kimura_kokuhosha_schedule_slides_20261011.html) | **国宝社 スケジュール表 HTML スライド（8枚）**。CSS Gantt・月別週表・マイルストーン・遅れ要因。 |
| [kimura_kokuhosha_subsidy_consultant_checklist_response_20261014.md](kimura_kokuhosha_subsidy_consultant_checklist_response_20261014.md) | **国宝社 助成金専門家チェックリスト（25観点）への回答案と打合せ準備**。論点 A〜G（AI の扱い・見積形式・内訳・検収基準・保守・期限・既存会社費用）、**予定表への AI 組み込み案（ルール＋AI＋人。木村さん意向 2026-10-14）**、要判断項目、v3 反映リスト、返信文案。**10/14 時点の記録（最新は hearing_sheet_answers_20261026）**。 |
| [kimura_kokuhosha_v3_change_memo_ai_20261014.md](kimura_kokuhosha_v3_change_memo_ai_20261014.md) | **国宝社 v3 からの変更点メモ（予定表への AI 組み込み）・v4 反映済み**。木村さん・花村氏向け A4 1枚。何が変わるか／金額 ¥2,650,000→¥2,900,000（案）／v3 のどこが置き換わるか／変わらないもの／打合せで決めたいこと。外部向け [HTML](kimura_kokuhosha_v3_change_memo_ai_20261014.html)・[PDF](kimura_kokuhosha_v3_change_memo_ai_20261014.pdf)。 |
| [kimura_kokuhosha_checklist_answers_20261014.html](kimura_kokuhosha_checklist_answers_20261014.html) | **国宝社 「開発会社を確認するときの観点」25項目への回答一覧（外部向け A4 3枚・10/14 版・20261026 版に更新済み）**。回答案 §1〜5 から内部メモ・要判断の経営判断を除き、★＝打合せで確定 に置き換えたもの。[PDF](kimura_kokuhosha_checklist_answers_20261014.pdf)。 |
| `kimura_kokuhosha_{proposal_v3,estimate_v3,system_architecture,basic_design,specification,schedule}_slides_20261011.pdf` | **上記6デッキの PDF**（Chrome headless 出力・960×540pt＝16:9・計55ページ）。2026-10-12 作成。提出用の日本語名コピーは `tugilo-os/deliverables/kokuhosha/20261012_提出一式/`。 |
