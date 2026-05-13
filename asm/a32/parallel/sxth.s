/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0xFFFF8000"
  }
}
*/
.text
.global _start
_start:
    // SXTH: Sign extend halfword
    // 0x8000 sign-extended to 32-bit = 0xFFFF8000
    ldr r0, =0x8000
    sxth r0, r0
    
    bkpt #0
.ltorg