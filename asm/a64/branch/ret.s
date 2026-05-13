/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000042"
  }
}
*/
// Test: RET - Return from subroutine

.text
.global _start
_start:
    bl func
    b done

func:
    mov x0, #0x42
    ret

done:
    brk #0
