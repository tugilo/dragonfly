---
name: ssot-lookup
description: Find and read SSOT specs before implementation in dragonfly/Religo. Use when starting features, unsure about requirements, or before changing API/UI/data model. Reads SSOT_REGISTRY and related docs/SSOT files.
---

# SSOT 参照（実装前必須）

## 起点

1. `docs/02_specifications/SSOT_REGISTRY.md` を開く
2. 関連 **Spec ID** とファイルパスを特定
3. 該当 SSOT を **全文または関連セクション** 読む
4. PLAN の **Related SSOT** に Spec ID を記載

## よく参照する SSOT

| Spec ID | ファイル | 用途 |
|---------|----------|------|
| SPEC-002 | `docs/SSOT/CONTACT_LOGIC_ALIGNMENT.md` | last_contact・1to1 completed |
| SPEC-003 | `docs/SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md` | Owner 選択 |
| SPEC-006 | `docs/SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md` | チャプター外 1to1 |
| SPEC-012 | `docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md` | Zoom 連携 |
| SPEC-013 | `docs/SSOT/ONETOONE_PREP_PROFILE_REQUIREMENTS.md` | 1to1 事前準備・AI |
| SPEC-014 | `docs/SSOT/CHAPTER_MINUTES_REQUIREMENTS.md` | 定例会議事録 DB 化 |
| SPEC-015/016 | `docs/SSOT/ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md` 等 | リファーラル提案 |

## 命名

- **Religo** = プロダクト / **DragonFly** = チャプター / **dragonfly** = リポジトリ
- `docs/PROJECT_NAMING.md`

## 停止条件

- Registry に該当 Spec がない → 人間に確認。新 Spec 作成時は Registry に登録
- SSOT と実装方針が矛盾 → SSOT 修正または人間確認後に再開

## 出力

WORKLOG に記録:
- 参照した Spec ID
- SSOT から採用した制約・判断
