/* CONFIG
{
  "Match": "All",
  "RegData": {
    "W0": "0x00000034",
    "W1": "0x00000012"
  },
  "MemData": {
    "0x1000": ["0x0000000000001234"]
  }
}
*/
.text
.global _start
_start:
    ldr x3, =0x1000
    ldrb w0, [x3]
    ldrb w1, [x3, #1]
    brk #0
