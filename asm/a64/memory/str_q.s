/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000010000000000000001",
    "Q1": "0x00000000000000010000000000000001"
  }
}
*/
// Test: STR Q register - store 128-bit vector to memory using stack

.text
.global _start
_start:
    // Create vector using MOV
    mov x0, #1
    mov v0.d[0], x0
    mov v0.d[1], x0
    
    // Store to stack
    str q0, [sp, #-16]!
    
    // Load back to Q1 to verify
    ldr q1, [sp]

    brk #0
