/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000078",
    "R1": "0x00000078",
    "R2": "0x12345678",
    "R3": "0x78563412"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    ldr r4, =0x12345678
    str r4, [sp]

    setend le
    ldrb r0, [sp]
    ldr r2, [sp]

    setend be
    ldrb r1, [sp]
    ldr r3, [sp]
    setend le

    add sp, sp, #16
    bkpt #0
