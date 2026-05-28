# Phase M4L Members から Connections への導線強化 — PLAN

**Phase:** M4L  
**作成日:** 2026-03-10  
**SSOT:** [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4.1, §4.2

---

## Phase

M4L — Members で「この人を見よう」と判断したあと、Connections へ迷わず遷移できるようにする。Members ＝ 理解、Connections ＝ 行動の流れを強化する。

---

## Purpose

- Members から Connections へ遷移する導線を明確にする。
- 「この人を Connections で見る／行動する」という意図で遷移できるようにする。
- 遷移時に対象 member を引き継げるようにする（Connections でそのメンバーが選択された状態で開く）。

---

## Background

- FIT_AND_GAP §4.1 のヘッダーには「🗺 Connectionsへ」がある。現行はページヘッダーに 1 本のみで、**一覧の各行・各カードから「この人で Connections へ」と飛ぶ導線はない**。
- Connections（DragonFlyBoard）は左ペインでメンバーをクリックすると右ペインにそのメンバーが表示される。**URL の query parameter で member_id を渡す仕組みは現状ない**。React Router の useSearchParams で読み取り、members 取得後に setTargetMember すれば引き継ぎ可能。

---

## Related SSOT

- docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md §4.1（.pg-hdr-r の Connectionsへ）、§4.2（行/カードアクション）

---

## Scope

- **変更可能:** www/resources/js/admin/pages/MembersList.jsx を主とする。**Connections 側で member_id を URL から受け取る**ために、DragonFlyBoard.jsx に必要最小限の読み取り処理を追加する（useSearchParams + 初回のみ setTargetMember）。
- **変更しない:** API、dataProvider、バックエンド、他ページの導線。既存の詳細・メモ・1to1・フラグ導線は壊さない。

---

## Target Files

- www/resources/js/admin/pages/MembersList.jsx（Card / List に「Connections で見る」導線追加）
- www/resources/js/admin/pages/DragonFlyBoard.jsx（URL の member_id を読み、対象メンバーを初期選択）

---

## Implementation Strategy

1. **遷移方式**
   - **URL query parameter** を採用する。Members からは `Link to={/connections?member_id=${record.id}}` で遷移する。Connections（DragonFlyBoard）側で `useSearchParams()` から `member_id` を取得し、members 取得後に該当メンバーを setTargetMember する。React Admin は react-router を使うため、DragonFlyBoard 内で useSearchParams が利用可能。

2. **MembersList.jsx**
   - **Card（mc-act）:** 「詳細 →」の手前または直後に「🗺 Connections で見る」ボタンを追加。Link で `/connections?member_id=${record.id}` に遷移。ラベルは「Connections で見る」または「🗺 Connections で見る」とし、何が起きるか分かるようにする。
   - **List（MemberRowActions）:** 既存のメモ・1to1・1to1メモ・フラグ・詳細に加え、「🗺 Connections」ボタンを追加。Link で `/connections?member_id=${record.id}`。既存 Actions との整合を崩さない。
   - ページヘッダーの「🗺 Connectionsへ」はそのまま残す（一覧全体からの遷移用）。

3. **DragonFlyBoard.jsx**
   - `useSearchParams()` で `member_id` を取得。members がロードされたあと、初回のみ `member_id` に一致するメンバーを setTargetMember する。すでに targetMember がユーザー操作で設定されている場合は上書きしない、というより「マウント時かつ members 初回ロード後に 1 回だけ URL の member_id を適用」する。ref で「URL 適用済み」フラグを立て、1 回だけ適用する。

4. **既存導線**
   - メモ・1to1・1to1メモ・フラグ・詳細はそのまま。Connections 導線は「追加」のみで、既存ボタンの並びや動作は変えない。

---

## Tasks

- [ ] Task1: 現行 Members / Connections 導線の確認（ヘッダー 1 本のみ、URL 引き継ぎなし）
- [ ] Task2: 遷移時の member 引き継ぎ方式の決定（query parameter member_id + DragonFlyBoard で読み取り）
- [ ] Task3: Card 側導線の実装（mc-act に「Connections で見る」Link 追加）
- [ ] Task4: List 側導線の実装（MemberRowActions に「Connections」Link 追加）
- [ ] Task5: DragonFlyBoard で member_id 読み取りと初期選択
- [ ] Task6: 既存メモ・1to1・詳細導線との競合確認

---

## DoD

- Card 表示で各カードに「Connections で見る」など分かりやすい導線があり、クリックで `/connections?member_id=X` に遷移すること。
- List 表示で各行の Actions に「Connections」導線があり、同様に member_id 付きで遷移すること。
- Connections を member_id 付きで開いたとき、該当メンバーが右ペインに選択された状態で表示されること。
- ページヘッダーの「Connectionsへ」は従来どおり残ること。
- 既存のメモ・1to1・1to1メモ・フラグ・詳細の導線が壊れていないこと。
- API・dataProvider・バックエンドは変更しないこと。
- php artisan test および npm run build が通ること。

---

## 参照

- MembersList.jsx: MembersListActions（ヘッダー）、MemberCard（mc-act）、MemberRowActions
- DragonFlyBoard.jsx: targetMember, setTargetMember, members 取得 useEffect
