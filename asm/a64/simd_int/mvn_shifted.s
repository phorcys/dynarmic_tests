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
    // Test MVN with shifted register
    // MVN Xd, Xm, LSL #shift
    // MVN: Xd = ~(Xm << shift)
    // Note: MVN is an alias for ORN Xd, XZR, Xm, shift

    mov x6, #0x0F            // Mask to be shifted and NOTed

    // MVN with LSL #4
    // Xm << 4 = 0xF0
    // ~(0xF0) = 0xFFFFFFFFFFFFFF0F
    mvn x0, x6, lsl #4       // x0 = 0xFFFFFFFFFFFFFF0F

    // MVN with LSL #8
    // Xm << 8 = 0xF00
    // ~(0xF00) = 0xFFFFFFFFFFFFF0FF
    mvn x1, x6, lsl #8       // x1 = 0xFFFFFFFFFFFFF0FF

    // MVN with LSL #12
    // Xm << 12 = 0xF000
    // ~(0xF000) = 0xFFFFFFFFFFFF0FFF
    mvn x2, x6, lsl #12      // x2 = 0xFFFFFFFFFFFF0FFF

    // MVN without shift (LSL #0)
    // ~(0x0F) = 0xFFFFFFFFFFFFFFF0
    mvn x3, x6               // x3 = 0xFFFFFFFFFFFFFFF0

    brk #0
