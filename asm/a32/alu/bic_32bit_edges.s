/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x7FFFFFFF",
    "R1": "0x12005678",
    "R2": "0x7FFFFFFF",
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
    bic r0, r4, r5

    ldr r4, =0x12345678
    ldr r5, =0x00FF0000
    bic r1, r4, r5

    mvn r2, #0
    mov r5, #1
    bic r2, r2, r5, lsl #31

    ldr r3, =0x0F0F0F0F
    mvn r5, #0
    bic r3, r3, r5

    bkpt #0
