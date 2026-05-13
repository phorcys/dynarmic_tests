/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005"
  }
}
*/
// Test: CMP Xn, #imm - compare immediate

.text
.global _start
_start:
    mov x0, #5
    
    // CMP: compare (Xn - imm)
    // 5 - 5 = 0 -> Z=1
    cmp x0, #5

    brk #0
