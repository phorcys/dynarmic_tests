/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000080" }
}
*/
.text
.global _start
_start:
    @ LSL immediate: Logical Shift Left
    @ LSL Rd, Rm, #imm
    
    mov r1, #1
    lsl r0, r1, #7       @ R0 = 1 << 7 = 128 = 0x80
    
    bkpt #0
