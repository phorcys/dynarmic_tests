/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x04030201" }
}
*/
.text
.global _start
_start:
    @ REV: Reverse bytes in word
    @ REV Rd, Rm
    
    ldr r1, =0x01020304
    
    rev r0, r1              @ R0 = 0x04030201
    
    bkpt #0
.ltorg