/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000000" },
  "VecData": {}
}
*/
.text
.global _start
_start:
    // UDIV 除以零返回 0
    mov x0, #100
    mov x1, #0
    udiv x0, x0, x1
    brk #0
