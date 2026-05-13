/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x0000000400000004" }
}
*/
.text
.global _start
_start:
    @ VPADAL: Pairwise Add and Accumulate Long
    @ VPADAL.S16 D0, D0 - pairwise add and accumulate
    mov r0, #1
    vdup.16 d0, r0    @ D0 = [1,1,1,1]
    vpaddl.s16 d0, d0 @ D0 = [2,2]
    mov r0, #1
    vdup.16 d1, r0
    vpaddl.s16 d1, d1 @ D1 = [2,2]
    vpadal.s16 d0, d1 @ D0 = [2,2] + [2,2] = [4,4]
    bkpt #0
