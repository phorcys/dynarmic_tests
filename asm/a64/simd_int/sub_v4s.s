/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00080005000800050008000500080005",
    "Q1": "0x00020003000200030002000300020003",
    "Q2": "0x00060002000600020006000200060002"
  }
}
*/
// Test: SUB Vd.4S, Vn.4S, Vm.4S - integer subtract (4x 32-bit)
// V0.4S = [5, 8, 5, 8]
// V1.4S = [2, 3, 2, 3]
// V2.4S = V0 - V1 = [3, 5, 3, 5]

.text
.global _start
_start:
    // Load V0 with [5, 8, 5, 8]
    mov x0, #0x00000005
    movk x0, #0x0008, lsl #16
    movk x0, #0x0005, lsl #32
    movk x0, #0x0008, lsl #48
    mov v0.d[0], x0
    mov v0.d[1], x0

    // Load V1 with [2, 3, 2, 3]
    mov x1, #0x00000003
    movk x1, #0x0002, lsl #16
    movk x1, #0x0003, lsl #32
    movk x1, #0x0002, lsl #48
    mov v1.d[0], x1
    mov v1.d[1], x1

    // Vector subtract
    sub v2.4s, v0.4s, v1.4s

    brk #0