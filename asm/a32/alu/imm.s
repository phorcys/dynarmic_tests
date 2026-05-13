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
    @ LDR with immediate offset
    @ Use stack for data
    ldr r0, =0x12345678
    push {r0}           @ sp points to data
    
    mov r1, sp
    add r1, r1, #4      @ r1 = sp + 4
    sub r1, r1, #4      @ r1 = sp (back to data)
    
    @ LDR R0, [R1, #0] - Load from R1+0
    ldr r0, [r1, #0]
    
    pop {r2}            @ fix stack
    mov r1, #0          @ clear r1 for test
    bkpt #0
.ltorg