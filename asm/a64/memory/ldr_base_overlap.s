/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x1122334455667788",
    "X1": "0x00000000000000AB"
  }
}
*/
// LDR/LDRB base-result overlap without writeback.

.text
.global _start
_start:
    mov x2, #0x7788
    movk x2, #0x5566, lsl #16
    movk x2, #0x3344, lsl #32
    movk x2, #0x1122, lsl #48
    str x2, [sp]

    mov w2, #0xAB
    strb w2, [sp, #8]

    mov x0, sp
    ldr x0, [x0]

    mov x1, sp
    ldrb w1, [x1, #8]

    brk #0
