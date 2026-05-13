/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFFFF", "R1": "0x00000010", "R2": "0x0FFFFFFF" }
}
*/
.text
.global _start
_start:
    mvn r0, #0           // R0 = 0xFFFFFFFF
    mov r1, #16
    
    // R2 = 0xFFFFFFFF / 16 = 0x0FFFFFFF
    udiv r2, r0, r1
    
    bkpt #0
