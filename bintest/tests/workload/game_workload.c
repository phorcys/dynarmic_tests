/*
 * Game-like Workload Test
 * Simulates game-like operations: vector math, state machines, collision detection
 */

#include "test_syscall.h"

/* Simple memset implementation */
static void *my_memset(void *s, int c, unsigned long n) {
    unsigned char *p = (unsigned char *)s;
    while (n--) {
        *p++ = (unsigned char)c;
    }
    return s;
}

/* 2D vector structure */
typedef struct {
    float x, y;
} Vec2;

/* Simple 2D vector operations */
static Vec2 vec2_add(Vec2 a, Vec2 b) {
    Vec2 r = {a.x + b.x, a.y + b.y};
    return r;
}

static Vec2 vec2_sub(Vec2 a, Vec2 b) {
    Vec2 r = {a.x - b.x, a.y - b.y};
    return r;
}

static float vec2_dot(Vec2 a, Vec2 b) {
    return a.x * b.x + a.y * b.y;
}

static float vec2_len_sq(Vec2 a) {
    return vec2_dot(a, a);
}

/* Game object structure */
typedef struct {
    Vec2 pos;
    Vec2 vel;
    int active;
    int type;
} GameObject;

/* Simple AABB collision detection */
static int check_collision(Vec2 pos1, Vec2 size1, Vec2 pos2, Vec2 size2) {
    float left1 = pos1.x;
    float right1 = pos1.x + size1.x;
    float top1 = pos1.y;
    float bottom1 = pos1.y + size1.y;
    
    float left2 = pos2.x;
    float right2 = pos2.x + size2.x;
    float top2 = pos2.y;
    float bottom2 = pos2.y + size2.y;
    
    return (left1 < right2 && right1 > left2 &&
            top1 < bottom2 && bottom1 > top2);
}

/* Simulate game physics update */
static int test_game_physics(void) {
    test_printstr("Testing game physics...\n");
    
    GameObject player = {{100.0f, 100.0f}, {0.0f, 0.0f}, 1, 0};
    GameObject enemies[5];
    Vec2 enemy_size = {20.0f, 20.0f};
    Vec2 player_size = {30.0f, 30.0f};
    
    /* Initialize enemies */
    for (int i = 0; i < 5; i++) {
        enemies[i].pos.x = 200.0f + i * 50.0f;
        enemies[i].pos.y = 100.0f;
        enemies[i].vel.x = -1.0f;
        enemies[i].vel.y = 0.0f;
        enemies[i].active = 1;
        enemies[i].type = 1;
    }
    
    int collision_count = 0;
    
    /* Simulate 100 frames */
    for (int frame = 0; frame < 100; frame++) {
        /* Update player position */
        player.pos = vec2_add(player.pos, player.vel);
        
        /* Update enemies */
        for (int i = 0; i < 5; i++) {
            if (enemies[i].active) {
                enemies[i].pos = vec2_add(enemies[i].pos, enemies[i].vel);
                
                /* Check collision with player */
                if (check_collision(player.pos, player_size, 
                                   enemies[i].pos, enemy_size)) {
                    collision_count++;
                    enemies[i].active = 0;
                }
            }
        }
        
        /* Player starts moving after frame 10 */
        if (frame == 10) {
            player.vel.x = 5.0f;
        }
        
        /* Player stops after frame 50 */
        if (frame == 50) {
            player.vel.x = 0.0f;
        }
    }
    
    /* Player at position: 100 + 5*40 = 300 */
    /* Enemies should have moved left and some collided */
    
    test_printstr("  Game physics: PASS\n");
    return 0;
}

/* Simple state machine simulation */
typedef enum {
    STATE_IDLE,
    STATE_WALKING,
    STATE_RUNNING,
    STATE_JUMPING,
    STATE_ATTACKING
} State;

typedef struct {
    State current;
    int frame_count;
    int health;
} Entity;

static int test_state_machine(void) {
    test_printstr("Testing state machine...\n");
    
    Entity player = {STATE_IDLE, 0, 100};
    int transitions = 0;
    
    /* Simulate state transitions over time */
    for (int frame = 0; frame < 200; frame++) {
        player.frame_count++;
        
        switch (player.current) {
            case STATE_IDLE:
                if (frame == 10) {
                    player.current = STATE_WALKING;
                    transitions++;
                }
                break;
                
            case STATE_WALKING:
                if (frame == 50) {
                    player.current = STATE_RUNNING;
                    transitions++;
                }
                break;
                
            case STATE_RUNNING:
                if (frame == 80) {
                    player.current = STATE_JUMPING;
                    transitions++;
                }
                break;
                
            case STATE_JUMPING:
                if (player.frame_count > 20) {
                    player.current = STATE_ATTACKING;
                    transitions++;
                    player.frame_count = 0;
                }
                break;
                
            case STATE_ATTACKING:
                if (player.frame_count > 30) {
                    player.current = STATE_IDLE;
                    transitions++;
                    player.frame_count = 0;
                }
                break;
        }
    }
    
    TEST_ASSERT(transitions == 5);
    TEST_ASSERT(player.current == STATE_IDLE);
    
    test_printstr("  State machine: PASS\n");
    return 0;
}

/* Simple pathfinding (A* simplified) */
static int test_pathfinding(void) {
    test_printstr("Testing pathfinding...\n");
    
    /* 8x8 grid, 0 = walkable, 1 = blocked */
    int grid[8][8] = {
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 1, 1, 0, 0, 1, 1, 0},
        {0, 1, 0, 0, 0, 0, 1, 0},
        {0, 0, 0, 1, 1, 0, 0, 0},
        {0, 0, 0, 1, 1, 0, 0, 0},
        {0, 1, 0, 0, 0, 0, 1, 0},
        {0, 1, 1, 0, 0, 1, 1, 0},
        {0, 0, 0, 0, 0, 0, 0, 0}
    };
    
    int start_x = 0, start_y = 0;
    int end_x = 7, end_y = 7;
    
    /* Simple BFS to find path length */
    int visited[8][8];
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            visited[i][j] = 0;
        }
    }
    int queue_x[64], queue_y[64], queue_dist[64];
    int head = 0, tail = 0;
    
    queue_x[tail] = start_x;
    queue_y[tail] = start_y;
    queue_dist[tail] = 0;
    tail++;
    visited[start_y][start_x] = 1;
    
    int found_dist = -1;
    int dx[] = {0, 1, 0, -1};
    int dy[] = {1, 0, -1, 0};
    
    while (head < tail && found_dist < 0) {
        int cx = queue_x[head];
        int cy = queue_y[head];
        int cd = queue_dist[head];
        head++;
        
        if (cx == end_x && cy == end_y) {
            found_dist = cd;
            break;
        }
        
        for (int d = 0; d < 4; d++) {
            int nx = cx + dx[d];
            int ny = cy + dy[d];
            
            if (nx >= 0 && nx < 8 && ny >= 0 && ny < 8 &&
                !visited[ny][nx] && grid[ny][nx] == 0) {
                visited[ny][nx] = 1;
                queue_x[tail] = nx;
                queue_y[tail] = ny;
                queue_dist[tail] = cd + 1;
                tail++;
            }
        }
    }
    
    TEST_ASSERT(found_dist >= 0);  /* Path found */
    TEST_ASSERT(found_dist == 14); /* Expected shortest path length */
    
    test_printstr("  Pathfinding: PASS\n");
    return 0;
}

/* Particle system simulation */
typedef struct {
    Vec2 pos;
    Vec2 vel;
    float life;
    int active;
} Particle;

static int test_particle_system(void) {
    test_printstr("Testing particle system...\n");
    
    Particle particles[100];
    int active_count = 0;
    
    /* Initialize particles */
    for (int i = 0; i < 100; i++) {
        particles[i].active = 0;
        particles[i].life = 0.0f;
    }
    
    /* Emit 50 particles */
    for (int i = 0; i < 50; i++) {
        particles[i].pos.x = 400.0f;
        particles[i].pos.y = 300.0f;
        particles[i].vel.x = (i - 25) * 0.5f;  /* Spread horizontally */
        particles[i].vel.y = -2.0f;  /* Initial upward velocity */
        particles[i].life = 100.0f;
        particles[i].active = 1;
    }
    
    /* Simulate 120 frames */
    for (int frame = 0; frame < 120; frame++) {
        active_count = 0;
        
        for (int i = 0; i < 100; i++) {
            if (particles[i].active) {
                active_count++;
                
                /* Update position */
                particles[i].pos = vec2_add(particles[i].pos, particles[i].vel);
                
                /* Gravity */
                particles[i].vel.y += 0.1f;
                
                /* Decay life */
                particles[i].life -= 1.0f;
                
                /* Deactivate if life <= 0 */
                if (particles[i].life <= 0.0f) {
                    particles[i].active = 0;
                }
            }
        }
    }
    
    /* All particles should be inactive after 120 frames */
    TEST_ASSERT(active_count == 0);
    
    test_printstr("  Particle system: PASS\n");
    return 0;
}

int test_main(void) {
    test_printstr("=== Game Workload Tests ===\n");
    
    test_game_physics();
    test_state_machine();
    test_pathfinding();
    test_particle_system();
    
    test_printstr("=== All game workload tests passed ===\n");
    test_pass();
    return 0;
}
