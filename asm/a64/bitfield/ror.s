/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xF00000000000000F"
  }
}
*/
// Test: ROR Xd, Xn, #amount - Rotate Right
// Rotates bits right by specified amount

.text
.global _start
_start:
    mov x0, #0xFF
    
    // ROR: rotate right by 4 bits
    // 0x00000000000000FF >> 4 = 0xF00000000000000F
    ror x0, x0, #4
    
    brk #0
