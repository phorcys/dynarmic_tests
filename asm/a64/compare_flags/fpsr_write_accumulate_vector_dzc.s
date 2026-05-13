/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000003" }
}
*/
.text
.global _start
_start:
    // Verify that:
    // 1. MSR FPSR writes architectural FPSR state
    // 2. A following native vector FP operation accumulates new exception flags on top
    // Expect IOC(0) preset + DZC(1) from vector 1.0 / 0.0 => 0x3

    mov x5, #1
    msr fpsr, x5

    fmov s0, #1.0
    dup v0.4s, v0.s[0]
    dup v1.4s, wzr
    fdiv v2.4s, v0.4s, v1.4s

    mrs x0, fpsr
    and x0, x0, #0x1f

    brk #0
