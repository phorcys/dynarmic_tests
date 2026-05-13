/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R6": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    // LDREXD/STREXD success basic path
    sub sp, sp, #16
    mov r0, sp
    
    ldr r2, =0x12345678
    ldr r3, =0xABCDEF00
    
    ldrexd r4, r5, [r0]
    strexd r6, r2, r3, [r0]
    
    add sp, sp, #16
    
    bkpt #0
