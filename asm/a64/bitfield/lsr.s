/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000008",
    "X1": "0x0000000000000004"
  }
}
*/
// Test: LSR Xd, Xn, #imm - Logical Shift Right
// Shift right by immediate

.text
.global _start
_start:
    // LSR by immediate
    mov x0, #16
    lsr x0, x0, #1      // X0 = 16 >> 1 = 8
    
    mov x1, #16
    lsr x1, x1, #2      // X1 = 16 >> 2 = 4

    brk #0
