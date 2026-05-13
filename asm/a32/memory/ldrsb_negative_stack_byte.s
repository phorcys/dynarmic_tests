/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0xFFFFFF88" }
}
*/
.text
.global _start
_start:
    sub sp, sp, #16
    mov r2, #0x88
    strb r2, [sp]
    ldrsb r0, [sp]
    add sp, sp, #16
    bkpt #0
