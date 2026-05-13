/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x0000000a" }
}
*/
.text
.global _start
_start:
    @ SEL: Select bytes based on GE bits
    @ SEL Rd, Rn, Rm - select bytes from Rn or Rm based on GE[3:0]
    mov r0, #0
    mov r1, #5
    mov r2, #10
    @ Set GE bits to all 0s (use Rm bytes)
    msr cpsr_f, #0
    sel r0, r1, r2
    bkpt #0
