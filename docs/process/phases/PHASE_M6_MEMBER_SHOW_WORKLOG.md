# Phase M-6 Member Show / Drawer 履歴強化 — WORKLOG

**Phase:** M-6  
**作成日:** 2026-03-06

---

## Step0: 既存 Drawer / Show / Connections のデータ源棚卸し

- **Members Drawer:** member は一覧行から渡される（summary_lite 付き）。メモ: `GET /api/contact-memos?owner_member_id=1&target_member_id={id}&limit=20`。1to1: `GET /api/one-to-ones?owner_member_id=1&target_member_id={id}&limit=20`。
- **MemberShow:** React Admin Show。dataProvider.getOne('members', { id }) → `GET /api/dragonfly/members/{id}`。**summary_lite は返っていない**。表示は display_no, name, category, current_role と「メモ履歴・1to1履歴 Coming soon」のみ。
- **Connections 右ペイン:** `GET /api/dragonfly/contacts/{target_member_id}/summary?owner_member_id=` でサマリ取得。`GET /api/one-to-ones?owner_member_id=&target_member_id=` で 1to1 一覧。latest_memos は summary に含まれる。

---

## Step1: 再利用する API

| API | 用途 | Drawer | Show |
|-----|------|--------|------|
| 一覧行の member（summary_lite） | Overview の同室・1to1・最終接触・フラグ | ○ そのまま利用 | — |
| GET /api/dragonfly/contacts/{id}/summary?owner_member_id= | Overview 用サマリ（Show で利用） | 不要（summary_lite あり） | ○ |
| GET /api/contact-memos?owner_member_id=&target_member_id=&limit= | メモ履歴 | ○ 既存 | ○ |
| GET /api/one-to-ones?owner_member_id=&target_member_id=&limit= | 1to1 履歴 | ○ 既存 | ○ |

- Show では getOne('members') に加え、上記 3 本を owner_member_id=1 で呼ぶ。二重取得は避ける（summary と contact-memos は別用途なので両方呼ぶ）。

---

## Step2: Drawer の情報構成

- **Overview:** 既存のまま強化。display_no, name, category, role はヘッダーにあり。要点カードに 同室・1to1・最終接触・興味・1to1希望。**直近メモ**を 1 件だけ summary_lite.last_memo または memos[0] で表示。メモ追加・1to1予定ボタンは維持。
- **Memos:** 既存のリストを維持（日付・種別・本文）。「Coming soon」はなし。
- **1to1:** 既存のリストを維持（status・日時・notes）。「Coming soon」はなし。

---

## Step3: Show ページの情報構成

- **Overview:** 基本データは getOne の member。サマリは GET /api/dragonfly/contacts/{id}/summary で取得し、同室・1to1・最終接触・フラグ・直近メモを表示。メモ追加・1to1予定は Members 一覧への導線または同じモーダルを開くにはコンテキストが必要なため、Show では「Members 一覧で操作」の案内に留めるか、同じ API で追加可能にする（要検討）。今回は「Overview / Memos / 1to1 を表示」を優先し、追加導線は「Members 一覧の詳細から」とし、Show には表示のみ＋リンクでよい。
- **Memos / 1to1:** contact-memos と one-to-ones を fetch して一覧表示。Drawer と同じ項目（日付・種別・本文 / status・日時・notes）。
- **Coming soon を削除**し、上記で置き換える。

---

## Step4: 共通化できる表示要素の整理

- Overview の「要点」ブロック（同室・1to1・最終接触・フラグ）は Drawer も Show も同じラベル・同じ順で表示。
- メモ 1 件の表示形式（日付・種別・本文）、1to1 1 件の表示形式（status・日時・notes）を Drawer と Show で揃える。
- コンポーネント共通化は任意。まずは Show に同じ構造を実装し、表示項目を揃える。

---

## Step5: モックとの差分整理

- モックの Drawer: Overview / Memos / 1to1 タブ、メモ追加・1to1予定・Connectionsで開く。
- 実装: タブ構成は同一。履歴を実データで表示し、「Coming soon」を解消すればモックに近づく。Show ページはモックに明示されていないが、URL 直アクセス用に同等内容を表示する。
