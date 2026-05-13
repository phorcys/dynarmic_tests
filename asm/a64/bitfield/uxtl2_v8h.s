/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0xff7f3f1f0f070301ff7f3f1f0f070301",
    "Q2": "0x00ff007f003f001f000f000700030001"
  }
}
*/
// Test: UXTL2 Vd.8H, Vn.16B - unsigned extend high bytes to halfword

.text
.global _start
_start:
    // Load Q0 with 16 bytes (low 8 and high 8 are the same pattern)
    ldr x0, =0xff7f3f1f0f070301
    fmov d0, x0
    mov v0.d[1], x0
    
    // UXTL2: zero-extend high 8 bytes to halfwords
    // High bytes: [1, 3, 7, 15, 31, 63, 127, 255] -> [0x0001, 0x0003, ..., 0x00ff]
    uxtl2 v2.8h, v0.16b

    brk #0
