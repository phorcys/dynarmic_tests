/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x0000000000000000ff7f3f1f0f070301",
    "Q2": "0x00ff007f003f001f000f000700030001"
  }
}
*/
// Test: UXTL Vd.8H, Vn.8B - unsigned extend byte to halfword

.text
.global _start
_start:
    // Load D0 with 8 bytes: [1, 3, 7, 15, 31, 63, 127, 255]
    ldr x0, =0xff7f3f1f0f070301
    fmov d0, x0
    
    // UXTL: zero-extend each byte to halfword
    // [1, 3, 7, 15, 31, 63, 127, 255] -> [0x0001, 0x0003, 0x0007, 0x000f, 0x001f, 0x003f, 0x007f, 0x00ff]
    uxtl v2.8h, v0.8b

    brk #0
