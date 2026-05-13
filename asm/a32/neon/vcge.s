/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0xffffffffffffffffffffffffffffffff" }
}
*/
.text
.global _start
_start:
    @ VCGE: Vector Compare Greater or Equal
    @ VCGE.S16 Q0, Q0, Q1 - set all 1s if Q0 >= Q1, else 0
    mov r0, #2
    vdup.16 q0, r0
    mov r0, #1
    vdup.16 q1, r0
    vcge.s16 q0, q0, q1
    @ Q0 >= Q1, so result is all 1s (true)
    bkpt #0
