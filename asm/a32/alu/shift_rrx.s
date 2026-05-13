/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x80000001" }
}
*/
.text
.global _start
_start:
    // RRX: Rotate Right with Extend
    // RRX rotates right by 1 bit, inserting the carry flag into bit 31
    ldr r0, =0x00000003
    mov r1, #1
    @ Set carry flag
    cmp r1, #0   @ 1 - 0 = 1, C=1 (no borrow)
    rrx r0, r0   @ Rotate right with extend: C || R0[31:1]
                 @ = 1 || 0000...0001 = 0x80000001
    bkpt #0

.pool
