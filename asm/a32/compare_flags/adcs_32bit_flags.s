/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0x00000006",
    "R2": "0x7FFFFFFF",
    "R3": "0x00000000",
    "R4": "0x80000000",
    "R5": "0x00000009",
    "R6": "0xFFFFFFFF",
    "R7": "0x0000000A"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r8, #0

    cmp r8, #0
    mvn r0, #0
    adcs r0, r0, #0
    mrs r1, cpsr
    lsr r1, r1, #28

    cmp r8, #1
    ldr r2, =0x7FFFFFFF
    adcs r2, r2, #0
    mrs r3, cpsr
    lsr r3, r3, #28

    cmp r8, #0
    ldr r4, =0x7FFFFFFF
    adcs r4, r4, #0
    mrs r5, cpsr
    lsr r5, r5, #28

    cmp r8, #0
    mvn r6, #0
    adcs r6, r6, r6
    mrs r7, cpsr
    lsr r7, r7, #28

    bkpt #0
