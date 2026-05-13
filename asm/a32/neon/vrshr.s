/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x00020002000200020002000200020002" }
}
*/
.text
.global _start
_start:
    @ VRSHR: Rounding Shift Right
    @ VRSHR.S16 Q0, Q0, #1
    mov r0, #3
    vdup.16 q0, r0
    vrshr.s16 q0, q0, #1
    @ (3 + 1) >> 1 = 2
    bkpt #0
