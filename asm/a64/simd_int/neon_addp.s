/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000005000000040000000300000002"
}
*/
// Test: NEON pairwise add - ADDP Vd.4S, Vn.4S, Vm.4S
// Add pairs of elements from two vectors

.text
.global _start
_start:
    // Create two vectors
    movi v0.4s, #1, lsl #0      // [1, 1, 1, 1]
    movi v1.4s, #2, lsl #0      // [2, 2, 2, 2]
    
    // Pairwise add: [1+1, 1+1, 2+2, 2+2] = [2, 2, 4, 4]? No...
    // ADDP adds adjacent pairs:
    // From v0: [1, 1, 1, 1], adjacent pairs: 1+1=2, 1+1=2
    // From v1: [2, 2, 2, 2], adjacent pairs: 2+2=4, 2+2=4
    // Result: [2, 2, 4, 4]
    // Wait, that doesn't match expected either...
    // Let me check the semantics again
    // ADDP Vd.T, Vn.T, Vm.T: 
    //   Vd[i] = Vn[2i] + Vn[2i+1] for i < T/2
    //   Vd[i+T/2] = Vm[2i] + Vm[2i+1] for i < T/2
    // So for 4S (4 x 32-bit elements):
    //   Vd[0] = Vn[0] + Vn[1] = 1 + 1 = 2
    //   Vd[1] = Vn[2] + Vn[3] = 1 + 1 = 2
    //   Vd[2] = Vm[0] + Vm[1] = 2 + 2 = 4
    //   Vd[3] = Vm[2] + Vm[3] = 2 + 2 = 4
    // Result: [2, 2, 4, 4]
    
    addp v0.4s, v0.4s, v1.4s
    
    // Hmm, expected shows [2, 3, 4, 5]... let me try different values

    brk #0
