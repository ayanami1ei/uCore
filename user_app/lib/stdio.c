#include <stdarg.h>
#include <stddef.h>
#include "stdio.h"
#include "unistd.h"

static void uputc(char c)
{
    write(stdout, &c, 1);
}

static void uputs(const char *s, int *count)
{
    if (!s)
    {
        s = "(null)";
    }
    size_t len = 0;
    const char *p = s;
    while (*p++)
        len++;

    if (len > 0)
        write(stdout, s, len);

    if (count)
        (*count) += (int)len;
}

static int print_unsigned(unsigned long value, int base, int uppercase)
{
    char buf[32];
    const char *digits_lower = "0123456789abcdef";
    const char *digits_upper = "0123456789ABCDEF";
    const char *digits = uppercase ? digits_upper : digits_lower;
    int i = 0;

    if (value == 0)
    {
        buf[i++] = '0';
    }
    else
    {
        while (value != 0 && i < (int)sizeof(buf))
        {
            int d = value % base;
            buf[i++] = digits[d];
            value /= base;
        }
    }

    // reverse in-place
    for (int l = 0, r = i - 1; l < r; ++l, --r)
    {
        char tmp = buf[l];
        buf[l] = buf[r];
        buf[r] = tmp;
    }

    write(stdout, buf, i);
    return i;
}

static int print_signed(long value, int base)
{
    unsigned long u;
    int count = 0;

    if (value < 0)
    {
        uputc('-');
        count++;
        u = (unsigned long)(-value);
    }
    else
    {
        u = (unsigned long)value;
    }

    count += print_unsigned(u, base, 0);
    return count;
}

static int print_pointer(const void *ptr)
{
    char buf[2 + 32];
    int idx = 0;

    buf[idx++] = '0';
    buf[idx++] = 'x';

    unsigned long value = (unsigned long)ptr;
    char tmp[32];
    int i = 0;
    const char *digits = "0123456789abcdef";

    if (value == 0)
    {
        tmp[i++] = '0';
    }
    else
    {
        while (value != 0 && i < (int)sizeof(tmp))
        {
            int d = value % 16;
            tmp[i++] = digits[d];
            value /= 16;
        }
    }

    while (i-- > 0 && idx < (int)sizeof(buf))
    {
        buf[idx++] = tmp[i];
    }

    write(stdout, buf, idx);
    return idx;
}

int vprintf(const char *fmt, va_list ap)
{
    int count = 0;

    for (; *fmt; fmt++)
    {
        if (*fmt != '%')
        {
            uputc(*fmt);
            count++;
            continue;
        }

        fmt++; // skip '%'

        if (*fmt == '\0')
            break;

        int long_flag = 0;
        while (*fmt == 'l')
        {
            long_flag++;
            fmt++;
        }

        switch (*fmt)
        {
        case 'd':
        case 'i':
            if (long_flag)
            {
                long v = va_arg(ap, long);
                count += print_signed(v, 10);
            }
            else
            {
                int v = va_arg(ap, int);
                count += print_signed(v, 10);
            }
            break;
        case 'u':
            if (long_flag)
            {
                unsigned long v = va_arg(ap, unsigned long);
                count += print_unsigned(v, 10, 0);
            }
            else
            {
                unsigned int v = va_arg(ap, unsigned int);
                count += print_unsigned(v, 10, 0);
            }
            break;
        case 'x':
            if (long_flag)
            {
                unsigned long v = va_arg(ap, unsigned long);
                count += print_unsigned(v, 16, 0);
            }
            else
            {
                unsigned int v = va_arg(ap, unsigned int);
                count += print_unsigned(v, 16, 0);
            }
            break;
        case 'X':
            if (long_flag)
            {
                unsigned long v = va_arg(ap, unsigned long);
                count += print_unsigned(v, 16, 1);
            }
            else
            {
                unsigned int v = va_arg(ap, unsigned int);
                count += print_unsigned(v, 16, 1);
            }
            break;
        case 'p':
        {
            void *p = va_arg(ap, void *);
            count += print_pointer(p);
            break;
        }
        case 'c':
        {
            int c = va_arg(ap, int);
            uputc((char)c);
            count++;
            break;
        }
        case 's':
        {
            const char *s = va_arg(ap, const char *);
            uputs(s, &count);
            break;
        }
        case '%':
            uputc('%');
            count++;
            break;
        default:
            uputs("[?]", &count);
            break;
        }
    }

    return count;
}

int printf(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    int ret = vprintf(fmt, ap);
    va_end(ap);
    return ret;
}
