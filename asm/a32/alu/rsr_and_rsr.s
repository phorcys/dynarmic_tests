/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x000000FF"
  }
}
*/
.text
.arm
.global _start
_start:
    @ AND with register-shifted register
    @ AND Rd, Rn, Rm, LSR Rs
    mov r1, #0xFF
    mov r3, #0xFF0
    mov r2, #4
    @ 0xFF0 >> 4 = 0xFF
    @ 0xFF & 0xFF = 0xFF
    and r0, r1, r3, lsr r2
    bkpt #0
