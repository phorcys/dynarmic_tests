// Test stack-based virtual machine
#include "test_syscall.h"

#define STACK_SIZE 64

int stack[STACK_SIZE];
int sp = 0;

void push(int val) {
    stack[sp++] = val;
}

int pop(void) {
    return stack[--sp];
}

// Opcodes
#define OP_PUSH  1
#define OP_ADD   2
#define OP_SUB   3
#define OP_MUL   4
#define OP_DIV   5
#define OP_DUP   6
#define OP_SWAP  7
#define OP_OVER  8
#define OP_ROT   9
#define OP_DROP  10
#define OP_NEG   11
#define OP_MOD   12
#define OP_HALT  0

int run_vm(unsigned char* program, int prog_len) {
    sp = 0;
    int pc = 0;
    
    while (pc < prog_len) {
        unsigned char op = program[pc++];
        
        switch (op) {
            case OP_PUSH:
                push(program[pc++]);
                break;
            case OP_ADD: {
                int b = pop();
                int a = pop();
                push(a + b);
                break;
            }
            case OP_SUB: {
                int b = pop();
                int a = pop();
                push(a - b);
                break;
            }
            case OP_MUL: {
                int b = pop();
                int a = pop();
                push(a * b);
                break;
            }
            case OP_DIV: {
                int b = pop();
                int a = pop();
                push(a / b);
                break;
            }
            case OP_DUP:
                push(stack[sp - 1]);
                break;
            case OP_SWAP: {
                int a = pop();
                int b = pop();
                push(a);
                push(b);
                break;
            }
            case OP_OVER:
                push(stack[sp - 2]);
                break;
            case OP_ROT: {
                int c = pop();
                int b = pop();
                int a = pop();
                push(b);
                push(c);
                push(a);
                break;
            }
            case OP_DROP:
                pop();
                break;
            case OP_NEG:
                stack[sp - 1] = -stack[sp - 1];
                break;
            case OP_MOD: {
                int b = pop();
                int a = pop();
                push(a % b);
                break;
            }
            case OP_HALT:
                return pop();
        }
    }
    return sp > 0 ? pop() : 0;
}

int test_main(void) {
    test_printstr("Testing stack VM...\n");
    
    // Test 1: Push and halt
    unsigned char prog1[] = {OP_PUSH, 42, OP_HALT};
    int r1 = run_vm(prog1, 3);
    test_printstr("  push: ");
    test_printint(r1);
    TEST_ASSERT(r1 == 42);
    test_printstr(" OK\n");
    
    // Test 2: Addition
    unsigned char prog2[] = {OP_PUSH, 10, OP_PUSH, 20, OP_ADD, OP_HALT};
    int r2 = run_vm(prog2, 6);
    test_printstr("  add: ");
    test_printint(r2);
    TEST_ASSERT(r2 == 30);
    test_printstr(" OK\n");
    
    // Test 3: Multiplication
    unsigned char prog3[] = {OP_PUSH, 6, OP_PUSH, 7, OP_MUL, OP_HALT};
    int r3 = run_vm(prog3, 6);
    test_printstr("  mul: ");
    test_printint(r3);
    TEST_ASSERT(r3 == 42);
    test_printstr(" OK\n");
    
    // Test 4: Complex calculation (2 + 3) * 4
    unsigned char prog4[] = {
        OP_PUSH, 2, OP_PUSH, 3, OP_ADD,
        OP_PUSH, 4, OP_MUL, OP_HALT
    };
    int r4 = run_vm(prog4, 9);
    test_printstr("  calc: ");
    test_printint(r4);
    TEST_ASSERT(r4 == 20);
    test_printstr(" OK\n");
    
    // Test 5: Dup and swap
    unsigned char prog5[] = {
        OP_PUSH, 5, OP_DUP, OP_MUL,  // 5 * 5 = 25
        OP_HALT
    };
    int r5 = run_vm(prog5, 5);
    test_printstr("  dup: ");
    test_printint(r5);
    TEST_ASSERT(r5 == 25);
    test_printstr(" OK\n");
    
    // Test 6: Negate
    unsigned char prog6[] = {OP_PUSH, 10, OP_NEG, OP_HALT};
    int r6 = run_vm(prog6, 4);
    test_printstr("  neg: ");
    test_printint(r6);
    TEST_ASSERT(r6 == -10);
    test_printstr(" OK\n");
    
    // Test 7: Factorial 5! = 120
    // Stack: [5, acc=1]
    // Loop: acc = acc * n; n = n - 1; while n > 0
    // Simplified: 5 * 4 * 3 * 2 * 1
    unsigned char prog7[] = {
        OP_PUSH, 5, OP_PUSH, 4, OP_MUL,
        OP_PUSH, 3, OP_MUL,
        OP_PUSH, 2, OP_MUL,
        OP_PUSH, 1, OP_MUL,
        OP_HALT
    };
    int r7 = run_vm(prog7, 15);
    test_printstr("  fact: ");
    test_printint(r7);
    TEST_ASSERT(r7 == 120);
    test_printstr(" OK\n");
    
    test_printstr("All stack VM tests passed!\n");
    test_pass();
    return 0;
}
