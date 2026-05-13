/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000004000000020000000100000000",
    "Q2": "0x40800000400000003f80000000000000"
  }
}
*/
// Test: SCVTF Vd.4S, Vn.4S - signed integer convert to floating-point

.text
.global _start
_start:
    // Load Q0 with [0, 1, 2, 4]
    mov w0, #0
    mov w1, #1
    mov w2, #2
    mov w3, #4
    mov v0.s[0], w0
    mov v0.s[1], w1
    mov v0.s[2], w2
    mov v0.s[3], w3
    
    // SCVTF: convert signed integer to floating-point
    // [0, 1, 2, 4] -> [0.0, 1.0, 2.0, 4.0]
    // 0.0 = 0x00000000, 1.0 = 0x3f800000
    // 2.0 = 0x40000000, 4.0 = 0x40800000
    scvtf v2.4s, v0.4s

    brk #0