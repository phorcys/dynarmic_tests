/* CONFIG
{
  "Match": "All",
  "RegData": {
    "W0": "0xFFFF8000",
    "W1": "0x00007FFF",
    "X2": "0xFFFFFFFFFFFF8000"
  },
  "MemData": {
    "0x1000": ["0x000000007FFF8000"]
  }
}
*/
.text
.global _start
_start:
    ldr x3, =0x1000
    ldrsh w0, [x3]
    ldrsh w1, [x3, #2]
    ldrsh x2, [x3]
    brk #0
