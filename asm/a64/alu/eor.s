/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000F0"
  }
}
*/
// Test: EOR Xd, Xn, Xm - Bitwise Exclusive OR
// Performs bitwise XOR

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0x0F
    
    // EOR: X0 = X0 XOR X1
    eor x0, x0, x1       // X0 = 0xFF XOR 0x0F = 0xF0

    brk #0