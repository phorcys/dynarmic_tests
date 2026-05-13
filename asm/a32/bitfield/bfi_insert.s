/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x00003400",
    "R1": "0x00000034"
  }
}
*/
// Test: BFI - Bit Field Insert
// BFI Rd, Rn, #lsb, #width: Insert width bits from Rn into Rd starting at lsb

.text
.arm
.global _start
_start:
    @ Test: BFI - insert 8 bits at position 8
    mov r0, #0
    mov r1, #0x34
    bfi r0, r1, #8, #8      @ Insert 8 bits of r1 (0x34) into r0 at bit 8
    @ r0 = 0x3400
    
    @ r1 unchanged
    @ r1 = 0x34
    
    bkpt #0
