/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x11111111",
    "R1": "0x22222222"
  }
}
*/
.text
.global _start
_start:
    @ STMIA: Store multiple increment after
    mov r2, #0
    mov r3, #0
    
    ldr r0, =0x11111111
    ldr r1, =0x22222222
    
    @ Store multiple
    sub sp, sp, #8
    mov r4, sp
    stmia r4!, {r0, r1}
    
    @ Verify by loading back
    ldmia sp, {r2, r3}
    add sp, sp, #8
    bkpt #0
