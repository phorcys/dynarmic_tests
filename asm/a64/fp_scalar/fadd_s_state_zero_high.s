/* CONFIG
{
  "Match": "All",
  "ExpectedMemData": {
    "0x1000": [
      "0x0000000040400000",
      "0x0000000000000000"
    ]
  }
}
*/

.text
.global _start
_start:
    movi v0.16b, #0xff
    fmov s1, #1.0
    fmov s2, #2.0
    fadd s0, s1, s2
    mov x0, #0x1000
    str q0, [x0]
    brk #0
