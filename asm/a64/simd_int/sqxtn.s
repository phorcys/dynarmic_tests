/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000000000000000000000000000007F"
}
*/
// Test: SQXTN Vd.4H, Vn.4S - Signed Saturating Extract Narrow
// Narrows with signed saturation

.text
.global _start
_start:
    mov w0, #127
    dup v0.4s, w0
    
    // SQXTN: signed saturating extract narrow (4S -> 4H)
    // 127 fits in signed 16-bit
    sqxtn v0.4h, v0.4s
    
    brk #0
