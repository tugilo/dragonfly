# 木村秀継さん（株式会社国宝社 / BPS木村）共有資料

**用途:** 第2回 1to1（2026-05-29）で合意した PDF注文書入力自動化の提案・モック作成用。  
**受領日:** 2026-07-05 JST（次廣保存）  
**関連:** [1to1 要望整理](../../meetings/1to1/1to1_kimura_hidetsugu_kokuhosha_requirements_20260529.md) · [1to1 履歴](../../meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md) · [提案書（たたき台）](../kimura_kokuhosha_pdf_order_input_proposal.md)

## ファイル一覧

| ファイル | 内容 | メモ |
|----------|------|------|
| [TTJUCUHDテーブル定義.pdf](TTJUCUHDテーブル定義.pdf) | 受注ヘッダー表 **TTJUCUHD** の Oracle テーブル定義 | 既存 VB 画面「基本情報」に対応 |
| [TTJUCUDTテーブル定義.pdf](TTJUCUDTテーブル定義.pdf) | 受注明細表 **TTJUCUDT** の Oracle テーブル定義 | 既存 VB 画面「詳細情報」に対応。Excel シート名は `TTJUCHDT` |
| [データ.xlsx](データ.xlsx) | テーブル関連図・画面対応・サンプルデータ | シート: `テーブル関連図` / `画面` / `TTJUCUHD` / `TTJUCHDT` |
| [注文書.pdf](注文書.pdf) | 出版社から届く PDF 注文書のサンプル（1パターン） | 追加パターンは引き続き確認予定 |
| [PDF注文書入力支援システム_ご提案_20260705122750.pdf](PDF注文書入力支援システム_ご提案_20260705122750.pdf) | **Genspark 生成の提案スライド（16枚）** | 2026-07-05 12:27 出力。元: [Gensparkプロンプト](../kimura_kokuhosha_pdf_order_input_genspark_slide_prompt.md) · [提案書](../kimura_kokuhosha_pdf_order_input_proposal.md) |

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
