/* CONFIG
{
  "Match": "All",
  "D0": "0x3FF0000000000000"
}
*/
// Test: FMOV Dd, #imm - Move floating-point immediate (double)
// Loads floating-point immediate into double register

.text
.global _start
_start:
    // FMOV: load 1.0 into double-precision register
    fmov d0, #1.0
    
    // D0 = 1.0 = 0x3FF0000000000000

    brk #0
