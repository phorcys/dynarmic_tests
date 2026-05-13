/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000100000000000000010"
}
*/
// Test: SHL Vd.4S, Vn.4S, #amount - Shift Left Immediate
// Shifts each element left by immediate

.text
.global _start
_start:
    mov w0, #2
    dup v0.4s, w0
    
    // SHL: shift left by immediate
    // 2 << 3 = 16
    shl v0.4s, v0.4s, #3
    
    brk #0
