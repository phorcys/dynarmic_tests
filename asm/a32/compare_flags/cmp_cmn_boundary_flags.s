/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000006",
    "R1": "0x00000008",
    "R2": "0x00000003",
    "R3": "0x00000009"
  }
}
*/
// Boundary NZCV checks for CMP/CMN.

.text
.arm
.global _start
_start:
    mov r4, #0

    @ CMP 0, 0 => Z=1, C=1
    cmp r4, #0
    mrs r0, cpsr
    lsr r0, r0, #28

    @ CMP 0, 1 => N=1, C=0
    cmp r4, #1
    mrs r1, cpsr
    lsr r1, r1, #28

    @ CMP 0x80000000, 1 => overflow, C=1
    ldr r5, =0x80000000
    cmp r5, #1
    mrs r2, cpsr
    lsr r2, r2, #28

    @ CMN 0x7fffffff, 1 => negative overflow
    ldr r5, =0x7FFFFFFF
    cmn r5, #1
    mrs r3, cpsr
    lsr r3, r3, #28

    bkpt #0
