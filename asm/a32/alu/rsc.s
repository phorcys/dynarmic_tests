/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000002", "R1": "0x00000003" }
}
*/
.text
.global _start
_start:
    // RSC: Reverse Subtract with Carry
    // R0 = R1 - R0 - !C
    mov r0, #1
    mov r1, #3
    @ Set carry flag (C=1)
    cmp r2, r2   @ R2 = R2, sets C=1 (no borrow)
    rsc r0, r0, r1   @ R0 = 3 - 1 - 0 = 2 (since C=1, !C=0)
    bkpt #0
