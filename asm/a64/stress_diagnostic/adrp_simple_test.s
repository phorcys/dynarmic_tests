/* CONFIG
{
  "Match": "All",
  "QemuSkip": "This ADR/ADRP test assumes a fixed code base under the QEMU runner",
  "RegData": { 
    "X0": "0x000000000000000C",
    "X1": "0x0000000000000000"
  }
}
*/
// ADRP test - verify page address computation
// When PC=0, ADRP should return 0 for any target on same page

.text
.global _start
_start:
    // ADR gives exact address (should be 0x0C = 12)
    adr x0, target
    
    // ADRP gives page address (should be 0 since PC=0)
    adrp x1, target
    
    brk #0

target:
    nop
