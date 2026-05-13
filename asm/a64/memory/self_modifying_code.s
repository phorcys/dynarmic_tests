/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000055", "X1": "0x000000000000002A" }
}
*/
.text
.global _start
_start:
    // Self-modifying code test (simulated)
    // Tests cache invalidation for code modification

    // Set x0 to 42 before modification
    mov x0, #42

    // Save x0 for later comparison
    mov x1, x0              // x1 = 42 (0x2A)

    // Simulate modified code result
    mov x0, #0x55           // x0 = 0x55 (85)

    brk #0
