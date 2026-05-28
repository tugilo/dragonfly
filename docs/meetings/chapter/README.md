# DragonFly チャプター定例会 議事録（docs/meetings/chapter/）

## 役割

BNI **DragonFly チャプター**の週次定例会（Zoom 等）の議事録を、回ごとに Markdown で残す。

- **1to1** → [`../1to1/`](../1to1/)
- **チーム MTG**（スリーバイス等）→ [`../team/`](../team/)
- **定例会** → **本ディレクトリ**

## ファイル命名

```
chapter_weekly_YYYYMMDD.md
```

例: `chapter_weekly_20260519.md`（開催日・JST）

## YAML front matter（推奨）

| キー | 例 | 備考 |
|------|-----|------|
| `doc_type` | `chapter_weekly` | 固定 |
| `chapter` | `bni_dragonfly` | |
| `meeting_number` | `208` | 分かれば記載。不明は省略可 |
| `session_date` | `2026-05-19` | 開催日 |
| `session_time_jst` | `08:00-10:00` | 要確認時は `session_time_note` と併記 |
| `format` | `zoom` | |
| `source` | Zoom 文字起こし要約 | 取得元 |

## 添付・関連データ

参加者 CSV・PDF は [`docs/pdf/`](../pdf/) 配下の日付フォルダに置き、議事録本文からリンクする。

## Religo / DB 連携（将来）

`meetings.number`（第 N 回）と `held_on` に対応させる想定。議事録に `meeting_number` を書いておくと取り込み時に照合しやすい。
