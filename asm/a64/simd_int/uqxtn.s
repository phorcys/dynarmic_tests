/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000000000000000000000000000007F"
}
*/
// Test: UQXTN Vd.4H, Vn.4S - Unsigned Saturating Extract Narrow
// Narrows with unsigned saturation

.text
.global _start
_start:
    mov w0, #127
    dup v0.4s, w0
    
    // UQXTN: unsigned saturating extract narrow (4S -> 4H)
    // 127 fits in unsigned 16-bit
    uqxtn v0.4h, v0.4s
    
    brk #0
