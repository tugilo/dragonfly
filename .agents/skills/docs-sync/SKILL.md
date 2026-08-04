---
name: docs-sync
description: Update dragonfly documentation after changes. Use when adding or editing docs, completing a phase, or recording progress. Updates docs/INDEX.md and docs/dragonfly_progress.md with JST timestamps.
---

# ドキュメント同期（INDEX・進捗）

## 必須更新対象

| 操作 | 更新ファイル |
|------|-------------|
| docs 追加・変更・削除 | `docs/INDEX.md` |
| Phase 完了・作業記録 | `docs/dragonfly_progress.md` |
| 新 Phase | `docs/process/PHASE_REGISTRY.md` |

## 日時（JST・時刻まで必須）

```bash
TZ=Asia/Tokyo date '+%Y-%m-%d %H:%M JST'
```

- 日付のみ（例: `2026-06-16`）で placeholder 的に書かない
- タイムゾーンは **JST** と明記

## INDEX 更新ルール

1. `docs/INDEX.md` の適切なセクションに行を追加
2. 移動・リネーム・削除時は INDEX を整合
3. 進捗ファイルが INDEX に載っていることを確認

## 進捗追記フォーマット

`docs/dragonfly_progress.md` の「進捗一覧」**先頭**に追加:

```markdown
| YYYY-MM-DD HH:MM JST | **Phase XXX または内容:** 概要（1〜2文）。関連ファイルへのリンク。 |
```

## Phase docs 追加時

`docs/process/phases/PHASE_XXX_*` を INDEX の process セクションにも追記。

## 打合せ・1to1 記録

- 日時はカレンダー・Zoom 等で **時刻まで** 確定
- 不明な場合は本文に **TODO** と明記
