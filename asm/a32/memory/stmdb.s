/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R5": "0x11111111",
    "R6": "0x22222222"
  }
}
*/
.text
.global _start
_start:
    @ STMDB: Store multiple decrement before
    mov r0, #0
    mov r1, #0
    
    ldr r5, =0x11111111
    ldr r6, =0x22222222
    
    @ Store multiple
    sub sp, sp, #8
    mov r2, sp
    stmdb r2!, {r5, r6}
    
    @ Verify by loading back
    ldmdb sp, {r0, r1}
    add sp, sp, #8
    bkpt #0
