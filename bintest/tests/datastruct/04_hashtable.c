// Hash Table with Chaining Test
// Tests: Hash table with linked list collision resolution
#include "test_syscall.h"

#define TABLE_SIZE 16

typedef struct HashEntry {
    int key;
    int value;
    struct HashEntry *next;
} HashEntry;

static HashEntry entries[100];
static int entry_count = 0;
static HashEntry *table[TABLE_SIZE];

unsigned int hash(int key) {
    return (unsigned int)(key * 31) % TABLE_SIZE;
}

HashEntry* create_entry(int key, int value) {
    if (entry_count >= 100) return 0;
    entries[entry_count].key = key;
    entries[entry_count].value = value;
    entries[entry_count].next = 0;
    return &entries[entry_count++];
}

void ht_init(void) {
    entry_count = 0;
    for (int i = 0; i < TABLE_SIZE; i++) {
        table[i] = 0;
    }
}

void ht_insert(int key, int value) {
    unsigned int idx = hash(key);
    
    // Check if key exists
    HashEntry *curr = table[idx];
    while (curr != 0) {
        if (curr->key == key) {
            curr->value = value;
            return;
        }
        curr = curr->next;
    }
    
    // Create new entry
    HashEntry *entry = create_entry(key, value);
    entry->next = table[idx];
    table[idx] = entry;
}

int ht_get(int key, int *found) {
    unsigned int idx = hash(key);
    HashEntry *curr = table[idx];
    
    while (curr != 0) {
        if (curr->key == key) {
            *found = 1;
            return curr->value;
        }
        curr = curr->next;
    }
    
    *found = 0;
    return 0;
}

int ht_contains(int key) {
    int found;
    ht_get(key, &found);
    return found;
}

int ht_count(void) {
    int count = 0;
    for (int i = 0; i < TABLE_SIZE; i++) {
        HashEntry *curr = table[i];
        while (curr != 0) {
            count++;
            curr = curr->next;
        }
    }
    return count;
}

int test_main(void) {
    test_printstr("Testing Hash Table...\n");
    
    // Test 1: Basic insert and get
    ht_init();
    ht_insert(1, 100);
    ht_insert(2, 200);
    
    test_printstr("  basic: ");
    int found;
    int val = ht_get(1, &found);
    TEST_ASSERT(found && val == 100);
    val = ht_get(2, &found);
    TEST_ASSERT(found && val == 200);
    test_printstr("OK\n");
    
    // Test 2: Non-existing key
    test_printstr("  missing: ");
    ht_get(999, &found);
    TEST_ASSERT(!found);
    test_printstr("OK\n");
    
    // Test 3: Update existing
    ht_insert(1, 150);
    test_printstr("  update: ");
    val = ht_get(1, &found);
    TEST_ASSERT(found && val == 150);
    test_printstr("OK\n");
    
    // Test 4: Collision handling
    ht_init();
    // These keys should hash to same bucket (if TABLE_SIZE=16)
    // key % 16 should be same for keys that differ by 16
    ht_insert(1, 10);
    ht_insert(17, 20);  // 17 % 16 = 1
    ht_insert(33, 30);  // 33 % 16 = 1
    
    test_printstr("  collision: ");
    TEST_ASSERT(ht_count() == 3);
    val = ht_get(1, &found);
    TEST_ASSERT(found && val == 10);
    val = ht_get(17, &found);
    TEST_ASSERT(found && val == 20);
    val = ht_get(33, &found);
    TEST_ASSERT(found && val == 30);
    test_printstr("OK\n");
    
    // Test 5: Many insertions
    ht_init();
    for (int i = 0; i < 50; i++) {
        ht_insert(i, i * 10);
    }
    
    test_printstr("  many: ");
    TEST_ASSERT(ht_count() == 50);
    val = ht_get(25, &found);
    TEST_ASSERT(found && val == 250);
    val = ht_get(49, &found);
    TEST_ASSERT(found && val == 490);
    test_printstr("OK\n");
    
    test_printstr("All Hash Table tests passed!\n");
    test_pass();
    return 0;
}
