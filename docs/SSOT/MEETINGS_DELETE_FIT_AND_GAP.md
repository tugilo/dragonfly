# Meetings 削除機能 — Fit & Gap / 削除ポリシー整理（調査 SSOT）

**Phase:** MEETINGS_DELETE_FIT_AND_GAP_CHECK（docs のみ・**実装なし**）  
**調査日:** 2026-03-19  
**ステータス:** 方針整理・次 Phase 判断用

**関連:** [DATA_MODEL.md](DATA_MODEL.md) §4.6–4.9、[MEETINGS_CREATE_FIT_AND_GAP.md](MEETINGS_CREATE_FIT_AND_GAP.md)、[FIT_AND_GAP_MEETINGS.md](FIT_AND_GAP_MEETINGS.md)

---

## 1. 調査目的

- Meetings の **DELETE API / UI が未実装**である一方、子機能（participants / BO / メモ / PDF / CSV 等）が `meeting_id` 前提で存在する。
- **削除を実装してよいか**、**先に決めるべき業務・技術条件**は何かを、SSOT・モック・マイグレーション・既存 Phase 記述から整理する。
- 次の **implement Phase に進むか**を判断できる材料を SSOT として残す（**今回はコード変更なし**）。

---

## 2. 確認した資料・実装

### 2.1 SSOT / Docs

| 資料 | 内容（削除関連） |
|------|------------------|
| `DATA_MODEL.md` §4.6 | POST/PATCH の記載あり。**「削除は別 Phase」** と明記。子テーブルとの FK は §4.7 以降に cascade/null 記載。 |
| `DATA_MODEL.md` §4.7–4.9 | participants / breakout_rooms / participant_breakout の **meeting_id または間接の cascade** の説明。 |
| `FIT_AND_GAP_MEETINGS.md` | 例会 **削除の要件記述なし**。メモは PUT で空削除（**meeting 行削除ではない**）。 |
| `FIT_AND_GAP_MOCK_VS_UI.md` | Meetings は一覧・Drawer・メモ等。**例会削除 UI の記載なし**（create 調査時も同様）。 |
| `MEETINGS_CREATE_FIT_AND_GAP.md` | 作成・更新実装済み・**削除未着手**。 |
| `PHASE_MEETINGS_CREATE_*` / `UPDATE_*` | **delete は非スコープ**。REPORT の残課題・次 Phase に削除を列挙。 |

### 2.2 モック（`religo-admin-mock-v2.html` `#/meetings`）

- 例会一覧・詳細・メモモーダル・Connections 導線。**例会行の「削除」ボタンやメニューは見当たらない**（grep 上も delete 導線なし）。
- **Fit:** 実装 UI に削除がなくてもモックと矛盾しない。  
- **Gap（要件）:** モックは「削除不要」を意味するかは **未確定**（画面スコープが「運用中の例会管理」までの可能性）。

### 2.3 実装（API / UI）

| 対象 | 結果 |
|------|------|
| `MeetingController` | `index` / `stats` / `show` / `store` / `update`。**destroy なし**。 |
| `routes/api.php` | `DELETE` は `meetings/{id}` **本体なし**。CSV resolutions の `DELETE` のみ（**meeting 削除ではない**）。 |
| `MeetingsList.jsx` | 新規・編集・メモ・BO 等。**例会削除 UI なし**。 |
| `Meeting` モデル | `hasMany` / `hasOne` で子リレーション定義。削除ロジックなし。 |

### 2.4 マイグレーション上の `meetings.id` 参照（確認済み）

**`ON DELETE CASCADE`（meeting 行削除で子行も DB が削除）**

| 子テーブル | 備考 |
|------------|------|
| `participants` | 当該回の参加記録が全消去。 |
| `breakout_rooms` | `meeting_id` cascade。 |
| `breakout_rounds` | `meeting_id` cascade。 |
| `breakout_memos` | `meeting_id` cascade。 |
| `meeting_participant_imports` | 参加者 PDF 1:1。**cascade**。 |
| `meeting_csv_imports` | CSV アップロード履歴。**cascade**。 |
| `meeting_csv_apply_logs` | 反映監査ログ。**cascade**。 |

`meeting_csv_import_resolutions` は `meeting_csv_import_id` → imports **cascade** のため、**meeting 削除 → imports 削除 → resolutions 連鎖削除**。

**`ON DELETE SET NULL`（meeting 削除で参照を null）**

| 子テーブル | 備考 |
|------------|------|
| `contact_memos` | `meeting_id` nullable。**例会紐付きメモは参照が外れるが行は残る**（本文・種別は残存）。 |
| `one_to_ones` | `meeting_id` nullable。予定・履歴の **関連例会だけ失われる**。 |
| `introductions` | `meeting_id` nullable。 |
| `dragonfly_contact_events` | `meeting_id` nullable（存在する環境）。 |

**間接連鎖:** `participant_breakout` は `participant_id` / `breakout_room_id` 双方 cascade のため、**participant または breakout_room 削除で消去**。meeting 削除 → participants / breakout_rooms 削除で **同室履歴も消去**。

### 2.5 Seeder / CLI

- `ImportParticipantsCsvCommand::resolveMeeting` は `number` で `firstOrCreate`。**meeting を削除すると `number` は UNIQUE 上解放され、同一番号で再インポート時は新規行になり得る**（id は別）。運用上「同一例会の継続」と整合するかは **要合意**。

---

## 3. 業務上 delete が必要な場面

| 場面 | 整理 |
|------|------|
| **誤って作成した空の例会** | create 実装後、番号・日付ミスで **子なしのゴミ行**ができる。**PATCH で修正できる**ため、削除は「作り直しより消したい」心理に依存。**要合意: 編集で足りるか**。 |
| **テストデータの掃除** | 開発・検証では削除欲求が強い。**本番と同じ API でよいか**は別論（管理限定・バッチでも可）。 |
| **「存在しないことにしたい」** | 会の地図・同室・参加履歴の SSOT 上、**過去の会を消すと履歴が欠ける**。BNI 週次例会では **監査・トレース**の観点から **物理削除は慎重**になりやすい。 |
| **表示だけ消したい** | 実態は **論理削除 / アーカイブ / 一覧フィルタ**で足りる可能性。**「削除」という言葉と要件を分離してヒアリングが必要（未確定）**。 |

**結論（調査時点）:** 「必ず削除 API が要る」とまでは SSOT からは読み取れない。**業務ヒアリングで優先シナリオを確定する必要がある（要合意）**。

---

## 4. モック / SSOT / 実装の現状（Fit / Gap 要約）

| 観点 | Fit | Gap |
|------|-----|-----|
| モック | 削除導線なし＝現 UI と整合 | 将来モックに削除を足すか **未確定** |
| SSOT | DATA_MODEL に FK・「削除は別 Phase」 | **削除時の振る舞い・禁止条件の SSOT 未記載** |
| 実装 | DELETE 未実装で事故リスクは低い | 実装する場合は **ポリシー未定のまま DB cascade に乗ると大量消去**になり得る |

---

## 5. meetings に紐づく子データ一覧（機能視点）

| 区分 | データ / 機能 | DB 上の主な載り先 |
|------|----------------|-------------------|
| 参加 | participants（種別・紹介者等） | `participants` |
| 同室 | BO ルーム・ラウンド・割当・BO メモ | `breakout_rounds`, `breakout_rooms`, `participant_breakout`, `breakout_memos` |
| メモ | 例会メモ（1 会議あたり運用は実装依存） | `contact_memos`（`memo_type=meeting`） |
| PDF | 参加者 PDF 取込 | `meeting_participant_imports` |
| CSV | アップロード・resolutions・apply ログ | `meeting_csv_imports`, `meeting_csv_import_resolutions`, `meeting_csv_apply_logs` |
| その他 | 1to1 / 紹介 / contact_events の関連例会 | `one_to_ones`, `introductions`, `dragonfly_contact_events` |

---

## 6. 各子データの削除影響

表は **「meetings 行を DB から物理削除した場合」** のマイグレーション既定の挙動に基づく。

| 子 | FK 動き | 業務的意味 | 削除してよいか（観点） |
|----|---------|------------|-------------------------|
| participants | **CASCADE** | その回の出席・種別・紹介関係 | **消すと「誰がその回にいたか」が失われる**。履歴重視なら危険。 |
| breakout 系 | **CASCADE**（rooms/rounds/memos、間接で participant_breakout） | 同室履歴 | **会の地図の根拠データ喪失**。 |
| meeting_participant_imports | **CASCADE** | PDF・解析候補 | ファイルストレージの扱いは **別途（孤児ファイルリスク）要確認**。 |
| meeting_csv_imports + resolutions + apply_logs | **CASCADE** | 取込・未解決マッピング・監査 | **監査ログまで消える**（apply_logs）。 |
| contact_memos | **SET NULL** | 例会メモ | meeting 参照だけ外れ **本文は残る**。一覧の「例会メモ」集計からは外れるが **テキストは残存**（ゴミデータ化し得る）。 |
| one_to_ones / introductions / contact_events | **SET NULL** | 関連付け | **文脈欠落**（いつの例会か分からなくなる）。 |

**まとめ:** マイグレーションは **「meeting 削除＝多くの子を物理消去」** か **「参照 null で孤児化」** の二系統。**アプリで DELETE を追加するだけでは、意図しないデータ喪失が起き得る（Gap / リスク）**。

---

## 7. 削除ポリシー案 A / B / C / D / E の比較

| 案 | 内容 | メリット | デメリット / リスク |
|----|------|----------|---------------------|
| **A** | **物理削除は「子が存在しない（厳密定義）」ときのみ許可** | 誤操作での連鎖消去を防ぎやすい。履歴リスクが小さい。 | 条件定義・実装チェックの網羅が必要。PDF/CSV/0 件 participants 等の境界 **要合意**。 |
| **B** | **物理削除＋子もすべて cascade 許容**（現行 FK のまま） | 実装は単純（`Meeting::delete()`）。 | **監査・参加・同室・取込履歴が一括消失**。本番運用では **非推奨になりやすい**。 |
| **C** | **論理削除**（`meetings.deleted_at` または `is_active`） | 一覧から消せる。復元・監査に強い。 | **マイグレーション・全クエリ修正**の波及が大きい（今回スコープ外だが実装コスト高）。 |
| **D** | **削除禁止**。**アーカイブ / 非表示**のみ（例: `archived_at` または一覧フィルタ） | データ喪失なし。運用で「見えない」にできる。 | スキーマ追加またはフィルタ規約の整理が必要。**「消したい」心理とのギャップ**は説明でカバー。 |
| **E** | **条件付き削除**（例: participants 0 かつ breakout 0 かつ PDF/CSV なし かつ meeting メモなし） | ゴミ行除去に特化。A の実務版。 | 条件の **正式定義**がプロダクト判断。**一部だけある**（例: メモのみ）ときの UX（先に空にする誘導）が必要。 |

---

## 8. 推奨方針（調査時点・実装前の提案）

1. **いきなり案 B（無条件 DELETE + 既存 cascade）を一般ユーザー向け UI に載せない。** データ喪失範囲が大きく、SSOT の「会の地図」とも衝突しやすい。  
2. **業務ヒアリングで「本当に消す」のか「直す / 隠す」のかを切り分ける。** 多くの場合 **PATCH + 運用** または **非表示（案 D 系）** で足りる可能性がある（**未確定・要合意**）。  
3. **削除を許すなら案 A または案 E** を推奨: **明示的条件**＋二重確認ダイアログ＋**消える対象の一覧表示**。**contact_memos の SET NULL 残存**もユーザー向け文言で説明。  
4. **論理削除（案 C）** は、長期監査・復元要件が明確になった場合の **別 Phase で設計**。スキーマと一覧/ stats / 外部キー整合を DATA_MODEL に先に書く。  
5. **number の再利用:** 物理削除後は UNIQUE 上 **再利用可能**。運用で **欠番を残す / 再利用する** を決めないと、CLI・レポートで混乱（**要合意**）。  
6. **削除導線:** 一覧より **Drawer 内の危険操作**、または **管理者限定・二段階**が自然。**モックに無いため、実装時は FIT_AND_GAP に追記推奨**。

---

## 9. 実装する前に先に決めること

| # | 論点 | 状態 |
|---|------|------|
| 1 | **本番で削除が必要なシナリオ**は何か（誤作成のみか、履歴抹消か） | **要合意** |
| 2 | **許可条件**（案 E の正式定義: PDF/CSV/メモ/BO/participants の有無） | **要合意** |
| 3 | **contact_memos** を残す（SET NULL）でよいか、事前にメモ削除を必須にするか | **要合意** |
| 4 | **ストレージ上の PDF ファイル**の削除／孤児化の扱い | **未確定・要確認** |
| 5 | **number 再利用**と欠番の運用 | **要合意** |
| 6 | **権限**（誰が削除できるか）— 現状 API に auth なしのため、削除実装時は **必ずセットで検討** | **要合意** |
| 7 | DATA_MODEL §4.6 に **削除ポリシー SSOT** を追記してから実装するか | **推奨** |

---

## 10. 次 Phase 提案

| 順 | 内容 |
|----|------|
| 1 | **docs（短）:** ステークホルダー合意を取り、§9 の表を **確定値で埋める**（または「削除不要」と決める）。 |
| 2 | **docs:** `DATA_MODEL.md` §4.6 に **削除の許可条件・挙動・メモ/set null の説明**を SSOT 化。 |
| 3 | **implement（別 Phase）:** `DELETE /api/meetings/{id}` または **アーカイブ PATCH** のどちらかを実装。条件付きなら **トランザクション内で子カウント検証**後に `delete`。 |
| 4 | **UI:** モック比較・`FIT_AND_GAP_MEETINGS.md` 更新。 |

---

**本ドキュメントは調査のみを記録する。コード・マイグレーション・API の変更は行っていない。**
