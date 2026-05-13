/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x11111111",
    "R1": "0x22222222",
    "R2": "0x33333333",
    "R3": "0x44444444"
  }
}
*/
.text
.global _start
_start:
    sub sp, sp, #32
    ldr r0, =0x11111111
    ldr r1, =0x22222222
    ldr r2, =0x33333333
    ldr r3, =0x44444444

    add r4, sp, #16
    stmia r4!, {r0-r3}
    mov r0, #0
    mov r1, #0
    mov r2, #0
    mov r3, #0
    sub r4, r4, #16
    ldmia r4, {r0-r3}

    add sp, sp, #32
    bkpt #0
