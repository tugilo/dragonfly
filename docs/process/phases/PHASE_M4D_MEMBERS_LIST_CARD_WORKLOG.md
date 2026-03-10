# Phase M4D Members List/Card 表示切替 — WORKLOG

**Phase:** M4D  
**作成日:** 2026-03-10  
**参照:** [PHASE_M4D_MEMBERS_LIST_CARD_PLAN.md](PHASE_M4D_MEMBERS_LIST_CARD_PLAN.md)、[FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4.1

---

## Task1: viewMode state と ViewModeContext

- **状態:** 完了
- **判断:** viewMode を List の子コンポーネント（FilterBar と一覧）で共有するため、React Context で渡す。List は react-admin が制御するため、state を持つラッパー MembersListInner を List の直下の子として配置し、その中で useState('list') と ViewModeContext.Provider を設定。
- **実施:** ViewModeContext を定義。MembersListInner 内で const [viewMode, setViewMode] = useState('list') を宣言し、Provider で value={{ viewMode, setViewMode }} を渡した。List の children を従来の <> ... </> から <MembersListInner /> に差し替え。
- **確認:** FilterBar と一覧の出し分けコンポーネントの両方で useContext(ViewModeContext) が利用可能。

---

## Task2: フィルタバー右に [List] [Card] 切替

- **状態:** 完了
- **判断:** FIT_AND_GAP の「フィルタバー右に表示切替」に従い、MembersFilterBar の右端（件数表示の右）に 2 ボタンを配置。ml: 'auto' で右寄せし、viewMode に応じて contained / outlined を切り替え。
- **実施:** MembersFilterBar で useContext(ViewModeContext) を取得。Box で [List] [Card] の Button を追加。viewMode === 'list' のとき List を contained、viewMode === 'card' のとき Card を contained にした。
- **確認:** クリックで viewMode が切り替わり、一覧表示が表⇔カードで切り替わる。

---

## Task3: list 時 Datagrid / card 時 MembersCardGrid

- **状態:** 完了
- **判断:** 既存 Datagrid は一切変更しない。MembersListInner 内で viewMode === 'list' ? <Datagrid>...</Datagrid> : <MembersCardGrid /> で分岐。Datagrid の子列は M4 時点のまま（番号・名前・カテゴリ・役職・同室・1to1回数・最終接触・直近メモ・フラグ・Actions）。
- **実施:** MembersListInner に上記三項演算子を実装。MembersCardGrid は useListContext() の data を利用する新規コンポーネントとして追加。
- **確認:** List 選択時は従来どおり表表示。Card 選択時はカードグリッド表示。

---

## Task4: MembersCardGrid と MemberCard（mcard 構造）

- **状態:** 完了
- **判断:** §4.1 の .cgrid（3 列、1300px 以下で 2 列）と .mcard の構造を MUI Box + sx で再現。API は変更しないため、関係ログ（最近）は一覧 API に含まれない想定で、mc-logs は「関係ログ（最近）」見出し＋「— 詳細で確認」の文言で代替。
- **実施:**
  - **MembersCardGrid:** useListContext().data を Array.isArray で安全に取得し、map(member => <MemberCard key={member.id} record={member} />)。grid は gridTemplateColumns: { xs: '1fr 1fr', md: 'repeat(3, 1fr)' }、gap: 2。
  - **MemberCard:** mc-hdr（番号 #01、役職 Chip、名前、かな）、mc-body（大/実カテゴリ Chip、同室回数・最終接触の 2 列、直近メモ 2 行 clamp、interested / want_1on1 フラグ）、mc-act（メモ・1to1・1to1メモ・詳細ボタン）、mc-logs（見出し＋「— 詳細で確認」）。30 日未接触時は最終接触を「⚠ N日未接触」表示。MembersModalContext で openMemo / openO2o / openO2oMemo / openFlagEdit / openDrawer を呼び出し。
- **確認:** カード表示で 1 人分の情報が 1 枚のカードにまとまり、モックの mcard 構成と対応している。既存 API は変更していない。

---

## DoD 確認

- List / Card 切替: フィルタバー右の [List] [Card] で切替可能。
- 既存 Datagrid: 列・挙動は変更なし。
- Card: mc-hdr / mc-body / mc-act / mc-logs の構造で実装済み。
