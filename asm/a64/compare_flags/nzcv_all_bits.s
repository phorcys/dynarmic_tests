/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000F0000000"
  }
}
*/
// Test: NZCV direct manipulation - all bit combinations

.text
.global _start
_start:
    // Set all flags: N=1, Z=1, C=1, V=1 -> NZCV = 0xF0000000
    // MSR NZCV, #imm uses bits 31:28 of the immediate
    mov x0, #0xF0000000
    msr nzcv, x0
    
    // Read back
    mrs x0, nzcv
    
    brk #0