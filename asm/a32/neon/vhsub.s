/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x00010001000100010001000100010001" }
}
*/
.text
.global _start
_start:
    @ VHSUB: Halving Subtract
    @ VHSUB.S16 Q0, Q0, Q1 - (R0 - R1) >> 1
    mov r0, #2
    vdup.16 q0, r0
    mov r0, #1
    vdup.16 q1, r0
    vhsub.s16 q0, q0, q1
    @ Q0 = [(2-1)>>1] = [0,0,...] but let's use different values
    mov r0, #3
    vdup.16 q0, r0
    vhsub.s16 q0, q0, q1
    @ Q0 = [(3-1)>>1] = [1,1,...]
    bkpt #0
