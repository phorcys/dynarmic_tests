/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R2": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    // LDREXB/STREXB status basic sample
    sub sp, sp, #16
    mov r0, sp
    
    mov r1, #0xAB
    
    ldrexb r3, [r0]
    strexb r2, r1, [r0]
    
    add sp, sp, #16
    
    bkpt #0
