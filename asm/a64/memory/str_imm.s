/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x1234567890ABCDEF"
  }
}
*/
// Test: STR X0, [X1] - store register, then load back

.text
.global _start
_start:
    // Allocate stack space
    sub sp, sp, #32

    // Store test value
    mov x0, #0xCDEF
    movk x0, #0x90AB, lsl #16
    movk x0, #0x5678, lsl #32
    movk x0, #0x1234, lsl #48
    str x0, [sp]

    // Load it back (X0 already has the value)
    ldr x0, [sp]

    add sp, sp, #32

    brk #0