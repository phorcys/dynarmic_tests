/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0xfffefffefffefffefffefffefffefffe" }
}
*/
.text
.global _start
_start:
    @ VQSHLU: Saturating Shift Left Unsigned
    @ VQSHLU.S16 Q0, Q0, #1
    mov r0, #0x7FFF
    vdup.16 q0, r0
    vqshlu.s16 q0, q0, #1
    bkpt #0
