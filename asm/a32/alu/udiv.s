/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "R0": "0x00000002"
  }
}
*/
.text
.global _start
_start:
    // UDIV: Unsigned division
    // 10 / 4 = 2 (truncated)
    mov r0, #10
    mov r1, #4
    udiv r0, r0, r1
    
    bkpt #0
