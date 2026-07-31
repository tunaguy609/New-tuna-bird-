# New-tuna-bird-

A collection of parametric OpenSCAD designs for offshore trolling lures.

## Files

| File | Description |
|------|-------------|
| `ballyhoo_trolling_head.scad` | Compact ballyhoo-style trolling head (37.5 mm nose + 22.2 mm rear, 19.05 mm max OD) |
| `trolling_head.scad` | Production offshore trolling head — Version 5 Tuna Lure (65 mm, 24 mm OD, ogive profile) |

## Requirements

- [OpenSCAD](https://openscad.org/) 2021.01 or later

---

### ballyhoo_trolling_head.scad

A parametric ballyhoo-style lure head with a power-curve nose profile, skirt pocket, eye recesses, and angled water ports.

**Key parameters**

| Parameter | Default | Description |
|-----------|---------|-------------|
| `nose_length` | 37.5 mm | Nose section length |
| `rear_length` | 22.2 mm | Rear body length |
| `max_diameter` | 19.05 mm | Maximum body diameter |
| `tip_diameter` | 4.8 mm | Nose tip diameter |
| `line_hole` | 2.0 mm | Center bore diameter |
| `eye_diameter` | 6.5 mm | Eye recess diameter |
| `water_port_diameter` | 3.5 mm | Water port diameter |
| `render_resolution` | 140 | Facet count (`$fn`) |

---

### trolling_head.scad

Production-quality offshore trolling head by **Haywire Tackle** (Version 4.0 design) with a smooth ogive body profile, skirt spigot, retaining collars, circumferential grooves, eye pads/pockets, leader bore, and skirt pocket.

**Key parameters**

| Parameter | Default | Description |
|-----------|---------|-------------|
| `headLength` | 65 mm | Overall head length |
| `bodyDiameter` | 24 mm | Maximum body OD |
| `noseDiameter` | 7 mm | Nose tip diameter |
| `spigotDiameter` | 19 mm | Rear spigot OD |
| `spigotLength` | 22 mm | Rear spigot length |
| `leaderHole` | 2.5 mm | Leader bore diameter |
| `skirtPocketDiameter` | 16 mm | Skirt pocket ID |
| `skirtPocketDepth` | 20 mm | Skirt pocket depth |
| `eyeDiameter` | 10 mm | Eye socket diameter |
| `eyeLocation` | 50 mm | Eye station from nose |

**Feature toggles:** `showGrooves`, `showEyes`, `showCollars`, `showLeaderHole`, `showSkirtPocket`

**Rendering:** set `preview = false` and re-render (`$fn` increases from 90 → 300) before exporting to STL.
