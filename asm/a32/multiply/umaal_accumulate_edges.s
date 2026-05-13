/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000008",
    "R1": "0x00000000",
    "R2": "0xFFFFFFFE",
    "R3": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    mov r0, #1
    mov r1, #1
    mov r4, #2
    mov r5, #3
    umaal r0, r1, r4, r5    @ 6 + 1 + 1 = 8

    mvn r2, #0
    mov r3, #0
    mvn r4, #0
    mov r5, #1
    umaal r2, r3, r4, r5    @ 0xFFFFFFFF + 0xFFFFFFFF + 0 = 0x1FFFFFFFE -> low=0xFFFFFFFE high=1

    bkpt #0
