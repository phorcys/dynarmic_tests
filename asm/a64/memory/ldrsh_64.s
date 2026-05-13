/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFF8000"
  },
  "MemData": {
    "0x1000": ["0x0000000000008000"]
  }
}
*/
.text
.global _start
_start:
    ldr x1, =0x1000
    ldrsh x0, [x1]
    brk #0
