/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000008",
    "R1": "0x00000006",
    "R2": "0x00000002",
    "R3": "0x00000004"
  }
}
*/
.text
.arm
.global _start
_start:
    mov r4, #0

    cmp r4, #1
    ldr r5, =0x80000000
    tst r5, r5
    mrs r0, cpsr
    lsr r0, r0, #28

    cmp r4, #0
    mov r5, #0
    tst r5, #0xFF
    mrs r1, cpsr
    lsr r1, r1, #28

    cmp r4, #0
    mov r5, #3
    tst r5, r5, lsr #1
    mrs r2, cpsr
    lsr r2, r2, #28

    cmp r4, #1
    ldr r5, =0x40000000
    tst r5, r5, lsl #1
    mrs r3, cpsr
    lsr r3, r3, #28

    bkpt #0
