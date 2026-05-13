/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000F",
    "X1": "0x000000000000000C"
  }
}
*/
// Test: UBFX - Unsigned Bit Field Extract

.text
.global _start
_start:
    // UBFX Xd, Xn, #lsb, #width
    // Extracts width bits starting from lsb position
    
    mov x2, #0xFF       // bits [7:0] = 1111 1111
    ubfx x0, x2, #2, #4 // Extract bits [5:2] (4 bits) = 1111 = 0xF
    
    mov x3, #0x3C       // 0011 1100
    ubfx x1, x3, #0, #4 // Extract bits [3:0] (4 bits) = 1100 = 0xC

    brk #0
