/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" }
}
*/
.text
.global _start
_start:
    mov r1, #0x7F
    mov r2, #0
    pkhtb r0, r1, r2
    bkpt #0
