/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// Test: BLR - Branch with Link to Register

.text
.global _start
_start:
    adr x1, target
    blr x1
    
    // Should not reach here
    mov x0, #0
    b done

target:
    mov x0, #1
done:
    brk #0
