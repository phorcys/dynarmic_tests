// Minimal test - only set x8 and call SVC
// This isolates the x8 reading problem

.global _start
.text

_start:
    // Set x8 = 94 (SYS_EXIT_GROUP)
    mov x8, #94
    // Set x0 = 0 (success exit code)
    mov x0, #0
    // Call SVC
    svc #0
    // Should not reach here
    b .
