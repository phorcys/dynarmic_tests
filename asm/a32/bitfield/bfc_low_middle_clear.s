/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x000000C3" }
}
*/
.text
.global _start
_start:
    mov r0, #0xFF
    bfc r0, #2, #4
    bkpt #0
.ltorg
