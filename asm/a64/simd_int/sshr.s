/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000020000000000000002"
}
*/
// Test: SSHR Vd.4S, Vn.4S, #amount - Signed Shift Right
// Arithmetic shift right

.text
.global _start
_start:
    mov w0, #16
    dup v0.4s, w0
    
    // SSHR: signed shift right
    // 16 >> 3 = 2
    sshr v0.4s, v0.4s, #3
    
    brk #0
