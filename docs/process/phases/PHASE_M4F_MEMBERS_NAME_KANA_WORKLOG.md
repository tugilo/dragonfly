# Phase M4F Members 一覧かな表示 — WORKLOG

**Phase:** M4F  
**参照:** [PHASE_M4F_MEMBERS_NAME_KANA_PLAN.md](PHASE_M4F_MEMBERS_NAME_KANA_PLAN.md)、[FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4.1, §4.2 M9

---

## Task1: SSOT と現行 MembersList.jsx の name_kana 表示差分確認

- **状態:** 完了
- **判断:** FIT_AND_GAP §4.1 では .mc-hdr に .mc-name と .mc-kana を表示。§4.2 M9 では「一覧：かな — モック .mc-kana、実装 列なし」が Gap。現行は List が TextField source="name" のみで name_kana なし。Card は mc-kana で (record.name_kana || '').trim() || '—' を表示済み。
- **実施:** SSOT と MembersList.jsx の該当箇所を照合。List は名前列のみ、Card は mc-kana あり。
- **確認:** List でかな表示が不足していることを確認。Card は表示ありで、空値時「—」は既存実装で対応済み。

---

## Task2: List 表示でのかな表示の実装

- **状態:** 完了
- **判断:** PLAN どおり「名前列内サブ表示」を採用。列を増やさず横幅を維持し、モックの名前＋かなの上下関係に合わせる。名前列を FunctionField にし、1 行目に name、2 行目に name_kana（空でなければ）を caption で表示。ソートは名前で効かせるため sortBy="name" を指定。
- **実施:** Datagrid の「名前」列を TextField から FunctionField に変更。render 内で Box を返し、Typography body2 で name、name_kana が存在し空でなければ Typography caption で 2 行目に表示。FunctionField に sortable と sortBy="name" を付与。
- **確認:** List 表示で名前の下にかなが出る。name_kana が null/空のときは 2 行目を出さず名前のみ。ソートは名前で動作。

---

## Task3: Card 表示のかな表示の確認・必要なら微調整

- **状態:** 完了
- **判断:** mc-kana は既に実装済み。SSOT の .mc-name / .mc-kana の関係に合わせ、名前とかなの間に少し余白を入れたい。空値は「—」に統一し、null/空文字の判定を明示的にする（trim のみだと null で不自然にならないが、String 化して trim と空文字を同一扱い）。
- **実施:** mc-kana の Typography に sx={{ display: 'block', mt: 0.25 }} を追加。表示内容を (record.name_kana != null && String(record.name_kana).trim() !== '') ? String(record.name_kana).trim() : '—' に変更。
- **確認:** Card で名前の直下にかなが表示され、空のときは「—」。余白で読みやすさを維持。

---

## Task4: 空値時のフォールバック確認

- **状態:** 完了
- **判断:** List では name_kana が null/空のときは補助行を描画しない（名前のみ）。Card では「—」を表示。不自然な空白やラベルのみにならないようにする。
- **実施:** List の FunctionField では (r?.name_kana != null && String(r.name_kana).trim() !== '') のときだけ 2 行目を描画。Card は上記の三項で「—」に統一。
- **確認:** name_kana 未設定のメンバーは List で名前のみ、Card で「—」。問題なし。
