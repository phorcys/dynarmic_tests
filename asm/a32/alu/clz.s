/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000004"
  }
}
*/
.text
.global _start
_start:
    // CLZ: Count leading zeros
    // 0x0F000000 has 4 leading zeros
    ldr r0, =0x0F000000
    clz r0, r0
    
    bkpt #0
.ltorg
