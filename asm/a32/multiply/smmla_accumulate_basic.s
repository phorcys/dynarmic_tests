/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000020" }
}
*/
.text
.global _start
_start:
    @ SMMLA accumulate basic case
    @ SMMLA Rd, Rn, Rm, Ra
    @ Rd = ((Rn * Rm) >> 32) + Ra
    
    mov r1, #0x10000
    lsl r1, r1, #8       @ R1 = 0x1000000 = 16777216
    mov r2, #0x10000
    lsl r2, r2, #8       @ R2 = 0x1000000 = 16777216
    mov r3, #0
    
    smmla r0, r1, r2, r3  @ R0 = (16777216 * 16777216) >> 32 + 0 = 0x100000000000000 >> 32 = 0x1000000
    
    @ Simpler - use values that give nice result
    ldr r1, =0x10000000  @ 268435456
    ldr r2, =0x00000100  @ 256
    mov r3, #0
    
    smmla r0, r1, r2, r3  @ (268435456 * 256) >> 32 = 68719476736 >> 32 = 16
    
    @ With accumulator
    mov r3, #16
    smmla r0, r1, r2, r3  @ 16 + 16 = 32
    
    bkpt #0
.ltorg
