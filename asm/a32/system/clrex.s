/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00000001"
  }
}
*/
.text
.global _start
_start:
    // CLREX: Clear Exclusive
    // Clears the local exclusive monitor
    // This is mostly for testing that the instruction executes without fault
    clrex
    mov r0, #1
    bkpt #0
