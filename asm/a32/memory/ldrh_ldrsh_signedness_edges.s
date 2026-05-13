/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00008001",
    "R1": "0xFFFF8001",
    "R2": "0x00007FFF",
    "R3": "0x00007FFF"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    ldr r4, =0x00008001
    strh r4, [sp]
    ldr r4, =0x00007FFF
    strh r4, [sp, #2]

    ldrh r0, [sp]
    ldrsh r1, [sp]
    ldrh r2, [sp, #2]
    ldrsh r3, [sp, #2]

    add sp, sp, #16
    bkpt #0
