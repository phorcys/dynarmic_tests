/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000003",
    "R1": "0x0000000C",
    "R2": "0x0000000A",
    "R3": "0x00000005"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r0, #0
    mov r4, #5
    cmp r4, #3
    addgt r0, r0, #1
    addge r0, r0, #2
    addlt r0, r0, #4
    addle r0, r0, #8

    mov r1, #0
    mov r4, #-3
    cmp r4, #5
    addgt r1, r1, #1
    addge r1, r1, #2
    addlt r1, r1, #4
    addle r1, r1, #8

    mov r2, #0
    mvn r4, #0
    cmp r4, r4
    addgt r2, r2, #1
    addge r2, r2, #2
    addlt r2, r2, #4
    addle r2, r2, #8

    mov r3, #0
    ldr r4, =0x7FFFFFFF
    adds r4, r4, #1
    addvs r3, r3, #1
    addvc r3, r3, #2
    addmi r3, r3, #4
    addpl r3, r3, #8

    bkpt #0
