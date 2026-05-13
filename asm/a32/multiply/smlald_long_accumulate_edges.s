/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000006",
    "R1": "0x00000000",
    "R2": "0x00000000",
    "R3": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    mov r0, #1
    mov r1, #0
    ldr r4, =0x00020003
    ldr r5, =0x00010001
    smlald r0, r1, r4, r5

    mvn r2, #0
    mvn r3, #0
    ldr r4, =0x00010000
    ldr r5, =0x00010001
    smlald r2, r3, r4, r5

    bkpt #0
