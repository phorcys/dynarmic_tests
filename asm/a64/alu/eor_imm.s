/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000FFFF",
    "X1": "0x000000000000FF00"
  }
}
*/
// Test: EOR Xd, Xn, #imm - bitwise exclusive OR with immediate

.text
.global _start
_start:
    mov x0, #0xFFFF
    
    // EOR with 0x00FF
    eor x1, x0, #0xFF

    brk #0