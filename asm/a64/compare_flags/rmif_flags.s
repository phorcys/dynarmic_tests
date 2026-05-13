/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x80000000",
    "X1": "0xC0000000",
    "X2": "0xE0000000",
    "X3": "0xF0000000",
    "X4": "0xF0000000",
    "X5": "0x30000000",
    "X6": "0x30000000"
  }
}
*/
// Test: RMIF - Rotate Multiple Into Flags (ARMv8.4-A)
// RMIF Xn, #lsb, #mask
// Rotate Xn right by lsb bits, then extract bits [3:0] as NZCV source
// bit[3] -> N, bit[2] -> Z, bit[1] -> C, bit[0] -> V
// mask: bit3=N, bit2=Z, bit1=C, bit0=V
// If mask bit is 1, update that flag from Xn; if 0, preserve current value

.text
.global _start
_start:
    // Initialize NZCV to 0
    mov x10, #0
    msr nzcv, x10

    // Test 1: RMIF with mask=0b1000 (N only)
    // X11 = 0x8 (bit 3 set)
    // bits [3:0] = 0x8 -> N=1, Z=0, C=0, V=0
    // mask=0b1000 -> update N only
    // Result: N=1, Z=0, C=0, V=0 = 0x80000000
    mov x11, #0x8
    rmif x11, #0, #0b1000
    mrs x0, nzcv

    // Test 2: RMIF with mask=0b0100 (Z only)
    // Previous NZCV = 0x80000000 (N=1)
    // X11 = 0x4 (bit 2 set)
    // bits [3:0] = 0x4 -> N=0, Z=1, C=0, V=0
    // mask=0b0100 -> update Z only, N preserved
    // Result: N=1, Z=1, C=0, V=0 = 0xC0000000
    mov x11, #0x4
    rmif x11, #0, #0b0100
    mrs x1, nzcv

    // Test 3: RMIF with mask=0b0010 (C only)
    // Previous NZCV = 0xC0000000 (N=1, Z=1)
    // X11 = 0x2 (bit 1 set)
    // bits [3:0] = 0x2 -> N=0, Z=0, C=1, V=0
    // mask=0b0010 -> update C only, N,Z preserved
    // Result: N=1, Z=1, C=1, V=0 = 0xE0000000
    mov x11, #0x2
    rmif x11, #0, #0b0010
    mrs x2, nzcv

    // Test 4: RMIF with mask=0b0001 (V only)
    // Previous NZCV = 0xE0000000 (N=1, Z=1, C=1)
    // X11 = 0x1 (bit 0 set)
    // bits [3:0] = 0x1 -> N=0, Z=0, C=0, V=1
    // mask=0b0001 -> update V only, N,Z,C preserved
    // Result: N=1, Z=1, C=1, V=1 = 0xF0000000
    mov x11, #0x1
    rmif x11, #0, #0b0001
    mrs x3, nzcv

    // Test 5: RMIF with mask=0b1111 (all flags)
    // X11 = 0xF (bits 3:0 all set)
    // bits [3:0] = 0xF -> N=1, Z=1, C=1, V=1
    // mask=0b1111 -> update all
    // Result: N=1, Z=1, C=1, V=1 = 0xF0000000
    mov x11, #0xF
    rmif x11, #0, #0b1111
    mrs x4, nzcv

    // Test 6: RMIF with rotation (lsb=4)
    // X11 = 0x30 (bits 5:4 set)
    // Rotate right by 4: 0x30 >> 4 = 0x3
    // bits [3:0] = 0x3 -> N=0, Z=0, C=1, V=1
    // mask=0b1111 -> update all
    // Result: N=0, Z=0, C=1, V=1 = 0x30000000
    mov x11, #0x30
    rmif x11, #4, #0b1111
    mrs x5, nzcv

    // Test 7: RMIF with mask=0 (preserve all)
    // Previous NZCV = 0x30000000
    // X11 = 0xF
    // mask=0 -> preserve all flags (no change)
    // Result: unchanged = 0x30000000
    mov x11, #0xF
    rmif x11, #0, #0b0000
    mrs x6, nzcv

    brk #0
