# Phase Meetings Participants PDF Requirements — WORKLOG

**Phase:** Meetings 参加者PDF取込 要件整理  
**作成日:** 2026-03-17

---

## 既存 Meetings 機能の確認内容

- **MeetingController:** GET /api/meetings（一覧、breakout_count, has_memo）、GET /api/meetings/stats、GET /api/meetings/{id}（詳細、memo_body, rooms）。参加者一覧は API では返していないが、MeetingAttendeesService で meeting_number 指定で member/visitor/guest 別に取得可能。
- **Meeting モデル:** id, number, held_on, name。participants(), breakoutRooms(), breakoutRounds(), breakoutMemos() のリレーションあり。
- **Participant モデル:** meeting_id, member_id, type（文字列。MeetingAttendeesService では member/visitor/guest でフィルタ）、introducer_member_id, attendant_member_id。participants は必ず member に紐づく（member_id 必須）。
- **ImportParticipantsCsvCommand:** 種別（メンバー／ビジター／ゲスト／代理出席）→ participants.type は regular/visitor/guest/proxy。名前・よみがな・大カテゴリー・カテゴリー・役職・紹介者・アテンドを CSV から読み、Member の updateOrCreate と Participant の updateOrCreate で投入。既存の「参加者登録」の実体はここにある。
- **MeetingsList.jsx:** 一覧・行アクション（メモ・BO編集）・行クリックで詳細 Drawer・メモ編集 Dialog。参加者取込の導線は現状なし。
- **結論:** 参加者データは participants + members で完結しており、PDF を「紐づけて保存する」テーブルや「抽出候補を保持する」中間テーブルはまだない。要件を満たすには新規の保存先と、必要に応じて取込履歴用テーブルが検討対象となる。

---

## 追加要件の整理

- 例会前日に送られるメンバー表 PDF を Meeting に登録したい。
- PDF を解析して参加者一覧を抜き出し、自動で（または半自動で）participants に登録したい。
- PDF 形式は毎回ほぼ同じ可能性が高いが、多少の揺れはありうる。100% 自動は前提にしない。
- 自動抽出 ＋ 人の確認・修正の流れを候補とする。
- BNI 的な区分（メンバー・ビジター・代理・ゲスト）が入る可能性がある。
- 1 meeting に対して参加予定者情報を持たせる形が基本。PDF 原本の保存要否も検討。
- 将来的には PDF 取込 → 参加者登録 → Connections / BO / メモへつながる可能性がある。

---

## 検討した選択肢

### 業務フロー

- **A案:** PDF を添付保存だけ。人が見て手で登録。→ 実装が軽く、リスクが小さい。参加者登録の手間は残る。
- **B案:** PDF を解析して参加者候補を抽出し、人が確認してから登録確定。→ 手間削減と正確性のバランスが良い。PDF 形式にある程度依存する。
- **C案:** 形式安定前提でかなり自動登録に寄せ、エラー時のみ手修正。→ 運用は楽だが誤登録リスクが高く、第一歩としては推奨しない。

**判断:** 第一歩は A または B の P1（PDF 保存）から始め、本格的な取込は B 案で P2〜P4 を段階的に実装する案をたたき台として推奨。

### データ構造

- participants はそのまま利用。PDF 由来の「取込候補」を保持するには、(1) 一時的な JSON のみ（DB に保存しない）、(2) meeting_participant_imports のような取込履歴テーブルに extracted_result を JSON で持つ、のいずれか。再取込・履歴を考慮すると (2) を推奨。
- 原本 PDF はストレージに保存し、import または meeting に 1:1 で紐づける形を想定。

### 画面導線

- 一覧の行アクションに「参加者取込」を追加する案と、詳細 Drawer 内に「参加者PDF登録／参加者取込」を置く案の両方を要件に含めた。実装 Phase でどちらを優先するか決める。

---

## 判断理由

- **100% 自動を前提にしない:** 既存 CSV 取込でも種別・名前の解釈は人が確認している。PDF はレイアウト崩れや表記ゆれがあるため、確定前に人の確認を入れる方が安全。
- **B案を推奨:** 手入力負荷を下げつつ、誤登録を防ぐため「抽出 → 確認 → 登録」の一歩を必須とする。
- **P1 を最初に:** PDF を保存するだけでも「その回の資料が Meeting に残る」価値がある。解析は P2 以降で段階的に導入できる。
- **既存構造を活かす:** participants の type / member_id / introducer / attendant は既存のまま。PDF 取込時も同じ形で投入し、既存 API・MeetingAttendeesService をそのまま使えるようにする。

---

## まとめ

- 要件整理ドキュメント（MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md）に、機能概要・背景・ユースケース・業務フロー A/B/C・画面・データ・Phase 案（P1〜P5）・リスク・推奨方針・今後の確認事項を記載した。
- 推奨は「P1 で PDF を Meeting に保存 → P2〜P4 で B 案の抽出・確認・登録を段階実装」。C 案および完全自動は第一歩では採用しない。
- 実装に進む場合は、実際の PDF サンプルでの抽出検証と、ストレージ・権限の確認を先行して行うことを推奨する。
