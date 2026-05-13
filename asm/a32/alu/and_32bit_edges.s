/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x80000000",
    "R1": "0x00340000",
    "R2": "0x00000000",
    "R3": "0x00000000"
  }
}
*/
.text
.arm
.global _start
_start:
    mvn r4, #0
    ldr r5, =0x80000000
    and r0, r4, r5

    ldr r4, =0x12345678
    ldr r5, =0x00FF0000
    and r1, r4, r5

    ldr r2, =0xF0F0F0F0
    and r2, r2, r2, lsr #4

    mov r3, #0
    and r3, r3, r4

    bkpt #0
