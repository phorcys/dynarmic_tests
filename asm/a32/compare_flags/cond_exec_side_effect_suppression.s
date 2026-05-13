/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xAAAAAAAA",
    "R1": "0x22222222",
    "R2": "0x00000011",
    "R3": "0x00000033",
    "R4": "0x00000000",
    "R5": "0x00000044"
  }
}
*/
// Conditional execution must suppress register and memory side effects when false.

.text
.arm
.global _start
_start:
    sub sp, sp, #16

    ldr r6, =0x11111111
    ldr r7, =0x22222222
    str r6, [sp]
    str r7, [sp, #4]

    mov r4, #0
    cmp r4, #0

    @ EQ true: store executes.
    ldreq r0, =0xAAAAAAAA
    streq r0, [sp]

    @ NE false: store suppressed.
    ldrne r0, =0xBBBBBBBB
    strne r0, [sp, #4]

    ldr r0, [sp]
    ldr r1, [sp, #4]

    mov r2, #0x11
    cmp r4, #0
    addne r2, r2, #0x10      @ suppressed

    mov r3, #0x33
    cmp r4, #1
    addeq r3, r3, #0x10      @ suppressed because Z=0

    mov r5, #0x40
    cmp r4, #0
    addeq r5, r5, #4         @ executed

    add sp, sp, #16
    bkpt #0
