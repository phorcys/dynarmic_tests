/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000000",
    "R1": "0x00000006",
    "R2": "0xFFFFFFFF",
    "R3": "0x00000008",
    "R4": "0x80000000",
    "R5": "0x00000009",
    "R6": "0x00000009",
    "R7": "0x00000002"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r0, #0
    rsbs r0, r0, #0
    mrs r1, cpsr
    lsr r1, r1, #28

    mov r2, #1
    rsbs r2, r2, #0
    mrs r3, cpsr
    lsr r3, r3, #28

    ldr r4, =0x80000000
    rsbs r4, r4, #0
    mrs r5, cpsr
    lsr r5, r5, #28

    mov r6, #3
    rsbs r6, r6, r6, lsl #2
    mrs r7, cpsr
    lsr r7, r7, #28

    bkpt #0
