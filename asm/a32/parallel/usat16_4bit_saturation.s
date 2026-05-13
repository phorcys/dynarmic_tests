/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x000F0000"
  }
}
*/
.text
.global _start
_start:
    // USAT16 4-bit saturation sample
    ldr r0, =0x0020FFE0
    usat16 r0, #4, r0
    
    bkpt #0
