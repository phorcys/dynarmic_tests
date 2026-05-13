/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000020000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0
    cmp x0, #0          // Z=1, C=1
    ccmn x0, #1, #0x0, eq  // if Z=1, compare x0 with -1
    brk #0

