#include "syscall_arch.h"
#include "syscall_ids.h"

#define __scc(x) ((long)(x))

/*
 * 将参数统一转换为 long 后，转发到底层 __syscallN 内联函数。
 */
#define __do_syscall __syscall
#define __do_syscall0(n) __syscall0(__scc(n))
#define __do_syscall1(n, a) __syscall1(__scc(n), __scc(a))
#define __do_syscall2(n, a, b) __syscall2(__scc(n), __scc(a), __scc(b))
#define __do_syscall3(n, a, b, c) __syscall3(__scc(n), __scc(a), __scc(b), __scc(c))
#define __do_syscall4(n, a, b, c, d) __syscall4(__scc(n), __scc(a), __scc(b), __scc(c), __scc(d))
#define __do_syscall5(n, a, b, c, d, e) __syscall5(__scc(n), __scc(a), __scc(b), __scc(c), __scc(d), __scc(e))
#define __do_syscall6(n, a, b, c, d, e, f) \
    __syscall6(__scc(n), __scc(a), __scc(b), __scc(c), __scc(d), __scc(e), __scc(f))

/* 统计变参个数，选择对应的 __do_syscallN 宏 */
#define __SYSCALL_NARGS_X(a, b, c, d, e, f, g, h, n, ...) n
#define __SYSCALL_NARGS(...) \
    __SYSCALL_NARGS_X(__VA_ARGS__, 7, 6, 5, 4, 3, 2, 1, 0, )

#define __SYS_CONCAT_X(a, b) a##b
#define __SYS_CONCAT(a, b) __SYS_CONCAT_X(a, b)
#define __SYS_DISPATCH(b, ...) \
    __SYS_CONCAT(b, __SYSCALL_NARGS(__VA_ARGS__))(__VA_ARGS__)

#define syscall(...) __SYS_DISPATCH(__do_syscall, __VA_ARGS__)