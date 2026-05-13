/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000100"
  }
}
*/
.text
.global _start
_start:
    // LSL: Logical shift left
    // 1 << 8 = 256 = 0x100
    mov r0, #1
    mov r1, #8
    lsl r0, r0, r1
    
    bkpt #0