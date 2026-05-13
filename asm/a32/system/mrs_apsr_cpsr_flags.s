/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x80000010", "R1": "0x80000010" }
}
*/
.text
.global _start
_start:
    @ MRS: read APSR/CPSR after flag-producing arithmetic
    @ Set N flag (bit 31) by subtracting 1 from 0
    subs r2, r2, #1
    @ Read APSR (user-visible part of CPSR)
    mrs r0, apsr
    @ Also test reading CPSR (same as APSR in user mode)
    mrs r1, cpsr
    bkpt #0
.ltorg
