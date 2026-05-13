/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000003", "R1": "0x00000001" }
}
*/
.text
.global _start
_start:
    @ ADC: Add with Carry
    mov r0, #1
    mov r1, #1
    
    @ Set carry flag
    cmp r0, #0       @ 1 - 0, sets C=1
    
    adc r0, r1, r1   @ r0 = r1 + r1 + C = 1 + 1 + 1 = 3
    
    bkpt #0
