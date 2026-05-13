/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000030"
  }
}
*/
// Test: CLS Xd, Xn - count leading sign bits

.text
.global _start
_start:
    // Create value 0xFFFF_FFFF_FFFF_8000
    mov x0, #0x8000
    movk x0, #0xFFFF, lsl #16
    movk x0, #0xFFFF, lsl #32
    movk x0, #0xFFFF, lsl #48

    // CLS counts consecutive bits that match the sign bit, starting from bit 62
    // 0xFFFF_FFFF_FFFF_8000:
    // bit 63 = 1 (sign bit)
    // bits 62-16 = 47 bits, all 1
    // bit 15 = 1
    // bits 14-0 = 0
    // Wait, 0x8000 = 1000 0000 0000 0000
    // So bits 15 = 1, bits 14-0 = 0

    // CLS should count bits 62-15 that match bit 63 = 48 bits
    // But result is 48 = 0x30, let me just use that

    cls x0, x0

    brk #0