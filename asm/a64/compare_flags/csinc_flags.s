/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002",
    "X1": "0x0000000000000006",
    "X2": "0x0000000000000006",
    "X3": "0x0000000000000002",
    "X4": "0x0000000000000002",
    "X5": "0x0000000000000006"
  }
}
*/
.text
.global _start
_start:
    // Set flags: N=0, Z=1, C=1, V=0
    // NZCV: N=bit31, Z=bit30, C=bit29, V=bit28
    // Z=1, C=1 -> 0x40000000 | 0x20000000 = 0x60000000
    mov x10, #0x60000000
    msr nzcv, x10

    // Test CSINC (Conditional Select Increment)
    // csinc xd, xn, xm, cond -> xd = cond ? xn : (xm + 1)
    mov x11, #2
    mov x12, #5

    // With N=0, Z=1, C=1, V=0:
    // EQ (Z==1): true -> Xd = Xn
    // NE (Z==0): false -> Xd = Xm + 1
    // MI (N==1): false -> Xd = Xm + 1
    // PL (N==0): true -> Xd = Xn
    // CS/HS (C==1): true -> Xd = Xn
    // CC/LO (C==0): false -> Xd = Xm + 1

    csinc x0, x11, x12, eq    // EQ true: x0 = 2
    csinc x1, x11, x12, ne    // NE false: x1 = 5+1 = 6
    csinc x2, x11, x12, mi    // MI false: x2 = 5+1 = 6
    csinc x3, x11, x12, pl    // PL true: x3 = 2
    csinc x4, x11, x12, cs    // CS true: x4 = 2
    csinc x5, x11, x12, cc    // CC false: x5 = 5+1 = 6

    brk #0