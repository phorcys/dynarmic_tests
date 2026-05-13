/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000001" }
}
*/
.text
.global _start
_start:
    mov r0, #0
    mov r1, #10
    mov r2, #5
    cmp r1, r2
    bgt greater
    mov r0, #10
greater:
    mov r0, #1
    bkpt #0
