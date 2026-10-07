"""Render the app's brand mark to assets/icon/app_icon.png.

Mirrors lib/core/widget/common/app_logo.dart -- if you change the geometry or
the brand colors there, re-run this script:

    python tool/generate_launcher_icon.py
    dart run flutter_launcher_icons

Requires Pillow (pip install pillow). Only needed when the logo changes, so
it's deliberately not part of the build.
"""

import math
from pathlib import Path

from PIL import Image, ImageDraw

SIZE = 1024
SS = 4  # supersample factor; PIL's draw is aliased, so render big and shrink
S = SIZE * SS / 100  # geometry is authored in a 100x100 box, as in the Dart painter
BRAND_START = (0x25, 0x63, 0xEB)
BRAND_END = (0x7C, 0x3A, 0xED)
GLYPH = (255, 255, 255, 255)

# Padding around the mark for the adaptive-icon foreground, which gets cropped
# by the launcher's mask.
FOREGROUND_INSET = 0.22


def diagonal_gradient(size, start, end):
    """Top-left to bottom-right linear gradient."""
    base = Image.new("RGB", (size, size), start)
    top = Image.new("RGB", (size, size), end)
    mask = Image.new("L", (size, size))
    px = mask.load()
    for y in range(size):
        for x in range(size):
            px[x, y] = int(255 * (x + y) / (2 * (size - 1)))
    base.paste(top, (0, 0), mask)
    return base


def monogram_path(scale, offset):
    """Points along the stroke centreline: stem, shoulder, bowl, bottom bar.

    Same path as the Dart painter. Sampled rather than drawn with PIL's line
    and arc primitives, whose stroke joins don't meet cleanly.
    """
    ox, oy = offset

    def p(x, y):
        return (ox + x * scale, oy + y * scale)

    def segment(a, b):
        steps = max(2, int(math.dist(a, b)))
        return [
            (a[0] + (b[0] - a[0]) * i / steps, a[1] + (b[1] - a[1]) * i / steps)
            for i in range(steps + 1)
        ]

    pts = segment(p(34, 80), p(34, 24))  # stem, bottom to top
    pts += segment(p(34, 24), p(58, 24))  # shoulder

    # Bowl: right half of a circle centred at (58, 41), r=17, going clockwise
    # from the top of the shoulder back down to the bottom bar.
    cx, cy = p(58, 41)
    r = 17 * scale
    steps = max(8, int(math.pi * r))
    pts += [
        (cx + r * math.sin(math.pi * i / steps), cy - r * math.cos(math.pi * i / steps))
        for i in range(steps + 1)
    ]

    pts += segment(p(58, 58), p(34, 58))  # bottom bar of the bowl
    return pts


def draw_monogram(draw, scale=S, offset=(0, 0)):
    """Stamp a round-capped, round-joined stroke along the path."""
    radius = 13 * scale / 2
    for x, y in monogram_path(scale, offset):
        draw.ellipse([x - radius, y - radius, x + radius, y + radius], fill=GLYPH)


def _downsample(img):
    return img.resize((SIZE, SIZE), Image.LANCZOS)


def rounded_badge():
    big = SIZE * SS
    icon = diagonal_gradient(big, BRAND_START, BRAND_END).convert("RGBA")
    mask = Image.new("L", (big, big), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, big - 1, big - 1], radius=int(24 * S), fill=255)
    icon.putalpha(mask)
    draw_monogram(ImageDraw.Draw(icon))
    return _downsample(icon)


def adaptive_foreground():
    """Transparent square holding only the inset monogram."""
    big = SIZE * SS
    img = Image.new("RGBA", (big, big), (0, 0, 0, 0))
    inset = big * FOREGROUND_INSET
    scale = (big - 2 * inset) / 100
    draw_monogram(ImageDraw.Draw(img), scale=scale, offset=(inset, inset))
    return _downsample(img)


def main():
    out = Path(__file__).resolve().parent.parent / "assets" / "icon"
    out.mkdir(parents=True, exist_ok=True)
    rounded_badge().save(out / "app_icon.png")
    adaptive_foreground().save(out / "app_icon_foreground.png")
    print(f"wrote {out / 'app_icon.png'} and {out / 'app_icon_foreground.png'}")


if __name__ == "__main__":
    main()
