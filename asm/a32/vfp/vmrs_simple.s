/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000" }
}
*/
.text
.global _start
_start:
    @ VMRS: Move from VFP System Register
    @ VMRS Rt, FPSCR
    
    mov r0, #0
    
    @ Read FPSCR (should be 0 by default)
    vmrs r0, fpscr
    and r0, r0, #0xFF000000 @ Keep only flags
    
    bkpt #0
.ltorg
