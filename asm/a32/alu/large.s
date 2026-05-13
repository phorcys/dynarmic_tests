/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000015", "R1": "0x00000004", "R2": "0x00000005" }
}
*/
.text
.global _start
_start:
    mov r0, #21
    mov r1, #4
    
    // R2 = 21 / 4 = 5 (truncated towards zero)
    udiv r2, r0, r1
    
    bkpt #0
