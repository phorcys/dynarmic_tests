/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0xF0F00000",
    "R1": "0x78563412"
  }
}
*/
.text
.global _start
_start:
    // REV - Reverse bytes in word
    ldr r0, =0x0000F0F0
    rev r0, r0        // r0 = 0xF0F00000
    
    ldr r1, =0x12345678
    rev r1, r1        // r1 = 0x78563412
    
    bkpt #0
