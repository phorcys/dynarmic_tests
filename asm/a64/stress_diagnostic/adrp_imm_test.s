/* CONFIG
{
  "Match": "All",
  "QemuSkip": "This ADRP immediate test assumes PC/page base zero, which the QEMU runner does not guarantee",
  "RegData": { 
    "X0": "0x0000000000000000"
  }
}
*/
// ADRP immediate value test
// Tests if ADRP correctly computes page-aligned address for the current page
// At PC=0, ADRP with imm=0 should return (PC & ~0xFFF) = 0

.text
.global _start
_start:
    // ADRP X0, _start computes the page of _start
    // Since _start is at address 0, and 0 is page-aligned,
    // ADRP should return 0
    adrp x0, _start
    // X0 should be 0x0000000000000000
    
    brk #0
