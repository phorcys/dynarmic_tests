/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000200000000000000010"
}
*/
// Test: USHLL Vd.4S, Vn.4H, #amount - Unsigned Shift Left Long
// Shifts elements left and widens

.text
.global _start
_start:
    mov w0, #1
    dup v0.4h, w0
    mov w0, #2
    mov v0.h[2], w0
    
    // USHLL: unsigned shift left long (4H -> 4S)
    // 1 << 4 = 16, 2 << 4 = 32
    ushll v0.4s, v0.4h, #4
    
    brk #0
