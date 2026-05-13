/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x40004040000000004000404000000000",
    "Q1": "0x40804100000000004080410000000000",
    "Q2": "0x40804100000000004080410000000000"
  }
}
*/
// Test: FMAX Vd.4S, Vn.4S, Vm.4S - floating-point maximum (4x single)
// V0.4S = [2.0, 3.0, 2.0, 3.0]
// V1.4S = [4.0, 8.0, 4.0, 8.0]
// V2.4S = max(V0, V1) = [4.0, 8.0, 4.0, 8.0]

.text
.global _start
_start:
    // Load V0 with [2.0, 3.0, 2.0, 3.0]
    mov x0, #0x0000
    movk x0, #0x0000, lsl #16
    movk x0, #0x4040, lsl #32
    movk x0, #0x4000, lsl #48
    mov v0.d[0], x0
    mov v0.d[1], x0

    // Load V1 with [4.0, 8.0, 4.0, 8.0]
    mov x1, #0x0000
    movk x1, #0x0000, lsl #16
    movk x1, #0x4100, lsl #32
    movk x1, #0x4080, lsl #48
    mov v1.d[0], x1
    mov v1.d[1], x1

    // Vector maximum
    fmax v2.4s, v0.4s, v1.4s

    brk #0