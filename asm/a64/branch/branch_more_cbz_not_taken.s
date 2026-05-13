/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000005"
  }
}
*/
// CBZ not taken

.text
.global _start
_start:
    mov x0, #1
    cbz x0, target
    mov x0, #5
    b done
    target:
    mov x0, #10
    done:
    brk #0
