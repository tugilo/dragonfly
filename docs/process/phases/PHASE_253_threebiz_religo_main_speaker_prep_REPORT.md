# Phase 253 REPORT: スリーバイス 2026-06-30 Religo共有 メインスピーカー準備

## Summary

2026-06-30 JST 08:00-08:45 に予定されているスリーバイス チームMTG向けに、次廣がメインスピーカーとしてReligoの開発経緯・思想・リファーラル創出の仕組みを共有するための準備ドキュメントを作成した。

成果物では、Religo開発の出発点、Religoの読み方（レリゴ）と発音記号風のつかみ、`ligo` はラテン語で「繋ぐ」という語源、ビジター招待の貢献と週2リファーラル目標、記憶力を記録力で補う思想、Zoom要約コピペからAI下書き＋人の確認で議事録化する運用、A/B/C/Dを使ったリファーラル経路例と二段階リファーラル連鎖、他者121の秘匿とつながり可視化、Givers Gainとの整合、開発ドキュメント照合メモ、Gensparkスライド生成プロンプトと修正プロンプトを整理した。

2026-06-26 追記として、生成済みPDFプレゼン資料の14枚構成に合わせ、20分準備稿をスライド1〜14の話者原稿へ再構成した。内容の主旨は維持し、PDFを見ながら同じ順番で話せるようにした。

## Deliverables

- `docs/meetings/team/team_threebiz_20260630.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_253_threebiz_religo_main_speaker_prep_PLAN.md`
- `docs/process/phases/PHASE_253_threebiz_religo_main_speaker_prep_WORKLOG.md`
- `docs/process/phases/PHASE_253_threebiz_religo_main_speaker_prep_REPORT.md`

## Decisions

- 6/30回は、前回予定の「次廣のパーソナル軸共有」を踏まえつつ、ユーザー意向に合わせて「Religo共有」を主軸にした準備稿として作成した。
- 121記録の共有は、本文を他者に見せるものではなく、「誰が誰と繋がっているか」という信頼関係の経路を活用するものとして説明した。
- A/B/C/D例では、直接知らないDへ行くのではなく、Dと繋がっているCに橋渡しをお願いすることで、Cのリファーラル実績にもなる構造を明示した。
- Gensparkプロンプトは、文字少なめ・図解中心・14枚構成を推奨し、Religo / DragonFly の命名区別、冒頭に軽いユーモアを入れる方針、ビジター招待の貢献と週2リファーラル目標の位置づけ、スライド本体は図・絵・アイコン中心で詳細は発表者ノートへ逃がす方針を明記した。
- 生成済みGensparkスライドの修正用プロンプトも追加し、文字量削減、図解化、発表者ノートへの詳細移動、SSOTに沿う表現修正を指示できるようにした。
- 開発ドキュメント照合では、原稿の方向性は概ね整合と判断した。一方で、AI・プライバシー・週2リファーラルの表現は強すぎるとSSOTとズレるため、`AI下書き＋人の確認`、`同意・設定された範囲`、`考えやすくする補助線`へ調整した。
- 追加の並行レビュー結果を踏まえ、現状機能と将来像を分けるため、Zoom要約の扱いは `Markdown/取り込み運用＋人の確認を基本`、A/B/C/D例は `自分の記録から思い出す例`、横断活用は `同意された範囲` として補正した。
- UIの現行表現に合わせ、発表・スライドでは旧来のコンセプト表現を使わず、`関係性の見える化`、`紹介のきっかけを思い出す仕組み` に置換した。
- ビジター招待はBNI活動における大きな貢献として尊重し、価値を下げるような対立的表現を避け、`ビジター招待を大切にしながら日常の紹介機会も増やす` という表現に調整した。
- A/B/C/D例では、CさんがDさんを自分へ紹介することでCさんから自分へのリファーラルになり、その後自分がDさんをAさんへ繋げることで自分からAさんへのリファーラルにもなる、という二段階の連鎖を追加した。
- Religoの語源説明は `Re + ligo` とし、`ligo` はラテン語で「繋ぐ」として発表本文・スライドプロンプトに反映した。
- 生成済みPDFの流れに合わせ、20分準備稿は `スライド1`〜`スライド14` の見出しで、表紙、今日話したいこと、読み方、Religoとは、開発経緯、記録運用、ビジター招待、5人例、パターン①、パターン②、プライバシー、Givers Gain、今後の展開の順に再構成した。

## DoD Check

| Item | Result |
|------|--------|
| 6/30チームMTG向け準備稿・20分構成を整理 | OK |
| Religoの読み方・発音記号風のつかみ・ユーモアを反映 | OK |
| ligo のラテン語由来を反映 | OK |
| PDFプレゼン資料14枚に合わせて20分準備稿をスライド順に再構成 | OK |
| ビジター招待の貢献と週2リファーラル目標を反映 | OK |
| 開発ドキュメント照合メモを追加 | OK |
| 現状機能と将来像を分ける表現へ調整 | OK |
| Religo思想・プライバシー配慮・Givers Gain整合を反映 | OK |
| A/B/C/Dの具体例を整理 | OK |
| 二段階リファーラル連鎖を追加 | OK |
| Gensparkスライド生成プロンプトを作成 | OK |
| Gensparkスライド修正プロンプトを作成 | OK |
| スライドを図解・絵中心にする制約を追加 | OK |
| UI現行表現に合わせた文言へ置換 | OK |
| ビジター招待の価値を下げない表現へ調整 | OK |
| INDEX / progress / phase registry を同期 | OK |
| テスト結果 | docsフェーズのためスキップ |

## Merge Evidence

| Item | Value |
|------|-------|
| merge commit id | 未実施（commit / merge 未依頼） |
| source branch | develop（commit / merge 未実施） |
| target branch | develop |
| phase id | 253 |
| phase type | docs |
| related ssot | SPEC-018, SPEC-015, SPEC-016, SPEC-009, `PROJECT_NAMING.md` |
| test command | スキップ（docsフェーズ） |
| test result | スキップ（docsフェーズ） |
| changed files | `docs/meetings/team/team_threebiz_20260630.md`, `docs/INDEX.md`, `docs/dragonfly_progress.md`, `docs/process/PHASE_REGISTRY.md`, `docs/process/phases/PHASE_253_threebiz_religo_main_speaker_prep_PLAN.md`, `docs/process/phases/PHASE_253_threebiz_religo_main_speaker_prep_WORKLOG.md`, `docs/process/phases/PHASE_253_threebiz_religo_main_speaker_prep_REPORT.md` |
| scope check | OK |
| ssot check | OK |
| dod check | OK |

## Notes

- Religo DBへの取り込みは今回スコープ外。
- 2026-06-30実施後は、Zoom文字起こし要約を同ファイルへ反映し、準備稿から実施済み議事録へ更新する。
