# Phase M4E Members Card 関係ログ表示 — WORKLOG

**Phase:** M4E  
**参照:** [PHASE_M4E_MEMBERS_CARD_LOGS_PLAN.md](PHASE_M4E_MEMBERS_CARD_LOGS_PLAN.md)、[FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4.1

---

## Task1: MemberCard で関係ログ用データ取得

- **状態:** 完了
- **判断:** owner_member_id は PLAN どおり MembersList.jsx 既存の定数 OWNER_MEMBER_ID を流用。新しい state や認証取得は追加しない。Card ごとに GET contact-memos を呼ぶ形で既存 API のみ使用。limit は 3 件とするため CARD_LOGS_LIMIT = 3 を定数で追加。
- **実施:** ファイル先頭に CARD_LOGS_LIMIT = 3 を追加。MemberCard 内で useState([], false) で recentLogs / loadingLogs を追加。useEffect で record.id を依存に、GET `/api/contact-memos?owner_member_id=${OWNER_MEMBER_ID}&target_member_id=${record.id}&limit=${CARD_LOGS_LIMIT}` を fetch し、res.ok なら res.json() を setRecentLogs、配列でなければ [] にフォールバック。finally で setLoadingLogs(false)。
- **確認:** Card 表示時に各カードで contact-memos が取得され、recentLogs に最大 3 件入る。OWNER_MEMBER_ID は既存の 1 のまま使用。

---

## Task2: mc-logs に .log-i 相当の表示

- **状態:** 完了
- **判断:** モックの .log-i は種別ラベル・日付・テキスト。contact-memos の memo_type を 1to1/例会/その他 にマッピング。日付は created_at を M/D 形式で表示。本文は body_short または body を 40 字で切り抜粋。
- **実施:** mc-logs 内を loadingLogs ? 「読込中…」 : recentLogs.length === 0 ? 「—」 : recentLogs.map で各 log に対し、typeLabel（one_to_one→1to1, meeting→例会, その他）、dateStr（created_at の M/D）、bodyDisplay（40字抜粋）を算出。Box.log-i で Chip（種別）＋日付＋本文を横並びで表示。
- **確認:** Card 表示でメモがあるメンバーは関係ログ（最近）に最大 3 件が種別・日付・抜粋で表示される。

---

## Task3: 読込中・0 件時の表示

- **状態:** 完了
- **判断:** PLAN のフォールバックどおり。取得中は「読込中…」、0 件は「—」を表示。詳細 Drawer への誘導は 0 件時も「—」のみとし、文言は最小限にした。
- **実施:** Task2 の分岐で loadingLogs のとき「読込中…」、recentLogs.length === 0 のとき「—」を表示。既に実装済み。
- **確認:** 初回表示時は一瞬「読込中…」、API が空配列を返すと「—」になる。
