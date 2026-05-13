/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000200000000000000010"
}
*/
// Test: SHLL Vd.4S, Vn.4H, #amount - Shift Left Long
// Widens and shifts elements left

.text
.global _start
_start:
    mov w0, #1
    dup v0.4h, w0
    mov w0, #2
    mov v0.h[2], w0
    
    // SHLL: shift left long (4H -> 4S)
    // 1 << 16 = 0x10000, 2 << 16 = 0x20000
    shll v0.4s, v0.4h, #16
    
    brk #0
