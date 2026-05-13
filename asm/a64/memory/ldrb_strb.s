/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000AB",
    "X1": "0x00000000000000CD"
  }
}
*/
// Test: LDRB W0, [X1] - load byte (zero-extend)

.text
.global _start
_start:
    // Allocate stack space
    sub sp, sp, #32

    // Store bytes: 0xAB, 0xCD
    mov w0, #0xCDAB
    strh w0, [sp]

    // Move stack pointer to X1
    mov x1, sp

    // Load byte (should zero-extend)
    ldrb w0, [x1]

    // Load another byte at offset 1
    ldrb w1, [x1, #1]

    add sp, sp, #32

    brk #0