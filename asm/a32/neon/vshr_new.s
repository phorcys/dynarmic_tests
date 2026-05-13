/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x00010001000100010001000100010001" }
}
*/
.text
.global _start
_start:
    @ VSHR: Vector Shift Right
    @ VSHR.S16 Q0, Q0, #1
    mov r0, #2
    vdup.16 q0, r0
    vshr.s16 q0, q0, #1
    @ 2 >> 1 = 1
    bkpt #0
