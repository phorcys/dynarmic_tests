/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000002", "R1": "0x00000001" }
}
*/
.text
.global _start
_start:
    // SBC: Subtract with Carry
    // R0 = R0 - R1 - !C
    mov r0, #3
    mov r1, #1
    @ Set carry flag (C=1)
    cmp r2, r2   @ R2 = R2, sets C=1 (no borrow)
    sbc r0, r0, r1   @ R0 = 3 - 1 - 0 = 2 (since C=1, !C=0)
    bkpt #0
