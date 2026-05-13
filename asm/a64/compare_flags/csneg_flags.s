/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002",
    "X1": "0xFFFFFFFFFFFFFFFB",
    "X2": "0xFFFFFFFFFFFFFFFB",
    "X3": "0x0000000000000002",
    "X4": "0x0000000000000002",
    "X5": "0xFFFFFFFFFFFFFFFB"
  }
}
*/
.text
.global _start
_start:
    // Set flags: N=0, Z=1, C=1, V=0
    mov x10, #0x60000000
    msr nzcv, x10

    // Test CSNEG (Conditional Select Negate)
    // csneg xd, xn, xm, cond -> xd = cond ? xn : -xm
    mov x11, #2
    mov x12, #5

    // -5 = 0xFFFFFFFFFFFFFFFB (in 64-bit two's complement)
    // With N=0, Z=1, C=1, V=0:
    // EQ (Z==1): true -> Xd = Xn
    // NE (Z==0): false -> Xd = -Xm
    // MI (N==1): false -> Xd = -Xm
    // PL (N==0): true -> Xd = Xn
    // CS/HS (C==1): true -> Xd = Xn
    // CC/LO (C==0): false -> Xd = -Xm

    csneg x0, x11, x12, eq    // EQ true: x0 = 2
    csneg x1, x11, x12, ne    // NE false: x1 = -5 = 0xFB...FB
    csneg x2, x11, x12, mi    // MI false: x2 = -5 = 0xFB...FB
    csneg x3, x11, x12, pl    // PL true: x3 = 2
    csneg x4, x11, x12, cs    // CS true: x4 = 2
    csneg x5, x11, x12, cc    // CC false: x5 = -5 = 0xFB...FB

    brk #0
