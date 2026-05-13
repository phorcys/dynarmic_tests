/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00030000
    ldr r2, =0x0000FFFE
    mov r3, #6
    smlawb r0, r1, r2, r3
    bkpt #0
.ltorg
