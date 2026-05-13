/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002",
    "X1": "0x0000000000000004"
  }
}
*/
// Test: LSL Xd, Xn, #imm - Logical Shift Left
// Alias for UBFIZ

.text
.global _start
_start:
    // LSL by immediate
    mov x0, #1
    lsl x0, x0, #1      // X0 = 1 << 1 = 2
    
    mov x1, #1
    lsl x1, x1, #2      // X1 = 1 << 2 = 4

    brk #0
