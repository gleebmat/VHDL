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
| [Traffic Lights Controller](./Traffic_lights_controller/) | A parameterized, safety-oriented VHDL finite-state-machine traffic intersection controller. It coordinates North/South and East/West vehicle signals through red+yellow, green, flashing-green, yellow, and all-red transition phases, ensuring that conflicting directions are never given a go signal simultaneously. The design also supports pedestrian requests: a request is stored in a synchronous pending flag so a brief button press is remembered until the current vehicle phase reaches a safe all-red point. Pedestrian crossing phases hold both vehicle directions at red, provide a walk indication for a configurable interval, and then flash the pedestrian indication before traffic resumes. Independent counters control phase durations and blink timing, while a dedicated output decoder supplies safe default light values for every state. |