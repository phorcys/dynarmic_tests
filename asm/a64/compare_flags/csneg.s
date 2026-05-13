/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A",
    "X1": "0xFFFFFFFFFFFFFFEB"
  }
}
*/
// Test: CSNEG Xd, Xn, Xm, #cond - Conditional Select Negate
// If condition true: Xd = Xn; else Xd = -Xm

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0
    
    // Test CSNEG with EQ condition
    mov x2, #42
    mov x3, #21
    
    cmp xzr, xzr       // Sets Z=1 (equal)
    csneg x0, x2, x3, eq   // X0 = X2 = 42 (condition true)
    
    // Test CSNEG with NE condition
    cmp xzr, xzr       // Sets Z=1 (equal)
    csneg x1, x2, x3, ne   // X1 = -X3 = -21 = 0xFFFFFFFFFFFFFFEB (condition false)

    brk #0