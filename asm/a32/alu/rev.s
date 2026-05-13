/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x04030201"
  }
}
*/
.text
.global _start
_start:
    // REV: Reverse bytes
    // 0x01020304 reversed = 0x04030201
    ldr r0, =0x01020304
    rev r0, r0
    
    bkpt #0
.ltorg
