/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x000000FF",
    "R1": "0x000000FF"
  }
}
*/
.text
.global _start
_start:
    // USAT - Unsigned Saturate
    ldr r0, =0x180     // 384
    usat r0, #8, r0    // Saturate to 8-bit unsigned: max = 255
                       // 384 > 255, so result = 255 = 0xFF
    
    ldr r1, =0x100     // 256
    usat r1, #8, r1    // Saturate to 8-bit unsigned: max = 255
                       // 256 > 255, so result = 255 = 0xFF
    
    bkpt #0
