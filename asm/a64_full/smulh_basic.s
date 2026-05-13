/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000000000000000"}
}
*/
.text
.global _start
_start:
    mov x1, #0x7FFFFFFFFFFFFFFF
    mov x2, #1
    smulh x0, x1, x2    // high 64 bits of 0x7FFF...FFFF * 1 = 0
    brk #0
