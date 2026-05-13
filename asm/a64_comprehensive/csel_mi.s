/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000000000000xBB"}
}
*/
.text
.global _start
_start:
    mov x0, #0xAA
    mov x1, #0xBB
    cmp xzr, xzr        // Z=1, C=1, N=0, V=0
    csel x0, x0, x1, mi
    brk #0
