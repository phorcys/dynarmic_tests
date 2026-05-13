/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x78563412",
    "R1": "0x00000078",
    "R2": "0x00000078",
    "R3": "0x12345678"
  }
}
*/
// A32-only SETEND endianness toggle cross-check.

.text
.arm
.global _start
_start:
    sub sp, sp, #16
    ldr r4, =0x12345678
    str r4, [sp]

    setend be
    ldr r0, [sp]
    ldrb r1, [sp]

    setend le
    ldrb r2, [sp]
    ldr r3, [sp]

    add sp, sp, #16
    bkpt #0
