/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0xFF000000000000FF"
  }
}
*/
// Test: EXTR Xd, Xn, Xm, #lsb - Extract Register
// Extract bit field from pair of registers

.text
.global _start
_start:
    // Extract from low bits
    mov x0, #0x2A       // 42
    mov x1, #0
    
    extr x0, x0, x1, #0  // X0 = 0 (x0=42, x1=0, extracts bits [63:0] from x1:x0? No...)
    // Actually extr x0, x0, x1, #0 extracts bits [63:0] from x0:x1
    // x0 is the high part, x1 is the low part
    // x0:x1 = 42:0, bits [63:0] = x1 = 0
    
    // Extract with shift
    mov x2, #0xFF00
    mov x3, #0xFF
    extr x1, x3, x2, #8  // X1 = bits [71:8] from x3:x2
    // x3 = 0xFF (high), x2 = 0xFF00 (low)
    // x3:x2 = 0x00000000000000FF_000000000000FF00
    // Bits [71:8] = ...

    brk #0
