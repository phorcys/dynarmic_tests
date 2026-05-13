/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000004000000040000000400000004",
    "Q1": "0x00000002000000020000000200000002",
    "Q2": "0x00000010000000100000001000000010"
  }
}
*/
.text
.global _start
_start:
    // VMLA.I32: Vector Multiply Accumulate
    // Q2 = Q2 + Q0 * Q1
    // Q0 = [4,4,4,4], Q1 = [2,2,2,2], Q2 = [8,8,8,8]
    // Q2 = [8 + 4*2, ...] = [16,16,16,16] = [0x10,...]
    vmov.i32 q0, #4
    vmov.i32 q1, #2
    vmov.i32 q2, #8
    vmla.i32 q2, q0, q1
    bkpt #0
