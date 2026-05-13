/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF",
    "X1": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: SBFX - Signed Bit Field Extract

.text
.global _start
_start:
    // SBFX Xd, Xn, #lsb, #width
    // Extracts width bits starting from lsb position, sign-extends
    
    mov x2, #0x3C       // 0011 1100
    sbfx x0, x2, #2, #4 // Extract bits [5:2] = 1111, sign-extend = -1
    
    mov x3, #0x3C       // 0011 1100
    sbfx x1, x3, #2, #2 // Extract bits [3:2] = 11, sign-extend = -1

    brk #0
