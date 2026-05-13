/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40800000404CCCCC40800000404CCCCC",
    "Q1": "0x40800000404000004080000040400000"
  }
}
*/
// Test: FRINTN Vd.4S - floating-point round to nearest (4x single)
// V0.4S = [3.2, 4.0, 3.2, 4.0]
// V1.4S = round(V0) = [3.0, 4.0, 3.0, 4.0]
// 3.2 ≈ 0x404CCCCC, 4.0 = 0x40800000
// 3.0 = 0x40400000

.text
.global _start
_start:
    // Load V0 with [3.2, 4.0, 3.2, 4.0]
    // d[0]: S[0]=3.2, S[1]=4.0 => 0x40800000_404CCCCC
    mov x0, #0xCCCC
    movk x0, #0x404C, lsl #16
    movk x0, #0x0000, lsl #32
    movk x0, #0x4080, lsl #48
    mov v0.d[0], x0
    mov v0.d[1], x0

    // Round to nearest
    frintn v1.4s, v0.4s

    brk #0