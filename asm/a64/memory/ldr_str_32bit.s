/* CONFIG
{
  "Match": "All",
  "RegData": {
    "W0": "0x12345678",
    "W1": "0x9ABCDEF0"
  },
  "MemData": {
    "0x1000": ["0x0000000012345678", "0x000000009ABCDEF0"]
  }
}
*/
.text
.global _start
_start:
    ldr x3, =0x1000
    ldr w0, [x3]
    ldr w1, [x3, #8]
    brk #0
