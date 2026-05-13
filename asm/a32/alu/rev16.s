/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x34127856",
    "R1": "0xBBAADDCC"
  }
}
*/
.text
.global _start
_start:
    // REV16 - Reverse bytes in each halfword
    ldr r0, =0x12345678
    rev16 r0, r0      // r0 = 0x34127856
    
    ldr r1, =0xAABBCCDD
    rev16 r1, r1      // r1 = 0xBBAADDCC
    
    bkpt #0
