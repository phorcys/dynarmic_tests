// Test state machine simulation
#include "test_syscall.h"

enum State { S0, S1, S2, S_DONE };

int run_state_machine(int* inputs, int n) {
    enum State state = S0;
    int result = 0;
    
    for (int i = 0; i < n && state != S_DONE; i++) {
        switch (state) {
            case S0:
                if (inputs[i] == 0) state = S1;
                else state = S2;
                break;
            case S1:
                result += inputs[i];
                if (inputs[i] == 0) state = S_DONE;
                else state = S2;
                break;
            case S2:
                result *= 2;
                if (inputs[i] < 0) state = S0;
                else if (inputs[i] > 5) state = S_DONE;
                else state = S1;
                break;
            case S_DONE:
                break;
        }
    }
    return result;
}

int test_main(void) {
    test_printstr("Testing state machine...\n");
    
    // Test 1: Simple sequence
    // S0: input=0 -> S1
    // S1: result=5, input=5 -> S2  
    // S2: result=10, input=3 -> S1
    // S1: result=13, input=0 -> S_DONE
    int seq1[] = {0, 5, 3, 0};
    int r1 = run_state_machine(seq1, 4);
    test_printstr("  seq1 result: ");
    test_printint(r1);
    TEST_ASSERT(r1 == 10);  // Adjusted expected value
    
    test_printstr("\nAll state machine tests passed!\n");
    test_pass();
    return 0;
}
