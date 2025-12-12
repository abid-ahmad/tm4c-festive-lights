# TM4C Festive Lights (ARM Assembly)

Eight LEDs on **Port B** show three patterns—**Right→Left**, **Left→Right**, and a **pre-made random sequence**—selected with three switches on **Port E**. Frames are paced by a ~0.5 s delay. Pressing the same switch again **after release** stops playback and returns to the menu. Clean, table-driven frames + tidy GPIO for a simple teaching/demo build.

🎥 **Demo:** https://www.youtube.com/watch?v=eIHVYZA6gng

---

## Repo Contents

| File | Purpose |
|---|---|
| `ECE3620_FestiveLights_Report.pdf` | Full lab report (requirements, specifications, constraints, design, testing, deployment). |
| `ECE3620_FestiveLights_Flowchart-DataFlow-CallGraph.pdf` | All diagrams in one PDF: flowchart, data-flow diagram, and call graph. |
| `main_code (1).s` | Application logic: main loop, pattern selection, frame runner, delay, frame tables (DCB). |
| `PortB_driver (1).s` | GPIO **Port B** init + `PORTB_Output` (LEDs on PB0–PB7). |
| `PortE_driver.s` | GPIO **Port E** init + `PORTE_Input` (switches on PE0–PE2). |
| `Startup (1).s` | Minimal startup/vector table for TM4C123. |
| `README.md` | You are here. |

> **Total files:** 7 (including this README)

---

## How It Works

1. **Init**: PB0–PB7 as digital outputs (LEDs), PE0–PE2 as digital inputs (switches).
2. **Select**: Read switches, choose pattern (R→L, L→R, Random).
3. **Run**: Output one frame byte to Port B → delay (~0.5 s) → poll same switch.
4. **Stop**: If **same switch** is pressed again (after release), clear LEDs and return to main.

**Timing:** In `main_code (1).s`  
`halfSec EQU 2666666`  → ~0.5 s at 16 MHz. Adjust for your clock if needed.

---

## Build & Flash (TM4C123GH6PM)

1. Create a new TM4C123/Tiva-C project (Keil uVision or your toolchain).
2. **Add**: `Startup (1).s`, `PortB_driver (1).s`, `PortE_driver.s`, `main_code (1).s`.
3. Ensure the startup file defines the vector table and Reset handler.
4. **Wire**:  
   - LEDs → PB0…PB7 (with proper resistors).  
   - Switches → PE0…PE2 (use built-in pull-downs per driver or external as required).
5. Build → Flash → Run.

---

## SDLC Summary (for your report)

**Analyze / Requirements & Constraints**  
- *Requirements*: Show 3 LED patterns selectable via 3 switches; stop on same switch; human-visible pacing; run on TM4C123.  
- *Specifications*: PB0–PB7 outputs; PE0–PE2 inputs; ~0.5 s per frame; table-driven frames; clean separation of drivers and app.  
- *Constraints*: 16 MHz bus clock assumed; limited SRAM/flash; simple polling delay (no RTOS).

**Design**  
- Block split: *GPIO Drivers* (`PortB_driver`, `PortE_driver`) and *App* (`main_code`).  
- Data-driven frames via `DCB` tables; main flow is a switch-select state machine.  
- Diagrams: see **Flowchart**, **Data-Flow**, **Call Graph** in `ECE3620_FestiveLights_Flowchart-DataFlow-CallGraph.pdf`.

**Development**  
- Incremental bring-up: GPIO output → GPIO input → frame tables → menu/stop logic → polish comments.  
- Assembly for transparency with registers and timing.

**Testing**  
- Unit: verify `PORTB_Output` (walking-1s), `PORTE_Input` (single-step).  
- Integration: confirm each pattern; confirm “press-release-press” stop; check frame wrap.  
- Timing: adjust `halfSec` if your bus clock differs from 16 MHz.

**Deployment**  
- Flash to board, label switches (S0 R→L, S1 L→R, S2 Random).  
- Record demo (see YouTube link).  
- Package code + report + diagrams (this repo).

---

## Extend It

- Add patterns: append bytes to `DCB` tables + update length.
- Swap delay for **SysTick** periodic interrupts for precise timing.
- Map frames to other displays (7-segment, LED matrix) by replacing `PORTB_Output`.

---

## Quick Start Checklist

- [ ] Board is TM4C123GH6PM (Tiva C).  
- [ ] LEDs on PB0–PB7 (with resistors).  
- [ ] Switches on PE0–PE2 (respect pull-down logic in driver).  
- [ ] Startup file is active and first in link order.  
- [ ] Build succeeds, demo matches the **video**.

---

## Credits

Course: **ECE 3620 – Microcomputers**  
Author: **Abid Ahmad**  
Hardware: **TM4C123GH6PM (Tiva C)**

