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
    // Safe-mode DN check for fused scalar arithmetic.
    // FPCR.DN=1 should force a NaN result to default NaN even when FMADD
    // receives a non-default quiet NaN payload.

    mrs x9, fpcr
    orr x10, x9, #(1 << 25)   // DN = 1
    msr fpcr, x10

    ldr w0, =0x7FC12345       // non-default quiet NaN payload
    fmov s0, w0
    fmov s1, #2.0
    fmov s2, #1.0
    fmadd s3, s0, s1, s2
    fmov w0, s3

    msr fpcr, x9

    brk #0
