/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A",
    "X1": "0x0000000000000014"
  }
}
*/
// Test: CSEL Xd, Xn, Xm, #cond - Conditional Select
// If condition true: Xd = Xn; else Xd = Xm

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0
    
    // Test CSEL with EQ condition
    mov x2, #42
    mov x3, #20
    
    cmp xzr, xzr       // Sets Z=1 (equal)
    csel x0, x2, x3, eq   // X0 = X2 = 42 (condition true)
    
    // Test CSEL with NE condition
    cmp xzr, xzr       // Sets Z=1 (equal)
    csel x1, x2, x3, ne   // X1 = X3 = 20 (condition false)

    brk #0