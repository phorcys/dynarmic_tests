// Test jump table and switch patterns
#include "test_syscall.h"

int classify_char(char c) {
    switch (c) {
        case 'a': case 'e': case 'i': case 'o': case 'u':
        case 'A': case 'E': case 'I': case 'O': case 'U':
            return 1;  // vowel
        case '0': case '1': case '2': case '3': case '4':
        case '5': case '6': case '7': case '8': case '9':
            return 2;  // digit
        case ' ': case '\t': case '\n':
            return 3;  // whitespace
        default:
            if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))
                return 4;  // consonant
            return 0;  // other
    }
}

int day_of_week(int d) {
    switch (d) {
        case 0: return 0;  // Sunday
        case 1: return 1;  // Monday
        case 2: return 2;  // Tuesday
        case 3: return 3;  // Wednesday
        case 4: return 4;  // Thursday
        case 5: return 5;  // Friday
        case 6: return 6;  // Saturday
        default: return -1;
    }
}

int operation(int op, int a, int b) {
    switch (op) {
        case 0: return a + b;
        case 1: return a - b;
        case 2: return a * b;
        case 3: return a / b;
        case 4: return a % b;
        case 5: return (a > b) ? a : b;
        case 6: return (a < b) ? a : b;
        default: return 0;
    }
}

int nested_switch(int a, int b) {
    switch (a) {
        case 0:
            switch (b) {
                case 0: return 0;
                case 1: return 1;
                default: return 2;
            }
        case 1:
            switch (b) {
                case 0: return 10;
                case 1: return 11;
                default: return 12;
            }
        default:
            return 99;
    }
}

int test_main(void) {
    test_printstr("Testing jump tables...\n");
    
    // Test 1: Char classification
    TEST_ASSERT(classify_char('a') == 1);
    TEST_ASSERT(classify_char('E') == 1);
    TEST_ASSERT(classify_char('z') == 4);
    TEST_ASSERT(classify_char('5') == 2);
    TEST_ASSERT(classify_char(' ') == 3);
    test_printstr("  char class: OK\n");
    
    // Test 2: Day of week
    TEST_ASSERT(day_of_week(0) == 0);
    TEST_ASSERT(day_of_week(3) == 3);
    TEST_ASSERT(day_of_week(6) == 6);
    TEST_ASSERT(day_of_week(7) == -1);
    test_printstr("  day_of_week: OK\n");
    
    // Test 3: Operation dispatcher
    int r = operation(0, 10, 5);
    test_printstr("  op(ADD, 10, 5) = ");
    test_printint(r);
    TEST_ASSERT(r == 15);
    
    r = operation(2, 6, 7);
    test_printstr("\n  op(MUL, 6, 7) = ");
    test_printint(r);
    TEST_ASSERT(r == 42);
    
    r = operation(5, 10, 20);
    test_printstr("\n  op(MAX, 10, 20) = ");
    test_printint(r);
    TEST_ASSERT(r == 20);
    
    // Test 4: Nested switch
    r = nested_switch(0, 1);
    test_printstr("\n  nested(0,1) = ");
    test_printint(r);
    TEST_ASSERT(r == 1);
    
    r = nested_switch(1, 0);
    test_printstr("\n  nested(1,0) = ");
    test_printint(r);
    TEST_ASSERT(r == 10);
    
    test_printstr("\nAll jump table tests passed!\n");
    test_pass();
    return 0;
}
