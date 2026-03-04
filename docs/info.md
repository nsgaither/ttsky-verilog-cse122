<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

# Hello Display
Inspired by: [550 : Sequential Circuit for 7-Segment Display done in Wokwi](https://tinytapeout.com/chips/ttsky25a/tt_um_wokwi_441378095886546945)
Tool used: [Interactive 7-Segment LED Display animator](https://jasonacox.github.io/TM1637TinyDisplay/examples/7-segment-animator.html) (was only used for encodings)
## How it works
The project cycles trhough the letters of HELLO on a single seven segment display. The module uses sequential logic to advance through to the next letter at the rising edge of an external 1Hz clock. The logic then loops back after the final O, and goes back to the inital H.

## How to test
1. Connect a 1 Hz clock signal `clk`.
2. Connect the active-low reset `rst_n` to a push button that pulls the signal low when pressed.
3. Assert `rst_n` low briefly to reset the sequence to 'H', then release it.
4. The display should cycle through H → E → L → L → O, changing letter every second.
5. Loop O → H.

## External hardware
- Single common-anode seven-segment display, connect the seven segment pins (a–g) to the corresponding output pins of the chip.
- 1 Hz external clock source.

## Testbench
The testbench (`tb.v`) is a Verilog testbench that verifies the correctness of the Hello Display design. This is testbench covers all of the functionality of my chip, only difference being at a faster clk than intended (10ns period is too fast for naked human eye, please dont run my chip at that); however, functionally still working the same.
 
It tests the following:
- Reset behavior (asserting `rst_n` low, and confirms it starts at first letter (H))
- Letter sequence (After reset is released, goes through each letter and asserts it prints out expected)
- Letter wrap around (Ensures it goes back to O after H)

