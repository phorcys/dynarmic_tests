/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x0000000040400000",
    "S1": "0x0000000040400000",
    "S2": "0x0000000042540000",
    "S3": "0x00000000c0c00000",
    "X5": "0x404A800000000000",
    "X6": "0xC018000000000000"
  }
}
*/
// Test: FRINTA Sd, Sn - floating-point round to nearest with ties to away

.text
.global _start
_start:
    // Load S0 with 3.0
    mov w0, #0x0000
    movk w0, #0x4040, lsl #16
    fmov s0, w0
    
    // FRINTA: round to nearest (3.0 stays 3.0)
    frinta s1, s0

    // 52.5 -> 53.0
    mov w1, #0x0000
    movk w1, #0x4252, lsl #16
    fmov s2, w1
    frinta s2, s2

    // -5.5 -> -6.0
    mov w2, #0x0000
    movk w2, #0xc0b0, lsl #16
    fmov s3, w2
    frinta s3, s3

    // 52.5 -> 53.0 (double)
    movz x3, #0x0000, lsl #0
    movk x3, #0x0000, lsl #16
    movk x3, #0x4000, lsl #32
    movk x3, #0x404a, lsl #48
    fmov d4, x3
    frinta d4, d4
    fmov x5, d4

    // -5.5 -> -6.0 (double)
    movz x4, #0x0000, lsl #0
    movk x4, #0x0000, lsl #16
    movk x4, #0x0000, lsl #32
    movk x4, #0xc016, lsl #48
    fmov d5, x4
    frinta d5, d5
    fmov x6, d5

    brk #0
