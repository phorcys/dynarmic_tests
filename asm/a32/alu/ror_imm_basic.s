/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x80000000" }
}
*/
.text
.global _start
_start:
    @ ROR immediate: Rotate Right
    @ ROR Rd, Rm, #imm
    
    ldr r1, =0x00000001
    ror r0, r1, #1       @ R0 = 0x00000001 ROR 1 = 0x80000000
    
    bkpt #0
.ltorg
