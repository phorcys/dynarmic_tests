/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x00010001000100010001000100010001" }
}
*/
.text
.global _start
_start:
    @ VRHADD: Rounding Halving Add
    @ VRHADD.S16 Q0, Q0, Q1 - (R0 + R1 + 1) >> 1
    mov r0, #1
    vdup.16 q0, r0
    mov r0, #1
    vdup.16 q1, r0
    vrhadd.s16 q0, q0, q1
    @ Q0 = [(1+1+1)>>1] = [1,1,1,1,...] as 16-bit
    bkpt #0
