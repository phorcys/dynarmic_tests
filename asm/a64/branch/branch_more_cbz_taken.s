/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000000A"
  }
}
*/
// CBZ taken

.text
.global _start
_start:
    mov x0, #0
    cbz x0, target
    mov x0, #5
    b done
    target:
    mov x0, #10
    done:
    brk #0
