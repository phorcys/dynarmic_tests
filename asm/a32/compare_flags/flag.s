/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001"
  }
}
*/
.text
.arm
.global _start
_start:
    @ Test CMP setting C flag
    @ CMP a, b sets C=1 if a >= b (unsigned)
    @ CMP 0xFFFFFFFF, 0 should set C=1
    
    mvn r0, #0            @ r0 = 0xFFFFFFFF
    cmp r0, #0            @ Should set C=1
    
    @ Use ADC to read C flag
    @ ADC r0, r1, r2 = r1 + r2 + C
    mov r0, #0
    adc r0, r0, #0        @ r0 = 0 + 0 + C = C
    bkpt #0
