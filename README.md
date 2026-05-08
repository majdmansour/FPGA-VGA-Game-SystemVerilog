# Alex Kidd in Miracle World – FPGA Implementation
## Project Overview

This project is a hardware-accelerated implementation of the classic game "Alex Kidd in Miracle World," developed on an Intel FPGA using SystemVerilog. Unlike traditional software-based games, the entire logic—including physics, collision detection, and VGA rendering—is handled directly by the hardware fabric for real-time performance.

## Technical Architecture
The system follows a modular design, ensuring efficient resource management and timing synchronization:

- VGA Controller: Manages the synchronization signals and coordinates the pixel stream for display output.

- Movement Unit: Implements the character physics and user input logic in hardware.

- Collision Detection: A dedicated hardware module that calculates overlapping boundaries in real-time to trigger game events.

## Key Features & Engineering Challenges
Hardware Debugging: Utilized Signal Tap Logic Analyzer to monitor real-time signals on the FPGA, allowing for rapid identification and resolution of logic bugs.

Optimization: Achieved a highly efficient compilation time of 3:55 minutes, significantly exceeding the lab requirement of under 10 minutes.

## Tools Used
- Languages: SystemVerilog

- Software: Intel Quartus Prime

- Hardware: Intel FPGA Board

- Verification: Signal Tap Logic Analyzer

## Media
<p align="center">
  <img src="https://github.com/user-attachments/assets/ec8f7bbe-0106-43c0-9f1a-5bec516e535f" width="600">
</p>
