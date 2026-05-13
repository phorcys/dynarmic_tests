/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x8000000000000000",
    "X1": "0x8000000000000000",
    "X2": "0x0000000000000001",
    "X3": "0xFFFFFFFFFFFFFFFF",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: NEG - boundary cases (MIN_INT, 1, 0)

.text
.global _start
_start:
    // NEG of MIN_INT (overflow, returns MIN_INT)
    movn x0, #0              // x0 = -1
    movn x0, #0x7FFF, lsl #48  // Actually let's use a different approach
    // MIN_INT = 0x8000000000000000
    movz x0, #0
    movk x0, #0x8000, lsl #48
    neg x1, x0               // -MIN_INT = MIN_INT (overflow)
    
    // NEG of 1
    mov x2, #1
    neg x3, x2               // -1 = 0xFFFFFFFFFFFFFFFF
    
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
