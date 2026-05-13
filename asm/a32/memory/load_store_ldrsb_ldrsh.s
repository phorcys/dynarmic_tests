/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFF80", "R1": "0xFFFFFFF0", "R2": "0x0000007F" }
}
*/
.text
.global _start
_start:
    // LDRSB/LDRSH: Load Signed Byte/Halfword
    sub sp, sp, #8

    @ Store signed bytes/halfwords
    mov r3, #0x80      @ 0x80 = 128 unsigned, or -128 signed
    strb r3, [sp, #0]

    ldr r3, =0xFFF0    @ -16 as signed halfword
    strh r3, [sp, #2]

    mov r3, #0x7F      @ 127
    strb r3, [sp, #4]

    @ Load signed
    ldrsb r0, [sp, #0]   @ R0 = -128 = 0xFFFFFF80 (sign extended)
    ldrsh r1, [sp, #2]   @ R1 = -16 = 0xFFFFFFF0 (sign extended)
    ldrsb r2, [sp, #4]   @ R2 = 127 = 0x0000007F (sign extended)

    bkpt #0

.pool
