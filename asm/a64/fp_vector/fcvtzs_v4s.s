/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0xbf000000bf8000004000000040800000",
    "Q1": "0x00000000ffffffff0000000200000004"
  }
}
*/
// Test: FCVTZS Vd.4S, Vn.4S - floating-point convert to signed integer

.text
.global _start
_start:
    // Load Q0 with [2.0, 4.0, -1.0, -0.5]
    // 2.0 = 0x40000000, 4.0 = 0x40800000
    // -1.0 = 0xbf800000, -0.5 = 0xbf000000
    ldr x0, =0x4000000040800000
    fmov d0, x0
    ldr x1, =0xbf000000bf800000
    mov v0.d[1], x1
    
    // FCVTZS: convert to signed integer (round toward zero)
    // [2.0, 4.0, -1.0, -0.5] -> [2, 4, -1, 0]
    fcvtzs v1.4s, v0.4s

    brk #0
