/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFF80" }
}
*/
.text
.global _start
_start:
    @ LDRSB with register offset
    
    sub sp, sp, #16
    
    @ Store byte 0x80 (negative when sign extended)
    mov r2, #0x80
    strb r2, [sp]
    
    mov r1, sp
    mov r2, #0
    ldrsb r0, [r1, r2]   @ R0 = sign_extend(0x80) = 0xFFFFFF80
    
    add sp, sp, #16
    bkpt #0
