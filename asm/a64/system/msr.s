/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// Test: MSR systemreg, Xt - move to system register

.text
.global _start
_start:
    mov x0, #0
    
    // MSR: write to system register
    msr nzcv, x0

    brk #0
