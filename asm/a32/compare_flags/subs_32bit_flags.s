/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0xFFFFFFFF",
    "R1": "0x00000008",
    "R2": "0x7FFFFFFF",
    "R3": "0x00000003",
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
    mov r0, #0
    subs r0, r0, #1
    mrs r1, cpsr
    lsr r1, r1, #28

    ldr r2, =0x80000000
    subs r2, r2, #1
    mrs r3, cpsr
    lsr r3, r3, #28

    mov r4, #1
    subs r4, r4, #1
    mrs r5, cpsr
    lsr r5, r5, #28

    ldr r6, =0x7FFFFFFF
    mvn r7, #0
    subs r6, r6, r7
    mrs r7, cpsr
    lsr r7, r7, #28

    bkpt #0
