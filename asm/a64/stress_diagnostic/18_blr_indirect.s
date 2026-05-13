/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000023",
    "X1": "0x0000000000000003"
  }
}
*/
// Test: BLR - indirect call through register
// Use adr instead of ldr for address loading

.text
.global _start
_start:
    mov x0, #10
    adr x2, target_func
    blr x2           // call target_func
    brk #0

target_func:
    add x0, x0, #25  // x0 = 10 + 25 = 35
    mov x1, #3       // side effect
    ret
