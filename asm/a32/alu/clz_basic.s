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
    
    clz r0, r1         @ Count leading zeros in 0x00FFFFFF = 8
    
    bkpt #0
.ltorg
