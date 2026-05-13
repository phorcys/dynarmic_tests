/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x000000FF",
    "R1": "0x00008001",
    "R2": "0x00000000",
    "R3": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    mov r4, #0xFF
    strb r4, [sp]
    ldr r4, =0x00008001
    strh r4, [sp, #2]

    mov r5, sp
    ldrexb r0, [r5]
    add r5, sp, #2
    ldrexh r1, [r5]

    add sp, sp, #16
    bkpt #0
