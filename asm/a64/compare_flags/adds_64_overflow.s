/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000007"
  }
}
*/
// ADDS 64-bit overflow: min_neg + min_neg = 0 with signed overflow

.text
.global _start
_start:
    mov x0, #0
    movk x0, #0x8000, lsl #48  // min negative = 0x8000000000000000
    adds x0, x0, x0            // result = 0, Z=1,C=1,V=1 -> NZCV=0x70000000
    mrs x1, nzcv
    lsr x0, x1, #28            // extract N,Z,C,V bits = 0x7
    brk #0
