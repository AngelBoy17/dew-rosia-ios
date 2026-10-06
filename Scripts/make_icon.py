#!/usr/bin/env python3
from PIL import Image, ImageDraw, ImageFilter
import math

SIZE = 1024
img = Image.new("RGB", (SIZE, SIZE), (8, 24, 38))
draw = ImageDraw.Draw(img, "RGBA")

# background radial wash
for r in range(520, 0, -4):
    t = 1 - r / 520
    col = (
        int(8 + 30 * t),
        int(24 + 70 * t),
        int(38 + 90 * t),
        18,
    )
    draw.ellipse(
        [512 - r, 512 - r, 512 + r, 512 + r],
        fill=col,
    )

# soft blobs
blob = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
b = ImageDraw.Draw(blob)
b.ellipse([80, 120, 520, 560], fill=(90, 210, 220, 90))
b.ellipse([540, 80, 980, 500], fill=(160, 150, 255, 70))
b.ellipse([220, 560, 780, 1020], fill=(255, 170, 150, 50))
blob = blob.filter(ImageFilter.GaussianBlur(70))
img = Image.alpha_composite(img.convert("RGBA"), blob)

# dew drop
drop = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
d = ImageDraw.Draw(drop)
# teardrop approximated by overlapping ellipses
d.ellipse([312, 250, 712, 790], fill=(210, 245, 255, 70))
d.ellipse([340, 300, 684, 760], fill=(180, 240, 245, 110))
d.ellipse([380, 360, 644, 720], fill=(140, 230, 235, 150))
# highlight
d.ellipse([400, 330, 520, 470], fill=(255, 255, 255, 170))
d.ellipse([430, 360, 500, 430], fill=(255, 255, 255, 210))
drop = drop.filter(ImageFilter.GaussianBlur(2))
img = Image.alpha_composite(img, drop)

# glass rim
rim = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
r = ImageDraw.Draw(rim)
r.ellipse([300, 240, 724, 800], outline=(255, 255, 255, 90), width=6)
rim = rim.filter(ImageFilter.GaussianBlur(1.5))
img = Image.alpha_composite(img, rim)

out = img.convert("RGB")
out.save("/agent/Dew/Dew/Assets.xcassets/AppIcon.appiconset/AppIcon.png", "PNG")
print("icon written")
