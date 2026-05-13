/* CONFIG
{
  "Match": "All",
  "QemuSkip": "This ADR/ADRP test assumes a fixed PC/image base that QEMU runner does not provide",
  "RegData": { 
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000014"
  }
}
*/
// ADR vs ADRP comparison test
// Both should give same result when target is within +/-1MB

.text
.global _start
_start:
    // ADR gives exact address
    adr x0, target
    
    // ADRP + ADD should give same result
    adrp x1, target
    add x1, x1, :lo12:target
    
    // X0 and X1 should be equal
    // Subtract X1 from X0 - result should be 0
    sub x0, x0, x1
    
    // X0 = 0 means ADRP+ADD matches ADR
    
    brk #0

target:
    nop
