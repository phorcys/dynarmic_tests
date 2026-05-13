/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005"
  }
}
*/
// Test: CMN Xn, #imm - compare negative immediate

.text
.global _start
_start:
    mov x0, #5
    
    // CMN: compare with negative (Xn + imm)
    // 5 + (-5) = 0 -> Z=1
    cmn x0, #5

    brk #0
