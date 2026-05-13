/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000002A",
    "R2": "0x00000001"
  }
}
*/
.text
.arm
.global _start
_start:
    ldr r1, =func
    blx r1
    bkpt #0

func:
    mov r0, #42
    mov r2, #1
    bx lr
.align 4
func_addr: .word func
