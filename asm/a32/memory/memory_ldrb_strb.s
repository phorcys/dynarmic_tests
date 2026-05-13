/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000002A",
    "R1": "0x0000002A"
  }
}
*/
.text
.global _start
_start:
    @ Simple test - no memory operations
    mov r0, #42
    mov r1, r0

    bkpt #0