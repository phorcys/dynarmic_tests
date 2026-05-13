/*
 * simde_bare_adapt.h - SIMDe Bare Metal Adaptation Layer
 *
 * This header intercepts standard library includes and provides
 * bare metal implementations for SIMDe NEON tests.
 *
 * Usage:
 *   aarch64-none-elf-gcc -include simde_bare_adapt.h -DSIMDE_TEST_BARE ...
 */

#ifndef SIMDE_BARE_ADAPT_H
#define SIMDE_BARE_ADAPT_H

/* ========== 1. Include syscall interface ========== */
#include "test_syscall.h"

/* ========== 2. Basic types and macros ========== */
#define NULL ((void*)0)
#define RAND_MAX 2147483647
#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

typedef unsigned long size_t;
typedef long ssize_t;
typedef long off_t;

/* Fixed-width integer types */
typedef signed char int8_t;
typedef unsigned char uint8_t;
typedef signed short int16_t;
typedef unsigned short uint16_t;
typedef signed int int32_t;
typedef unsigned int uint32_t;
typedef signed long int64_t;
typedef unsigned long uint64_t;
typedef int64_t intptr_t;
typedef uint64_t uintptr_t;
typedef int64_t intmax_t;
typedef uint64_t uintmax_t;
typedef long int_fast16_t;
typedef unsigned long uint_fast16_t;
typedef long int_fast32_t;
typedef unsigned long uint_fast32_t;
typedef int64_t int_fast64_t;
typedef uint64_t uint_fast64_t;
typedef int32_t int_least32_t;
typedef uint32_t uint_least32_t;
typedef int64_t int_least64_t;
typedef uint64_t uint_least64_t;
#define INT8_MIN (-128)
#define INT8_MAX 127
#define UINT8_MAX 255
#define INT16_MIN (-32768)
#define INT16_MAX 32767
#define UINT16_MAX 65535
#define INT32_MIN (-2147483647-1)
#define INT32_MAX 2147483647
#define UINT32_MAX 4294967295U
#define INT64_MIN (-9223372036854775807LL-1)
#define INT64_MAX 9223372036854775807LL
#define UINT64_MAX 18446744073709551615ULL
#define INTPTR_MIN INT64_MIN
#define INTPTR_MAX INT64_MAX
#define UINTPTR_MAX UINT64_MAX

/* FILE type and stdio macros - must be before any stdio functions */
typedef void FILE;
#define stdin  ((FILE*)0)
#define stdout ((FILE*)1)
#define stderr ((FILE*)2)

/* ========== 3. Block standard library headers ========== */
/* This prevents the compiler from including the real headers */
#define _STDLIB_H
#define _STDLIB_H_
#define _STDIO_H
#define _STDIO_H_
#define _STRING_H
#define _STRING_H_
#define _STRINGS_H
#define _STRINGS_H_
#define _MATH_H
#define _MATH_H_
#define _TIME_H
#define _TIME_H_
#define _STDARG_H
#define _STDARG_H_
#define _STDDEF_H
#define _STDDEF_H_
#define _STDINT_H
#define _STDINT_H_
#define _INTTYPES_H
#define _INTTYPES_H_
#define _LIMITS_H
#define _LIMITS_H_
#define _FLOAT_H
#define _FLOAT_H_
#define _STDALIGN_H
#define _STDALIGN_H_
#define _STDATOMIC_H
#define _STDATOMIC_H_
#define _ASSERT_H
#define _ASSERT_H_

/* Tell SIMDe to use builtin math functions instead of library calls */
#define SIMDE_MATH_BUILTIN_LIBM(name) 1

/* ========== 4. stddef.h replacements ========== */
#define offsetof(type, member) ((size_t)&((type*)0)->member)

/* ========== 5. stdarg.h replacements ========== */
typedef __builtin_va_list va_list;
#define va_start(ap, last) __builtin_va_start(ap, last)
#define va_end(ap) __builtin_va_end(ap)
#define va_arg(ap, type) __builtin_va_arg(ap, type)
#define va_copy(dest, src) __builtin_va_copy(dest, src)

/* ========== 6. String operations (must be before memory management) ========== */
static inline void* memset(void* s, int c, size_t n) {
    char* p = (char*)s;
    while (n--) {
        *p++ = (char)c;
    }
    return s;
}

static inline void* memcpy(void* d, const void* s, size_t n) {
    char* dst = (char*)d;
    const char* src = (const char*)s;
    while (n--) {
        *dst++ = *src++;
    }
    return d;
}

static inline int memcmp(const void* a, const void* b, size_t n) {
    const unsigned char* pa = (const unsigned char*)a;
    const unsigned char* pb = (const unsigned char*)b;
    while (n--) {
        if (*pa != *pb) {
            return *pa - *pb;
        }
        pa++;
        pb++;
    }
    return 0;
}

static inline size_t strlen(const char* s) {
    size_t len = 0;
    while (*s++) len++;
    return len;
}

static inline char* strcpy(char* d, const char* s) {
    char* ret = d;
    while ((*d++ = *s++));
    return ret;
}

static inline char* strncpy(char* d, const char* s, size_t n) {
    char* ret = d;
    while (n && (*d++ = *s++)) n--;
    while (n--) *d++ = '\0';
    return ret;
}

static inline int strcmp(const char* a, const char* b) {
    while (*a && (*a == *b)) {
        a++;
        b++;
    }
    return *(const unsigned char*)a - *(const unsigned char*)b;
}

static inline int strncmp(const char* a, const char* b, size_t n) {
    while (n && *a && (*a == *b)) {
        a++;
        b++;
        n--;
    }
    if (n == 0) return 0;
    return *(const unsigned char*)a - *(const unsigned char*)b;
}

/* ========== 7. Memory management ========== */
/* Simple bump allocator */
extern char __heap_start[];
extern char __heap_end[];
extern char* __heap_current;

static inline void* malloc(size_t n) {
    /* Align to 8 bytes */
    n = (n + 7) & ~7UL;
    if (__heap_current == NULL) {
        __heap_current = __heap_start;
    }
    if (__heap_current + n > __heap_end) {
        return NULL;
    }
    void* p = __heap_current;
    __heap_current += n;
    return p;
}

static inline void free(void* p) {
    /* Bump allocator doesn't free */
    (void)p;
}

static inline void* calloc(size_t nmemb, size_t size) {
    size_t total = nmemb * size;
    void* p = malloc(total);
    if (p) {
        char* cp = (char*)p;
        for (size_t i = 0; i < total; i++) {
            cp[i] = 0;
        }
    }
    return p;
}

static inline void* realloc(void* ptr, size_t size) {
    /* Simple implementation: just allocate new block */
    void* p = malloc(size);
    if (p && ptr && size > 0) {
        memcpy(p, ptr, size);
    }
    return p;
}

/* ========== 8. Random number (xorshift) ========== */
static unsigned long rand_state = 1;

static inline int rand(void) {
    rand_state ^= rand_state << 13;
    rand_state ^= rand_state >> 17;
    rand_state ^= rand_state << 5;
    return (int)(rand_state & 0x7fffffff);
}

static inline void srand(unsigned int s) {
    rand_state = s ? s : 1;
}

/* ========== 9. Time functions (stub) ========== */
typedef long time_t;

static inline time_t time(time_t* t) {
    if (t) *t = 1;
    return 1;
}

/* ========== 10. Math functions ========== */
/* Basic floating point operations */

/* fabs/fabsf */
static inline double fabs(double x) {
    union { double d; unsigned long u; } u;
    u.d = x;
    u.u &= 0x7fffffffffffffffUL;
    return u.d;
}

static inline float fabsf(float x) {
    union { float f; unsigned int u; } u;
    u.f = x;
    u.u &= 0x7fffffff;
    return u.f;
}

/* isnan/isinf */
static inline int isnan(double x) {
    union { double d; unsigned long u; } u;
    u.d = x;
    return (u.u & 0x7ff0000000000000UL) == 0x7ff0000000000000UL &&
           (u.u & 0x000fffffffffffffUL) != 0;
}

static inline int isinf(double x) {
    union { double d; unsigned long u; } u;
    u.d = x;
    return (u.u & 0x7ff0000000000000UL) == 0x7ff0000000000000UL &&
           (u.u & 0x000fffffffffffffUL) == 0;
}

static inline int isnanf(float x) {
    union { float f; unsigned int u; } u;
    u.f = x;
    return (u.u & 0x7f800000) == 0x7f800000 && (u.u & 0x007fffff) != 0;
}

static inline int isinff(float x) {
    union { float f; unsigned int u; } u;
    u.f = x;
    return (u.u & 0x7f800000) == 0x7f800000 && (u.u & 0x007fffff) == 0;
}

/* nextafter - simplified implementation */
static inline double nextafter(double x, double y) {
    if (x == y) return y;
    if (isnan(x) || isnan(y)) return 0.0/0.0; /* NaN */
    if (x == 0.0) {
        union { double d; unsigned long u; } u;
        u.u = 1;
        return y > 0 ? u.d : -u.d;
    }
    /* Simplified: just increment/decrement the bits */
    union { double d; unsigned long u; } u;
    u.d = x;
    if (x < y) {
        u.u++;
    } else {
        u.u--;
    }
    return u.d;
}

static inline float nextafterf(float x, float y) {
    if (x == y) return y;
    if (isnanf(x) || isnanf(y)) {
        union { float f; unsigned int u; } u;
        u.u = 0x7fc00000; /* NaN */
        return u.f;
    }
    if (x == 0.0f) {
        union { float f; unsigned int u; } u;
        u.u = 1;
        return y > 0 ? u.f : -u.f;
    }
    union { float f; unsigned int u; } u;
    u.f = x;
    if (x < y) {
        u.u++;
    } else {
        u.u--;
    }
    return u.f;
}

/* Floor/Ceil/Round - using ARM64 instructions */
static inline float floorf(float x) {
    __asm__ volatile("frintm %s0, %s1" : "=w"(x) : "w"(x));
    return x;
}

static inline float ceilf(float x) {
    __asm__ volatile("frintp %s0, %s1" : "=w"(x) : "w"(x));
    return x;
}

static inline float roundf(float x) {
    __asm__ volatile("frinta %s0, %s1" : "=w"(x) : "w"(x));
    return x;
}

static inline double floor(double x) {
    __asm__ volatile("frintm %d0, %d1" : "=w"(x) : "w"(x));
    return x;
}

static inline double ceil(double x) {
    __asm__ volatile("frintp %d0, %d1" : "=w"(x) : "w"(x));
    return x;
}

static inline double round(double x) {
    __asm__ volatile("frinta %d0, %d1" : "=w"(x) : "w"(x));
    return x;
}

/* sqrt - using ARM64 fsqrt instruction */
__attribute__((always_inline)) static inline float sqrtf(float x) {
    float result;
    __asm__ volatile("fsqrt %s0, %s1" : "=w"(result) : "w"(x));
    return result;
}

__attribute__((always_inline)) static inline double sqrt(double x) {
    double result;
    __asm__ volatile("fsqrt %d0, %d1" : "=w"(result) : "w"(x));
    return result;
}

/* Override SIMDe math functions to use our implementations */
#define simde_math_sqrtf(v) __builtin_sqrtf(v)
#define simde_math_sqrt(v) __builtin_sqrt(v)

/* ========== 11. Formatted output (simplified vsnprintf) ========== */
/* Only supports: %d, %i, %u, %x, %X, %s, %c, %p, %%, %f (limited) */

static inline int vsnprintf(char* buf, size_t size, const char* fmt, va_list ap) {
    char* p = buf;
    char* end = buf + size - 1;
    
    while (*fmt && p < end) {
        if (*fmt != '%') {
            *p++ = *fmt++;
            continue;
        }
        fmt++;
        
        /* Skip flags and width */
        while (*fmt == '-' || *fmt == '+' || *fmt == ' ' ||
               *fmt == '0' || *fmt == '#') fmt++;
        while (*fmt >= '0' && *fmt <= '9') fmt++;
        if (*fmt == '.') {
            fmt++;
            while (*fmt >= '0' && *fmt <= '9') fmt++;
        }
        if (*fmt == 'l') fmt++;
        if (*fmt == 'l') fmt++;
        if (*fmt == 'z') fmt++;
        
        /* Handle conversion */
        switch (*fmt) {
            case 'd':
            case 'i': {
                long val = va_arg(ap, long);
                if (val < 0) {
                    if (p < end) *p++ = '-';
                    val = -val;
                }
                char tmp[24];
                int i = 23;
                tmp[i] = '\0';
                if (val == 0) {
                    tmp[--i] = '0';
                } else {
                    while (val > 0) {
                        tmp[--i] = '0' + (val % 10);
                        val /= 10;
                    }
                }
                while (tmp[i] && p < end) *p++ = tmp[i++];
                break;
            }
            case 'u': {
                unsigned long val = va_arg(ap, unsigned long);
                char tmp[24];
                int i = 23;
                tmp[i] = '\0';
                if (val == 0) {
                    tmp[--i] = '0';
                } else {
                    while (val > 0) {
                        tmp[--i] = '0' + (val % 10);
                        val /= 10;
                    }
                }
                while (tmp[i] && p < end) *p++ = tmp[i++];
                break;
            }
            case 'x':
            case 'X': {
                unsigned long val = va_arg(ap, unsigned long);
                char tmp[20];
                int i = 19;
                tmp[i] = '\0';
                if (val == 0) {
                    tmp[--i] = '0';
                } else {
                    while (val > 0) {
                        int d = val & 0xf;
                        tmp[--i] = d < 10 ? '0' + d : 'a' + d - 10;
                        val >>= 4;
                    }
                }
                while (tmp[i] && p < end) *p++ = tmp[i++];
                break;
            }
            case 's': {
                const char* s = va_arg(ap, const char*);
                if (!s) s = "(null)";
                while (*s && p < end) *p++ = *s++;
                break;
            }
            case 'c': {
                char c = (char)va_arg(ap, int);
                if (p < end) *p++ = c;
                break;
            }
            case 'p': {
                void* ptr = va_arg(ap, void*);
                if (p < end) *p++ = '0';
                if (p < end) *p++ = 'x';
                unsigned long val = (unsigned long)ptr;
                char tmp[18];
                for (int i = 0; i < 16; i++) {
                    int d = (val >> (60 - i*4)) & 0xf;
                    tmp[i] = d < 10 ? '0' + d : 'a' + d - 10;
                }
                tmp[16] = '\0';
                char* tp = tmp;
                while (*tp && p < end) *p++ = *tp++;
                break;
            }
            case 'f': {
                /* Very simplified float printing */
                double val = va_arg(ap, double);
                if (val < 0) {
                    if (p < end) *p++ = '-';
                    val = -val;
                }
                /* Print integer part */
                unsigned long ipart = (unsigned long)val;
                char tmp[24];
                int i = 23;
                tmp[i] = '\0';
                if (ipart == 0) {
                    tmp[--i] = '0';
                } else {
                    while (ipart > 0) {
                        tmp[--i] = '0' + (ipart % 10);
                        ipart /= 10;
                    }
                }
                while (tmp[i] && p < end) *p++ = tmp[i++];
                if (p < end) *p++ = '.';
                /* Print a few decimal places */
                val -= (unsigned long)val;
                for (int d = 0; d < 6 && p < end; d++) {
                    val *= 10;
                    int digit = (int)val;
                    *p++ = '0' + digit;
                    val -= digit;
                }
                break;
            }
            case '%':
                if (p < end) *p++ = '%';
                break;
            case '\0':
                break;
            default:
                /* Unknown format, skip */
                break;
        }
        if (*fmt) fmt++;
    }
    
    *p = '\0';
    return (int)(p - buf);
}

static inline int snprintf(char* buf, size_t size, const char* fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    int r = vsnprintf(buf, size, fmt, ap);
    va_end(ap);
    return r;
}

static inline int fprintf(FILE* fp, const char* fmt, ...) {
    char buf[1024];
    va_list ap;
    va_start(ap, fmt);
    int r = vsnprintf(buf, sizeof(buf), fmt, ap);
    va_end(ap);
    int fd = (fp == stderr) ? STDERR : STDOUT;
    sys_write(fd, buf, test_strlen(buf));
    return r;
}

static inline int printf(const char* fmt, ...) {
    char buf[1024];
    va_list ap;
    va_start(ap, fmt);
    int r = vsnprintf(buf, sizeof(buf), fmt, ap);
    va_end(ap);
    sys_write(STDOUT, buf, test_strlen(buf));
    return r;
}

/* ========== 12. FILE* stubs ========== */
#define EOF (-1)
#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2

static inline FILE* fopen(const char* path, const char* mode) {
    (void)path; (void)mode;
    return NULL; /* No file access in bare metal */
}

static inline int fclose(FILE* fp) {
    (void)fp;
    return 0;
}

static inline size_t fread(void* ptr, size_t size, size_t nmemb, FILE* fp) {
    (void)ptr; (void)size; (void)nmemb; (void)fp;
    return 0;
}

static inline size_t fwrite(const void* ptr, size_t size, size_t nmemb, FILE* fp) {
    int fd = (fp == stderr) ? STDERR : STDOUT;
    sys_write(fd, ptr, size * nmemb);
    return nmemb;
}

static inline int fseek(FILE* fp, long offset, int whence) {
    (void)fp; (void)offset; (void)whence;
    return -1;
}

static inline long ftell(FILE* fp) {
    (void)fp;
    return -1;
}

static inline void rewind(FILE* fp) {
    (void)fp;
}

static inline int feof(FILE* fp) {
    (void)fp;
    return 0;
}

static inline int ferror(FILE* fp) {
    (void)fp;
    return 0;
}

static inline void clearerr(FILE* fp) {
    (void)fp;
}

static inline int fflush(FILE* fp) {
    (void)fp;
    return 0;
}

static inline int fputs(const char* s, FILE* fp) {
    int fd = (fp == stderr) ? STDERR : STDOUT;
    sys_write(fd, s, test_strlen(s));
    return 0;
}

static inline int fputc(int c, FILE* fp) {
    char ch = (char)c;
    int fd = (fp == stderr) ? STDERR : STDOUT;
    sys_write(fd, &ch, 1);
    return c;
}

static inline int putc(int c, FILE* fp) {
    return fputc(c, fp);
}

static inline int putchar(int c) {
    char ch = (char)c;
    sys_write(STDOUT, &ch, 1);
    return c;
}

static inline int puts(const char* s) {
    sys_write(STDOUT, s, test_strlen(s));
    sys_write(STDOUT, "\n", 1);
    return 0;
}

static inline char* fgets(char* s, int size, FILE* fp) {
    (void)s; (void)size; (void)fp;
    return NULL;
}

static inline int getc(FILE* fp) {
    (void)fp;
    return EOF;
}

static inline int getchar(void) {
    return EOF;
}

/* vfprintf - must come after FILE is defined */
static inline int vfprintf(FILE* fp, const char* fmt, va_list ap) {
    char buf[1024];
    int r = vsnprintf(buf, sizeof(buf), fmt, ap);
    int fd = (fp == stderr) ? STDERR : STDOUT;
    sys_write(fd, buf, test_strlen(buf));
    return r;
}

/* ========== 13. SIMDe compatibility ========== */
/* simde_abort is already defined in SIMDe test.h when SIMDE_TEST_BARE is set,
 * so we don't redefine it here. Instead, we just ensure abort() is available. */

/* SIMDe uses exit() in some places */
static inline void exit(int status) {
    sys_exit(status);
}

/* abort() */
static inline void abort(void) {
    sys_exit(134); /* SIGABRT exit code */
}

/* Override SIMDe's simde_abort if needed */
#ifdef simde_abort
#undef simde_abort
#endif
#define simde_abort() abort()

/* atoi */
static inline int atoi(const char* s) {
    int r = 0;
    int neg = 0;
    if (*s == '-') { neg = 1; s++; }
    while (*s >= '0' && *s <= '9') {
        r = r * 10 + (*s - '0');
        s++;
    }
    return neg ? -r : r;
}

/* strtol */
static inline long strtol(const char* s, char** endptr, int base) {
    long r = 0;
    int neg = 0;
    while (*s == ' ' || *s == '\t') s++;
    if (*s == '-') { neg = 1; s++; }
    else if (*s == '+') s++;
    if (base == 0) {
        if (*s == '0') {
            base = 8;
            s++;
            if (*s == 'x' || *s == 'X') { base = 16; s++; }
        } else {
            base = 10;
        }
    }
    while (*s) {
        int d;
        if (*s >= '0' && *s <= '9') d = *s - '0';
        else if (*s >= 'a' && *s <= 'z') d = *s - 'a' + 10;
        else if (*s >= 'A' && *s <= 'Z') d = *s - 'A' + 10;
        else break;
        if (d >= base) break;
        r = r * base + d;
        s++;
    }
    if (endptr) *endptr = (char*)s;
    return neg ? -r : r;
}

/* strtoul */
static inline unsigned long strtoul(const char* s, char** endptr, int base) {
    unsigned long r = 0;
    while (*s == ' ' || *s == '\t') s++;
    if (*s == '+') s++;
    if (base == 0) {
        if (*s == '0') {
            base = 8;
            s++;
            if (*s == 'x' || *s == 'X') { base = 16; s++; }
        } else {
            base = 10;
        }
    }
    while (*s) {
        int d;
        if (*s >= '0' && *s <= '9') d = *s - '0';
        else if (*s >= 'a' && *s <= 'z') d = *s - 'a' + 10;
        else if (*s >= 'A' && *s <= 'Z') d = *s - 'A' + 10;
        else break;
        if (d >= base) break;
        r = r * base + d;
        s++;
    }
    if (endptr) *endptr = (char*)s;
    return r;
}

/* ========== 14. Assert macro ========== */
#ifdef NDEBUG
#define assert(cond) ((void)0)
#else
#define assert(cond) do { \
    if (!(cond)) { \
        sys_write(STDERR, "Assertion failed: " #cond "\n", \
                  sizeof("Assertion failed: " #cond "\n")); \
        sys_exit(1); \
    } \
} while(0)
#endif

/* ========== 15. Inttypes and stdint macros ========== */
/* UINT32_C, INT32_C, etc. */
#define INT8_C(x)   (x)
#define INT16_C(x)  (x)
#define INT32_C(x)  ((int32_t)(x))
#define INT64_C(x)  ((int64_t)(x))
#define UINT8_C(x)  (x##U)
#define UINT16_C(x) (x##U)
#define UINT32_C(x) ((uint32_t)(x))
#define UINT64_C(x) ((uint64_t)(x))

#define PRId8 "d"
#define PRId16 "d"
#define PRId32 "ld"
#define PRId64 "ld"
#define PRIi8 "i"
#define PRIi16 "i"
#define PRIi32 "li"
#define PRIi64 "li"
#define PRIu8 "u"
#define PRIu16 "u"
#define PRIu32 "lu"
#define PRIu64 "lu"
#define PRIx8 "x"
#define PRIx16 "x"
#define PRIx32 "lx"
#define PRIx64 "lx"
#define PRIX8 "X"
#define PRIX16 "X"
#define PRIX32 "lX"
#define PRIX64 "lX"

/* ========== 16. Limits ========== */
#define INT8_MIN   (-128)
#define INT16_MIN  (-32768)
#define INT32_MIN  (-2147483647-1)
#define INT64_MIN  (-9223372036854775807LL-1)
#define INT8_MAX   127
#define INT16_MAX  32767
#define INT32_MAX  2147483647
#define INT64_MAX  9223372036854775807LL
#define UINT8_MAX  255
#define UINT16_MAX 65535
#define UINT32_MAX 4294967295U
#define UINT64_MAX 18446744073709551615ULL

#endif /* SIMDE_BARE_ADAPT_H */
