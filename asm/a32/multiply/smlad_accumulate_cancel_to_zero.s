/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000004" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x0001FFFF
    ldr r2, =0x0001FFFF
    mov r3, #2
    smlad r0, r1, r2, r3
    bkpt #0
.ltorg
