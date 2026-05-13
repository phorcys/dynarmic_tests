/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000020" }
}
*/
.text
.global _start
_start:
    mov r1, #16
    mov r2, #16
    qadd r0, r1, r2
    bkpt #0
