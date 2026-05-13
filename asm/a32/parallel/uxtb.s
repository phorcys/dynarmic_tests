/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000080"
  }
}
*/
.text
.global _start
_start:
    // UXTB: Unsigned extend byte
    // 0xFFFFFF80 zero-extended to 32-bit = 0x00000080
    ldr r0, =0xFFFFFF80
    uxtb r0, r0
    
    bkpt #0
.ltorg