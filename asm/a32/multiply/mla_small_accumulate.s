/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000014" }
}
*/
.text
.global _start
_start:
    mov r1, #3
    mov r2, #4
    mov r3, #8
    mla r0, r1, r2, r3
    bkpt #0
