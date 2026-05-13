/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x20104030" }
}
*/
.text
.global _start
_start:
    @ REV16: Reverse bytes in each halfword
    @ REV16 Rd, Rm
    
    ldr r1, =0x10203040
    
    rev16 r0, r1            @ R0 = 0x20104030
    
    bkpt #0
.ltorg