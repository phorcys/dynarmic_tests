/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x123456789ABCDEF0",
    "X1": "0x0000000000000010",
    "X2": "0xDEF0123456789ABC",
    "X3": "0x0000000000000008",
    "X4": "0xF0123456789ABCDE"
  }
}
*/
// Test: RORV - Rotate Right Variable

.text
.global _start
_start:
    // X0 = 0x123456789ABCDEF0
    mov x0, #0xDEF0
    movk x0, #0x9ABC, lsl #16
    movk x0, #0x5678, lsl #32
    movk x0, #0x1234, lsl #48
    
    // Rotate right by 16 bits
    mov x1, #16
    rorv x2, x0, x1       // x2 = 0xDEF0123456789ABC
    
    // Rotate right by 8 bits
    mov x3, #8
    rorv x4, x0, x3       // x4 = 0xF0123456789ABCDE

    brk #0
