/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000000000002"
}
*/
// Test: SHRN Vd.4H, Vn.4S, #amount - Shift Right Narrow
// Narrows and shifts elements right

.text
.global _start
_start:
    mov w0, #16
    dup v0.4s, w0
    
    // SHRN: shift right narrow (4S -> 4H)
    // 16 >> 3 = 2
    shrn v0.4h, v0.4s, #3
    
    brk #0
