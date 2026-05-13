/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000014",
    "R1": "0x0000000A"
  }
}
*/
.text
.global _start
_start:
    // LSL immediate - Logical Shift Left
    mov r0, #5
    lsl r1, r0, #1      // r1 = 5 << 1 = 10
    
    // LSL register
    mov r0, #5
    mov r2, #2
    lsl r0, r0, r2      // r0 = 5 << 2 = 20
    
    bkpt #0
