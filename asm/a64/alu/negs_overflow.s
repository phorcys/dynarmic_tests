/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// NEGS overflow - negate max positive causes overflow

.text
.global _start
_start:
    mov x0, #1
    movk x0, #0x0000, lsl #16
    movk x0, #0x0000, lsl #32
    movk x0, #0x8000, lsl #48  // x0 = 0x8000000000000001 (not max positive but negative)
    // Actually let's use min negative which will overflow when negated
    mov x0, #0
    movk x0, #0x0000, lsl #16
    movk x0, #0x0000, lsl #32
    movk x0, #0x8000, lsl #48  // x0 = 0x8000000000000000 (min negative)
    negs x0, x0           // negate min negative -> overflow (stays same, V=1)
    cset x0, vs           // x0 = 1 if overflow flag set
    brk #0
