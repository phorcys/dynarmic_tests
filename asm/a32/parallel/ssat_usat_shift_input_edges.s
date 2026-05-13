/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000003F",
    "R1": "0xFFFFFFFF",
    "R2": "0x000000FF",
    "R3": "0x0000000F"
  }
}
*/
.text
.global _start
_start:
    ldr r4, =0x000003FC
    ssat r0, #7, r4, asr #4

    mvn r4, #0
    lsl r4, r4, #4
    ssat r1, #5, r4, asr #4

    ldr r4, =0x00000FF0
    usat r2, #8, r4, asr #4

    mov r4, #1
    usat r3, #4, r4, lsl #8

    bkpt #0
