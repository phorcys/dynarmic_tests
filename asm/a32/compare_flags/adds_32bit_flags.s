/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0x00000006",
    "R2": "0x80000000",
    "R3": "0x00000009",
    "R4": "0x00000000",
    "R5": "0x00000007",
    "R6": "0x00000000",
    "R7": "0x00000006"
  }
}
*/
.text
.arm
.global _start
_start:
    mvn r0, #0
    adds r0, r0, #1
    mrs r1, cpsr
    lsr r1, r1, #28

    ldr r2, =0x7FFFFFFF
    adds r2, r2, #1
    mrs r3, cpsr
    lsr r3, r3, #28

    ldr r4, =0x80000000
    adds r4, r4, r4
    mrs r5, cpsr
    lsr r5, r5, #28

    mov r6, #1
    mvn r7, #0
    adds r6, r6, r7
    mrs r7, cpsr
    lsr r7, r7, #28

    bkpt #0
