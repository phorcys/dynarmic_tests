/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000000"
  }
}
*/
// Test: ANDS Xd, Xn, Xm - Bitwise AND and set flags
// Performs bitwise AND and sets condition flags

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #1
    
    // ANDS: X0 = X0 AND X1, set flags
    ands x0, x0, x1      // X0 = 1, Z=0, N=0
    
    // Test with zero result
    mov x2, #0xFF
    mov x3, #0
    ands x1, x2, x3      // X1 = 0, Z=1, N=0

    brk #0
