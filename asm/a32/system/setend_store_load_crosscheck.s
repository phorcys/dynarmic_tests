/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x44332211",
    "R1": "0x11223344",
    "R2": "0x00000011",
    "R3": "0x00000011"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    ldr r4, =0x11223344

    setend be
    str r4, [sp]

    setend le
    ldr r0, [sp]
    ldrb r2, [sp]

    setend be
    ldr r1, [sp]
    ldrb r3, [sp]
    setend le

    add sp, sp, #16
    bkpt #0
