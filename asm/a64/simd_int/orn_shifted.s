/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFF0F",
    "X1": "0xFFFFFFFFFFFFF0FF",
    "X2": "0xFFFFFFFFFFFF0FFF",
    "X3": "0xFFFFFFFFFFFFFFF0"
  }
}
*/
.text
.global _start
_start:
    // Test ORN with shifted register
    // ORN Xd, Xn, Xm, LSL #shift
    // ORN: Xd = Xn | ~(Xm << shift)

    mov x5, #0               // Source value (0 means result is just ~mask)
    mov x6, #0x0F            // Mask to be shifted and NOTed

    // ORN with LSL #4
    // Xm << 4 = 0xF0
    // ~(0xF0) = 0xFFFFFFFFFFFFFF0F
    // 0 | 0xFF...FF0F = 0xFF...FF0F
    orn x0, x5, x6, lsl #4   // x0 = 0xFFFFFFFFFFFFFF0F

    // ORN with LSL #8
    // Xm << 8 = 0xF00
    // ~(0xF00) = 0xFFFFFFFFFFFFF0FF
    orn x1, x5, x6, lsl #8   // x1 = 0xFFFFFFFFFFFFF0FF

    // ORN with LSL #12
    // Xm << 12 = 0xF000
    // ~(0xF000) = 0xFFFFFFFFFFFF0FFF
    orn x2, x5, x6, lsl #12  // x2 = 0xFFFFFFFFFFFF0FFF

    // ORN without shift (LSL #0)
    // ~(0x0F) = 0xFFFFFFFFFFFFFFF0
    orn x3, x5, x6           // x3 = 0xFFFFFFFFFFFFFFF0

    brk #0
