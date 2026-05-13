/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000010" }
}
*/
.text
.global _start
_start:
    @ SMMLS subtract basic case
    @ SMMLS Rd, Rn, Rm, Ra
    @ Rd = Ra - ((Rn * Rm) >> 32)
    
    ldr r1, =0x10000000  @ 268435456
    ldr r2, =0x00000100  @ 256
    mov r3, #32          @ Ra = 32
    
    smmls r0, r1, r2, r3  @ R0 = 32 - (268435456 * 256) >> 32 = 32 - 16 = 16
    
    bkpt #0
.ltorg
