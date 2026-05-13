/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0xFFFFFFFFFFFFFF80"}
}
*/
.text
.global _start
_start:
    mov x0, #0
    mov x1, #0x80
    add x0, x0, x1, sxtb  // 0 + sign_extend(0x80) = 0 + (-128) = -128
    brk #0
