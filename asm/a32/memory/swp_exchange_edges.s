/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0x80000000",
    "R2": "0x000000FF",
    "R3": "0x00000080"
  }
}
*/
.text
.arm
.global _start
_start:
    sub sp, sp, #16

    mvn r4, #0
    str r4, [sp]
    ldr r1, =0x80000000
    swp r0, r1, [sp]

    mov r4, #0xFF
    strb r4, [sp, #4]
    mov r3, #0x80
    add r5, sp, #4
    swpb r2, r3, [r5]

    add sp, sp, #16
    bkpt #0
