# members 重複の発生条件・影響・マージ運用（Runbook）

**プロダクト:** Religo  
**リポジトリ内部名:** dragonfly  

**親 SSOT:** [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md)（SPEC-007）  
**状態:** active（運用手順・調査整理。**自動マージ機能は未実装**。本書は **推測による同一人物判定を採用しない** 前提）

**関連 Phase:** MEMBERS-DEDUP-RUNBOOK-P0（docs）

---

## 1. 目的

visitor / guest が正式 **member** になったあとも **`members.id` が 1 人 1 行**に保たれるよう、

- 重複が **いつ・なぜ**起きうるか（発生条件）
- **業務・データへの影響**
- **まず運用で防ぐ**手順（案 A）
- **将来の補助実装**（案 B/C）の段階案

を共通言語として固定する。

---

## 2. 現行インポート経路と「合わせキー」の違い

同一リポジトリ内でも **経路ごとに Member の探し方が異なる**。ここが重複や齟齬の温床になる。

| 経路 | 主な実装 | 既存 Member の探し方（要約） | type 変更（visitor→member）時 |
|------|----------|-------------------------------|--------------------------------|
| **定例会参加者 CSV（Artisan）** | `ImportParticipantsCsvCommand::resolveOrCreateMember` | **`type` + `name` の完全一致**で 1 件検索。あれば更新、なければ `create` | **別 type なので一致しない → 新規行が追加されやすい**（同名でも） |
| **Meeting CSV import（プレビュー/Apply）** | `ApplyMeetingCsvImportService` + `MeetingCsvMemberResolver` | **resolution マップ優先**、なければ **`name` 完全一致**で既存を再利用（先頭 ID）。type は行に応じて付与されうる | resolution / 名前先頭一致に依存。**CLI と挙動が一致しない**場合がある |
| **PDF 候補の Apply** | `ApplyParticipantCandidatesService` | `matched_member_id` 優先、なければ **`name` のみ**で `first()` | **type をまたいで同一行を再利用**しうる（名前一致時） |

**示唆:** 「CSV を取り込んだら自動で visitor と member が 1 行にまとまる」とは **限らない**。特に **Artisan 参加者 CSV** は **type が変わると別レコード**になりやすい。

---

## 3. 重複発生パターン（代表）

| # | 条件 | 典型例 |
|---|------|--------|
| P1 | **visitor/guest 行が残ったまま**、同じ氏名で **メンバー**行が **別 `member_id`** で追加される | 入会後の名簿で「メンバー・No12・山田」が来たが、DB にはまだ「visitor・V1・山田」がある → CLI は `type=member` で検索し **新規作成** |
| P2 | **表記ゆれ**（全角半角・スペース・旧姓など）で **名前が一致しない** | visitor「山田太郎」と member「山田　太郎」→ 別レコード |
| P3 | **同名の別人**が先に存在し、**名前のみ**の解決で **誤った行に紐づく**（重複ではなく **誤結合リスク**） | Meeting CSV の `MeetingCsvMemberResolver` が同名複数時に **id 昇順先頭**を採用 |
| P4 | 過去回の **`participants` は古い `member_id` のまま**残り、マスタだけ新 ID に増える | 履歴上「その回はビジター」は正しいが、画面によっては **同一人物が 2 ID** に見える |
| P5 | **手入力・別ツール**で Member を追加し、後から CSV が別行を作る | 運用外データとの不整合 |

---

## 4. 業務・データへの影響（重複が残った場合）

- **検索・一覧:** 同一人が 2 行出る、Connections の左ペインで **別人扱い**。
- **関係ログ:** `contact_memos` / `dragonfly_contact_flags` / `dragonfly_contact_events` / `one_to_ones` / `introductions` は **`member_id` 単位**。片方の ID にしか紐づかないと **履歴が分断**。
- **紹介者・アテンド:** `members.introducer_member_id` / `attendant_member_id` / `participants` 側 FK が **古い ID を指したまま**になりうる。
- **参加者・BO:** `participants.member_id` が回ごとに別 ID に分かれると、**同室履歴の集計**や運用レポートが分断。
- **CSV resolution:** `meeting_csv_import_resolutions` が **どちらの `member_id` に張るか**で以降の apply が変わる。

**削除の難しさ:** `participants` 等に **restrictOnDelete** が付くテーブルがあり、単純削除で片付かない場合がある。**マージは「勝ち ID への FK 付け替え + 負け行の廃止」**が基本（アプリ機能または慎重なバッチ）。

---

## 5. 推奨運用（案 A: まずは運用で防ぐ）

**大規模実装なしで効く順**に並べる。

1. **名簿確定・入会確定のタイミング**で、担当者が **「既存 visitor/guest 行を正として更新」**する方針を決める（SPEC-007 §3.1 と同方向）。
2. **Artisan 参加者 CSV を流す前**に、当該名が **既に visitor/guest として存在するか**を一覧（管理画面または DB 閲覧）で確認し、  
   - **同一人物なら** 先に **手動で `members` を `type=member`・正式 `display_no` に更新**してから CSV を流す、または  
   - CSV 後に **重複が出たら即座にマージ手順（§6）**へ回す。
3. **氏名の正規化ルール**（スペース除去・表記統一）を **CSV 入力規約**に書く（完全自動判定はしない）。
4. **本番データの直接 UPDATE は禁止**（バックアップ・検証なしの手直し禁止）。緊急時も **手順と担当二名**を決めてから。

---

## 6. マージ運用手順（案・概念）

**前提:** 「同一人物である」と **業務で確定した** 2 つの `member_id` があり、**片方を canonical（勝ち）** に寄せる。

1. **勝ち ID の決定:** 通常は **正式メンバー番号が付いた行**、または **これから使う公式行**。
2. **影響範囲の洗い出し（読み取りのみ）:** `participants` / `one_to_ones` / `contact_memos` / flags / introductions / `member_roles` / resolutions 等で **負け ID 参照**の有無。
3. **付け替え:** 参照を **勝ち ID に更新**（トランザクション推奨）。
4. **負け行の扱い:** 削除できるなら削除、**restrict** で消せない場合は **アーカイブ方針**（論理フラグ等は未実装なら **別 Phase**）。
5. **検証:** 画面で当該人物の **履歴・例会・1to1** が期待どおり 1 系統になるか確認。

**本番での一括 SQL は Runbook の対象外**（バックアップ・レビュー・ロールバック計画が必須のため）。将来 **案 B** の UI または **管理用 Artisan** で **ドライラン付き**にすることが望ましい。

---

## 7. 補助実装の段階案（難易度イメージ）

### 案 B: 管理画面でマージ補助（中〜大）

- **最小:** 「2 `member_id` を選び、**参照テーブル一覧を表示**（件数のみ）→ 実行は管理者のみ」ドライラン。
- **標準:** 付け替え対象を **チェックリスト化**し、トランザクションで更新。
- **難所:** FK 網羅・`unique` 制約（同一 `(owner,target)` など）の衝突解消ルール。

### 案 C: import 時の同一人物候補提示（大）

- CSV 行ごとに **名前ゆれ・類似**で候補を出すが、**自動確定はしない**（M8/M9 の resolution 思想と整合）。
- **誤結合コストが高い**ため、閾値・監査ログ・ロールバックが前提。

### 7.1 実装済み（MEMBERS-MERGE-ASSIST-P1・案 B の最小）

- **API:** `POST /api/admin/member-merge/preview` · `POST /api/admin/member-merge/execute`（ヘッダ `X-Religo-Member-Merge-Token` = 環境変数 `RELIGO_MEMBER_MERGE_TOKEN`。未設定時は **404** で非公開）
- **UI:** 管理画面 `/member-merge`（プレビュー JSON 表示・確認フレーズ `MERGE {merge_id} INTO {canonical_id}` 後に実行）
- **付け替え対象:** `MemberMergeService` が担当（participants / contact_memos / flags / events / one_to_ones / introductions / member_roles / members FK / csv resolutions / users.owner_member_id / bo_assignment_audit_logs / meeting_csv_apply_logs 等）。**同一 `meeting_id` に両方 participants がある場合はブロック**。
- **未対応（別検討）:** PDF 取込 `candidates` JSON 内の `matched_member_id`、自動重複検知一覧。

---

## 8. 実装難易度別の位置づけ

| レベル | 内容 | 備考 |
|--------|------|------|
| **最小** | Runbook の徹底・CSV 入力規約・手動マージ手順のテンプレ化 | コスト低・即日から |
| **標準** | 管理画面の「重複疑い一覧（名前同一・type 違い）」**表示のみ** | 読み取り API + UI |
| **将来** | マージウィザード・import 候補・監査ログ | 設計・テスト工数大 |

---

## 9. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-03-31 12:00 JST | 初版（MEMBERS-DEDUP-RUNBOOK-P0）。インポート経路別キー整理・重複パターン・影響・案 A/B/C。 |
| 2026-04-20 22:18 JST | 7.1: 最小マージ補助（API・トークン・UI）を追記（MEMBERS-MERGE-ASSIST-P1）。変更履歴の日時表記を整理。 |
