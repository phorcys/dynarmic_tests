/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000000060000000"}
}
*/
.text
.global _start
_start:
    mov x0, #0
    cmp x0, #0         // Z=1, C=1
    ccmp x0, #0, #0x0, eq  // if Z=1, compare; result: Z=1, C=1
    mrs x0, nzcv
    brk #0
