/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000000005" }
}
*/
.text
.global _start
_start:
    @ VBIT - Bitwise Insert if True
    @ VBIT Dd, Dn, Dm: For each bit, if Dm[i] == 1, then Dd[i] = Dn[i]
    mov r0, #3
    mov r1, #0
    vmov d0, r0, r1      @ D0 = 0x0000000000000003 (destination)
    mov r0, #5
    mov r1, #0
    vmov d1, r0, r1      @ D1 = 0x0000000000000005 (source)
    mov r0, #0xFF
    mov r1, #0
    vmov d2, r0, r1      @ D2 = 0x00000000000000FF (mask, all 1s in low byte)
    @ VBIT: D0 = D1 (because mask is all 1s in low byte)
    vbit d0, d1, d2
    bkpt #0
.ltorg
