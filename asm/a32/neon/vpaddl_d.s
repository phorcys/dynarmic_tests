/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x0000000200000002" }
}
*/
.text
.global _start
_start:
    @ VPADDL: Pairwise Add Long
    @ VPADDL.S16 D0, D0 - pairwise add 16-bit to 32-bit
    mov r0, #1
    vdup.16 d0, r0    @ D0 = [1,1,1,1] as 16-bit
    vpaddl.s16 d0, d0 @ D0 = [2,2] as 32-bit
    bkpt #0
