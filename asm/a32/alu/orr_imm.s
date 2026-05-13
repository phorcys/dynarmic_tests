/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000007" }
}
*/
.text
.global _start
_start:
    @ ORR with immediate
    @ ORR Rd, Rn, #imm
    
    mov r1, #5
    orr r0, r1, #2       @ R0 = 5 | 2 = 7
    
    bkpt #0
