/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000002"
}
*/
// Test: ROR Xt, Xn, #imm - Rotate Right Immediate
// Rotates a register value right by an immediate amount

.text
.global _start
_start:
    mov x0, #0x80000000
    movk x0, #0x1, lsl #32  // x0 = 0x00000001_80000000
    
    // ROR: rotate right by 31 bits
    ror x0, x0, #31
    
    brk #0
