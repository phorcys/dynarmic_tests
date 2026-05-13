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
    // LDREXH/STREXH success basic path
    sub sp, sp, #16
    mov r0, sp
    
    mov r1, #0x1234
    
    ldrexh r3, [r0]
    strexh r2, r1, [r0]
    
    add sp, sp, #16
    
    bkpt #0
