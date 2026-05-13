/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000010000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0
    cmp x0, #0          // Z=1, C=1
    ccmp x0, #1, #0x8, eq  // if condition true, compare; else NZCV=0x8
    brk #0

