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
    // LDREX/STREX status basic sample
    sub sp, sp, #16
    mov r0, sp
    
    mov r1, #0x42
    
    ldrex r3, [r0]         // exclusive load
    strex r2, r1, [r0]     // exclusive store, r2 = 0 on success
    
    add sp, sp, #16
    
    bkpt #0
