/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005" }
}
*/
.text
.global _start
_start:
    @ EOR with immediate
    @ EOR Rd, Rn, #imm
    
    mov r1, #7
    eor r0, r1, #2       @ R0 = 7 ^ 2 = 5
    
    bkpt #0
