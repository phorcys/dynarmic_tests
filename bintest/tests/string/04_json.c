// Simple JSON Parser Test
// Tests: Parsing simple JSON objects
#include "test_syscall.h"

typedef struct {
    char key[32];
    char value[64];
    int is_number;
    int num_value;
} JsonField;

static JsonField fields[10];
static int field_count = 0;

void skip_whitespace(const char **p) {
    while (**p == ' ' || **p == '\t' || **p == '\n' || **p == '\r') {
        (*p)++;
    }
}

int parse_string(const char **p, char *out, int max_len) {
    if (**p != '"') return 0;
    (*p)++;
    
    int i = 0;
    while (**p && **p != '"' && i < max_len - 1) {
        out[i++] = **p;
        (*p)++;
    }
    out[i] = '\0';
    
    if (**p == '"') (*p)++;
    return i;
}

int parse_number(const char **p, int *out) {
    int neg = 0;
    int val = 0;
    
    if (**p == '-') {
        neg = 1;
        (*p)++;
    }
    
    while (**p >= '0' && **p <= '9') {
        val = val * 10 + (**p - '0');
        (*p)++;
    }
    
    *out = neg ? -val : val;
    return 1;
}

int parse_simple_json(const char *json) {
    const char *p = json;
    field_count = 0;
    
    skip_whitespace(&p);
    if (*p != '{') return 0;
    p++;
    
    while (*p && *p != '}') {
        skip_whitespace(&p);
        
        if (*p == '}') break;
        if (*p == ',') { p++; continue; }
        
        // Parse key
        if (!parse_string(&p, fields[field_count].key, 32)) break;
        
        skip_whitespace(&p);
        if (*p != ':') break;
        p++;
        skip_whitespace(&p);
        
        // Parse value
        if (*p == '"') {
            fields[field_count].is_number = 0;
            parse_string(&p, fields[field_count].value, 64);
        } else {
            fields[field_count].is_number = 1;
            parse_number(&p, &fields[field_count].num_value);
        }
        
        field_count++;
    }
    
    return field_count;
}

int find_field(const char *key) {
    for (int i = 0; i < field_count; i++) {
        int j = 0;
        while (key[j] && fields[i].key[j] && key[j] == fields[i].key[j]) j++;
        if (key[j] == '\0' && fields[i].key[j] == '\0') return i;
    }
    return -1;
}

int str_equals(const char *a, const char *b) {
    int i = 0;
    while (a[i] && b[i] && a[i] == b[i]) i++;
    return a[i] == '\0' && b[i] == '\0';
}

int test_main(void) {
    test_printstr("Testing JSON Parser...\n");
    
    // Test 1: Simple object
    const char *json1 = "{\"name\":\"Alice\",\"age\":25}";
    int count = parse_simple_json(json1);
    
    test_printstr("  simple: ");
    TEST_ASSERT(count == 2);
    
    int idx = find_field("name");
    TEST_ASSERT(idx >= 0);
    TEST_ASSERT(!fields[idx].is_number);
    TEST_ASSERT(str_equals(fields[idx].value, "Alice"));
    
    idx = find_field("age");
    TEST_ASSERT(idx >= 0);
    TEST_ASSERT(fields[idx].is_number);
    TEST_ASSERT(fields[idx].num_value == 25);
    test_printstr("OK\n");
    
    // Test 2: With spaces
    const char *json2 = "{ \"key\" : \"value\" }";
    count = parse_simple_json(json2);
    
    test_printstr("  spaces: ");
    TEST_ASSERT(count == 1);
    idx = find_field("key");
    TEST_ASSERT(idx >= 0);
    TEST_ASSERT(str_equals(fields[idx].value, "value"));
    test_printstr("OK\n");
    
    // Test 3: Numbers
    const char *json3 = "{\"x\":100,\"y\":-50}";
    count = parse_simple_json(json3);
    
    test_printstr("  nums: ");
    TEST_ASSERT(count == 2);
    idx = find_field("x");
    TEST_ASSERT(fields[idx].num_value == 100);
    idx = find_field("y");
    TEST_ASSERT(fields[idx].num_value == -50);
    test_printstr("OK\n");
    
    // Test 4: Empty object
    const char *json4 = "{}";
    count = parse_simple_json(json4);
    
    test_printstr("  empty: ");
    TEST_ASSERT(count == 0);
    test_printstr("OK\n");
    
    test_printstr("All JSON tests passed!\n");
    test_pass();
    return 0;
}
