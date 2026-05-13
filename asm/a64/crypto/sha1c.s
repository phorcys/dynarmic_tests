/* CONFIG
{
  "Match": "All",
  "Q0": "0x9efc9abcfa375c2187c427beac0110e9"
}
*/
// Test: SHA1C Qd, Sn, Vm.4S - SHA1 hash update (choose)

.text
.global _start
_start:
    // Initialize test data
    mov w0, #0x1234
    movk w0, #0x5678, lsl #16
    mov v0.s[0], w0
    mov v0.s[1], w0
    mov v0.s[2], w0
    mov v0.s[3], w0
    
    mov v1.16b, v0.16b
    
    // SHA1C: SHA1 hash update choose
    sha1c q0, s1, v2.4s
    
    brk #0
