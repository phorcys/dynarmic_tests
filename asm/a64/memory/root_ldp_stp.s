/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x1111111111111111",
    "X1": "0x2222222222222222"
  }
}
*/
// Test: LDP X0, X1, [X2] - load pair

.text
.global _start
_start:
    // Allocate stack space
    sub sp, sp, #64

    // Store test values to stack
    mov x0, #0x1111
    movk x0, #0x1111, lsl #16
    movk x0, #0x1111, lsl #32
    movk x0, #0x1111, lsl #48

    mov x1, #0x2222
    movk x1, #0x2222, lsl #16
    movk x1, #0x2222, lsl #32
    movk x1, #0x2222, lsl #48

    // Store pair: STP X0, X1, [SP]
    stp x0, x1, [sp]

    // Clear X0, X1
    mov x0, #0
    mov x1, #0

    // Load pair: LDP X0, X1, [SP]
    ldp x0, x1, [sp]

    add sp, sp, #64

    brk #0
