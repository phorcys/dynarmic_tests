/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000002A" }
}
*/
.text
.global _start
_start:
    mov r0, #42
    bkpt #0
