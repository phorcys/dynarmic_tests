/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00017FFF",
    "R1": "0xFFFF8000"
  }
}
*/
.text
.global _start
_start:
    // SXTAH - Sign Extend Halfword and Add
    // Rd = Rn + SignExtend(Rm[15:0])
    
    mov r1, #0x8000
    ldr r2, =0x0000FFFF   // Halfword 0xFFFF -> sign extend -> 0xFFFFFFFF (-1)
    sxtah r0, r1, r2      // r0 = 0x8000 + (-1) = 0x7FFF
                          // Actually let me use simpler test
    
    mov r1, #0x8000
    ldr r2, =0x0000FFFF
    add r0, r1, r2, lsl #0  // Let's just test with positive
    // Actually the expected value is wrong. Let me fix.
    
    mov r1, #0            // Clear
    ldr r2, =0x00007FFF   // Positive halfword
    sxtah r0, r1, r2      // r0 = 0 + 0x7FFF = 0x7FFF
    
    // Now with add
    mov r1, #0x10000
    sxtah r0, r1, r2      // r0 = 0x10000 + 0x7FFF = 0x17FFF
    
    // Negative case
    mov r1, #0
    ldr r2, =0x00008000   // Halfword 0x8000 -> sign extend -> 0xFFFF8000
    sxtah r1, r1, r2      // r1 = 0 + 0xFFFF8000 = 0xFFFF8000
    
    bkpt #0
