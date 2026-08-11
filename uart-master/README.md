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
                Parallel Data
                      |
                      v
                +-----------+
                |  UART TX  |
                | RTL Module|
                +-----+-----+
                      |
                      | Serial Data
                      v
                +-----------+
                |  UART RX  |
                | RTL Module|
                +-----+-----+
                      |
                      v
                Received Data
