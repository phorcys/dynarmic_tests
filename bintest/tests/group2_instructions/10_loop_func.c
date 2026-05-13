// Test loops with functions
#include "test_syscall.h"

int sum_to(int n) {
    int sum = 0;
    for (int i = 1; i <= n; i++) {
        sum += i;
    }
    return sum;
}

int factorial(int n) {
    int prod = 1;
    for (int i = 1; i <= n; i++) {
        prod *= i;
    }
    return prod;
}

int fibonacci(int n) {
    int a = 0, b = 1;
    for (int i = 0; i < n; i++) {
        int temp = a + b;
        a = b;
        b = temp;
    }
    return a;
}

int test_main(void) {
    test_printstr("Testing loops with functions...\n");
    
    // Test 1: Sum to n
    int r1 = sum_to(10);
    test_printstr("  sum_to(10): ");
    test_printint(r1);
    TEST_ASSERT(r1 == 55);
    
    // Test 2: Factorial
    int r2 = factorial(5);
    test_printstr("\n  5! = ");
    test_printint(r2);
    TEST_ASSERT(r2 == 120);
    
    // Test 3: While loop
    int count = 0, n = 10;
    while (n > 0) {
        count++;
        n--;
    }
    test_printstr("\n  while(10): ");
    test_printint(count);
    TEST_ASSERT(count == 10);
    
    // Test 4: Do-while
    int dw = 0;
    do {
        dw++;
    } while (dw < 5);
    test_printstr("\n  do-while: ");
    test_printint(dw);
    TEST_ASSERT(dw == 5);
    
    // Test 5: Break
    int sum = 0;
    for (int i = 0; i < 100; i++) {
        if (i == 5) break;
        sum += i;
    }
    test_printstr("\n  break: ");
    test_printint(sum);
    TEST_ASSERT(sum == 10);  // 0+1+2+3+4 = 10
    
    // Test 6: Continue
    sum = 0;
    for (int i = 0; i < 10; i++) {
        if (i % 2 == 0) continue;
        sum += i;
    }
    test_printstr("\n  continue: ");
    test_printint(sum);
    TEST_ASSERT(sum == 25);  // 1+3+5+7+9 = 25
    
    // Test 7: Fibonacci
    int r7 = fibonacci(10);
    test_printstr("\n  fib(10): ");
    test_printint(r7);
    TEST_ASSERT(r7 == 55);
    
    test_printstr("\nAll loop tests passed!\n");
    test_pass();
    return 0;
}