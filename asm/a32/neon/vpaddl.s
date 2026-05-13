/* CONFIG
{
  "Match": "All",
  "RegData": { "Q0": "0x00000002000000020000000200000002" }
}
*/
.text
.global _start
_start:
    @ VPADDL: Pairwise Add Long
    @ VPADDL.S16 Q0, Q0 - pairwise add 16-bit to 32-bit
    mov r0, #1
    vdup.16 q0, r0    @ Q0 = [1,1,1,1,1,1,1,1] as 16-bit
    vpaddl.s16 q0, q0 @ Q0 = [2,2,2,2] as 32-bit
    bkpt #0
