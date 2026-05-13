/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000100" }
}
*/
.text
.global _start
_start:
    mov r1, #128
    mov r2, #64
    qdadd r0, r1, r2
    bkpt #0
