/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000A",
    "X1": "0x0000000020000000",
    "X2": "0x0000000080000000"
  }
}
*/
.text
.global _start
_start:
    mov x0, #10
    cmp x0, #5
    mrs x1, nzcv     // Should be 0x20000000
    
    // Now use CCMP
    ccmp x0, #15, #0, gt
    mrs x2, nzcv     // Should be 0x80000000
    brk #0
