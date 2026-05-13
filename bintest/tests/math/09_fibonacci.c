// Fibonacci Sequence Test
// Tests: Various methods to compute Fibonacci numbers
#include "test_syscall.h"

// Recursive (slow)
int fib_recursive(int n) {
    if (n <= 1) return n;
    return fib_recursive(n - 1) + fib_recursive(n - 2);
}

// Iterative (fast)
int fib_iterative(int n) {
    if (n <= 1) return n;
    
    int a = 0, b = 1;
    for (int i = 2; i <= n; i++) {
        int temp = a + b;
        a = b;
        b = temp;
    }
    return b;
}

// Matrix exponentiation (fastest)
void matrix_mult(int a[2][2], int b[2][2], int result[2][2]) {
    int temp[2][2];
    temp[0][0] = a[0][0] * b[0][0] + a[0][1] * b[1][0];
    temp[0][1] = a[0][0] * b[0][1] + a[0][1] * b[1][1];
    temp[1][0] = a[1][0] * b[0][0] + a[1][1] * b[1][0];
    temp[1][1] = a[1][0] * b[0][1] + a[1][1] * b[1][1];
    
    for (int i = 0; i < 2; i++)
        for (int j = 0; j < 2; j++)
            result[i][j] = temp[i][j];
}

int fib_matrix(int n) {
    if (n <= 1) return n;
    
    int result[2][2] = {{1, 0}, {0, 1}};
    int base[2][2] = {{1, 1}, {1, 0}};
    
    n--;
    while (n > 0) {
        if (n & 1) {
            matrix_mult(result, base, result);
        }
        matrix_mult(base, base, base);
        n >>= 1;
    }
    
    return result[0][0];
}

int test_main(void) {
    test_printstr("Testing Fibonacci...\n");
    
    // Test 1: First few Fibonacci numbers
    test_printstr("  first: ");
    TEST_ASSERT(fib_iterative(0) == 0);
    TEST_ASSERT(fib_iterative(1) == 1);
    TEST_ASSERT(fib_iterative(2) == 1);
    TEST_ASSERT(fib_iterative(3) == 2);
    TEST_ASSERT(fib_iterative(4) == 3);
    TEST_ASSERT(fib_iterative(5) == 5);
    test_printstr("OK\n");
    
    // Test 2: Iterative vs recursive match
    test_printstr("  match: ");
    int match = 1;
    for (int i = 0; i <= 15; i++) {
        if (fib_iterative(i) != fib_recursive(i)) match = 0;
    }
    TEST_ASSERT(match);
    test_printstr("OK\n");
    
    // Test 3: Matrix method matches
    test_printstr("  matrix: ");
    match = 1;
    for (int i = 0; i <= 20; i++) {
        if (fib_iterative(i) != fib_matrix(i)) match = 0;
    }
    TEST_ASSERT(match);
    test_printstr("OK\n");
    
    // Test 4: Larger Fibonacci numbers
    test_printstr("  large: ");
    // F(20) = 6765
    TEST_ASSERT(fib_iterative(20) == 6765);
    // F(25) = 75025
    TEST_ASSERT(fib_iterative(25) == 75025);
    test_printstr("OK\n");
    
    // Test 5: Specific values
    test_printstr("  values: ");
    TEST_ASSERT(fib_iterative(10) == 55);
    TEST_ASSERT(fib_iterative(15) == 610);
    test_printstr("OK\n");
    
    test_printstr("All Fibonacci tests passed!\n");
    test_pass();
    return 0;
}
