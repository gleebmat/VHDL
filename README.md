# VHDL / Vivado Projects

A collection of VHDL designs developed and simulated using AMD/Xilinx Vivado.  
Each project includes RTL source code, a testbench, and simulation documentation.

## Projects

| Project | Description |
|--------|-------------|
| [Voting Machine](./voting-machine/) | Finite-state-machine voting controller with three counters and input validation |
| [Clock Divider + LED Blinker](./clock-divider/) | Clock divider generating slow signals for LED blinking; includes testbench and waveform analysis |
| [Button Synchronizer + Debouncer + LED Toggle](./button-debouncer/) | Complete button input pipeline: metastability protection, digital debouncing, rising-edge detection, and LED toggle logic |
| [Four-Digit Hexadecimal Seven-Segment Display](./seven-segment-hex-display/) | Multiplexed four-digit active-low seven-segment display controller with hexadecimal decoder, scan counter, digit selection, reset logic, and self-checking simulation |
| [PWM LED Dimmer](./pwm-led-dimmer/) | Parameterized pulse-width-modulation generator using a clocked counter and duty-cycle comparator; includes reset behavior, 0–100% boundary testing, and a fixed 50% LED top module |