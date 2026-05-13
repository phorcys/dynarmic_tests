/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R2": "0x0000FFFF",
    "R3": "0x00008001",
    "R7": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    ldr r4, =0x00008001
    strh r4, [sp]

    mov r5, sp
    mov r2, #0xFFFF
    strexh r7, r2, [r5]
    ldrh r3, [sp]

    add sp, sp, #16
    bkpt #0
