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
    // Safe-mode DN check for native vector arithmetic.
    // FPCR.DN=1 should force vector arithmetic NaN results to default NaN.

    mrs x9, fpcr
    orr x10, x9, #(1 << 25)   // DN = 1
    msr fpcr, x10

    ldr w0, =0x7FC12345       // non-default quiet NaN payload
    fmov s0, w0
    dup v0.4s, v0.s[0]
    fmov s1, #1.0
    dup v1.4s, v1.s[0]
    fadd v2.4s, v0.4s, v1.4s
    umov w0, v2.s[0]

    msr fpcr, x9

    brk #0
