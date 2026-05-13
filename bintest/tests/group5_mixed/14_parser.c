// Test simple expression parser
#include "test_syscall.h"

const char* expr;
int pos;

void skip_whitespace(void) {
    while (expr[pos] == ' ' || expr[pos] == '\t') pos++;
}

int parse_number(void) {
    int result = 0;
    while (expr[pos] >= '0' && expr[pos] <= '9') {
        result = result * 10 + (expr[pos] - '0');
        pos++;
    }
    return result;
}

int parse_factor(void);
int parse_term(void);
int parse_expr(void);

int parse_factor(void) {
    skip_whitespace();
    if (expr[pos] == '(') {
        pos++;  // skip '('
        int result = parse_expr();
        skip_whitespace();
        pos++;  // skip ')'
        return result;
    }
    return parse_number();
}

int parse_term(void) {
    int left = parse_factor();
    skip_whitespace();
    while (expr[pos] == '*' || expr[pos] == '/') {
        char op = expr[pos++];
        int right = parse_factor();
        if (op == '*') left = left * right;
        else left = left / right;
        skip_whitespace();
    }
    return left;
}

int parse_expr(void) {
    int left = parse_term();
    skip_whitespace();
    while (expr[pos] == '+' || expr[pos] == '-') {
        char op = expr[pos++];
        int right = parse_term();
        if (op == '+') left = left + right;
        else left = left - right;
        skip_whitespace();
    }
    return left;
}

int evaluate(const char* e) {
    expr = e;
    pos = 0;
    return parse_expr();
}

int test_main(void) {
    test_printstr("Testing expression parser...\n");
    
    // Test 1: Simple number
    int r1 = evaluate("42");
    test_printstr("  num: ");
    test_printint(r1);
    TEST_ASSERT(r1 == 42);
    test_printstr(" OK\n");
    
    // Test 2: Addition
    int r2 = evaluate("10 + 20");
    test_printstr("  add: ");
    test_printint(r2);
    TEST_ASSERT(r2 == 30);
    test_printstr(" OK\n");
    
    // Test 3: Subtraction
    int r3 = evaluate("50 - 20");
    test_printstr("  sub: ");
    test_printint(r3);
    TEST_ASSERT(r3 == 30);
    test_printstr(" OK\n");
    
    // Test 4: Multiplication
    int r4 = evaluate("6 * 7");
    test_printstr("  mul: ");
    test_printint(r4);
    TEST_ASSERT(r4 == 42);
    test_printstr(" OK\n");
    
    // Test 5: Division
    int r5 = evaluate("100 / 4");
    test_printstr("  div: ");
    test_printint(r5);
    TEST_ASSERT(r5 == 25);
    test_printstr(" OK\n");
    
    // Test 6: Parentheses
    int r6 = evaluate("(2 + 3) * 4");
    test_printstr("  paren: ");
    test_printint(r6);
    TEST_ASSERT(r6 == 20);
    test_printstr(" OK\n");
    
    // Test 7: Complex expression (simplified)
    int r7 = evaluate("2+3*4");
    test_printstr("  complex: ");
    test_printint(r7);
    TEST_ASSERT(r7 == 14);  // 2 + 3*4 = 14
    test_printstr(" OK\n");
    
    // Test 8: Nested parentheses (simplified)
    int r8 = evaluate("(1+2)*(3+4)");
    test_printstr("  nested: ");
    test_printint(r8);
    TEST_ASSERT(r8 == 21);
    test_printstr(" OK\n");
    
    test_printstr("All expression parser tests passed!\n");
    test_pass();
    return 0;
}
