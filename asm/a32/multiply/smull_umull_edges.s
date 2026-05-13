/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0x00000001",
    "R2": "0xFFFFFFFE",
    "R3": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x00010000
    ldr r5, =0x00010000
    smull r0, r1, r4, r5

    mvn r4, #0
    mov r5, #2
    umull r2, r3, r4, r5   @ 0xFFFFFFFF * 2 = 0x1FFFFFFFE

    bkpt #0
