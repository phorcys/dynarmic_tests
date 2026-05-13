/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000030000000000000003"
}
*/
// Test: URSRA Vd.4S, Vn.4S, #amount - Unsigned Rounding Shift Right and Accumulate
// Shifts right with rounding and accumulates

.text
.global _start
_start:
    mov w0, #1
    dup v0.4s, w0
    mov w1, #16
    dup v1.4s, w1
    
    // URSRA: unsigned rounding shift right and accumulate
    // 1 + (16 >> 3) = 1 + 2 = 3
    ursra v0.4s, v1.4s, #3
    
    brk #0
