/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000008000000080000000800000008",
    "Q1": "0x00000008000000080000000800000008"
  }
}
*/
.text
.global _start
_start:
    @ VRSRA: Vector Rounding Shift Right Accumulate
    @ Q1 = Q1 + (Q0 >> 1 with rounding)
    @ Q0 = [8,8,8,8], shift right by 1 with rounding = [4,4,4,4]
    @ Q1 = [4,4,4,4] + [4,4,4,4] = [8,8,8,8]
    vmov.i32 q0, #8
    vmov.i32 q1, #4
    vrsra.s32 q1, q0, #1
    bkpt #0