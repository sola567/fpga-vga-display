# fpga-vga-display
Simple VGA display system using Xilinx Artix-7 which displays colors on 640×480 monitor @ 60Hz

# VGA Pattern Generator

Simple VGA display controller for FPGA that generates test patterns at 640×480 @ 60Hz.

## Features
- ✅ VGA 640×480 @ 60Hz timing
- ✅ 4 selectable test patterns
- ✅ 12-bit color depth (4096 colors)
- ✅ No external memory required
- ❌ Image display (planned future work)

## Test Patterns
- Pattern 0: Color bars (RGB primary colors)
- Pattern 1: Checkerboard (black and white)
- Pattern 2: RGB gradient
- Pattern 3: White circle on black background

## Hardware
- Board: Basys 3 / Nexys A7
- FPGA: Xilinx Artix-7
- Output: VGA (15-pin connector)

## Current Status
✅ Working test pattern generation
🔄 Future: Image display from Block RAM
🔄 Future: Basic image filters
```

---

