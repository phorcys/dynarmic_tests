/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000008" }
}
*/
.text
.global _start
_start:
    @ LSR immediate: Logical Shift Right
    @ LSR Rd, Rm, #imm
    
    ldr r1, =0x800
    lsr r0, r1, #8       @ R0 = 0x800 >> 8 = 8
    
    bkpt #0
.ltorg
