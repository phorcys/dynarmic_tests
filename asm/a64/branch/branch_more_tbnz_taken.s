/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000000A"
  }
}
*/
// TBNZ taken

.text
.global _start
_start:
    mov x0, #2
    tbnz x0, #1, target  // bit 1 is set, taken
    mov x0, #5
    b done
    target:
    mov x0, #10
    done:
    brk #0
