/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x42400000",
    "S1": "0x40000000",
    "S2": "0x40800000",
    "S3": "0x00000000"
  }
}
*/
// Scalar FP chain:
//   s0 = 1.0
//   s1 = 2.0
//   s2 = 4.0
//   fadd s0, s0, s1   ; 3.0
//   fadd s0, s0, s1   ; 5.0
//   fsub s0, s0, s1   ; 3.0
//   fmul s0, s0, s2   ; 12.0
//   fmul s0, s0, s2   ; 48.0

.text
.global _start

_start:
    fmov s0, #1.0
    fmov s1, #2.0
    fmov s2, #4.0

    fadd s0, s0, s1
    fadd s0, s0, s1
    fsub s0, s0, s1
    fmul s0, s0, s2
    fmul s0, s0, s2

    mov x3, #0
    brk #0
