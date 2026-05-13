/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000001", "R1": "0x00000002" }
}
*/
.text
.global _start
_start:
    // RSB: Reverse Subtract
    // R0 = R1 - R0 (in reversed order)
    mov r0, #1
    mov r1, #2
    rsb r0, r0, r1   @ R0 = R1 - R0 = 2 - 1 = 1
    bkpt #0