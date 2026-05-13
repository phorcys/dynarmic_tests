/* CONFIG
{
  "Match": "Partial",
  "RegData": {
    "X1": "0x0000000000000000",
    "X3": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: ADR - form PC-relative address
// ADR returns PC-relative addresses, we only verify that ADR works
// by checking the difference between addresses

.text
.global _start
_start:
    adr x0, label1     // x0 = address of label1
    mov x1, #0
label1:
    adr x2, label2     // x2 = address of label2
    mov x3, #0
label2:
    adr x4, label1     // x4 = address of label1 (same as x0)
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
