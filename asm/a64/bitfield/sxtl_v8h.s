/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x0000000000000000ff7f3f1f0f070301",
    "Q2": "0xffff007f003f001f000f000700030001"
  }
}
*/
// Test: SXTL Vd.8H, Vn.8B - signed extend byte to halfword

.text
.global _start
_start:
    // Load D0 with 8 bytes: [1, 3, 7, 15, 31, 63, 127, 255]
    // 255 (0xff) as signed is -1
    // Use ldr to load the immediate
    ldr x0, =0xff7f3f1f0f070301
    fmov d0, x0
    
    // SXTL: sign-extend each byte to halfword
    // [1, 3, 7, 15, 31, 63, 127, -1] -> [1, 3, 7, 15, 31, 63, 127, -1] as halfwords
    // Result: [0x0001, 0x0003, 0x0007, 0x000f, 0x001f, 0x003f, 0x007f, 0xffff]
    sxtl v2.8h, v0.8b

    brk #0
