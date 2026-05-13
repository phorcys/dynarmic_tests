/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x01010101010101010002000200020002" }
}
*/
.text
.global _start
_start:
    @ VQRSHR: Saturating Rounding Shift Right
    @ VQRSHRN.S16 D0, Q0, #1
    mov r0, #2
    vdup.16 q0, r0
    vqrshrn.s16 d0, q0, #1
    @ 2 >> 1 = 1, no saturation
    bkpt #0
