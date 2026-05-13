/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234",
    "X1": "0x0000000000005678"
  },
  "MemData": {
    "0x1000": ["0x0000000000001234", "0x0000000000005678"]
  }
}
*/
.text
.global _start
_start:
    ldr x1, =0x1000
    ldp x0, x1, [x1]
    brk #0
