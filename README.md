# CyberWar
This repository contains Verilog code for a CyberWar game, where a human player competes against a computer opponent in a Tug of War on an FPGA board. The project includes key digital logic components such as counters, LFSRs, and comparators, demonstrating various Verilog practices.

Components
3-bit Counter:
Tracks the score for each player, incrementing on each win.
Uses a simple finite state machine (FSM) to handle state transitions.

7-Segment Display Driver:
Converts binary score values to 7-segment display format for visual feedback.

Linear Feedback Shift Register (LFSR):
Generates pseudo-random numbers to simulate computer moves.
Implements a 10-bit LFSR with carefully chosen feedback taps for randomness.

10-bit Comparator:
Compares the computer's LFSR output with a user-defined value from switches.
Outputs a signal indicating whether the computer should "press" the button.

Clock Divider:
Slows down the game clock to a playable speed.
Ensures all clocked components use the same divided clock for synchronization.

Verilog Practices
Finite State Machines (FSMs) for counters and game logic.
Combinational Logic for the comparator and LFSR feedback calculations.
Sequential Logic for the LFSR and counters, using always_ff blocks for edge-triggered behavior.
Parameterization and Modularity to keep code organized and reusable.
