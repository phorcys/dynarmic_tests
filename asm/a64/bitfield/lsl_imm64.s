/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000010"
  }
}
*/
// Test: LSL Xd, Xn, #imm - logical shift left by immediate (64-bit)

.text
.global _start
_start:
    mov x0, #1
    lsl x1, x0, #4       // 1 << 4 = 16

    brk #0
