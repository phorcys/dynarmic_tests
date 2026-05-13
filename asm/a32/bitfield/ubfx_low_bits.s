/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000003" }
}
*/
.text
.global _start
_start:
    @ UBFX: low-bit extraction sample
    @ UBFX Rd, Rn, #lsb, #width
    
    ldr r1, =0x12345678
    
    ubfx r0, r1, #4, #4     @ Extract bits [7:4] = 0x7
    
    @ Simpler test
    ldr r1, =0x0000003C     @ bits [5:2] = 1111 = 15
    ubfx r0, r1, #2, #2     @ Extract bits [3:2] = 3
    
    bkpt #0
.ltorg
