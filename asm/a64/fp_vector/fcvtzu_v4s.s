/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x4080000040000000bf000000bf800000",
    "Q2": "0x00000004000000020000000000000000"
  }
}
*/
// Test: FCVTZU Vd.4S, Vn.4S - floating-point convert to unsigned integer

.text
.global _start
_start:
    // Load Q0 with [-1.0, -0.5, 2.0, 4.0]
    ldr x0, =0xbf000000bf800000  // -0.5, -1.0
    fmov d0, x0
    ldr x1, =0x4080000040000000  // 4.0, 2.0
    mov v0.d[1], x1
    
    // FCVTZU: convert to unsigned integer (round toward zero)
    // [-1.0, -0.5, 2.0, 4.0] -> [0 (clamped), 0 (clamped), 2, 4]
    fcvtzu v2.4s, v0.4s

    brk #0