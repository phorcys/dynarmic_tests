/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000001",
    "R1": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    // MOVW - Move 16-bit immediate to register (zero-extended)
    movw r0, #0x0001  // r0 = 1
    
    movw r1, #0x0000  // r1 = 0
    
    bkpt #0
