/* CONFIG
{
  "Match": "All",
  "RegData": {
    "W0": "0x00001234",
    "W1": "0x00005678"
  },
  "MemData": {
    "0x1000": ["0x0000000056781234"]
  }
}
*/
.text
.global _start
_start:
    ldr x3, =0x1000
    ldrh w0, [x3]
    ldrh w1, [x3, #2]
    brk #0
