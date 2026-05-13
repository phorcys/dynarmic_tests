/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x000F000F"
  }
}
*/
.text
.global _start
_start:
    // SSAT16: Saturate two 16-bit halves to 5-bit signed range (-16 to 15)
    ldr r0, =0x00200040
    ssat16 r0, #5, r0
    
    bkpt #0
