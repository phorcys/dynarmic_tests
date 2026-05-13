/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000007F",
    "R1": "0xFFFFFF80",
    "R2": "0x000000FF",
    "R3": "0x00000000"
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

    ldr r4, =0x180
    usat r2, #8, r4

    mvn r4, #0            @ -1
    usat r3, #8, r4

    bkpt #0
