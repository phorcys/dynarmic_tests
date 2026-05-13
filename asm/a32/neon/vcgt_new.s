/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x00000000000000000000000000000000" }
}
*/
.text
.global _start
_start:
    @ VCGT: Vector Compare Greater Than
    @ VCGT.S16 Q0, Q0, Q1 - set all 1s if Q0 > Q1, else 0
    mov r0, #1
    vdup.16 q0, r0
    mov r0, #2
    vdup.16 q1, r0
    vcgt.s16 q0, q0, q1
    @ Q0 < Q1, so result is all 0s (false)
    bkpt #0
