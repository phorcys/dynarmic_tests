/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000FFFF",
    "X1": "0x000000000000FFFF"
  }
}
*/
// Test: ANDS Xd, Xn, #imm - bitwise AND with immediate and set flags

.text
.global _start
_start:
    mov x0, #0xFFFF
    
    // ANDS with 0xFFFF, result is non-zero, Z=0
    ands x1, x0, #0xFFFF

    brk #0
