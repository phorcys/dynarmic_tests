/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x000000AF" }
}
*/
.text
.global _start
_start:
    mov r0, #0x0F
    mov r1, #0x3A
    bfi r0, r1, #4, #4
    bkpt #0
.ltorg
