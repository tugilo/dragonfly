# Phase M7-C3: 参加者CSVを participants / members に反映 — WORKLOG

**Phase ID:** M7-C3

---

## 全置換を採用した理由

- 初期実装として差分更新より安全で分かりやすい。M7-P3-IMPLEMENT-2 の candidates apply と同じ思想で揃えられる。

## 既存 CSV CLI ロジックとの関係

- 種別マッピング（TYPE_MAP）は CLI と同一: メンバー→regular, ビジター→visitor, ゲスト→guest, 代理出席→proxy。
- Member 解決は「名前で検索 or 新規作成」で CLI と同方針。CLI は display_no / category / role 等も更新するが、本 Phase では最小限（name, type, name_kana 程度）に留める。

## Member 解決の判断

- Member::where('name', $name)->first() で存在すれば使用。なければ Member::create([name, type, name_kana, category_id=>null, display_no=>null, ...])。members.type は CSV 種別に応じて member/visitor/guest を設定（proxy は guest で登録するCLIに合わせる）。

## 紹介者 / アテンド / オリエンをどこまで扱ったか

- 反映では必須にしない。participants の introducer_member_id / attendant_member_id は null のまま。後続 Phase で名前解決を入れる。

## 実装内容

- マイグレーション: meeting_csv_imports に imported_at (nullable timestamp), applied_count (nullable unsignedInteger) を追加。
- MeetingCsvImport: fillable / casts に上記を追加。
- ApplyMeetingCsvImportService: MeetingCsvPreviewService で rows 取得、0 件なら 422。TYPE_MAP で メンバー→regular, ビジター→visitor, ゲスト→guest, 代理出席→proxy。既存 participants 削除後、行ごとに member を名前で解決 or 新規作成（name, type, name_kana のみ）、Participant 作成（introducer/attendant は null）。import に imported_at / applied_count を保存。
- MeetingCsvImportController::apply: 最新 csv import を取得し applyService->apply() を呼び、applied_count と message を返す。
- MeetingController show: csv_import に imported_at, applied_count を追加。
- UI: postCsvImportApply、csvApplyConfirmOpen / csvApplyLoading、プレビュー row_count > 0 のとき「participants に反映」ボタン、確認ダイアログ、反映後に notify と onDetailRefresh。imported_at / applied_count の表示を追加。

## テスト内容・結果

- apply 成功: 2 行 CSV で apply → 200, applied_count=2, participants 2 件、import に imported_at/applied_count 保存。
- データ行 0 件で 422、CSV 未登録で 404。
- 既存 participants が全削除され CSV 行のみになること。
- 種別が regular/visitor/guest/proxy にマッピングされること。
- 既存 member は紐づき、新規名は member 作成のうえ participant 作成。
- php artisan test: 172 passed。npm run build: 成功。
