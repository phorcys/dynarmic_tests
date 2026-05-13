/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000100"
  }
}
*/
// Test: UDIV Xd, Xn, Xm - Unsigned Divide
// Unsigned integer division

.text
.global _start
_start:
    mov x0, #10
    mov x1, #5
    
    // 10 / 5 = 2
    udiv x2, x0, x1
    
    mov x0, x2          // X0 = 2
    
    // Test division by zero
    mov x2, #0
    udiv x1, x0, x2     // X1 = 0 (division by zero returns 0)
    
    // Test large unsigned division
    mov x2, #0
    movk x2, #0x1, lsl #16  // X2 = 65536
    mov x3, #256
    
    udiv x2, x2, x3     // 65536 / 256 = 256

    brk #0
