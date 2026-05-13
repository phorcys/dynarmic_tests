/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000002001"
  }
}
*/
// REV16 reverse bytes in each halfword

.text
.global _start
_start:
    mov x0, #0
    movk x0, #0x0120, lsl #0   // halfword: 0x0120
    rev16 x0, x0               // reverse bytes: 0x2001
    brk #0
