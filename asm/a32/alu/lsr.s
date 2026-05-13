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
    // LSR: Logical shift right
    // 0x10000 >> 8 = 0x100
    ldr r0, =0x10000
    mov r1, #8
    lsr r0, r0, r1
    
    bkpt #0
.ltorg