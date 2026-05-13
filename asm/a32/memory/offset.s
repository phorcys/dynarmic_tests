/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12345678",
    "R1": "0x00000000"
  }
}
*/
.text
.global _start
_start:
    @ LDR with negative immediate offset
    @ Use stack for data
    ldr r0, =0x12345678
    push {r0}           @ sp points to data
    add sp, sp, #8      @ sp = sp + 8 (above data)
    
    mov r1, sp
    
    @ LDR R0, [R1, #-8] - Load from R1-8
    ldr r0, [r1, #-8]
    
    sub sp, sp, #8
    pop {r2}            @ fix stack
    mov r1, #0          @ clear r1 for test
    bkpt #0
.ltorg