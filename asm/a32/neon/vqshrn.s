/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x01010101010101010002000200020002" }
}
*/
.text
.global _start
_start:
    @ VQSHRN: Saturating Shift Right Narrow
    @ VQSHRN.S16 D0, Q0, #1
    mov r0, #2
    vdup.16 q0, r0
    vqshrn.s16 d0, q0, #1
    @ 2 >> 1 = 1
    bkpt #0
