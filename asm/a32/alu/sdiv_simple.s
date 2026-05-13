/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005" }
}
*/
.text
.global _start
_start:
    @ SDIV: Signed Divide
    
    mov r1, #20
    mov r2, #4
    
    sdiv r0, r1, r2      @ R0 = 20 / 4 = 5
    
    bkpt #0
