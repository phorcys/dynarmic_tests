/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x00000000000000AA" }
}
*/
.text
.global _start
_start:
    // Execute code from computed address test

    // Branch to computed address
    adr x4, target_code
    blr x4                  // Call target_code

    // x0 should be 0xAA now

    brk #0

target_code:
    mov x0, #0xAA
    ret