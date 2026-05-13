/* CONFIG
{
  "Match": "All",
  "S0": "0x000000002A000000"
}
*/
// Test: FMOV Sd, #imm - Move floating-point immediate
// Loads floating-point immediate into register

.text
.global _start
_start:
    // FMOV: load 1.0 into single-precision register
    fmov s0, #1.0
    
    // S0 = 1.0 = 0x3F800000

    brk #0
