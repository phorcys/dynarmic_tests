/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x00000000", "R1": "0x00000020", "R2": "0x00000010" }
}
*/
.text
.global _start
_start:
    // CLZ: Count Leading Zeros
    // CLZ counts the number of leading zeros in a register
    
    // Test 1: Value with MSB set (no leading zeros)
    ldr r3, =0x80000000
    clz r0, r3           // R0 = 0
    
    // Test 2: Value with all zeros (32 leading zeros)
    mov r3, #0
    clz r1, r3           // R1 = 32
    
    // Test 3: Value with 16 leading zeros
    ldr r3, =0x00008000
    clz r2, r3           // R2 = 16
    
    bkpt #0

.pool
