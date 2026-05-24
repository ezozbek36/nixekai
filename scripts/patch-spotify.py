import argparse
import re
import shutil
import sys
import tempfile
import zipfile
from pathlib import Path


JS_PATCHES = [
    ("adsEnabled",    "adsEnabled:!0",                          "adsEnabled:!1",          False),
    ("hptoEnabled",   "hptoEnabled:!0",                         "hptoEnabled:!1",         False),
    ("isHptoHidden",  "isHptoHidden:!0",                        "isHptoHidden:!1",        False),
    ("sponsorships",  '.set("allSponsorships",t.sponsorships)',  '.set("allSponsorships",[])', False),
    ("sentry",        "sentry.io",                              "localhost",              False),
    ("sentry_gate",   "/864e5<30",                              "<0",                     False),
    ("upgrade_button",
        r'"data-testid":"upgrade-button"(?!,style)',
        '"data-testid":"upgrade-button",style:{display:"none"}',
        True),
]

PATCHES_BY_FILE = {
    "xpui.js":          JS_PATCHES,
    "xpui-snapshot.js": JS_PATCHES,
    "vendor~xpui.js":   [p for p in JS_PATCHES if p[0] in ("sentry", "sentry_gate")],
    "home-hpto.css":    [("hpto_hide", "display:flex", "display:none", False)],
}


def apply_patches(content, patches):
    total = 0
    for name, find, replace, is_regex in patches:
        if is_regex:
            new, n = re.subn(find, replace, content)
        else:
            n = content.count(find)
            new = content.replace(find, replace)
        if n:
            content = new
            total += n
            print(f"  [patch] {name}: {n} match(es)")
    return content, total


def patch_spa(spa, theme, colors, extensions):
    with tempfile.TemporaryDirectory() as tmp:
        xpui_dir = Path(tmp) / "xpui"

        print(f"[+] Extracting {spa.name}")
        with zipfile.ZipFile(spa, "r") as zf:
            zf.extractall(xpui_dir)

        patched = 0
        for f in xpui_dir.rglob("*"):
            if not f.is_file():
                continue
            patches = PATCHES_BY_FILE.get(f.name)
            if not patches:
                continue
            print(f"[*] {f.name}")
            content = f.read_text(encoding="utf-8", errors="ignore")
            new_content, n = apply_patches(content, patches)
            if n:
                f.write_text(new_content, encoding="utf-8")
                patched += 1
        print(f"[+] Patched {patched} file(s)")

        (xpui_dir / "colors.css").write_text(
            colors.read_text() if colors else "/* no theme */\n"
        )
        (xpui_dir / "user.css").write_text(
            theme.read_text() if theme else "/* no theme */\n"
        )

        if extensions:
            ext_dir = xpui_dir / "extensions"
            ext_dir.mkdir(exist_ok=True)
            for ext in extensions:
                shutil.copy2(ext, ext_dir / ext.name)
                print(f"[+] Extension: {ext.name}")

        index = xpui_dir / "index.html"
        if index.exists():
            html = index.read_text(encoding="utf-8")
            if "colors.css" not in html:
                html = html.replace(
                    "<body",
                    "<link rel='stylesheet' href='colors.css'>\n"
                    "<link rel='stylesheet' href='user.css'>\n<body",
                    1,
                )
            if extensions:
                tags = "\n".join(
                    f'<script defer src="extensions/{e.name}"></script>'
                    for e in extensions
                )
                html = html.replace("</body>", f"{tags}\n</body>")
            index.write_text(html, encoding="utf-8")

        print(f"[+] Repacking → {spa}")
        with zipfile.ZipFile(spa, "w", zipfile.ZIP_DEFLATED) as zf:
            for f in sorted(xpui_dir.rglob("*")):
                if f.is_file():
                    zf.write(f, f.relative_to(xpui_dir))

    print("[+] Done")


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--spa",       required=True, type=Path)
    p.add_argument("--theme",     type=Path, default=None)
    p.add_argument("--colors",    type=Path, default=None)
    p.add_argument("--extension", type=Path, action="append", default=[], dest="extensions")
    args = p.parse_args()

    if not args.spa.exists():
        print(f"[ERROR] Not found: {args.spa}", file=sys.stderr)
        sys.exit(1)

    patch_spa(args.spa, args.theme, args.colors, args.extensions)


if __name__ == "__main__":
    main()
