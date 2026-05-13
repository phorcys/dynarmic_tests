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
    @ STR with post-index
    @ STR Rd, [Rn], #imm
    sub sp, sp, #16
    ldr r0, =0x12345678
    mov r1, sp
    str r0, [r1], #4      @ Store and post-increment
    @ Load back to verify
    ldr r0, [sp]          @ Load from original sp location
    add sp, sp, #16
    bkpt #0
.ltorg
