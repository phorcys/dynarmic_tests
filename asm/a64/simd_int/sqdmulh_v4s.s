/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002"
  }
}
*/
// Test: SQDMULH - Saturating Doubling Multiply High (4S)

.text
.global _start
_start:
    // V0 = {0x4000, 0, ...} (0x4000 in first halfword)
    movz x8, #0x4000
    fmov d0, x8
    
    // V1 = {0x4000, 0, ...}
    movz x9, #0x4000
    fmov d1, x9
    
    // SQDMULH: 2 * (0x4000 * 0x4000) >> 16
    // = 2 * 0x10000000 >> 16 = 0x20000000 >> 16 = 0x2000
    // But this is for 4S, let me recalculate
    // Actually SQDMULH Vd.4S, Vn.4S, Vm.4S operates on 32-bit elements
    
    // Let's use simpler values for 32-bit
    // For SQDMULH with 32-bit elements:
    // result = (2 * Vn[i] * Vm[i]) >> 32, saturated
    
    // Let's use 0x00010000 and 0x00010000
    // 2 * 0x00010000 * 0x00010000 = 2 * 0x0000000100000000
    // >> 32 = 0x00000002
    
    // Actually let's use immediate form
    movz w8, #0x0001, lsl #16
    fmov s0, w8
    fmov s1, w8
    
    // SQDMULH: 2 * (0x10000 * 0x10000) >> 32
    // = 2 * 0x100000000 >> 32 = 0x2
    // Wait, that's 2 * 0x100000000 = 0x200000000 >> 32 = 2
    
    sqdmulh v0.4s, v0.4s, v1.4s
    
    fmov x0, d0

    brk #0
