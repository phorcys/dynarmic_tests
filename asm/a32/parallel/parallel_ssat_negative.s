/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0xFFFFFFEC",
    "R1": "0xFFFFFFF0"
  }
}
*/
.text
.global _start
_start:
    // SSAT: Signed saturate to 5 bits (-16 to 15)
    // -20 < -16, should saturate to -16 (0xFFFFFFF0)
    ldr r0, =0xFFFFFFEC   // -20 in two's complement
    ssat r1, #5, r0
    
    bkpt #0
