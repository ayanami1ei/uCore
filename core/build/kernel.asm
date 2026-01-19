
build/kernel:     file format elf32-i386


Disassembly of section .text:

0010000c <_start>:
    .section .text.entry, "ax"
    .code32                 # 明确告诉汇编器是 32 位代码
    .globl _start
_start:
    # 初始化内核栈指针 ESP
    mov $boot_stack_top, %esp
  10000c:	bc 00 40 11 00       	mov    $0x114000,%esp

    call main               # 调到 C 里的 main()
  100011:	e8 38 04 00 00       	call   10044e <main>

00100016 <.hang>:

    # 如果 main 返回，简单死循环或停机
.hang:
    hlt
  100016:	f4                   	hlt
    jmp .hang
  100017:	eb fd                	jmp    100016 <.hang>

00100019 <print_unsigned>:
            (*count)++;
    }
}

static int print_unsigned(unsigned long value, int base, int uppercase)
{
  100019:	55                   	push   %ebp
  10001a:	89 e5                	mov    %esp,%ebp
  10001c:	57                   	push   %edi
  10001d:	56                   	push   %esi
  10001e:	53                   	push   %ebx
  10001f:	83 ec 3c             	sub    $0x3c,%esp
  100022:	89 d6                	mov    %edx,%esi
    char buf[32];
    const char *digits_lower = "0123456789abcdef";
    const char *digits_upper = "0123456789ABCDEF";
    const char *digits = uppercase ? digits_upper : digits_lower;
  100024:	85 c9                	test   %ecx,%ecx
  100026:	74 40                	je     100068 <print_unsigned+0x4f>
  100028:	bf 00 20 10 00       	mov    $0x102000,%edi
    int i = 0;

    if (value == 0)
  10002d:	85 c0                	test   %eax,%eax
  10002f:	74 3e                	je     10006f <print_unsigned+0x56>
    int i = 0;
  100031:	b9 00 00 00 00       	mov    $0x0,%ecx
    }

    while (value != 0 && i < (int)sizeof(buf))
    {
        int d = value % base;
        buf[i++] = digits[d];
  100036:	89 c3                	mov    %eax,%ebx
  100038:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  10003b:	41                   	inc    %ecx
        int d = value % base;
  10003c:	89 d8                	mov    %ebx,%eax
  10003e:	ba 00 00 00 00       	mov    $0x0,%edx
  100043:	f7 f6                	div    %esi
        buf[i++] = digits[d];
  100045:	8a 14 17             	mov    (%edi,%edx,1),%dl
  100048:	88 55 c7             	mov    %dl,-0x39(%ebp)
  10004b:	88 54 0d c7          	mov    %dl,-0x39(%ebp,%ecx,1)
        value /= base;
  10004f:	89 da                	mov    %ebx,%edx
  100051:	89 c3                	mov    %eax,%ebx
    while (value != 0 && i < (int)sizeof(buf))
  100053:	39 f2                	cmp    %esi,%edx
  100055:	72 2c                	jb     100083 <print_unsigned+0x6a>
  100057:	83 f9 20             	cmp    $0x20,%ecx
  10005a:	75 dc                	jne    100038 <print_unsigned+0x1f>
  10005c:	be 1f 00 00 00       	mov    $0x1f,%esi
    }

    int count = 0;
    while (i-- > 0)
  100061:	bb 1f 00 00 00       	mov    $0x1f,%ebx
  100066:	eb 24                	jmp    10008c <print_unsigned+0x73>
    const char *digits = uppercase ? digits_upper : digits_lower;
  100068:	bf 11 20 10 00       	mov    $0x102011,%edi
  10006d:	eb be                	jmp    10002d <print_unsigned+0x14>
    put_char(c);
  10006f:	83 ec 0c             	sub    $0xc,%esp
  100072:	6a 30                	push   $0x30
  100074:	e8 06 0c 00 00       	call   100c7f <put_char>
}
  100079:	83 c4 10             	add    $0x10,%esp
        return 1;
  10007c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  100081:	eb 28                	jmp    1000ab <print_unsigned+0x92>
    while (i-- > 0)
  100083:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  100086:	85 c9                	test   %ecx,%ecx
  100088:	7e 29                	jle    1000b3 <print_unsigned+0x9a>
  10008a:	89 de                	mov    %ebx,%esi
    put_char(c);
  10008c:	83 ec 0c             	sub    $0xc,%esp
  10008f:	0f be 44 2b c8       	movsbl -0x38(%ebx,%ebp,1),%eax
  100094:	50                   	push   %eax
  100095:	e8 e5 0b 00 00       	call   100c7f <put_char>
    while (i-- > 0)
  10009a:	89 d8                	mov    %ebx,%eax
  10009c:	4b                   	dec    %ebx
  10009d:	83 c4 10             	add    $0x10,%esp
  1000a0:	85 c0                	test   %eax,%eax
  1000a2:	7f e8                	jg     10008c <print_unsigned+0x73>
  1000a4:	89 f0                	mov    %esi,%eax
  1000a6:	85 f6                	test   %esi,%esi
  1000a8:	78 10                	js     1000ba <print_unsigned+0xa1>
  1000aa:	40                   	inc    %eax
    {
        kputc(buf[i]);
        count++;
    }
    return count;
}
  1000ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  1000ae:	5b                   	pop    %ebx
  1000af:	5e                   	pop    %esi
  1000b0:	5f                   	pop    %edi
  1000b1:	5d                   	pop    %ebp
  1000b2:	c3                   	ret
    return count;
  1000b3:	b8 00 00 00 00       	mov    $0x0,%eax
  1000b8:	eb f1                	jmp    1000ab <print_unsigned+0x92>
  1000ba:	b8 00 00 00 00       	mov    $0x0,%eax
  1000bf:	eb e9                	jmp    1000aa <print_unsigned+0x91>

001000c1 <vprintf>:
    count += print_unsigned((unsigned long long)(uintptr_t)ptr, 16, 0);
    return count;
}

int vprintf(const char *fmt, va_list ap)
{
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	57                   	push   %edi
  1000c5:	56                   	push   %esi
  1000c6:	53                   	push   %ebx
  1000c7:	83 ec 2c             	sub    $0x2c,%esp
  1000ca:	8b 75 08             	mov    0x8(%ebp),%esi
    int count = 0;

    for (; *fmt; fmt++)
  1000cd:	8a 06                	mov    (%esi),%al
  1000cf:	84 c0                	test   %al,%al
  1000d1:	0f 84 2b 03 00 00    	je     100402 <vprintf+0x341>
    int count = 0;
  1000d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1000de:	e9 77 02 00 00       	jmp    10035a <vprintf+0x299>
            continue;
        }

        fmt++; // skip '%'

        if (*fmt == '\0')
  1000e3:	8a 46 01             	mov    0x1(%esi),%al
  1000e6:	84 c0                	test   %al,%al
  1000e8:	0f 84 1b 03 00 00    	je     100409 <vprintf+0x348>
            break;

        // 暂时只支持一个或零个 'l' 修饰符
        int long_flag = 0;
        while (*fmt == 'l')
  1000ee:	3c 6c                	cmp    $0x6c,%al
  1000f0:	0f 85 1e 03 00 00    	jne    100414 <vprintf+0x353>
  1000f6:	8d 4e 02             	lea    0x2(%esi),%ecx
  1000f9:	89 ca                	mov    %ecx,%edx
  1000fb:	41                   	inc    %ecx
  1000fc:	8a 41 ff             	mov    -0x1(%ecx),%al
  1000ff:	3c 6c                	cmp    $0x6c,%al
  100101:	74 f6                	je     1000f9 <vprintf+0x38>
        {
            long_flag++;
            fmt++;
  100103:	89 d7                	mov    %edx,%edi
        }

        switch (*fmt)
  100105:	3c 25                	cmp    $0x25,%al
  100107:	0f 84 d5 02 00 00    	je     1003e2 <vprintf+0x321>
  10010d:	8d 48 a8             	lea    -0x58(%eax),%ecx
  100110:	80 f9 20             	cmp    $0x20,%cl
  100113:	77 14                	ja     100129 <vprintf+0x68>
            long_flag++;
  100115:	29 f2                	sub    %esi,%edx
  100117:	8d 5a ff             	lea    -0x1(%edx),%ebx
        switch (*fmt)
  10011a:	80 f9 20             	cmp    $0x20,%cl
  10011d:	77 0a                	ja     100129 <vprintf+0x68>
  10011f:	0f b6 c1             	movzbl %cl,%eax
  100122:	ff 24 85 88 20 10 00 	jmp    *0x102088(,%eax,4)
    while (*s)
  100129:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10012c:	89 d3                	mov    %edx,%ebx
  10012e:	b0 5b                	mov    $0x5b,%al
  100130:	be 29 20 10 00       	mov    $0x102029,%esi
  100135:	29 d6                	sub    %edx,%esi
    put_char(c);
  100137:	83 ec 0c             	sub    $0xc,%esp
  10013a:	0f be c0             	movsbl %al,%eax
  10013d:	50                   	push   %eax
  10013e:	e8 3c 0b 00 00       	call   100c7f <put_char>
            (*count)++;
  100143:	43                   	inc    %ebx
    while (*s)
  100144:	8a 04 1e             	mov    (%esi,%ebx,1),%al
  100147:	83 c4 10             	add    $0x10,%esp
  10014a:	84 c0                	test   %al,%al
  10014c:	75 e9                	jne    100137 <vprintf+0x76>
  10014e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  100151:	e9 f6 01 00 00       	jmp    10034c <vprintf+0x28b>
        switch (*fmt)
  100156:	bb 00 00 00 00       	mov    $0x0,%ebx
        {
        case 'd':
        case 'i':
            if (long_flag)
  10015b:	85 db                	test   %ebx,%ebx
  10015d:	74 67                	je     1001c6 <vprintf+0x105>
            {
                long long v = va_arg(ap, long long);
  10015f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100162:	83 c0 08             	add    $0x8,%eax
  100165:	89 45 d8             	mov    %eax,-0x28(%ebp)
  100168:	8b 45 0c             	mov    0xc(%ebp),%eax
  10016b:	8b 18                	mov    (%eax),%ebx
  10016d:	8b 70 04             	mov    0x4(%eax),%esi
    if (value < 0)
  100170:	85 f6                	test   %esi,%esi
  100172:	78 2d                	js     1001a1 <vprintf+0xe0>
        u = (unsigned long long)value;
  100174:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  100177:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    int count = 0;
  10017a:	be 00 00 00 00       	mov    $0x0,%esi
    count += print_unsigned(u, base, 0);
  10017f:	b9 00 00 00 00       	mov    $0x0,%ecx
  100184:	ba 0a 00 00 00       	mov    $0xa,%edx
  100189:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10018c:	e8 88 fe ff ff       	call   100019 <print_unsigned>
  100191:	01 f0                	add    %esi,%eax
                count += print_signed(v, 10);
  100193:	01 45 e4             	add    %eax,-0x1c(%ebp)
                long long v = va_arg(ap, long long);
  100196:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100199:	89 45 0c             	mov    %eax,0xc(%ebp)
  10019c:	e9 ab 01 00 00       	jmp    10034c <vprintf+0x28b>
    put_char(c);
  1001a1:	83 ec 0c             	sub    $0xc,%esp
  1001a4:	6a 2d                	push   $0x2d
  1001a6:	e8 d4 0a 00 00       	call   100c7f <put_char>
        u = (unsigned long long)(-value);
  1001ab:	89 d8                	mov    %ebx,%eax
  1001ad:	89 f2                	mov    %esi,%edx
  1001af:	f7 d8                	neg    %eax
  1001b1:	83 d2 00             	adc    $0x0,%edx
  1001b4:	f7 da                	neg    %edx
  1001b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1001b9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1001bc:	83 c4 10             	add    $0x10,%esp
        count++;
  1001bf:	be 01 00 00 00       	mov    $0x1,%esi
  1001c4:	eb b9                	jmp    10017f <vprintf+0xbe>
            }
            else
            {
                int v = va_arg(ap, int);
  1001c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1001c9:	83 c0 04             	add    $0x4,%eax
  1001cc:	89 c6                	mov    %eax,%esi
  1001ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1001d1:	8b 00                	mov    (%eax),%eax
                count += print_signed(v, 10);
  1001d3:	89 c1                	mov    %eax,%ecx
  1001d5:	c1 f9 1f             	sar    $0x1f,%ecx
  1001d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1001db:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    if (value < 0)
  1001de:	78 2a                	js     10020a <vprintf+0x149>
        u = (unsigned long long)value;
  1001e0:	89 c1                	mov    %eax,%ecx
  1001e2:	c1 f9 1f             	sar    $0x1f,%ecx
  1001e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1001e8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    count += print_unsigned(u, base, 0);
  1001eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  1001f0:	ba 0a 00 00 00       	mov    $0xa,%edx
  1001f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1001f8:	e8 1c fe ff ff       	call   100019 <print_unsigned>
  1001fd:	01 d8                	add    %ebx,%eax
                count += print_signed(v, 10);
  1001ff:	01 45 e4             	add    %eax,-0x1c(%ebp)
                int v = va_arg(ap, int);
  100202:	89 75 0c             	mov    %esi,0xc(%ebp)
  100205:	e9 42 01 00 00       	jmp    10034c <vprintf+0x28b>
    put_char(c);
  10020a:	83 ec 0c             	sub    $0xc,%esp
  10020d:	6a 2d                	push   $0x2d
  10020f:	e8 6b 0a 00 00       	call   100c7f <put_char>
        u = (unsigned long long)(-value);
  100214:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100217:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10021a:	f7 d8                	neg    %eax
  10021c:	83 d2 00             	adc    $0x0,%edx
  10021f:	f7 da                	neg    %edx
  100221:	89 45 d8             	mov    %eax,-0x28(%ebp)
  100224:	89 55 dc             	mov    %edx,-0x24(%ebp)
  100227:	83 c4 10             	add    $0x10,%esp
        count++;
  10022a:	bb 01 00 00 00       	mov    $0x1,%ebx
  10022f:	eb ba                	jmp    1001eb <vprintf+0x12a>
        switch (*fmt)
  100231:	bb 00 00 00 00       	mov    $0x0,%ebx
            }
            break;
        case 'u':
            if (long_flag)
  100236:	85 db                	test   %ebx,%ebx
  100238:	74 22                	je     10025c <vprintf+0x19b>
            {
                unsigned long long v = va_arg(ap, unsigned long long);
  10023a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10023d:	8d 58 08             	lea    0x8(%eax),%ebx
                count += print_unsigned(v, 10, 0);
  100240:	8b 00                	mov    (%eax),%eax
  100242:	b9 00 00 00 00       	mov    $0x0,%ecx
  100247:	ba 0a 00 00 00       	mov    $0xa,%edx
  10024c:	e8 c8 fd ff ff       	call   100019 <print_unsigned>
  100251:	01 45 e4             	add    %eax,-0x1c(%ebp)
                unsigned long long v = va_arg(ap, unsigned long long);
  100254:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  100257:	e9 f0 00 00 00       	jmp    10034c <vprintf+0x28b>
            }
            else
            {
                unsigned int v = va_arg(ap, unsigned int);
  10025c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10025f:	8d 58 04             	lea    0x4(%eax),%ebx
                count += print_unsigned(v, 10, 0);
  100262:	8b 00                	mov    (%eax),%eax
  100264:	b9 00 00 00 00       	mov    $0x0,%ecx
  100269:	ba 0a 00 00 00       	mov    $0xa,%edx
  10026e:	e8 a6 fd ff ff       	call   100019 <print_unsigned>
  100273:	01 45 e4             	add    %eax,-0x1c(%ebp)
                unsigned int v = va_arg(ap, unsigned int);
  100276:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  100279:	e9 ce 00 00 00       	jmp    10034c <vprintf+0x28b>
        switch (*fmt)
  10027e:	bb 00 00 00 00       	mov    $0x0,%ebx
            }
            break;
        case 'x':
            if (long_flag)
  100283:	85 db                	test   %ebx,%ebx
  100285:	74 22                	je     1002a9 <vprintf+0x1e8>
            {
                unsigned long long v = va_arg(ap, unsigned long long);
  100287:	8b 45 0c             	mov    0xc(%ebp),%eax
  10028a:	8d 58 08             	lea    0x8(%eax),%ebx
                count += print_unsigned(v, 16, 0);
  10028d:	8b 00                	mov    (%eax),%eax
  10028f:	b9 00 00 00 00       	mov    $0x0,%ecx
  100294:	ba 10 00 00 00       	mov    $0x10,%edx
  100299:	e8 7b fd ff ff       	call   100019 <print_unsigned>
  10029e:	01 45 e4             	add    %eax,-0x1c(%ebp)
                unsigned long long v = va_arg(ap, unsigned long long);
  1002a1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  1002a4:	e9 a3 00 00 00       	jmp    10034c <vprintf+0x28b>
            }
            else
            {
                unsigned int v = va_arg(ap, unsigned int);
  1002a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ac:	8d 58 04             	lea    0x4(%eax),%ebx
                count += print_unsigned(v, 16, 0);
  1002af:	8b 00                	mov    (%eax),%eax
  1002b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  1002b6:	ba 10 00 00 00       	mov    $0x10,%edx
  1002bb:	e8 59 fd ff ff       	call   100019 <print_unsigned>
  1002c0:	01 45 e4             	add    %eax,-0x1c(%ebp)
                unsigned int v = va_arg(ap, unsigned int);
  1002c3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  1002c6:	e9 81 00 00 00       	jmp    10034c <vprintf+0x28b>
            }
            break;
        case 'X':
            if (long_flag)
  1002cb:	85 db                	test   %ebx,%ebx
  1002cd:	74 1f                	je     1002ee <vprintf+0x22d>
            {
                unsigned long long v = va_arg(ap, unsigned long long);
  1002cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d2:	8d 58 08             	lea    0x8(%eax),%ebx
                count += print_unsigned(v, 16, 1);
  1002d5:	8b 00                	mov    (%eax),%eax
  1002d7:	b9 01 00 00 00       	mov    $0x1,%ecx
  1002dc:	ba 10 00 00 00       	mov    $0x10,%edx
  1002e1:	e8 33 fd ff ff       	call   100019 <print_unsigned>
  1002e6:	01 45 e4             	add    %eax,-0x1c(%ebp)
                unsigned long long v = va_arg(ap, unsigned long long);
  1002e9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  1002ec:	eb 5e                	jmp    10034c <vprintf+0x28b>
            }
            else
            {
                unsigned int v = va_arg(ap, unsigned int);
  1002ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002f1:	8d 58 04             	lea    0x4(%eax),%ebx
                count += print_unsigned(v, 16, 1);
  1002f4:	8b 00                	mov    (%eax),%eax
  1002f6:	b9 01 00 00 00       	mov    $0x1,%ecx
  1002fb:	ba 10 00 00 00       	mov    $0x10,%edx
  100300:	e8 14 fd ff ff       	call   100019 <print_unsigned>
  100305:	01 45 e4             	add    %eax,-0x1c(%ebp)
                unsigned int v = va_arg(ap, unsigned int);
  100308:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  10030b:	eb 3f                	jmp    10034c <vprintf+0x28b>
            }
            break;
        case 'p':
        {
            void *p = va_arg(ap, void *);
  10030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100310:	8d 58 04             	lea    0x4(%eax),%ebx
  100313:	8b 30                	mov    (%eax),%esi
    put_char(c);
  100315:	83 ec 0c             	sub    $0xc,%esp
  100318:	6a 30                	push   $0x30
  10031a:	e8 60 09 00 00       	call   100c7f <put_char>
  10031f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  100326:	e8 54 09 00 00       	call   100c7f <put_char>
    count += print_unsigned((unsigned long long)(uintptr_t)ptr, 16, 0);
  10032b:	b9 00 00 00 00       	mov    $0x0,%ecx
  100330:	ba 10 00 00 00       	mov    $0x10,%edx
  100335:	89 f0                	mov    %esi,%eax
  100337:	e8 dd fc ff ff       	call   100019 <print_unsigned>
            count += print_pointer(p);
  10033c:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  10033f:	8d 44 06 02          	lea    0x2(%esi,%eax,1),%eax
  100343:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            break;
  100346:	83 c4 10             	add    $0x10,%esp
            void *p = va_arg(ap, void *);
  100349:	89 5d 0c             	mov    %ebx,0xc(%ebp)
    for (; *fmt; fmt++)
  10034c:	8d 77 01             	lea    0x1(%edi),%esi
  10034f:	8a 47 01             	mov    0x1(%edi),%al
  100352:	84 c0                	test   %al,%al
  100354:	0f 84 af 00 00 00    	je     100409 <vprintf+0x348>
        if (*fmt != '%')
  10035a:	3c 25                	cmp    $0x25,%al
  10035c:	0f 84 81 fd ff ff    	je     1000e3 <vprintf+0x22>
    put_char(c);
  100362:	83 ec 0c             	sub    $0xc,%esp
  100365:	0f be c0             	movsbl %al,%eax
  100368:	50                   	push   %eax
  100369:	e8 11 09 00 00       	call   100c7f <put_char>
            count++;
  10036e:	ff 45 e4             	incl   -0x1c(%ebp)
            continue;
  100371:	83 c4 10             	add    $0x10,%esp
  100374:	89 f7                	mov    %esi,%edi
  100376:	eb d4                	jmp    10034c <vprintf+0x28b>
        }
        case 'c':
        {
            int c = va_arg(ap, int);
  100378:	8b 45 0c             	mov    0xc(%ebp),%eax
  10037b:	8d 58 04             	lea    0x4(%eax),%ebx
    put_char(c);
  10037e:	83 ec 0c             	sub    $0xc,%esp
  100381:	0f be 00             	movsbl (%eax),%eax
  100384:	50                   	push   %eax
  100385:	e8 f5 08 00 00       	call   100c7f <put_char>
            kputc((char)c);
            count++;
  10038a:	ff 45 e4             	incl   -0x1c(%ebp)
            break;
  10038d:	83 c4 10             	add    $0x10,%esp
            int c = va_arg(ap, int);
  100390:	89 5d 0c             	mov    %ebx,0xc(%ebp)
            break;
  100393:	eb b7                	jmp    10034c <vprintf+0x28b>
        }
        case 's':
        {
            const char *s = va_arg(ap, const char *);
  100395:	8b 45 0c             	mov    0xc(%ebp),%eax
  100398:	83 c0 04             	add    $0x4,%eax
  10039b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  10039e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003a1:	8b 30                	mov    (%eax),%esi
    if (!s)
  1003a3:	85 f6                	test   %esi,%esi
  1003a5:	74 32                	je     1003d9 <vprintf+0x318>
    while (*s)
  1003a7:	8a 06                	mov    (%esi),%al
  1003a9:	84 c0                	test   %al,%al
  1003ab:	74 4a                	je     1003f7 <vprintf+0x336>
  1003ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1003b0:	89 d3                	mov    %edx,%ebx
  1003b2:	29 d6                	sub    %edx,%esi
    put_char(c);
  1003b4:	83 ec 0c             	sub    $0xc,%esp
  1003b7:	0f be c0             	movsbl %al,%eax
  1003ba:	50                   	push   %eax
  1003bb:	e8 bf 08 00 00       	call   100c7f <put_char>
            (*count)++;
  1003c0:	43                   	inc    %ebx
    while (*s)
  1003c1:	8a 04 1e             	mov    (%esi,%ebx,1),%al
  1003c4:	83 c4 10             	add    $0x10,%esp
  1003c7:	84 c0                	test   %al,%al
  1003c9:	75 e9                	jne    1003b4 <vprintf+0x2f3>
            const char *s = va_arg(ap, const char *);
  1003cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1003ce:	89 45 0c             	mov    %eax,0xc(%ebp)
  1003d1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  1003d4:	e9 73 ff ff ff       	jmp    10034c <vprintf+0x28b>
        s = "(null)";
  1003d9:	be 22 20 10 00       	mov    $0x102022,%esi
    while (*s)
  1003de:	b0 28                	mov    $0x28,%al
  1003e0:	eb cb                	jmp    1003ad <vprintf+0x2ec>
    put_char(c);
  1003e2:	83 ec 0c             	sub    $0xc,%esp
  1003e5:	6a 25                	push   $0x25
  1003e7:	e8 93 08 00 00       	call   100c7f <put_char>
            kputs(s, &count);
            break;
        }
        case '%':
            kputc('%');
            count++;
  1003ec:	ff 45 e4             	incl   -0x1c(%ebp)
            break;
  1003ef:	83 c4 10             	add    $0x10,%esp
  1003f2:	e9 55 ff ff ff       	jmp    10034c <vprintf+0x28b>
            const char *s = va_arg(ap, const char *);
  1003f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1003fa:	89 45 0c             	mov    %eax,0xc(%ebp)
  1003fd:	e9 4a ff ff ff       	jmp    10034c <vprintf+0x28b>
    int count = 0;
  100402:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            break;
        }
    }

    return count;
}
  100409:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10040c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  10040f:	5b                   	pop    %ebx
  100410:	5e                   	pop    %esi
  100411:	5f                   	pop    %edi
  100412:	5d                   	pop    %ebp
  100413:	c3                   	ret
        fmt++; // skip '%'
  100414:	8d 7e 01             	lea    0x1(%esi),%edi
        switch (*fmt)
  100417:	3c 25                	cmp    $0x25,%al
  100419:	74 c7                	je     1003e2 <vprintf+0x321>
  10041b:	8d 50 a8             	lea    -0x58(%eax),%edx
  10041e:	80 fa 20             	cmp    $0x20,%dl
  100421:	0f 87 02 fd ff ff    	ja     100129 <vprintf+0x68>
  100427:	0f 87 fc fc ff ff    	ja     100129 <vprintf+0x68>
  10042d:	0f b6 c2             	movzbl %dl,%eax
  100430:	ff 24 85 0c 21 10 00 	jmp    *0x10210c(,%eax,4)

00100437 <printf>:

int printf(const char *fmt, ...)
{
  100437:	55                   	push   %ebp
  100438:	89 e5                	mov    %esp,%ebp
  10043a:	83 ec 10             	sub    $0x10,%esp
    va_list ap;
    va_start(ap, fmt);
  10043d:	8d 45 0c             	lea    0xc(%ebp),%eax
    int ret = vprintf(fmt, ap);
  100440:	50                   	push   %eax
  100441:	ff 75 08             	push   0x8(%ebp)
  100444:	e8 78 fc ff ff       	call   1000c1 <vprintf>
    va_end(ap);
    return ret;
}
  100449:	c9                   	leave
  10044a:	c3                   	ret

0010044b <scanf_char>:

char scanf_char()
{
    return 'c'; // keyboard_trap();
}
  10044b:	b0 63                	mov    $0x63,%al
  10044d:	c3                   	ret

0010044e <main>:

// 在这里真正定义全局定时器实例
//struct timer t;

int main()
{
  10044e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  100452:	83 e4 f0             	and    $0xfffffff0,%esp
  100455:	ff 71 fc             	push   -0x4(%ecx)
  100458:	55                   	push   %ebp
  100459:	89 e5                	mov    %esp,%ebp
  10045b:	51                   	push   %ecx
  10045c:	83 ec 04             	sub    $0x4,%esp
   gdt_install();
  10045f:	e8 71 03 00 00       	call   1007d5 <gdt_install>
   trap_init();
  100464:	e8 ea 0b 00 00       	call   101053 <trap_init>
   page_init();
  100469:	e8 cc 04 00 00       	call   10093a <page_init>

   printf("Welcome to uCore!\n");
  10046e:	83 ec 0c             	sub    $0xc,%esp
  100471:	68 2d 20 10 00       	push   $0x10202d
  100476:	e8 bc ff ff ff       	call   100437 <printf>

   printf("Starting user app...\n");
  10047b:	c7 04 24 40 20 10 00 	movl   $0x102040,(%esp)
  100482:	e8 b0 ff ff ff       	call   100437 <printf>
   user_app_run();
  100487:	e8 80 0c 00 00       	call   10110c <user_app_run>
   printf("User app finished\n");
  10048c:	c7 04 24 56 20 10 00 	movl   $0x102056,(%esp)
  100493:	e8 9f ff ff ff       	call   100437 <printf>

   shutdown();
  100498:	e8 34 08 00 00       	call   100cd1 <shutdown>

   return 0;
}
  10049d:	b8 00 00 00 00       	mov    $0x0,%eax
  1004a2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  1004a5:	c9                   	leave
  1004a6:	8d 61 fc             	lea    -0x4(%ecx),%esp
  1004a9:	c3                   	ret

001004aa <memset>:
#include "string.h"
#include "types.h"

void *memset(void *dst, int c, uint n)
{
  1004aa:	55                   	push   %ebp
  1004ab:	89 e5                	mov    %esp,%ebp
  1004ad:	53                   	push   %ebx
  1004ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1004b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1004b4:	8b 55 10             	mov    0x10(%ebp),%edx
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
  1004b7:	85 d2                	test   %edx,%edx
  1004b9:	74 0b                	je     1004c6 <memset+0x1c>
  1004bb:	89 d8                	mov    %ebx,%eax
  1004bd:	01 da                	add    %ebx,%edx
    {
        cdst[i] = c;
  1004bf:	88 08                	mov    %cl,(%eax)
    for (i = 0; i < n; i++)
  1004c1:	40                   	inc    %eax
  1004c2:	39 d0                	cmp    %edx,%eax
  1004c4:	75 f9                	jne    1004bf <memset+0x15>
    }
    return dst;
}
  1004c6:	89 d8                	mov    %ebx,%eax
  1004c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1004cb:	c9                   	leave
  1004cc:	c3                   	ret

001004cd <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
  1004cd:	55                   	push   %ebp
  1004ce:	89 e5                	mov    %esp,%ebp
  1004d0:	56                   	push   %esi
  1004d1:	53                   	push   %ebx
  1004d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1004d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1004d8:	8b 75 10             	mov    0x10(%ebp),%esi
    const uchar *s1, *s2;

    s1 = v1;
    s2 = v2;
    while (n-- > 0)
  1004db:	85 f6                	test   %esi,%esi
  1004dd:	74 23                	je     100502 <memcmp+0x35>
  1004df:	01 c6                	add    %eax,%esi
    {
        if (*s1 != *s2)
  1004e1:	8a 08                	mov    (%eax),%cl
  1004e3:	8a 1a                	mov    (%edx),%bl
  1004e5:	38 d9                	cmp    %bl,%cl
  1004e7:	75 0d                	jne    1004f6 <memcmp+0x29>
            return *s1 - *s2;
        s1++, s2++;
  1004e9:	40                   	inc    %eax
  1004ea:	42                   	inc    %edx
    while (n-- > 0)
  1004eb:	39 c6                	cmp    %eax,%esi
  1004ed:	75 f2                	jne    1004e1 <memcmp+0x14>
    }

    return 0;
  1004ef:	b8 00 00 00 00       	mov    $0x0,%eax
  1004f4:	eb 08                	jmp    1004fe <memcmp+0x31>
            return *s1 - *s2;
  1004f6:	0f b6 c1             	movzbl %cl,%eax
  1004f9:	0f b6 db             	movzbl %bl,%ebx
  1004fc:	29 d8                	sub    %ebx,%eax
}
  1004fe:	5b                   	pop    %ebx
  1004ff:	5e                   	pop    %esi
  100500:	5d                   	pop    %ebp
  100501:	c3                   	ret
    return 0;
  100502:	b8 00 00 00 00       	mov    $0x0,%eax
  100507:	eb f5                	jmp    1004fe <memcmp+0x31>

00100509 <memmove>:

void *memmove(void *dst, const void *src, uint n)
{
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	56                   	push   %esi
  10050d:	53                   	push   %ebx
  10050e:	8b 75 08             	mov    0x8(%ebp),%esi
  100511:	8b 45 0c             	mov    0xc(%ebp),%eax
  100514:	8b 4d 10             	mov    0x10(%ebp),%ecx
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d)
  100517:	39 f0                	cmp    %esi,%eax
  100519:	72 1a                	jb     100535 <memmove+0x2c>
        d += n;
        while (n-- > 0)
            *--d = *--s;
    }
    else
        while (n-- > 0)
  10051b:	85 c9                	test   %ecx,%ecx
  10051d:	74 10                	je     10052f <memmove+0x26>
  10051f:	01 c1                	add    %eax,%ecx
  100521:	89 f2                	mov    %esi,%edx
            *d++ = *s++;
  100523:	40                   	inc    %eax
  100524:	42                   	inc    %edx
  100525:	8a 58 ff             	mov    -0x1(%eax),%bl
  100528:	88 5a ff             	mov    %bl,-0x1(%edx)
        while (n-- > 0)
  10052b:	39 c8                	cmp    %ecx,%eax
  10052d:	75 f4                	jne    100523 <memmove+0x1a>

    return dst;
}
  10052f:	89 f0                	mov    %esi,%eax
  100531:	5b                   	pop    %ebx
  100532:	5e                   	pop    %esi
  100533:	5d                   	pop    %ebp
  100534:	c3                   	ret
    if (s < d && s + n > d)
  100535:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  100538:	39 d6                	cmp    %edx,%esi
  10053a:	73 df                	jae    10051b <memmove+0x12>
        while (n-- > 0)
  10053c:	8d 51 ff             	lea    -0x1(%ecx),%edx
  10053f:	85 c9                	test   %ecx,%ecx
  100541:	74 ec                	je     10052f <memmove+0x26>
            *--d = *--s;
  100543:	8a 0c 10             	mov    (%eax,%edx,1),%cl
  100546:	88 0c 16             	mov    %cl,(%esi,%edx,1)
        while (n-- > 0)
  100549:	4a                   	dec    %edx
  10054a:	83 fa ff             	cmp    $0xffffffff,%edx
  10054d:	75 f4                	jne    100543 <memmove+0x3a>
  10054f:	eb de                	jmp    10052f <memmove+0x26>

00100551 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n)
{
  100551:	55                   	push   %ebp
  100552:	89 e5                	mov    %esp,%ebp
  100554:	83 ec 0c             	sub    $0xc,%esp
    return memmove(dst, src, n);
  100557:	ff 75 10             	push   0x10(%ebp)
  10055a:	ff 75 0c             	push   0xc(%ebp)
  10055d:	ff 75 08             	push   0x8(%ebp)
  100560:	e8 a4 ff ff ff       	call   100509 <memmove>
}
  100565:	c9                   	leave
  100566:	c3                   	ret

00100567 <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
  100567:	55                   	push   %ebp
  100568:	89 e5                	mov    %esp,%ebp
  10056a:	53                   	push   %ebx
  10056b:	8b 45 08             	mov    0x8(%ebp),%eax
  10056e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100571:	8b 55 10             	mov    0x10(%ebp),%edx
    while (n > 0 && *p && *p == *q)
  100574:	85 d2                	test   %edx,%edx
  100576:	74 16                	je     10058e <strncmp+0x27>
  100578:	8a 18                	mov    (%eax),%bl
  10057a:	84 db                	test   %bl,%bl
  10057c:	74 17                	je     100595 <strncmp+0x2e>
  10057e:	3a 19                	cmp    (%ecx),%bl
  100580:	75 13                	jne    100595 <strncmp+0x2e>
        n--, p++, q++;
  100582:	40                   	inc    %eax
  100583:	41                   	inc    %ecx
    while (n > 0 && *p && *p == *q)
  100584:	4a                   	dec    %edx
  100585:	75 f1                	jne    100578 <strncmp+0x11>
    if (n == 0)
        return 0;
  100587:	b8 00 00 00 00       	mov    $0x0,%eax
  10058c:	eb 0f                	jmp    10059d <strncmp+0x36>
  10058e:	b8 00 00 00 00       	mov    $0x0,%eax
  100593:	eb 08                	jmp    10059d <strncmp+0x36>
    return (uchar)*p - (uchar)*q;
  100595:	0f b6 00             	movzbl (%eax),%eax
  100598:	0f b6 11             	movzbl (%ecx),%edx
  10059b:	29 d0                	sub    %edx,%eax
}
  10059d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1005a0:	c9                   	leave
  1005a1:	c3                   	ret

001005a2 <strncpy>:

char *strncpy(char *s, const char *t, int n)
{
  1005a2:	55                   	push   %ebp
  1005a3:	89 e5                	mov    %esp,%ebp
  1005a5:	56                   	push   %esi
  1005a6:	53                   	push   %ebx
  1005a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  1005aa:	8b 55 10             	mov    0x10(%ebp),%edx
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0)
  1005ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1005b0:	89 d6                	mov    %edx,%esi
  1005b2:	4a                   	dec    %edx
  1005b3:	85 f6                	test   %esi,%esi
  1005b5:	7e 23                	jle    1005da <strncpy+0x38>
  1005b7:	43                   	inc    %ebx
  1005b8:	41                   	inc    %ecx
  1005b9:	8a 43 ff             	mov    -0x1(%ebx),%al
  1005bc:	88 41 ff             	mov    %al,-0x1(%ecx)
  1005bf:	84 c0                	test   %al,%al
  1005c1:	75 ed                	jne    1005b0 <strncpy+0xe>
        ;
    while (n-- > 0)
  1005c3:	85 d2                	test   %edx,%edx
  1005c5:	7e 13                	jle    1005da <strncpy+0x38>
  1005c7:	89 ca                	mov    %ecx,%edx
  1005c9:	8d 5c 31 ff          	lea    -0x1(%ecx,%esi,1),%ebx
        *s++ = 0;
  1005cd:	42                   	inc    %edx
  1005ce:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
    while (n-- > 0)
  1005d2:	89 d9                	mov    %ebx,%ecx
  1005d4:	29 d1                	sub    %edx,%ecx
  1005d6:	85 c9                	test   %ecx,%ecx
  1005d8:	7f f3                	jg     1005cd <strncpy+0x2b>
    return os;
}
  1005da:	8b 45 08             	mov    0x8(%ebp),%eax
  1005dd:	5b                   	pop    %ebx
  1005de:	5e                   	pop    %esi
  1005df:	5d                   	pop    %ebp
  1005e0:	c3                   	ret

001005e1 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n)
{
  1005e1:	55                   	push   %ebp
  1005e2:	89 e5                	mov    %esp,%ebp
  1005e4:	56                   	push   %esi
  1005e5:	53                   	push   %ebx
  1005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1005ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
    char *os;

    os = s;
    if (n <= 0)
  1005ef:	85 c9                	test   %ecx,%ecx
  1005f1:	7e 19                	jle    10060c <safestrcpy+0x2b>
  1005f3:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
  1005f7:	89 c1                	mov    %eax,%ecx
        return os;
    while (--n > 0 && (*s++ = *t++) != 0)
  1005f9:	39 f2                	cmp    %esi,%edx
  1005fb:	74 0c                	je     100609 <safestrcpy+0x28>
  1005fd:	42                   	inc    %edx
  1005fe:	41                   	inc    %ecx
  1005ff:	8a 5a ff             	mov    -0x1(%edx),%bl
  100602:	88 59 ff             	mov    %bl,-0x1(%ecx)
  100605:	84 db                	test   %bl,%bl
  100607:	75 f0                	jne    1005f9 <safestrcpy+0x18>
        ;
    *s = 0;
  100609:	c6 01 00             	movb   $0x0,(%ecx)
    return os;
}
  10060c:	5b                   	pop    %ebx
  10060d:	5e                   	pop    %esi
  10060e:	5d                   	pop    %ebp
  10060f:	c3                   	ret

00100610 <strlen>:

int strlen(const char *s)
{
  100610:	55                   	push   %ebp
  100611:	89 e5                	mov    %esp,%ebp
  100613:	8b 55 08             	mov    0x8(%ebp),%edx
    int n;

    for (n = 0; s[n]; n++)
  100616:	80 3a 00             	cmpb   $0x0,(%edx)
  100619:	74 0e                	je     100629 <strlen+0x19>
  10061b:	b8 00 00 00 00       	mov    $0x0,%eax
  100620:	40                   	inc    %eax
  100621:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  100625:	75 f9                	jne    100620 <strlen+0x10>
        ;
    return n;
}
  100627:	5d                   	pop    %ebp
  100628:	c3                   	ret
    for (n = 0; s[n]; n++)
  100629:	b8 00 00 00 00       	mov    $0x0,%eax
    return n;
  10062e:	eb f7                	jmp    100627 <strlen+0x17>

00100630 <dummy>:

void dummy(int _, ...)
{
  100630:	c3                   	ret
  100631:	66 90                	xchg   %ax,%ax
  100633:	90                   	nop

00100634 <trap_entry>:
     * EIP
     * Vector (Pushed by macro)
     */

    /* ---------- 保存段寄存器 ---------- */
    pushl %ds
  100634:	1e                   	push   %ds
    pushl %es
  100635:	06                   	push   %es
    pushl %fs
  100636:	0f a0                	push   %fs
    pushl %gs
  100638:	0f a8                	push   %gs

    /* ---------- 保存通用寄存器 ---------- */
    pusha
  10063a:	60                   	pusha

    /* ---------- 切换到内核数据段 ---------- */
    mov $0x10, %ax              /* 内核数据段选择子 */
  10063b:	66 b8 10 00          	mov    $0x10,%ax
    mov %ax, %ds
  10063f:	8e d8                	mov    %eax,%ds
    mov %ax, %es
  100641:	8e c0                	mov    %eax,%es
    mov %ax, %fs
  100643:	8e e0                	mov    %eax,%fs
    mov %ax, %gs
  100645:	8e e8                	mov    %eax,%gs

    /* ---------- 调用 C 处理函数 ---------- */
    pushl %esp                  /* struct trapframe* */
  100647:	54                   	push   %esp
    call trap_handler
  100648:	e8 14 0a 00 00       	call   101061 <trap_handler>
    addl $4, %esp
  10064d:	83 c4 04             	add    $0x4,%esp

    /* ---------- 恢复寄存器（严格反序） ---------- */
    popa
  100650:	61                   	popa
    popl %gs
  100651:	0f a9                	pop    %gs
    popl %fs
  100653:	0f a1                	pop    %fs
    popl %es
  100655:	07                   	pop    %es
    popl %ds
  100656:	1f                   	pop    %ds
    
    /* 弹出 vector 号 (4字节) */
    addl $4, %esp 
  100657:	83 c4 04             	add    $0x4,%esp

     /* 弹出 err 号 (4字节) */
    addl $4, %esp
  10065a:	83 c4 04             	add    $0x4,%esp

    /* ---------- 返回 ---------- */
    iret
  10065d:	cf                   	iret

0010065e <trap_entry_0>:
    #ret
    .endm

    # 生成 syscall 向量 0x80 的 stub
    .if 1
    TRAP_STUB 0
  10065e:	6a 00                	push   $0x0
  100660:	6a 00                	push   $0x0
  100662:	eb d0                	jmp    100634 <trap_entry>

00100664 <trap_entry_1>:
    TRAP_STUB 1
  100664:	6a 00                	push   $0x0
  100666:	6a 01                	push   $0x1
  100668:	eb ca                	jmp    100634 <trap_entry>

0010066a <trap_entry_2>:
    TRAP_STUB 2
  10066a:	6a 00                	push   $0x0
  10066c:	6a 02                	push   $0x2
  10066e:	eb c4                	jmp    100634 <trap_entry>

00100670 <trap_entry_3>:
    TRAP_STUB 3
  100670:	6a 00                	push   $0x0
  100672:	6a 03                	push   $0x3
  100674:	eb be                	jmp    100634 <trap_entry>

00100676 <trap_entry_4>:
    TRAP_STUB 4
  100676:	6a 00                	push   $0x0
  100678:	6a 04                	push   $0x4
  10067a:	eb b8                	jmp    100634 <trap_entry>

0010067c <trap_entry_5>:
    TRAP_STUB 5
  10067c:	6a 00                	push   $0x0
  10067e:	6a 05                	push   $0x5
  100680:	eb b2                	jmp    100634 <trap_entry>

00100682 <trap_entry_6>:
    TRAP_STUB 6
  100682:	6a 00                	push   $0x0
  100684:	6a 06                	push   $0x6
  100686:	eb ac                	jmp    100634 <trap_entry>

00100688 <trap_entry_7>:
    TRAP_STUB 7
  100688:	6a 00                	push   $0x0
  10068a:	6a 07                	push   $0x7
  10068c:	eb a6                	jmp    100634 <trap_entry>

0010068e <trap_entry_8>:
    TRAP_STUB 8
  10068e:	6a 00                	push   $0x0
  100690:	6a 08                	push   $0x8
  100692:	eb a0                	jmp    100634 <trap_entry>

00100694 <trap_entry_9>:
    TRAP_STUB 9
  100694:	6a 00                	push   $0x0
  100696:	6a 09                	push   $0x9
  100698:	eb 9a                	jmp    100634 <trap_entry>

0010069a <trap_entry_10>:
    TRAP_STUB 10
  10069a:	6a 00                	push   $0x0
  10069c:	6a 0a                	push   $0xa
  10069e:	eb 94                	jmp    100634 <trap_entry>

001006a0 <trap_entry_11>:
    TRAP_STUB 11
  1006a0:	6a 00                	push   $0x0
  1006a2:	6a 0b                	push   $0xb
  1006a4:	eb 8e                	jmp    100634 <trap_entry>

001006a6 <trap_entry_12>:
    TRAP_STUB 12
  1006a6:	6a 00                	push   $0x0
  1006a8:	6a 0c                	push   $0xc
  1006aa:	eb 88                	jmp    100634 <trap_entry>

001006ac <trap_entry_13>:
    TRAP_STUB 13
  1006ac:	6a 00                	push   $0x0
  1006ae:	6a 0d                	push   $0xd
  1006b0:	eb 82                	jmp    100634 <trap_entry>

001006b2 <trap_entry_14>:
    TRAP_STUB_err 14
  1006b2:	6a 0e                	push   $0xe
  1006b4:	e9 7b ff ff ff       	jmp    100634 <trap_entry>

001006b9 <trap_entry_15>:
    TRAP_STUB 15
  1006b9:	6a 00                	push   $0x0
  1006bb:	6a 0f                	push   $0xf
  1006bd:	e9 72 ff ff ff       	jmp    100634 <trap_entry>

001006c2 <trap_entry_16>:
    TRAP_STUB 16
  1006c2:	6a 00                	push   $0x0
  1006c4:	6a 10                	push   $0x10
  1006c6:	e9 69 ff ff ff       	jmp    100634 <trap_entry>

001006cb <trap_entry_17>:
    TRAP_STUB 17
  1006cb:	6a 00                	push   $0x0
  1006cd:	6a 11                	push   $0x11
  1006cf:	e9 60 ff ff ff       	jmp    100634 <trap_entry>

001006d4 <trap_entry_18>:
    TRAP_STUB 18
  1006d4:	6a 00                	push   $0x0
  1006d6:	6a 12                	push   $0x12
  1006d8:	e9 57 ff ff ff       	jmp    100634 <trap_entry>

001006dd <trap_entry_19>:
    TRAP_STUB 19
  1006dd:	6a 00                	push   $0x0
  1006df:	6a 13                	push   $0x13
  1006e1:	e9 4e ff ff ff       	jmp    100634 <trap_entry>

001006e6 <trap_entry_20>:
    TRAP_STUB 20
  1006e6:	6a 00                	push   $0x0
  1006e8:	6a 14                	push   $0x14
  1006ea:	e9 45 ff ff ff       	jmp    100634 <trap_entry>

001006ef <trap_entry_21>:
    TRAP_STUB 21
  1006ef:	6a 00                	push   $0x0
  1006f1:	6a 15                	push   $0x15
  1006f3:	e9 3c ff ff ff       	jmp    100634 <trap_entry>

001006f8 <trap_entry_22>:
    TRAP_STUB 22
  1006f8:	6a 00                	push   $0x0
  1006fa:	6a 16                	push   $0x16
  1006fc:	e9 33 ff ff ff       	jmp    100634 <trap_entry>

00100701 <trap_entry_23>:
    TRAP_STUB 23
  100701:	6a 00                	push   $0x0
  100703:	6a 17                	push   $0x17
  100705:	e9 2a ff ff ff       	jmp    100634 <trap_entry>

0010070a <trap_entry_24>:
    TRAP_STUB 24
  10070a:	6a 00                	push   $0x0
  10070c:	6a 18                	push   $0x18
  10070e:	e9 21 ff ff ff       	jmp    100634 <trap_entry>

00100713 <trap_entry_25>:
    TRAP_STUB 25
  100713:	6a 00                	push   $0x0
  100715:	6a 19                	push   $0x19
  100717:	e9 18 ff ff ff       	jmp    100634 <trap_entry>

0010071c <trap_entry_26>:
    TRAP_STUB 26
  10071c:	6a 00                	push   $0x0
  10071e:	6a 1a                	push   $0x1a
  100720:	e9 0f ff ff ff       	jmp    100634 <trap_entry>

00100725 <trap_entry_27>:
    TRAP_STUB 27
  100725:	6a 00                	push   $0x0
  100727:	6a 1b                	push   $0x1b
  100729:	e9 06 ff ff ff       	jmp    100634 <trap_entry>

0010072e <trap_entry_28>:
    TRAP_STUB 28
  10072e:	6a 00                	push   $0x0
  100730:	6a 1c                	push   $0x1c
  100732:	e9 fd fe ff ff       	jmp    100634 <trap_entry>

00100737 <trap_entry_29>:
    TRAP_STUB 29
  100737:	6a 00                	push   $0x0
  100739:	6a 1d                	push   $0x1d
  10073b:	e9 f4 fe ff ff       	jmp    100634 <trap_entry>

00100740 <trap_entry_30>:
    TRAP_STUB 30
  100740:	6a 00                	push   $0x0
  100742:	6a 1e                	push   $0x1e
  100744:	e9 eb fe ff ff       	jmp    100634 <trap_entry>

00100749 <trap_entry_31>:
    TRAP_STUB 31
  100749:	6a 00                	push   $0x0
  10074b:	6a 1f                	push   $0x1f
  10074d:	e9 e2 fe ff ff       	jmp    100634 <trap_entry>

00100752 <trap_entry_0x80>:
    TRAP_STUB 0x80
  100752:	6a 00                	push   $0x0
  100754:	68 80 00 00 00       	push   $0x80
  100759:	e9 d6 fe ff ff       	jmp    100634 <trap_entry>

0010075e <user_enter>:

# 参数：eax = 用户态栈顶地址 (user_esp)
#        ebx = 用户代码入口 (entry)

user_enter:
    cli
  10075e:	fa                   	cli
    # C调用约定：
    #   第一个参数 [esp+4]  -> entry (用户程序入口)
    #   第二个参数 [esp+8]  -> user_esp (用户栈顶)
    mov eax, [esp + 8]    # user_esp
  10075f:	8b 44 24 08          	mov    0x8(%esp),%eax
    mov ebx, [esp + 4]    # entry
  100763:	8b 5c 24 04          	mov    0x4(%esp),%ebx

    push 0x23             # SS (用户数据段选择子，ring3)
  100767:	6a 23                	push   $0x23
    push eax              # ESP (用户栈顶)
  100769:	50                   	push   %eax
    pushfd
  10076a:	9c                   	pushf
    or dword ptr [esp], 0x200
  10076b:	81 0c 24 00 02 00 00 	orl    $0x200,(%esp)
    push 0x1B             # CS (用户代码段选择子，ring3)
  100772:	6a 1b                	push   $0x1b
    push ebx              # EIP (用户入口)
  100774:	53                   	push   %ebx
    iret
  100775:	cf                   	iret

00100776 <idt_flush>:

    
.intel_syntax noprefix
.globl idt_flush
idt_flush:
	mov eax, [esp+4]  #参数存入 eax 寄存器
  100776:	8b 44 24 04          	mov    0x4(%esp),%eax
	lidt [eax]        #加载到 IDTR
  10077a:	0f 01 18             	lidtl  (%eax)
	ret
  10077d:	c3                   	ret

0010077e <set_gdt_entry>:

struct gdt_entry gdt[GDT_SIZE];
struct gdt_ptr gp;

void set_gdt_entry(int num, uint32_t base, uint32_t limit, uint8_t access, uint8_t flags)
{
  10077e:	55                   	push   %ebp
  10077f:	89 e5                	mov    %esp,%ebp
  100781:	53                   	push   %ebx
  100782:	8b 55 08             	mov    0x8(%ebp),%edx
  100785:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100788:	8b 45 10             	mov    0x10(%ebp),%eax
    gdt[num].base_low = base & 0xFFFF;
  10078b:	66 89 0c d5 22 40 11 	mov    %cx,0x114022(,%edx,8)
  100792:	00 
    gdt[num].base_middle = (base >> 16) & 0xFF;
  100793:	89 cb                	mov    %ecx,%ebx
  100795:	c1 eb 10             	shr    $0x10,%ebx
  100798:	88 1c d5 24 40 11 00 	mov    %bl,0x114024(,%edx,8)
    gdt[num].base_high = (base >> 24) & 0xFF;
  10079f:	c1 e9 18             	shr    $0x18,%ecx
  1007a2:	88 0c d5 27 40 11 00 	mov    %cl,0x114027(,%edx,8)

    gdt[num].limit_low = limit & 0xFFFF;
  1007a9:	66 89 04 d5 20 40 11 	mov    %ax,0x114020(,%edx,8)
  1007b0:	00 
    gdt[num].granularity = ((limit >> 16) & 0x0F) | (flags & 0xF0);
  1007b1:	c1 e8 10             	shr    $0x10,%eax
  1007b4:	83 e0 0f             	and    $0xf,%eax
  1007b7:	8a 4d 18             	mov    0x18(%ebp),%cl
  1007ba:	83 e1 f0             	and    $0xfffffff0,%ecx
  1007bd:	09 c8                	or     %ecx,%eax
  1007bf:	88 04 d5 26 40 11 00 	mov    %al,0x114026(,%edx,8)

    gdt[num].access = access;
  1007c6:	8b 45 14             	mov    0x14(%ebp),%eax
  1007c9:	88 04 d5 25 40 11 00 	mov    %al,0x114025(,%edx,8)
}
  1007d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1007d3:	c9                   	leave
  1007d4:	c3                   	ret

001007d5 <gdt_install>:

void gdt_install()
{
  1007d5:	55                   	push   %ebp
  1007d6:	89 e5                	mov    %esp,%ebp
  1007d8:	83 ec 14             	sub    $0x14,%esp
    gp.limit = sizeof(gdt) - 1;
  1007db:	66 c7 05 00 40 11 00 	movw   $0x2f,0x114000
  1007e2:	2f 00 
    gp.base = (uint32_t)&gdt;
  1007e4:	c7 05 02 40 11 00 20 	movl   $0x114020,0x114002
  1007eb:	40 11 00 

    // Null descriptor
    set_gdt_entry(0, 0, 0, 0, 0);
  1007ee:	6a 00                	push   $0x0
  1007f0:	6a 00                	push   $0x0
  1007f2:	6a 00                	push   $0x0
  1007f4:	6a 00                	push   $0x0
  1007f6:	6a 00                	push   $0x0
  1007f8:	e8 81 ff ff ff       	call   10077e <set_gdt_entry>

    // 内核代码段 (CPL=0)
    set_gdt_entry(1, 0x0, 0xFFFFF,
  1007fd:	83 c4 14             	add    $0x14,%esp
  100800:	68 c0 00 00 00       	push   $0xc0
  100805:	68 9a 00 00 00       	push   $0x9a
  10080a:	68 ff ff 0f 00       	push   $0xfffff
  10080f:	6a 00                	push   $0x0
  100811:	6a 01                	push   $0x1
  100813:	e8 66 ff ff ff       	call   10077e <set_gdt_entry>
                  SEG_PRESENT | SEG_CODE | SEG_RING0,
                  GDT_GRAN_4K | GDT_32BIT);

    // 内核数据段 (CPL=0)
    set_gdt_entry(2, 0x0, 0xFFFFF,
  100818:	83 c4 14             	add    $0x14,%esp
  10081b:	68 c0 00 00 00       	push   $0xc0
  100820:	68 92 00 00 00       	push   $0x92
  100825:	68 ff ff 0f 00       	push   $0xfffff
  10082a:	6a 00                	push   $0x0
  10082c:	6a 02                	push   $0x2
  10082e:	e8 4b ff ff ff       	call   10077e <set_gdt_entry>
                  SEG_PRESENT | SEG_DATA | SEG_RING0,
                  GDT_GRAN_4K | GDT_32BIT);

    // 用户代码段 (CPL=3)
    set_gdt_entry(3, 0x0, 0xFFFFFFFF,
  100833:	83 c4 14             	add    $0x14,%esp
  100836:	68 c0 00 00 00       	push   $0xc0
  10083b:	68 fa 00 00 00       	push   $0xfa
  100840:	6a ff                	push   $0xffffffff
  100842:	6a 00                	push   $0x0
  100844:	6a 03                	push   $0x3
  100846:	e8 33 ff ff ff       	call   10077e <set_gdt_entry>
                  SEG_PRESENT | SEG_CODE | SEG_RING3,
                  GDT_GRAN_4K | GDT_32BIT);

    // 用户数据段 (CPL=3)
    set_gdt_entry(4, 0x0, 0xFFFFFFFF,
  10084b:	83 c4 14             	add    $0x14,%esp
  10084e:	68 c0 00 00 00       	push   $0xc0
  100853:	68 f2 00 00 00       	push   $0xf2
  100858:	6a ff                	push   $0xffffffff
  10085a:	6a 00                	push   $0x0
  10085c:	6a 04                	push   $0x4
  10085e:	e8 1b ff ff ff       	call   10077e <set_gdt_entry>
                  SEG_PRESENT | SEG_DATA | SEG_RING3,
                  GDT_GRAN_4K | GDT_32BIT);

    // TSS段 (GDT[5])
    memset(&tss, 0, sizeof(tss));
  100863:	83 c4 1c             	add    $0x1c,%esp
  100866:	6a 68                	push   $0x68
  100868:	6a 00                	push   $0x0
  10086a:	68 60 40 11 00       	push   $0x114060
  10086f:	e8 36 fc ff ff       	call   1004aa <memset>
    tss.ss0 = 0x10; // 内核数据段选择子
  100874:	c7 05 68 40 11 00 10 	movl   $0x10,0x114068
  10087b:	00 00 00 
    tss.esp0 = 0;   // 需要在任务切换时设置
  10087e:	c7 05 64 40 11 00 00 	movl   $0x0,0x114064
  100885:	00 00 00 
    uint32_t base = (uint32_t)&tss;
    uint32_t limit = sizeof(tss) - 1;
    set_gdt_entry(5, base, limit, 0x89, 0x00); // 0x89: present, type=32位TSS
  100888:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10088f:	68 89 00 00 00       	push   $0x89
  100894:	6a 67                	push   $0x67
  100896:	68 60 40 11 00       	push   $0x114060
  10089b:	6a 05                	push   $0x5
  10089d:	e8 dc fe ff ff       	call   10077e <set_gdt_entry>

    // 加载 GDTR
    asm volatile("lgdt (%0)" : : "r"(&gp));
  1008a2:	b8 00 40 11 00       	mov    $0x114000,%eax
  1008a7:	0f 01 10             	lgdtl  (%eax)

    // 更新段寄存器，内核态 CS/DS/ES/FS/GS/SS
    asm volatile(
  1008aa:	66 b8 10 00          	mov    $0x10,%ax
  1008ae:	8e d8                	mov    %eax,%ds
  1008b0:	8e c0                	mov    %eax,%es
  1008b2:	8e e0                	mov    %eax,%fs
  1008b4:	8e e8                	mov    %eax,%gs
        :
        :
        : "ax");

    // 加载TSS
    asm volatile("ltr %%ax" : : "a"(5 << 3));
  1008b6:	b8 28 00 00 00       	mov    $0x28,%eax
  1008bb:	0f 00 d8             	ltr    %eax
}
  1008be:	83 c4 20             	add    $0x20,%esp
  1008c1:	c9                   	leave
  1008c2:	c3                   	ret

001008c3 <tss_set>:

// 设置TSS的esp0（内核栈顶），可在任务切换时调用
void tss_set(uint32_t kernel_stack)
{
  1008c3:	55                   	push   %ebp
  1008c4:	89 e5                	mov    %esp,%ebp
    tss.esp0 = kernel_stack;
  1008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1008c9:	a3 64 40 11 00       	mov    %eax,0x114064
}
  1008ce:	5d                   	pop    %ebp
  1008cf:	c3                   	ret

001008d0 <set_idt_gate>:
struct idt_entry idt[IDT_SIZE];
struct idt_ptr idtp;
extern void idt_flush(uint32_t);

void set_idt_gate(int vec, void (*handler)(), uint16_t selector, uint8_t flags)
{
  1008d0:	55                   	push   %ebp
  1008d1:	89 e5                	mov    %esp,%ebp
  1008d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1008d6:	8b 55 0c             	mov    0xc(%ebp),%edx
    uint32_t addr = (uint32_t)handler;

    idt[vec].offset_low = addr & 0xFFFF;
  1008d9:	66 89 14 c5 00 41 11 	mov    %dx,0x114100(,%eax,8)
  1008e0:	00 
    idt[vec].selector = selector;
  1008e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1008e4:	66 89 0c c5 02 41 11 	mov    %cx,0x114102(,%eax,8)
  1008eb:	00 
    idt[vec].zero = 0;
  1008ec:	c6 04 c5 04 41 11 00 	movb   $0x0,0x114104(,%eax,8)
  1008f3:	00 
    idt[vec].type_attr = flags;
  1008f4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  1008f7:	88 0c c5 05 41 11 00 	mov    %cl,0x114105(,%eax,8)
    idt[vec].offset_high = (addr >> 16) & 0xFFFF;
  1008fe:	c1 ea 10             	shr    $0x10,%edx
  100901:	66 89 14 c5 06 41 11 	mov    %dx,0x114106(,%eax,8)
  100908:	00 
}
  100909:	5d                   	pop    %ebp
  10090a:	c3                   	ret

0010090b <idt_load>:

void idt_load(void)
{
  10090b:	55                   	push   %ebp
  10090c:	89 e5                	mov    %esp,%ebp
  10090e:	83 ec 14             	sub    $0x14,%esp
    idtp.limit = sizeof(idt) - 1;
  100911:	66 c7 05 e0 40 11 00 	movw   $0x7ff,0x1140e0
  100918:	ff 07 
    idtp.base = (uint32_t)&idt;
  10091a:	c7 05 e2 40 11 00 00 	movl   $0x114100,0x1140e2
  100921:	41 11 00 

    asm volatile("lidt %0" : : "m"(idtp));
  100924:	0f 01 1d e0 40 11 00 	lidtl  0x1140e0

    idt_flush((uint32_t)&idtp);
  10092b:	68 e0 40 11 00       	push   $0x1140e0
  100930:	e8 41 fe ff ff       	call   100776 <idt_flush>
}
  100935:	83 c4 10             	add    $0x10,%esp
  100938:	c9                   	leave
  100939:	c3                   	ret

0010093a <page_init>:

__attribute__((aligned(4096))) struct PagedDirectoryEntry page_directory[1024];
__attribute__((aligned(4096))) struct PageTableEntry page_table[512][1024]; // 512个页表，每个1024项
uint8_t phys_bitmap[512]; // 每位表示一个物理页

void page_init() {
  10093a:	55                   	push   %ebp
  10093b:	89 e5                	mov    %esp,%ebp
  10093d:	56                   	push   %esi
  10093e:	53                   	push   %ebx
    // 初始化页目录和页表
    for (int i = 0; i < 1024; i++) {
  10093f:	b8 00 00 00 00       	mov    $0x0,%eax
        page_directory[i].present = 0;
        page_directory[i].rw = 1;
  100944:	8a 14 85 00 60 31 00 	mov    0x316000(,%eax,4),%dl
  10094b:	83 e2 fa             	and    $0xfffffffa,%edx
        page_directory[i].user = 0;
  10094e:	83 ca 02             	or     $0x2,%edx
  100951:	88 14 85 00 60 31 00 	mov    %dl,0x316000(,%eax,4)
        page_directory[i].reserved = 0;
  100958:	66 81 24 85 00 60 31 	andw   $0xf007,0x316000(,%eax,4)
  10095f:	00 07 f0 
        page_directory[i].table_addr = 0;
  100962:	81 24 85 00 60 31 00 	andl   $0xfff,0x316000(,%eax,4)
  100969:	ff 0f 00 00 
    for (int i = 0; i < 1024; i++) {
  10096d:	40                   	inc    %eax
  10096e:	3d 00 04 00 00       	cmp    $0x400,%eax
  100973:	75 cf                	jne    100944 <page_init+0xa>
    }

    for (int i = 0; i < 4; i++) {
  100975:	be 00 00 00 00       	mov    $0x0,%esi
        for (int j = 0; j < 1024; j++) {
  10097a:	b9 00 00 00 00       	mov    $0x0,%ecx
            page_table[i][j].present = 0;
  10097f:	89 f3                	mov    %esi,%ebx
  100981:	c1 e3 0a             	shl    $0xa,%ebx
  100984:	8d 04 0b             	lea    (%ebx,%ecx,1),%eax
            page_table[i][j].rw = 1;
  100987:	8a 14 85 00 60 11 00 	mov    0x116000(,%eax,4),%dl
  10098e:	83 e2 fa             	and    $0xfffffffa,%edx
            page_table[i][j].user = 0;
  100991:	83 ca 02             	or     $0x2,%edx
  100994:	88 14 85 00 60 11 00 	mov    %dl,0x116000(,%eax,4)
            page_table[i][j].reserved = 0;
  10099b:	66 81 24 85 00 60 11 	andw   $0xf007,0x116000(,%eax,4)
  1009a2:	00 07 f0 
            page_table[i][j].frame_addr = 0;
  1009a5:	81 24 85 00 60 11 00 	andl   $0xfff,0x116000(,%eax,4)
  1009ac:	ff 0f 00 00 
        for (int j = 0; j < 1024; j++) {
  1009b0:	41                   	inc    %ecx
  1009b1:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
  1009b7:	75 cb                	jne    100984 <page_init+0x4a>
    for (int i = 0; i < 4; i++) {
  1009b9:	46                   	inc    %esi
  1009ba:	83 fe 04             	cmp    $0x4,%esi
  1009bd:	75 bb                	jne    10097a <page_init+0x40>
        }
    }

    // 初始化物理页位图，所有页初始为可用（除了内核使用的）
    memset(phys_bitmap, 0, sizeof(phys_bitmap));
  1009bf:	83 ec 04             	sub    $0x4,%esp
  1009c2:	68 00 02 00 00       	push   $0x200
  1009c7:	6a 00                	push   $0x0
  1009c9:	68 00 50 11 00       	push   $0x115000
  1009ce:	e8 d7 fa ff ff       	call   1004aa <memset>
  1009d3:	83 c4 10             	add    $0x10,%esp
    // 标记内核使用的页为已用（假设内核使用前64页，256KB）
    for (int i = 0; i < 64; i++) {
  1009d6:	b8 00 00 00 00       	mov    $0x0,%eax
    bitmap[bit / 8] |= (1 << (bit % 8));
  1009db:	bb 01 00 00 00       	mov    $0x1,%ebx
  1009e0:	eb 1a                	jmp    1009fc <page_init+0xc2>
  1009e2:	c1 fa 03             	sar    $0x3,%edx
  1009e5:	89 c1                	mov    %eax,%ecx
  1009e7:	83 e1 07             	and    $0x7,%ecx
  1009ea:	89 de                	mov    %ebx,%esi
  1009ec:	d3 e6                	shl    %cl,%esi
  1009ee:	89 f1                	mov    %esi,%ecx
  1009f0:	08 8a 00 50 11 00    	or     %cl,0x115000(%edx)
    for (int i = 0; i < 64; i++) {
  1009f6:	40                   	inc    %eax
  1009f7:	83 f8 40             	cmp    $0x40,%eax
  1009fa:	74 0b                	je     100a07 <page_init+0xcd>
    bitmap[bit / 8] |= (1 << (bit % 8));
  1009fc:	89 c2                	mov    %eax,%edx
  1009fe:	85 c0                	test   %eax,%eax
  100a00:	79 e0                	jns    1009e2 <page_init+0xa8>
  100a02:	8d 50 07             	lea    0x7(%eax),%edx
  100a05:	eb db                	jmp    1009e2 <page_init+0xa8>
        set_bit(phys_bitmap, i);
    }

    // 映射前 4MB 内存
    for (int i = 0; i < 1024; i++) {
  100a07:	b8 00 00 00 00       	mov    $0x0,%eax
        page_table[0][i].present = 1;
        page_table[0][i].rw = 1;
  100a0c:	8a 14 85 00 60 11 00 	mov    0x116000(,%eax,4),%dl
  100a13:	83 ca 03             	or     $0x3,%edx
        page_table[0][i].user = 0;
  100a16:	83 e2 fb             	and    $0xfffffffb,%edx
  100a19:	88 14 85 00 60 11 00 	mov    %dl,0x116000(,%eax,4)
        page_table[0][i].frame_addr = i; // 映射到物理地址 i * 4KB
  100a20:	89 c1                	mov    %eax,%ecx
  100a22:	c1 e1 0c             	shl    $0xc,%ecx
  100a25:	8b 14 85 00 60 11 00 	mov    0x116000(,%eax,4),%edx
  100a2c:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  100a32:	09 ca                	or     %ecx,%edx
  100a34:	89 14 85 00 60 11 00 	mov    %edx,0x116000(,%eax,4)
    for (int i = 0; i < 1024; i++) {
  100a3b:	40                   	inc    %eax
  100a3c:	3d 00 04 00 00       	cmp    $0x400,%eax
  100a41:	75 c9                	jne    100a0c <page_init+0xd2>
    }

    // 设置页目录的第一个条目指向第一个页表
    page_directory[0].present = 1;
    page_directory[0].rw = 1;
  100a43:	a0 00 60 31 00       	mov    0x316000,%al
  100a48:	83 c8 03             	or     $0x3,%eax
    page_directory[0].user = 0;
  100a4b:	83 e0 fb             	and    $0xfffffffb,%eax
  100a4e:	a2 00 60 31 00       	mov    %al,0x316000
    page_directory[0].table_addr = ((uint32_t)page_table[0]) >> 12;
  100a53:	ba 00 60 11 00       	mov    $0x116000,%edx
  100a58:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  100a5e:	a1 00 60 31 00       	mov    0x316000,%eax
  100a63:	25 ff 0f 00 00       	and    $0xfff,%eax
  100a68:	09 d0                	or     %edx,%eax
  100a6a:	a3 00 60 31 00       	mov    %eax,0x316000

    // 映射直接映射区域 0xC0000000 到物理 0 (前 4MB)
    for (int i = 0; i < 1024; i++) {
  100a6f:	ba 00 00 00 00       	mov    $0x0,%edx
        page_table[1][i].present = 1;
  100a74:	8d 8a 00 04 00 00    	lea    0x400(%edx),%ecx
        page_table[1][i].rw = 1;
  100a7a:	8a 04 8d 00 60 11 00 	mov    0x116000(,%ecx,4),%al
  100a81:	83 c8 03             	or     $0x3,%eax
        page_table[1][i].user = 0;
  100a84:	83 e0 fb             	and    $0xfffffffb,%eax
  100a87:	88 04 8d 00 60 11 00 	mov    %al,0x116000(,%ecx,4)
        page_table[1][i].frame_addr = i; // 映射到物理地址 i * 4KB
  100a8e:	89 d3                	mov    %edx,%ebx
  100a90:	c1 e3 0c             	shl    $0xc,%ebx
  100a93:	8b 04 8d 00 60 11 00 	mov    0x116000(,%ecx,4),%eax
  100a9a:	25 ff 0f 00 00       	and    $0xfff,%eax
  100a9f:	09 d8                	or     %ebx,%eax
  100aa1:	89 04 8d 00 60 11 00 	mov    %eax,0x116000(,%ecx,4)
    for (int i = 0; i < 1024; i++) {
  100aa8:	42                   	inc    %edx
  100aa9:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  100aaf:	75 c3                	jne    100a74 <page_init+0x13a>
    }

    // 设置页目录的第768个条目指向第二个页表 (0xC0000000)
    page_directory[768].present = 1;
    page_directory[768].rw = 1;
  100ab1:	a0 00 6c 31 00       	mov    0x316c00,%al
  100ab6:	83 c8 03             	or     $0x3,%eax
    page_directory[768].user = 0;
  100ab9:	83 e0 fb             	and    $0xfffffffb,%eax
  100abc:	a2 00 6c 31 00       	mov    %al,0x316c00
    page_directory[768].table_addr = ((uint32_t)page_table[1]) >> 12;
  100ac1:	ba 00 70 11 00       	mov    $0x117000,%edx
  100ac6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  100acc:	a1 00 6c 31 00       	mov    0x316c00,%eax
  100ad1:	25 ff 0f 00 00       	and    $0xfff,%eax
  100ad6:	09 d0                	or     %edx,%eax
  100ad8:	a3 00 6c 31 00       	mov    %eax,0x316c00

    // 预先设置用户程序页目录项（页目录索引2，对应0x00800000）
    page_directory[2].present = 1;
    page_directory[2].rw = 1;
    page_directory[2].user = 1;
  100add:	80 0d 08 60 31 00 07 	orb    $0x7,0x316008
    page_directory[2].table_addr = ((uint32_t)page_table[2]) >> 12;
  100ae4:	ba 00 80 11 00       	mov    $0x118000,%edx
  100ae9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  100aef:	a1 08 60 31 00       	mov    0x316008,%eax
  100af4:	25 ff 0f 00 00       	and    $0xfff,%eax
  100af9:	09 d0                	or     %edx,%eax
  100afb:	a3 08 60 31 00       	mov    %eax,0x316008

    //内核页表，0-1MB

    // 加载页目录地址到 CR3 寄存器
    asm volatile("mov %0, %%cr3" : : "r"(&page_directory));
  100b00:	b8 00 60 31 00       	mov    $0x316000,%eax
  100b05:	0f 22 d8             	mov    %eax,%cr3

    // 启用分页，设置 CR0 寄存器的分页位
    uint32_t cr0;
    asm volatile("mov %%cr0, %0" : "=r"(cr0));
  100b08:	0f 20 c0             	mov    %cr0,%eax
    cr0 |= 0x80000000; // 设置分页位
  100b0b:	0d 00 00 00 80       	or     $0x80000000,%eax
    asm volatile("mov %0, %%cr0" : : "r"(cr0));
  100b10:	0f 22 c0             	mov    %eax,%cr0
}
  100b13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  100b16:	5b                   	pop    %ebx
  100b17:	5e                   	pop    %esi
  100b18:	5d                   	pop    %ebp
  100b19:	c3                   	ret

00100b1a <alloc_phys_page>:

uint32_t alloc_phys_page() {
  100b1a:	55                   	push   %ebp
  100b1b:	89 e5                	mov    %esp,%ebp
  100b1d:	56                   	push   %esi
  100b1e:	53                   	push   %ebx
    return (bitmap[bit / 8] >> (bit % 8)) & 1;
  100b1f:	8a 1d 00 50 11 00    	mov    0x115000,%bl
    for (int i = 0; i < 4096; i++) {
        if (!get_bit(phys_bitmap, i)) { // 页空闲
  100b25:	f6 c3 01             	test   $0x1,%bl
  100b28:	74 38                	je     100b62 <alloc_phys_page+0x48>
    for (int i = 0; i < 4096; i++) {
  100b2a:	b8 00 00 00 00       	mov    $0x0,%eax
  100b2f:	eb 1e                	jmp    100b4f <alloc_phys_page+0x35>
    return (bitmap[bit / 8] >> (bit % 8)) & 1;
  100b31:	c1 fa 03             	sar    $0x3,%edx
  100b34:	8d b2 00 50 11 00    	lea    0x115000(%edx),%esi
  100b3a:	8a 9a 00 50 11 00    	mov    0x115000(%edx),%bl
  100b40:	89 c1                	mov    %eax,%ecx
  100b42:	83 e1 07             	and    $0x7,%ecx
  100b45:	0f b6 d3             	movzbl %bl,%edx
  100b48:	d3 fa                	sar    %cl,%edx
        if (!get_bit(phys_bitmap, i)) { // 页空闲
  100b4a:	f6 c2 01             	test   $0x1,%dl
  100b4d:	74 22                	je     100b71 <alloc_phys_page+0x57>
    for (int i = 0; i < 4096; i++) {
  100b4f:	40                   	inc    %eax
  100b50:	3d 00 10 00 00       	cmp    $0x1000,%eax
  100b55:	74 2c                	je     100b83 <alloc_phys_page+0x69>
    return (bitmap[bit / 8] >> (bit % 8)) & 1;
  100b57:	89 c2                	mov    %eax,%edx
  100b59:	85 c0                	test   %eax,%eax
  100b5b:	79 d4                	jns    100b31 <alloc_phys_page+0x17>
  100b5d:	8d 50 07             	lea    0x7(%eax),%edx
  100b60:	eb cf                	jmp    100b31 <alloc_phys_page+0x17>
  100b62:	b9 00 00 00 00       	mov    $0x0,%ecx
  100b67:	be 00 50 11 00       	mov    $0x115000,%esi
    for (int i = 0; i < 4096; i++) {
  100b6c:	b8 00 00 00 00       	mov    $0x0,%eax
    bitmap[bit / 8] |= (1 << (bit % 8));
  100b71:	ba 01 00 00 00       	mov    $0x1,%edx
  100b76:	d3 e2                	shl    %cl,%edx
  100b78:	09 d3                	or     %edx,%ebx
  100b7a:	88 1e                	mov    %bl,(%esi)
            set_bit(phys_bitmap, i);   // 标记为已用
            return i * PAGE_SIZE;      // 返回物理地址
  100b7c:	c1 e0 0c             	shl    $0xc,%eax
        }
    }
    return 0; // 没有空闲页
}
  100b7f:	5b                   	pop    %ebx
  100b80:	5e                   	pop    %esi
  100b81:	5d                   	pop    %ebp
  100b82:	c3                   	ret
    return 0; // 没有空闲页
  100b83:	b8 00 00 00 00       	mov    $0x0,%eax
  100b88:	eb f5                	jmp    100b7f <alloc_phys_page+0x65>

00100b8a <free_phys_page>:

void free_phys_page(uint32_t addr) {
  100b8a:	55                   	push   %ebp
  100b8b:	89 e5                	mov    %esp,%ebp
  100b8d:	8b 45 08             	mov    0x8(%ebp),%eax
    int index = addr / PAGE_SIZE;
  100b90:	89 c1                	mov    %eax,%ecx
  100b92:	c1 e9 0c             	shr    $0xc,%ecx
    bitmap[bit / 8] &= ~(1 << (bit % 8));
  100b95:	c1 e8 0f             	shr    $0xf,%eax
  100b98:	83 e1 07             	and    $0x7,%ecx
  100b9b:	ba 01 00 00 00       	mov    $0x1,%edx
  100ba0:	d3 e2                	shl    %cl,%edx
  100ba2:	f7 d2                	not    %edx
  100ba4:	20 90 00 50 11 00    	and    %dl,0x115000(%eax)
    clear_bit(phys_bitmap, index);
}
  100baa:	5d                   	pop    %ebp
  100bab:	c3                   	ret

00100bac <alloc_page>:

void alloc_page(uint32_t fault_addr, bool is_write, bool is_user) {
  100bac:	55                   	push   %ebp
  100bad:	89 e5                	mov    %esp,%ebp
  100baf:	57                   	push   %edi
  100bb0:	56                   	push   %esi
  100bb1:	53                   	push   %ebx
  100bb2:	83 ec 1c             	sub    $0x1c,%esp
  100bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb8:	8b 7d 0c             	mov    0xc(%ebp),%edi
  100bbb:	8b 75 10             	mov    0x10(%ebp),%esi
    uint32_t dir_idx   = (fault_addr >> 22) & 0x3FF; // 高 10 位
  100bbe:	89 c3                	mov    %eax,%ebx
  100bc0:	c1 eb 16             	shr    $0x16,%ebx
    uint32_t table_idx = (fault_addr >> 12) & 0x3FF; // 中间 10 位
  100bc3:	c1 e8 0c             	shr    $0xc,%eax
  100bc6:	25 ff 03 00 00       	and    $0x3ff,%eax
  100bcb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    struct PagedDirectoryEntry *pde = &page_directory[dir_idx];

    if (!pde->present) {
  100bce:	f6 04 9d 00 60 31 00 	testb  $0x1,0x316000(,%ebx,4)
  100bd5:	01 
  100bd6:	75 30                	jne    100c08 <alloc_page+0x5c>
        // 设置PDE指向对应的页表
        pde->table_addr = ((uint32_t)page_table[dir_idx]) >> 12;
  100bd8:	89 da                	mov    %ebx,%edx
  100bda:	c1 e2 0c             	shl    $0xc,%edx
  100bdd:	81 c2 00 60 11 00    	add    $0x116000,%edx
  100be3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  100be9:	8b 04 9d 00 60 31 00 	mov    0x316000(,%ebx,4),%eax
  100bf0:	25 ff 0f 00 00       	and    $0xfff,%eax
  100bf5:	09 d0                	or     %edx,%eax
  100bf7:	89 04 9d 00 60 31 00 	mov    %eax,0x316000(,%ebx,4)
        pde->present    = 1;
        pde->rw         = 1;
        pde->user       = 1;
  100bfe:	83 c8 07             	or     $0x7,%eax
  100c01:	88 04 9d 00 60 31 00 	mov    %al,0x316000(,%ebx,4)
    }

    struct PageTableEntry *pte = &page_table[dir_idx][table_idx];
    uint32_t phys_page = alloc_phys_page();  // 新分配一个 4 KB 物理页
  100c08:	e8 0d ff ff ff       	call   100b1a <alloc_phys_page>
    
    // 通过直接映射区域清零物理页
    //uint32_t virt_addr = 0xC0000000 + phys_page;  // 直接映射虚拟地址
    //memset((void*)virt_addr, 0, PAGE_SIZE);

    pte->frame_addr = phys_page >> 12;
  100c0d:	c1 e3 0a             	shl    $0xa,%ebx
  100c10:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  100c13:	01 cb                	add    %ecx,%ebx
  100c15:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  100c1a:	89 c2                	mov    %eax,%edx
  100c1c:	8b 04 9d 00 60 11 00 	mov    0x116000(,%ebx,4),%eax
  100c23:	25 ff 0f 00 00       	and    $0xfff,%eax
  100c28:	09 d0                	or     %edx,%eax
  100c2a:	89 04 9d 00 60 11 00 	mov    %eax,0x116000(,%ebx,4)
    pte->present    = 1;
  100c31:	83 c8 01             	or     $0x1,%eax
    pte->rw         = is_write ? 1 : 0;
  100c34:	83 e7 01             	and    $0x1,%edi
  100c37:	d1 e7                	shl    $1,%edi
  100c39:	83 e0 f9             	and    $0xfffffff9,%eax
    pte->user       = is_user ? 1 : 0;
  100c3c:	83 e6 01             	and    $0x1,%esi
  100c3f:	c1 e6 02             	shl    $0x2,%esi
  100c42:	09 f8                	or     %edi,%eax
  100c44:	09 f0                	or     %esi,%eax
  100c46:	88 04 9d 00 60 11 00 	mov    %al,0x116000(,%ebx,4)
}
  100c4d:	83 c4 1c             	add    $0x1c,%esp
  100c50:	5b                   	pop    %ebx
  100c51:	5e                   	pop    %esi
  100c52:	5f                   	pop    %edi
  100c53:	5d                   	pop    %ebp
  100c54:	c3                   	ret

00100c55 <r_cr2>:

int r_cr2(){
    uint32_t val;
    asm volatile("mov %%cr2, %0" : "=r"(val));
  100c55:	0f 20 d0             	mov    %cr2,%eax
    return val;
}
  100c58:	c3                   	ret

00100c59 <page_not_found_handler>:

void page_not_found_handler(uint32_t err) {
  100c59:	55                   	push   %ebp
  100c5a:	89 e5                	mov    %esp,%ebp
  100c5c:	83 ec 0c             	sub    $0xc,%esp
  100c5f:	8b 45 08             	mov    0x8(%ebp),%eax
    asm volatile("mov %%cr2, %0" : "=r"(val));
  100c62:	0f 20 d1             	mov    %cr2,%ecx
    uint32_t fault_addr = r_cr2();
    uint32_t err_code = err;
    bool is_write = err_code & (1 << 1);
    bool is_user  = err_code & (1 << 2);
  100c65:	89 c2                	mov    %eax,%edx
  100c67:	c1 ea 02             	shr    $0x2,%edx
  100c6a:	83 e2 01             	and    $0x1,%edx

    alloc_page(fault_addr, is_write, is_user);
  100c6d:	52                   	push   %edx
    bool is_write = err_code & (1 << 1);
  100c6e:	d1 e8                	shr    $1,%eax
  100c70:	83 e0 01             	and    $0x1,%eax
    alloc_page(fault_addr, is_write, is_user);
  100c73:	50                   	push   %eax
  100c74:	51                   	push   %ecx
  100c75:	e8 32 ff ff ff       	call   100bac <alloc_page>
}
  100c7a:	83 c4 10             	add    $0x10,%esp
  100c7d:	c9                   	leave
  100c7e:	c3                   	ret

00100c7f <put_char>:
#include "sbi.h"

static char *video_memory = (char *)0xb8000;

void put_char(char c)
{
  100c7f:	55                   	push   %ebp
  100c80:	89 e5                	mov    %esp,%ebp
  100c82:	53                   	push   %ebx
  100c83:	8b 55 08             	mov    0x8(%ebp),%edx
  100c86:	88 d1                	mov    %dl,%cl
    // 简单的换行处理 logic
    if (c == '\n')
  100c88:	80 fa 0a             	cmp    $0xa,%dl
  100c8b:	74 20                	je     100cad <put_char+0x2e>
        uint32_t next_row_offset = (current_row + 1) * 80 * 2;
        video_memory = (char *)(0xb8000 + next_row_offset);
    }
    else
    {
        *video_memory = c;
  100c8d:	a1 60 36 10 00       	mov    0x103660,%eax
  100c92:	88 10                	mov    %dl,(%eax)
        video_memory++;
        *video_memory = 0x07; // 黑底灰字
  100c94:	c6 40 01 07          	movb   $0x7,0x1(%eax)
        video_memory++;
  100c98:	83 c0 02             	add    $0x2,%eax
        video_memory = (char *)(0xb8000 + next_row_offset);
  100c9b:	a3 60 36 10 00       	mov    %eax,0x103660
    }

    // 也写到串口 COM1（0x3F8），便于在 QEMU 中使用 -serial stdio 查看
    unsigned short port = 0x3f8;
    asm volatile("outb %0, %1" ::"a"(c), "Nd"(port));
  100ca0:	ba f8 03 00 00       	mov    $0x3f8,%edx
  100ca5:	88 c8                	mov    %cl,%al
  100ca7:	ee                   	out    %al,(%dx)
}
  100ca8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100cab:	c9                   	leave
  100cac:	c3                   	ret
        uint32_t current_offset = (uint32_t)(video_memory - 0xb8000);
  100cad:	a1 60 36 10 00       	mov    0x103660,%eax
  100cb2:	8d 90 00 80 f4 ff    	lea    -0xb8000(%eax),%edx
        uint32_t current_row = (current_offset / 2) / 80;
  100cb8:	bb cd cc cc cc       	mov    $0xcccccccd,%ebx
  100cbd:	89 d0                	mov    %edx,%eax
  100cbf:	f7 e3                	mul    %ebx
  100cc1:	c1 ea 07             	shr    $0x7,%edx
        video_memory = (char *)(0xb8000 + next_row_offset);
  100cc4:	8d 04 92             	lea    (%edx,%edx,4),%eax
  100cc7:	c1 e0 05             	shl    $0x5,%eax
  100cca:	05 a0 80 0b 00       	add    $0xb80a0,%eax
  100ccf:	eb ca                	jmp    100c9b <put_char+0x1c>

00100cd1 <shutdown>:

static inline void outw(uint16_t port, uint16_t value)
{
    __asm__ volatile("outw %0, %1" : : "a"(value), "Nd"(port));
  100cd1:	b8 00 20 00 00       	mov    $0x2000,%eax
  100cd6:	ba 04 06 00 00       	mov    $0x604,%edx
  100cdb:	66 ef                	out    %ax,(%dx)

void shutdown()
{
    outw(0x604, 0x2000); // QEMU power off
    for (;;)
        __asm__ volatile("hlt");
  100cdd:	f4                   	hlt
    for (;;)
  100cde:	eb fd                	jmp    100cdd <shutdown+0xc>

00100ce0 <sys_write>:
#include "../riscv/syscall_ids.h"
#include "../../types.h"
#include "../../console.h"

uint32 sys_write(int fd, const char *str, uint32 len)
{
  100ce0:	55                   	push   %ebp
  100ce1:	89 e5                	mov    %esp,%ebp
  100ce3:	57                   	push   %edi
  100ce4:	56                   	push   %esi
  100ce5:	53                   	push   %ebx
  100ce6:	83 ec 0c             	sub    $0xc,%esp
  100ce9:	8b 75 0c             	mov    0xc(%ebp),%esi
  100cec:	8b 7d 10             	mov    0x10(%ebp),%edi
    // fd=1 (stdout) 或 fd=2 (stderr) 都可以输出
    if ((fd != 1 && fd != 2) || str == 0)
  100cef:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf2:	48                   	dec    %eax
  100cf3:	83 f8 01             	cmp    $0x1,%eax
  100cf6:	77 2a                	ja     100d22 <sys_write+0x42>
  100cf8:	85 f6                	test   %esi,%esi
  100cfa:	74 2d                	je     100d29 <sys_write+0x49>
        return -1;
    for (uint32_t i = 0; i < len; ++i)
  100cfc:	85 ff                	test   %edi,%edi
  100cfe:	74 18                	je     100d18 <sys_write+0x38>
  100d00:	89 f3                	mov    %esi,%ebx
  100d02:	01 fe                	add    %edi,%esi
        put_char(str[i]);
  100d04:	83 ec 0c             	sub    $0xc,%esp
  100d07:	0f be 03             	movsbl (%ebx),%eax
  100d0a:	50                   	push   %eax
  100d0b:	e8 6f ff ff ff       	call   100c7f <put_char>
    for (uint32_t i = 0; i < len; ++i)
  100d10:	43                   	inc    %ebx
  100d11:	83 c4 10             	add    $0x10,%esp
  100d14:	39 f3                	cmp    %esi,%ebx
  100d16:	75 ec                	jne    100d04 <sys_write+0x24>
    return len;
}
  100d18:	89 f8                	mov    %edi,%eax
  100d1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  100d1d:	5b                   	pop    %ebx
  100d1e:	5e                   	pop    %esi
  100d1f:	5f                   	pop    %edi
  100d20:	5d                   	pop    %ebp
  100d21:	c3                   	ret
        return -1;
  100d22:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  100d27:	eb ef                	jmp    100d18 <sys_write+0x38>
  100d29:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  100d2e:	eb e8                	jmp    100d18 <sys_write+0x38>

00100d30 <sys_exit>:

__attribute__((noreturn)) void sys_exit(int code)
{
  100d30:	55                   	push   %ebp
  100d31:	89 e5                	mov    %esp,%ebp
  100d33:	83 ec 08             	sub    $0x8,%esp
    shutdown();
  100d36:	e8 96 ff ff ff       	call   100cd1 <shutdown>

00100d3b <syscall>:
    __builtin_unreachable();
}

void syscall(struct trapframe *tf)
{
  100d3b:	55                   	push   %ebp
  100d3c:	89 e5                	mov    %esp,%ebp
  100d3e:	56                   	push   %esi
  100d3f:	53                   	push   %ebx
  100d40:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (!tf)
  100d43:	85 db                	test   %ebx,%ebx
  100d45:	74 22                	je     100d69 <syscall+0x2e>
        return;
    int id = tf->eax;
  100d47:	8b 43 1c             	mov    0x1c(%ebx),%eax
    int ret = -1;
    uint32 args[6] = {tf->ebx, tf->ecx, tf->edx, tf->esi, tf->edi, tf->ebp};
  100d4a:	8b 53 10             	mov    0x10(%ebx),%edx
  100d4d:	8b 4b 18             	mov    0x18(%ebx),%ecx
  100d50:	8b 73 14             	mov    0x14(%ebx),%esi
    __attribute__((unused)) uint32 eip = stack[0];
    __attribute__((unused)) uint32 cs = stack[1];
    __attribute__((unused)) uint32 eflags = stack[2];
    __attribute__((unused)) uint32 user_esp = stack[3];
    __attribute__((unused)) uint32 user_ss = stack[4];
    switch (id)
  100d53:	83 f8 40             	cmp    $0x40,%eax
  100d56:	75 18                	jne    100d70 <syscall+0x35>
    {
    case SYS_write:
        ret = sys_write(args[0], (const char *)args[1], args[2]);
  100d58:	83 ec 04             	sub    $0x4,%esp
  100d5b:	56                   	push   %esi
  100d5c:	51                   	push   %ecx
  100d5d:	52                   	push   %edx
  100d5e:	e8 7d ff ff ff       	call   100ce0 <sys_write>
    default:
        printf("unknown interrupt or exception");
        sys_exit(args[0]);
        break;
    }
    tf->eax = ret;
  100d63:	89 43 1c             	mov    %eax,0x1c(%ebx)
  100d66:	83 c4 10             	add    $0x10,%esp
}
  100d69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  100d6c:	5b                   	pop    %ebx
  100d6d:	5e                   	pop    %esi
  100d6e:	5d                   	pop    %ebp
  100d6f:	c3                   	ret
    switch (id)
  100d70:	83 f8 5d             	cmp    $0x5d,%eax
  100d73:	74 12                	je     100d87 <syscall+0x4c>
        printf("unknown interrupt or exception");
  100d75:	83 ec 0c             	sub    $0xc,%esp
  100d78:	68 90 21 10 00       	push   $0x102190
  100d7d:	e8 b5 f6 ff ff       	call   100437 <printf>
    shutdown();
  100d82:	e8 4a ff ff ff       	call   100cd1 <shutdown>
  100d87:	e8 45 ff ff ff       	call   100cd1 <shutdown>

00100d8c <idt_init>:

__attribute__((aligned(4096))) char trap_page[0x1000];
__attribute__((aligned(4096))) char user_stack_top[0x1000];

void idt_init(void)
{
  100d8c:	55                   	push   %ebp
  100d8d:	89 e5                	mov    %esp,%ebp
  100d8f:	83 ec 0c             	sub    $0xc,%esp
    memset(idt, 0, sizeof(idt));
  100d92:	68 00 08 00 00       	push   $0x800
  100d97:	6a 00                	push   $0x0
  100d99:	68 00 41 11 00       	push   $0x114100
  100d9e:	e8 07 f7 ff ff       	call   1004aa <memset>

    set_idt_gate(0x80, trap_entry_0x80, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100da3:	68 ee 00 00 00       	push   $0xee
  100da8:	6a 08                	push   $0x8
  100daa:	68 52 07 10 00       	push   $0x100752
  100daf:	68 80 00 00 00       	push   $0x80
  100db4:	e8 17 fb ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(0, trap_entry_0, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100db9:	83 c4 20             	add    $0x20,%esp
  100dbc:	68 ee 00 00 00       	push   $0xee
  100dc1:	6a 08                	push   $0x8
  100dc3:	68 5e 06 10 00       	push   $0x10065e
  100dc8:	6a 00                	push   $0x0
  100dca:	e8 01 fb ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(1, trap_entry_1, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100dcf:	68 ee 00 00 00       	push   $0xee
  100dd4:	6a 08                	push   $0x8
  100dd6:	68 64 06 10 00       	push   $0x100664
  100ddb:	6a 01                	push   $0x1
  100ddd:	e8 ee fa ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(2, trap_entry_2, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100de2:	83 c4 20             	add    $0x20,%esp
  100de5:	68 ee 00 00 00       	push   $0xee
  100dea:	6a 08                	push   $0x8
  100dec:	68 6a 06 10 00       	push   $0x10066a
  100df1:	6a 02                	push   $0x2
  100df3:	e8 d8 fa ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(3, trap_entry_3, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100df8:	68 ee 00 00 00       	push   $0xee
  100dfd:	6a 08                	push   $0x8
  100dff:	68 70 06 10 00       	push   $0x100670
  100e04:	6a 03                	push   $0x3
  100e06:	e8 c5 fa ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(4, trap_entry_4, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e0b:	83 c4 20             	add    $0x20,%esp
  100e0e:	68 ee 00 00 00       	push   $0xee
  100e13:	6a 08                	push   $0x8
  100e15:	68 76 06 10 00       	push   $0x100676
  100e1a:	6a 04                	push   $0x4
  100e1c:	e8 af fa ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(5, trap_entry_5, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e21:	68 ee 00 00 00       	push   $0xee
  100e26:	6a 08                	push   $0x8
  100e28:	68 7c 06 10 00       	push   $0x10067c
  100e2d:	6a 05                	push   $0x5
  100e2f:	e8 9c fa ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(6, trap_entry_6, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e34:	83 c4 20             	add    $0x20,%esp
  100e37:	68 ee 00 00 00       	push   $0xee
  100e3c:	6a 08                	push   $0x8
  100e3e:	68 82 06 10 00       	push   $0x100682
  100e43:	6a 06                	push   $0x6
  100e45:	e8 86 fa ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(7, trap_entry_7, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e4a:	68 ee 00 00 00       	push   $0xee
  100e4f:	6a 08                	push   $0x8
  100e51:	68 88 06 10 00       	push   $0x100688
  100e56:	6a 07                	push   $0x7
  100e58:	e8 73 fa ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(8, trap_entry_8, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e5d:	83 c4 20             	add    $0x20,%esp
  100e60:	68 ee 00 00 00       	push   $0xee
  100e65:	6a 08                	push   $0x8
  100e67:	68 8e 06 10 00       	push   $0x10068e
  100e6c:	6a 08                	push   $0x8
  100e6e:	e8 5d fa ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(9, trap_entry_9, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e73:	68 ee 00 00 00       	push   $0xee
  100e78:	6a 08                	push   $0x8
  100e7a:	68 94 06 10 00       	push   $0x100694
  100e7f:	6a 09                	push   $0x9
  100e81:	e8 4a fa ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(10, trap_entry_10, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e86:	83 c4 20             	add    $0x20,%esp
  100e89:	68 ee 00 00 00       	push   $0xee
  100e8e:	6a 08                	push   $0x8
  100e90:	68 9a 06 10 00       	push   $0x10069a
  100e95:	6a 0a                	push   $0xa
  100e97:	e8 34 fa ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(11, trap_entry_11, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100e9c:	68 ee 00 00 00       	push   $0xee
  100ea1:	6a 08                	push   $0x8
  100ea3:	68 a0 06 10 00       	push   $0x1006a0
  100ea8:	6a 0b                	push   $0xb
  100eaa:	e8 21 fa ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(12, trap_entry_12, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100eaf:	83 c4 20             	add    $0x20,%esp
  100eb2:	68 ee 00 00 00       	push   $0xee
  100eb7:	6a 08                	push   $0x8
  100eb9:	68 a6 06 10 00       	push   $0x1006a6
  100ebe:	6a 0c                	push   $0xc
  100ec0:	e8 0b fa ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(13, trap_entry_13, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100ec5:	68 ee 00 00 00       	push   $0xee
  100eca:	6a 08                	push   $0x8
  100ecc:	68 ac 06 10 00       	push   $0x1006ac
  100ed1:	6a 0d                	push   $0xd
  100ed3:	e8 f8 f9 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(14, trap_entry_14, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100ed8:	83 c4 20             	add    $0x20,%esp
  100edb:	68 ee 00 00 00       	push   $0xee
  100ee0:	6a 08                	push   $0x8
  100ee2:	68 b2 06 10 00       	push   $0x1006b2
  100ee7:	6a 0e                	push   $0xe
  100ee9:	e8 e2 f9 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(15, trap_entry_15, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100eee:	68 ee 00 00 00       	push   $0xee
  100ef3:	6a 08                	push   $0x8
  100ef5:	68 b9 06 10 00       	push   $0x1006b9
  100efa:	6a 0f                	push   $0xf
  100efc:	e8 cf f9 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(16, trap_entry_16, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100f01:	83 c4 20             	add    $0x20,%esp
  100f04:	68 ee 00 00 00       	push   $0xee
  100f09:	6a 08                	push   $0x8
  100f0b:	68 c2 06 10 00       	push   $0x1006c2
  100f10:	6a 10                	push   $0x10
  100f12:	e8 b9 f9 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(17, trap_entry_17, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100f17:	68 ee 00 00 00       	push   $0xee
  100f1c:	6a 08                	push   $0x8
  100f1e:	68 cb 06 10 00       	push   $0x1006cb
  100f23:	6a 11                	push   $0x11
  100f25:	e8 a6 f9 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(18, trap_entry_18, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100f2a:	83 c4 20             	add    $0x20,%esp
  100f2d:	68 ee 00 00 00       	push   $0xee
  100f32:	6a 08                	push   $0x8
  100f34:	68 d4 06 10 00       	push   $0x1006d4
  100f39:	6a 12                	push   $0x12
  100f3b:	e8 90 f9 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(19, trap_entry_19, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100f40:	68 ee 00 00 00       	push   $0xee
  100f45:	6a 08                	push   $0x8
  100f47:	68 dd 06 10 00       	push   $0x1006dd
  100f4c:	6a 13                	push   $0x13
  100f4e:	e8 7d f9 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(20, trap_entry_20, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100f53:	83 c4 20             	add    $0x20,%esp
  100f56:	68 ee 00 00 00       	push   $0xee
  100f5b:	6a 08                	push   $0x8
  100f5d:	68 e6 06 10 00       	push   $0x1006e6
  100f62:	6a 14                	push   $0x14
  100f64:	e8 67 f9 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(21, trap_entry_21, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100f69:	68 ee 00 00 00       	push   $0xee
  100f6e:	6a 08                	push   $0x8
  100f70:	68 ef 06 10 00       	push   $0x1006ef
  100f75:	6a 15                	push   $0x15
  100f77:	e8 54 f9 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(22, trap_entry_22, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100f7c:	83 c4 20             	add    $0x20,%esp
  100f7f:	68 ee 00 00 00       	push   $0xee
  100f84:	6a 08                	push   $0x8
  100f86:	68 f8 06 10 00       	push   $0x1006f8
  100f8b:	6a 16                	push   $0x16
  100f8d:	e8 3e f9 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(23, trap_entry_23, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100f92:	68 ee 00 00 00       	push   $0xee
  100f97:	6a 08                	push   $0x8
  100f99:	68 01 07 10 00       	push   $0x100701
  100f9e:	6a 17                	push   $0x17
  100fa0:	e8 2b f9 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(24, trap_entry_24, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100fa5:	83 c4 20             	add    $0x20,%esp
  100fa8:	68 ee 00 00 00       	push   $0xee
  100fad:	6a 08                	push   $0x8
  100faf:	68 0a 07 10 00       	push   $0x10070a
  100fb4:	6a 18                	push   $0x18
  100fb6:	e8 15 f9 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(25, trap_entry_25, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100fbb:	68 ee 00 00 00       	push   $0xee
  100fc0:	6a 08                	push   $0x8
  100fc2:	68 13 07 10 00       	push   $0x100713
  100fc7:	6a 19                	push   $0x19
  100fc9:	e8 02 f9 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(26, trap_entry_26, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100fce:	83 c4 20             	add    $0x20,%esp
  100fd1:	68 ee 00 00 00       	push   $0xee
  100fd6:	6a 08                	push   $0x8
  100fd8:	68 1c 07 10 00       	push   $0x10071c
  100fdd:	6a 1a                	push   $0x1a
  100fdf:	e8 ec f8 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(27, trap_entry_27, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100fe4:	68 ee 00 00 00       	push   $0xee
  100fe9:	6a 08                	push   $0x8
  100feb:	68 25 07 10 00       	push   $0x100725
  100ff0:	6a 1b                	push   $0x1b
  100ff2:	e8 d9 f8 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(28, trap_entry_28, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  100ff7:	83 c4 20             	add    $0x20,%esp
  100ffa:	68 ee 00 00 00       	push   $0xee
  100fff:	6a 08                	push   $0x8
  101001:	68 2e 07 10 00       	push   $0x10072e
  101006:	6a 1c                	push   $0x1c
  101008:	e8 c3 f8 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(29, trap_entry_29, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  10100d:	68 ee 00 00 00       	push   $0xee
  101012:	6a 08                	push   $0x8
  101014:	68 37 07 10 00       	push   $0x100737
  101019:	6a 1d                	push   $0x1d
  10101b:	e8 b0 f8 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(30, trap_entry_30, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  101020:	83 c4 20             	add    $0x20,%esp
  101023:	68 ee 00 00 00       	push   $0xee
  101028:	6a 08                	push   $0x8
  10102a:	68 40 07 10 00       	push   $0x100740
  10102f:	6a 1e                	push   $0x1e
  101031:	e8 9a f8 ff ff       	call   1008d0 <set_idt_gate>
    set_idt_gate(31, trap_entry_31, 0x08, IDT_PRESENT | IDT_INT_GATE | IDT_RING3);
  101036:	68 ee 00 00 00       	push   $0xee
  10103b:	6a 08                	push   $0x8
  10103d:	68 49 07 10 00       	push   $0x100749
  101042:	6a 1f                	push   $0x1f
  101044:	e8 87 f8 ff ff       	call   1008d0 <set_idt_gate>

    idt_load();
  101049:	83 c4 20             	add    $0x20,%esp
  10104c:	e8 ba f8 ff ff       	call   10090b <idt_load>
}
  101051:	c9                   	leave
  101052:	c3                   	ret

00101053 <trap_init>:

void trap_init()
{
  101053:	55                   	push   %ebp
  101054:	89 e5                	mov    %esp,%ebp
  101056:	83 ec 08             	sub    $0x8,%esp
    idt_init();
  101059:	e8 2e fd ff ff       	call   100d8c <idt_init>

    asm volatile("sti");
  10105e:	fb                   	sti
}
  10105f:	c9                   	leave
  101060:	c3                   	ret

00101061 <trap_handler>:

void trap_handler(struct trapframe *tf)
{
  101061:	55                   	push   %ebp
  101062:	89 e5                	mov    %esp,%ebp
  101064:	53                   	push   %ebx
  101065:	83 ec 04             	sub    $0x4,%esp
  101068:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (!tf)
  10106b:	85 db                	test   %ebx,%ebx
  10106d:	74 60                	je     1010cf <trap_handler+0x6e>
        return;

    switch(tf->trapno)
  10106f:	8b 43 30             	mov    0x30(%ebx),%eax
  101072:	83 f8 0e             	cmp    $0xe,%eax
  101075:	74 24                	je     10109b <trap_handler+0x3a>
  101077:	3d 80 00 00 00       	cmp    $0x80,%eax
  10107c:	74 45                	je     1010c3 <trap_handler+0x62>
  10107e:	83 f8 0d             	cmp    $0xd,%eax
  101081:	74 28                	je     1010ab <trap_handler+0x4a>
            return;
        default:
            break;
    }

    printf("CPU Exception %d occurred!\n", tf->trapno);
  101083:	83 ec 08             	sub    $0x8,%esp
  101086:	50                   	push   %eax
  101087:	68 69 20 10 00       	push   $0x102069
  10108c:	e8 a6 f3 ff ff       	call   100437 <printf>
    shutdown();
  101091:	e8 3b fc ff ff       	call   100cd1 <shutdown>

    return;
  101096:	83 c4 10             	add    $0x10,%esp
  101099:	eb 34                	jmp    1010cf <trap_handler+0x6e>
            page_not_found_handler(tf->err);
  10109b:	83 ec 0c             	sub    $0xc,%esp
  10109e:	ff 73 34             	push   0x34(%ebx)
  1010a1:	e8 b3 fb ff ff       	call   100c59 <page_not_found_handler>
            return;
  1010a6:	83 c4 10             	add    $0x10,%esp
  1010a9:	eb 24                	jmp    1010cf <trap_handler+0x6e>
            printf("General Protection Fault at EIP: 0x%x\n", tf->eip);
  1010ab:	83 ec 08             	sub    $0x8,%esp
  1010ae:	ff 73 38             	push   0x38(%ebx)
  1010b1:	68 b0 21 10 00       	push   $0x1021b0
  1010b6:	e8 7c f3 ff ff       	call   100437 <printf>
            shutdown();
  1010bb:	e8 11 fc ff ff       	call   100cd1 <shutdown>
  1010c0:	83 c4 10             	add    $0x10,%esp
            syscall(tf);
  1010c3:	83 ec 0c             	sub    $0xc,%esp
  1010c6:	53                   	push   %ebx
  1010c7:	e8 6f fc ff ff       	call   100d3b <syscall>
            return;
  1010cc:	83 c4 10             	add    $0x10,%esp
}
  1010cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1010d2:	c9                   	leave
  1010d3:	c3                   	ret

001010d4 <user_app_load>:

int user_app_load(uint32 *info)
{
  1010d4:	55                   	push   %ebp
  1010d5:	89 e5                	mov    %esp,%ebp
  1010d7:	56                   	push   %esi
  1010d8:	53                   	push   %ebx
  1010d9:	8b 45 08             	mov    0x8(%ebp),%eax
    uint32 start = info[1];
  1010dc:	8b 70 04             	mov    0x4(%eax),%esi
    uint32 end = info[2];
    uint32 length = end - start;
  1010df:	8b 58 08             	mov    0x8(%eax),%ebx
  1010e2:	29 f3                	sub    %esi,%ebx

    memset((void *)BASE_ADDRESS, 0, length);
  1010e4:	83 ec 04             	sub    $0x4,%esp
  1010e7:	53                   	push   %ebx
  1010e8:	6a 00                	push   $0x0
  1010ea:	68 00 00 30 00       	push   $0x300000
  1010ef:	e8 b6 f3 ff ff       	call   1004aa <memset>
    memmove((void *)BASE_ADDRESS, (void *)start, length);
  1010f4:	83 c4 0c             	add    $0xc,%esp
  1010f7:	53                   	push   %ebx
  1010f8:	56                   	push   %esi
  1010f9:	68 00 00 30 00       	push   $0x300000
  1010fe:	e8 06 f4 ff ff       	call   100509 <memmove>

    return (int)length;
}
  101103:	89 d8                	mov    %ebx,%eax
  101105:	8d 65 f8             	lea    -0x8(%ebp),%esp
  101108:	5b                   	pop    %ebx
  101109:	5e                   	pop    %esi
  10110a:	5d                   	pop    %ebp
  10110b:	c3                   	ret

0010110c <user_app_run>:

void user_app_run(void)
{
  10110c:	55                   	push   %ebp
  10110d:	89 e5                	mov    %esp,%ebp
  10110f:	83 ec 14             	sub    $0x14,%esp
    user_app_load((uint32 *)_app_num);
  101112:	68 00 30 10 00       	push   $0x103000
  101117:	e8 b8 ff ff ff       	call   1010d4 <user_app_load>
    tss_set((uint32_t)boot_stack_top);
  10111c:	c7 04 24 00 40 11 00 	movl   $0x114000,(%esp)
  101123:	e8 9b f7 ff ff       	call   1008c3 <tss_set>
    user_enter(BASE_ADDRESS, (uint32_t)(user_stack_top + sizeof(user_stack_top)));
  101128:	83 c4 08             	add    $0x8,%esp
  10112b:	68 00 80 31 00       	push   $0x318000
  101130:	68 00 00 30 00       	push   $0x300000
  101135:	e8 24 f6 ff ff       	call   10075e <user_enter>
}
  10113a:	83 c4 10             	add    $0x10,%esp
  10113d:	c9                   	leave
  10113e:	c3                   	ret
