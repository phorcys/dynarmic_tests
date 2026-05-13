/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x0000002A"
  }
}
*/
.text
.arm
.global _start
_start:
    ldr r1, =target
    bx r1
    mov r0, #0
target:
    mov r0, #42
    bkpt #0
.align 4
target_addr: .word target
