/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000004000000040000000400000004",
    "Q1": "0x00000002000000020000000200000002",
    "Q2": "0x0000000C0000000C0000000C0000000C"
  }
}
*/
.text
.global _start
_start:
    // VMLS.I32: Vector Multiply Subtract
    // Q2 = Q2 - Q0 * Q1
    // Q0 = [4,4,4,4], Q1 = [2,2,2,2], Q2 = [20,20,20,20]
    // Q2 = [20 - 4*2, ...] = [12,12,12,12] = [0xC,...]
    vmov.i32 q0, #4
    vmov.i32 q1, #2
    vmov.i32 q2, #20
    vmls.i32 q2, q0, q1
    bkpt #0
