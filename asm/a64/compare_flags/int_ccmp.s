/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000005"
  }
}
*/
// Test: CCMP - Conditional Compare

.text
.global _start
_start:
    mov x2, #5
    
    // Compare x2 with 10, x2 < 10, so condition gt is false
    // When condition is false, set NZCV to #0 (nzcv = 0000)
    cmp x2, #10
    ccmp x2, #3, #0, gt  // If gt (x2 > 10), compare x2 with 3, else set flags to 0
    
    // CSEL to check result
    // Since condition gt was false, flags = 0, so Z=0, C=0, N=0, V=0
    // Actually nzcv = 0000 means N=0, Z=0, C=0, V=0
    csel x0, x2, xzr, eq  // If Z=0, x0 = 0
    csel x1, x2, xzr, ne  // If Z=0, x1 = x2

    brk #0
