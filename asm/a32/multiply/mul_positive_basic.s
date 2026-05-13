/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000001C" }
}
*/
.text
.global _start
_start:
    @ MUL positive basic sample
    @ MUL Rd, Rn, Rm
    
    mov r1, #7
    mov r2, #4
    
    mul r0, r1, r2       @ R0 = 7 * 4 = 28 = 0x1C
    
    bkpt #0
