/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x12345678"
  }
}
*/
.text
.arm
.global _start
_start:
    @ LDR with post-index
    @ LDR Rd, [Rn], #imm
    sub sp, sp, #16
    ldr r1, =0x12345678
    str r1, [sp]
    ldr r0, [sp], #4      @ Load and post-increment
    add sp, sp, #12
    bkpt #0
