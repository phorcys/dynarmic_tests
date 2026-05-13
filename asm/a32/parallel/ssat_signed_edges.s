/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000007F",
    "R1": "0xFFFFFF80",
    "R2": "0x0000003F",
    "R3": "0xFFFFFFC0"
  }
}
*/
.text
.global _start
_start:
    mov r4, #127
    ssat r0, #8, r4

    mvn r4, #127          @ -128
    ssat r1, #8, r4

    mov r4, #100
    ssat r2, #7, r4

    mvn r4, #99           @ -100
    ssat r3, #7, r4

    bkpt #0
