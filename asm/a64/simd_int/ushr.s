/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000020000000000000002"
}
*/
// Test: USHR Vd.4S, Vn.4S, #amount - Unsigned Shift Right
// Logical shift right

.text
.global _start
_start:
    mov w0, #16
    dup v0.4s, w0
    
    // USHR: unsigned shift right
    // 16 >> 3 = 2
    ushr v0.4s, v0.4s, #3
    
    brk #0
