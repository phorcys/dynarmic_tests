/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000002" }
}
*/
.text
.global _start
_start:
    mov r1, #2
    mov r2, #0
    uxtah r0, r1, r2
    bkpt #0
