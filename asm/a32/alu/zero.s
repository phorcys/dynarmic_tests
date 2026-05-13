/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000015", "R1": "0x00000000", "R2": "0x00000000" }
}
*/
.text
.global _start
_start:
    mov r0, #21
    mov r1, #0
    
    // R2 = 21 / 0 = 0 (division by zero returns 0)
    sdiv r2, r0, r1
    
    bkpt #0
