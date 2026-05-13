/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000080" }
}
*/
.text
.global _start
_start:
    mov r1, #1
    mov r2, #0x7F
    sxtab r0, r1, r2
    bkpt #0
