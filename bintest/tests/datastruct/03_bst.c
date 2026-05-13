// Binary Search Tree Test
// Tests: BST insert, search, and traversal
#include "test_syscall.h"

typedef struct Node {
    int key;
    struct Node *left;
    struct Node *right;
} Node;

static Node nodes[100];
static int node_count = 0;

Node* create_node(int key) {
    if (node_count >= 100) return 0;
    nodes[node_count].key = key;
    nodes[node_count].left = 0;
    nodes[node_count].right = 0;
    return &nodes[node_count++];
}

Node* bst_insert(Node *root, int key) {
    if (root == 0) {
        return create_node(key);
    }
    
    if (key < root->key) {
        root->left = bst_insert(root->left, key);
    } else if (key > root->key) {
        root->right = bst_insert(root->right, key);
    }
    
    return root;
}

Node* bst_search(Node *root, int key) {
    if (root == 0 || root->key == key) {
        return root;
    }
    
    if (key < root->key) {
        return bst_search(root->left, key);
    }
    
    return bst_search(root->right, key);
}

int bst_count(Node *root) {
    if (root == 0) return 0;
    return 1 + bst_count(root->left) + bst_count(root->right);
}

void bst_inorder(Node *root, int *arr, int *idx) {
    if (root == 0) return;
    bst_inorder(root->left, arr, idx);
    arr[(*idx)++] = root->key;
    bst_inorder(root->right, arr, idx);
}

int test_main(void) {
    test_printstr("Testing BST...\n");
    node_count = 0;
    Node *root = 0;
    
    // Test 1: Insert and search
    root = bst_insert(root, 50);
    bst_insert(root, 30);
    bst_insert(root, 70);
    bst_insert(root, 20);
    bst_insert(root, 40);
    
    test_printstr("  insert: ");
    TEST_ASSERT(root != 0);
    TEST_ASSERT(bst_count(root) == 5);
    test_printstr("OK\n");
    
    // Test 2: Search existing
    test_printstr("  search_yes: ");
    Node *found = bst_search(root, 30);
    TEST_ASSERT(found != 0 && found->key == 30);
    test_printstr("OK\n");
    
    // Test 3: Search non-existing
    test_printstr("  search_no: ");
    found = bst_search(root, 100);
    TEST_ASSERT(found == 0);
    test_printstr("OK\n");
    
    // Test 4: Inorder traversal (should be sorted)
    int arr[10];
    int idx = 0;
    bst_inorder(root, arr, &idx);
    
    test_printstr("  inorder: ");
    int sorted = 1;
    for (int i = 1; i < idx; i++) {
        if (arr[i] < arr[i-1]) sorted = 0;
    }
    TEST_ASSERT(sorted);
    TEST_ASSERT(arr[0] == 20);
    TEST_ASSERT(arr[4] == 70);
    test_printstr("OK\n");
    
    // Test 5: Duplicate insert (should not add)
    node_count = 0;
    root = 0;
    root = bst_insert(root, 10);
    bst_insert(root, 10);
    
    test_printstr("  dup: ");
    TEST_ASSERT(bst_count(root) == 1);
    test_printstr("OK\n");
    
    test_printstr("All BST tests passed!\n");
    test_pass();
    return 0;
}
