/* CONFIG
{
  "Match": "All",
  "QemuSkip": "This ADRP test assumes PC/page base zero, which the QEMU runner does not guarantee",
  "RegData": { 
    "X0": "0x0000000000000000"
  }
}
*/
// ADRP immediate value test
// Tests if ADRP correctly computes page-aligned address
// This test uses a known offset within same page

.text
.global _start
_start:
    // At PC=0, ADRP should compute: (PC & ~0xFFF) + (imm << 12)
    // Since PC=0, the result should just be imm << 12
    
    // ADRP x0, _start with PC=0
    // imm = 0 (same page)
    // Result should be: (0 & ~0xFFF) + (0 << 12) = 0
    adrp x0, _start
    
    brk #0
