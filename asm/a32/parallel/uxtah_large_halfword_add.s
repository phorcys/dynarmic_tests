/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x10001111" }
}
*/
.text
.global _start
_start:
    @ UXTAH large-add basic sample
    @ UXTAH Rd, Rn, Rm
    @ Rd = Rn + ZeroExtend(Rm[15:0])
    
    mov r1, #0x10000000
    ldr r2, =0x00001111
    
    uxtah r0, r1, r2     @ R0 = 0x10000000 + 0x1111 = 0x10001111
    
    bkpt #0
.ltorg
