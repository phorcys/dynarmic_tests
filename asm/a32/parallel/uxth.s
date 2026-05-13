/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x0000ffff",
    "R1": "0x00005678"
  }
}
*/
.text
.global _start
_start:
    @ UXTH: Unsigned extend halfword
    mov r0, #0
    mvn r0, r0      @ r0 = 0xFFFFFFFF
    uxth r0, r0     @ r0 = 0x0000FFFF
    
    movw r1, #0x5678
    uxth r1, r1     @ r1 = 0x5678 (unchanged)
    bkpt #0
