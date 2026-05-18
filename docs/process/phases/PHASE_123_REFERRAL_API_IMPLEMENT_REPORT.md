# Phase 123 REPORT: リファーラル DB/API（SPEC-009 P1）

## 概要

`introductions` に `referral_kind`（default `external`）、`internal_referrals` テーブルを追加し、owner スコープの REST API と `MemberMergeService` 連携、Feature テストを追加した。

## Phase

- **Phase ID:** 123
- **Type:** implement
- **Related SSOT:** SPEC-009, DATA_MODEL §4.13–4.14

## Merge Evidence

- **merge commit id:** （未 merge）develop 取り込み後に記録すること。
- **source branch:** feature/phase123-referral-api-implement（推奨）
- **target branch:** develop
- **test command:** `php artisan test`
- **test result:** 369 passed（実施時点）
- **changed files:** `git diff --name-only develop...HEAD` で記録

## scope check

OK

## ssot check

OK（DATA_MODEL・REFERRAL §10 更新）

## dod check

OK
