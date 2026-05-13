/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000109", "X1": "0x0000000000000002" }
}
*/
.text
.global _start
_start:
    // w0 = 0x109 = 0b0001_0000_1001, bit 1 is 0
    // TBZ w0, #1 should branch
    tbz w0, #1, bit_is_zero
    // If bit is 1, set X1 to 1 (wrong path)
    mov x1, #1
    b done
bit_is_zero:
    // If bit is 0, set X1 to 2 (correct path)
    mov x1, #2
done:
    brk #0
