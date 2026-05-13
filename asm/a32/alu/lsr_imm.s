/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000002" }
}
*/
.text
.global _start
_start:
    @ LSR immediate: Logical Shift Right
    @ LSR Rd, Rm, #imm
    
    mov r1, #8
    lsr r0, r1, #2       @ R0 = 8 >> 2 = 2
    
    bkpt #0
