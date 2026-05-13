/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000000003" }
}
*/
.text
.global _start
_start:
    @ VBIF - Bitwise Insert if False
    @ VBIF Dd, Dn, Dm: For each bit, if Dm[i] == 0, then Dd[i] = Dn[i]
    mov r0, #3
    mov r1, #0
    vmov d0, r0, r1      @ D0 = 0x0000000000000003 (destination)
    mov r0, #5
    mov r1, #0
    vmov d1, r0, r1      @ D1 = 0x0000000000000005 (source)
    mov r0, #0x0F
    mov r1, #0
    vmov d2, r0, r1      @ D2 = 0x000000000000000F (mask)
    @ VBIF: For bits where mask is 0, copy from D1
    @ Bits 0-3: mask = 1, so D0 stays = 3
    @ Bits 4-7: mask = 0, so D0 = D1 = 0
    @ Result: D0 = 3
    vbif d0, d1, d2
    bkpt #0
.ltorg
