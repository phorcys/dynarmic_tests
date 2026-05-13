/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000000080000001"}
}
*/
.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    add x0, x0, x1, lsl #31  // 1 + (1 << 31) = 0x80000001
    brk #0
