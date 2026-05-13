/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005", "R1": "0x00030003", "R2": "0x0000000F" }
}
*/
.text
.global _start
_start:
    movw r0, #5
    movw r1, #0x0003
    movt r1, #0x0003     // R1 = 0x00030003
    
    // SMUAD with mixed zero/non-zero halfwords
    // R0 = 5, so low=5, high=0
    // R1 = 0x00030003, so low=3, high=3
    // R2 = 5*3 + 0*3 = 15
    smuad r2, r0, r1
    
    bkpt #0
