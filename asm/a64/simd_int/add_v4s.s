/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00020003000200030002000300020003",
    "Q1": "0x00040005000400050004000500040005",
    "Q2": "0x00060008000600080006000800060008"
  }
}
*/
// Test: ADD Vd.4S, Vn.4S, Vm.4S - integer add (4x 32-bit)
// V0.4S = [2, 3, 2, 3]
// V1.4S = [4, 5, 4, 5]
// V2.4S = V0 + V1 = [6, 8, 6, 8]

.text
.global _start
_start:
    // Load V0 with [2, 3, 2, 3]
    mov x0, #0x00000003
    movk x0, #0x0002, lsl #16
    movk x0, #0x0003, lsl #32
    movk x0, #0x0002, lsl #48
    mov v0.d[0], x0
    mov v0.d[1], x0

    // Load V1 with [4, 5, 4, 5]
    mov x1, #0x00000005
    movk x1, #0x0004, lsl #16
    movk x1, #0x0005, lsl #32
    movk x1, #0x0004, lsl #48
    mov v1.d[0], x1
    mov v1.d[1], x1

    // Vector add
    add v2.4s, v0.4s, v1.4s

    brk #0