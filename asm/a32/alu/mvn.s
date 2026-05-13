/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0xFFFFFFFF",
    "R1": "0x00000000",
    "R2": "0xFFFFFFFE"
  }
}
*/
.text
.global _start
_start:
    // MVN R0, R1  -> R0 = ~R1
    mov r1, #0
    mvn r0, r1        // R0 = ~0 = 0xFFFFFFFF
    
    // MVN with immediate
    mvn r2, #1         // R2 = ~1 = 0xFFFFFFFE
    
    bkpt #0
