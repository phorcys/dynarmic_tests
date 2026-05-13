// Dijkstra Shortest Path Test
// Tests: Dijkstra's algorithm for shortest paths
#include "test_syscall.h"

#define MAX_NODES 10
#define INF 999999

int graph[MAX_NODES][MAX_NODES];
int dist[MAX_NODES];
int visited[MAX_NODES];
int prev[MAX_NODES];

void init_graph(int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            graph[i][j] = INF;
        }
        graph[i][i] = 0;
    }
}

void add_edge(int from, int to, int weight) {
    graph[from][to] = weight;
}

int min_distance(int n) {
    int min = INF;
    int min_idx = -1;
    
    for (int v = 0; v < n; v++) {
        if (!visited[v] && dist[v] <= min) {
            min = dist[v];
            min_idx = v;
        }
    }
    
    return min_idx;
}

void dijkstra(int src, int n) {
    for (int i = 0; i < n; i++) {
        dist[i] = INF;
        visited[i] = 0;
        prev[i] = -1;
    }
    dist[src] = 0;
    
    for (int count = 0; count < n - 1; count++) {
        int u = min_distance(n);
        if (u < 0) break;
        
        visited[u] = 1;
        
        for (int v = 0; v < n; v++) {
            if (!visited[v] && graph[u][v] != INF && 
                dist[u] != INF && dist[u] + graph[u][v] < dist[v]) {
                dist[v] = dist[u] + graph[u][v];
                prev[v] = u;
            }
        }
    }
}

int test_main(void) {
    test_printstr("Testing Dijkstra...\n");
    
    // Test 1: Simple graph
    //     1
    //  0----1
    //  |    |
    // 4|    |2
    //  |    |
    //  2----3
    //     3
    
    init_graph(4);
    add_edge(0, 1, 1);
    add_edge(0, 2, 4);
    add_edge(1, 3, 2);
    add_edge(2, 3, 3);
    
    dijkstra(0, 4);
    
    test_printstr("  simple: ");
    test_printstr("d0=");
    test_printint(dist[0]);
    test_printstr(",d1=");
    test_printint(dist[1]);
    test_printstr(",d2=");
    test_printint(dist[2]);
    test_printstr(",d3=");
    test_printint(dist[3]);
    test_printstr(" ");
    
    TEST_ASSERT(dist[0] == 0);
    TEST_ASSERT(dist[1] == 1);
    TEST_ASSERT(dist[2] == 4);
    TEST_ASSERT(dist[3] == 3);  // 0->1->3
    test_printstr("OK\n");
    
    // Test 2: Directed graph
    init_graph(5);
    add_edge(0, 1, 10);
    add_edge(0, 4, 5);
    add_edge(1, 2, 1);
    add_edge(1, 4, 2);
    add_edge(2, 3, 4);
    add_edge(3, 2, 6);
    add_edge(3, 0, 7);
    add_edge(4, 1, 3);
    add_edge(4, 2, 9);
    add_edge(4, 3, 2);
    
    dijkstra(0, 5);
    
    test_printstr("  directed: ");
    test_printstr("d0=");
    test_printint(dist[0]);
    test_printstr(",d1=");
    test_printint(dist[1]);
    test_printstr(",d2=");
    test_printint(dist[2]);
    test_printstr(",d3=");
    test_printint(dist[3]);
    test_printstr(" ");
    
    TEST_ASSERT(dist[0] == 0);
    TEST_ASSERT(dist[1] == 8);  // 0->4->1
    TEST_ASSERT(dist[2] == 9);  // 0->4->1->2
    TEST_ASSERT(dist[3] == 7);  // 0->4->3
    test_printstr("OK\n");
    
    // Test 3: Disconnected graph
    init_graph(4);
    add_edge(0, 1, 1);
    // Nodes 2 and 3 are disconnected
    
    dijkstra(0, 4);
    
    test_printstr("  disconn: ");
    TEST_ASSERT(dist[2] == INF);
    TEST_ASSERT(dist[3] == INF);
    test_printstr("OK\n");
    
    // Test 4: Single node
    init_graph(1);
    dijkstra(0, 1);
    
    test_printstr("  single: ");
    TEST_ASSERT(dist[0] == 0);
    test_printstr("OK\n");
    
    test_printstr("All Dijkstra tests passed!\n");
    test_pass();
    return 0;
}
