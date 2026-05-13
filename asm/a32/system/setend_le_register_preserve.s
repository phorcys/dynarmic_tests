/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000001", "R1": "0x00000002" }
}
*/
.text
.global _start
_start:
    setend le
    mov r0, #1
    mov r1, #2
    bkpt #0
