# Phase M7-P8: participants / members 専用パーサ強化 — WORKLOG

**Phase:** M7-P8  
**作成日:** 2026-03-17

---

## 専用パーサを分けた理由

- 拡張性と責務の分離のため B 案（ParticipantPdfMembersPageParser / ParticipantPdfParticipantsPageParser）を採用。members は見出し除外・人名行の選別、participants はセクション追跡と type_hint 付与でロジックが異なるため、別クラスにした。

## members 見出し除外ルール

- HEADER_KEYWORDS: No., 名前, よみがな, カテゴリー, 役職, 備考, メンバー表 のいずれかを含む行は候補にしない。
- カテゴリ見出し: 行に「・」を含み、かつ短い（12 文字以下）かつ記号が少ないパターンの行（例: 建設・不動産、IT・通信）は除外。当初は短い行を広く除外していたが「山田 太郎」が落ちるため、「・」を含む行に限定した。
- 先頭の "01 " のような番号は除去して name にしている。

## participants 区分追跡のルール

- セクション見出し: ビジター様 → visitor、代理出席者様 → proxy、ゲスト様 → guest。該当行は候補にせず、以降の行に currentSection / type_hint を付与。
- 「ミーティング参加者」はページ内見出しとして PAGE_HEADER_KEYWORDS で除外し、候補にしない。
- セクション未設定の先頭行は type_hint=regular, source_section=null。

## candidates 構造をどこまで拡張したか

- 各候補に page_type（members | participants）と source_section（visitor | proxy | guest | null）を追加。既存の name / raw_line / type_hint は維持。ApplyParticipantCandidatesService と CandidateMemberMatchService は name / type_hint のみ参照するため後方互換。updateCandidates ではリクエストの candidates で上書きするため page_type / source_section は送らなければ失われるが、編集・apply には不要として許容。

## 実装内容

- **ParticipantPdfMembersPageParser:** 行分割 → ヘッダ/カテゴリ除外 → 先頭番号除去して name 化 → type_hint=regular, page_type=members, source_section=null で候補追加。
- **ParticipantPdfParticipantsPageParser:** 行分割 → セクション見出しで currentSection 更新（見出し行はスキップ）→ ページ見出し「ミーティング参加者」はスキップ → それ以外の行を name 化して type_hint/source_section 付与、page_type=participants。
- **PdfParticipantParseService:** members ページは membersPageParser->parse()、participants は participantsPageParser->parse() を呼び出し。それ以外の type（将来用）は従来の buildCandidates を使い、ensureCandidateKeys で page_type/source_section を付与。
- **Unit:** ParticipantPdfMembersPageParserTest（見出し除外・カテゴリ除外・人名行が regular・page_type members・番号除去）、ParticipantPdfParticipantsPageParserTest（visitor/proxy/guest セクション・見出し行は候補にしない・複数セクション切替）。
- **Feature:** test_parse_success のモック戻り値に page_type / source_section を含め、保存後に meta.pages と candidate の page_type / source_section を断言。

## テスト内容

- Unit: members で見出し・カテゴリが候補に入らないこと、人名行が regular・page_type=members であること。participants でビジター様/代理/ゲスト各セクションの type_hint と source_section が正しいこと、セクション見出し行が候補に含まれないこと。
- Feature: parse 成功時に meta.pages が維持され、candidates に page_type / source_section が保存されること。

## 結果

- php artisan test 155 passed。npm run build 成功。既存 parse/apply/updateCandidates はすべて通過。
