# M7-P9-INVESTIGATION: 解析結果クリア機能の調査 — REPORT

**Phase:** M7-P9-INVESTIGATION  
**種別:** docs（調査のみ・実装なし）  
**作成日:** 2026-03-17

---

## 1. 結論

| 項目 | 結果 |
|------|------|
| **クリア機能** | **明示的 API はない**。暗黙的に「PDF 再アップロードでクリア」「再解析で上書き」「updateCandidates で空配列送信時は candidates のみクリア可能（UI からは不可）」がある。 |
| **実装場所** | クリア専用の API/Service メソッドは存在しない。store（再アップロード）・parse（上書き）・updateCandidates（candidates 差し替え）の既存処理で結果が変わる。 |
| **UI** | **「解析結果をクリアする」ボタンはない**。「PDF解析」は parse_status が success でないときのみ表示。成功後は再解析するには PDF を再アップロードする必要がある。 |

---

## 2. 現在の挙動まとめ

### parse 時

- **POST .../participants/import/parse** は `extracted_text` / `extracted_result`（candidates + meta）/ `parse_status` / `parsed_at` を**常に上書き**する。
- 成功時: 新規の candidates と meta で DB を更新（実質「クリア＋再解析」と同じ）。
- 失敗時: `extracted_text` と `extracted_result` を **null に更新**（解析結果のクリアが行われる）。

**根拠:** `MeetingParticipantImportController.php` 166–170 行（失敗時 null 設定）、185–189 行（成功時上書き）。

### updateCandidates 時

- **PUT .../participants/import/candidates** で `candidates` を送信した内容で差し替える。**meta は既存を維持**。
- **空配列 `candidates: []` を送ると** `extracted_result` は `{ candidates: [], meta: <既存 meta> }` になる → **candidates のみクリア**。`extracted_text` / `parse_status` / `parsed_at` は変更されない。
- バリデーション上 `candidates` は `required|array` のため `[]` は有効。

**根拠:** `MeetingParticipantImportController.php` 254–262 行（既存 meta 取得・candidates のみ更新）。

### apply 時

- **POST .../participants/import/apply** は `extracted_result['candidates']` を participants に反映するだけ。
- **candidates / extracted_result / parse_status は一切変更しない**。`imported_at` と `applied_count` のみ更新。
- apply 後も candidates と meta はそのまま残る。

**根拠:** `MeetingParticipantImportController.php` 289–299 行、`ApplyParticipantCandidatesService.php` で import の `extracted_result` は参照のみで更新しない。

---

## 3. 問題点

- **明示的に「解析結果だけ」をクリアする手段がない**
  - 解析結果を捨てて「解析待ち」に戻したい場合、現状は **PDF を再アップロード**するしかない（store で extracted_* と parse_status がリセットされる）。
  - 「同じ PDF のまま解析だけやり直したい」場合、**parse_status が success のときは UI に「PDF解析」ボタンが出ない**ため、再解析するには一度別 PDF を上げるか、API を直接叩く必要がある。

- **データの不整合リスク**
  - updateCandidates で candidates を空にすると、`extracted_result = { candidates: [], meta: <前回の meta> }` の状態になる。parse_status は success のままなので「解析成功・候補 0 件」という状態は発生しうる。apply は 0 件で 422 になるため、運用上は気づきやすい。

- **candidates / meta の残存**
  - apply 後も candidates と meta は残る。履歴として残す意図ならよいが、「反映済みなので解析結果は不要」という運用にしたい場合、明示的クリアがないと残り続ける。

---

## 4. コード根拠

### 4.1 ルート定義（クリア専用 API なし）

| ファイル | 内容 |
|----------|------|
| `www/routes/api.php` 93–98 行 | GET show, POST store, POST parse, PUT candidates, POST apply, GET download のみ。DELETE や POST clear はなし。 |

### 4.2 store（再アップロード時のクリア）

| ファイル | 箇所 | 説明 |
|----------|------|------|
| `MeetingParticipantImportController.php` | 91–103 行 | `updateOrCreate` で `extracted_text => null`, `extracted_result => null`, `parse_status => PENDING`, `parsed_at => null` を設定。PDF 再アップロードで解析結果がクリアされる。 |

### 4.3 parse（上書き・失敗時のクリア）

| ファイル | 箇所 | 説明 |
|----------|------|------|
| `MeetingParticipantImportController.php` | 166–170 行 | catch 内で `extracted_text => null`, `extracted_result => null`, `parse_status => failed`, `parsed_at => $now` を更新。解析失敗時に結果をクリア。 |
| 同 | 185–189 行 | 成功時に `extracted_text` / `extracted_result` / `parse_status` / `parsed_at` を新結果で上書き。 |

### 4.4 updateCandidates（candidates のみ更新・空配列で candidates クリア可能）

| ファイル | 箇所 | 説明 |
|----------|------|------|
| `MeetingParticipantImportController.php` | 219 行 | `$raw = $request->input('candidates', [])`。空配列で呼ぶと `$candidates` は空。 |
| 同 | 254–262 行 | 既存 `extracted_result['meta']` を維持し、`extracted_result => ['candidates' => $candidates, 'meta' => $meta]` で更新。candidates のみクリア可能。 |
| `UpdateParticipantImportCandidatesRequest.php` | 25 行 | `'candidates' => ['required', 'array']`。`[]` は有効。 |

### 4.5 apply（解析結果は変更しない）

| ファイル | 箇所 | 説明 |
|----------|------|------|
| `MeetingParticipantImportController.php` | 289–299 行 | `extracted_result['candidates']` を読み取り apply するだけ。import の extracted_result / parse_status は更新しない。 |
| `ApplyParticipantCandidatesService.php` | 77–80 行 | `$import->update(['imported_at' => now(), 'applied_count' => $count])` のみ。 |

### 4.6 UI（クリアボタンなし・成功時は再解析ボタンなし）

| ファイル | 箇所 | 説明 |
|----------|------|------|
| `MeetingsList.jsx` | 408, 507–524 行 | `needsParse = parse_status !== 'success'` のときのみ「PDF解析」ボタンを表示。**parse_status が success のときはボタン非表示**で、同じ PDF で再解析する導線がない。 |
| 同 | 113–127, 665 行 | `putParticipantImportCandidates` は `candidates.filter((c) => c.name !== '')` を送信。全行名前空なら `body` は `[]` になるが、 |
| 同 | 718 行 | 保存ボタンは `editingCandidates.every((c) => !String(c.name || '').trim())` のとき **disabled**。**全削除して保存は UI から実行できない**。 |

### 4.7 データ構造（個別クリアの有無）

| ファイル | 説明 |
|----------|------|
| `MeetingParticipantImport.php` | `extracted_text`, `extracted_result` は fillable。DB 上は 1 レコードで、`extracted_result` が JSON。candidates と meta を**個別にクリアする専用カラムや API はない**。updateCandidates で candidates だけ空にすることは可能（meta は維持）。 |

---

## 5. 結論としての整理

- **現状は「再解析＝上書き」だが、UI からは「解析成功後は同じ PDF で再解析できない」。**
  - 再解析したい場合は **PDF を再アップロード**して parse_status を pending に戻し、そのうえで「PDF解析」を押す必要がある。
- **「解析結果だけをクリアする」明示 API はない。**
  - 代替: (1) PDF 再アップロード（store）→ 解析結果・parse_status がクリア、(2) updateCandidates に `candidates: []` を送る → candidates のみクリア（meta は残る、UI からは全削除保存ができない）。
- **明示的クリアが必要かどうか**
  - 「解析をやり直したい」「反映後に解析結果を捨てたい」という運用があれば、**明示的クリア（API + 必要なら UI）があるとよい**。現状は再アップロードで代替可能だが、同じ PDF で「解析だけやり直す」は UI からはできない。

---

## 6. 次アクション（提案）

| 提案 | 内容 | 優先度 |
|------|------|--------|
| **A. 解析結果クリア API の追加** | 例: POST `/api/meetings/{id}/participants/import/clear-result`。extracted_text / extracted_result を null にし、parse_status を pending（または failed）にし、parsed_at を null にする。PDF ファイルは残す。 | **中**（「同じ PDF で解析やり直し」を UI からやりたい場合） |
| **B. 成功時も「再解析」を出せるようにする** | parse_status が success のときも「PDF解析」ボタン（または「再解析」）を表示し、押したら parse を再実行して上書き。実質「クリア＋再解析」になる。 | **中**（実装量は少ない） |
| **C. 「解析結果をクリア」UI ボタン** | A を実装したうえで、Drawer に「解析結果をクリア」を追加。押下で clear-result を呼び、解析待ち状態に戻す。 | **低**（A の後） |
| **D. updateCandidates で全削除保存を許可** | 編集モードで全行削除したときも「保存」を有効にし、PUT candidates に `[]` を送れるようにする。candidates のみクリア、meta は残る。 | **低**（0 件で apply は 422 のままなので、運用で整理可能） |

---

## 変更ファイル（本調査）

- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P9_INVESTIGATION_REPORT.md（本ファイルのみ。実装なし）

---

## 追記（M7-P10 対応）

- **M7-P10** にて、本調査の提案 B「成功時も再解析を出せるようにする」を実装。parse_status === success のときも「再解析」ボタンを表示し、既存 parse API の再実行で上書きする導線を追加した。詳細は PHASE_MEETINGS_PARTICIPANTS_PDF_P10_REPORT.md を参照。
