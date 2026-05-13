/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000300000003" }
}
*/
.text
.global _start
_start:
    @ VRSRA - Rounding Shift Right and Accumulate
    @ D0 = D0 + round(D1 >> 1)
    mov r0, #1
    mov r1, #1
    vmov d0, r0, r1      @ D0 = 0x0000000100000001
    mov r0, #3
    mov r1, #3
    vmov d1, r0, r1      @ D1 = 0x0000000300000003
    @ VRSRA: D0 += round(D1 >> 1) = 1 + round(1.5) = 1 + 2 = 3
    vrsra.u32 d0, d1, #1
    bkpt #0
.ltorg
