#!/usr/bin/env python3
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FIELDS_PATH = ROOT / "AppStore" / "app-store-connect-fields.md"

# Limits are based on Apple App Store Connect Help as of 2026-07-03:
# - Platform version information: promotional text 170 chars, description 4000 chars,
#   keywords 100 bytes, app review notes 4000 bytes.
# - In-App Purchase information: reference name 64 chars, product ID 100 chars,
#   display name 2-30 chars, description 45 chars.
LIMITS = {
    "app_name_chars": 30,
    "subtitle_chars": 30,
    "promotional_text_chars": 170,
    "description_chars": 4000,
    "keywords_bytes": 100,
    "review_notes_bytes": 4000,
    "iap_reference_chars": 64,
    "iap_product_id_chars": 100,
    "iap_display_name_min_chars": 2,
    "iap_display_name_max_chars": 30,
    "iap_description_chars": 45,
}


def fail(message: str) -> None:
    print(f"NG: {message}", file=sys.stderr)
    raise SystemExit(1)


def ok(message: str) -> None:
    print(f"OK: {message}")


def read_fields() -> str:
    if not FIELDS_PATH.exists():
        fail(f"{FIELDS_PATH} is missing")
    return FIELDS_PATH.read_text(encoding="utf-8")


def strip_code(value: str) -> str:
    value = value.strip()
    if value.startswith("`") and value.endswith("`"):
        value = value[1:-1]
    return value.strip()


def table_value(markdown: str, label: str) -> str:
    pattern = re.compile(rf"^\|\s*{re.escape(label)}\s*\|\s*(.*?)\s*\|$", re.MULTILINE)
    match = pattern.search(markdown)
    if not match:
        fail(f"Table value for '{label}' is missing")
    return strip_code(match.group(1))


def section(markdown: str, heading: str) -> str:
    pattern = re.compile(
        rf"^###\s+{re.escape(heading)}\s*$([\s\S]*?)(?=^###\s+|\Z)",
        re.MULTILINE,
    )
    match = pattern.search(markdown)
    if not match:
        fail(f"Section '{heading}' is missing")
    return match.group(1)


def code_block_after(markdown: str, heading: str) -> str:
    content = section(markdown, heading)
    match = re.search(r"```text\n([\s\S]*?)\n```", content)
    if not match:
        fail(f"Text block for '{heading}' is missing")
    return match.group(1).strip()


def section_table_value(markdown: str, heading: str, label: str) -> str:
    return table_value(section(markdown, heading), label)


def check_chars(name: str, value: str, maximum: int, minimum: int = 0) -> None:
    length = len(value)
    if length < minimum or length > maximum:
        fail(f"{name} length is {length}, expected {minimum}-{maximum} chars")
    ok(f"{name} length {length}/{maximum} chars")


def check_bytes(name: str, value: str, maximum: int, minimum: int = 0) -> None:
    length = len(value.encode("utf-8"))
    if length < minimum or length > maximum:
        fail(f"{name} length is {length}, expected {minimum}-{maximum} bytes")
    ok(f"{name} length {length}/{maximum} bytes")


def check_product_id(name: str, value: str) -> None:
    check_chars(name, value, LIMITS["iap_product_id_chars"], 1)
    if not re.fullmatch(r"[A-Za-z0-9._-]+", value):
        fail(f"{name} contains characters outside letters, numbers, periods, underscores, and hyphens")
    ok(f"{name} format is valid")


def check_https_url(name: str, value: str) -> None:
    if not value.startswith("https://") or " " in value:
        fail(f"{name} must be a full https URL")
    ok(f"{name} is a full https URL")


def main() -> int:
    markdown = read_fields()

    app_name = table_value(markdown, "名前")
    subtitle = code_block_after(markdown, "サブタイトル")
    promo = code_block_after(markdown, "プロモーション文")
    description = code_block_after(markdown, "説明文")
    keywords = code_block_after(markdown, "キーワード")
    review_notes = code_block_after(markdown, "Notes")

    check_chars("App name", app_name, LIMITS["app_name_chars"], 2)
    check_chars("Subtitle", subtitle, LIMITS["subtitle_chars"])
    check_chars("Promotional text", promo, LIMITS["promotional_text_chars"])
    check_chars("Description", description, LIMITS["description_chars"], 1)
    check_bytes("Keywords", keywords, LIMITS["keywords_bytes"], 1)
    check_bytes("App Review Notes", review_notes, LIMITS["review_notes_bytes"])

    keyword_items = [item.strip() for item in keywords.split(",")]
    if any(not item for item in keyword_items):
        fail("Keywords contain an empty item")
    if len(keyword_items) != len(set(keyword_items)):
        fail("Keywords contain duplicates")
    ok(f"Keywords contain {len(keyword_items)} non-empty unique items")

    for url_label in ["サポートURL", "プライバシーポリシーURL", "利用規約URL"]:
        check_https_url(url_label, table_value(markdown, url_label))

    for heading in ["非消耗型", "自動更新サブスクリプション"]:
        product_id = section_table_value(markdown, heading, "Product ID")
        reference_name = section_table_value(markdown, heading, "参照名")
        display_name = section_table_value(markdown, heading, "表示名")
        iap_description = section_table_value(markdown, heading, "説明")

        check_product_id(f"{heading} Product ID", product_id)
        check_chars(f"{heading} reference name", reference_name, LIMITS["iap_reference_chars"], 1)
        check_chars(
            f"{heading} display name",
            display_name,
            LIMITS["iap_display_name_max_chars"],
            LIMITS["iap_display_name_min_chars"],
        )
        check_chars(f"{heading} description", iap_description, LIMITS["iap_description_chars"], 1)

    print("App Store metadata checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
