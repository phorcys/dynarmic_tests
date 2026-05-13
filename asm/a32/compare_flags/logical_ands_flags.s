/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R2": "0x0000000F",
    "R1": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    @ ANDS - AND and update flags
    mov r0, #0xFF
    mov r1, #0x0F
    ands r2, r0, r1      @ r2 = 0x0F, Z=0, N=0

    @ Test zero flag
    mov r0, #0
    ands r1, r0, #0      @ r1 = 0, Z=1

    bkpt #0
