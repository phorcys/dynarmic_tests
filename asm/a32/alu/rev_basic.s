/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00010203" }
}
*/
.text
.global _start
_start:
    @ REV: Reverse byte order
    @ REV Rd, Rm
    
    ldr r1, =0x03020100
    
    rev r0, r1           @ R0 = 0x00010203
    
    bkpt #0
.ltorg
