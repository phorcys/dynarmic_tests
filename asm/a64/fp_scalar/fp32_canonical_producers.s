/* CONFIG
{
  "Match": "All",
    "ExpectedMemData": {
      "0x1000": [
      "0x0000000040e00000",
      "0x0000000000000000",
      "0x00000000c0a00000",
      "0x0000000000000000",
      "0x000000003f800000",
      "0x0000000000000000",
      "0x000000003f800000",
      "0x0000000000000000",
      "0x0000000040000000",
      "0x0000000000000000"
    ]
  }
}
*/

.text
.global _start
_start:
    mov x0, #0x1000

    movi v0.16b, #0xff
    fmov s1, #2.0
    fmov s2, #3.0
    fmov s3, #1.0
    fmadd s0, s1, s2, s3       // 7.0
    str q0, [x0], #16

    fmsub s1, s1, s2, s3       // 5.0
    str q1, [x0], #16

    movi v0.16b, #0xff
    fmov d1, #1.0
    fcvt s0, d1
    str q0, [x0], #16

    movi v1.16b, #0xff
    frintn s1, s0
    str q1, [x0], #16

    movi v0.16b, #0xff
    fmov s1, #1.0
    fmov s2, #2.0
    fmax s0, s1, s2
    str q0, [x0]

    brk #0
