/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xC0000003" }
}
*/
.text
.global _start
_start:
    @ ROR immediate: Rotate Right
    @ ROR Rd, Rm, #imm
    
    ldr r1, =0xF000000F
    ror r0, r1, #4       @ R0 = rotate_right(0xF000000F, 4) = 0xFF000000
    
    @ Simpler example
    ldr r1, =0x0000000F
    ror r0, r1, #2       @ R0 = rotate_right(0x0F, 2) = 0xC0000003
    
    bkpt #0
.ltorg
