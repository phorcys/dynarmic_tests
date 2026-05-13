/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000000080000000"}
}
*/
.text
.global _start
_start:
    mov x0, #0
    subs x0, x0, #1     // 0 - 1 = -1, N=1, C=0 (borrow), Z=0, V=0
    mrs x0, nzcv        // N=1 -> 0x80000000
    brk #0
