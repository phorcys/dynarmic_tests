/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000010",
    "X1": "0x0000000000000001"
  }
}
*/
// Test: LSR Xd, Xn, #imm - logical shift right by immediate (64-bit)

.text
.global _start
_start:
    mov x0, #16
    lsr x1, x0, #4       // 16 >> 4 = 1

    brk #0
