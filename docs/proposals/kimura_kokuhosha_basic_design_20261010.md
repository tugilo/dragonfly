# 株式会社国宝社 様 — 基本設計書（v3・案）

**作成:** 2026-10-10 07:19 JST  
**位置づけ:** 第4回 1to1（2026-10-05）合意を反映した基本設計。要件定義（M0）で確定・更新する。  
**関連:** [改訂提案書 v3](kimura_kokuhosha_proposal_v3_20261010.md) · [システム構成図](kimura_kokuhosha_system_architecture_20261010.md) · [仕様書](kimura_kokuhosha_specification_20261010.md) · [要件 第2回](../meetings/1to1/1to1_kimura_hidetsugu_kokuhosha_requirements_20260529.md) · [要件 第3回](../meetings/1to1/1to1_kimura_hidetsugu_kokuhosha_requirements_20260826.md) · [第4回 議事録](../meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md)

---

## 1. 目的と範囲

| 項目 | 内容 |
|------|------|
| 目的 | 注文書PDF と生産依頼表 Excel の手入力、紙の製本作業予定表を、社内 Web に置き換える |
| 範囲 | 注文入力（PDF／手動）、補助DB、CSV 出力、製本作業予定表、自動配置 v1、ユーザー・ログ |
| 範囲外 | VB 改修、Oracle へのテーブル追加・書き込み、取込プログラム（開発会社）、OCR、得意先ポータル、予定表の印刷・CSV 出力 |
| 利用者 | 事務（入力・承認・CSV 出力）、予定組み担当（予定表）、管理者（ユーザー・設定） |

---

## 2. 原則

1. **基幹は触らない。** 受注・得意先・注文番号の正は Oracle。補助DB は正にしない
2. **人が必ず見る。** PDF 解析結果は人が1件ずつ直して承認。承認前は CSV に出ない
3. **CSV が境界。** Oracle へは開発会社の取込プログラムだけが書く
4. **自動配置は提案。** 人が確定するまで予定表に反映しない
5. **段階的に自動化。** 生産依頼表 Excel は手動入力から。読込・メール取込は後から
6. **出さない。** 予定表の印刷・CSV 出力は作らない

---

## 3. 機能一覧

| ID | 機能 | 必須／便利 | 概要 |
|----|------|------------|------|
| F-01 | ログイン・ユーザー・権限 | 必須 | 事務／予定組み／管理者。パスワード。社内のみ |
| F-02 | PDF 一括アップロード | 必須 | 複数 PDF をドラッグ＆ドロップ。原本を保存 |
| F-03 | PDF 解析 | 必須 | 主要1社フォーマット。項目ごとに値と信頼度（証跡）を出す |
| F-04 | 注文情報 修正・承認 | 必須 | 項目欄を直す → 承認で draft 確定。「次へ」で次 PDF 解析 |
| F-05 | 生産依頼表 手動入力 | 必須 | Excel テンプレートと同じ項目。判型ドロップダウン |
| F-06 | CSV 出力 | 必須 | 承認済み draft を開発会社レイアウトで出力。既定フォルダ。履歴 |
| F-07 | 取込結果の反映 | 必須（方式は要確認） | 取込済み／エラーを draft に戻す |
| F-08 | 製本作業予定表 | 必須 | 未配置・6列×日付・差し込み・作業時間・合計・手追加・塞ぎ |
| F-09 | 自動配置 v1 | 必須 | ルールで提案 → 人が確定。入れ替え記録 |
| F-10 | 操作ログ | 必須 | 誰がいつ何を（承認・出力・配置確定） |
| F-11 | 得意先参照 | 必須（方式は要確認） | Oracle 読み取り、または開発会社提供 CSV の写し |
| F-12 | 生産依頼表 Excel 読込 | 便利 O1 | アップロードして項目に展開 |
| F-13 | メール自動取込・通知 | 便利 O2 | 定期取得、添付 Excel 取込、登録済み通知メール |
| F-14 | 自動配置 v2 | 便利 O3 | 生産性指標・提案理由・履歴からの調整 |
| F-15 | AI API 配置提案 | 便利 O4 | 外部 API。確定は人 |
| F-16 | PDF フォーマット追加 | 便利 O5 | 2社目以降 |

---

## 4. 画面一覧

| ID | 画面 | 主な利用者 | 要点 |
|----|------|------------|------|
| S-01 | ログイン | 全員 | ID／パスワード |
| S-02 | 注文入力（一覧） | 事務 | アップロード枠、処理待ち・解析中・確認待ち・承認済み・出力済み・取込済み・エラーの一覧 |
| S-03 | 注文確認・修正 | 事務 | 左 PDF プレビュー、右 項目欄。承認／差し戻し／次へ |
| S-04 | 生産依頼表 手動入力 | 事務 | Excel テンプレート順の入力欄。保存で draft（PDF 無し） |
| S-05 | CSV 出力 | 事務 | 承認済みを選ぶ → 出力。履歴・再出力 |
| S-06 | 製本作業予定表 | 予定組み | 週切替、未配置、6列×日付、カード、合計、自動配置ボタン |
| S-07 | 自動配置 提案確認 | 予定組み | 現在と提案を並べる。差分を色で。確定／取消 |
| S-08 | ユーザー・設定 | 管理者 | ユーザー、役割、作業場所、判型、優先度、既定フォルダ、CSV レイアウト版 |
| S-09 | 操作ログ | 管理者 | 検索・表示 |

項目・操作の詳細は [仕様書](kimura_kokuhosha_specification_20261010.md)。

---

## 5. データ設計（補助DB・主要テーブル）

| テーブル | 内容 | 主な列 |
|----------|------|--------|
| users | 利用者 | id, name, login_id, password_hash, role, is_active |
| customers_cache | 得意先の写し | oracle_customer_code, name, short_name, synced_at |
| pdf_files | アップロード原本 | id, file_name, stored_path, pages, uploaded_by, uploaded_at, status |
| order_drafts | 注文（仮） | id, draft_no（DRAFT-YYYYMMDD-NNN）, source（pdf／manual／excel／mail）, pdf_file_id, customer_code, customer_name_raw, kind（新刊／重版）, title, copies, format_code（判型）, spec_ajiro, spec_mikaeshi, spec_tryauto, sig16_count, sig8_count, sig_tentative, sample_date, delivery_date, requested_date, decided_date, decided_factory, note, status, approved_by, approved_at |
| order_draft_fields | 解析証跡 | draft_id, field_name, raw_text, parsed_value, confidence, page, bbox, edited_by_user |
| export_batches | CSV 出力履歴 | id, file_name, layout_version, record_count, exported_by, exported_at, result_status, result_detail |
| export_batch_items | 出力した draft | batch_id, draft_id, line_no, import_result |
| work_places | 作業場所 | id, name（板橋1F…）, sort, is_spare |
| schedule_weeks | 週 | id, start_date, status |
| schedule_cards | 予定表カード | id, week_id, draft_id（null なら手追加）, work_place_id, work_date, position, work_hours, is_blocked, memo, created_by |
| schedule_moves | 入れ替え記録 | card_id, from, to, by_user, reason, moved_at, was_auto_proposed |
| auto_plan_runs | 自動配置の実行 | id, week_id, rule_version, proposed_json, confirmed_by, confirmed_at, rejected |
| formats | 判型マスタ | code, name（A6判〜菊判変型 25種）, sort |
| priorities | 優先度 | code, name, weight |
| audit_logs | 操作ログ | user_id, action, target, detail, at |

- 注文番号は Oracle 採番。補助DB は draft_no と、取込結果で戻る Oracle 番号（戻る場合）だけ持つ
- 補助DB に得意先の **新マスタは作らない**。customers_cache は写し

### draft の状態

```text
uploaded → parsing → review → approved → exported → imported
                       ↓                     ↓
                    rejected              import_error → review（直して再出力）
```

---

## 6. CSV 連携 方式

### 6.1 決まっていること（開発会社資料 2026-09-29）

| 項目 | 内容 |
|------|------|
| 形式 | CSV 等のテキスト |
| レイアウト | **開発会社が設計・提示** |
| タイミング | 手動実行。既定フォルダに置いて取込プログラムを起動 |
| 重複防止 | 同一ファイル名は取込エラー |

### 6.2 tugilo 側の設計

| 項目 | 設計 |
|------|------|
| ファイル名 | `ORDER_YYYYMMDD_HHMMSS_NNN.csv`。常に新規。再出力も新しい名前 |
| 文字コード・改行 | 開発会社提示に従う（候補: Shift_JIS／CRLF。VB 側に合わせる） |
| 1ファイルの単位 | 事務が選んだ承認済み draft（既定は「未出力の承認済み全部」） |
| 控え | 同じ内容をサーバー内に保存。export_batches に記録 |
| 出力後 | draft を exported に。取込結果が戻れば imported／import_error |
| 項目 | 生産依頼表の項目を基本に、受注ヘッダー／明細（TTJUCUHD／TTJUCUDT）の必須列へ対応。対応表は仕様書 §5 |

### 6.3 開発会社の確認事項への tugilo 案

| 確認事項 | tugilo 案 | 代替 |
|----------|-----------|------|
| 取込結果の通知方法 | 取込プログラムが **結果ファイル**（同名 + `_result.csv`: 行番号・結果・メッセージ）を既定フォルダに書く。Web が読んで draft に反映 | 結果は VB 画面で見るだけにし、Web は exported 止まり（人が確認） |
| 既存データの UPDATE／DELETE | **初回は INSERT のみ。** 承認済みの修正・取消は VB 側で行う運用。Web 側は exported 後の draft を編集不可にする | 将来、取消 CSV（取消フラグ列）を追加 |
| 得意先の照合 | Web は Oracle 得意先コードを持って出す。コードが無い行は出力前にエラーにする | 得意先名で出し、取込側で照合 |

---

## 7. 自動配置 v1（ルール）

| 項目 | 内容 |
|------|------|
| 入力 | 対象週、未配置カード、配置済みカード（固定可）、作業場所の稼働枠（日ごとの時間）、各カードの 納期（決定日／配本日／希望日）、作業時間、優先度、仕様（アジロ等・前後工程の制約があれば） |
| ルールの順 | 1) 納期が近い順 2) 優先度が高い順 3) 同じ場所の空き時間に入る順 4) 予備列は本列が埋まってから 5) 作業時間が未入力のカードは末尾に置き、要入力の印 |
| 出力 | 提案（カードごとに 日付・場所・位置）と理由（納期／優先度／空き）。現状との差分 |
| 確定 | 予定組み担当が S-07 で見て確定。確定まで予定表は変わらない |
| 記録 | 提案と、人が確定前後に動かした内容を auto_plan_runs／schedule_moves に残す。v2 のルール見直しに使う |
| 検証 | 1月の並行テストで、現行の手組みと並べて比べる。差の理由を毎週拾う |
| v2（便利） | 前後工程の生産性指標、提案理由の詳細表示、履歴からの重み調整 |

ルールの条件は **10月の担当者 Zoom** で聞き取り、仕様書 §6 に落とす。

---

## 8. 権限

| 役割 | 注文入力 | 承認 | CSV 出力 | 予定表 | 自動配置確定 | 設定 |
|------|----------|------|----------|--------|--------------|------|
| 事務 | ○ | ○ | ○ | 閲覧 | — | — |
| 予定組み | 閲覧 | — | — | ○ | ○ | — |
| 管理者 | ○ | ○ | ○ | ○ | ○ | ○ |

---

## 9. ログ・証跡

- 操作ログ: 承認、差し戻し、CSV 出力、再出力、配置確定、ユーザー変更
- 解析証跡: 項目ごとの元テキスト・位置・信頼度・人が直したか
- 出力控え: CSV 本体をサーバー内に保存（保存期間 要確認。目安1年）

---

## 10. 非機能

| 項目 | 内容 |
|------|------|
| 利用場所 | 社内 LAN のみ。外部公開なし |
| 同時利用 | 数名 |
| 性能 | PDF 1件の解析 数秒〜十数秒。予定表の表示 1秒程度 |
| バックアップ | DB ダンプ・PDF 原本・CSV 控えを日次。復元手順を引き渡す |
| 可用性 | 営業時間内。停止時は従来の手入力に戻れる（補助DB は正でないため） |
| セキュリティ | HTTPS（社内証明書）、パスワード、役割、ログ。Oracle は読み取り専用アカウント（使う場合） |
| 運用 | Docker 再起動手順、ディスク監視、月次確認 |

---

## 11. 開発会社との境界・確認事項

| # | 確認事項 | 期限目安 |
|---|----------|----------|
| 1 | CSV レイアウト（項目・順・型・文字コード・改行） | 10月末 |
| 2 | 既定フォルダの場所・書き込み権限 | 10月末 |
| 3 | 取込結果の通知方法（§6.3） | 11月中 |
| 4 | UPDATE／DELETE の扱い（§6.3） | 11月中 |
| 5 | 得意先コードの照合方法。Oracle 読み取り接続の可否 | 11月中 |
| 6 | 取込口の完成時期（12月末目標） | 10月中に合意 |
| 7 | 結合テストの日程（12月・1月） | 11月中 |

---

## 12. 未確定（要件定義で決める）

- 置き場所（案A Hyper-V／案B 専用PC）
- 主要1社の社名・PDF サンプル追加
- 予定表 Excel 実ファイルと、Oracle から引いている項目
- VB で直接入力された注文を予定表に出す方法（Oracle 読み取り／CSV 受領）
- 作業場所の稼働枠（日ごとの時間）
- 優先度の定義
- 保存期間
