/* CONFIG
{
  "RegData": {
    "X0": "0x4010000000000000"
  }
}
*/
// FADD double: 2.0 + 2.0 = 4.0

.text
.global _start
_start:
    // 2.0 as double = 0x4000000000000000
    mov x0, #0
    movk x0, #0x0000, lsl #16
    movk x0, #0x0000, lsl #32
    movk x0, #0x4000, lsl #48
    fmov d0, x0
    fmov d1, x0
    fadd d0, d0, d1            // 2.0 + 2.0 = 4.0 = 0x4010000000000000
    fmov x0, d0
    brk #0
