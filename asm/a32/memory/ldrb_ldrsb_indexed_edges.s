/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFF80",
    "R1": "0x00000080",
    "R2": "0xFFFFFF80",
    "R3": "0x0000007F"
  }
}
*/
// Signed and unsigned byte loads with pre/post indexing.

.text
.arm
.global _start
_start:
    sub sp, sp, #16

    mov r4, #0x80
    strb r4, [sp, #4]
    mov r4, #0x7F
    strb r4, [sp, #5]

    mov r5, sp
    ldrsb r0, [r5, #4]!

    mov r6, sp
    ldrb r1, [r6, #4]!

    add r7, sp, #4
    ldrsb r2, [r7], #1

    ldrb r3, [r7]

    add sp, sp, #16
    bkpt #0
