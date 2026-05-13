/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0xFFFFFF80"
  }
}
*/
.text
.global _start
_start:
    // SXTB: Sign extend byte
    // 0x80 sign-extended to 32-bit = 0xFFFFFF80
    mov r0, #0x80
    sxtb r0, r0
    
    bkpt #0
