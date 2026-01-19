
bin/user_app.elf:     file format elf32-i386


Disassembly of section .startup:

00800000 <_start>:
.section .text.entry
.globl _start
_start:
    # push argc(0) and argv(NULL)
    push $0
  800000:	6a 00                	push   $0x0
    push $0
  800002:	6a 00                	push   $0x0
    call __start_main
  800004:	e8 03 00 00 00       	call   80000c <__start_main>

00800009 <.hang>:
.hang:
    hlt
  800009:	f4                   	hlt
    jmp .hang
  80000a:	eb fd                	jmp    800009 <.hang>

Disassembly of section .text:

0080000c <__start_main>:
#include "unistd.h"

extern int main(int, char **);

int __start_main(int argc, char **argv)
{
  80000c:	55                   	push   %ebp
  80000d:	89 e5                	mov    %esp,%ebp
  80000f:	83 ec 10             	sub    $0x10,%esp
    exit(main(argc, argv));
  800012:	ff 75 0c             	push   0xc(%ebp)
  800015:	ff 75 08             	push   0x8(%ebp)
  800018:	e8 ab 05 00 00       	call   8005c8 <main>
  80001d:	89 04 24             	mov    %eax,(%esp)
  800020:	e8 7b 05 00 00       	call   8005a0 <exit>
    return 0;
  800025:	31 c0                	xor    %eax,%eax
  800027:	c9                   	leave
  800028:	c3                   	ret
  800029:	66 90                	xchg   %ax,%ax
  80002b:	90                   	nop

0080002c <malloc>:

static block_t *heap_start = NULL;
static block_t *last_block = NULL;

void *malloc(size_t size)
{
  80002c:	55                   	push   %ebp
  80002d:	89 e5                	mov    %esp,%ebp
  80002f:	57                   	push   %edi
  800030:	56                   	push   %esi
  800031:	8b 75 08             	mov    0x8(%ebp),%esi
  800034:	8b 7d 0c             	mov    0xc(%ebp),%edi
    if (size == 0)
  800037:	89 f0                	mov    %esi,%eax
  800039:	09 f8                	or     %edi,%eax
  80003b:	0f 84 8f 00 00 00    	je     8000d0 <malloc+0xa4>
        return NULL;

    size = ALIGN(size);
  800041:	83 c6 07             	add    $0x7,%esi
  800044:	83 d7 00             	adc    $0x0,%edi
  800047:	83 e6 f8             	and    $0xfffffff8,%esi

    // 查找空闲块
    block_t *current = heap_start;
  80004a:	a1 20 08 80 00       	mov    0x800820,%eax
    while (current)
  80004f:	85 c0                	test   %eax,%eax
  800051:	74 18                	je     80006b <malloc+0x3f>
  800053:	90                   	nop
    {
        if (current->free && current->size >= size)
  800054:	8b 48 0c             	mov    0xc(%eax),%ecx
  800057:	85 c9                	test   %ecx,%ecx
  800059:	74 09                	je     800064 <malloc+0x38>
  80005b:	8b 50 04             	mov    0x4(%eax),%edx
  80005e:	39 30                	cmp    %esi,(%eax)
  800060:	19 fa                	sbb    %edi,%edx
  800062:	73 58                	jae    8000bc <malloc+0x90>
        {
            current->free = 0;
            return (void *)(current + 1);
        }
        current = current->next;
  800064:	8b 40 08             	mov    0x8(%eax),%eax
    while (current)
  800067:	85 c0                	test   %eax,%eax
  800069:	75 e9                	jne    800054 <malloc+0x28>
    }

    // 没有找到，扩展堆
    size_t total_size = sizeof(block_t) + size;
    void *new_block = sbrk(total_size);
  80006b:	83 ec 08             	sub    $0x8,%esp
    size_t total_size = sizeof(block_t) + size;
  80006e:	89 f0                	mov    %esi,%eax
  800070:	89 fa                	mov    %edi,%edx
  800072:	83 c0 10             	add    $0x10,%eax
  800075:	83 d2 00             	adc    $0x0,%edx
    void *new_block = sbrk(total_size);
  800078:	52                   	push   %edx
  800079:	50                   	push   %eax
  80007a:	e8 35 05 00 00       	call   8005b4 <sbrk>
    if (new_block == (void *)-1)
  80007f:	83 c4 10             	add    $0x10,%esp
  800082:	83 f8 ff             	cmp    $0xffffffff,%eax
  800085:	74 49                	je     8000d0 <malloc+0xa4>
        return NULL;

    block_t *blk = (block_t *)new_block;
    blk->size = size;
  800087:	89 30                	mov    %esi,(%eax)
  800089:	89 78 04             	mov    %edi,0x4(%eax)
    blk->next = NULL;
  80008c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    blk->free = 0;
  800093:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

    if (!heap_start)
  80009a:	8b 15 20 08 80 00    	mov    0x800820,%edx
  8000a0:	85 d2                	test   %edx,%edx
  8000a2:	74 38                	je     8000dc <malloc+0xb0>
    {
        heap_start = blk;
    }
    else
    {
        last_block->next = blk;
  8000a4:	8b 15 1c 08 80 00    	mov    0x80081c,%edx
  8000aa:	89 42 08             	mov    %eax,0x8(%edx)
    }
    last_block = blk;
  8000ad:	a3 1c 08 80 00       	mov    %eax,0x80081c

    return (void *)(blk + 1);
  8000b2:	83 c0 10             	add    $0x10,%eax
}
  8000b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret
            current->free = 0;
  8000bc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
            return (void *)(current + 1);
  8000c3:	83 c0 10             	add    $0x10,%eax
}
  8000c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c9:	5e                   	pop    %esi
  8000ca:	5f                   	pop    %edi
  8000cb:	5d                   	pop    %ebp
  8000cc:	c3                   	ret
  8000cd:	8d 76 00             	lea    0x0(%esi),%esi
        return NULL;
  8000d0:	31 c0                	xor    %eax,%eax
}
  8000d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000d5:	5e                   	pop    %esi
  8000d6:	5f                   	pop    %edi
  8000d7:	5d                   	pop    %ebp
  8000d8:	c3                   	ret
  8000d9:	8d 76 00             	lea    0x0(%esi),%esi
        heap_start = blk;
  8000dc:	a3 20 08 80 00       	mov    %eax,0x800820
  8000e1:	eb ca                	jmp    8000ad <malloc+0x81>
  8000e3:	90                   	nop

008000e4 <free>:

void free(void *ptr)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	8b 45 08             	mov    0x8(%ebp),%eax
    if (!ptr)
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	74 07                	je     8000f5 <free+0x11>
        return;

    block_t *blk = (block_t *)ptr - 1;
    blk->free = 1;
  8000ee:	c7 40 fc 01 00 00 00 	movl   $0x1,-0x4(%eax)

    // 可选：合并空闲块，但简化版不做
  8000f5:	5d                   	pop    %ebp
  8000f6:	c3                   	ret
  8000f7:	90                   	nop

008000f8 <print_unsigned>:
    if (count)
        (*count) += (int)len;
}

static int print_unsigned(unsigned long value, int base, int uppercase)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	57                   	push   %edi
  8000fc:	56                   	push   %esi
  8000fd:	53                   	push   %ebx
  8000fe:	83 ec 3c             	sub    $0x3c,%esp
  800101:	89 c3                	mov    %eax,%ebx
  800103:	89 d6                	mov    %edx,%esi
    char buf[32];
    const char *digits_lower = "0123456789abcdef";
    const char *digits_upper = "0123456789ABCDEF";
    const char *digits = uppercase ? digits_upper : digits_lower;
  800105:	85 c9                	test   %ecx,%ecx
  800107:	74 33                	je     80013c <print_unsigned+0x44>
  800109:	bf 80 06 80 00       	mov    $0x800680,%edi
    int i = 0;

    if (value == 0)
  80010e:	85 db                	test   %ebx,%ebx
  800110:	75 33                	jne    800145 <print_unsigned+0x4d>
    {
        buf[i++] = '0';
  800112:	c6 45 c8 30          	movb   $0x30,-0x38(%ebp)
  800116:	be 01 00 00 00       	mov    $0x1,%esi
  80011b:	31 ff                	xor    %edi,%edi
  80011d:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  800124:	8d 55 c8             	lea    -0x38(%ebp),%edx
        char tmp = buf[l];
        buf[l] = buf[r];
        buf[r] = tmp;
    }

    write(stdout, buf, i);
  800127:	57                   	push   %edi
  800128:	56                   	push   %esi
  800129:	52                   	push   %edx
  80012a:	6a 01                	push   $0x1
  80012c:	e8 53 04 00 00       	call   800584 <write>
    return i;
}
  800131:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800134:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800137:	5b                   	pop    %ebx
  800138:	5e                   	pop    %esi
  800139:	5f                   	pop    %edi
  80013a:	5d                   	pop    %ebp
  80013b:	c3                   	ret
    const char *digits = uppercase ? digits_upper : digits_lower;
  80013c:	bf 91 06 80 00       	mov    $0x800691,%edi
    if (value == 0)
  800141:	85 db                	test   %ebx,%ebx
  800143:	74 cd                	je     800112 <print_unsigned+0x1a>
    int i = 0;
  800145:	31 c9                	xor    %ecx,%ecx
  800147:	eb 08                	jmp    800151 <print_unsigned+0x59>
  800149:	8d 76 00             	lea    0x0(%esi),%esi
        while (value != 0 && i < (int)sizeof(buf))
  80014c:	83 f9 20             	cmp    $0x20,%ecx
  80014f:	74 53                	je     8001a4 <print_unsigned+0xac>
            int d = value % base;
  800151:	89 d8                	mov    %ebx,%eax
  800153:	31 d2                	xor    %edx,%edx
  800155:	f7 f6                	div    %esi
            buf[i++] = digits[d];
  800157:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80015a:	41                   	inc    %ecx
  80015b:	8a 14 17             	mov    (%edi,%edx,1),%dl
  80015e:	88 55 c7             	mov    %dl,-0x39(%ebp)
  800161:	88 54 0d c7          	mov    %dl,-0x39(%ebp,%ecx,1)
            value /= base;
  800165:	89 da                	mov    %ebx,%edx
  800167:	89 c3                	mov    %eax,%ebx
        while (value != 0 && i < (int)sizeof(buf))
  800169:	39 f2                	cmp    %esi,%edx
  80016b:	73 df                	jae    80014c <print_unsigned+0x54>
    write(stdout, buf, i);
  80016d:	89 c8                	mov    %ecx,%eax
  80016f:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  800172:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800175:	89 c6                	mov    %eax,%esi
  800177:	89 c7                	mov    %eax,%edi
  800179:	c1 ff 1f             	sar    $0x1f,%edi
    for (int l = 0, r = i - 1; l < r; ++l, --r)
  80017c:	8d 55 c8             	lea    -0x38(%ebp),%edx
  80017f:	85 c9                	test   %ecx,%ecx
  800181:	74 a4                	je     800127 <print_unsigned+0x2f>
  800183:	31 c0                	xor    %eax,%eax
  800185:	8d 55 c8             	lea    -0x38(%ebp),%edx
        char tmp = buf[l];
  800188:	8a 1c 02             	mov    (%edx,%eax,1),%bl
  80018b:	88 5d c7             	mov    %bl,-0x39(%ebp)
        buf[l] = buf[r];
  80018e:	8a 1c 0a             	mov    (%edx,%ecx,1),%bl
  800191:	88 1c 02             	mov    %bl,(%edx,%eax,1)
        buf[r] = tmp;
  800194:	8a 5d c7             	mov    -0x39(%ebp),%bl
  800197:	88 1c 0a             	mov    %bl,(%edx,%ecx,1)
    for (int l = 0, r = i - 1; l < r; ++l, --r)
  80019a:	40                   	inc    %eax
  80019b:	49                   	dec    %ecx
  80019c:	39 c8                	cmp    %ecx,%eax
  80019e:	7c e8                	jl     800188 <print_unsigned+0x90>
  8001a0:	eb 85                	jmp    800127 <print_unsigned+0x2f>
  8001a2:	66 90                	xchg   %ax,%ax
  8001a4:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  8001a7:	b9 1f 00 00 00       	mov    $0x1f,%ecx
  8001ac:	be 20 00 00 00       	mov    $0x20,%esi
  8001b1:	31 ff                	xor    %edi,%edi
  8001b3:	eb ce                	jmp    800183 <print_unsigned+0x8b>
  8001b5:	8d 76 00             	lea    0x0(%esi),%esi

008001b8 <vprintf>:
    write(stdout, buf, idx);
    return idx;
}

int vprintf(const char *fmt, va_list ap)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	57                   	push   %edi
  8001bc:	56                   	push   %esi
  8001bd:	53                   	push   %ebx
  8001be:	83 ec 6c             	sub    $0x6c,%esp
  8001c1:	8b 75 08             	mov    0x8(%ebp),%esi
    int count = 0;

    for (; *fmt; fmt++)
  8001c4:	8a 06                	mov    (%esi),%al
    int count = 0;
  8001c6:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
    for (; *fmt; fmt++)
  8001cd:	84 c0                	test   %al,%al
  8001cf:	75 2b                	jne    8001fc <vprintf+0x44>
  8001d1:	e9 88 00 00 00       	jmp    80025e <vprintf+0xa6>
  8001d6:	66 90                	xchg   %ax,%ax
    {
        if (*fmt != '%')
        {
            uputc(*fmt);
  8001d8:	88 45 c6             	mov    %al,-0x3a(%ebp)
    write(stdout, &c, 1);
  8001db:	6a 00                	push   $0x0
  8001dd:	6a 01                	push   $0x1
  8001df:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  8001e2:	50                   	push   %eax
  8001e3:	6a 01                	push   $0x1
  8001e5:	e8 9a 03 00 00       	call   800584 <write>
            count++;
  8001ea:	ff 45 94             	incl   -0x6c(%ebp)
            continue;
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	89 f3                	mov    %esi,%ebx
    for (; *fmt; fmt++)
  8001f2:	8d 73 01             	lea    0x1(%ebx),%esi
  8001f5:	8a 43 01             	mov    0x1(%ebx),%al
  8001f8:	84 c0                	test   %al,%al
  8001fa:	74 62                	je     80025e <vprintf+0xa6>
        if (*fmt != '%')
  8001fc:	3c 25                	cmp    $0x25,%al
  8001fe:	75 d8                	jne    8001d8 <vprintf+0x20>
        }

        fmt++; // skip '%'

        if (*fmt == '\0')
  800200:	8a 46 01             	mov    0x1(%esi),%al
  800203:	84 c0                	test   %al,%al
  800205:	74 57                	je     80025e <vprintf+0xa6>
        fmt++; // skip '%'
  800207:	8d 5e 01             	lea    0x1(%esi),%ebx
            break;

        int long_flag = 0;
        while (*fmt == 'l')
  80020a:	3c 6c                	cmp    $0x6c,%al
  80020c:	0f 85 e6 01 00 00    	jne    8003f8 <vprintf+0x240>
  800212:	66 90                	xchg   %ax,%ax
        {
            long_flag++;
            fmt++;
  800214:	43                   	inc    %ebx
        while (*fmt == 'l')
  800215:	8a 03                	mov    (%ebx),%al
  800217:	3c 6c                	cmp    $0x6c,%al
  800219:	74 f9                	je     800214 <vprintf+0x5c>
        }

        switch (*fmt)
  80021b:	3c 25                	cmp    $0x25,%al
  80021d:	0f 84 d9 01 00 00    	je     8003fc <vprintf+0x244>
  800223:	83 e8 58             	sub    $0x58,%eax
  800226:	3c 20                	cmp    $0x20,%al
  800228:	77 0a                	ja     800234 <vprintf+0x7c>
  80022a:	0f b6 c0             	movzbl %al,%eax
  80022d:	ff 24 85 b0 06 80 00 	jmp    *0x8006b0(,%eax,4)
    size_t len = 0;
  800234:	31 f6                	xor    %esi,%esi
  800236:	31 ff                	xor    %edi,%edi
        len++;
  800238:	83 c6 01             	add    $0x1,%esi
  80023b:	83 d7 00             	adc    $0x0,%edi
    while (*p++)
  80023e:	89 f0                	mov    %esi,%eax
  800240:	80 be a9 06 80 00 00 	cmpb   $0x0,0x8006a9(%esi)
  800247:	75 ef                	jne    800238 <vprintf+0x80>
    if (len > 0)
  800249:	09 f8                	or     %edi,%eax
  80024b:	0f 85 0d 02 00 00    	jne    80045e <vprintf+0x2a6>
        (*count) += (int)len;
  800251:	01 75 94             	add    %esi,-0x6c(%ebp)
    for (; *fmt; fmt++)
  800254:	8d 73 01             	lea    0x1(%ebx),%esi
  800257:	8a 43 01             	mov    0x1(%ebx),%al
  80025a:	84 c0                	test   %al,%al
  80025c:	75 9e                	jne    8001fc <vprintf+0x44>
            break;
        }
    }

    return count;
}
  80025e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800261:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800264:	5b                   	pop    %ebx
  800265:	5e                   	pop    %esi
  800266:	5f                   	pop    %edi
  800267:	5d                   	pop    %ebp
  800268:	c3                   	ret
                long v = va_arg(ap, long);
  800269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026c:	8b 30                	mov    (%eax),%esi
    if (value < 0)
  80026e:	85 f6                	test   %esi,%esi
  800270:	0f 88 16 02 00 00    	js     80048c <vprintf+0x2d4>
        u = (unsigned long)value;
  800276:	89 f0                	mov    %esi,%eax
    int count = 0;
  800278:	31 f6                	xor    %esi,%esi
                long v = va_arg(ap, long);
  80027a:	83 45 0c 04          	addl   $0x4,0xc(%ebp)
    count += print_unsigned(u, base, 0);
  80027e:	31 c9                	xor    %ecx,%ecx
  800280:	ba 0a 00 00 00       	mov    $0xa,%edx
  800285:	e8 6e fe ff ff       	call   8000f8 <print_unsigned>
  80028a:	01 f0                	add    %esi,%eax
                count += print_signed(v, 10);
  80028c:	01 45 94             	add    %eax,-0x6c(%ebp)
  80028f:	e9 5e ff ff ff       	jmp    8001f2 <vprintf+0x3a>
            void *p = va_arg(ap, void *);
  800294:	8b 45 0c             	mov    0xc(%ebp),%eax
  800297:	8d 78 04             	lea    0x4(%eax),%edi
  80029a:	8b 00                	mov    (%eax),%eax
    buf[idx++] = '0';
  80029c:	66 c7 45 c6 30 78    	movw   $0x7830,-0x3a(%ebp)
    if (value == 0)
  8002a2:	85 c0                	test   %eax,%eax
  8002a4:	0f 84 cd 01 00 00    	je     800477 <vprintf+0x2bf>
    int i = 0;
  8002aa:	31 c9                	xor    %ecx,%ecx
  8002ac:	89 5d 8c             	mov    %ebx,-0x74(%ebp)
  8002af:	eb 0c                	jmp    8002bd <vprintf+0x105>
  8002b1:	8d 76 00             	lea    0x0(%esi),%esi
        while (value != 0 && i < (int)sizeof(tmp))
  8002b4:	83 f9 20             	cmp    $0x20,%ecx
  8002b7:	0f 84 ff 01 00 00    	je     8004bc <vprintf+0x304>
            tmp[i++] = digits[d];
  8002bd:	89 ca                	mov    %ecx,%edx
  8002bf:	8d 49 01             	lea    0x1(%ecx),%ecx
  8002c2:	89 c6                	mov    %eax,%esi
  8002c4:	83 e6 0f             	and    $0xf,%esi
  8002c7:	8a 9e 91 06 80 00    	mov    0x800691(%esi),%bl
  8002cd:	88 5d 90             	mov    %bl,-0x70(%ebp)
  8002d0:	88 5c 15 a6          	mov    %bl,-0x5a(%ebp,%edx,1)
        while (value != 0 && i < (int)sizeof(tmp))
  8002d4:	c1 e8 04             	shr    $0x4,%eax
  8002d7:	75 db                	jne    8002b4 <vprintf+0xfc>
  8002d9:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8002dc:	8d 45 a6             	lea    -0x5a(%ebp),%eax
  8002df:	8d 54 15 a6          	lea    -0x5a(%ebp,%edx,1),%edx
  8002e3:	be 02 00 00 00       	mov    $0x2,%esi
  8002e8:	eb 0c                	jmp    8002f6 <vprintf+0x13e>
  8002ea:	66 90                	xchg   %ax,%ax
    while (i-- > 0 && idx < (int)sizeof(buf))
  8002ec:	4a                   	dec    %edx
  8002ed:	83 fe 22             	cmp    $0x22,%esi
  8002f0:	0f 84 ba 01 00 00    	je     8004b0 <vprintf+0x2f8>
        buf[idx++] = tmp[i];
  8002f6:	46                   	inc    %esi
  8002f7:	8a 0a                	mov    (%edx),%cl
  8002f9:	88 4c 35 c5          	mov    %cl,-0x3b(%ebp,%esi,1)
    while (i-- > 0 && idx < (int)sizeof(buf))
  8002fd:	39 d0                	cmp    %edx,%eax
  8002ff:	75 eb                	jne    8002ec <vprintf+0x134>
    write(stdout, buf, idx);
  800301:	89 f0                	mov    %esi,%eax
  800303:	99                   	cltd
  800304:	52                   	push   %edx
  800305:	50                   	push   %eax
  800306:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  800309:	50                   	push   %eax
  80030a:	6a 01                	push   $0x1
  80030c:	e8 73 02 00 00       	call   800584 <write>
            count += print_pointer(p);
  800311:	01 75 94             	add    %esi,-0x6c(%ebp)
            break;
  800314:	83 c4 10             	add    $0x10,%esp
            void *p = va_arg(ap, void *);
  800317:	89 7d 0c             	mov    %edi,0xc(%ebp)
            break;
  80031a:	e9 d3 fe ff ff       	jmp    8001f2 <vprintf+0x3a>
                long v = va_arg(ap, long);
  80031f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800322:	8d 70 04             	lea    0x4(%eax),%esi
                count += print_unsigned(v, 16, 0);
  800325:	8b 00                	mov    (%eax),%eax
  800327:	31 c9                	xor    %ecx,%ecx
  800329:	ba 10 00 00 00       	mov    $0x10,%edx
  80032e:	e8 c5 fd ff ff       	call   8000f8 <print_unsigned>
  800333:	01 45 94             	add    %eax,-0x6c(%ebp)
                unsigned int v = va_arg(ap, unsigned int);
  800336:	89 75 0c             	mov    %esi,0xc(%ebp)
  800339:	e9 b4 fe ff ff       	jmp    8001f2 <vprintf+0x3a>
            int c = va_arg(ap, int);
  80033e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800341:	8d 70 04             	lea    0x4(%eax),%esi
            uputc((char)c);
  800344:	8b 00                	mov    (%eax),%eax
  800346:	88 45 c6             	mov    %al,-0x3a(%ebp)
    write(stdout, &c, 1);
  800349:	6a 00                	push   $0x0
  80034b:	6a 01                	push   $0x1
  80034d:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  800350:	50                   	push   %eax
  800351:	6a 01                	push   $0x1
  800353:	e8 2c 02 00 00       	call   800584 <write>
            count++;
  800358:	ff 45 94             	incl   -0x6c(%ebp)
            break;
  80035b:	83 c4 10             	add    $0x10,%esp
            int c = va_arg(ap, int);
  80035e:	89 75 0c             	mov    %esi,0xc(%ebp)
            break;
  800361:	e9 8c fe ff ff       	jmp    8001f2 <vprintf+0x3a>
                unsigned int v = va_arg(ap, unsigned int);
  800366:	8b 45 0c             	mov    0xc(%ebp),%eax
  800369:	8d 70 04             	lea    0x4(%eax),%esi
                count += print_unsigned(v, 16, 1);
  80036c:	8b 00                	mov    (%eax),%eax
  80036e:	b9 01 00 00 00       	mov    $0x1,%ecx
  800373:	ba 10 00 00 00       	mov    $0x10,%edx
  800378:	e8 7b fd ff ff       	call   8000f8 <print_unsigned>
  80037d:	01 45 94             	add    %eax,-0x6c(%ebp)
                unsigned int v = va_arg(ap, unsigned int);
  800380:	89 75 0c             	mov    %esi,0xc(%ebp)
  800383:	e9 6a fe ff ff       	jmp    8001f2 <vprintf+0x3a>
                long v = va_arg(ap, long);
  800388:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038b:	8d 70 04             	lea    0x4(%eax),%esi
                count += print_unsigned(v, 10, 0);
  80038e:	8b 00                	mov    (%eax),%eax
  800390:	31 c9                	xor    %ecx,%ecx
  800392:	ba 0a 00 00 00       	mov    $0xa,%edx
  800397:	e8 5c fd ff ff       	call   8000f8 <print_unsigned>
  80039c:	01 45 94             	add    %eax,-0x6c(%ebp)
                unsigned int v = va_arg(ap, unsigned int);
  80039f:	89 75 0c             	mov    %esi,0xc(%ebp)
  8003a2:	e9 4b fe ff ff       	jmp    8001f2 <vprintf+0x3a>
            const char *s = va_arg(ap, const char *);
  8003a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003aa:	83 c0 04             	add    $0x4,%eax
  8003ad:	89 45 90             	mov    %eax,-0x70(%ebp)
  8003b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b3:	8b 00                	mov    (%eax),%eax
    if (!s)
  8003b5:	85 c0                	test   %eax,%eax
  8003b7:	0f 84 c5 00 00 00    	je     800482 <vprintf+0x2ca>
    while (*p++)
  8003bd:	80 38 00             	cmpb   $0x0,(%eax)
  8003c0:	74 28                	je     8003ea <vprintf+0x232>
    size_t len = 0;
  8003c2:	31 f6                	xor    %esi,%esi
  8003c4:	31 ff                	xor    %edi,%edi
  8003c6:	66 90                	xchg   %ax,%ax
        len++;
  8003c8:	83 c6 01             	add    $0x1,%esi
  8003cb:	83 d7 00             	adc    $0x0,%edi
    while (*p++)
  8003ce:	89 f2                	mov    %esi,%edx
  8003d0:	80 3c 30 00          	cmpb   $0x0,(%eax,%esi,1)
  8003d4:	75 f2                	jne    8003c8 <vprintf+0x210>
    if (len > 0)
  8003d6:	09 fa                	or     %edi,%edx
  8003d8:	74 0d                	je     8003e7 <vprintf+0x22f>
        write(stdout, s, len);
  8003da:	57                   	push   %edi
  8003db:	56                   	push   %esi
  8003dc:	50                   	push   %eax
  8003dd:	6a 01                	push   $0x1
  8003df:	e8 a0 01 00 00       	call   800584 <write>
  8003e4:	83 c4 10             	add    $0x10,%esp
        (*count) += (int)len;
  8003e7:	01 75 94             	add    %esi,-0x6c(%ebp)
            const char *s = va_arg(ap, const char *);
  8003ea:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003ed:	89 45 0c             	mov    %eax,0xc(%ebp)
  8003f0:	e9 fd fd ff ff       	jmp    8001f2 <vprintf+0x3a>
  8003f5:	8d 76 00             	lea    0x0(%esi),%esi
        switch (*fmt)
  8003f8:	3c 25                	cmp    $0x25,%al
  8003fa:	75 20                	jne    80041c <vprintf+0x264>
            uputc('%');
  8003fc:	c6 45 c6 25          	movb   $0x25,-0x3a(%ebp)
    write(stdout, &c, 1);
  800400:	6a 00                	push   $0x0
  800402:	6a 01                	push   $0x1
  800404:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  800407:	50                   	push   %eax
  800408:	6a 01                	push   $0x1
  80040a:	e8 75 01 00 00       	call   800584 <write>
            count++;
  80040f:	ff 45 94             	incl   -0x6c(%ebp)
            break;
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	e9 d8 fd ff ff       	jmp    8001f2 <vprintf+0x3a>
  80041a:	66 90                	xchg   %ax,%ax
        switch (*fmt)
  80041c:	83 e8 58             	sub    $0x58,%eax
  80041f:	3c 20                	cmp    $0x20,%al
  800421:	0f 87 0d fe ff ff    	ja     800234 <vprintf+0x7c>
  800427:	0f b6 c0             	movzbl %al,%eax
  80042a:	ff 24 85 34 07 80 00 	jmp    *0x800734(,%eax,4)
                long v = va_arg(ap, long);
  800431:	8b 45 0c             	mov    0xc(%ebp),%eax
  800434:	8d 70 04             	lea    0x4(%eax),%esi
                int v = va_arg(ap, int);
  800437:	8b 38                	mov    (%eax),%edi
    if (value < 0)
  800439:	85 ff                	test   %edi,%edi
  80043b:	0f 88 88 00 00 00    	js     8004c9 <vprintf+0x311>
        u = (unsigned long)value;
  800441:	89 f8                	mov    %edi,%eax
    int count = 0;
  800443:	31 ff                	xor    %edi,%edi
    count += print_unsigned(u, base, 0);
  800445:	31 c9                	xor    %ecx,%ecx
  800447:	ba 0a 00 00 00       	mov    $0xa,%edx
  80044c:	e8 a7 fc ff ff       	call   8000f8 <print_unsigned>
  800451:	01 f8                	add    %edi,%eax
                count += print_signed(v, 10);
  800453:	01 45 94             	add    %eax,-0x6c(%ebp)
                int v = va_arg(ap, int);
  800456:	89 75 0c             	mov    %esi,0xc(%ebp)
  800459:	e9 94 fd ff ff       	jmp    8001f2 <vprintf+0x3a>
        write(stdout, s, len);
  80045e:	57                   	push   %edi
  80045f:	56                   	push   %esi
  800460:	68 a9 06 80 00       	push   $0x8006a9
  800465:	6a 01                	push   $0x1
  800467:	e8 18 01 00 00       	call   800584 <write>
  80046c:	83 c4 10             	add    $0x10,%esp
        (*count) += (int)len;
  80046f:	01 75 94             	add    %esi,-0x6c(%ebp)
            break;
  800472:	e9 dd fd ff ff       	jmp    800254 <vprintf+0x9c>
        tmp[i++] = '0';
  800477:	c6 45 a6 30          	movb   $0x30,-0x5a(%ebp)
    while (i-- > 0 && idx < (int)sizeof(buf))
  80047b:	31 d2                	xor    %edx,%edx
  80047d:	e9 5a fe ff ff       	jmp    8002dc <vprintf+0x124>
        s = "(null)";
  800482:	b8 a2 06 80 00       	mov    $0x8006a2,%eax
  800487:	e9 36 ff ff ff       	jmp    8003c2 <vprintf+0x20a>
        uputc('-');
  80048c:	c6 45 c6 2d          	movb   $0x2d,-0x3a(%ebp)
    write(stdout, &c, 1);
  800490:	6a 00                	push   $0x0
  800492:	6a 01                	push   $0x1
  800494:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  800497:	50                   	push   %eax
  800498:	6a 01                	push   $0x1
  80049a:	e8 e5 00 00 00       	call   800584 <write>
        u = (unsigned long)(-value);
  80049f:	89 f0                	mov    %esi,%eax
  8004a1:	f7 d8                	neg    %eax
  8004a3:	83 c4 10             	add    $0x10,%esp
        count++;
  8004a6:	be 01 00 00 00       	mov    $0x1,%esi
  8004ab:	e9 ca fd ff ff       	jmp    80027a <vprintf+0xc2>
  8004b0:	b8 22 00 00 00       	mov    $0x22,%eax
  8004b5:	31 d2                	xor    %edx,%edx
  8004b7:	e9 48 fe ff ff       	jmp    800304 <vprintf+0x14c>
  8004bc:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8004bf:	ba 1f 00 00 00       	mov    $0x1f,%edx
  8004c4:	e9 13 fe ff ff       	jmp    8002dc <vprintf+0x124>
        uputc('-');
  8004c9:	c6 45 c6 2d          	movb   $0x2d,-0x3a(%ebp)
    write(stdout, &c, 1);
  8004cd:	6a 00                	push   $0x0
  8004cf:	6a 01                	push   $0x1
  8004d1:	8d 45 c6             	lea    -0x3a(%ebp),%eax
  8004d4:	50                   	push   %eax
  8004d5:	6a 01                	push   $0x1
  8004d7:	e8 a8 00 00 00       	call   800584 <write>
        u = (unsigned long)(-value);
  8004dc:	89 f8                	mov    %edi,%eax
  8004de:	f7 d8                	neg    %eax
  8004e0:	83 c4 10             	add    $0x10,%esp
        count++;
  8004e3:	bf 01 00 00 00       	mov    $0x1,%edi
  8004e8:	e9 58 ff ff ff       	jmp    800445 <vprintf+0x28d>
  8004ed:	8d 76 00             	lea    0x0(%esi),%esi

008004f0 <printf>:

int printf(const char *fmt, ...)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
  8004f6:	8d 45 0c             	lea    0xc(%ebp),%eax
    int ret = vprintf(fmt, ap);
  8004f9:	50                   	push   %eax
  8004fa:	ff 75 08             	push   0x8(%ebp)
  8004fd:	e8 b6 fc ff ff       	call   8001b8 <vprintf>
    va_end(ap);
    return ret;
}
  800502:	c9                   	leave
  800503:	c3                   	ret

00800504 <memset>:
#include "string.h"

void *memset(void *s, int c, size_t n)
{
  800504:	55                   	push   %ebp
  800505:	89 e5                	mov    %esp,%ebp
  800507:	57                   	push   %edi
  800508:	56                   	push   %esi
  800509:	53                   	push   %ebx
  80050a:	8b 75 10             	mov    0x10(%ebp),%esi
  80050d:	8b 7d 14             	mov    0x14(%ebp),%edi
    unsigned char *p = s;
    while (n--)
  800510:	89 f0                	mov    %esi,%eax
  800512:	89 fa                	mov    %edi,%edx
  800514:	83 c0 ff             	add    $0xffffffff,%eax
  800517:	83 d2 ff             	adc    $0xffffffff,%edx
  80051a:	89 c1                	mov    %eax,%ecx
  80051c:	89 d3                	mov    %edx,%ebx
  80051e:	89 f0                	mov    %esi,%eax
  800520:	09 f8                	or     %edi,%eax
  800522:	74 1b                	je     80053f <memset+0x3b>
        *p++ = c;
  800524:	8a 45 0c             	mov    0xc(%ebp),%al
    unsigned char *p = s;
  800527:	8b 75 08             	mov    0x8(%ebp),%esi
  80052a:	88 c2                	mov    %al,%dl
        *p++ = c;
  80052c:	46                   	inc    %esi
  80052d:	88 56 ff             	mov    %dl,-0x1(%esi)
    while (n--)
  800530:	83 c1 ff             	add    $0xffffffff,%ecx
  800533:	83 d3 ff             	adc    $0xffffffff,%ebx
  800536:	89 c8                	mov    %ecx,%eax
  800538:	21 d8                	and    %ebx,%eax
  80053a:	83 f8 ff             	cmp    $0xffffffff,%eax
  80053d:	75 ed                	jne    80052c <memset+0x28>
    return s;
}
  80053f:	8b 45 08             	mov    0x8(%ebp),%eax
  800542:	5b                   	pop    %ebx
  800543:	5e                   	pop    %esi
  800544:	5f                   	pop    %edi
  800545:	5d                   	pop    %ebp
  800546:	c3                   	ret
  800547:	90                   	nop

00800548 <memcpy>:

void *memcpy(void *dest, const void *src, size_t n)
{
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	57                   	push   %edi
  80054c:	56                   	push   %esi
  80054d:	53                   	push   %ebx
  80054e:	8b 75 0c             	mov    0xc(%ebp),%esi
    unsigned char *d = dest;
    const unsigned char *s = src;
    while (n--)
  800551:	8b 45 10             	mov    0x10(%ebp),%eax
  800554:	8b 55 14             	mov    0x14(%ebp),%edx
  800557:	83 c0 ff             	add    $0xffffffff,%eax
  80055a:	83 d2 ff             	adc    $0xffffffff,%edx
  80055d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800560:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800563:	09 d9                	or     %ebx,%ecx
  800565:	74 15                	je     80057c <memcpy+0x34>
    unsigned char *d = dest;
  800567:	8b 7d 08             	mov    0x8(%ebp),%edi
  80056a:	66 90                	xchg   %ax,%ax
        *d++ = *s++;
  80056c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while (n--)
  80056d:	83 c0 ff             	add    $0xffffffff,%eax
  800570:	83 d2 ff             	adc    $0xffffffff,%edx
  800573:	89 c1                	mov    %eax,%ecx
  800575:	21 d1                	and    %edx,%ecx
  800577:	83 f9 ff             	cmp    $0xffffffff,%ecx
  80057a:	75 f0                	jne    80056c <memcpy+0x24>
    return dest;
  80057c:	8b 45 08             	mov    0x8(%ebp),%eax
  80057f:	5b                   	pop    %ebx
  800580:	5e                   	pop    %esi
  800581:	5f                   	pop    %edi
  800582:	5d                   	pop    %ebp
  800583:	c3                   	ret

00800584 <write>:
#include "syscall.h"
#include "syscall_ids.h"
#include "stddef.h"

ssize_t write(int fd, const void *buf, size_t count)
{
  800584:	55                   	push   %ebp
  800585:	89 e5                	mov    %esp,%ebp
  800587:	53                   	push   %ebx
}

static inline long __syscall3(long n, long a, long b, long c)
{
    long ret;
    __asm__ __volatile__(
  800588:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80058b:	b8 40 00 00 00       	mov    $0x40,%eax
  800590:	8b 55 10             	mov    0x10(%ebp),%edx
  800593:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800596:	cd 80                	int    $0x80
    return (ssize_t)syscall(SYS_write, fd, (long)buf, (long)count);
  800598:	99                   	cltd
}
  800599:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80059c:	c9                   	leave
  80059d:	c3                   	ret
  80059e:	66 90                	xchg   %ax,%ax

008005a0 <exit>:

void exit(int code)
{
  8005a0:	55                   	push   %ebp
  8005a1:	89 e5                	mov    %esp,%ebp
  8005a3:	53                   	push   %ebx
    __asm__ __volatile__(
  8005a4:	b8 5d 00 00 00       	mov    $0x5d,%eax
  8005a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005ac:	cd 80                	int    $0x80
    syscall(SYS_exit, code);
}
  8005ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005b1:	c9                   	leave
  8005b2:	c3                   	ret
  8005b3:	90                   	nop

008005b4 <sbrk>:

void *sbrk(intptr_t increment)
{
  8005b4:	55                   	push   %ebp
  8005b5:	89 e5                	mov    %esp,%ebp
  8005b7:	53                   	push   %ebx
  8005b8:	b8 5e 00 00 00       	mov    $0x5e,%eax
  8005bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005c0:	cd 80                	int    $0x80
    return (void *)syscall(SYS_sbrk, increment);
}
  8005c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005c5:	c9                   	leave
  8005c6:	c3                   	ret
  8005c7:	90                   	nop

008005c8 <main>:
#include"stdio.h"
#include"stdlib.h"
int main() {
  8005c8:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  8005cc:	83 e4 f0             	and    $0xfffffff0,%esp
  8005cf:	ff 71 fc             	push   -0x4(%ecx)
  8005d2:	55                   	push   %ebp
  8005d3:	89 e5                	mov    %esp,%ebp
  8005d5:	57                   	push   %edi
  8005d6:	56                   	push   %esi
  8005d7:	53                   	push   %ebx
  8005d8:	51                   	push   %ecx
  8005d9:	83 ec 24             	sub    $0x24,%esp
   printf("Hello World,there is user app\n");
  8005dc:	68 b8 07 80 00       	push   $0x8007b8
  8005e1:	e8 0a ff ff ff       	call   8004f0 <printf>
   printf("%d + %d = %d\n", 1, 2, 1 + 2);
  8005e6:	6a 03                	push   $0x3
  8005e8:	6a 02                	push   $0x2
  8005ea:	6a 01                	push   $0x1
  8005ec:	68 d7 07 80 00       	push   $0x8007d7
  8005f1:	e8 fa fe ff ff       	call   8004f0 <printf>

   char s[]="Sample String";
  8005f6:	8d 7d da             	lea    -0x26(%ebp),%edi
  8005f9:	be 0c 08 80 00       	mov    $0x80080c,%esi
  8005fe:	b9 0e 00 00 00       	mov    $0xe,%ecx
  800603:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
   printf("String: %s\n", s);
  800605:	83 c4 18             	add    $0x18,%esp
  800608:	8d 45 da             	lea    -0x26(%ebp),%eax
  80060b:	50                   	push   %eax
  80060c:	68 e5 07 80 00       	push   $0x8007e5
  800611:	e8 da fe ff ff       	call   8004f0 <printf>

   int *a=malloc(sizeof(int)*5);
  800616:	5a                   	pop    %edx
  800617:	59                   	pop    %ecx
  800618:	6a 00                	push   $0x0
  80061a:	6a 14                	push   $0x14
  80061c:	e8 0b fa ff ff       	call   80002c <malloc>
  800621:	89 c6                	mov    %eax,%esi

   for (int i=0;i<5;i++) {
       a[i]=i*i;
  800623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800629:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  800630:	c7 40 08 04 00 00 00 	movl   $0x4,0x8(%eax)
  800637:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
  80063e:	c7 40 10 10 00 00 00 	movl   $0x10,0x10(%eax)
   }
   printf("Array elements:\n");
  800645:	c7 04 24 f1 07 80 00 	movl   $0x8007f1,(%esp)
  80064c:	e8 9f fe ff ff       	call   8004f0 <printf>
  800651:	83 c4 10             	add    $0x10,%esp
   for (int i=0;i<5;i++) {
  800654:	31 db                	xor    %ebx,%ebx
  800656:	66 90                	xchg   %ax,%ax
       printf("a[%d]=%d\n",i,a[i]);
  800658:	50                   	push   %eax
  800659:	ff 34 9e             	push   (%esi,%ebx,4)
  80065c:	53                   	push   %ebx
  80065d:	68 02 08 80 00       	push   $0x800802
  800662:	e8 89 fe ff ff       	call   8004f0 <printf>
   for (int i=0;i<5;i++) {
  800667:	43                   	inc    %ebx
  800668:	83 c4 10             	add    $0x10,%esp
  80066b:	83 fb 05             	cmp    $0x5,%ebx
  80066e:	75 e8                	jne    800658 <main+0x90>
   }

   return 0;
  800670:	31 c0                	xor    %eax,%eax
  800672:	8d 65 f0             	lea    -0x10(%ebp),%esp
  800675:	59                   	pop    %ecx
  800676:	5b                   	pop    %ebx
  800677:	5e                   	pop    %esi
  800678:	5f                   	pop    %edi
  800679:	5d                   	pop    %ebp
  80067a:	8d 61 fc             	lea    -0x4(%ecx),%esp
  80067d:	c3                   	ret
