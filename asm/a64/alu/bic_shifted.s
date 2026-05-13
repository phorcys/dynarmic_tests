/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000F0F",
    "X1": "0x000000000000F0FF",
    "X2": "0x0000000000000FFF",
    "X3": "0x000000000000FFF0"
  }
}
*/
.text
.global _start
_start:
    // Test BIC with shifted register
    // BIC Xd, Xn, Xm, LSL #shift
    // BIC: Xd = Xn & ~(Xm << shift)

    mov x5, #0x0FFF          // Source value
    mov x6, #0x0F            // Mask to be shifted and NOTed

    // BIC with LSL #4
    // Xm << 4 = 0xF0
    // ~(0xF0) = 0xFF...FF0F
    // 0x0FFF & 0xFF0F = 0x0F0F
    bic x0, x5, x6, lsl #4   // x0 = 0x0F0F

    // BIC with LSL #8
    mov x7, #0xFFFF
    // Xm << 8 = 0xF00
    // ~(0xF00) = 0xFFFFF0FF
    // 0xFFFF & 0xF0FF = 0xF0FF
    bic x1, x7, x6, lsl #8   // x1 = 0xF0FF

    // BIC with LSL #12
    // Xm << 12 = 0xF000
    // ~(0xF000) = 0xFFFF0FFF
    // 0xFFFF & 0x0FFF = 0x0FFF
    bic x2, x7, x6, lsl #12  // x2 = 0x0FFF

    // BIC without shift (LSL #0)
    // ~(0x0F) = 0xFFF0
    // 0xFFFF & 0xFFF0 = 0xFFF0
    bic x3, x7, x6           // x3 = 0xFFF0

    brk #0
