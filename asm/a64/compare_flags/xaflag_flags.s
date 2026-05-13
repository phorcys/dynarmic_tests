/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x80000000",
    "X1": "0x80000000",
    "X2": "0x20000000",
    "X3": "0x20000000",
    "X4": "0x30000000",
    "X5": "0x30000000",
    "X6": "0x60000000",
    "X7": "0x60000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // XAFlag - Convert x86 EFLAGS to ARM NZCV
    // 
    // x86 EFLAGS format in NZCV (N=0 case):
    // Bits [3:0] of NZCV represent: OF, SF, ZF, CF (x86 style)
    // 
    // Conversion to ARM NZCV:
    // ARM_N = x86_SF (sign flag)
    // ARM_Z = x86_ZF (zero flag)  
    // ARM_C = x86_CF (carry flag)
    // ARM_V = x86_OF (overflow flag)
    //
    // Note: Only N=0 cases are valid for XAFlag
    // N=1 is CONSTRAINED UNPREDICTABLE
    // ========================================

    // Test 0: NZCV = 0x00000000 (OF=0, SF=0, ZF=0, CF=0)
    // x86: no flags set
    // ARM: N=1 (SF=0, but XAFlag inverts SF for "less than" case)
    // Actually from QEMU: 0x00000000 -> 0x80000000
    msr nzcv, xzr
    xaflag
    mrs x0, nzcv              // QEMU: 0x80000000

    // Test 1: NZCV = 0x10000000 (V=1 in ARM, but OF bit position in x86)
    msr nzcv, xzr
    mov x20, #0x10000000
    msr nzcv, x20
    xaflag
    mrs x1, nzcv              // QEMU: 0x80000000

    // Test 2: NZCV = 0x20000000 (C=1 in ARM, CF in x86)
    msr nzcv, xzr
    mov x20, #0x20000000
    msr nzcv, x20
    xaflag
    mrs x2, nzcv              // QEMU: 0x20000000

    // Test 3: NZCV = 0x30000000 (C=1, V=1 in ARM)
    msr nzcv, xzr
    mov x20, #0x30000000
    msr nzcv, x20
    xaflag
    mrs x3, nzcv              // QEMU: 0x20000000

    // Test 4: NZCV = 0x40000000 (Z=1 in ARM, ZF in x86)
    msr nzcv, xzr
    mov x20, #0x40000000
    msr nzcv, x20
    xaflag
    mrs x4, nzcv              // QEMU: 0x30000000

    // Test 5: NZCV = 0x50000000 (Z=1, V=1)
    msr nzcv, xzr
    mov x20, #0x50000000
    msr nzcv, x20
    xaflag
    mrs x5, nzcv              // QEMU: 0x30000000

    // Test 6: NZCV = 0x60000000 (Z=1, C=1)
    msr nzcv, xzr
    mov x20, #0x60000000
    msr nzcv, x20
    xaflag
    mrs x6, nzcv              // QEMU: 0x60000000

    // Test 7: NZCV = 0x70000000 (Z=1, C=1, V=1)
    msr nzcv, xzr
    mov x20, #0x70000000
    msr nzcv, x20
    xaflag
    mrs x7, nzcv              // QEMU: 0x60000000

    brk #0
