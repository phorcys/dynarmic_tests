/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x1"
  }
}
*/
// Test: Read TPIDR_EL0 and verify it's non-zero (TLS base address)
.text
.global _start
_start:
    mrs x0, tpidr_el0
    cmp x0, #0
    cset x0, ne      // X0 = 1 if TPIDR_EL0 is non-zero
    brk #0
