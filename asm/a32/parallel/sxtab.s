/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x0000FF00",
    "R1": "0xFFFFFF80"
  }
}
*/
.text
.global _start
_start:
    // SXTAB - Sign Extend Byte and Add
    // SXTAB Rd, Rn, Rm, ROR #n
    // Rd = Rn + SignExtend(Rm[7:0])
    
    mov r1, #0xFF00       // Base value
    ldr r2, =0x000000FF   // Byte to sign extend (0xFF -> -1)
    sxtab r0, r1, r2      // r0 = 0xFF00 + SignExtend(0xFF) = 0xFF00 + 0xFFFFFFFF = 0xFEFF (wrapping)
                          // Actually: 0xFF00 + (-1) = 0xFEFF
                          // Let me use a positive case
    
    // Reset and try again
    mov r1, #0xFF00
    ldr r2, =0x00000000   // Clear r2 first
    mov r2, #0x00         // Byte 0x00 -> sign extend -> 0x00000000
    sxtab r0, r1, r2      // r0 = 0xFF00 + 0 = 0xFF00
    
    // Negative case
    ldr r2, =0x00000080   // Byte 0x80 -> sign extend -> 0xFFFFFF80 (-128)
    mov r1, #0            // Clear r1
    sxtab r1, r1, r2      // r1 = 0 + 0xFFFFFF80 = 0xFFFFFF80
    
    bkpt #0
