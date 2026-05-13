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
    ldr r0, =0x11111111
    ldr r1, =0x22222222
    ldr r2, =0x33333333
    ldr r3, =0x44444444

    push {r0-r3}
    mov r0, #0
    mov r1, #0
    mov r2, #0
    mov r3, #0
    pop {r0-r3}

    bkpt #0
