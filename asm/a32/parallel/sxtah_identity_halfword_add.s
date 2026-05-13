/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00001111" }
}
*/
.text
.global _start
_start:
    @ SXTAH: Sign Extend and Add Halfword
    @ SXTAH Rd, Rn, Rm, ROR #n
    @ Rd = Rn + SignExtend(Rm[15:0] rotated by n)
    
    mov r1, #0
    ldr r2, =0x00001111
    
    sxtah r0, r1, r2     @ R0 = 0 + 0x1111 = 0x1111
    
    bkpt #0
.ltorg