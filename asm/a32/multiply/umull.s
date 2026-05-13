/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000000",
    "R1": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    // UMULL: Unsigned multiply long
    // R1:R0 = R2 * R3 = 0x10000 * 0x10000 = 0x100000000
    ldr r2, =0x10000
    ldr r3, =0x10000
    umull r0, r1, r2, r3
    
    bkpt #0
.ltorg
