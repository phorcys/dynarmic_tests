/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x80000000",
    "R1": "0x12345678",
    "R2": "0x80000001",
    "R3": "0xFFFFFFFF"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r0, #0
    ldr r4, =0x80000000
    orr r0, r0, r4

    ldr r4, =0x12340000
    ldr r5, =0x00005678
    orr r1, r4, r5

    mov r2, #1
    orr r2, r2, r2, lsl #31

    ldr r4, =0xF0F0F0F0
    ldr r5, =0x0F0F0F0F
    orr r3, r4, r5

    bkpt #0
