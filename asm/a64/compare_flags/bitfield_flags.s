/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x20000000",
    "X1": "0xA0000000",
    "X2": "0xA0000000",
    "X3": "0x20000000"
  }
}
*/
// Test: Bitfield operations (UBFX, SBFX, BFI, BFC) with flags via CMP
// These operations don't set flags directly, we check results with CMP

.text
.global _start
_start:
    // Test 1: UBFX (Unsigned Bit Field Extract)
    // Extract bits [4:0] from 0x80000001, result = 1
    mov w11, #1
    ubfx w12, w11, #0, #5    // w12 = bits[4:0] of w11 = 1
    cmp w12, #0              // 1 - 0 = 1
    // N=0, Z=0, C=1, V=0 -> 0x20000000
    mrs x0, nzcv

    // Test 2: SBFX (Signed Bit Field Extract) - sign extends
    // Extract bits [31:31] from 0x80000000, result = 0xFFFFFFFF (-1)
    mov w11, #0x80000000
    sbfx w12, w11, #31, #1   // w12 = sign bit = -1 (0xFFFFFFFF)
    cmp w12, #0              // -1 - 0 = -1
    // N=1, Z=0, C=1, V=0 -> 0xA0000000
    mrs x1, nzcv

    // Test 3: BFI (Bit Field Insert)
    // Insert 0xFF into bits [7:0] of 0x80000000
    mov w11, #0x80000000
    mov w12, #0xFF
    bfi w11, w12, #0, #8     // w11 = 0x800000FF
    cmp w11, #0              // 0x800000FF - 0 = 0x800000FF
    // N=1, Z=0, C=1, V=0 -> 0xA0000000
    mrs x2, nzcv

    // Test 4: BFC (Bit Field Clear)
    // Clear bits [7:0] of 0x100 -> 0x100
    mov w11, #0x100
    bfc w11, #0, #8          // w11 = 0x100 (bits [7:0] already 0)
    cmp w11, #0              // 0x100 - 0 = 0x100
    // N=0, Z=0, C=1, V=0 -> 0x20000000
    mrs x3, nzcv

    brk #0
