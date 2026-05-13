/* CONFIG
{
  "Match": "All",
  "RegData": {
    "W0": "0x12345678",
    "W1": "0x9ABCDEF0"
  },
  "MemData": {
    "0x1000": ["0x9ABCDEF012345678"]
  }
}
*/
.text
.global _start
_start:
    ldr x2, =0x1000
    ldp w0, w1, [x2]
    brk #0
