/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000010"
  }
}
*/

.text
.global _start
_start:
    mov x0, #2
    mul x0, x0, x0     // x0 = 2 * 2 = 4
    mul x0, x0, x0     // x0 = 4 * 4 = 16
    brk #0

