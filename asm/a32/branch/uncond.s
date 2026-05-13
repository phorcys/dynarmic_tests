/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x0000002A"
  }
}
*/
.text
.global _start
_start:
    // B: Unconditional branch
    b skip
    mov r0, #0      // Should be skipped
skip:
    mov r0, #42
    
    bkpt #0
