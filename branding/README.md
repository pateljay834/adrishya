# Adrishya branding

The visual identity: an "Adrishya" emblem built around the Devanagari letter
**अ** (the first letter of the name), inside a broken ring - the unclosed loop
standing for a system that leaves no trace.

| File | Use |
|------|-----|
| `logo.svg` / `logo.png` | App icon, 512x512 |
| `logo-256.png` | Smaller icon (menus, pixmaps) |
| `logo-lockup.svg` / `.png` | Horizontal logo with the wordmark |
| `wallpaper.svg` / `wallpaper.png` | Desktop wallpaper, 2560x1440 |
| `wallpaper-preview.jpg` | 1600x900 preview for the release page |

Colours: navy `#22406B`, deep `#0C1726`, amber `#E0A458`.

## Regenerating

Edit the SVGs (or `../scripts/` if you change the source script), then:

```sh
./scripts/install-branding.sh    # copy rendered PNGs into the build tree
```

The SVG files are the master; the PNGs are rendered from them.
