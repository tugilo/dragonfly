# Phase M7-P11-REQUIREMENTS: ChatGPT作成CSVのアップロード連携 要件整理 — WORKLOG

**Phase:** M7-P11-REQUIREMENTS  
**作成日:** 2026-03-17

---

## 既存 M7 の確認内容

- MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS: PDF を Meeting に紐づけ、解析→候補→確認→反映の B 案で P1〜P10 まで実装済み。参加者PDFブロック・解析・候補編集・手動マッチング・反映・再解析導線あり。
- DATA_MODEL: participants は meeting_id, member_id, type, introducer_member_id, attendant_member_id。members は name, name_kana, category_id, type, display_no 等。種別は regular / visitor / guest / proxy。
- ImportParticipantsCsvCommand: meeting_number + csv_path + held_on で CSV を読み、種別・名前必須。メンバー/ビジター/ゲスト/代理出席を TYPE_MAP で member type と participant type に変換。Member::updateOrCreate（type+display_no キー）、Participant::updateOrCreate。紹介者・アテンドは名前で解決。カテゴリーは group_name+name で firstOrCreate。
- サンプル dragonfly_201_20260317_all_csv.txt: 種別, No, 名前, よみがな, 大カテゴリー, カテゴリー, 役職, 紹介者, アテンド, オリエン。メンバー・ビジター・代理出席・ゲストの行がある。

## CSV 運用への切り替え意図

- PDF 解析だけでは 1 人 1 行の精度が出しにくく、調整コストがかかる。ChatGPT で PDF→CSV を作る運用は実績があり精度が高いため、「CSV を正」として取り込み、実運用を安定させたい。PDF 解析は否定せず、候補生成として残し、CSV を確定データに近い入口とする。

## 比較した案

- **業務フロー:** A（アップロード→即反映）、B（アップロード→確認・修正→反映）、C（PDF と CSV 両方保持・CSV 優先反映）。B を推奨（確認で誤りを減らせる）。
- **データ:** CSV を Meeting に紐づけて保存。PDF と CSV は別テーブル（meeting_csv_imports 等）にする案を推奨。participants は全置換。反映履歴は PDF と同様 imported_at / applied_count を検討。
- **画面:** 参加者PDFブロックの近くに参加者CSVブロックを追加。プレビュー表・「反映」ボタン。PDF 由来候補と CSV 由来は別導線で、「出典」を分かるようにする。

## 判断理由

- 案B にした理由: 誤った CSV をそのまま反映すると participants が壊れる。プレビューと簡易修正を挟むことで、確定は人が「反映」で行う形にでき、PDF の「候補→確認→反映」と一貫する。
- 別テーブルにした理由: PDF フロー（meeting_participant_imports）を触らずに CSV 専用の履歴を管理できる。役割が分かりやすい。
- CLI 共通化: ImportParticipantsCsvCommand のロジックを Service に切り出し、Web アップロードからも同じパース・Member 解決・Participant 更新を使うと、仕様の一貫と保守が楽になる。

## まとめ

- 要件整理を docs/SSOT/MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md に集約。業務フローは案B、フェーズは C1（アップロード保存）→ C2（プレビュー）→ C3（反映）→ C4（履歴）→ C5（PDF との統合整理）。推奨方針は「CSV を確定に近い入力とし、プレビュー→反映。PDF は候補のまま残す」。
