/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000200000000000000010"
}
*/
// Test: SSHLL Vd.4S, Vn.4H, #amount - Signed Shift Left Long
// Shifts elements left and widens

.text
.global _start
_start:
    mov w0, #1
    dup v0.4h, w0
    mov w0, #2
    mov v0.h[2], w0
    
    // SSHLL: signed shift left long (4H -> 4S)
    // 1 << 4 = 16, 2 << 4 = 32
    sshll v0.4s, v0.4h, #4
    
    brk #0
