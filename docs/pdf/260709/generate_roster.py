#!/usr/bin/env python3
"""Generate BNI Shizuoka joint social roster CSV + print/mobile HTML from form export."""

from __future__ import annotations

import csv
import html
import re
from collections import defaultdict
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo

DIR = Path(__file__).resolve().parent
SOURCE = DIR / "source_form_responses.md"
CSV_OUT = DIR / "bni_shizuoka_joint_social_roster_normalized.csv"
PRINT_OUT = DIR / "bni_shizuoka_joint_social_roster_print.html"
MOBILE_OUT = DIR / "bni_shizuoka_joint_social_roster_mobile.html"

EVENT_TITLE = "BNI 静岡合同懇親会 参加者名簿"
EVENT_DATE = "2026-07-09"
SOURCE_SHEET = "2026_07_09_BNI合同懇親会_参加者一覧"


def parse_markdown_table(path: Path) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line.startswith("|") or line.startswith("| ---"):
            continue
        cells = [c.strip() for c in line.strip("|").split("|")]
        if len(cells) < 9:
            continue
        row_num = cells[0]
        if not row_num.isdigit() or int(row_num) <= 1:
            continue
        timestamp = cells[1]
        name = re.sub(r"\\(.)", r"\1", cells[2]).strip()
        email = re.sub(r"\\(.)", r"\1", cells[3]).strip()
        chapter_raw = cells[4].strip()
        col_f = cells[5].strip()
        col_g = cells[6].strip()
        col_h = cells[7].strip()
        col_i = cells[8].strip() if len(cells) > 8 else ""

        if not name:
            continue

        if chapter_raw == "その他":
            chapter = col_f
            category = col_g
            comment = col_i or col_h
        else:
            chapter = chapter_raw
            category = col_f
            comment = col_h or col_i

        rows.append(
            {
                "timestamp": timestamp,
                "name": name,
                "email": email,
                "chapter_name": chapter,
                "category": category,
                "comment": comment,
            }
        )
    return rows


def dedupe(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    by_key: dict[tuple[str, str], dict[str, str]] = {}
    for row in rows:
        key = (row["name"], row["email"].lower())
        existing = by_key.get(key)
        if existing is None or row["timestamp"] >= existing["timestamp"]:
            by_key[key] = row
    return list(by_key.values())


def sort_grouped(rows: list[dict[str, str]]) -> list[tuple[str, list[dict[str, str]]]]:
    by_chapter: dict[str, list[dict[str, str]]] = defaultdict(list)
    for row in rows:
        by_chapter[row["chapter_name"]].append(row)

    for members in by_chapter.values():
        members.sort(key=lambda r: r["name"])

    chapters = sorted(
        by_chapter.items(),
        key=lambda item: (-len(item[1]), item[0]),
    )
    return chapters


def write_csv(chapters: list[tuple[str, list[dict[str, str]]]]) -> int:
    count = 0
    with CSV_OUT.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=["chapter_name", "category", "name", "email", "comment"],
        )
        writer.writeheader()
        for _, members in chapters:
            for row in members:
                writer.writerow(
                    {
                        "chapter_name": row["chapter_name"],
                        "category": row["category"],
                        "name": row["name"],
                        "email": row["email"],
                        "comment": row["comment"],
                    }
                )
                count += 1
    return count


def esc(value: str) -> str:
    return html.escape(value or "", quote=True)


def generated_at() -> str:
    return datetime.now(ZoneInfo("Asia/Tokyo")).strftime("%Y-%m-%d %H:%M JST")


def build_print_html(chapters: list[tuple[str, list[dict[str, str]]]], total: int) -> str:
    body_parts: list[str] = []
    for chapter, members in chapters:
        body_parts.append(
            f'<section class="chapter"><h2>{esc(chapter)}（{len(members)}名）</h2>'
            '<table><thead><tr>'
            "<th>チャプター</th><th>カテゴリ</th><th>名前</th><th>メール</th><th>一言</th>"
            "</tr></thead><tbody>"
        )
        for row in members:
            body_parts.append(
                "<tr>"
                f"<td>{esc(row['chapter_name'])}</td>"
                f"<td>{esc(row['category'])}</td>"
                f"<td>{esc(row['name'])}</td>"
                f"<td class=\"email\">{esc(row['email'])}</td>"
                f"<td class=\"comment\">{esc(row['comment'])}</td>"
                "</tr>"
            )
        body_parts.append("</tbody></table></section>")

    return f"""<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="utf-8">
  <meta name="robots" content="noindex, nofollow">
  <title>{esc(EVENT_TITLE)} — 印刷用</title>
  <style>
    @page {{ size: A4 landscape; margin: 12mm; }}
    * {{ box-sizing: border-box; }}
    body {{ font-family: "Hiragino Sans", "Yu Gothic", sans-serif; font-size: 9pt; color: #111; margin: 0; }}
    header {{ margin-bottom: 10px; border-bottom: 2px solid #333; padding-bottom: 6px; }}
    h1 {{ font-size: 16pt; margin: 0 0 4px; }}
    .meta {{ font-size: 8pt; color: #444; line-height: 1.5; }}
    .notice {{ margin-top: 6px; font-size: 8pt; color: #800; }}
    .chapter {{ margin-top: 14px; break-inside: avoid-page; }}
    h2 {{ font-size: 11pt; margin: 0 0 6px; background: #eef2ff; padding: 4px 6px; border-left: 4px solid #334155; }}
    table {{ width: 100%; border-collapse: collapse; table-layout: fixed; }}
    th, td {{ border: 1px solid #cbd5e1; padding: 4px 5px; vertical-align: top; word-wrap: break-word; }}
    th {{ background: #f8fafc; font-size: 8pt; }}
    td.email {{ font-size: 8pt; word-break: break-all; }}
    td.comment {{ font-size: 8pt; }}
    colgroup col:nth-child(1) {{ width: 11%; }}
    colgroup col:nth-child(2) {{ width: 18%; }}
    colgroup col:nth-child(3) {{ width: 10%; }}
    colgroup col:nth-child(4) {{ width: 18%; }}
    colgroup col:nth-child(5) {{ width: 43%; }}
  </style>
</head>
<body>
  <header>
    <h1>{esc(EVENT_TITLE)}</h1>
    <div class="meta">
      開催日: {esc(EVENT_DATE)} / 参加者: {total}名 / 生成: {esc(generated_at())}<br>
      入力元: {esc(SOURCE_SHEET)}
    </div>
    <div class="notice">個人情報を含みます。参加者・運営関係者以外への配布・転送は禁止です。</div>
  </header>
  {''.join(body_parts)}
</body>
</html>
"""


def build_mobile_html(chapters: list[tuple[str, list[dict[str, str]]]], total: int) -> str:
    body_parts: list[str] = []
    for chapter, members in chapters:
        cards: list[str] = []
        for row in members:
            email_link = (
                f'<a href="mailto:{esc(row["email"])}">{esc(row["email"])}</a>'
                if row["email"]
                else "（未入力）"
            )
            cards.append(
                f"""<article class="card">
  <h3>{esc(row['name'])}</h3>
  <dl>
    <dt>カテゴリ</dt><dd>{esc(row['category'])}</dd>
    <dt>メール</dt><dd>{email_link}</dd>
    <dt>一言</dt><dd>{esc(row['comment']) or '—'}</dd>
  </dl>
</article>"""
            )
        body_parts.append(
            f"""<details class="chapter" open>
  <summary>{esc(chapter)}（{len(members)}名）</summary>
  <div class="cards">{''.join(cards)}</div>
</details>"""
        )

    return f"""<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex, nofollow">
  <title>{esc(EVENT_TITLE)} — スマホ閲覧用</title>
  <style>
    * {{ box-sizing: border-box; }}
    body {{ font-family: "Hiragino Sans", "Yu Gothic", sans-serif; margin: 0; background: #f1f5f9; color: #0f172a; }}
    header {{ background: #1e293b; color: #fff; padding: 16px; }}
    h1 {{ font-size: 1.1rem; margin: 0 0 8px; }}
    .meta {{ font-size: 0.82rem; opacity: 0.9; line-height: 1.5; }}
    .notice {{ margin-top: 8px; font-size: 0.78rem; color: #fecaca; }}
    main {{ padding: 12px; max-width: 640px; margin: 0 auto; }}
    .chapter {{ background: #fff; border-radius: 10px; margin-bottom: 12px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,.08); }}
    summary {{ cursor: pointer; font-weight: 700; padding: 12px 14px; background: #e2e8f0; list-style: none; }}
    summary::-webkit-details-marker {{ display: none; }}
    .cards {{ padding: 8px 10px 12px; display: grid; gap: 10px; }}
    .card {{ border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px 12px; background: #fafafa; }}
    .card h3 {{ margin: 0 0 8px; font-size: 1rem; }}
    dl {{ margin: 0; display: grid; grid-template-columns: 4.5em 1fr; gap: 4px 8px; font-size: 0.88rem; }}
    dt {{ color: #64748b; }}
    dd {{ margin: 0; word-break: break-word; }}
    a {{ color: #2563eb; }}
  </style>
</head>
<body>
  <header>
    <h1>{esc(EVENT_TITLE)}</h1>
    <div class="meta">開催日: {esc(EVENT_DATE)} / 参加者: {total}名 / 生成: {esc(generated_at())}</div>
    <div class="notice">個人情報を含みます。限定共有 URL で閲覧してください。</div>
  </header>
  <main>
    {''.join(body_parts)}
  </main>
</body>
</html>
"""


def chapter_summary(chapters: list[tuple[str, list[dict[str, str]]]]) -> str:
    lines = [f"{name}: {len(members)}名" for name, members in chapters]
    return ", ".join(lines)


def main() -> None:
    raw = parse_markdown_table(SOURCE)
    rows = dedupe(raw)
    chapters = sort_grouped(rows)
    total = write_csv(chapters)
    PRINT_OUT.write_text(build_print_html(chapters, total), encoding="utf-8")
    MOBILE_OUT.write_text(build_mobile_html(chapters, total), encoding="utf-8")
    print(f"Parsed raw rows: {len(raw)}")
    print(f"After dedupe: {total}")
    print(f"Chapters: {len(chapters)}")
    print(chapter_summary(chapters))
    print(f"Wrote: {CSV_OUT.name}, {PRINT_OUT.name}, {MOBILE_OUT.name}")


if __name__ == "__main__":
    main()
