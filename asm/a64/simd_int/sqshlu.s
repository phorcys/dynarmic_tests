/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000200000000000000010"
}
*/
// Test: SQSHLU Vd.4S, Vn.4S, #amount - Signed Saturating Shift Left Unsigned
// Shifts signed value left, saturates to unsigned

.text
.global _start
_start:
    mov w0, #1
    dup v0.4s, w0
    mov w0, #2
    mov v0.s[2], w0
    
    // SQSHLU: signed saturating shift left unsigned
    // 1 << 4 = 16, 2 << 4 = 32
    sqshlu v0.4s, v0.4s, #4
    
    brk #0