/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000007FC00000"
  }
}
*/
.text
.global _start
_start:
    // Safe-mode DN check:
    // FPCR.DN=1 should force arithmetic NaN results to default NaN.
    // Use a non-default quiet NaN payload as input and verify FADD returns 0x7FC00000.

    mrs x9, fpcr
    orr x10, x9, #(1 << 25)   // DN = 1
    msr fpcr, x10

    ldr w0, =0x7FC12345       // non-default quiet NaN payload
    fmov s0, w0
    fmov s1, #1.0
    fadd s2, s0, s1
    fmov w0, s2

    msr fpcr, x9

    brk #0
