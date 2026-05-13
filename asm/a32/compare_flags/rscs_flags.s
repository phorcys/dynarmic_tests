/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0x00000008",
    "R2": "0xFFFFFFFE",
    "R3": "0x00000008",
    "R4": "0x00000000",
    "R5": "0x00000006",
    "R6": "0x80000000",
    "R7": "0x00000009"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r8, #0

    cmp r8, #0
    mov r0, #1
    rscs r0, r0, #0
    mrs r1, cpsr
    lsr r1, r1, #28

    cmp r8, #1
    mov r2, #1
    rscs r2, r2, #0
    mrs r3, cpsr
    lsr r3, r3, #28

    cmp r8, #0
    mov r4, #0
    rscs r4, r4, #0
    mrs r5, cpsr
    lsr r5, r5, #28

    cmp r8, #0
    ldr r6, =0x80000000
    rscs r6, r6, #0
    mrs r7, cpsr
    lsr r7, r7, #28

    bkpt #0
