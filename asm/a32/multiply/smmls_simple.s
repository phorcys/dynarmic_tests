/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFF000002" }
}
*/
.text
.global _start
_start:
    @ SMMLS: Signed Most Significant Word Multiply Subtract
    @ SMMLS Rd, Rn, Rm, Ra
    @ Rd = ((Ra << 32) - Rn * Rm) >> 32
    
    ldr r1, =0x10000000
    ldr r2, =0x10000000
    ldr r3, =0x00000002
    
    smmls r0, r1, r2, r3    @ R0 = (2 << 32 - 0x0100000000000000) >> 32
                            @ = (0x200000000 - 0x100000000) >> 32
                            @ = 0x100000000 >> 32 = 0x1
                            @ Actually with signed, might be different
    
    bkpt #0
.ltorg