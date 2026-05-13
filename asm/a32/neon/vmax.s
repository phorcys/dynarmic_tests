/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x0000000300000003" }
}
*/
.text
.global _start
_start:
    // VMAX: Maximum
    // D0 = max(D0, D1) element-wise
    mov r0, #2
    mov r1, #3
    vdup.32 d0, r0    @ D0 = [2, 2]
    vdup.32 d1, r1    @ D1 = [3, 3]
    vmax.u32 d0, d0, d1   @ D0 = [3, 3]
    bkpt #0