# TM4C “Festive Lights” — ARM Assembly

Eight LEDs on Port B (PB7..PB0) display three patterns—Right→Left, Left→Right, and a pre-made random sequence—selected with three Port E switches (PE0..PE2). SysTick (or a busy delay) paces frames ~0.5 s. Press–release–press of the same switch cleanly **stops** playback. Table-driven frames keep the code small and readable.

---

## Repo Contents
- `main_code (1).s` – main control/loop, pattern selection, runner  
- `PortB_driver (1).s` – `PORTB_Init`, `PORTB_Output` (LEDs)  
- `PortE_driver.s` – `PORTE_Init`, `PORTE_Input` (switches)  
- `Startup (1).s` – vector table / reset / handlers (as used in project)  
- `ECE3620_EXTRACREDIT_FINAL.pdf` – project report (upload here)  
- `ECE3620_ProjectVideo.mp4` – short demo video  
- **Diagrams (one PDF, all three):** `docs/diagrams/SDLC_Diagrams.pdf`  
  *(Put FLOW CHART + DATA-FLOW CHART + CALL GRAPH together in this single PDF.)*

Quick links:
- 📄 **Report:** [ECE3620_EXTRACREDIT_FINAL.pdf](./ECE3620_EXTRACREDIT_FINAL.pdf)  
- 🎥 **Demo Video:** [ECE3620_ProjectVideo.mp4](./ECE3620_ProjectVideo.mp4)  
- 🗺️ **Flow/Data-Flow/Call Graphs (one file):** [SDLC_Diagrams.pdf](./docs/diagrams/SDLC_Diagrams.pdf)

---

## Features
- 3 one-hot inputs on **PE0/PE1/PE2** select patterns
- 8 outputs on **PB0..PB7** drive LEDs
- Release-then-press of same switch stops the sequence (debounce-friendly)
- Table-driven pattern bytes: easy to extend or reorder
- Simple delay loop (or swap to SysTick)

---

## Build & Run (Keil/uVision example)
1. Create TM4C123 project, **Thumb** / **ARM**.  
2. Add all `.s` files above to the project.  
3. Ensure startup file/vector table matches your toolchain.  
4. Build → Flash → Run on LaunchPad (PB0..PB7 to LEDs, PE0..PE2 to switches).

*(If you use Make/OpenOCD, add your own steps here.)*

---

## Usage
- **S0 (PE0):** Right → Left sweep  
- **S1 (PE1):** Left → Right sweep  
- **S2 (PE2):** Random pre-made sequence  
- While a pattern is running: **release, then press the same switch** to stop (LEDs off).

---

## SDLC (for your report)
- **Analyze** — Req’s: 3 patterns, 8 LEDs, ~0.5 s cadence; Constraints: 16 MHz, GPIO pins, lab parts.  
- **Design** — Block/circuit, flowchart, data-flow, call graph; table-driven frames + single runner.  
- **Development** — `PortB_*`, `PortE_*`, pattern tables, main loop & stop logic.  
- **Testing** — Per-pattern verification, press/release/stop, wraparound timing check.  
- **Deployment** — Flashed to LaunchPad; demo video recorded; docs added to repo.

---

## License
Add a LICENSE (MIT recommended) if you plan to share.

