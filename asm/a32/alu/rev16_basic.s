/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0201FFFE" }
}
*/
.text
.global _start
_start:
    @ REV16: Reverse bytes in each halfword
    @ REV16 Rd, Rm
    
    ldr r1, =0x0102FEFF
    
    rev16 r0, r1         @ R0 = 0x0201FFFE
    
    bkpt #0
.ltorg
