/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000200000002" }
}
*/
.text
.global _start
_start:
    @ VSRA - Shift Right and Accumulate
    @ D0 = D0 + (D1 >> 1)
    mov r0, #1
    mov r1, #1
    vmov d0, r0, r1      @ D0 = 0x0000000100000001
    mov r0, #2
    mov r1, #2
    vmov d1, r0, r1      @ D1 = 0x0000000200000002
    @ VSRA: D0 += D1 >> 1 = 1 + 1 = 2 per element (u32)
    vsra.u32 d0, d1, #1
    bkpt #0
.ltorg
