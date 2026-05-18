# Phase 122 WORKLOG: SPEC-009 + DATA_MODEL

## 判断

- **1→3→4 の順:** 先に要件 SSOT で運用に必要な既定を閉じ、次に DevOS の Phase 記録、最後にデータモデル SSOT に落とす。実装はスキーマ確定後の別 Phase とし、今回は docs のみとした。
- **内部の買い手:** P1 では **非メンバー購買を構造化しない**（会計・守秘の複雑さを避ける）。`buyer_member_id` と `seller_member_id` は **どちらも `members`**。記録者 `owner_member_id` は **買い手または売り手のいずれかと同一**とし、二重登録は許容しない厳格さより **本人側の記録**を優先。
- **金額:** 列は **任意・整数円・税込入力（ユーザー申告）** と定義。**閲覧は当面 owner の行のみ**（全員オープンの TYFCB ボードは別要件）。
- **既存 introductions:** 意味は従来どおり外部紹介の矢印。列 `referral_kind` は **default `external`** で既存行を一括解釈。内部は **`internal_referrals` にのみ**持たせ、`introductions` に `internal` を載せない（正規化）。
- **last_contact / Introduction Hint:** 内部リファーラルは **関係接触と別概念**のため、`last_contact_at`・Introduction Hint の入力に **含めない**。

## 実施内容（要領）

- `REFERRAL_RECORDING_REQUIREMENTS.md` に §9 製品既定を追記し、旧 TODO を整理。
- `DATA_MODEL.md` に `internal_referrals` と `referral_kind` を追記。§8 に「SSOT 先行・実装は別 Phase」を明記。
