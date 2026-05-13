/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12345678"
  }
}
*/
.text
.global _start
_start:
    @ LDR with register offset
    @ Use stack for data
    ldr r0, =0x12345678
    push {r0}           @ data at sp
    add r1, sp, #4      @ r1 = sp + 4
    mov r2, #4
    
    @ LDR R0, [R1, -R2] - Load from R1-R2 = sp
    ldr r0, [r1, -r2]
    
    pop {r3}            @ fix stack
    bkpt #0
.ltorg