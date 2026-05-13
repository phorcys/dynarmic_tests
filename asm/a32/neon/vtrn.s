/* CONFIG
{
  "Match": "All",
  "RegData": { "D0": "0x0002000100020001" }
}
*/
.text
.global _start
_start:
    @ VTRN: Transpose elements
    @ VTRN.16 D0, D1
    mov r0, #1
    vdup.16 d0, r0    @ D0 = [1,1,1,1]
    mov r0, #2
    vdup.16 d1, r0    @ D1 = [2,2,2,2]
    vtrn.16 d0, d1
    @ Result: D0 = [1,2,1,2], D1 = [1,2,1,2]
    @ But we want to verify, so use simpler test
    vmov.i16 d0, #1
    vmov.i16 d1, #2
    vtrn.16 d0, d1
    @ D0 = [1,2,1,2] = 0x0002000100020001
    @ D1 = [1,2,1,2]
    bkpt #0
