/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000", "R1": "0x00000000" }
}
*/
.text
.global _start
_start:
    @ MRRC: Move to two registers from coprocessor
    @ This is for reading VFP registers
    
    @ VMRS: Move from VFP system register to ARM register
    @ Read FPSCR (VFP status/control register)
    
    @ First clear FPSCR
    mov r0, #0
    vmsr fpscr, r0
    
    @ Read it back
    vmrs r0, fpscr
    
    bkpt #0
