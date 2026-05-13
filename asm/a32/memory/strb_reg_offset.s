/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000078" }
}
*/
.text
.global _start
_start:
    @ STRB with register offset
    @ STRB Rd, [Rn, Rm]
    
    sub sp, sp, #16
    
    ldr r0, =0x12345678
    mov r1, sp
    mov r2, #0
    strb r0, [r1, r2]    @ mem[sp] = 0x78
    
    ldrb r0, [sp]        @ R0 = 0x78
    
    add sp, sp, #16
    bkpt #0
.ltorg
