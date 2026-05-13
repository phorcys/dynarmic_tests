/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000030000000000000003"
}
*/
// Test: SRSRA Vd.4S, Vn.4S, #amount - Signed Rounding Shift Right and Accumulate
// Shifts right with rounding and accumulates

.text
.global _start
_start:
    mov w0, #1
    dup v0.4s, w0
    mov w1, #16
    dup v1.4s, w1
    
    // SRSRA: signed rounding shift right and accumulate
    // 1 + (16 >> 3) = 1 + 2 = 3
    srsra v0.4s, v1.4s, #3
    
    brk #0
