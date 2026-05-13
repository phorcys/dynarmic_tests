/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000009" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00020000
    ldr r2, =0x00018000
    mov r3, #7
    smlawt r0, r1, r2, r3
    bkpt #0
.ltorg
