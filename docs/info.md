<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

# Hello Display

## How it works
Inspired by: [550 : Sequential Circuit for 7-Segment Display](https://tinytapeout.com/chips/ttsky25a/tt_um_wokwi_441378095886546945)
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
