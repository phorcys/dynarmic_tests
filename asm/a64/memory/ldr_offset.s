/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x1111111111111111",
    "X1": "0x2222222222222222"
  }
}
*/
// Test: LDR X0, [X1, #offset] - load with offset

.text
.global _start
_start:
    // Allocate stack space
    sub sp, sp, #64

    // Store test values
    mov x0, #0x1111
    movk x0, #0x1111, lsl #16
    movk x0, #0x1111, lsl #32
    movk x0, #0x1111, lsl #48
    str x0, [sp, #8]

    mov x0, #0x2222
    movk x0, #0x2222, lsl #16
    movk x0, #0x2222, lsl #32
    movk x0, #0x2222, lsl #48
    str x0, [sp, #16]

    // Clear X0, X1
    mov x0, #0
    mov x1, #0

    // Load with offset
    ldr x0, [sp, #8]
    ldr x1, [sp, #16]

    add sp, sp, #64

    brk #0
