/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00005678",
    "R1": "0x00007856",
    "R2": "0x00001234",
    "R3": "0x00003412"
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
    ldrh r0, [sp]
    ldrh r2, [sp, #2]

    setend be
    ldrh r1, [sp]
    ldrh r3, [sp, #2]
    setend le

    add sp, sp, #16
    bkpt #0
