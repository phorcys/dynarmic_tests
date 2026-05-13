/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000007FFFFFFF",
    "X1": "0xFFFFFFFF80000000"
  },
  "MemData": {
    "0x1000": ["0x800000007FFFFFFF"]
  }
}
*/
.text
.global _start
_start:
    ldr x2, =0x1000
    ldpsw x0, x1, [x2]
    brk #0
