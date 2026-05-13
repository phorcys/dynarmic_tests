/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A",
    "X1": "0x0000000000000015"
  }
}
*/
// Test: CSINC Xd, Xn, Xm, #cond - Conditional Select Increment
// If condition true: Xd = Xn; else Xd = Xm + 1

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0
    
    // Test CSINC with EQ condition
    mov x2, #42
    mov x3, #20
    
    cmp xzr, xzr       // Sets Z=1 (equal)
    csinc x0, x2, x3, eq  // X0 = X2 = 42 (condition true)
    
    // Test CSINC with NE condition
    cmp xzr, xzr       // Sets Z=1 (equal)
    csinc x1, x2, x3, ne  // X1 = X3 + 1 = 21 (condition false)

    brk #0