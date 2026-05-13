/* CONFIG
{
  "Match": "All",
  "RegData": {
    "W19": "0x00000109",
    "X0": "0x0000000000000001"
  }
}
*/
// Test: TBZ with w19=0x109, bit 1 should be 0, so branch should be taken

.text
.global _start
_start:
    mov w19, #0x109      // w19 = 0x109 = 0b0001_0000_1001, bit 1 = 0
    
    // Test TBZ - should branch because bit 1 is 0
    tbz w19, #1, target_taken
    
    // This should be skipped
    mov x0, #0
    b done

target_taken:
    mov x0, #1      // x0 = 1 if TBZ worked correctly

done:
    brk #0
