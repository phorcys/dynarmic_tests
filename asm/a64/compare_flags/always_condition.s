/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000001",
    "X2": "0x0000000000000001",
    "X3": "0x0000000000000001"
  }
}
*/
.text
.global _start
_start:
    // Test AL (always) and NV (never/always)
    // AL always executes regardless of flags
    // NV is architecturally "always" in ARMv8

    mov x11, #1
    mov x12, #0

    // Test with all flags clear
    mov x10, #0x00000000
    msr nzcv, x10

    csel x0, x11, x12, al   // AL always true: x0 = 1
    csel x1, x11, x12, nv   // NV always true: x1 = 1

    // Test with all flags set
    mov x10, #0xF0000000
    msr nzcv, x10

    csel x2, x11, x12, al   // AL always true: x2 = 1
    csel x3, x11, x12, nv   // NV always true: x3 = 1

    brk #0