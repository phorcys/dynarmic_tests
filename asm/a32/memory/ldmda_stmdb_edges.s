/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xAAAAAAAA",
    "R1": "0xBBBBBBBB",
    "R2": "0xCCCCCCCC",
    "R3": "0xDDDDDDDD"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #32
    ldr r0, =0xAAAAAAAA
    ldr r1, =0xBBBBBBBB
    ldr r2, =0xCCCCCCCC
    ldr r3, =0xDDDDDDDD

    add r4, sp, #16
    stmdb r4!, {r0-r3}
    mov r0, #0
    mov r1, #0
    mov r2, #0
    mov r3, #0
    add r4, r4, #12
    ldmda r4, {r0-r3}

    add sp, sp, #32
    bkpt #0
