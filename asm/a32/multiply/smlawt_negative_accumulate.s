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
    ldr r2, =0xFFFE0000
    mov r3, #6
    smlawt r0, r1, r2, r3
    bkpt #0
.ltorg
