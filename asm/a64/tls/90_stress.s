/* CONFIG
{
  "Match": "All",
  "SvcTest": [
    {"svc": "17", "action": "write_tls", "offset": "0", "value": "0x0100000001000001"},
    {"svc": "16", "action": "read_tls", "offset": "0", "result_reg": "X2"},
    {"svc": "17", "action": "write_tls", "offset": "8", "value": "0x0200000002000002"},
    {"svc": "16", "action": "read_tls", "offset": "8", "result_reg": "X3"},
    {"svc": "17", "action": "write_tls", "offset": "16", "value": "0x0300000003000003"},
    {"svc": "16", "action": "read_tls", "offset": "16", "result_reg": "X4"},
    {"svc": "17", "action": "write_tls", "offset": "24", "value": "0x0400000004000004"},
    {"svc": "16", "action": "read_tls", "offset": "24", "result_reg": "X5"},
    {"svc": "17", "action": "write_tls", "offset": "32", "value": "0x0500000005000005"},
    {"svc": "16", "action": "read_tls", "offset": "32", "result_reg": "X6"},
    {"svc": "17", "action": "write_tls", "offset": "40", "value": "0x0600000006000006"},
    {"svc": "16", "action": "read_tls", "offset": "40", "result_reg": "X7"},
    {"svc": "17", "action": "write_tls", "offset": "48", "value": "0x0700000007000007"},
    {"svc": "16", "action": "read_tls", "offset": "48", "result_reg": "X8"},
    {"svc": "17", "action": "write_tls", "offset": "56", "value": "0x0800000008000008"},
    {"svc": "16", "action": "read_tls", "offset": "56", "result_reg": "X9"}
  ],
  "RegData": {
    "X0": "0x8",
    "X2": "0x0100000001000001",
    "X3": "0x0200000002000002",
    "X4": "0x0300000003000003",
    "X5": "0x0400000004000004",
    "X6": "0x0500000005000005",
    "X7": "0x0600000006000006",
    "X8": "0x0700000007000007",
    "X9": "0x0800000008000008"
  }
}
*/
// Test: Stress test - 16 consecutive SVC calls
// Tests TLS and SVC handling under load
.text
.global _start
_start:
    mov x0, #0
    
    // Round 1: write to offset 0, read back
    mov x1, #0
    svc #17
    mov x1, #0
    svc #16
    mov x2, x0
    
    // Round 2: write to offset 8, read back
    mov x1, #8
    svc #17
    mov x1, #8
    svc #16
    mov x3, x0
    
    // Round 3: write to offset 16, read back
    mov x1, #16
    svc #17
    mov x1, #16
    svc #16
    mov x4, x0
    
    // Round 4: write to offset 24, read back
    mov x1, #24
    svc #17
    mov x1, #24
    svc #16
    mov x5, x0
    
    // Round 5: write to offset 32, read back
    mov x1, #32
    svc #17
    mov x1, #32
    svc #16
    mov x6, x0
    
    // Round 6: write to offset 40, read back
    mov x1, #40
    svc #17
    mov x1, #40
    svc #16
    mov x7, x0
    
    // Round 7: write to offset 48, read back
    mov x1, #48
    svc #17
    mov x1, #48
    svc #16
    mov x8, x0
    
    // Round 8: write to offset 56, read back
    mov x1, #56
    svc #17
    mov x1, #56
    svc #16
    mov x9, x0
    
    // Success
    mov x0, #8
    
    brk #0