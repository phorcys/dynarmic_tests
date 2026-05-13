/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000001" }
}
*/
.text
.global _start
_start:
    @ BLT: Branch if Less Than (N != V)
    
    mov r0, #0
    
    mov r1, #5
    mov r2, #10
    cmp r1, r2           @ 5 < 10, N=1 (signed comparison)
    blt less
    mov r0, #10          @ Not executed
    
less:
    mov r0, #1           @ R0 = 1
    
    bkpt #0
