/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000005" }
}
*/
.text
.global _start
_start:
    mov r1, #5
    mov r2, #0
    sxtah r0, r1, r2
    bkpt #0
