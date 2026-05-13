/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x00000000F0000000"}
}
*/
.text
.global _start
_start:
    mov x0, #0
    cmp x0, #1          // Z=0, C=0
    ccmp x0, #0, #0xF, eq  // if Z=0: NZCV = 0xF -> 0xF0000000
    mrs x0, nzcv
    brk #0
