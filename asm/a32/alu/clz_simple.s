/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000008" }
}
*/
.text
.global _start
_start:
    @ CLZ: Count Leading Zeros
    
    ldr r1, =0x00FFFFFF
    clz r0, r1           @ R0 = 8 (8 leading zeros)
    
    bkpt #0
.ltorg
