/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000002" }
}
*/
.text
.global _start
_start:
    @ BIC with immediate
    @ BIC Rd, Rn, #imm
    
    mov r1, #7
    bic r0, r1, #5       @ R0 = 7 & NOT 5 = 7 & 0xFFFFFFFA = 2
    
    bkpt #0
