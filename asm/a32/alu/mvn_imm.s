/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFFC" }
}
*/
.text
.global _start
_start:
    @ AND with immediate
    @ AND Rd, Rn, #imm
    
    ldr r1, =0xFFFFFFFF
    and r0, r1, #0xFC    @ R0 = 0xFFFFFFFF & 0xFC = 0xFC
    
    @ Actually test MVN
    mvn r0, #3           @ R0 = NOT 3 = 0xFFFFFFFC
    
    bkpt #0
.ltorg
