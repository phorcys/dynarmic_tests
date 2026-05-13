/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000078" }
}
*/
.text
.global _start
_start:
    @ LDRB with register offset
    @ LDRB Rd, [Rn, Rm]
    
    sub sp, sp, #16
    ldr r2, =0x12345678
    str r2, [sp]
    
    mov r1, sp
    mov r2, #0
    ldrb r0, [r1, r2]    @ R0 = mem[sp] (byte) = 0x78
    
    add sp, sp, #16
    bkpt #0
.ltorg
