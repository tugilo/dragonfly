# 木村秀継さん（株式会社国宝社 / BPS木村）共有資料

**用途:** 第2回 1to1（2026-05-29）で合意した PDF注文書入力自動化の提案・モック作成用。  
**受領日:** 2026-07-05 JST（次廣保存）。予定表・依頼表は **2026-08-27 23:34 JST** 追受領。  
**関連:** [第2回要望](../../meetings/1to1/1to1_kimura_hidetsugu_kokuhosha_requirements_20260529.md) · [第3回追加要件](../../meetings/1to1/1to1_kimura_hidetsugu_kokuhosha_requirements_20260826.md) · [1to1 履歴](../../meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md) · [提案書（§16 まで）](../kimura_kokuhosha_pdf_order_input_proposal.md)

> **第3回（2026-08-26）注記:** 追加要件は提案書 §16。画面モックは未着手。予定表・依頼表の実物は本フォルダ。

## ファイル一覧

| ファイル | 内容 | メモ |
|----------|------|------|
| [TTJUCUHDテーブル定義.pdf](TTJUCUHDテーブル定義.pdf) | 受注ヘッダー表 **TTJUCUHD** の Oracle テーブル定義 | 既存 VB 画面「基本情報」に対応 |
| [TTJUCUDTテーブル定義.pdf](TTJUCUDTテーブル定義.pdf) | 受注明細表 **TTJUCUDT** の Oracle テーブル定義 | 既存 VB 画面「詳細情報」に対応。Excel シート名は `TTJUCHDT` |
| [データ.xlsx](データ.xlsx) | テーブル関連図・画面対応・サンプルデータ | シート: `テーブル関連図` / `画面` / `TTJUCUHD` / `TTJUCHDT` |
| [注文書.pdf](注文書.pdf) | 出版社から届く PDF 注文書のサンプル（1パターン） | 追加パターンは引き続き確認予定 |
| [PDF注文書入力支援システム_ご提案_20260705122750.pdf](PDF注文書入力支援システム_ご提案_20260705122750.pdf) | **Genspark 生成の提案スライド（16枚）** | 2026-07-05 12:27 出力。元: [Gensparkプロンプト](../kimura_kokuhosha_pdf_order_input_genspark_slide_prompt.md) · [提案書](../kimura_kokuhosha_pdf_order_input_proposal.md) |
| [生産依頼表_画面.jpg](生産依頼表_画面.jpg) | **生産依頼表**（1案件の入力票） | 2026-08-27 受領。得意先・書名・部数・判型・仕様・台割・見本／配本／希望／決定日（工場）・備考 |
| [製本作業予定表_20260907-0911_手書き.jpg](製本作業予定表_20260907-0911_手書き.jpg) | **製本作業予定表**（週次印刷＋手書き） | 2026-08-27 受領。対象 2026-09-07〜11。印刷 2026-08-24 21:49。板橋1F/2F・ふじみ野（本線＋予備） |

## データ.xlsx の概要

- **TTJUCUHD:** 受注ヘッダー。`TOKUICOD`, `KANRISEQ`, `SEIHINCD`, `SEISIKINM`, `SEIHINNM`, `ISBN`, `CHUBUSU`, 各種日付（`HATYMD`, `MIHYMD`, `HAIYMD`, `SORYMD`, `NOUYMD` 等）、丁数・平台・輪転関連項目を含む。
- **TTJUCHDT:** 受注明細（1:N）。`KANRISEQ` + `RENBANCD` でヘッダーに紐づく。`TUKIMCOD`（種別）、印刷所・加工所、備考（`JUDTBIKO`）等。
- サンプル行は講談社系の書籍タイトル（例: 深い河、午後の脅迫者 等）で、`KANRISEQ` 735 以降の実データ形式。

## まだ不足しているもの

- 出版社・得意先ごとの **PDF 注文書サンプル複数パターン**（現状 1 件）
- ODBC / Oracle への **書き込み権限** の可否
- 採番・シーケンス・トリガーの運用詳細
- 1件あたりの入力時間、担当人数、失敗時の現場運用

## 取り扱い注意

- クライアント提供の業務データ。**リポジトリ外共有・公開禁止**。
- 提案・モック作成以外の用途に流用しない。
