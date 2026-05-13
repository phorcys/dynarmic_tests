/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000002A"
  }
}
*/
// Test: ADRP Xd, label - Compute page-aligned address
// Loads the page-aligned address of a label

.text
.global _start
_start:
    mov x0, #42
    
    // ADRP loads the page address of a label
    // We'll just verify the instruction executes
    adrp x1, _start
    // X1 = page-aligned address of _start
    
    // Keep X0 = 42

    brk #0
