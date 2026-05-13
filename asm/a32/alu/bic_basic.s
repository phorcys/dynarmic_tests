/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000FF00" }
}
*/
.text
.global _start
_start:
    @ BIC: Bit Clear (AND with complement)
    @ BIC Rd, Rn, Operand2
    @ Rd = Rn AND NOT Operand2
    
    mov r1, #0xFF
    mov r0, #0xFF
    
    bic r0, r1, #0x0F  @ R0 = 0xFF AND NOT 0x0F = 0xFF AND 0xF0 = 0xF0
    
    @ Let's do a cleaner test
    mov r1, #0xFFFF
    bic r0, r1, #0xFF  @ R0 = 0xFFFF AND NOT 0xFF = 0xFFFF AND 0xFF00 = 0xFF00
    
    @ Actually use a simple test
    ldr r1, =0x0000FFFF
    ldr r2, =0x000000FF
    
    bic r0, r1, r2     @ R0 = 0xFFFF AND NOT 0xFF = 0xFFFFFF00
    
    bkpt #0
.ltorg