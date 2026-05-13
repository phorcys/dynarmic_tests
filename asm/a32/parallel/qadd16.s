/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x10004000"
  }
}
*/
.text
.global _start
_start:
    // QADD16: Saturating add of two 16-bit pairs
    ldr r0, =0x10003000
    ldr r1, =0x00001000
    qadd16 r0, r0, r1
    
    bkpt #0
