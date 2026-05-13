/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" }
}
*/
.text
.global _start
_start:
    mov r0, #0
    nop
    nop
    nop
    bkpt #0
