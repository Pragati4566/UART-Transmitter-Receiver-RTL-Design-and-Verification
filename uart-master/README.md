# UART Transmitter-Receiver RTL Design

## Overview

This project implements a basic UART (Universal Asynchronous Receiver/Transmitter)
using Verilog and RTL Design.

The project contains two main parts:

- UART Transmitter (TX)
- UART Receiver (RX)

The Transmitter converts parallel data into serial data,
and the Receiver converts the serial data back into parallel data.

The design is tested using a Verilog testbench and verified
using simulation waveforms.

---

## Architecture

```text
                                    UART TRANSMITTER–RECEIVER
                         RTL DESIGN
                              │
                              │
                  ┌───────────▼───────────┐
                  │       INPUT DATA      │
                  │                       │
                  │  TX Data [7:0]        │
                  │  TX Start             │
                  │  Reset                │
                  └───────────┬───────────┘
                              │
                              ▼
                ┌─────────────────────────┐
                │    UART TRANSMITTER     │
                │                         │
                │      Verilog RTL        │
                │                         │
                │  • Data Register        │
                │  • State Machine        │
                │  • Bit Counter          │
                │  • Baud Counter         │
                └────────────┬────────────┘
                             │
                             │ Serial TX Line
                             │
                             ▼
                 ┌────────────────────────┐
                 │      UART RECEIVER     │
                 │                        │
                 │       Verilog RTL      │
                 │                        │
                 │  • Start Detection     │
                 │  • Data Sampling       │
                 │  • Bit Counter         │
                 │  • State Machine       │
                 └────────────┬───────────┘
                              │
                              ▼
                   ┌─────────────────────┐
                   │     OUTPUT DATA     │
                   │                     │
                   │  RX Data [7:0]      │
                   │  RX Valid           │
                   └─────────────────────┘


         CONFIGURATION / TIMING
         ──────────────────────

              ┌──────────────────────┐
              │   UART PARAMETERS    │
              │                      │
              │  DATA_WIDTH = 8      │
              │  BAUD_RATE           │
              │  CLK_FREQ_HZ         │
              └──────────┬───────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │   BAUD CALCULATION   │
              │                      │
              │   CLKS_PER_BIT       │
              └──────────┬───────────┘
                         │
                  Controls TX/RX
                     bit timing


              VERIFICATION FLOW
              ────────────────

       ┌──────────────────────┐
       │     TESTBENCH.V      │
       │                      │
       │ • Generates Clock    │
       │ • Applies Reset      │
       │ • Sends Test Data    │
       │ • Starts TX          │
       │ • Observes RX        │
       └──────────┬───────────┘
                  │
                  ▼
       ┌──────────────────────┐
       │     SIMULATION       │
       │                      │
       │       VeriSim        │
       └──────────┬───────────┘
                  │
                  ▼
       ┌──────────────────────┐
       │   WAVEFORM ANALYSIS  │
       │                      │
       │  TX → Serial Data    │
       │  RX → Received Data  │
       │  RX_VALID            │
       └──────────────────────┘
