/*
 * Test Syscall Interface for dynarmic_bintest
 * 
 * Uses real Linux syscalls for compatibility with both:
 * - QEMU user-mode emulation
 * - dynarmic bintest_runner
 */

#ifndef TEST_SYSCALL_H
#define TEST_SYSCALL_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

#if defined(__aarch64__)
/* Linux ARM64 syscall numbers */
#define SYS_READ        63
#define SYS_WRITE       64
#define SYS_EXIT        93
#define SYS_EXIT_GROUP  94
#define SYS_GETPID      172
#elif defined(__arm__)
/* Linux ARM EABI syscall numbers */
#define SYS_READ        3
#define SYS_WRITE       4
#define SYS_EXIT        1
#define SYS_EXIT_GROUP  248
#define SYS_GETPID      20
#else
#error "Unsupported test bintest target architecture"
#endif

/* Custom syscall numbers for test framework (high numbers to avoid conflict) */
#define SYS_TEST_ASSERT     0x1000  /* assert(cond, line, file) */
#define SYS_TEST_PASS       0x1001  /* mark test as passed */
#define SYS_TEST_FAIL       0x1002  /* mark test as failed with line number */

/* File descriptors */
#define STDIN   0
#define STDOUT  1
#define STDERR  2

/* ==================== Low-level syscall wrappers ==================== */

#if defined(__aarch64__)
/*
 * ARM64 Linux syscall calling convention:
 * - x8 = syscall number
 * - x0-x5 = arguments
 * - x0 = return value
 */
#define syscall0(n) ({ \
    register long _x8 __asm__("x8") = (n); \
    register long _x0 __asm__("x0"); \
    __asm__ volatile( \
        "svc #0" \
        : "=r"(_x0) \
        : "r"(_x8) \
        : "memory" \
    ); \
    _x0; \
})

#define syscall1(n, a0) ({ \
    register long _x8 __asm__("x8") = (n); \
    register long _x0 __asm__("x0") = (a0); \
    __asm__ volatile( \
        "svc #0" \
        : "+r"(_x0) \
        : "r"(_x8) \
        : "memory" \
    ); \
    _x0; \
})

#define syscall2(n, a0, a1) ({ \
    register long _x8 __asm__("x8") = (n); \
    register long _x0 __asm__("x0") = (a0); \
    register long _x1 __asm__("x1") = (a1); \
    __asm__ volatile( \
        "svc #0" \
        : "+r"(_x0) \
        : "r"(_x8), "r"(_x1) \
        : "memory" \
    ); \
    _x0; \
})

#define syscall3(n, a0, a1, a2) ({ \
    register long _x8 __asm__("x8") = (n); \
    register long _x0 __asm__("x0") = (a0); \
    register long _x1 __asm__("x1") = (a1); \
    register long _x2 __asm__("x2") = (a2); \
    __asm__ volatile( \
        "svc #0" \
        : "+r"(_x0) \
        : "r"(_x8), "r"(_x1), "r"(_x2) \
        : "memory" \
    ); \
    _x0; \
})
#elif defined(__arm__)
/*
 * ARM Linux EABI syscall convention:
 * - r7 = syscall number
 * - r0-r6 = arguments
 * - r0 = return value
 */
#define syscall0(n) ({ \
    register long _r7 __asm__("r7") = (n); \
    register long _r0 __asm__("r0"); \
    __asm__ volatile( \
        "svc #0" \
        : "=r"(_r0) \
        : "r"(_r7) \
        : "memory" \
    ); \
    _r0; \
})

#define syscall1(n, a0) ({ \
    register long _r7 __asm__("r7") = (n); \
    register long _r0 __asm__("r0") = (a0); \
    __asm__ volatile( \
        "svc #0" \
        : "+r"(_r0) \
        : "r"(_r7) \
        : "memory" \
    ); \
    _r0; \
})

#define syscall2(n, a0, a1) ({ \
    register long _r7 __asm__("r7") = (n); \
    register long _r0 __asm__("r0") = (a0); \
    register long _r1 __asm__("r1") = (a1); \
    __asm__ volatile( \
        "svc #0" \
        : "+r"(_r0) \
        : "r"(_r7), "r"(_r1) \
        : "memory" \
    ); \
    _r0; \
})

#define syscall3(n, a0, a1, a2) ({ \
    register long _r7 __asm__("r7") = (n); \
    register long _r0 __asm__("r0") = (a0); \
    register long _r1 __asm__("r1") = (a1); \
    register long _r2 __asm__("r2") = (a2); \
    __asm__ volatile( \
        "svc #0" \
        : "+r"(_r0) \
        : "r"(_r7), "r"(_r1), "r"(_r2) \
        : "memory" \
    ); \
    _r0; \
})
#endif

/* ==================== Standard syscall wrappers ==================== */

/* write(fd, buf, count) - write to file descriptor */
static inline long sys_write(int fd, const void *buf, unsigned long count) {
    return syscall3(SYS_WRITE, fd, (long)buf, count);
}

/* read(fd, buf, count) - read from file descriptor */
static inline long sys_read(int fd, void *buf, unsigned long count) {
    return syscall3(SYS_READ, fd, (long)buf, count);
}

/* getpid() - get process ID */
static inline long sys_getpid(void) {
    return syscall0(SYS_GETPID);
}

/* exit(status) - terminate process */
static inline void sys_exit(int status) __attribute__((noreturn));
static inline void sys_exit(int status) {
    syscall1(SYS_EXIT_GROUP, status);
    __builtin_unreachable();
}

/* ==================== Test helper functions ==================== */

/* Simple strlen implementation */
static inline unsigned long test_strlen(const char *s) {
    unsigned long len = 0;
    while (s[len]) len++;
    return len;
}

/* Print a single character to stdout */
static inline void test_putchar(char c) {
    sys_write(STDOUT, &c, 1);
}

/* Print a string to stdout */
static inline void test_printstr(const char *str) {
    sys_write(STDOUT, str, test_strlen(str));
}

/* Print a string to stderr */
static inline void test_errstr(const char *str) {
    sys_write(STDERR, str, test_strlen(str));
}

/* Print signed integer */
static inline void test_printint(long val) {
    char buf[24];
    int i = 23;
    int neg = 0;
    
    buf[i] = '\0';
    
    if (val < 0) {
        neg = 1;
        val = -val;
    }
    
    if (val == 0) {
        buf[--i] = '0';
    } else {
        while (val > 0) {
            buf[--i] = '0' + (val % 10);
            val /= 10;
        }
    }
    
    if (neg) {
        buf[--i] = '-';
    }
    
    test_printstr(&buf[i]);
}

/* Print unsigned integer */
static inline void test_printuint(unsigned long val) {
    char buf[24];
    int i = 23;
    
    buf[i] = '\0';
    
    if (val == 0) {
        buf[--i] = '0';
    } else {
        while (val > 0) {
            buf[--i] = '0' + (val % 10);
            val /= 10;
        }
    }
    
    test_printstr(&buf[i]);
}

/* Print hex value with 0x prefix */
static inline void test_printhex(unsigned long val) {
    static const char hex[] = "0123456789ABCDEF";
    char buf[20];
    int i;
    
    buf[0] = '0';
    buf[1] = 'x';
    
    for (i = 0; i < 16; i++) {
        buf[2 + i] = hex[(val >> (60 - i * 4)) & 0xF];
    }
    buf[18] = '\0';
    
    /* Skip leading zeros after 0x */
    test_printstr(buf);
}

/* Print newline */
static inline void test_newline(void) {
    test_putchar('\n');
}

/* ==================== Test control macros ==================== */

/* Assertion macro - on failure, prints line number and exits */
#define TEST_ASSERT(cond) do { \
    if (!(cond)) { \
        test_errstr("ASSERTION FAILED at line "); \
        test_printint(__LINE__); \
        test_errstr("\n"); \
        sys_exit(1); \
    } \
} while(0)

/* Mark test as passed and exit with status 0 */
static inline void test_pass(void) {
    test_printstr("[PASS]\n");
    sys_exit(0);
}

/* Mark test as failed and exit with status 1 */
static inline void test_fail(int line) {
    test_errstr("[FAIL] at line ");
    test_printint(line);
    test_errstr("\n");
    sys_exit(1);
}

/* Exit test with status (0 = pass, non-zero = fail) */
static inline void test_exit(int status) {
    sys_exit(status);
}

/* ==================== Test entry point ==================== */

/* Each test must define this function */
int test_main(void);

/* Compatibility aliases */
#define test_print_str test_printstr
#define test_print_int test_printint
#define test_print_uint test_printuint
#define test_print_hex test_printhex

/* Debug helpers */
#define DEBUG_VAL(name, val) do { \
    test_printstr(name); \
    test_printstr(" = "); \
    test_printint(val); \
    test_newline(); \
} while(0)

#define DEBUG_HEX(name, val) do { \
    test_printstr(name); \
    test_printstr(" = "); \
    test_printhex(val); \
    test_newline(); \
} while(0)

#ifdef __cplusplus
}
#endif

#endif /* TEST_SYSCALL_H */
