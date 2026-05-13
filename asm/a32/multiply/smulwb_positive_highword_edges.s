/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000004" }
}
*/
.text
.global _start
_start:
    ldr r1, =0x00020000
    mov r2, #2
    smulwb r0, r1, r2
    bkpt #0
.ltorg
