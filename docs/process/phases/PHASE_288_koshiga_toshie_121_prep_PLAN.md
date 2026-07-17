# Phase 288 PLAN — 越賀淑恵 初回121事前準備

**作成:** 2026-07-17 16:16 JST  
**Phase Type:** implement  
**Branch:** `feature/phase283-makita-sanako-121-minutes`（既存の未コミット作業があるため現作業ツリー上で記録。Phase 288 専用ブランチへの分離は commit / merge 時に要整理）  
**Related SSOT:** SPEC-013, SPEC-019, `docs/meetings/1to1/README.md` §重複防止, `.cursor/rules/1to1-dedup.mdc`

---

## Purpose

DragonFly メンバー・越賀淑恵さん（ケイティ＆アソシエイツ／ブランド戦略プランナー）との **2026-07-17 18:00 JST 開始予定**の初回121に向け、ユーザー提供の NCAS プロフィールをもとに、ブランド・マーケティング戦略と次廣のAI業務改善システム構築の役割分担、相互紹介条件を深掘りする読み上げ原稿を作成する。

Zoom取込済み `one_to_ones.id=95` を正として事前原稿を反映し、同一面談の新規行は作らない。

---

## Scope

- `docs/meetings/1to1/1to1_koshiga_toshie_kt_associates.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- Phase 288 PLAN / WORKLOG / REPORT
- ローカルDB: `members.id=30` の NCAS URL・公開プロフィール情報、`one_to_ones.id=95` の notes 更新のみ

アプリコード・DBスキーマ・本番DBは変更しない。

---

## DoD

- NCASから基本プロフィール、略歴、ONE to ONEシート、顧客像、コンタクトサークル、推薦・感謝の傾向を整理する。
- **2026-07-17 18:00 JST 開始予定**を記録し、終了時刻・実施方法は TODO とする。
- ブランド戦略と業務改善システム構築の境界・補完関係を明確にした60分アジェンダ、読み上げ台本、深掘り質問、紹介文を作成する。
- Zoom取込済み `one_to_ones.id=95`（planned / `zoom_meeting_id=88169264613`）を正とし、新規行を作らず notes を更新する。
- `members.id=30` にユーザー提供の NCAS URLを反映する。
- INDEX / progress / registry / WORKLOG / REPORT を同期する。
- Laravelテストを実行し、結果をREPORTへ記録する。React変更はないためビルドは不要。

---

## Tasks

1. SSOT・Phase番号・既存 Zoom 予定行を確認する。
2. NCAS一次情報と既存チャプター記録を、確認済み事実と仮説に分けて整理する。
3. 新規1to1シリーズ文書へプロフィール・60分原稿・紹介仮説を記載する。
4. `members.id=30` と既存 `one_to_ones.id=95` へ必要最小限を反映する。
5. INDEX / progress / registry / WORKLOG / REPORT を同期し、テストする。
