/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000003000000020000000300000002",
    "Q1": "0x00000005000000040000000500000004",
    "Q2": "0x0000000F000000080000000F00000008"
  }
}
*/
// Test: MUL Vd.4S, Vn.4S, Vm.4S - integer multiply (4x 32-bit)
// V0.4S = [2, 3, 2, 3]
// V1.4S = [4, 5, 4, 5]
// V2.4S = V0 * V1 = [8, 15, 8, 15]

.text
.global _start
_start:
    // Load V0 with [2, 3, 2, 3] using 32-bit lanes
    mov x0, #2
    mov x1, #3
    dup v0.2s, w0           // V0 = [2, 2]
    ins v0.s[1], w1         // V0 = [2, 3]
    ins v0.s[2], w0         // V0 = [2, 3, 2]
    ins v0.s[3], w1         // V0 = [2, 3, 2, 3]

    // Load V1 with [4, 5, 4, 5]
    mov x0, #4
    mov x1, #5
    dup v1.2s, w0           // V1 = [4, 4]
    ins v1.s[1], w1         // V1 = [4, 5]
    ins v1.s[2], w0         // V1 = [4, 5, 4]
    ins v1.s[3], w1         // V1 = [4, 5, 4, 5]

    // Vector multiply
    mul v2.4s, v0.4s, v1.4s

    brk #0