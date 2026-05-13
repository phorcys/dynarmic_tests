/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000011" }
}
*/
.text
.global _start
_start:
    @ SXTAB: Sign Extend and Add Byte
    @ SXTAB Rd, Rn, Rm, ROR #n
    @ Rd = Rn + SignExtend(Rm[7:0] rotated by n)
    
    mov r1, #0
    mov r2, #0x11
    
    sxtab r0, r1, r2     @ R0 = 0 + 0x11 = 0x11
    
    bkpt #0