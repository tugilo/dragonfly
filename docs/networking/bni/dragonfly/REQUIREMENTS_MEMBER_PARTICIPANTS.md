# 要件定義：メンバーマスター・参加者・ブレイクアウトメモ

**対象:** BNI DragonFly 定例会の「誰が参加したか」「誰と同室したか」「その人へのメモ」を管理する機能  
**元資料:** [BNI_DragonFly_All_Participants_20260303.md](participants/BNI_DragonFly_All_Participants_20260303.md) / [BNI_DragonFly_Breakout_20260303.md](participants/BNI_DragonFly_Breakout_20260303.md)  
**作成日:** 2026-03-03

---

## 1. 要望の整理

| # | 要望 | 対応方針 |
|---|------|----------|
| 1 | メンバーマスターと participants テーブルを作成する | マスター＝人物の登録情報、participants＝「その回の参加者」として分離 |
| 2 | 今日の参加者がわかるようにする | 定例会（meetings）ごとに participants で「誰が参加したか」を記録 |
| 3 | ブレイクアウトで一緒になった人を簡単に抽出する | 同室グループ（breakout_rooms / participant_breakout）で紐付け |
| 4 | 一緒になった人に対してメモを追加したい | **ミーティング単位のメモ** として持つ（理由は後述） |

---

## 2. 要件サマリ

### 2.1 やりたいこと（ユースケース）

1. **参加者一覧の管理**  
   - 毎回の参加者リスト（メンバー／ビジター／ゲスト）を、その回（定例会）に紐づけて登録・参照できる。
2. **「今日の参加者」の確認**  
   - 指定した定例会について「誰が参加したか」を一覧で見られる。
3. **ブレイクアウト同室者の抽出**  
   - ある参加者を指定したとき、「その回で同じブレイクアウトルームにいた人」を一覧で取得できる。
4. **同室者へのメモ**  
   - 同じルームにいた人に対して、「この回で気づいたこと・フォローしたいこと」をメモとして保存・参照できる。

### 2.2 メモを「マスター」と「ミーティング」のどちらに持つか

**結論: ミーティング（その回）単位のメモとすることを推奨します。**

| 観点 | マスターに持つ | ミーティング単位で持つ（推奨） |
|------|----------------|--------------------------------|
| 意味 | 「その人についての恒常的なメモ」 | 「その回で同室したときのメモ」 |
| 例 | 「紹介したい取引先がいる」「話しやすい」 | 「第199回で〇〇の話をした。後日連絡する」 |
| 時系列 | 1人1メモ欄が増えていく | 回ごとに残るので「いつ」が明確 |
| ブレイクアウトとの対応 | どの回の同室か分かりにくい | 「第199回の同室メモ」と自然に対応 |
| 運用 | マスターが肥大化しやすい | 回ごとに閉じるので管理しやすい |

**推奨:**  
- **members（マスター）:** 氏名・ふりがな・カテゴリー・役職・区分（メンバー/ビジター/ゲスト）など、**人物の属性のみ**。  
- **ミーティング単位のメモ:** 「その定例会で、誰と同室して、誰に対してどんなメモを残すか」は **participants / breakout_rooms / 同室メモ用テーブル** で持つ。

「この人についての恒常メモ」も将来欲しくなった場合は、`member_notes` のような「メンバーID + 自由メモ」テーブルを後から追加する形がよいです。

---

## 3. データモデル要件

### 3.1 テーブル構成案

| テーブル | 役割 | 主な項目例 |
|----------|------|------------|
| **members**（メンバーマスター） | 人物のマスタデータ。BNI のメンバー・ビジター・ゲストを一括で登録 | id, name, name_kana, category, role_notes, type(メンバー/ビジター/ゲスト), display_no（表示用 No）, 紹介者_id, アテンド_id, timestamps |
| **meetings**（定例会） | 第何回・いつ実施したか | id, number（回数）, held_on（日付）, name など |
| **participants**（参加者） | 「その回に誰が参加したか」 | id, meeting_id, member_id, 区分(メンバー/ビジター/ゲスト), 紹介者_id, アテンド_id（ビジター/ゲスト用）, timestamps |
| **breakout_rooms**（ブレイクアウトルーム） | その回のルーム単位 | id, meeting_id, room_label（例: A, B, C）または order |
| **participant_breakout**（参加者⇔ルーム） | 誰がどのルームに入ったか | id, participant_id, breakout_room_id |
| **breakout_memos**（同室メモ） | 同室した相手へのメモ（ミーティング単位） | id, participant_id（メモを書いた人）, target_participant_id（メモ対象の同室者）, breakout_room_id, meeting_id, body（メモ本文）, timestamps |

- **「今日の参加者」** → `meetings` + `participants` + `members` で一覧。
- **「一緒になった人を抽出」** → ある `participant_id` について、同じ `breakout_room_id` を持つ `participant_breakout` の他の `participant_id` を取得。
- **「その人へのメモ」** → `breakout_memos` に `target_participant_id` と `meeting_id` で保存し、回ごと・同室者ごとに参照。

### 3.2 区分・用語

- **区分（type）:** メンバー / ビジター / ゲスト（All_Participants の「区分」に準拠）。
- **participants** では、同じ `member_id` でも回によって「メンバー」で出たか「ビジター」で出たかは、原則としてその回の participants の type で持つ（履歴が残る想定）。
- 紹介者・アテンドは、元資料どおり「メンバー」の member_id を participants で参照する形で保持。

### 3.3 元データとの対応

- **All_Participants の 1 行** → 1 人の **member**（マスター）＋ その回の **participant**（meeting_id = 第199回）。
- **Breakout の「同室」チェック** → 同じルームにいる participant 同士を **participant_breakout** で同じ **breakout_room_id** に紐付け。
- **Breakout の「メモ」** → **breakout_memos** の body。target_participant_id に「同室した相手」の participant_id を指定。

---

## 4. 機能要件（一覧）

| ID | 機能 | 説明 |
|----|------|------|
| F1 | メンバーマスター登録・編集 | 氏名・ふりがな・カテゴリー・役職・区分などを登録・更新 |
| F2 | 定例会（meetings）登録 | 回数・日付を登録 |
| F3 | 参加者登録 | 指定した定例会に「誰が参加したか」を participant として登録（member と紐付け） |
| F4 | 今日の参加者一覧 | 指定した定例会について、参加者を区分・氏名・カテゴリーなどで一覧表示 |
| F5 | ブレイクアウトルーム登録 | その回のルーム（A/B/C…）を登録 |
| F6 | 同室者紐付け | 参加者を「どのルームに入ったか」で紐付け（同室者グループの作成） |
| F7 | 同室者の抽出 | ある参加者を指定したとき、同じルームの他の参加者一覧を取得 |
| F8 | 同室者へのメモ登録・表示 | 指定した「回＋自分＋相手（同室者）」に対してメモを1件登録・編集・表示 |
| F9 | 参加者一覧のインポート（将来） | All_Participants のような Markdown/CSV から members + participants を一括投入する補助 |

---

## 5. 非機能・制約

- 既存の Laravel プロジェクト（dragonfly www）に組み込む。
- DB は現在 SQLite；本番で MariaDB に切り替えても同じマイグレーションが使えるようにする。
- 個人情報を含むため、アクセス制御・表示範囲は今後のフェーズで検討する。

---

## 6. 今後の判断・保留

- **member_notes（マスター側の自由メモ）** は、運用で「恒常メモ」が必要になったタイミングで追加する。
- ブレイクアウトの「ルーム名」をシステムでどう持つか（A/B/C vs 番号のみ）は実装時に決定。
- 紹介者・アテンドを「その回の participant_id」で持つか、「member_id」で持つかは、履歴の扱いと相談して決定。

---

## 7. 次のステップ

1. 上記テーブル案で **マイグレーション** を作成（members, meetings, participants, breakout_rooms, participant_breakout, breakout_memos）。
2. **Eloquent モデル** とリレーション定義（Member, Meeting, Participant, BreakoutRoom, BreakoutMemo 等）。
3. F4（今日の参加者一覧）と F7（同室者抽出）から、必要な API または画面の要否を検討。
4. 必要なら、BNI_DragonFly_All_Participants_20260303.md の内容を **シードまたはインポート用スクリプト** で members / participants に投入する。

以上が、要望に基づく要件のまとめです。
