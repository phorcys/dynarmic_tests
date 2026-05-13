/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000001F" }
}
*/
.text
.global _start
_start:
    @ RBIT: Reverse bits
    @ RBIT Rd, Rm
    
    ldr r1, =0xF8000000
    
    rbit r0, r1          @ R0 = 0x0000001F
    
    bkpt #0
.ltorg
