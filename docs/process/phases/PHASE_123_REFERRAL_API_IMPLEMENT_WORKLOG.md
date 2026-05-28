# Phase 123 WORKLOG

## 判断

- **Owner 解決:** `DashboardController` と同型にし、再利用のため `ResolvesReligoOwner` トレイトを新設。
- **introductions 物理列:** 既存が `note` / `introduced_at` のためモデル・API もそれに合わせ、SSOT §4.13 の主要カラム表を実スキーマに整合。
- **内部:** オーナーは買い手または売り手と一致必須、buyer/seller の `workspace_id` が両方非 null なら一致必須。
- **マージ:** `internal_referrals` の owner/buyer/seller 三列を canonical に付け替え（introductions と同じパターン）。

## 実装メモ

- ルート: `introductions` を `one-to-ones` の直後に配置（相対パスの可読性）。
- `referral_kind` は API で常に `external` に固定（store/update）。
