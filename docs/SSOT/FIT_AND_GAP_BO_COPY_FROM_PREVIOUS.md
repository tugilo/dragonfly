# Fit & Gap: BO 追加時の「直前 BO からメンバーコピー」

**調査日:** 2026-06-16 08:49 JST  
**対象画面:** Connections（`DragonFlyBoard.jsx`）— 中央ペインの BO（同室枠）割当  
**関連 SSOT:** [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md) §5.5、[CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md](CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md)、[MEETING_DOMAIN_IA.md](MEETING_DOMAIN_IA.md)  
**実装参照:** Phase **G11**（BO1→BO2 コピー）、**CONN-BO-UX-GUARDS-P1**（割当ガード）

---

## 1. 用語

| 用語 | 意味 |
|------|------|
| **BO** | Breakout 同室枠。UI 上は BO1, BO2, …。API では `room_label`（例: `"BO1"`）。 |
| **直前の BO** | 同じ Round 内で、表示順・`room_label` 番号が 1 つ小さい BO（BO2 の直前は BO1、BO3 の直前は BO2）。 |

※ 本調査ではユーザー表記の「BOR」は **同室枠 BO** と解釈する（Breakout Room の略称として同一概念）。

---

## 2. 要件整理（ユーザー要望）

### 2.1 背景

DragonFly の例会では、複数の同室枠（BO1, BO2, …）にメンバーを割り当てる。2 枠目以降は 1 枠目とメンバー構成が似ることが多く、毎回手入力は手間になる。

### 2.2 機能要件（望ましい挙動）

| # | 要件 | 優先 |
|---|------|------|
| R1 | **2 つ目以降の BO**（BO2, BO3, …）ごとに、**直前の BO からメンバーをコピーする操作**ができる | 必須 |
| R2 | コピー対象は **メンバー一覧（`member_ids`）**。ルームメモ（`notes`）も含めるかは運用判断（現行 BO1→BO2 は **notes もコピー**） | 必須 |
| R3 | コピーは **対象 BO を完全上書き**（仕様 A: G11 で BO1→BO2 に採用済み） | 必須 |
| R4 | **割当不可メンバー**（代理出席・欠席相当・参加者未登録等）はコピーから **除外**し、除外があればユーザーに通知 | 必須 |
| R5 | 同一 member を **複数 BO に同時所属**してよい（cross-BO 重複可。G11） | 制約 |
| R6 | 同一 BO **内**の `member_ids` 重複は防ぐ | 制約 |
| R7 | （任意）「＋ 同室枠を追加」直後に **自動で直前 BO をコピー**する | 任意 |
| R8 | コピー後も **「BO割当を保存」** で API に永続化される | 必須 |

### 2.3 非機能・UX

- ボタンラベルは **「BO{n-1}→BO{n} コピー」** のように直前枠が分かること。
- コピーは **未保存の編集 state** に対する操作（保存は別ボタン）。
- 左ペイン・Autocomplete と同様、`bo_assignable` / 参加者一覧に基づくガードを踏襲する。

---

## 3. 現行実装の確認

### 3.1 UI — 同室枠の追加

`addBO()` は Round 内の rooms 配列末尾に `BO{nextNo}` を **空の `member_ids`** で追加する。

```593:607:www/resources/js/admin/pages/DragonFlyBoard.jsx
    const addBO = () => {
        setDirty(true);
        setRoundsEdit((prev) => {
            const first = prev[0];
            const rooms = first?.rooms ?? [];
            const nextNo = rooms.length + 1;
            const newRoom = { room_label: `BO${nextNo}`, notes: '', member_ids: [] };
            // ...
            return [{
                ...first,
                rooms: [...rooms, newRoom],
            }];
        });
    };
```

「＋ 同室枠を追加」ボタンは BO3 以降も追加可能（UI 上は N 枠まで表示される）。

### 3.2 UI — コピーボタン（BO2 のみ）

BO2 ヘッダーに **「BO1→BO2 コピー」** が **1 件だけ** 存在する。条件は `roomLabel === 'BO2'` かつ BO1 が存在すること。

```1144:1178:www/resources/js/admin/pages/DragonFlyBoard.jsx
                                                        {roomLabel === 'BO2' && (() => {
                                                            const bo1 = rooms.find((r) => r.room_label === 'BO1');
                                                            return bo1 ? (
                                                                <Button
                                                                    // ...
                                                                    onClick={() => {
                                                                        // BO1 の member_ids / notes を BO2 に完全上書き
                                                                        // filterBoAssignableMemberIds で除外
                                                                    }}
                                                                >
                                                                    BO1→BO2 コピー
                                                                </Button>
                                                            ) : null;
                                                        })()}
```

- **BO3, BO4 … にはコピーボタンなし。**
- 追加直後の自動コピー（R7）も **なし**。

### 3.3 UI — コピー時のガード

`filterBoAssignableMemberIds`（`boAssignmentGuards.js`）で割当可能 ID のみ残す。除外時 Snackbar:

> `BO2 には割当可能なメンバーのみコピーしました（{n}名を除外）。`

### 3.4 API — 永続化は BO1 / BO2 のみ

Connections は `PUT /api/meetings/{id}/breakouts` を使用。サーバ側 `MeetingBreakoutService` は **`ROOM_LABELS = ['BO1', 'BO2']` 固定**。

```17:17:www/app/Services/Religo/MeetingBreakoutService.php
    private const ROOM_LABELS = ['BO1', 'BO2'];
```

- GET / PUT とも **BO1・BO2 以外の `room_label` は無視または正規化されない**。
- 保存成功後、UI は API 応答で `roundsEdit` を再構築するため、**BO3 以降は画面から消える**（未保存編集のみ存在）。

別 API の `PUT /api/meetings/{id}/breakout-rounds`（`MeetingBreakoutRoundsService`）は可変 Round / Room を扱えるが、**DragonFlyBoard は未使用**。

---

## 4. Fit & Gap 一覧

| 観点 | 要件 | 現状 | Fit / Gap |
|------|------|------|-----------|
| BO2 への手動コピー | R1–R4, R6 | BO1→BO2 ボタン。完全上書き・`filterBoAssignableMemberIds`・Snackbar | **Fit** |
| BO3 以降への手動コピー | R1–R4 | ボタンなし | **Gap** |
| 直前 BO を汎用参照 | R1 | BO1 固定参照（BO2 のみ） | **Gap** |
| 追加時の自動コピー | R7（任意） | 常に空の `member_ids` で追加 | **Gap**（任意要件） |
| cross-BO 同一 member | R5 | G11 で UI/API とも許可 | **Fit** |
| BO3+ の永続化 | R8 | API が BO1/BO2 のみ保存。保存後 BO3+ は消失 | **Gap（重大）** |
| UI の「同室枠を追加」 | — | BO3+ を追加できる表示 | **Gap（整合性）**: 追加 UI と API 能力が不一致 |
| 割当ガード | R4, R6 | CONN-BO-UX-GUARDS-P1 済 | **Fit**（コピー経路も BO2 で適用済み） |
| ルームメモのコピー | R2 | BO1→BO2 で `notes` もコピー | **Fit**（BO2 のみ） |
| SSOT 記載 | — | [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md) §5.5 は **BO1→BO2 のみ** | **Gap**（BO3+ 未記載） |

---

## 5. 結論

### 5.1 設置できるか

**UI だけであれば可能。** 既存の BO1→BO2 実装を **「`roomIndex >= 1` の各 BO で `rooms[roomIndex - 1]` からコピー」** に一般化すれば、R1–R4・R6 は満たせる。`filterBoAssignableMemberIds` と Snackbar 文言のパラメータ化も流用できる。

### 5.2 ただし現状の重大な制約

**BO3 以降にコピーボタンだけ追加しても、保存後にデータは失われる。** 永続化層が BO1/BO2 固定のため、R8 を BO3+ で満たすには **バックエンド拡張**（`MeetingBreakoutService` の可変 room 対応、または DragonFlyBoard を `breakout-rounds` API へ移行）が **前提**。

運用上 DragonFly が **常に 2 枠（BO1/BO2）** で足りるなら:

- **短期:** BO1→BO2 コピーで **Fit**。
- **「同室枠を追加」** は BO3+ を作れるため **誤解を招く Gap** — 非表示にするか、BO3+ 追加時に「保存されません」警告が望ましい。

### 5.3 推奨実装方針（未着手・参考）

| 案 | 内容 | 向き |
|----|------|------|
| **A（最小 UI）** | BO1/BO2 のみ運用と明言し、BO3+ 追加 UI を隠す。BO1→BO2 コピーは現状維持 | 現 API のまま整合 |
| **B（UI 一般化 + 2 枠 API）** | コピーボタンは BO2 のみ（現状）で十分とし、追加 BO UI を削除 | 現状に近い |
| **C（完全対応）** | `MeetingBreakoutService` または `breakout-rounds` で N 枠永続化 + UI で BO2..N に「直前 BO コピー」+ 任意で `addBO` 時自動コピー | R1–R8 を満たす |

**推奨:** 業務上 N 枠が必要なら **案 C**。**Phase 219（2026-06-16）で案 C を実装済み**（BO1..BO20、`MeetingBreakoutService` + Connections コピー一般化）。

---

## 6. Phase 219 実装後の Fit / Gap（2026-06-16 08:51 JST）

| 観点 | 状態 |
|------|------|
| BO3+ 永続化 | **Fit** — `PUT/GET breakouts` が BO1..BOn（最大20） |
| BO2 以降コピーボタン | **Fit** — 直前 BO から完全上書き |
| 追加時自動コピー | **Gap**（任意要件 R7）— 未実装 |
| payload 外 BO 削除 | **Fit** — 2 枠で保存すると BO3 は DB から削除 |
| `breakout-rounds` API | **Gap** — 引き続き BO1/BO2 固定（別経路。Connections は未使用） |

---

## 7. 実装時チェックリスト（案 C 想定）

- [x] 永続化: `ROOM_LABELS` 固定解除または payload の `rooms[]` をそのまま保存（Phase 219）
- [x] GET 応答が UI の `rooms` 件数と一致（Phase 219）
- [x] 各 BO（index ≥ 1）に `BO{n-1}→BO{n} コピー` ボタン（Phase 219）
- [x] コピー処理を共通関数化（Phase 219: `copyBoFromPreviousRoom`）
- [x] Snackbar: `BO{n} には割当可能なメンバーのみコピーしました（{dropped}名を除外）。`
- [ ] SSOT §5.5 を「直前 BO コピー」一般化で更新
- [x] Feature test: BO3 保存・再 GET・削除（Phase 219）
- [ ] [FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) Connections 行の更新

---

## 8. 変更履歴

| 日時 (JST) | 内容 |
|------------|------|
| 2026-06-16 08:49 JST | 初版。コード実装確認に基づく Fit/Gap 調査（実装変更なし）。 |
| 2026-06-16 08:51 JST | Phase 219 実装反映（§5.3 案 C 完了、§6 Fit/Gap 追記）。 |
