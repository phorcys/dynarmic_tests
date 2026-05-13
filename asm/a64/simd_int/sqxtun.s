/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000000000000000000000000000007F"
}
*/
// Test: SQXTUN Vd.4H, Vn.4S - Signed Saturating Extract Unsigned Narrow
// Narrows signed to unsigned with saturation

.text
.global _start
_start:
    mov w0, #127
    dup v0.4s, w0
    
    // SQXTUN: signed to unsigned saturating extract narrow (4S -> 4H)
    // 127 fits in unsigned 16-bit
    sqxtun v0.4h, v0.4s
    
    brk #0
