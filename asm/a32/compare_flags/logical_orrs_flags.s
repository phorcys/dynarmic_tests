/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R2": "0x000000FF",
    "R1": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    @ ORRS - ORR and update flags
    mov r0, #0xF0
    mov r1, #0x0F
    orrs r2, r0, r1      @ r2 = 0xFF, Z=0, N=0

    @ Test zero flag with zero result
    mov r0, #0
    orrs r1, r0, #0      @ r1 = 0, Z=1

    bkpt #0