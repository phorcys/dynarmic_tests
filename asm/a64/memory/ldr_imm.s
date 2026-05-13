/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x1234567890ABCDEF"
  }
}
*/
// Test: LDR X0, [X1] - load register (immediate offset)

.text
.global _start
_start:
    // Allocate stack space
    sub sp, sp, #32

    // Store test value to stack
    mov x0, #0xCDEF
    movk x0, #0x90AB, lsl #16
    movk x0, #0x5678, lsl #32
    movk x0, #0x1234, lsl #48
    str x0, [sp]

    // Move stack pointer to X1
    mov x1, sp

    // Clear X0
    mov x0, #0

    // LDR: X0 = mem[X1]
    ldr x0, [x1]

    add sp, sp, #32

    brk #0
