// Stack Data Structure Test
// Tests: Stack push, pop, peek operations
#include "test_syscall.h"

#define STACK_SIZE 50

static int stack[STACK_SIZE];
static int stack_top = 0;

void stack_init(void) {
    stack_top = 0;
}

int stack_push(int val) {
    if (stack_top >= STACK_SIZE) return 0;
    stack[stack_top++] = val;
    return 1;
}

int stack_pop(void) {
    if (stack_top <= 0) return -1;
    return stack[--stack_top];
}

int stack_peek(void) {
    if (stack_top <= 0) return -1;
    return stack[stack_top - 1];
}

int stack_empty(void) {
    return stack_top == 0;
}

int stack_size(void) {
    return stack_top;
}

int test_main(void) {
    test_printstr("Testing Stack...\n");
    
    // Test 1: Push and pop
    stack_init();
    stack_push(1);
    stack_push(2);
    stack_push(3);
    
    test_printstr("  basic: ");
    TEST_ASSERT(stack_pop() == 3);
    TEST_ASSERT(stack_pop() == 2);
    TEST_ASSERT(stack_pop() == 1);
    test_printstr("OK\n");
    
    // Test 2: Peek
    stack_init();
    stack_push(10);
    stack_push(20);
    
    test_printstr("  peek: ");
    TEST_ASSERT(stack_peek() == 20);
    TEST_ASSERT(stack_size() == 2);  // Peek shouldn't remove
    test_printstr("OK\n");
    
    // Test 3: Empty stack
    stack_init();
    
    test_printstr("  empty: ");
    TEST_ASSERT(stack_empty());
    TEST_ASSERT(stack_pop() == -1);
    TEST_ASSERT(stack_peek() == -1);
    test_printstr("OK\n");
    
    // Test 4: LIFO order
    stack_init();
    for (int i = 1; i <= 5; i++) {
        stack_push(i);
    }
    
    test_printstr("  lifo: ");
    int correct = 1;
    for (int i = 5; i >= 1; i--) {
        if (stack_pop() != i) correct = 0;
    }
    TEST_ASSERT(correct);
    test_printstr("OK\n");
    
    // Test 5: Size tracking
    stack_init();
    TEST_ASSERT(stack_size() == 0);
    stack_push(1);
    TEST_ASSERT(stack_size() == 1);
    stack_push(2);
    TEST_ASSERT(stack_size() == 2);
    stack_pop();
    TEST_ASSERT(stack_size() == 1);
    stack_pop();
    TEST_ASSERT(stack_size() == 0);
    
    test_printstr("  size: ");
    test_printstr("OK\n");
    
    // Test 6: Use case: reverse sequence
    stack_init();
    int arr[] = {1, 2, 3, 4, 5};
    for (int i = 0; i < 5; i++) stack_push(arr[i]);
    
    test_printstr("  reverse: ");
    int reversed[5];
    for (int i = 0; i < 5; i++) reversed[i] = stack_pop();
    TEST_ASSERT(reversed[0] == 5 && reversed[4] == 1);
    test_printstr("OK\n");
    
    test_printstr("All Stack tests passed!\n");
    test_pass();
    return 0;
}
