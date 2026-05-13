/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001",
    "R1": "0x00001234"
  }
}
*/
.text
.arm
.global _start
_start:
    sub sp, sp, #16
    mov r0, #0x1234
    strh r0, [sp]
    ldrh r1, [sp]

    mov r0, #1
    strh r0, [sp, #2]
    ldrh r0, [sp, #2]
    add sp, sp, #16
    bkpt #0
