/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000004000000040000000200000002"
}
*/
// Test: SQDMULH Vd.4S, Vn.4S, Vm.4S - Signed Saturating Double Multiply High
// Multiplies and returns high half of doubled result

.text
.global _start
_start:
    // Setup: v0.2s = [1, 2], v1.2s = [1, 2]
    mov w0, #1
    ins v0.s[0], w0
    add w0, w0, #1
    ins v0.s[1], w0
    mov w1, #1
    ins v1.s[0], w1
    add w1, w1, #1
    ins v1.s[1], w1
    
    // SQDMULH: signed saturating double multiply returning high half
    sqdmulh v0.2s, v0.2s, v1.2s
    
    brk #0
