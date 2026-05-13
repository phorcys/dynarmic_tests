/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x10000011" }
}
*/
.text
.global _start
_start:
    @ UXTAB large-add basic sample
    @ UXTAB Rd, Rn, Rm, ROR #n
    @ Rd = Rn + ZeroExtend(Rm[7:0] rotated by n)
    
    mov r1, #0x10000000
    ldr r2, =0xFFFFFF11  @ byte 0x11, zero extended = 0x11
    
    uxtab r0, r1, r2     @ R0 = 0x10000000 + 0x11 = 0x10000011
    
    bkpt #0
.ltorg
