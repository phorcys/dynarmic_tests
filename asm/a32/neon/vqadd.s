/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x00030003000300030003000300030003" }
}
*/
.text
.global _start
_start:
    @ VQADD: Saturating Add
    @ VQADD.S16 Q0, Q0, Q1
    mov r0, #1
    vdup.16 q0, r0
    mov r0, #2
    vdup.16 q1, r0
    vqadd.s16 q0, q0, q1
    @ Q0 = [3,3,3,3,3,3,3,3] as 16-bit
    bkpt #0
