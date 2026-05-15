/* CONFIG
{
  "Match": "All",
  "ExpectedMemData": {
    "0x1000": [
      "0x4008000000000000",
      "0x0000000000000000"
    ]
  }
}
*/

.text
.global _start
_start:
    movi v0.16b, #0xff
    fmov d1, #1.0
    fmov d2, #2.0
    fadd d0, d1, d2
    mov x0, #0x1000
    str q0, [x0]
    brk #0
