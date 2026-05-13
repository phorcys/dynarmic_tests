/* CONFIG
{
  "Match": "All",
  "VecData": { "D0": "0x0000000000000003" }
}
*/
.text
.global _start
_start:
    @ VBSL - Bitwise Select
    @ D0 = (D0 & D1) | (~D0 & D2)
    @ Set up mask in D0
    mov r0, #0x0F
    mov r1, #0
    vmov d0, r0, r1      @ D0 = 0x000000000000000F (mask)
    @ Set up D1 and D2
    mov r0, #3
    mov r1, #0
    vmov d1, r0, r1      @ D1 = 0x0000000000000003
    mov r0, #5
    mov r1, #0
    vmov d2, r0, r1      @ D2 = 0x0000000000000005
    @ VBSL: D0 = (D0 & D1) | (~D0 & D2)
    @ = (0x0F & 3) | (~0x0F & 5)
    @ = 3 | (0xF0 & 5)
    @ = 3 | 0
    @ = 3
    vbsl d0, d1, d2
    bkpt #0
.ltorg
