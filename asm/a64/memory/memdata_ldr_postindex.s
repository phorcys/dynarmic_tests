/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234"
  },
  "MemData": {
    "0x1000": ["0x0000000000001234"]
  }
}
*/
.text
.global _start
_start:
    ldr x1, =0x1000
    ldr x0, [x1], #8
    brk #0
