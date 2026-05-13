/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000020000000000000002"
}
*/
// Test: SRSHR Vd.4S, Vn.4S, #amount - Signed Rounding Shift Right
// Arithmetic shift right with rounding

.text
.global _start
_start:
    mov w0, #17
    dup v0.4s, w0
    
    // SRSHR: signed rounding shift right
    // 17 >> 3 = 2 (with rounding: 17/8 = 2.125 -> 2)
    srshr v0.4s, v0.4s, #3
    
    brk #0
