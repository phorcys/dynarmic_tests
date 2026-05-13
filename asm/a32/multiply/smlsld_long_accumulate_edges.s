/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000014",
    "R1": "0x00000000",
    "R2": "0xFFFFFFFE",
    "R3": "0xFFFFFFFF"
  }
}
*/
.text
.global _start
_start:
    mov r0, #20
    mov r1, #0
    ldr r4, =0x00010002
    ldr r5, =0x00020001
    smlsld r0, r1, r4, r5

    mvn r2, #0
    mvn r3, #0
    ldr r4, =0x00010000
    ldr r5, =0x00010002
    smlsld r2, r3, r4, r5

    bkpt #0
