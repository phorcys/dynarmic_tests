/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    // CMP: Compare and set flags
    // Compare 10 and 5, should set N=0, Z=0, C=1, V=0
    mov r0, #10
    cmp r0, #5
    // If greater, set r0 = 1
    movgt r0, #1
    movle r0, #0
    
    bkpt #0