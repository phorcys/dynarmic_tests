/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x7fff7fff7fff7fff7fff7fff7fff7fff" }
}
*/
.text
.global _start
_start:
    @ VQSHL: Saturating Shift Left
    @ VQSHL.S16 Q0, Q0, #1 - shift left 1, saturate
    mov r0, #0x7FFF
    vdup.16 q0, r0    @ Q0 = max positive 16-bit
    vqshl.s16 q0, q0, #1
    @ Result saturates to 0x7FFF (can't shift)
    bkpt #0
