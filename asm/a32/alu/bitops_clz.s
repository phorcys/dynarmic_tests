/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000020",
    "R1": "0x0000000F"
  }
}
*/
.text
.global _start
_start:
    // CLZ - Count Leading Zeros
    mov r0, #0
    clz r0, r0        // CLZ(0) = 32
    
    mov r1, #1
    lsl r1, r1, #16   // r1 = 0x10000
    clz r1, r1        // CLZ(0x10000) = 15 (binary: 0000...010000000000000000)
    
    bkpt #0
