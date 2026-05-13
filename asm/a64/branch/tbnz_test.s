/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000109", "X1": "0x0000000000000001" }
}
*/
.text
.global _start
_start:
    // w0 = 0x109 = 0b0001_0000_1001
    // bit 0 = 1, bit 1 = 0, bit 3 = 1, bit 8 = 1
    // TBNZ w0, #0 should branch (bit 0 = 1)
    tbnz w0, #0, bit_is_one
    // If bit is 0, set X1 to 2 (wrong path)
    mov x1, #2
    b done
bit_is_one:
    // If bit is 1, set X1 to 1 (correct path)
    mov x1, #1
done:
    brk #0
