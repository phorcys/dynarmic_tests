/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x08000000"
  }
}
*/
.text
.global _start
_start:
    // RBIT: Reverse bits
    // 0x00000010 reversed = 0x08000000
    mov r0, #0x10
    rbit r0, r0
    
    bkpt #0
