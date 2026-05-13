/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R2": "0x11111111",
    "R3": "0x22222222"
  }
}
*/
.text
.global _start
_start:
    @ LDMDA: Load multiple decrement after
    @ Store test data on stack (high to low)
    ldr r0, =0x22222222
    push {r0}
    ldr r0, =0x11111111
    push {r0}
    
    @ Load multiple decrement after
    mov r1, sp
    add r1, r1, #4  @ Point to higher address
    ldmda r1, {r2, r3}
    
    @ Fix stack
    add sp, sp, #8
    bkpt #0
