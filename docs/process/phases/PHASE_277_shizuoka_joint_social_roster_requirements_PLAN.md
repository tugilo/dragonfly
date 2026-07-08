# Phase 277 PLAN: 静岡合同懇親会 参加者名簿要件整理

## Phase 情報

| 項目 | 内容 |
|------|------|
| Phase ID | 277 |
| Phase 種別 | docs |
| ブランチ | `main`（既存未コミット変更あり。ブランチ切替は未実施） |
| 開始 | 2026-07-08 18:22 JST |
| Status | completed |

## 背景・目的

東京 NE リージョンの静岡メンバーと静岡のリアルチャプターとの合同懇親会に向け、Google フォーム回答から参加者名簿を作成する必要がある。

ユーザー要望は、A4 サイズで印刷できる名簿と、スマホからも見られる名簿の両方を作ること。まずは実装や生成作業に入る前に、入力データ・表示項目・並び順・公開範囲・未確認事項を要件ドキュメントとして整理する。

## Related SSOT

- **SPEC-021** [REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md](../../SSOT/REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md)

今回の成果物は Religo 機能実装ではないが、東京 NE リージョンとチャプター表記・グルーピングに関わるため SPEC-021 を参照する。

## Scope

### In

| 領域 | 対象 |
|------|------|
| 要件定義 | `docs/requirements/bni_shizuoka_joint_social_roster_requirements.md` |
| Phase docs | Phase 277 PLAN / WORKLOG / REPORT |
| Docs sync | `docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md` |

### Out

- Google Sheets 原本の編集
- A4 PDF の実生成
- スマホ HTML の実生成
- Religo DB 取り込み
- Web アプリ実装
- 参加者への共有・送信

## Tasks

1. Google Sheets 添付内容から入力列とデータ解釈を把握する。
2. A4 印刷用名簿の表示項目・並び順・レイアウト方針を整理する。
3. スマホ閲覧用名簿の方式候補と推奨案を整理する。
4. 個人情報・公開範囲・未確認事項を明記する。
5. `docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md` を同期する。

## DoD

- [x] 要件定義書に、入力元 Google Sheets と対象イベントが明記されている。
- [x] A4 印刷用の表示項目・並び順・レイアウト方針が明記されている。
- [x] スマホ閲覧用の方式候補と推奨案が明記されている。
- [x] `その他` チャプター行の扱いが明記されている。
- [x] メールアドレスを含む個人情報の公開範囲が明記されている。
- [x] 未確認事項が TODO として整理されている。
- [x] INDEX / progress / PHASE_REGISTRY が同期されている。

## 実施方針

今回は生成プログラムや PDF/HTML 作成には進まず、次作業で迷わない粒度の要件整理に限定する。

スマホ閲覧は「A4 PDF をスマホで見る」ではなく、同じ正規化データからレスポンシブ HTML を生成する方針を第一候補として記録する。

