/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x80000000"
  }
}
*/
.text
.global _start
_start:
    // QSUB: Saturating Subtract
    // QSUB R0, R1, R2 - R0 = saturate(R1 - R2)
    // R1 = 0x80000000, R2 = 1 -> saturates to 0x80000000 (most negative)
    ldr r1, =0x80000000
    mov r2, #1
    qsub r0, r1, r2
    bkpt #0
