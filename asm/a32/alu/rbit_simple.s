/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x04000000" }
}
*/
.text
.global _start
_start:
    @ RBIT: Reverse bits in word
    @ RBIT Rd, Rm
    
    mov r1, #0x20           @ bit 5 set
    
    rbit r0, r1             @ R0 = bit 26 set = 0x04000000
    
    bkpt #0
