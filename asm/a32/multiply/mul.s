/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000018",
    "R1": "0x00000006",
    "R2": "0x00000004"
  }
}
*/
.text
.global _start
_start:
    // MUL R0, R1, R2  -> R0 = R1 * R2
    mov r1, #6
    mov r2, #4
    mul r0, r1, r2    // R0 = 6 * 4 = 24
    
    bkpt #0
