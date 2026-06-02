# フィット＆ギャップ：Markdown ビューア（議事録・1to1 メモ）

**調査日:** 2026-06-02 16:07 JST  
**種別:** 調査 SSOT（実装前の Fit/Gap 整理）  
**Related:** SPEC-014（定例会議事録）、SPEC-013（1to1 事前準備・notes）、Phase 180

---

## 1. 目的・スコープ

Religo 管理画面で **Markdown 文字列を「生テキスト」ではなく、React 上で読みやすくレンダリングする** 要件と現状の差分を整理する。

### 対象コンテンツ

| 種別 | データ源 | 典型フォーマット |
|------|----------|------------------|
| **チャプター定例会議事録** | `meeting_minutes.body_markdown`（file→DB） | 見出し・**GFM 表**・リスト・太字・リンク |
| **1to1 notes** | `one_to_ones.notes` | 見出し・リスト・太字・区切り線（Zoom 要約・手書きメモ） |
| **例会メモ** | `contact_memos.body`（`memo_type=meeting`） | プレーンテキスト〜軽い Markdown 混在 |
| **1to1 履歴メモ** | `contact_memos`（1to1 紐づけ） | 同上 |
| **Members 抜粋** | notes / memo body の先頭 N 文字 | 一覧用プレビュー（短い） |

### 非目標（本 Fit/Gap のスコープ外）

- 管理画面からの Markdown **編集** UI（WYSIWYG / 分割ペインエディタ）
- DB→Markdown **書き出し**
- モック HTML との pixel-perfect 一致（モックに Markdown ビューア専用画面は無い）

### 目標像（「わかりやすく表示」の定義）

1. **構造が視覚化される** — 見出し階層・段落・リストが Typography で区別される  
2. **表が表として読める** — 定例会議事録の GFM 表（`| ... |`）が崩れない  
3. **リンクがクリック可能** — 外部 PDF/CSV へのリンクが機能する  
4. **一貫したコンポーネント** — 議事録・1to1 で同じ `MarkdownView`（dense モード差のみ）  
5. **編集は textarea、閲覧はビューア** — 入力 UI と表示 UI を混同しない  

---

## 2. 現状実装（2026-06-02 時点）

### 2.1 共有コンポーネント

| ファイル | 内容 |
|----------|------|
| `www/resources/js/admin/components/MarkdownView.jsx` | `react-markdown` + MUI カスタム `components`（見出し・段落・リスト・リンク・引用・表・コード） |
| `dense` prop | 一覧プレビュー向けに fontSize / spacing を縮小 |

**依存:** `react-markdown` ^10.1.0（`package.json`）。**`remark-gfm` は未導入。**

### 2.2 画面別の表示方式

| 画面 | 対象フィールド | 表示方式 | コンポーネント |
|------|----------------|----------|----------------|
| Meetings Drawer **議事録タブ** | `minutes.body_markdown` | Markdown レンダリング | `MarkdownView` dense=false |
| Meetings Drawer **メモタブ** | `memo_body` | **生テキスト**（`pre-wrap`） | Typography |
| 1to1 一覧 **notes プレビュー** | `record.notes` | Markdown レンダリング（小） | `OneToOneMarkdownView` → `MarkdownView` dense |
| 1to1 **メモ Dialog** | `record.notes` | Markdown レンダリング | `OneToOneMarkdownView` dense=false |
| 1to1 **Edit** フォーム | `notes` 入力 | TextInput（編集） | react-admin 標準 |
| 1to1 Edit **履歴メモパネル** | `contact_memos.body` | **生テキスト**（`pre-wrap`） | Typography |
| Members List / Show **抜粋** | notes / memo body | **生テキスト**（先頭 120〜200 字） | Typography |
| Dashboard ウィークリープレゼン | 原稿テキスト | **生テキスト** | Typography（別 SSOT: SPEC-004） |

---

## 3. フィット＆ギャップ一覧

### 3.1 画面・UX

| ID | 観点 | 目標 | 現状 | Fit / Gap | 優先度 |
|----|------|------|------|-----------|--------|
| MV01 | 定例会議事録の閲覧 | Drawer 議事録タブで Markdown ビュー | `MarkdownView` + `remark-gfm`（Phase 181） | **Fit** | — |
| MV02 | 1to1 notes の閲覧（全文） | Dialog / 詳細で Markdown ビュー | Dialog で `MarkdownView` | **Fit** | — |
| MV03 | 1to1 notes の一覧プレビュー | セル内で構造が分かる概要 | `MarkdownView` dense | **Partial Fit** | Low |
| MV04 | 例会メモの閲覧 | メモタブでも Markdown 対応（任意） | `pre-wrap` プレーン | **Gap** | Medium |
| MV05 | 1to1 履歴メモの閲覧 | 履歴も Markdown レンダリング | `pre-wrap` プレーン | **Gap** | Low |
| MV06 | Members 抜粋 | 短いプレビュー（Markdown 不要でも可） | `pre-wrap` 抜粋 | **Acceptable** | Low |
| MV07 | 編集 vs 閲覧の分離 | 編集=textarea、閲覧=ビューア | Edit は textarea、閲覧系は上記 | **Fit** | — |
| MV08 | 表示の一貫性 | 議事録・1to1 で同一コンポーネント | 共有 `MarkdownView` あり | **Fit** | — |

### 3.2 レンダリング品質（技術）

| ID | 観点 | 目標 | 現状 | Fit / Gap | 優先度 |
|----|------|------|------|-----------|--------|
| MV-T01 | **GFM 表** | `\| col \|` 形式が HTML 表になる | `remark-gfm` 導入済み（Phase 181）。`table`/`th`/`td` スタイル適用 | **Fit** | — |
| MV-T02 | 見出し階層 | h1〜h3 でサイズ差が明確 | h1〜h6 で fontSize 段階化（Phase 181） | **Fit** | — |
| MV-T03 | 太字・斜体 | `**bold**` / `*em*` | react-markdown デフォルトで `<strong>`/`<em>`（カスタム未指定） | **Fit** | — |
| MV-T04 | 水平線 | `---` | `Divider` コンポーネント | **Fit** | — |
| MV-T05 | リンク | 相対パス・外部 URL | `target=_blank` の `<a>` | **Partial Fit**（相対リンクは docs/pdf 等、管理画面 origin では 404 になり得る） | Medium |
| MV-T06 | タスクリスト | `- [ ]` | 未対応（remark-gfm 依存） | **Gap** | Low |
| MV-T07 | コードブロック | インライン / フェンス | 基本対応済み | **Fit** | — |
| MV-T08 | 空文字・未取り込み | プレースホルダー文言 | 議事録未取り込み時に import 案内表示 | **Fit** | — |

### 3.3 コンテンツ実態（定例会議事録サンプル）

`chapter_weekly_20260602.md` 等で **頻出する Markdown 要素:**

| 要素 | 例 | 現状レンダリング |
|------|-----|------------------|
| 見出し `##` / `###` | 決定事項・メンバーシップ | サイズ段階付きで表示（Phase 181） |
| GFM 表 | 概要・決定事項・実績の表 | **HTML 表として表示（Phase 181）** |
| 太字 | `**リファーラル**` | 表示される |
| リスト | `-` / 番号付き | 表示される |
| リンク | `[CSV](../../pdf/...)` | クリック可能だが URL 解決は環境依存 |

---

## 4. まとめ

### Fit（揃っているところ）

- 共有 **`MarkdownView`** コンポーネントが存在し、議事録タブ・1to1 一覧/Dialog で利用開始済み（Phase 180）
- 見出し・段落・リスト・リンク・引用・コード・**GFM 表**（Phase 181: `remark-gfm`）
- 見出し h1〜h6 のサイズ段階（Phase 181）
- 編集画面は textarea のまま、閲覧はビューア — 役割分離は明確

### 主な Gap（優先度順）

1. **Medium — 例会メモタブがプレーン表示（MV04）**  
   Markdown 混在メモを同じビューアで見られると一貫性向上（P2）。

2. **Medium — 相対リンクの解決（MV-T05）**  
   議事録内 `../../pdf/` リンクは管理画面 URL では開けない。将来: 静的ファイル配信 or リンク無効化＋注記。

3. **Low — 1to1 履歴メモ・Members 抜粋（MV05, MV06）**  
   横展開は任意。抜粋はプレーンのままでも運用上許容。

---

## 5. 推奨実装 Phase（案）

| 順 | Phase 案 | 内容 | 状態 |
|----|----------|------|------|
| 1 | **MARKDOWN_VIEWER_P1** | `remark-gfm` 導入 + 見出し階層 | **完了（Phase 181）** |
| 2 | **MARKDOWN_VIEWER_P2** | Meetings メモタブ・1to1 履歴メモを `MarkdownView` 化 | 未着手 |
| 3 | **MARKDOWN_VIEWER_P3**（任意） | 議事録内リンク方針 | 未着手 |

### DoD（P1 完了の目安）

- [x] 第210回議事録相当で **概要表・決定事項表が HTML 表として表示**される
- [x] 1to1 Dialog の既存 Markdown 表示が退行しない（同一コンポーネント）
- [x] `npm run build` 成功
- [x] 本 Fit/Gap の MV-T01 / MV-T02 を **Fit** に更新

---

## 6. 関連 SSOT

| ドキュメント | 関係 |
|--------------|------|
| [CHAPTER_MINUTES_REQUIREMENTS.md](CHAPTER_MINUTES_REQUIREMENTS.md) | SPEC-014 — 議事録 UI は「MarkdownView」と記載 |
| [MEETING_DOMAIN_IA.md](MEETING_DOMAIN_IA.md) | Meetings Drawer タブ構成 |
| [FIT_AND_GAP_MEETINGS.md](FIT_AND_GAP_MEETINGS.md) | Meetings 画面全体（§4 Meeting ハブ IA） |
| [ONETOONES_EDIT_UI_FIT_AND_GAP.md](ONETOONES_EDIT_UI_FIT_AND_GAP.md) | 1to1 Edit UX（notes 編集は別論点） |

---

**更新履歴**

| 日付 | 内容 |
|------|------|
| 2026-06-02 16:11 JST | Phase 181 実装後: MV-T01/MV-T02 を Fit に更新 |
