/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000008"
  }
}
*/

.text
.global _start
_start:
    adr x0, _start
    brk #0

