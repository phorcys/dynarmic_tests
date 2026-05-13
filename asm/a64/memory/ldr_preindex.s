/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x1234567890ABCDEF"
  }
}
*/
// Test: LDR X0, [X1, #8]! - load with pre-index

.text
.global _start
_start:
    // Allocate stack space
    sub sp, sp, #64

    // Store test value at sp+8
    mov x0, #0xCDEF
    movk x0, #0x90AB, lsl #16
    movk x0, #0x5678, lsl #32
    movk x0, #0x1234, lsl #48
    str x0, [sp, #8]

    // Clear X0
    mov x0, #0

    // Move sp to x1
    mov x1, sp

    // Pre-index: X1 = X1 + 8, then load from X1
    ldr x0, [x1, #8]!

    // X0 = 0x1234567890ABCDEF
    // X1 = sp + 8 (we don't verify X1)

    add sp, sp, #64

    brk #0
