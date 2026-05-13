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
    // 2. A following native FP operation accumulates new exception flags on top
    // Expect IOC(0) preset + DZC(1) from 1.0 / 0.0 => 0x3

    mov x5, #1
    msr fpsr, x5

    fmov s0, #1.0
    fmov s1, wzr
    fdiv s2, s0, s1

    mrs x0, fpsr
    and x0, x0, #0x1f

    brk #0
