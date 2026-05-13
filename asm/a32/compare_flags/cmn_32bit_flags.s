/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000006",
    "R1": "0x00000009",
    "R2": "0x00000007",
    "R3": "0x00000008"
  }
}
*/
.text
.arm
.global _start
_start:
    mvn r4, #0
    cmn r4, #1
    mrs r0, cpsr
    lsr r0, r0, #28

    ldr r4, =0x7FFFFFFF
    cmn r4, #1
    mrs r1, cpsr
    lsr r1, r1, #28

    ldr r4, =0x80000000
    cmn r4, r4
    mrs r2, cpsr
    lsr r2, r2, #28

    mov r4, #1
    cmn r4, r4, lsl #31
    mrs r3, cpsr
    lsr r3, r3, #28

    bkpt #0
