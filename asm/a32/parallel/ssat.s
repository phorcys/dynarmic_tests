/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x0000007F",
    "R1": "0x0000007F"
  }
}
*/
.text
.global _start
_start:
    // SSAT - Signed Saturate
    ldr r0, =0x180     // 384 in signed
    ssat r0, #8, r0    // Saturate to 8-bit signed: max = 127
                       // 384 > 127, so result = 127 = 0x7F
    
    ldr r1, =0xFFFFF80 // A value
    ssat r1, #8, r1    // Saturate to 8-bit signed: result = 127 = 0x7F
    
    bkpt #0