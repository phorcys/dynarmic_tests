/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000000D" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00020000
    mov r2, #3
    mov r3, #7
    smlawb r0, r1, r2, r3
    bkpt #0
.ltorg
