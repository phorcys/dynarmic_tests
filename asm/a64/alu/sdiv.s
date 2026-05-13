/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002",
    "X1": "0xFFFFFFFFFFFFFFFE",
    "X2": "0x0000000000000000"
  }
}
*/
// Test: SDIV Xd, Xn, Xm - Signed Divide
// Signed integer division

.text
.global _start
_start:
    mov x0, #10
    mov x1, #5
    
    // 10 / 5 = 2
    sdiv x2, x0, x1
    
    mov x0, x2          // X0 = 2
    
    // Test negative division
    mov x2, #-10
    mov x3, #5
    
    // -10 / 5 = -2
    sdiv x1, x2, x3     // X1 = -2 (0xFFFFFFFFFFFFFFFE)
    
    // Test division by zero
    mov x2, #0
    sdiv x3, x0, x2     // X2 = 0 (division by zero returns 0)

    brk #0