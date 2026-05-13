/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000004" }
}
*/
.text
.global _start
_start:
    @ LSL immediate: Logical Shift Left
    @ LSL Rd, Rm, #imm
    
    mov r1, #1
    lsl r0, r1, #2       @ R0 = 1 << 2 = 4
    
    bkpt #0
