/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000003", "R1": "0x00000001" }
}
*/
.text
.global _start
_start:
    // ADC: Add with Carry
    // R0 = R0 + R1 + C
    mov r0, #1
    mov r1, #1
    @ Set carry flag
    cmp r2, r2   @ R2 = R2, sets C=1 (no borrow)
    adc r0, r0, r1   @ R0 = 1 + 1 + 1 = 3
    bkpt #0