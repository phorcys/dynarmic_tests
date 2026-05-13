/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000000", "X1": "0x0000000000000000" }
}
*/
.text
.global _start
_start:
    // FPCR (Floating-point Control Register) test
    // FPSR (Floating-point Status Register) test

    // Read default FPCR value
    mrs x0, fpcr

    // Read default FPSR value
    mrs x1, fpsr

    brk #0