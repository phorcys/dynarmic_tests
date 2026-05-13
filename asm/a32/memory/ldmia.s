/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R2": "0x11111111",
    "R3": "0x22222222",
    "R4": "0x33333333"
  }
}
*/
.text
.global _start
_start:
    @ LDMIA: Load multiple increment after
    @ Store test data on stack in correct order for LDMIA
    @ LDMIA loads from low to high address
    @ Stack grows downward, so we need to push in reverse order
    ldr r0, =0x33333333
    push {r0}
    ldr r0, =0x22222222
    push {r0}
    ldr r0, =0x11111111
    push {r0}
    
    @ Load multiple - LDMIA loads from base addr upward
    @ sp points to lowest addr (0x11111111)
    mov r1, sp
    ldmia r1, {r2, r3, r4}
    
    @ Fix stack
    add sp, sp, #12
    bkpt #0