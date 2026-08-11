# UART Transmitter-Receiver RTL Design

## About

This project implements a basic UART Transmitter and Receiver
using Verilog RTL Design.

The UART Transmitter converts parallel data into serial data,
while the Receiver converts serial data back into parallel data.

## Architecture

```text
Parallel Data
      |
      v
  UART TX
      |
      | Serial Data
      v
  UART RX
      |
      v
Received Data
