/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005",
    "X1": "0x0000000000000003",
    "X2": "0x0000000000000001",
    "X3": "0x0000000000000002",
    "X4": "0x0000000000000001",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: SBC - subtract with carry
// SBC: result = a - b - (1 - C)

.text
.global _start
_start:
    mov x0, #5
    mov x1, #3
    mov x2, #1
    
    // Test 1: SBC with C=1 (normal subtraction)
    cmp x2, #1               // Set C=1 (no borrow)
    sbc x3, x0, x1           // 5 - 3 - (1-1) = 5 - 3 - 0 = 2
    
    // Test 2: SBC with C=0
    cmp x2, #2               // Set C=0 (borrow, 1-2 underflows)
    sbc x4, x0, x1           // 5 - 3 - (1-0) = 5 - 3 - 1 = 1
    
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
