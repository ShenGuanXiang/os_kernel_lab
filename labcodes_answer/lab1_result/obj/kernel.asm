
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 80 fd 10 00       	mov    $0x10fd80,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	89 d1                	mov    %edx,%ecx
  100012:	29 c1                	sub    %eax,%ecx
  100014:	89 c8                	mov    %ecx,%eax
  100016:	89 44 24 08          	mov    %eax,0x8(%esp)
  10001a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100021:	00 
  100022:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100029:	e8 27 2e 00 00       	call   102e55 <memset>

    cons_init();                // init the console
  10002e:	e8 0e 16 00 00       	call   101641 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100033:	c7 45 f4 e0 36 10 00 	movl   $0x1036e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10003a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100041:	c7 04 24 fc 36 10 00 	movl   $0x1036fc,(%esp)
  100048:	e8 21 02 00 00       	call   10026e <cprintf>

    print_kerninfo();
  10004d:	e8 e5 08 00 00       	call   100937 <print_kerninfo>

    grade_backtrace();
  100052:	e8 8b 00 00 00       	call   1000e2 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100057:	e8 b0 2a 00 00       	call   102b0c <pmm_init>

    pic_init();                 // init interrupt controller
  10005c:	e8 1d 17 00 00       	call   10177e <pic_init>
    idt_init();                 // init interrupt descriptor table
  100061:	e8 7b 18 00 00       	call   1018e1 <idt_init>

    clock_init();               // init clock interrupt
  100066:	e8 2b 0d 00 00       	call   100d96 <clock_init>
    intr_enable();              // enable irq interrupt
  10006b:	e8 49 18 00 00       	call   1018b9 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100070:	e8 6d 01 00 00       	call   1001e2 <lab1_switch_test>

    /* do nothing */
    while (1);
  100075:	eb fe                	jmp    100075 <kern_init+0x75>

00100077 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100077:	55                   	push   %ebp
  100078:	89 e5                	mov    %esp,%ebp
  10007a:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100084:	00 
  100085:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008c:	00 
  10008d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100094:	e8 eb 0c 00 00       	call   100d84 <mon_backtrace>
}
  100099:	c9                   	leave  
  10009a:	c3                   	ret    

0010009b <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10009b:	55                   	push   %ebp
  10009c:	89 e5                	mov    %esp,%ebp
  10009e:	53                   	push   %ebx
  10009f:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a8:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ae:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000b6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000ba:	89 04 24             	mov    %eax,(%esp)
  1000bd:	e8 b5 ff ff ff       	call   100077 <grade_backtrace2>
}
  1000c2:	83 c4 14             	add    $0x14,%esp
  1000c5:	5b                   	pop    %ebx
  1000c6:	5d                   	pop    %ebp
  1000c7:	c3                   	ret    

001000c8 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c8:	55                   	push   %ebp
  1000c9:	89 e5                	mov    %esp,%ebp
  1000cb:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1000d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d8:	89 04 24             	mov    %eax,(%esp)
  1000db:	e8 bb ff ff ff       	call   10009b <grade_backtrace1>
}
  1000e0:	c9                   	leave  
  1000e1:	c3                   	ret    

001000e2 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e2:	55                   	push   %ebp
  1000e3:	89 e5                	mov    %esp,%ebp
  1000e5:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e8:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000ed:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f4:	ff 
  1000f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100100:	e8 c3 ff ff ff       	call   1000c8 <grade_backtrace0>
}
  100105:	c9                   	leave  
  100106:	c3                   	ret    

00100107 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100107:	55                   	push   %ebp
  100108:	89 e5                	mov    %esp,%ebp
  10010a:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010d:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100110:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100113:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100116:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100119:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011d:	0f b7 c0             	movzwl %ax,%eax
  100120:	89 c2                	mov    %eax,%edx
  100122:	83 e2 03             	and    $0x3,%edx
  100125:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10012a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100132:	c7 04 24 01 37 10 00 	movl   $0x103701,(%esp)
  100139:	e8 30 01 00 00       	call   10026e <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100142:	0f b7 d0             	movzwl %ax,%edx
  100145:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10014a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100152:	c7 04 24 0f 37 10 00 	movl   $0x10370f,(%esp)
  100159:	e8 10 01 00 00       	call   10026e <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015e:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100162:	0f b7 d0             	movzwl %ax,%edx
  100165:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10016a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100172:	c7 04 24 1d 37 10 00 	movl   $0x10371d,(%esp)
  100179:	e8 f0 00 00 00       	call   10026e <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100182:	0f b7 d0             	movzwl %ax,%edx
  100185:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10018a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100192:	c7 04 24 2b 37 10 00 	movl   $0x10372b,(%esp)
  100199:	e8 d0 00 00 00       	call   10026e <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a2:	0f b7 d0             	movzwl %ax,%edx
  1001a5:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b2:	c7 04 24 39 37 10 00 	movl   $0x103739,(%esp)
  1001b9:	e8 b0 00 00 00       	call   10026e <cprintf>
    round ++;
  1001be:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001c3:	83 c0 01             	add    $0x1,%eax
  1001c6:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001cb:	c9                   	leave  
  1001cc:	c3                   	ret    

001001cd <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cd:	55                   	push   %ebp
  1001ce:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001d0:	83 ec 08             	sub    $0x8,%esp
  1001d3:	cd 78                	int    $0x78
  1001d5:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001d7:	5d                   	pop    %ebp
  1001d8:	c3                   	ret    

001001d9 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d9:	55                   	push   %ebp
  1001da:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001dc:	cd 79                	int    $0x79
  1001de:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001e0:	5d                   	pop    %ebp
  1001e1:	c3                   	ret    

001001e2 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001e2:	55                   	push   %ebp
  1001e3:	89 e5                	mov    %esp,%ebp
  1001e5:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001e8:	e8 1a ff ff ff       	call   100107 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001ed:	c7 04 24 48 37 10 00 	movl   $0x103748,(%esp)
  1001f4:	e8 75 00 00 00       	call   10026e <cprintf>
    lab1_switch_to_user();
  1001f9:	e8 cf ff ff ff       	call   1001cd <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fe:	e8 04 ff ff ff       	call   100107 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100203:	c7 04 24 68 37 10 00 	movl   $0x103768,(%esp)
  10020a:	e8 5f 00 00 00       	call   10026e <cprintf>
    lab1_switch_to_kernel();
  10020f:	e8 c5 ff ff ff       	call   1001d9 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100214:	e8 ee fe ff ff       	call   100107 <lab1_print_cur_status>
}
  100219:	c9                   	leave  
  10021a:	c3                   	ret    

0010021b <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10021b:	55                   	push   %ebp
  10021c:	89 e5                	mov    %esp,%ebp
  10021e:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100221:	8b 45 08             	mov    0x8(%ebp),%eax
  100224:	89 04 24             	mov    %eax,(%esp)
  100227:	e8 41 14 00 00       	call   10166d <cons_putc>
    (*cnt) ++;
  10022c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10022f:	8b 00                	mov    (%eax),%eax
  100231:	8d 50 01             	lea    0x1(%eax),%edx
  100234:	8b 45 0c             	mov    0xc(%ebp),%eax
  100237:	89 10                	mov    %edx,(%eax)
}
  100239:	c9                   	leave  
  10023a:	c3                   	ret    

0010023b <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10023b:	55                   	push   %ebp
  10023c:	89 e5                	mov    %esp,%ebp
  10023e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100241:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100248:	8b 45 0c             	mov    0xc(%ebp),%eax
  10024b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10024f:	8b 45 08             	mov    0x8(%ebp),%eax
  100252:	89 44 24 08          	mov    %eax,0x8(%esp)
  100256:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100259:	89 44 24 04          	mov    %eax,0x4(%esp)
  10025d:	c7 04 24 1b 02 10 00 	movl   $0x10021b,(%esp)
  100264:	e8 ab 2f 00 00       	call   103214 <vprintfmt>
    return cnt;
  100269:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10026c:	c9                   	leave  
  10026d:	c3                   	ret    

0010026e <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10026e:	55                   	push   %ebp
  10026f:	89 e5                	mov    %esp,%ebp
  100271:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100274:	8d 45 0c             	lea    0xc(%ebp),%eax
  100277:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10027a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10027d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100281:	8b 45 08             	mov    0x8(%ebp),%eax
  100284:	89 04 24             	mov    %eax,(%esp)
  100287:	e8 af ff ff ff       	call   10023b <vcprintf>
  10028c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10028f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100292:	c9                   	leave  
  100293:	c3                   	ret    

00100294 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100294:	55                   	push   %ebp
  100295:	89 e5                	mov    %esp,%ebp
  100297:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10029a:	8b 45 08             	mov    0x8(%ebp),%eax
  10029d:	89 04 24             	mov    %eax,(%esp)
  1002a0:	e8 c8 13 00 00       	call   10166d <cons_putc>
}
  1002a5:	c9                   	leave  
  1002a6:	c3                   	ret    

001002a7 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002a7:	55                   	push   %ebp
  1002a8:	89 e5                	mov    %esp,%ebp
  1002aa:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002b4:	eb 13                	jmp    1002c9 <cputs+0x22>
        cputch(c, &cnt);
  1002b6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002ba:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002bd:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002c1:	89 04 24             	mov    %eax,(%esp)
  1002c4:	e8 52 ff ff ff       	call   10021b <cputch>
    while ((c = *str ++) != '\0') {
  1002c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cc:	0f b6 00             	movzbl (%eax),%eax
  1002cf:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002d2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002d6:	0f 95 c0             	setne  %al
  1002d9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1002dd:	84 c0                	test   %al,%al
  1002df:	75 d5                	jne    1002b6 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002e8:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1002ef:	e8 27 ff ff ff       	call   10021b <cputch>
    return cnt;
  1002f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002f7:	c9                   	leave  
  1002f8:	c3                   	ret    

001002f9 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002f9:	55                   	push   %ebp
  1002fa:	89 e5                	mov    %esp,%ebp
  1002fc:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002ff:	e8 92 13 00 00       	call   101696 <cons_getc>
  100304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100307:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10030b:	74 f2                	je     1002ff <getchar+0x6>
        /* do nothing */;
    return c;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100318:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10031c:	74 13                	je     100331 <readline+0x1f>
        cprintf("%s", prompt);
  10031e:	8b 45 08             	mov    0x8(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	c7 04 24 87 37 10 00 	movl   $0x103787,(%esp)
  10032c:	e8 3d ff ff ff       	call   10026e <cprintf>
    }
    int i = 0, c;
  100331:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100338:	eb 01                	jmp    10033b <readline+0x29>
        else if (c == '\n' || c == '\r') {
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
  10033a:	90                   	nop
        c = getchar();
  10033b:	e8 b9 ff ff ff       	call   1002f9 <getchar>
  100340:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100343:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100347:	79 07                	jns    100350 <readline+0x3e>
            return NULL;
  100349:	b8 00 00 00 00       	mov    $0x0,%eax
  10034e:	eb 79                	jmp    1003c9 <readline+0xb7>
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100350:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100354:	7e 28                	jle    10037e <readline+0x6c>
  100356:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10035d:	7f 1f                	jg     10037e <readline+0x6c>
            cputchar(c);
  10035f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100362:	89 04 24             	mov    %eax,(%esp)
  100365:	e8 2a ff ff ff       	call   100294 <cputchar>
            buf[i ++] = c;
  10036a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10036d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100370:	81 c2 40 ea 10 00    	add    $0x10ea40,%edx
  100376:	88 02                	mov    %al,(%edx)
  100378:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10037c:	eb 46                	jmp    1003c4 <readline+0xb2>
        else if (c == '\b' && i > 0) {
  10037e:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100382:	75 17                	jne    10039b <readline+0x89>
  100384:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100388:	7e 11                	jle    10039b <readline+0x89>
            cputchar(c);
  10038a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10038d:	89 04 24             	mov    %eax,(%esp)
  100390:	e8 ff fe ff ff       	call   100294 <cputchar>
            i --;
  100395:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100399:	eb 29                	jmp    1003c4 <readline+0xb2>
        else if (c == '\n' || c == '\r') {
  10039b:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10039f:	74 06                	je     1003a7 <readline+0x95>
  1003a1:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003a5:	75 93                	jne    10033a <readline+0x28>
            cputchar(c);
  1003a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003aa:	89 04 24             	mov    %eax,(%esp)
  1003ad:	e8 e2 fe ff ff       	call   100294 <cputchar>
            buf[i] = '\0';
  1003b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003b5:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003ba:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003bd:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003c2:	eb 05                	jmp    1003c9 <readline+0xb7>
    }
  1003c4:	e9 71 ff ff ff       	jmp    10033a <readline+0x28>
}
  1003c9:	c9                   	leave  
  1003ca:	c3                   	ret    

001003cb <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003cb:	55                   	push   %ebp
  1003cc:	89 e5                	mov    %esp,%ebp
  1003ce:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003d1:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003d6:	85 c0                	test   %eax,%eax
  1003d8:	75 5b                	jne    100435 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  1003da:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003e1:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003e4:	8d 45 14             	lea    0x14(%ebp),%eax
  1003e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  1003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1003f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003f8:	c7 04 24 8a 37 10 00 	movl   $0x10378a,(%esp)
  1003ff:	e8 6a fe ff ff       	call   10026e <cprintf>
    vcprintf(fmt, ap);
  100404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100407:	89 44 24 04          	mov    %eax,0x4(%esp)
  10040b:	8b 45 10             	mov    0x10(%ebp),%eax
  10040e:	89 04 24             	mov    %eax,(%esp)
  100411:	e8 25 fe ff ff       	call   10023b <vcprintf>
    cprintf("\n");
  100416:	c7 04 24 a6 37 10 00 	movl   $0x1037a6,(%esp)
  10041d:	e8 4c fe ff ff       	call   10026e <cprintf>
    
    cprintf("stack trackback:\n");
  100422:	c7 04 24 a8 37 10 00 	movl   $0x1037a8,(%esp)
  100429:	e8 40 fe ff ff       	call   10026e <cprintf>
    print_stackframe();
  10042e:	e8 55 06 00 00       	call   100a88 <print_stackframe>
  100433:	eb 01                	jmp    100436 <__panic+0x6b>
        goto panic_dead;
  100435:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100436:	e8 84 14 00 00       	call   1018bf <intr_disable>
    while (1) {
        kmonitor(NULL);
  10043b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100442:	e8 6e 08 00 00       	call   100cb5 <kmonitor>
    }
  100447:	eb f2                	jmp    10043b <__panic+0x70>

00100449 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100449:	55                   	push   %ebp
  10044a:	89 e5                	mov    %esp,%ebp
  10044c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10044f:	8d 45 14             	lea    0x14(%ebp),%eax
  100452:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100455:	8b 45 0c             	mov    0xc(%ebp),%eax
  100458:	89 44 24 08          	mov    %eax,0x8(%esp)
  10045c:	8b 45 08             	mov    0x8(%ebp),%eax
  10045f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100463:	c7 04 24 ba 37 10 00 	movl   $0x1037ba,(%esp)
  10046a:	e8 ff fd ff ff       	call   10026e <cprintf>
    vcprintf(fmt, ap);
  10046f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100472:	89 44 24 04          	mov    %eax,0x4(%esp)
  100476:	8b 45 10             	mov    0x10(%ebp),%eax
  100479:	89 04 24             	mov    %eax,(%esp)
  10047c:	e8 ba fd ff ff       	call   10023b <vcprintf>
    cprintf("\n");
  100481:	c7 04 24 a6 37 10 00 	movl   $0x1037a6,(%esp)
  100488:	e8 e1 fd ff ff       	call   10026e <cprintf>
    va_end(ap);
}
  10048d:	c9                   	leave  
  10048e:	c3                   	ret    

0010048f <is_kernel_panic>:

bool
is_kernel_panic(void) {
  10048f:	55                   	push   %ebp
  100490:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100492:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100497:	5d                   	pop    %ebp
  100498:	c3                   	ret    

00100499 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100499:	55                   	push   %ebp
  10049a:	89 e5                	mov    %esp,%ebp
  10049c:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  10049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a2:	8b 00                	mov    (%eax),%eax
  1004a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004a7:	8b 45 10             	mov    0x10(%ebp),%eax
  1004aa:	8b 00                	mov    (%eax),%eax
  1004ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004b6:	e9 d2 00 00 00       	jmp    10058d <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004c1:	01 d0                	add    %edx,%eax
  1004c3:	89 c2                	mov    %eax,%edx
  1004c5:	c1 ea 1f             	shr    $0x1f,%edx
  1004c8:	01 d0                	add    %edx,%eax
  1004ca:	d1 f8                	sar    %eax
  1004cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004d2:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004d5:	eb 04                	jmp    1004db <stab_binsearch+0x42>
            m --;
  1004d7:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004e1:	7c 1f                	jl     100502 <stab_binsearch+0x69>
  1004e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004e6:	89 d0                	mov    %edx,%eax
  1004e8:	01 c0                	add    %eax,%eax
  1004ea:	01 d0                	add    %edx,%eax
  1004ec:	c1 e0 02             	shl    $0x2,%eax
  1004ef:	89 c2                	mov    %eax,%edx
  1004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f4:	01 d0                	add    %edx,%eax
  1004f6:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004fa:	0f b6 c0             	movzbl %al,%eax
  1004fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  100500:	75 d5                	jne    1004d7 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 0b                	jge    100515 <stab_binsearch+0x7c>
            l = true_m + 1;
  10050a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10050d:	83 c0 01             	add    $0x1,%eax
  100510:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100513:	eb 78                	jmp    10058d <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100515:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10051c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10051f:	89 d0                	mov    %edx,%eax
  100521:	01 c0                	add    %eax,%eax
  100523:	01 d0                	add    %edx,%eax
  100525:	c1 e0 02             	shl    $0x2,%eax
  100528:	89 c2                	mov    %eax,%edx
  10052a:	8b 45 08             	mov    0x8(%ebp),%eax
  10052d:	01 d0                	add    %edx,%eax
  10052f:	8b 40 08             	mov    0x8(%eax),%eax
  100532:	3b 45 18             	cmp    0x18(%ebp),%eax
  100535:	73 13                	jae    10054a <stab_binsearch+0xb1>
            *region_left = m;
  100537:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10053d:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10053f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100542:	83 c0 01             	add    $0x1,%eax
  100545:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100548:	eb 43                	jmp    10058d <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10054a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10054d:	89 d0                	mov    %edx,%eax
  10054f:	01 c0                	add    %eax,%eax
  100551:	01 d0                	add    %edx,%eax
  100553:	c1 e0 02             	shl    $0x2,%eax
  100556:	89 c2                	mov    %eax,%edx
  100558:	8b 45 08             	mov    0x8(%ebp),%eax
  10055b:	01 d0                	add    %edx,%eax
  10055d:	8b 40 08             	mov    0x8(%eax),%eax
  100560:	3b 45 18             	cmp    0x18(%ebp),%eax
  100563:	76 16                	jbe    10057b <stab_binsearch+0xe2>
            *region_right = m - 1;
  100565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100568:	8d 50 ff             	lea    -0x1(%eax),%edx
  10056b:	8b 45 10             	mov    0x10(%ebp),%eax
  10056e:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100573:	83 e8 01             	sub    $0x1,%eax
  100576:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100579:	eb 12                	jmp    10058d <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10057b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100581:	89 10                	mov    %edx,(%eax)
            l = m;
  100583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100586:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100589:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  10058d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100590:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100593:	0f 8e 22 ff ff ff    	jle    1004bb <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  100599:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10059d:	75 0f                	jne    1005ae <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  10059f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a2:	8b 00                	mov    (%eax),%eax
  1005a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005a7:	8b 45 10             	mov    0x10(%ebp),%eax
  1005aa:	89 10                	mov    %edx,(%eax)
  1005ac:	eb 3f                	jmp    1005ed <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005ae:	8b 45 10             	mov    0x10(%ebp),%eax
  1005b1:	8b 00                	mov    (%eax),%eax
  1005b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005b6:	eb 04                	jmp    1005bc <stab_binsearch+0x123>
  1005b8:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005bf:	8b 00                	mov    (%eax),%eax
  1005c1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005c4:	7d 1f                	jge    1005e5 <stab_binsearch+0x14c>
  1005c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005c9:	89 d0                	mov    %edx,%eax
  1005cb:	01 c0                	add    %eax,%eax
  1005cd:	01 d0                	add    %edx,%eax
  1005cf:	c1 e0 02             	shl    $0x2,%eax
  1005d2:	89 c2                	mov    %eax,%edx
  1005d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d7:	01 d0                	add    %edx,%eax
  1005d9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005dd:	0f b6 c0             	movzbl %al,%eax
  1005e0:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005e3:	75 d3                	jne    1005b8 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005eb:	89 10                	mov    %edx,(%eax)
    }
}
  1005ed:	c9                   	leave  
  1005ee:	c3                   	ret    

001005ef <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005ef:	55                   	push   %ebp
  1005f0:	89 e5                	mov    %esp,%ebp
  1005f2:	53                   	push   %ebx
  1005f3:	83 ec 54             	sub    $0x54,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f9:	c7 00 d8 37 10 00    	movl   $0x1037d8,(%eax)
    info->eip_line = 0;
  1005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100602:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100609:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060c:	c7 40 08 d8 37 10 00 	movl   $0x1037d8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100613:	8b 45 0c             	mov    0xc(%ebp),%eax
  100616:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10061d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100620:	8b 55 08             	mov    0x8(%ebp),%edx
  100623:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100626:	8b 45 0c             	mov    0xc(%ebp),%eax
  100629:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100630:	c7 45 f4 ec 3f 10 00 	movl   $0x103fec,-0xc(%ebp)
    stab_end = __STAB_END__;
  100637:	c7 45 f0 ac b8 10 00 	movl   $0x10b8ac,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10063e:	c7 45 ec ad b8 10 00 	movl   $0x10b8ad,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100645:	c7 45 e8 84 d8 10 00 	movl   $0x10d884,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10064c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10064f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100652:	76 0d                	jbe    100661 <debuginfo_eip+0x72>
  100654:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100657:	83 e8 01             	sub    $0x1,%eax
  10065a:	0f b6 00             	movzbl (%eax),%eax
  10065d:	84 c0                	test   %al,%al
  10065f:	74 0a                	je     10066b <debuginfo_eip+0x7c>
        return -1;
  100661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100666:	e9 c6 02 00 00       	jmp    100931 <debuginfo_eip+0x342>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10066b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100672:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100678:	89 d1                	mov    %edx,%ecx
  10067a:	29 c1                	sub    %eax,%ecx
  10067c:	89 c8                	mov    %ecx,%eax
  10067e:	c1 f8 02             	sar    $0x2,%eax
  100681:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100687:	83 e8 01             	sub    $0x1,%eax
  10068a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10068d:	8b 45 08             	mov    0x8(%ebp),%eax
  100690:	89 44 24 10          	mov    %eax,0x10(%esp)
  100694:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  10069b:	00 
  10069c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10069f:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006a3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ad:	89 04 24             	mov    %eax,(%esp)
  1006b0:	e8 e4 fd ff ff       	call   100499 <stab_binsearch>
    if (lfile == 0)
  1006b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b8:	85 c0                	test   %eax,%eax
  1006ba:	75 0a                	jne    1006c6 <debuginfo_eip+0xd7>
        return -1;
  1006bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006c1:	e9 6b 02 00 00       	jmp    100931 <debuginfo_eip+0x342>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 9f fd ff ff       	call   100499 <stab_binsearch>

    if (lfun <= rfun) {
  1006fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 7e                	jg     100782 <debuginfo_eip+0x193>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100704:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	8b 10                	mov    (%eax),%edx
  10071b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10071e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100721:	89 cb                	mov    %ecx,%ebx
  100723:	29 c3                	sub    %eax,%ebx
  100725:	89 d8                	mov    %ebx,%eax
  100727:	39 c2                	cmp    %eax,%edx
  100729:	73 22                	jae    10074d <debuginfo_eip+0x15e>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10072b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10072e:	89 c2                	mov    %eax,%edx
  100730:	89 d0                	mov    %edx,%eax
  100732:	01 c0                	add    %eax,%eax
  100734:	01 d0                	add    %edx,%eax
  100736:	c1 e0 02             	shl    $0x2,%eax
  100739:	89 c2                	mov    %eax,%edx
  10073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10073e:	01 d0                	add    %edx,%eax
  100740:	8b 10                	mov    (%eax),%edx
  100742:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100745:	01 c2                	add    %eax,%edx
  100747:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074a:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10074d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100750:	89 c2                	mov    %eax,%edx
  100752:	89 d0                	mov    %edx,%eax
  100754:	01 c0                	add    %eax,%eax
  100756:	01 d0                	add    %edx,%eax
  100758:	c1 e0 02             	shl    $0x2,%eax
  10075b:	89 c2                	mov    %eax,%edx
  10075d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100760:	01 d0                	add    %edx,%eax
  100762:	8b 50 08             	mov    0x8(%eax),%edx
  100765:	8b 45 0c             	mov    0xc(%ebp),%eax
  100768:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10076b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076e:	8b 40 10             	mov    0x10(%eax),%eax
  100771:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100774:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100777:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10077a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10077d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100780:	eb 15                	jmp    100797 <debuginfo_eip+0x1a8>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100782:	8b 45 0c             	mov    0xc(%ebp),%eax
  100785:	8b 55 08             	mov    0x8(%ebp),%edx
  100788:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10078b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10078e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100791:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100794:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100797:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079a:	8b 40 08             	mov    0x8(%eax),%eax
  10079d:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007a4:	00 
  1007a5:	89 04 24             	mov    %eax,(%esp)
  1007a8:	e8 1c 25 00 00       	call   102cc9 <strfind>
  1007ad:	89 c2                	mov    %eax,%edx
  1007af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b2:	8b 40 08             	mov    0x8(%eax),%eax
  1007b5:	29 c2                	sub    %eax,%edx
  1007b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ba:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1007c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007c4:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007cb:	00 
  1007cc:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007d3:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	89 04 24             	mov    %eax,(%esp)
  1007e0:	e8 b4 fc ff ff       	call   100499 <stab_binsearch>
    if (lline <= rline) {
  1007e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007eb:	39 c2                	cmp    %eax,%edx
  1007ed:	7f 24                	jg     100813 <debuginfo_eip+0x224>
        info->eip_line = stabs[rline].n_desc;
  1007ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007f2:	89 c2                	mov    %eax,%edx
  1007f4:	89 d0                	mov    %edx,%eax
  1007f6:	01 c0                	add    %eax,%eax
  1007f8:	01 d0                	add    %edx,%eax
  1007fa:	c1 e0 02             	shl    $0x2,%eax
  1007fd:	89 c2                	mov    %eax,%edx
  1007ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100802:	01 d0                	add    %edx,%eax
  100804:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100808:	0f b7 d0             	movzwl %ax,%edx
  10080b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100811:	eb 13                	jmp    100826 <debuginfo_eip+0x237>
        return -1;
  100813:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100818:	e9 14 01 00 00       	jmp    100931 <debuginfo_eip+0x342>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10081d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100820:	83 e8 01             	sub    $0x1,%eax
  100823:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100826:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10082c:	39 c2                	cmp    %eax,%edx
  10082e:	7c 56                	jl     100886 <debuginfo_eip+0x297>
           && stabs[lline].n_type != N_SOL
  100830:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100833:	89 c2                	mov    %eax,%edx
  100835:	89 d0                	mov    %edx,%eax
  100837:	01 c0                	add    %eax,%eax
  100839:	01 d0                	add    %edx,%eax
  10083b:	c1 e0 02             	shl    $0x2,%eax
  10083e:	89 c2                	mov    %eax,%edx
  100840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100843:	01 d0                	add    %edx,%eax
  100845:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100849:	3c 84                	cmp    $0x84,%al
  10084b:	74 39                	je     100886 <debuginfo_eip+0x297>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100850:	89 c2                	mov    %eax,%edx
  100852:	89 d0                	mov    %edx,%eax
  100854:	01 c0                	add    %eax,%eax
  100856:	01 d0                	add    %edx,%eax
  100858:	c1 e0 02             	shl    $0x2,%eax
  10085b:	89 c2                	mov    %eax,%edx
  10085d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100860:	01 d0                	add    %edx,%eax
  100862:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100866:	3c 64                	cmp    $0x64,%al
  100868:	75 b3                	jne    10081d <debuginfo_eip+0x22e>
  10086a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10086d:	89 c2                	mov    %eax,%edx
  10086f:	89 d0                	mov    %edx,%eax
  100871:	01 c0                	add    %eax,%eax
  100873:	01 d0                	add    %edx,%eax
  100875:	c1 e0 02             	shl    $0x2,%eax
  100878:	89 c2                	mov    %eax,%edx
  10087a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10087d:	01 d0                	add    %edx,%eax
  10087f:	8b 40 08             	mov    0x8(%eax),%eax
  100882:	85 c0                	test   %eax,%eax
  100884:	74 97                	je     10081d <debuginfo_eip+0x22e>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100886:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10088c:	39 c2                	cmp    %eax,%edx
  10088e:	7c 48                	jl     1008d8 <debuginfo_eip+0x2e9>
  100890:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100893:	89 c2                	mov    %eax,%edx
  100895:	89 d0                	mov    %edx,%eax
  100897:	01 c0                	add    %eax,%eax
  100899:	01 d0                	add    %edx,%eax
  10089b:	c1 e0 02             	shl    $0x2,%eax
  10089e:	89 c2                	mov    %eax,%edx
  1008a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a3:	01 d0                	add    %edx,%eax
  1008a5:	8b 10                	mov    (%eax),%edx
  1008a7:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1008aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008ad:	89 cb                	mov    %ecx,%ebx
  1008af:	29 c3                	sub    %eax,%ebx
  1008b1:	89 d8                	mov    %ebx,%eax
  1008b3:	39 c2                	cmp    %eax,%edx
  1008b5:	73 21                	jae    1008d8 <debuginfo_eip+0x2e9>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008ba:	89 c2                	mov    %eax,%edx
  1008bc:	89 d0                	mov    %edx,%eax
  1008be:	01 c0                	add    %eax,%eax
  1008c0:	01 d0                	add    %edx,%eax
  1008c2:	c1 e0 02             	shl    $0x2,%eax
  1008c5:	89 c2                	mov    %eax,%edx
  1008c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ca:	01 d0                	add    %edx,%eax
  1008cc:	8b 10                	mov    (%eax),%edx
  1008ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008d1:	01 c2                	add    %eax,%edx
  1008d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d6:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008de:	39 c2                	cmp    %eax,%edx
  1008e0:	7d 4a                	jge    10092c <debuginfo_eip+0x33d>
        for (lline = lfun + 1;
  1008e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008e5:	83 c0 01             	add    $0x1,%eax
  1008e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008eb:	eb 18                	jmp    100905 <debuginfo_eip+0x316>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f0:	8b 40 14             	mov    0x14(%eax),%eax
  1008f3:	8d 50 01             	lea    0x1(%eax),%edx
  1008f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f9:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008ff:	83 c0 01             	add    $0x1,%eax
  100902:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100905:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100908:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10090b:	39 c2                	cmp    %eax,%edx
  10090d:	7d 1d                	jge    10092c <debuginfo_eip+0x33d>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10090f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100912:	89 c2                	mov    %eax,%edx
  100914:	89 d0                	mov    %edx,%eax
  100916:	01 c0                	add    %eax,%eax
  100918:	01 d0                	add    %edx,%eax
  10091a:	c1 e0 02             	shl    $0x2,%eax
  10091d:	89 c2                	mov    %eax,%edx
  10091f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100922:	01 d0                	add    %edx,%eax
  100924:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100928:	3c a0                	cmp    $0xa0,%al
  10092a:	74 c1                	je     1008ed <debuginfo_eip+0x2fe>
        }
    }
    return 0;
  10092c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100931:	83 c4 54             	add    $0x54,%esp
  100934:	5b                   	pop    %ebx
  100935:	5d                   	pop    %ebp
  100936:	c3                   	ret    

00100937 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100937:	55                   	push   %ebp
  100938:	89 e5                	mov    %esp,%ebp
  10093a:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10093d:	c7 04 24 e2 37 10 00 	movl   $0x1037e2,(%esp)
  100944:	e8 25 f9 ff ff       	call   10026e <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100949:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100950:	00 
  100951:	c7 04 24 fb 37 10 00 	movl   $0x1037fb,(%esp)
  100958:	e8 11 f9 ff ff       	call   10026e <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10095d:	c7 44 24 04 d6 36 10 	movl   $0x1036d6,0x4(%esp)
  100964:	00 
  100965:	c7 04 24 13 38 10 00 	movl   $0x103813,(%esp)
  10096c:	e8 fd f8 ff ff       	call   10026e <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100971:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100978:	00 
  100979:	c7 04 24 2b 38 10 00 	movl   $0x10382b,(%esp)
  100980:	e8 e9 f8 ff ff       	call   10026e <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100985:	c7 44 24 04 80 fd 10 	movl   $0x10fd80,0x4(%esp)
  10098c:	00 
  10098d:	c7 04 24 43 38 10 00 	movl   $0x103843,(%esp)
  100994:	e8 d5 f8 ff ff       	call   10026e <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100999:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  10099e:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009a4:	b8 00 00 10 00       	mov    $0x100000,%eax
  1009a9:	89 d1                	mov    %edx,%ecx
  1009ab:	29 c1                	sub    %eax,%ecx
  1009ad:	89 c8                	mov    %ecx,%eax
  1009af:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009b5:	85 c0                	test   %eax,%eax
  1009b7:	0f 48 c2             	cmovs  %edx,%eax
  1009ba:	c1 f8 0a             	sar    $0xa,%eax
  1009bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c1:	c7 04 24 5c 38 10 00 	movl   $0x10385c,(%esp)
  1009c8:	e8 a1 f8 ff ff       	call   10026e <cprintf>
}
  1009cd:	c9                   	leave  
  1009ce:	c3                   	ret    

001009cf <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009cf:	55                   	push   %ebp
  1009d0:	89 e5                	mov    %esp,%ebp
  1009d2:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009d8:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009df:	8b 45 08             	mov    0x8(%ebp),%eax
  1009e2:	89 04 24             	mov    %eax,(%esp)
  1009e5:	e8 05 fc ff ff       	call   1005ef <debuginfo_eip>
  1009ea:	85 c0                	test   %eax,%eax
  1009ec:	74 15                	je     100a03 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1009f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f5:	c7 04 24 86 38 10 00 	movl   $0x103886,(%esp)
  1009fc:	e8 6d f8 ff ff       	call   10026e <cprintf>
  100a01:	eb 6d                	jmp    100a70 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a0a:	eb 1c                	jmp    100a28 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100a0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a12:	01 d0                	add    %edx,%eax
  100a14:	0f b6 00             	movzbl (%eax),%eax
  100a17:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a20:	01 ca                	add    %ecx,%edx
  100a22:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a24:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100a28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a2b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100a2e:	7f dc                	jg     100a0c <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
  100a30:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a39:	01 d0                	add    %edx,%eax
  100a3b:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a41:	8b 55 08             	mov    0x8(%ebp),%edx
  100a44:	89 d1                	mov    %edx,%ecx
  100a46:	29 c1                	sub    %eax,%ecx
  100a48:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a4e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
                fnname, eip - info.eip_fn_addr);
  100a52:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a58:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a5c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a60:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a64:	c7 04 24 a2 38 10 00 	movl   $0x1038a2,(%esp)
  100a6b:	e8 fe f7 ff ff       	call   10026e <cprintf>
    }
}
  100a70:	c9                   	leave  
  100a71:	c3                   	ret    

00100a72 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a72:	55                   	push   %ebp
  100a73:	89 e5                	mov    %esp,%ebp
  100a75:	53                   	push   %ebx
  100a76:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a79:	8b 5d 04             	mov    0x4(%ebp),%ebx
  100a7c:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    return eip;
  100a7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  100a82:	83 c4 10             	add    $0x10,%esp
  100a85:	5b                   	pop    %ebx
  100a86:	5d                   	pop    %ebp
  100a87:	c3                   	ret    

00100a88 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a88:	55                   	push   %ebp
  100a89:	89 e5                	mov    %esp,%ebp
  100a8b:	53                   	push   %ebx
  100a8c:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a8f:	89 eb                	mov    %ebp,%ebx
  100a91:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    return ebp;
  100a94:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  100a97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a9a:	e8 d3 ff ff ff       	call   100a72 <read_eip>
  100a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100aa2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100aa9:	e9 88 00 00 00       	jmp    100b36 <print_stackframe+0xae>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ab1:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100abc:	c7 04 24 b4 38 10 00 	movl   $0x1038b4,(%esp)
  100ac3:	e8 a6 f7 ff ff       	call   10026e <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100acb:	83 c0 08             	add    $0x8,%eax
  100ace:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100ad1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100ad8:	eb 25                	jmp    100aff <print_stackframe+0x77>
            cprintf("0x%08x ", args[j]);
  100ada:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100add:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ae4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100ae7:	01 d0                	add    %edx,%eax
  100ae9:	8b 00                	mov    (%eax),%eax
  100aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aef:	c7 04 24 d0 38 10 00 	movl   $0x1038d0,(%esp)
  100af6:	e8 73 f7 ff ff       	call   10026e <cprintf>
        for (j = 0; j < 4; j ++) {
  100afb:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100aff:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b03:	7e d5                	jle    100ada <print_stackframe+0x52>
        }
        cprintf("\n");
  100b05:	c7 04 24 d8 38 10 00 	movl   $0x1038d8,(%esp)
  100b0c:	e8 5d f7 ff ff       	call   10026e <cprintf>
        print_debuginfo(eip - 1);
  100b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b14:	83 e8 01             	sub    $0x1,%eax
  100b17:	89 04 24             	mov    %eax,(%esp)
  100b1a:	e8 b0 fe ff ff       	call   1009cf <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b22:	83 c0 04             	add    $0x4,%eax
  100b25:	8b 00                	mov    (%eax),%eax
  100b27:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b2d:	8b 00                	mov    (%eax),%eax
  100b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100b32:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100b36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b3a:	74 0a                	je     100b46 <print_stackframe+0xbe>
  100b3c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b40:	0f 8e 68 ff ff ff    	jle    100aae <print_stackframe+0x26>
    }
}
  100b46:	83 c4 34             	add    $0x34,%esp
  100b49:	5b                   	pop    %ebx
  100b4a:	5d                   	pop    %ebp
  100b4b:	c3                   	ret    

00100b4c <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b4c:	55                   	push   %ebp
  100b4d:	89 e5                	mov    %esp,%ebp
  100b4f:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b59:	eb 0d                	jmp    100b68 <parse+0x1c>
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
  100b5b:	90                   	nop
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b5c:	eb 0a                	jmp    100b68 <parse+0x1c>
            *buf ++ = '\0';
  100b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b61:	c6 00 00             	movb   $0x0,(%eax)
  100b64:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b68:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6b:	0f b6 00             	movzbl (%eax),%eax
  100b6e:	84 c0                	test   %al,%al
  100b70:	74 1d                	je     100b8f <parse+0x43>
  100b72:	8b 45 08             	mov    0x8(%ebp),%eax
  100b75:	0f b6 00             	movzbl (%eax),%eax
  100b78:	0f be c0             	movsbl %al,%eax
  100b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b7f:	c7 04 24 5c 39 10 00 	movl   $0x10395c,(%esp)
  100b86:	e8 0b 21 00 00       	call   102c96 <strchr>
  100b8b:	85 c0                	test   %eax,%eax
  100b8d:	75 cf                	jne    100b5e <parse+0x12>
        if (*buf == '\0') {
  100b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b92:	0f b6 00             	movzbl (%eax),%eax
  100b95:	84 c0                	test   %al,%al
  100b97:	74 64                	je     100bfd <parse+0xb1>
        if (argc == MAXARGS - 1) {
  100b99:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b9d:	75 14                	jne    100bb3 <parse+0x67>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b9f:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ba6:	00 
  100ba7:	c7 04 24 61 39 10 00 	movl   $0x103961,(%esp)
  100bae:	e8 bb f6 ff ff       	call   10026e <cprintf>
        argv[argc ++] = buf;
  100bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bb6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bc0:	01 c2                	add    %eax,%edx
  100bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc5:	89 02                	mov    %eax,(%edx)
  100bc7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bcb:	eb 04                	jmp    100bd1 <parse+0x85>
            buf ++;
  100bcd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd4:	0f b6 00             	movzbl (%eax),%eax
  100bd7:	84 c0                	test   %al,%al
  100bd9:	74 80                	je     100b5b <parse+0xf>
  100bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  100bde:	0f b6 00             	movzbl (%eax),%eax
  100be1:	0f be c0             	movsbl %al,%eax
  100be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100be8:	c7 04 24 5c 39 10 00 	movl   $0x10395c,(%esp)
  100bef:	e8 a2 20 00 00       	call   102c96 <strchr>
  100bf4:	85 c0                	test   %eax,%eax
  100bf6:	74 d5                	je     100bcd <parse+0x81>
    }
  100bf8:	e9 5e ff ff ff       	jmp    100b5b <parse+0xf>
            break;
  100bfd:	90                   	nop
    return argc;
  100bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c01:	c9                   	leave  
  100c02:	c3                   	ret    

00100c03 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c03:	55                   	push   %ebp
  100c04:	89 e5                	mov    %esp,%ebp
  100c06:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c09:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c10:	8b 45 08             	mov    0x8(%ebp),%eax
  100c13:	89 04 24             	mov    %eax,(%esp)
  100c16:	e8 31 ff ff ff       	call   100b4c <parse>
  100c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c22:	75 0a                	jne    100c2e <runcmd+0x2b>
        return 0;
  100c24:	b8 00 00 00 00       	mov    $0x0,%eax
  100c29:	e9 85 00 00 00       	jmp    100cb3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c35:	eb 5c                	jmp    100c93 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c37:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3d:	89 d0                	mov    %edx,%eax
  100c3f:	01 c0                	add    %eax,%eax
  100c41:	01 d0                	add    %edx,%eax
  100c43:	c1 e0 02             	shl    $0x2,%eax
  100c46:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c4b:	8b 00                	mov    (%eax),%eax
  100c4d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c51:	89 04 24             	mov    %eax,(%esp)
  100c54:	e8 98 1f 00 00       	call   102bf1 <strcmp>
  100c59:	85 c0                	test   %eax,%eax
  100c5b:	75 32                	jne    100c8f <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c60:	89 d0                	mov    %edx,%eax
  100c62:	01 c0                	add    %eax,%eax
  100c64:	01 d0                	add    %edx,%eax
  100c66:	c1 e0 02             	shl    $0x2,%eax
  100c69:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c6e:	8b 40 08             	mov    0x8(%eax),%eax
  100c71:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100c74:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100c77:	8b 55 0c             	mov    0xc(%ebp),%edx
  100c7a:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c7e:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100c81:	83 c2 04             	add    $0x4,%edx
  100c84:	89 54 24 04          	mov    %edx,0x4(%esp)
  100c88:	89 0c 24             	mov    %ecx,(%esp)
  100c8b:	ff d0                	call   *%eax
  100c8d:	eb 24                	jmp    100cb3 <runcmd+0xb0>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c96:	83 f8 02             	cmp    $0x2,%eax
  100c99:	76 9c                	jbe    100c37 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c9b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ca2:	c7 04 24 7f 39 10 00 	movl   $0x10397f,(%esp)
  100ca9:	e8 c0 f5 ff ff       	call   10026e <cprintf>
    return 0;
  100cae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb3:	c9                   	leave  
  100cb4:	c3                   	ret    

00100cb5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100cb5:	55                   	push   %ebp
  100cb6:	89 e5                	mov    %esp,%ebp
  100cb8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100cbb:	c7 04 24 98 39 10 00 	movl   $0x103998,(%esp)
  100cc2:	e8 a7 f5 ff ff       	call   10026e <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cc7:	c7 04 24 c0 39 10 00 	movl   $0x1039c0,(%esp)
  100cce:	e8 9b f5 ff ff       	call   10026e <cprintf>

    if (tf != NULL) {
  100cd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cd7:	74 0e                	je     100ce7 <kmonitor+0x32>
        print_trapframe(tf);
  100cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  100cdc:	89 04 24             	mov    %eax,(%esp)
  100cdf:	e8 b5 0d 00 00       	call   101a99 <print_trapframe>
  100ce4:	eb 01                	jmp    100ce7 <kmonitor+0x32>
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
            }
        }
    }
  100ce6:	90                   	nop
        if ((buf = readline("K> ")) != NULL) {
  100ce7:	c7 04 24 e5 39 10 00 	movl   $0x1039e5,(%esp)
  100cee:	e8 1f f6 ff ff       	call   100312 <readline>
  100cf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cf6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cfa:	74 ea                	je     100ce6 <kmonitor+0x31>
            if (runcmd(buf, tf) < 0) {
  100cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  100cff:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d06:	89 04 24             	mov    %eax,(%esp)
  100d09:	e8 f5 fe ff ff       	call   100c03 <runcmd>
  100d0e:	85 c0                	test   %eax,%eax
  100d10:	79 d4                	jns    100ce6 <kmonitor+0x31>
                break;
  100d12:	90                   	nop
}
  100d13:	c9                   	leave  
  100d14:	c3                   	ret    

00100d15 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d15:	55                   	push   %ebp
  100d16:	89 e5                	mov    %esp,%ebp
  100d18:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d22:	eb 3f                	jmp    100d63 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d27:	89 d0                	mov    %edx,%eax
  100d29:	01 c0                	add    %eax,%eax
  100d2b:	01 d0                	add    %edx,%eax
  100d2d:	c1 e0 02             	shl    $0x2,%eax
  100d30:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d35:	8b 48 04             	mov    0x4(%eax),%ecx
  100d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d3b:	89 d0                	mov    %edx,%eax
  100d3d:	01 c0                	add    %eax,%eax
  100d3f:	01 d0                	add    %edx,%eax
  100d41:	c1 e0 02             	shl    $0x2,%eax
  100d44:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d49:	8b 00                	mov    (%eax),%eax
  100d4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d53:	c7 04 24 e9 39 10 00 	movl   $0x1039e9,(%esp)
  100d5a:	e8 0f f5 ff ff       	call   10026e <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d5f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d66:	83 f8 02             	cmp    $0x2,%eax
  100d69:	76 b9                	jbe    100d24 <mon_help+0xf>
    }
    return 0;
  100d6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d70:	c9                   	leave  
  100d71:	c3                   	ret    

00100d72 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d72:	55                   	push   %ebp
  100d73:	89 e5                	mov    %esp,%ebp
  100d75:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d78:	e8 ba fb ff ff       	call   100937 <print_kerninfo>
    return 0;
  100d7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d82:	c9                   	leave  
  100d83:	c3                   	ret    

00100d84 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d84:	55                   	push   %ebp
  100d85:	89 e5                	mov    %esp,%ebp
  100d87:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d8a:	e8 f9 fc ff ff       	call   100a88 <print_stackframe>
    return 0;
  100d8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d94:	c9                   	leave  
  100d95:	c3                   	ret    

00100d96 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d96:	55                   	push   %ebp
  100d97:	89 e5                	mov    %esp,%ebp
  100d99:	83 ec 28             	sub    $0x28,%esp
  100d9c:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100da2:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100da6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100daa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dae:	ee                   	out    %al,(%dx)
  100daf:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100db5:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100db9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dbd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dc1:	ee                   	out    %al,(%dx)
  100dc2:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dc8:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dcc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dd0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dd4:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dd5:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100ddc:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100ddf:	c7 04 24 f2 39 10 00 	movl   $0x1039f2,(%esp)
  100de6:	e8 83 f4 ff ff       	call   10026e <cprintf>
    pic_enable(IRQ_TIMER);
  100deb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100df2:	e8 52 09 00 00       	call   101749 <pic_enable>
}
  100df7:	c9                   	leave  
  100df8:	c3                   	ret    

00100df9 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100df9:	55                   	push   %ebp
  100dfa:	89 e5                	mov    %esp,%ebp
  100dfc:	53                   	push   %ebx
  100dfd:	83 ec 14             	sub    $0x14,%esp
  100e00:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e06:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e0a:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e0e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e12:	ec                   	in     (%dx),%al
  100e13:	89 c3                	mov    %eax,%ebx
  100e15:	88 5d f9             	mov    %bl,-0x7(%ebp)
  100e18:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e1e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e22:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e26:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e2a:	ec                   	in     (%dx),%al
  100e2b:	89 c3                	mov    %eax,%ebx
  100e2d:	88 5d f5             	mov    %bl,-0xb(%ebp)
  100e30:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e36:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e3a:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e3e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e42:	ec                   	in     (%dx),%al
  100e43:	89 c3                	mov    %eax,%ebx
  100e45:	88 5d f1             	mov    %bl,-0xf(%ebp)
  100e48:	66 c7 45 ee 84 00    	movw   $0x84,-0x12(%ebp)
  100e4e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e52:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e56:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e5a:	ec                   	in     (%dx),%al
  100e5b:	89 c3                	mov    %eax,%ebx
  100e5d:	88 5d ed             	mov    %bl,-0x13(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e60:	83 c4 14             	add    $0x14,%esp
  100e63:	5b                   	pop    %ebx
  100e64:	5d                   	pop    %ebp
  100e65:	c3                   	ret    

00100e66 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e66:	55                   	push   %ebp
  100e67:	89 e5                	mov    %esp,%ebp
  100e69:	53                   	push   %ebx
  100e6a:	83 ec 24             	sub    $0x24,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100e6d:	c7 45 f8 00 80 0b 00 	movl   $0xb8000,-0x8(%ebp)
    uint16_t was = *cp;
  100e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100e77:	0f b7 00             	movzwl (%eax),%eax
  100e7a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100e81:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100e89:	0f b7 00             	movzwl (%eax),%eax
  100e8c:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e90:	74 12                	je     100ea4 <cga_init+0x3e>
        cp = (uint16_t*)MONO_BUF;
  100e92:	c7 45 f8 00 00 0b 00 	movl   $0xb0000,-0x8(%ebp)
        addr_6845 = MONO_BASE;
  100e99:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100ea0:	b4 03 
  100ea2:	eb 13                	jmp    100eb7 <cga_init+0x51>
    } else {
        *cp = was;
  100ea4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100ea7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100eab:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eae:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100eb5:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100eb7:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ebe:	0f b7 c0             	movzwl %ax,%eax
  100ec1:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ec5:	c6 45 ed 0e          	movb   $0xe,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ec9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ecd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ed1:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ed2:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ed9:	83 c0 01             	add    $0x1,%eax
  100edc:	0f b7 c0             	movzwl %ax,%eax
  100edf:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ee3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ee7:	66 89 55 da          	mov    %dx,-0x26(%ebp)
  100eeb:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100eef:	ec                   	in     (%dx),%al
  100ef0:	89 c3                	mov    %eax,%ebx
  100ef2:	88 5d e9             	mov    %bl,-0x17(%ebp)
    return data;
  100ef5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ef9:	0f b6 c0             	movzbl %al,%eax
  100efc:	c1 e0 08             	shl    $0x8,%eax
  100eff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    outb(addr_6845, 15);
  100f02:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100f09:	0f b7 c0             	movzwl %ax,%eax
  100f0c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f10:	c6 45 e5 0f          	movb   $0xf,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f14:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f18:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f1c:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f1d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100f24:	83 c0 01             	add    $0x1,%eax
  100f27:	0f b7 c0             	movzwl %ax,%eax
  100f2a:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f2e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f32:	66 89 55 da          	mov    %dx,-0x26(%ebp)
  100f36:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f3a:	ec                   	in     (%dx),%al
  100f3b:	89 c3                	mov    %eax,%ebx
  100f3d:	88 5d e1             	mov    %bl,-0x1f(%ebp)
    return data;
  100f40:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f44:	0f b6 c0             	movzbl %al,%eax
  100f47:	09 45 f0             	or     %eax,-0x10(%ebp)

    crt_buf = (uint16_t*) cp;
  100f4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100f4d:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;
  100f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100f55:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100f5b:	83 c4 24             	add    $0x24,%esp
  100f5e:	5b                   	pop    %ebx
  100f5f:	5d                   	pop    %ebp
  100f60:	c3                   	ret    

00100f61 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f61:	55                   	push   %ebp
  100f62:	89 e5                	mov    %esp,%ebp
  100f64:	53                   	push   %ebx
  100f65:	83 ec 54             	sub    $0x54,%esp
  100f68:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f6e:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f72:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f76:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f7a:	ee                   	out    %al,(%dx)
  100f7b:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f81:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f85:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f89:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f8d:	ee                   	out    %al,(%dx)
  100f8e:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f94:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f98:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f9c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fa0:	ee                   	out    %al,(%dx)
  100fa1:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fa7:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fab:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100faf:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fb3:	ee                   	out    %al,(%dx)
  100fb4:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fba:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fbe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fc2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fc6:	ee                   	out    %al,(%dx)
  100fc7:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fcd:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fd1:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fd5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fd9:	ee                   	out    %al,(%dx)
  100fda:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fe0:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fe4:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fe8:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fec:	ee                   	out    %al,(%dx)
  100fed:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ff3:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100ff7:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
  100ffb:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
  100fff:	ec                   	in     (%dx),%al
  101000:	89 c3                	mov    %eax,%ebx
  101002:	88 5d d9             	mov    %bl,-0x27(%ebp)
    return data;
  101005:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101009:	3c ff                	cmp    $0xff,%al
  10100b:	0f 95 c0             	setne  %al
  10100e:	0f b6 c0             	movzbl %al,%eax
  101011:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  101016:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10101c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101020:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
  101024:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
  101028:	ec                   	in     (%dx),%al
  101029:	89 c3                	mov    %eax,%ebx
  10102b:	88 5d d5             	mov    %bl,-0x2b(%ebp)
  10102e:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101034:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101038:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
  10103c:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
  101040:	ec                   	in     (%dx),%al
  101041:	89 c3                	mov    %eax,%ebx
  101043:	88 5d d1             	mov    %bl,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101046:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10104b:	85 c0                	test   %eax,%eax
  10104d:	74 0c                	je     10105b <serial_init+0xfa>
        pic_enable(IRQ_COM1);
  10104f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101056:	e8 ee 06 00 00       	call   101749 <pic_enable>
    }
}
  10105b:	83 c4 54             	add    $0x54,%esp
  10105e:	5b                   	pop    %ebx
  10105f:	5d                   	pop    %ebp
  101060:	c3                   	ret    

00101061 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101061:	55                   	push   %ebp
  101062:	89 e5                	mov    %esp,%ebp
  101064:	53                   	push   %ebx
  101065:	83 ec 24             	sub    $0x24,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101068:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  10106f:	eb 09                	jmp    10107a <lpt_putc_sub+0x19>
        delay();
  101071:	e8 83 fd ff ff       	call   100df9 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101076:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  10107a:	66 c7 45 f6 79 03    	movw   $0x379,-0xa(%ebp)
  101080:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101084:	66 89 55 da          	mov    %dx,-0x26(%ebp)
  101088:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10108c:	ec                   	in     (%dx),%al
  10108d:	89 c3                	mov    %eax,%ebx
  10108f:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  101092:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101096:	84 c0                	test   %al,%al
  101098:	78 09                	js     1010a3 <lpt_putc_sub+0x42>
  10109a:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
  1010a1:	7e ce                	jle    101071 <lpt_putc_sub+0x10>
    }
    outb(LPTPORT + 0, c);
  1010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a6:	0f b6 c0             	movzbl %al,%eax
  1010a9:	66 c7 45 f2 78 03    	movw   $0x378,-0xe(%ebp)
  1010af:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010b2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010b6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010ba:	ee                   	out    %al,(%dx)
  1010bb:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010c1:	c6 45 ed 0d          	movb   $0xd,-0x13(%ebp)
  1010c5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010c9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010cd:	ee                   	out    %al,(%dx)
  1010ce:	66 c7 45 ea 7a 03    	movw   $0x37a,-0x16(%ebp)
  1010d4:	c6 45 e9 08          	movb   $0x8,-0x17(%ebp)
  1010d8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1010dc:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1010e0:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010e1:	83 c4 24             	add    $0x24,%esp
  1010e4:	5b                   	pop    %ebx
  1010e5:	5d                   	pop    %ebp
  1010e6:	c3                   	ret    

001010e7 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010e7:	55                   	push   %ebp
  1010e8:	89 e5                	mov    %esp,%ebp
  1010ea:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010ed:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010f1:	74 0d                	je     101100 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f6:	89 04 24             	mov    %eax,(%esp)
  1010f9:	e8 63 ff ff ff       	call   101061 <lpt_putc_sub>
  1010fe:	eb 24                	jmp    101124 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101100:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101107:	e8 55 ff ff ff       	call   101061 <lpt_putc_sub>
        lpt_putc_sub(' ');
  10110c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101113:	e8 49 ff ff ff       	call   101061 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101118:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10111f:	e8 3d ff ff ff       	call   101061 <lpt_putc_sub>
    }
}
  101124:	c9                   	leave  
  101125:	c3                   	ret    

00101126 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101126:	55                   	push   %ebp
  101127:	89 e5                	mov    %esp,%ebp
  101129:	53                   	push   %ebx
  10112a:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10112d:	8b 45 08             	mov    0x8(%ebp),%eax
  101130:	b0 00                	mov    $0x0,%al
  101132:	85 c0                	test   %eax,%eax
  101134:	75 07                	jne    10113d <cga_putc+0x17>
        c |= 0x0700;
  101136:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10113d:	8b 45 08             	mov    0x8(%ebp),%eax
  101140:	25 ff 00 00 00       	and    $0xff,%eax
  101145:	83 f8 0a             	cmp    $0xa,%eax
  101148:	74 4e                	je     101198 <cga_putc+0x72>
  10114a:	83 f8 0d             	cmp    $0xd,%eax
  10114d:	74 59                	je     1011a8 <cga_putc+0x82>
  10114f:	83 f8 08             	cmp    $0x8,%eax
  101152:	0f 85 8a 00 00 00    	jne    1011e2 <cga_putc+0xbc>
    case '\b':
        if (crt_pos > 0) {
  101158:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10115f:	66 85 c0             	test   %ax,%ax
  101162:	0f 84 9f 00 00 00    	je     101207 <cga_putc+0xe1>
            crt_pos --;
  101168:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10116f:	83 e8 01             	sub    $0x1,%eax
  101172:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101178:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10117d:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  101184:	0f b7 d2             	movzwl %dx,%edx
  101187:	01 d2                	add    %edx,%edx
  101189:	01 c2                	add    %eax,%edx
  10118b:	8b 45 08             	mov    0x8(%ebp),%eax
  10118e:	b0 00                	mov    $0x0,%al
  101190:	83 c8 20             	or     $0x20,%eax
  101193:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101196:	eb 6f                	jmp    101207 <cga_putc+0xe1>
    case '\n':
        crt_pos += CRT_COLS;
  101198:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10119f:	83 c0 50             	add    $0x50,%eax
  1011a2:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011a8:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1011af:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1011b6:	0f b7 c1             	movzwl %cx,%eax
  1011b9:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1011bf:	c1 e8 10             	shr    $0x10,%eax
  1011c2:	89 c2                	mov    %eax,%edx
  1011c4:	66 c1 ea 06          	shr    $0x6,%dx
  1011c8:	89 d0                	mov    %edx,%eax
  1011ca:	c1 e0 02             	shl    $0x2,%eax
  1011cd:	01 d0                	add    %edx,%eax
  1011cf:	c1 e0 04             	shl    $0x4,%eax
  1011d2:	89 ca                	mov    %ecx,%edx
  1011d4:	29 c2                	sub    %eax,%edx
  1011d6:	89 d8                	mov    %ebx,%eax
  1011d8:	29 d0                	sub    %edx,%eax
  1011da:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  1011e0:	eb 26                	jmp    101208 <cga_putc+0xe2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011e2:	8b 15 60 ee 10 00    	mov    0x10ee60,%edx
  1011e8:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011ef:	0f b7 c8             	movzwl %ax,%ecx
  1011f2:	01 c9                	add    %ecx,%ecx
  1011f4:	01 d1                	add    %edx,%ecx
  1011f6:	8b 55 08             	mov    0x8(%ebp),%edx
  1011f9:	66 89 11             	mov    %dx,(%ecx)
  1011fc:	83 c0 01             	add    $0x1,%eax
  1011ff:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101205:	eb 01                	jmp    101208 <cga_putc+0xe2>
        break;
  101207:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101208:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10120f:	66 3d cf 07          	cmp    $0x7cf,%ax
  101213:	76 5b                	jbe    101270 <cga_putc+0x14a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101215:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10121a:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101220:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101225:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10122c:	00 
  10122d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101231:	89 04 24             	mov    %eax,(%esp)
  101234:	e8 67 1c 00 00       	call   102ea0 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101239:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101240:	eb 15                	jmp    101257 <cga_putc+0x131>
            crt_buf[i] = 0x0700 | ' ';
  101242:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101247:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10124a:	01 d2                	add    %edx,%edx
  10124c:	01 d0                	add    %edx,%eax
  10124e:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101253:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101257:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10125e:	7e e2                	jle    101242 <cga_putc+0x11c>
        }
        crt_pos -= CRT_COLS;
  101260:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101267:	83 e8 50             	sub    $0x50,%eax
  10126a:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101270:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101277:	0f b7 c0             	movzwl %ax,%eax
  10127a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10127e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101282:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101286:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10128a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10128b:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101292:	66 c1 e8 08          	shr    $0x8,%ax
  101296:	0f b6 c0             	movzbl %al,%eax
  101299:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1012a0:	83 c2 01             	add    $0x1,%edx
  1012a3:	0f b7 d2             	movzwl %dx,%edx
  1012a6:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1012aa:	88 45 ed             	mov    %al,-0x13(%ebp)
  1012ad:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012b1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012b5:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1012b6:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1012bd:	0f b7 c0             	movzwl %ax,%eax
  1012c0:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1012c4:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1012c8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012cc:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012d0:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012d1:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1012d8:	0f b6 c0             	movzbl %al,%eax
  1012db:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1012e2:	83 c2 01             	add    $0x1,%edx
  1012e5:	0f b7 d2             	movzwl %dx,%edx
  1012e8:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012ec:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012ef:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012f3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012f7:	ee                   	out    %al,(%dx)
}
  1012f8:	83 c4 34             	add    $0x34,%esp
  1012fb:	5b                   	pop    %ebx
  1012fc:	5d                   	pop    %ebp
  1012fd:	c3                   	ret    

001012fe <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012fe:	55                   	push   %ebp
  1012ff:	89 e5                	mov    %esp,%ebp
  101301:	53                   	push   %ebx
  101302:	83 ec 14             	sub    $0x14,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101305:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  10130c:	eb 09                	jmp    101317 <serial_putc_sub+0x19>
        delay();
  10130e:	e8 e6 fa ff ff       	call   100df9 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101313:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  101317:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10131d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101321:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101325:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101329:	ec                   	in     (%dx),%al
  10132a:	89 c3                	mov    %eax,%ebx
  10132c:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  10132f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101333:	0f b6 c0             	movzbl %al,%eax
  101336:	83 e0 20             	and    $0x20,%eax
  101339:	85 c0                	test   %eax,%eax
  10133b:	75 09                	jne    101346 <serial_putc_sub+0x48>
  10133d:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
  101344:	7e c8                	jle    10130e <serial_putc_sub+0x10>
    }
    outb(COM1 + COM_TX, c);
  101346:	8b 45 08             	mov    0x8(%ebp),%eax
  101349:	0f b6 c0             	movzbl %al,%eax
  10134c:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  101352:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101355:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101359:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10135d:	ee                   	out    %al,(%dx)
}
  10135e:	83 c4 14             	add    $0x14,%esp
  101361:	5b                   	pop    %ebx
  101362:	5d                   	pop    %ebp
  101363:	c3                   	ret    

00101364 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101364:	55                   	push   %ebp
  101365:	89 e5                	mov    %esp,%ebp
  101367:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10136a:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10136e:	74 0d                	je     10137d <serial_putc+0x19>
        serial_putc_sub(c);
  101370:	8b 45 08             	mov    0x8(%ebp),%eax
  101373:	89 04 24             	mov    %eax,(%esp)
  101376:	e8 83 ff ff ff       	call   1012fe <serial_putc_sub>
  10137b:	eb 24                	jmp    1013a1 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10137d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101384:	e8 75 ff ff ff       	call   1012fe <serial_putc_sub>
        serial_putc_sub(' ');
  101389:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101390:	e8 69 ff ff ff       	call   1012fe <serial_putc_sub>
        serial_putc_sub('\b');
  101395:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10139c:	e8 5d ff ff ff       	call   1012fe <serial_putc_sub>
    }
}
  1013a1:	c9                   	leave  
  1013a2:	c3                   	ret    

001013a3 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013a3:	55                   	push   %ebp
  1013a4:	89 e5                	mov    %esp,%ebp
  1013a6:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013a9:	eb 32                	jmp    1013dd <cons_intr+0x3a>
        if (c != 0) {
  1013ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013af:	74 2c                	je     1013dd <cons_intr+0x3a>
            cons.buf[cons.wpos ++] = c;
  1013b1:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1013b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013b9:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
  1013bf:	83 c0 01             	add    $0x1,%eax
  1013c2:	a3 84 f0 10 00       	mov    %eax,0x10f084
            if (cons.wpos == CONSBUFSIZE) {
  1013c7:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1013cc:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013d1:	75 0a                	jne    1013dd <cons_intr+0x3a>
                cons.wpos = 0;
  1013d3:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  1013da:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1013e0:	ff d0                	call   *%eax
  1013e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013e5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013e9:	75 c0                	jne    1013ab <cons_intr+0x8>
            }
        }
    }
}
  1013eb:	c9                   	leave  
  1013ec:	c3                   	ret    

001013ed <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013ed:	55                   	push   %ebp
  1013ee:	89 e5                	mov    %esp,%ebp
  1013f0:	53                   	push   %ebx
  1013f1:	83 ec 14             	sub    $0x14,%esp
  1013f4:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013fa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1013fe:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101402:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101406:	ec                   	in     (%dx),%al
  101407:	89 c3                	mov    %eax,%ebx
  101409:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  10140c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101410:	0f b6 c0             	movzbl %al,%eax
  101413:	83 e0 01             	and    $0x1,%eax
  101416:	85 c0                	test   %eax,%eax
  101418:	75 07                	jne    101421 <serial_proc_data+0x34>
        return -1;
  10141a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10141f:	eb 32                	jmp    101453 <serial_proc_data+0x66>
  101421:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101427:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10142b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10142f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101433:	ec                   	in     (%dx),%al
  101434:	89 c3                	mov    %eax,%ebx
  101436:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
  101439:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10143d:	0f b6 c0             	movzbl %al,%eax
  101440:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (c == 127) {
  101443:	83 7d f8 7f          	cmpl   $0x7f,-0x8(%ebp)
  101447:	75 07                	jne    101450 <serial_proc_data+0x63>
        c = '\b';
  101449:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%ebp)
    }
    return c;
  101450:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  101453:	83 c4 14             	add    $0x14,%esp
  101456:	5b                   	pop    %ebx
  101457:	5d                   	pop    %ebp
  101458:	c3                   	ret    

00101459 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101459:	55                   	push   %ebp
  10145a:	89 e5                	mov    %esp,%ebp
  10145c:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10145f:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101464:	85 c0                	test   %eax,%eax
  101466:	74 0c                	je     101474 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101468:	c7 04 24 ed 13 10 00 	movl   $0x1013ed,(%esp)
  10146f:	e8 2f ff ff ff       	call   1013a3 <cons_intr>
    }
}
  101474:	c9                   	leave  
  101475:	c3                   	ret    

00101476 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101476:	55                   	push   %ebp
  101477:	89 e5                	mov    %esp,%ebp
  101479:	53                   	push   %ebx
  10147a:	83 ec 44             	sub    $0x44,%esp
  10147d:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101483:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101487:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
  10148b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10148f:	ec                   	in     (%dx),%al
  101490:	89 c3                	mov    %eax,%ebx
  101492:	88 5d ef             	mov    %bl,-0x11(%ebp)
    return data;
  101495:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101499:	0f b6 c0             	movzbl %al,%eax
  10149c:	83 e0 01             	and    $0x1,%eax
  10149f:	85 c0                	test   %eax,%eax
  1014a1:	75 0a                	jne    1014ad <kbd_proc_data+0x37>
        return -1;
  1014a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014a8:	e9 61 01 00 00       	jmp    10160e <kbd_proc_data+0x198>
  1014ad:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014b3:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1014b7:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
  1014bb:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1014bf:	ec                   	in     (%dx),%al
  1014c0:	89 c3                	mov    %eax,%ebx
  1014c2:	88 5d eb             	mov    %bl,-0x15(%ebp)
    return data;
  1014c5:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014c9:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014cc:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014d0:	75 17                	jne    1014e9 <kbd_proc_data+0x73>
        // E0 escape character
        shift |= E0ESC;
  1014d2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d7:	83 c8 40             	or     $0x40,%eax
  1014da:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1014df:	b8 00 00 00 00       	mov    $0x0,%eax
  1014e4:	e9 25 01 00 00       	jmp    10160e <kbd_proc_data+0x198>
    } else if (data & 0x80) {
  1014e9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ed:	84 c0                	test   %al,%al
  1014ef:	79 47                	jns    101538 <kbd_proc_data+0xc2>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014f1:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014f6:	83 e0 40             	and    $0x40,%eax
  1014f9:	85 c0                	test   %eax,%eax
  1014fb:	75 09                	jne    101506 <kbd_proc_data+0x90>
  1014fd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101501:	83 e0 7f             	and    $0x7f,%eax
  101504:	eb 04                	jmp    10150a <kbd_proc_data+0x94>
  101506:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150a:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10150d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101511:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101518:	83 c8 40             	or     $0x40,%eax
  10151b:	0f b6 c0             	movzbl %al,%eax
  10151e:	f7 d0                	not    %eax
  101520:	89 c2                	mov    %eax,%edx
  101522:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101527:	21 d0                	and    %edx,%eax
  101529:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10152e:	b8 00 00 00 00       	mov    $0x0,%eax
  101533:	e9 d6 00 00 00       	jmp    10160e <kbd_proc_data+0x198>
    } else if (shift & E0ESC) {
  101538:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10153d:	83 e0 40             	and    $0x40,%eax
  101540:	85 c0                	test   %eax,%eax
  101542:	74 11                	je     101555 <kbd_proc_data+0xdf>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101544:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101548:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10154d:	83 e0 bf             	and    $0xffffffbf,%eax
  101550:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101555:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101559:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101560:	0f b6 d0             	movzbl %al,%edx
  101563:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101568:	09 d0                	or     %edx,%eax
  10156a:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  10156f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101573:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  10157a:	0f b6 d0             	movzbl %al,%edx
  10157d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101582:	31 d0                	xor    %edx,%eax
  101584:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  101589:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10158e:	83 e0 03             	and    $0x3,%eax
  101591:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  101598:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10159c:	01 d0                	add    %edx,%eax
  10159e:	0f b6 00             	movzbl (%eax),%eax
  1015a1:	0f b6 c0             	movzbl %al,%eax
  1015a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015a7:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1015ac:	83 e0 08             	and    $0x8,%eax
  1015af:	85 c0                	test   %eax,%eax
  1015b1:	74 22                	je     1015d5 <kbd_proc_data+0x15f>
        if ('a' <= c && c <= 'z')
  1015b3:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015b7:	7e 0c                	jle    1015c5 <kbd_proc_data+0x14f>
  1015b9:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015bd:	7f 06                	jg     1015c5 <kbd_proc_data+0x14f>
            c += 'A' - 'a';
  1015bf:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015c3:	eb 10                	jmp    1015d5 <kbd_proc_data+0x15f>
        else if ('A' <= c && c <= 'Z')
  1015c5:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015c9:	7e 0a                	jle    1015d5 <kbd_proc_data+0x15f>
  1015cb:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015cf:	7f 04                	jg     1015d5 <kbd_proc_data+0x15f>
            c += 'a' - 'A';
  1015d1:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015d5:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1015da:	f7 d0                	not    %eax
  1015dc:	83 e0 06             	and    $0x6,%eax
  1015df:	85 c0                	test   %eax,%eax
  1015e1:	75 28                	jne    10160b <kbd_proc_data+0x195>
  1015e3:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015ea:	75 1f                	jne    10160b <kbd_proc_data+0x195>
        cprintf("Rebooting!\n");
  1015ec:	c7 04 24 0d 3a 10 00 	movl   $0x103a0d,(%esp)
  1015f3:	e8 76 ec ff ff       	call   10026e <cprintf>
  1015f8:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015fe:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101602:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101606:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10160a:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10160b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10160e:	83 c4 44             	add    $0x44,%esp
  101611:	5b                   	pop    %ebx
  101612:	5d                   	pop    %ebp
  101613:	c3                   	ret    

00101614 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101614:	55                   	push   %ebp
  101615:	89 e5                	mov    %esp,%ebp
  101617:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10161a:	c7 04 24 76 14 10 00 	movl   $0x101476,(%esp)
  101621:	e8 7d fd ff ff       	call   1013a3 <cons_intr>
}
  101626:	c9                   	leave  
  101627:	c3                   	ret    

00101628 <kbd_init>:

static void
kbd_init(void) {
  101628:	55                   	push   %ebp
  101629:	89 e5                	mov    %esp,%ebp
  10162b:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10162e:	e8 e1 ff ff ff       	call   101614 <kbd_intr>
    pic_enable(IRQ_KBD);
  101633:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10163a:	e8 0a 01 00 00       	call   101749 <pic_enable>
}
  10163f:	c9                   	leave  
  101640:	c3                   	ret    

00101641 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101641:	55                   	push   %ebp
  101642:	89 e5                	mov    %esp,%ebp
  101644:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101647:	e8 1a f8 ff ff       	call   100e66 <cga_init>
    serial_init();
  10164c:	e8 10 f9 ff ff       	call   100f61 <serial_init>
    kbd_init();
  101651:	e8 d2 ff ff ff       	call   101628 <kbd_init>
    if (!serial_exists) {
  101656:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10165b:	85 c0                	test   %eax,%eax
  10165d:	75 0c                	jne    10166b <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10165f:	c7 04 24 19 3a 10 00 	movl   $0x103a19,(%esp)
  101666:	e8 03 ec ff ff       	call   10026e <cprintf>
    }
}
  10166b:	c9                   	leave  
  10166c:	c3                   	ret    

0010166d <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10166d:	55                   	push   %ebp
  10166e:	89 e5                	mov    %esp,%ebp
  101670:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101673:	8b 45 08             	mov    0x8(%ebp),%eax
  101676:	89 04 24             	mov    %eax,(%esp)
  101679:	e8 69 fa ff ff       	call   1010e7 <lpt_putc>
    cga_putc(c);
  10167e:	8b 45 08             	mov    0x8(%ebp),%eax
  101681:	89 04 24             	mov    %eax,(%esp)
  101684:	e8 9d fa ff ff       	call   101126 <cga_putc>
    serial_putc(c);
  101689:	8b 45 08             	mov    0x8(%ebp),%eax
  10168c:	89 04 24             	mov    %eax,(%esp)
  10168f:	e8 d0 fc ff ff       	call   101364 <serial_putc>
}
  101694:	c9                   	leave  
  101695:	c3                   	ret    

00101696 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101696:	55                   	push   %ebp
  101697:	89 e5                	mov    %esp,%ebp
  101699:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  10169c:	e8 b8 fd ff ff       	call   101459 <serial_intr>
    kbd_intr();
  1016a1:	e8 6e ff ff ff       	call   101614 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016a6:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1016ac:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1016b1:	39 c2                	cmp    %eax,%edx
  1016b3:	74 35                	je     1016ea <cons_getc+0x54>
        c = cons.buf[cons.rpos ++];
  1016b5:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1016ba:	0f b6 90 80 ee 10 00 	movzbl 0x10ee80(%eax),%edx
  1016c1:	0f b6 d2             	movzbl %dl,%edx
  1016c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1016c7:	83 c0 01             	add    $0x1,%eax
  1016ca:	a3 80 f0 10 00       	mov    %eax,0x10f080
        if (cons.rpos == CONSBUFSIZE) {
  1016cf:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1016d4:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016d9:	75 0a                	jne    1016e5 <cons_getc+0x4f>
            cons.rpos = 0;
  1016db:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  1016e2:	00 00 00 
        }
        return c;
  1016e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016e8:	eb 05                	jmp    1016ef <cons_getc+0x59>
    }
    return 0;
  1016ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1016ef:	c9                   	leave  
  1016f0:	c3                   	ret    

001016f1 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016f1:	55                   	push   %ebp
  1016f2:	89 e5                	mov    %esp,%ebp
  1016f4:	83 ec 14             	sub    $0x14,%esp
  1016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1016fa:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016fe:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101702:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101708:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  10170d:	85 c0                	test   %eax,%eax
  10170f:	74 36                	je     101747 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101711:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101715:	0f b6 c0             	movzbl %al,%eax
  101718:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10171e:	88 45 fd             	mov    %al,-0x3(%ebp)
  101721:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101725:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101729:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10172a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10172e:	66 c1 e8 08          	shr    $0x8,%ax
  101732:	0f b6 c0             	movzbl %al,%eax
  101735:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10173b:	88 45 f9             	mov    %al,-0x7(%ebp)
  10173e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101742:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101746:	ee                   	out    %al,(%dx)
    }
}
  101747:	c9                   	leave  
  101748:	c3                   	ret    

00101749 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101749:	55                   	push   %ebp
  10174a:	89 e5                	mov    %esp,%ebp
  10174c:	53                   	push   %ebx
  10174d:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101750:	8b 45 08             	mov    0x8(%ebp),%eax
  101753:	ba 01 00 00 00       	mov    $0x1,%edx
  101758:	89 d3                	mov    %edx,%ebx
  10175a:	89 c1                	mov    %eax,%ecx
  10175c:	d3 e3                	shl    %cl,%ebx
  10175e:	89 d8                	mov    %ebx,%eax
  101760:	89 c2                	mov    %eax,%edx
  101762:	f7 d2                	not    %edx
  101764:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10176b:	21 d0                	and    %edx,%eax
  10176d:	0f b7 c0             	movzwl %ax,%eax
  101770:	89 04 24             	mov    %eax,(%esp)
  101773:	e8 79 ff ff ff       	call   1016f1 <pic_setmask>
}
  101778:	83 c4 04             	add    $0x4,%esp
  10177b:	5b                   	pop    %ebx
  10177c:	5d                   	pop    %ebp
  10177d:	c3                   	ret    

0010177e <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10177e:	55                   	push   %ebp
  10177f:	89 e5                	mov    %esp,%ebp
  101781:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101784:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  10178b:	00 00 00 
  10178e:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101794:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101798:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10179c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017a0:	ee                   	out    %al,(%dx)
  1017a1:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1017a7:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1017ab:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017af:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017b3:	ee                   	out    %al,(%dx)
  1017b4:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1017ba:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1017be:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1017c2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017c6:	ee                   	out    %al,(%dx)
  1017c7:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1017cd:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1017d1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017d5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017d9:	ee                   	out    %al,(%dx)
  1017da:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017e0:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017e4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017e8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017ec:	ee                   	out    %al,(%dx)
  1017ed:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017f3:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017f7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017fb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017ff:	ee                   	out    %al,(%dx)
  101800:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101806:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  10180a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10180e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101812:	ee                   	out    %al,(%dx)
  101813:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101819:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10181d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101821:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101825:	ee                   	out    %al,(%dx)
  101826:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  10182c:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101830:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101834:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101838:	ee                   	out    %al,(%dx)
  101839:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10183f:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101843:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101847:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10184b:	ee                   	out    %al,(%dx)
  10184c:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101852:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101856:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10185a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10185e:	ee                   	out    %al,(%dx)
  10185f:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101865:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101869:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10186d:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101871:	ee                   	out    %al,(%dx)
  101872:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101878:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10187c:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101880:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101884:	ee                   	out    %al,(%dx)
  101885:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10188b:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10188f:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101893:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101897:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101898:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10189f:	66 83 f8 ff          	cmp    $0xffff,%ax
  1018a3:	74 12                	je     1018b7 <pic_init+0x139>
        pic_setmask(irq_mask);
  1018a5:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1018ac:	0f b7 c0             	movzwl %ax,%eax
  1018af:	89 04 24             	mov    %eax,(%esp)
  1018b2:	e8 3a fe ff ff       	call   1016f1 <pic_setmask>
    }
}
  1018b7:	c9                   	leave  
  1018b8:	c3                   	ret    

001018b9 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1018b9:	55                   	push   %ebp
  1018ba:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1018bc:	fb                   	sti    
    sti();
}
  1018bd:	5d                   	pop    %ebp
  1018be:	c3                   	ret    

001018bf <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1018bf:	55                   	push   %ebp
  1018c0:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1018c2:	fa                   	cli    
    cli();
}
  1018c3:	5d                   	pop    %ebp
  1018c4:	c3                   	ret    

001018c5 <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  1018c5:	55                   	push   %ebp
  1018c6:	89 e5                	mov    %esp,%ebp
  1018c8:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1018cb:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018d2:	00 
  1018d3:	c7 04 24 40 3a 10 00 	movl   $0x103a40,(%esp)
  1018da:	e8 8f e9 ff ff       	call   10026e <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1018df:	c9                   	leave  
  1018e0:	c3                   	ret    

001018e1 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018e1:	55                   	push   %ebp
  1018e2:	89 e5                	mov    %esp,%ebp
  1018e4:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018ee:	e9 c3 00 00 00       	jmp    1019b6 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f6:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018fd:	89 c2                	mov    %eax,%edx
  1018ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101902:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101909:	00 
  10190a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190d:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101914:	00 08 00 
  101917:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191a:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101921:	00 
  101922:	83 e2 e0             	and    $0xffffffe0,%edx
  101925:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10192c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192f:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101936:	00 
  101937:	83 e2 1f             	and    $0x1f,%edx
  10193a:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101941:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101944:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10194b:	00 
  10194c:	83 e2 f0             	and    $0xfffffff0,%edx
  10194f:	83 ca 0e             	or     $0xe,%edx
  101952:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101959:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195c:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101963:	00 
  101964:	83 e2 ef             	and    $0xffffffef,%edx
  101967:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10196e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101971:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101978:	00 
  101979:	83 e2 9f             	and    $0xffffff9f,%edx
  10197c:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101983:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101986:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10198d:	00 
  10198e:	83 ca 80             	or     $0xffffff80,%edx
  101991:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101998:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10199b:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1019a2:	c1 e8 10             	shr    $0x10,%eax
  1019a5:	89 c2                	mov    %eax,%edx
  1019a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019aa:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1019b1:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1019b2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1019b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b9:	3d ff 00 00 00       	cmp    $0xff,%eax
  1019be:	0f 86 2f ff ff ff    	jbe    1018f3 <idt_init+0x12>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1019c4:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1019c9:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  1019cf:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  1019d6:	08 00 
  1019d8:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1019df:	83 e0 e0             	and    $0xffffffe0,%eax
  1019e2:	a2 6c f4 10 00       	mov    %al,0x10f46c
  1019e7:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1019ee:	83 e0 1f             	and    $0x1f,%eax
  1019f1:	a2 6c f4 10 00       	mov    %al,0x10f46c
  1019f6:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019fd:	83 e0 f0             	and    $0xfffffff0,%eax
  101a00:	83 c8 0e             	or     $0xe,%eax
  101a03:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101a08:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101a0f:	83 e0 ef             	and    $0xffffffef,%eax
  101a12:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101a17:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101a1e:	83 c8 60             	or     $0x60,%eax
  101a21:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101a26:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101a2d:	83 c8 80             	or     $0xffffff80,%eax
  101a30:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101a35:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101a3a:	c1 e8 10             	shr    $0x10,%eax
  101a3d:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101a43:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101a4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a4d:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  101a50:	c9                   	leave  
  101a51:	c3                   	ret    

00101a52 <trapname>:

static const char *
trapname(int trapno) {
  101a52:	55                   	push   %ebp
  101a53:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a55:	8b 45 08             	mov    0x8(%ebp),%eax
  101a58:	83 f8 13             	cmp    $0x13,%eax
  101a5b:	77 0c                	ja     101a69 <trapname+0x17>
        return excnames[trapno];
  101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a60:	8b 04 85 a0 3d 10 00 	mov    0x103da0(,%eax,4),%eax
  101a67:	eb 18                	jmp    101a81 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a69:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a6d:	7e 0d                	jle    101a7c <trapname+0x2a>
  101a6f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a73:	7f 07                	jg     101a7c <trapname+0x2a>
        return "Hardware Interrupt";
  101a75:	b8 4a 3a 10 00       	mov    $0x103a4a,%eax
  101a7a:	eb 05                	jmp    101a81 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a7c:	b8 5d 3a 10 00       	mov    $0x103a5d,%eax
}
  101a81:	5d                   	pop    %ebp
  101a82:	c3                   	ret    

00101a83 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a83:	55                   	push   %ebp
  101a84:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a86:	8b 45 08             	mov    0x8(%ebp),%eax
  101a89:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a8d:	66 83 f8 08          	cmp    $0x8,%ax
  101a91:	0f 94 c0             	sete   %al
  101a94:	0f b6 c0             	movzbl %al,%eax
}
  101a97:	5d                   	pop    %ebp
  101a98:	c3                   	ret    

00101a99 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a99:	55                   	push   %ebp
  101a9a:	89 e5                	mov    %esp,%ebp
  101a9c:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa6:	c7 04 24 9e 3a 10 00 	movl   $0x103a9e,(%esp)
  101aad:	e8 bc e7 ff ff       	call   10026e <cprintf>
    print_regs(&tf->tf_regs);
  101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab5:	89 04 24             	mov    %eax,(%esp)
  101ab8:	e8 a1 01 00 00       	call   101c5e <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101abd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac0:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101ac4:	0f b7 c0             	movzwl %ax,%eax
  101ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101acb:	c7 04 24 af 3a 10 00 	movl   $0x103aaf,(%esp)
  101ad2:	e8 97 e7 ff ff       	call   10026e <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  101ada:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ade:	0f b7 c0             	movzwl %ax,%eax
  101ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae5:	c7 04 24 c2 3a 10 00 	movl   $0x103ac2,(%esp)
  101aec:	e8 7d e7 ff ff       	call   10026e <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101af1:	8b 45 08             	mov    0x8(%ebp),%eax
  101af4:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101af8:	0f b7 c0             	movzwl %ax,%eax
  101afb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aff:	c7 04 24 d5 3a 10 00 	movl   $0x103ad5,(%esp)
  101b06:	e8 63 e7 ff ff       	call   10026e <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0e:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b12:	0f b7 c0             	movzwl %ax,%eax
  101b15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b19:	c7 04 24 e8 3a 10 00 	movl   $0x103ae8,(%esp)
  101b20:	e8 49 e7 ff ff       	call   10026e <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b25:	8b 45 08             	mov    0x8(%ebp),%eax
  101b28:	8b 40 30             	mov    0x30(%eax),%eax
  101b2b:	89 04 24             	mov    %eax,(%esp)
  101b2e:	e8 1f ff ff ff       	call   101a52 <trapname>
  101b33:	8b 55 08             	mov    0x8(%ebp),%edx
  101b36:	8b 52 30             	mov    0x30(%edx),%edx
  101b39:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b3d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b41:	c7 04 24 fb 3a 10 00 	movl   $0x103afb,(%esp)
  101b48:	e8 21 e7 ff ff       	call   10026e <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b50:	8b 40 34             	mov    0x34(%eax),%eax
  101b53:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b57:	c7 04 24 0d 3b 10 00 	movl   $0x103b0d,(%esp)
  101b5e:	e8 0b e7 ff ff       	call   10026e <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b63:	8b 45 08             	mov    0x8(%ebp),%eax
  101b66:	8b 40 38             	mov    0x38(%eax),%eax
  101b69:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6d:	c7 04 24 1c 3b 10 00 	movl   $0x103b1c,(%esp)
  101b74:	e8 f5 e6 ff ff       	call   10026e <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b79:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b80:	0f b7 c0             	movzwl %ax,%eax
  101b83:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b87:	c7 04 24 2b 3b 10 00 	movl   $0x103b2b,(%esp)
  101b8e:	e8 db e6 ff ff       	call   10026e <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b93:	8b 45 08             	mov    0x8(%ebp),%eax
  101b96:	8b 40 40             	mov    0x40(%eax),%eax
  101b99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9d:	c7 04 24 3e 3b 10 00 	movl   $0x103b3e,(%esp)
  101ba4:	e8 c5 e6 ff ff       	call   10026e <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ba9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101bb0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101bb7:	eb 3e                	jmp    101bf7 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbc:	8b 50 40             	mov    0x40(%eax),%edx
  101bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bc2:	21 d0                	and    %edx,%eax
  101bc4:	85 c0                	test   %eax,%eax
  101bc6:	74 28                	je     101bf0 <print_trapframe+0x157>
  101bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bcb:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101bd2:	85 c0                	test   %eax,%eax
  101bd4:	74 1a                	je     101bf0 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd9:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101be0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be4:	c7 04 24 4d 3b 10 00 	movl   $0x103b4d,(%esp)
  101beb:	e8 7e e6 ff ff       	call   10026e <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bf0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bf4:	d1 65 f0             	shll   -0x10(%ebp)
  101bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bfa:	83 f8 17             	cmp    $0x17,%eax
  101bfd:	76 ba                	jbe    101bb9 <print_trapframe+0x120>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bff:	8b 45 08             	mov    0x8(%ebp),%eax
  101c02:	8b 40 40             	mov    0x40(%eax),%eax
  101c05:	25 00 30 00 00       	and    $0x3000,%eax
  101c0a:	c1 e8 0c             	shr    $0xc,%eax
  101c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c11:	c7 04 24 51 3b 10 00 	movl   $0x103b51,(%esp)
  101c18:	e8 51 e6 ff ff       	call   10026e <cprintf>

    if (!trap_in_kernel(tf)) {
  101c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c20:	89 04 24             	mov    %eax,(%esp)
  101c23:	e8 5b fe ff ff       	call   101a83 <trap_in_kernel>
  101c28:	85 c0                	test   %eax,%eax
  101c2a:	75 30                	jne    101c5c <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2f:	8b 40 44             	mov    0x44(%eax),%eax
  101c32:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c36:	c7 04 24 5a 3b 10 00 	movl   $0x103b5a,(%esp)
  101c3d:	e8 2c e6 ff ff       	call   10026e <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c42:	8b 45 08             	mov    0x8(%ebp),%eax
  101c45:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c49:	0f b7 c0             	movzwl %ax,%eax
  101c4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c50:	c7 04 24 69 3b 10 00 	movl   $0x103b69,(%esp)
  101c57:	e8 12 e6 ff ff       	call   10026e <cprintf>
    }
}
  101c5c:	c9                   	leave  
  101c5d:	c3                   	ret    

00101c5e <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c5e:	55                   	push   %ebp
  101c5f:	89 e5                	mov    %esp,%ebp
  101c61:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c64:	8b 45 08             	mov    0x8(%ebp),%eax
  101c67:	8b 00                	mov    (%eax),%eax
  101c69:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6d:	c7 04 24 7c 3b 10 00 	movl   $0x103b7c,(%esp)
  101c74:	e8 f5 e5 ff ff       	call   10026e <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c79:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7c:	8b 40 04             	mov    0x4(%eax),%eax
  101c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c83:	c7 04 24 8b 3b 10 00 	movl   $0x103b8b,(%esp)
  101c8a:	e8 df e5 ff ff       	call   10026e <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c92:	8b 40 08             	mov    0x8(%eax),%eax
  101c95:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c99:	c7 04 24 9a 3b 10 00 	movl   $0x103b9a,(%esp)
  101ca0:	e8 c9 e5 ff ff       	call   10026e <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca8:	8b 40 0c             	mov    0xc(%eax),%eax
  101cab:	89 44 24 04          	mov    %eax,0x4(%esp)
  101caf:	c7 04 24 a9 3b 10 00 	movl   $0x103ba9,(%esp)
  101cb6:	e8 b3 e5 ff ff       	call   10026e <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbe:	8b 40 10             	mov    0x10(%eax),%eax
  101cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc5:	c7 04 24 b8 3b 10 00 	movl   $0x103bb8,(%esp)
  101ccc:	e8 9d e5 ff ff       	call   10026e <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd4:	8b 40 14             	mov    0x14(%eax),%eax
  101cd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cdb:	c7 04 24 c7 3b 10 00 	movl   $0x103bc7,(%esp)
  101ce2:	e8 87 e5 ff ff       	call   10026e <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  101cea:	8b 40 18             	mov    0x18(%eax),%eax
  101ced:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf1:	c7 04 24 d6 3b 10 00 	movl   $0x103bd6,(%esp)
  101cf8:	e8 71 e5 ff ff       	call   10026e <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  101d00:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d03:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d07:	c7 04 24 e5 3b 10 00 	movl   $0x103be5,(%esp)
  101d0e:	e8 5b e5 ff ff       	call   10026e <cprintf>
}
  101d13:	c9                   	leave  
  101d14:	c3                   	ret    

00101d15 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d15:	55                   	push   %ebp
  101d16:	89 e5                	mov    %esp,%ebp
  101d18:	57                   	push   %edi
  101d19:	56                   	push   %esi
  101d1a:	53                   	push   %ebx
  101d1b:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d21:	8b 40 30             	mov    0x30(%eax),%eax
  101d24:	83 f8 2f             	cmp    $0x2f,%eax
  101d27:	77 21                	ja     101d4a <trap_dispatch+0x35>
  101d29:	83 f8 2e             	cmp    $0x2e,%eax
  101d2c:	0f 83 ee 01 00 00    	jae    101f20 <trap_dispatch+0x20b>
  101d32:	83 f8 21             	cmp    $0x21,%eax
  101d35:	0f 84 8b 00 00 00    	je     101dc6 <trap_dispatch+0xb1>
  101d3b:	83 f8 24             	cmp    $0x24,%eax
  101d3e:	74 5d                	je     101d9d <trap_dispatch+0x88>
  101d40:	83 f8 20             	cmp    $0x20,%eax
  101d43:	74 1c                	je     101d61 <trap_dispatch+0x4c>
  101d45:	e9 9e 01 00 00       	jmp    101ee8 <trap_dispatch+0x1d3>
  101d4a:	83 f8 78             	cmp    $0x78,%eax
  101d4d:	0f 84 9c 00 00 00    	je     101def <trap_dispatch+0xda>
  101d53:	83 f8 79             	cmp    $0x79,%eax
  101d56:	0f 84 11 01 00 00    	je     101e6d <trap_dispatch+0x158>
  101d5c:	e9 87 01 00 00       	jmp    101ee8 <trap_dispatch+0x1d3>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a function, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d61:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101d66:	83 c0 01             	add    $0x1,%eax
  101d69:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks % TICK_NUM == 0) {
  101d6e:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101d74:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d79:	89 c8                	mov    %ecx,%eax
  101d7b:	f7 e2                	mul    %edx
  101d7d:	89 d0                	mov    %edx,%eax
  101d7f:	c1 e8 05             	shr    $0x5,%eax
  101d82:	6b c0 64             	imul   $0x64,%eax,%eax
  101d85:	89 ca                	mov    %ecx,%edx
  101d87:	29 c2                	sub    %eax,%edx
  101d89:	89 d0                	mov    %edx,%eax
  101d8b:	85 c0                	test   %eax,%eax
  101d8d:	0f 85 90 01 00 00    	jne    101f23 <trap_dispatch+0x20e>
            print_ticks();
  101d93:	e8 2d fb ff ff       	call   1018c5 <print_ticks>
        }
        break;
  101d98:	e9 86 01 00 00       	jmp    101f23 <trap_dispatch+0x20e>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d9d:	e8 f4 f8 ff ff       	call   101696 <cons_getc>
  101da2:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101da5:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101da9:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101dad:	89 54 24 08          	mov    %edx,0x8(%esp)
  101db1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db5:	c7 04 24 f4 3b 10 00 	movl   $0x103bf4,(%esp)
  101dbc:	e8 ad e4 ff ff       	call   10026e <cprintf>
        break;
  101dc1:	e9 64 01 00 00       	jmp    101f2a <trap_dispatch+0x215>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101dc6:	e8 cb f8 ff ff       	call   101696 <cons_getc>
  101dcb:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101dce:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101dd2:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101dd6:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dda:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dde:	c7 04 24 06 3c 10 00 	movl   $0x103c06,(%esp)
  101de5:	e8 84 e4 ff ff       	call   10026e <cprintf>
        break;
  101dea:	e9 3b 01 00 00       	jmp    101f2a <trap_dispatch+0x215>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101def:	8b 45 08             	mov    0x8(%ebp),%eax
  101df2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101df6:	66 83 f8 1b          	cmp    $0x1b,%ax
  101dfa:	0f 84 26 01 00 00    	je     101f26 <trap_dispatch+0x211>
            switchk2u = *tf;
  101e00:	8b 45 08             	mov    0x8(%ebp),%eax
  101e03:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101e08:	89 c3                	mov    %eax,%ebx
  101e0a:	b8 13 00 00 00       	mov    $0x13,%eax
  101e0f:	89 d7                	mov    %edx,%edi
  101e11:	89 de                	mov    %ebx,%esi
  101e13:	89 c1                	mov    %eax,%ecx
  101e15:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101e17:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101e1e:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101e20:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101e27:	23 00 
  101e29:	0f b7 05 68 f9 10 00 	movzwl 0x10f968,%eax
  101e30:	66 a3 48 f9 10 00    	mov    %ax,0x10f948
  101e36:	0f b7 05 48 f9 10 00 	movzwl 0x10f948,%eax
  101e3d:	66 a3 4c f9 10 00    	mov    %ax,0x10f94c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101e43:	8b 45 08             	mov    0x8(%ebp),%eax
  101e46:	83 c0 44             	add    $0x44,%eax
  101e49:	a3 64 f9 10 00       	mov    %eax,0x10f964
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101e4e:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101e53:	80 cc 30             	or     $0x30,%ah
  101e56:	a3 60 f9 10 00       	mov    %eax,0x10f960
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5e:	8d 50 fc             	lea    -0x4(%eax),%edx
  101e61:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101e66:	89 02                	mov    %eax,(%edx)
        }
        break;
  101e68:	e9 b9 00 00 00       	jmp    101f26 <trap_dispatch+0x211>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e70:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e74:	66 83 f8 08          	cmp    $0x8,%ax
  101e78:	0f 84 ab 00 00 00    	je     101f29 <trap_dispatch+0x214>
            tf->tf_cs = KERNEL_CS;
  101e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e81:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e87:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8a:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e90:	8b 45 08             	mov    0x8(%ebp),%eax
  101e93:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e97:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9a:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea1:	8b 40 40             	mov    0x40(%eax),%eax
  101ea4:	89 c2                	mov    %eax,%edx
  101ea6:	80 e6 cf             	and    $0xcf,%dh
  101ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  101eac:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb2:	8b 40 44             	mov    0x44(%eax),%eax
  101eb5:	83 e8 44             	sub    $0x44,%eax
  101eb8:	a3 6c f9 10 00       	mov    %eax,0x10f96c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101ebd:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101ec2:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101ec9:	00 
  101eca:	8b 55 08             	mov    0x8(%ebp),%edx
  101ecd:	89 54 24 04          	mov    %edx,0x4(%esp)
  101ed1:	89 04 24             	mov    %eax,(%esp)
  101ed4:	e8 c7 0f 00 00       	call   102ea0 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  101edc:	8d 50 fc             	lea    -0x4(%eax),%edx
  101edf:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101ee4:	89 02                	mov    %eax,(%edx)
        }
        break;
  101ee6:	eb 41                	jmp    101f29 <trap_dispatch+0x214>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  101eeb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101eef:	0f b7 c0             	movzwl %ax,%eax
  101ef2:	83 e0 03             	and    $0x3,%eax
  101ef5:	85 c0                	test   %eax,%eax
  101ef7:	75 31                	jne    101f2a <trap_dispatch+0x215>
            print_trapframe(tf);
  101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  101efc:	89 04 24             	mov    %eax,(%esp)
  101eff:	e8 95 fb ff ff       	call   101a99 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101f04:	c7 44 24 08 15 3c 10 	movl   $0x103c15,0x8(%esp)
  101f0b:	00 
  101f0c:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  101f13:	00 
  101f14:	c7 04 24 31 3c 10 00 	movl   $0x103c31,(%esp)
  101f1b:	e8 ab e4 ff ff       	call   1003cb <__panic>
        break;
  101f20:	90                   	nop
  101f21:	eb 07                	jmp    101f2a <trap_dispatch+0x215>
        break;
  101f23:	90                   	nop
  101f24:	eb 04                	jmp    101f2a <trap_dispatch+0x215>
        break;
  101f26:	90                   	nop
  101f27:	eb 01                	jmp    101f2a <trap_dispatch+0x215>
        break;
  101f29:	90                   	nop
        }
    }
}
  101f2a:	83 c4 2c             	add    $0x2c,%esp
  101f2d:	5b                   	pop    %ebx
  101f2e:	5e                   	pop    %esi
  101f2f:	5f                   	pop    %edi
  101f30:	5d                   	pop    %ebp
  101f31:	c3                   	ret    

00101f32 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f32:	55                   	push   %ebp
  101f33:	89 e5                	mov    %esp,%ebp
  101f35:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f38:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3b:	89 04 24             	mov    %eax,(%esp)
  101f3e:	e8 d2 fd ff ff       	call   101d15 <trap_dispatch>
}
  101f43:	c9                   	leave  
  101f44:	c3                   	ret    

00101f45 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f45:	6a 00                	push   $0x0
  pushl $0
  101f47:	6a 00                	push   $0x0
  jmp __alltraps
  101f49:	e9 67 0a 00 00       	jmp    1029b5 <__alltraps>

00101f4e <vector1>:
.globl vector1
vector1:
  pushl $0
  101f4e:	6a 00                	push   $0x0
  pushl $1
  101f50:	6a 01                	push   $0x1
  jmp __alltraps
  101f52:	e9 5e 0a 00 00       	jmp    1029b5 <__alltraps>

00101f57 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f57:	6a 00                	push   $0x0
  pushl $2
  101f59:	6a 02                	push   $0x2
  jmp __alltraps
  101f5b:	e9 55 0a 00 00       	jmp    1029b5 <__alltraps>

00101f60 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f60:	6a 00                	push   $0x0
  pushl $3
  101f62:	6a 03                	push   $0x3
  jmp __alltraps
  101f64:	e9 4c 0a 00 00       	jmp    1029b5 <__alltraps>

00101f69 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f69:	6a 00                	push   $0x0
  pushl $4
  101f6b:	6a 04                	push   $0x4
  jmp __alltraps
  101f6d:	e9 43 0a 00 00       	jmp    1029b5 <__alltraps>

00101f72 <vector5>:
.globl vector5
vector5:
  pushl $0
  101f72:	6a 00                	push   $0x0
  pushl $5
  101f74:	6a 05                	push   $0x5
  jmp __alltraps
  101f76:	e9 3a 0a 00 00       	jmp    1029b5 <__alltraps>

00101f7b <vector6>:
.globl vector6
vector6:
  pushl $0
  101f7b:	6a 00                	push   $0x0
  pushl $6
  101f7d:	6a 06                	push   $0x6
  jmp __alltraps
  101f7f:	e9 31 0a 00 00       	jmp    1029b5 <__alltraps>

00101f84 <vector7>:
.globl vector7
vector7:
  pushl $0
  101f84:	6a 00                	push   $0x0
  pushl $7
  101f86:	6a 07                	push   $0x7
  jmp __alltraps
  101f88:	e9 28 0a 00 00       	jmp    1029b5 <__alltraps>

00101f8d <vector8>:
.globl vector8
vector8:
  pushl $8
  101f8d:	6a 08                	push   $0x8
  jmp __alltraps
  101f8f:	e9 21 0a 00 00       	jmp    1029b5 <__alltraps>

00101f94 <vector9>:
.globl vector9
vector9:
  pushl $9
  101f94:	6a 09                	push   $0x9
  jmp __alltraps
  101f96:	e9 1a 0a 00 00       	jmp    1029b5 <__alltraps>

00101f9b <vector10>:
.globl vector10
vector10:
  pushl $10
  101f9b:	6a 0a                	push   $0xa
  jmp __alltraps
  101f9d:	e9 13 0a 00 00       	jmp    1029b5 <__alltraps>

00101fa2 <vector11>:
.globl vector11
vector11:
  pushl $11
  101fa2:	6a 0b                	push   $0xb
  jmp __alltraps
  101fa4:	e9 0c 0a 00 00       	jmp    1029b5 <__alltraps>

00101fa9 <vector12>:
.globl vector12
vector12:
  pushl $12
  101fa9:	6a 0c                	push   $0xc
  jmp __alltraps
  101fab:	e9 05 0a 00 00       	jmp    1029b5 <__alltraps>

00101fb0 <vector13>:
.globl vector13
vector13:
  pushl $13
  101fb0:	6a 0d                	push   $0xd
  jmp __alltraps
  101fb2:	e9 fe 09 00 00       	jmp    1029b5 <__alltraps>

00101fb7 <vector14>:
.globl vector14
vector14:
  pushl $14
  101fb7:	6a 0e                	push   $0xe
  jmp __alltraps
  101fb9:	e9 f7 09 00 00       	jmp    1029b5 <__alltraps>

00101fbe <vector15>:
.globl vector15
vector15:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $15
  101fc0:	6a 0f                	push   $0xf
  jmp __alltraps
  101fc2:	e9 ee 09 00 00       	jmp    1029b5 <__alltraps>

00101fc7 <vector16>:
.globl vector16
vector16:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $16
  101fc9:	6a 10                	push   $0x10
  jmp __alltraps
  101fcb:	e9 e5 09 00 00       	jmp    1029b5 <__alltraps>

00101fd0 <vector17>:
.globl vector17
vector17:
  pushl $17
  101fd0:	6a 11                	push   $0x11
  jmp __alltraps
  101fd2:	e9 de 09 00 00       	jmp    1029b5 <__alltraps>

00101fd7 <vector18>:
.globl vector18
vector18:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $18
  101fd9:	6a 12                	push   $0x12
  jmp __alltraps
  101fdb:	e9 d5 09 00 00       	jmp    1029b5 <__alltraps>

00101fe0 <vector19>:
.globl vector19
vector19:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $19
  101fe2:	6a 13                	push   $0x13
  jmp __alltraps
  101fe4:	e9 cc 09 00 00       	jmp    1029b5 <__alltraps>

00101fe9 <vector20>:
.globl vector20
vector20:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $20
  101feb:	6a 14                	push   $0x14
  jmp __alltraps
  101fed:	e9 c3 09 00 00       	jmp    1029b5 <__alltraps>

00101ff2 <vector21>:
.globl vector21
vector21:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $21
  101ff4:	6a 15                	push   $0x15
  jmp __alltraps
  101ff6:	e9 ba 09 00 00       	jmp    1029b5 <__alltraps>

00101ffb <vector22>:
.globl vector22
vector22:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $22
  101ffd:	6a 16                	push   $0x16
  jmp __alltraps
  101fff:	e9 b1 09 00 00       	jmp    1029b5 <__alltraps>

00102004 <vector23>:
.globl vector23
vector23:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $23
  102006:	6a 17                	push   $0x17
  jmp __alltraps
  102008:	e9 a8 09 00 00       	jmp    1029b5 <__alltraps>

0010200d <vector24>:
.globl vector24
vector24:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $24
  10200f:	6a 18                	push   $0x18
  jmp __alltraps
  102011:	e9 9f 09 00 00       	jmp    1029b5 <__alltraps>

00102016 <vector25>:
.globl vector25
vector25:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $25
  102018:	6a 19                	push   $0x19
  jmp __alltraps
  10201a:	e9 96 09 00 00       	jmp    1029b5 <__alltraps>

0010201f <vector26>:
.globl vector26
vector26:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $26
  102021:	6a 1a                	push   $0x1a
  jmp __alltraps
  102023:	e9 8d 09 00 00       	jmp    1029b5 <__alltraps>

00102028 <vector27>:
.globl vector27
vector27:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $27
  10202a:	6a 1b                	push   $0x1b
  jmp __alltraps
  10202c:	e9 84 09 00 00       	jmp    1029b5 <__alltraps>

00102031 <vector28>:
.globl vector28
vector28:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $28
  102033:	6a 1c                	push   $0x1c
  jmp __alltraps
  102035:	e9 7b 09 00 00       	jmp    1029b5 <__alltraps>

0010203a <vector29>:
.globl vector29
vector29:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $29
  10203c:	6a 1d                	push   $0x1d
  jmp __alltraps
  10203e:	e9 72 09 00 00       	jmp    1029b5 <__alltraps>

00102043 <vector30>:
.globl vector30
vector30:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $30
  102045:	6a 1e                	push   $0x1e
  jmp __alltraps
  102047:	e9 69 09 00 00       	jmp    1029b5 <__alltraps>

0010204c <vector31>:
.globl vector31
vector31:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $31
  10204e:	6a 1f                	push   $0x1f
  jmp __alltraps
  102050:	e9 60 09 00 00       	jmp    1029b5 <__alltraps>

00102055 <vector32>:
.globl vector32
vector32:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $32
  102057:	6a 20                	push   $0x20
  jmp __alltraps
  102059:	e9 57 09 00 00       	jmp    1029b5 <__alltraps>

0010205e <vector33>:
.globl vector33
vector33:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $33
  102060:	6a 21                	push   $0x21
  jmp __alltraps
  102062:	e9 4e 09 00 00       	jmp    1029b5 <__alltraps>

00102067 <vector34>:
.globl vector34
vector34:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $34
  102069:	6a 22                	push   $0x22
  jmp __alltraps
  10206b:	e9 45 09 00 00       	jmp    1029b5 <__alltraps>

00102070 <vector35>:
.globl vector35
vector35:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $35
  102072:	6a 23                	push   $0x23
  jmp __alltraps
  102074:	e9 3c 09 00 00       	jmp    1029b5 <__alltraps>

00102079 <vector36>:
.globl vector36
vector36:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $36
  10207b:	6a 24                	push   $0x24
  jmp __alltraps
  10207d:	e9 33 09 00 00       	jmp    1029b5 <__alltraps>

00102082 <vector37>:
.globl vector37
vector37:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $37
  102084:	6a 25                	push   $0x25
  jmp __alltraps
  102086:	e9 2a 09 00 00       	jmp    1029b5 <__alltraps>

0010208b <vector38>:
.globl vector38
vector38:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $38
  10208d:	6a 26                	push   $0x26
  jmp __alltraps
  10208f:	e9 21 09 00 00       	jmp    1029b5 <__alltraps>

00102094 <vector39>:
.globl vector39
vector39:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $39
  102096:	6a 27                	push   $0x27
  jmp __alltraps
  102098:	e9 18 09 00 00       	jmp    1029b5 <__alltraps>

0010209d <vector40>:
.globl vector40
vector40:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $40
  10209f:	6a 28                	push   $0x28
  jmp __alltraps
  1020a1:	e9 0f 09 00 00       	jmp    1029b5 <__alltraps>

001020a6 <vector41>:
.globl vector41
vector41:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $41
  1020a8:	6a 29                	push   $0x29
  jmp __alltraps
  1020aa:	e9 06 09 00 00       	jmp    1029b5 <__alltraps>

001020af <vector42>:
.globl vector42
vector42:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $42
  1020b1:	6a 2a                	push   $0x2a
  jmp __alltraps
  1020b3:	e9 fd 08 00 00       	jmp    1029b5 <__alltraps>

001020b8 <vector43>:
.globl vector43
vector43:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $43
  1020ba:	6a 2b                	push   $0x2b
  jmp __alltraps
  1020bc:	e9 f4 08 00 00       	jmp    1029b5 <__alltraps>

001020c1 <vector44>:
.globl vector44
vector44:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $44
  1020c3:	6a 2c                	push   $0x2c
  jmp __alltraps
  1020c5:	e9 eb 08 00 00       	jmp    1029b5 <__alltraps>

001020ca <vector45>:
.globl vector45
vector45:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $45
  1020cc:	6a 2d                	push   $0x2d
  jmp __alltraps
  1020ce:	e9 e2 08 00 00       	jmp    1029b5 <__alltraps>

001020d3 <vector46>:
.globl vector46
vector46:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $46
  1020d5:	6a 2e                	push   $0x2e
  jmp __alltraps
  1020d7:	e9 d9 08 00 00       	jmp    1029b5 <__alltraps>

001020dc <vector47>:
.globl vector47
vector47:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $47
  1020de:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020e0:	e9 d0 08 00 00       	jmp    1029b5 <__alltraps>

001020e5 <vector48>:
.globl vector48
vector48:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $48
  1020e7:	6a 30                	push   $0x30
  jmp __alltraps
  1020e9:	e9 c7 08 00 00       	jmp    1029b5 <__alltraps>

001020ee <vector49>:
.globl vector49
vector49:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $49
  1020f0:	6a 31                	push   $0x31
  jmp __alltraps
  1020f2:	e9 be 08 00 00       	jmp    1029b5 <__alltraps>

001020f7 <vector50>:
.globl vector50
vector50:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $50
  1020f9:	6a 32                	push   $0x32
  jmp __alltraps
  1020fb:	e9 b5 08 00 00       	jmp    1029b5 <__alltraps>

00102100 <vector51>:
.globl vector51
vector51:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $51
  102102:	6a 33                	push   $0x33
  jmp __alltraps
  102104:	e9 ac 08 00 00       	jmp    1029b5 <__alltraps>

00102109 <vector52>:
.globl vector52
vector52:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $52
  10210b:	6a 34                	push   $0x34
  jmp __alltraps
  10210d:	e9 a3 08 00 00       	jmp    1029b5 <__alltraps>

00102112 <vector53>:
.globl vector53
vector53:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $53
  102114:	6a 35                	push   $0x35
  jmp __alltraps
  102116:	e9 9a 08 00 00       	jmp    1029b5 <__alltraps>

0010211b <vector54>:
.globl vector54
vector54:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $54
  10211d:	6a 36                	push   $0x36
  jmp __alltraps
  10211f:	e9 91 08 00 00       	jmp    1029b5 <__alltraps>

00102124 <vector55>:
.globl vector55
vector55:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $55
  102126:	6a 37                	push   $0x37
  jmp __alltraps
  102128:	e9 88 08 00 00       	jmp    1029b5 <__alltraps>

0010212d <vector56>:
.globl vector56
vector56:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $56
  10212f:	6a 38                	push   $0x38
  jmp __alltraps
  102131:	e9 7f 08 00 00       	jmp    1029b5 <__alltraps>

00102136 <vector57>:
.globl vector57
vector57:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $57
  102138:	6a 39                	push   $0x39
  jmp __alltraps
  10213a:	e9 76 08 00 00       	jmp    1029b5 <__alltraps>

0010213f <vector58>:
.globl vector58
vector58:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $58
  102141:	6a 3a                	push   $0x3a
  jmp __alltraps
  102143:	e9 6d 08 00 00       	jmp    1029b5 <__alltraps>

00102148 <vector59>:
.globl vector59
vector59:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $59
  10214a:	6a 3b                	push   $0x3b
  jmp __alltraps
  10214c:	e9 64 08 00 00       	jmp    1029b5 <__alltraps>

00102151 <vector60>:
.globl vector60
vector60:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $60
  102153:	6a 3c                	push   $0x3c
  jmp __alltraps
  102155:	e9 5b 08 00 00       	jmp    1029b5 <__alltraps>

0010215a <vector61>:
.globl vector61
vector61:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $61
  10215c:	6a 3d                	push   $0x3d
  jmp __alltraps
  10215e:	e9 52 08 00 00       	jmp    1029b5 <__alltraps>

00102163 <vector62>:
.globl vector62
vector62:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $62
  102165:	6a 3e                	push   $0x3e
  jmp __alltraps
  102167:	e9 49 08 00 00       	jmp    1029b5 <__alltraps>

0010216c <vector63>:
.globl vector63
vector63:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $63
  10216e:	6a 3f                	push   $0x3f
  jmp __alltraps
  102170:	e9 40 08 00 00       	jmp    1029b5 <__alltraps>

00102175 <vector64>:
.globl vector64
vector64:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $64
  102177:	6a 40                	push   $0x40
  jmp __alltraps
  102179:	e9 37 08 00 00       	jmp    1029b5 <__alltraps>

0010217e <vector65>:
.globl vector65
vector65:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $65
  102180:	6a 41                	push   $0x41
  jmp __alltraps
  102182:	e9 2e 08 00 00       	jmp    1029b5 <__alltraps>

00102187 <vector66>:
.globl vector66
vector66:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $66
  102189:	6a 42                	push   $0x42
  jmp __alltraps
  10218b:	e9 25 08 00 00       	jmp    1029b5 <__alltraps>

00102190 <vector67>:
.globl vector67
vector67:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $67
  102192:	6a 43                	push   $0x43
  jmp __alltraps
  102194:	e9 1c 08 00 00       	jmp    1029b5 <__alltraps>

00102199 <vector68>:
.globl vector68
vector68:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $68
  10219b:	6a 44                	push   $0x44
  jmp __alltraps
  10219d:	e9 13 08 00 00       	jmp    1029b5 <__alltraps>

001021a2 <vector69>:
.globl vector69
vector69:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $69
  1021a4:	6a 45                	push   $0x45
  jmp __alltraps
  1021a6:	e9 0a 08 00 00       	jmp    1029b5 <__alltraps>

001021ab <vector70>:
.globl vector70
vector70:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $70
  1021ad:	6a 46                	push   $0x46
  jmp __alltraps
  1021af:	e9 01 08 00 00       	jmp    1029b5 <__alltraps>

001021b4 <vector71>:
.globl vector71
vector71:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $71
  1021b6:	6a 47                	push   $0x47
  jmp __alltraps
  1021b8:	e9 f8 07 00 00       	jmp    1029b5 <__alltraps>

001021bd <vector72>:
.globl vector72
vector72:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $72
  1021bf:	6a 48                	push   $0x48
  jmp __alltraps
  1021c1:	e9 ef 07 00 00       	jmp    1029b5 <__alltraps>

001021c6 <vector73>:
.globl vector73
vector73:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $73
  1021c8:	6a 49                	push   $0x49
  jmp __alltraps
  1021ca:	e9 e6 07 00 00       	jmp    1029b5 <__alltraps>

001021cf <vector74>:
.globl vector74
vector74:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $74
  1021d1:	6a 4a                	push   $0x4a
  jmp __alltraps
  1021d3:	e9 dd 07 00 00       	jmp    1029b5 <__alltraps>

001021d8 <vector75>:
.globl vector75
vector75:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $75
  1021da:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021dc:	e9 d4 07 00 00       	jmp    1029b5 <__alltraps>

001021e1 <vector76>:
.globl vector76
vector76:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $76
  1021e3:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021e5:	e9 cb 07 00 00       	jmp    1029b5 <__alltraps>

001021ea <vector77>:
.globl vector77
vector77:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $77
  1021ec:	6a 4d                	push   $0x4d
  jmp __alltraps
  1021ee:	e9 c2 07 00 00       	jmp    1029b5 <__alltraps>

001021f3 <vector78>:
.globl vector78
vector78:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $78
  1021f5:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021f7:	e9 b9 07 00 00       	jmp    1029b5 <__alltraps>

001021fc <vector79>:
.globl vector79
vector79:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $79
  1021fe:	6a 4f                	push   $0x4f
  jmp __alltraps
  102200:	e9 b0 07 00 00       	jmp    1029b5 <__alltraps>

00102205 <vector80>:
.globl vector80
vector80:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $80
  102207:	6a 50                	push   $0x50
  jmp __alltraps
  102209:	e9 a7 07 00 00       	jmp    1029b5 <__alltraps>

0010220e <vector81>:
.globl vector81
vector81:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $81
  102210:	6a 51                	push   $0x51
  jmp __alltraps
  102212:	e9 9e 07 00 00       	jmp    1029b5 <__alltraps>

00102217 <vector82>:
.globl vector82
vector82:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $82
  102219:	6a 52                	push   $0x52
  jmp __alltraps
  10221b:	e9 95 07 00 00       	jmp    1029b5 <__alltraps>

00102220 <vector83>:
.globl vector83
vector83:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $83
  102222:	6a 53                	push   $0x53
  jmp __alltraps
  102224:	e9 8c 07 00 00       	jmp    1029b5 <__alltraps>

00102229 <vector84>:
.globl vector84
vector84:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $84
  10222b:	6a 54                	push   $0x54
  jmp __alltraps
  10222d:	e9 83 07 00 00       	jmp    1029b5 <__alltraps>

00102232 <vector85>:
.globl vector85
vector85:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $85
  102234:	6a 55                	push   $0x55
  jmp __alltraps
  102236:	e9 7a 07 00 00       	jmp    1029b5 <__alltraps>

0010223b <vector86>:
.globl vector86
vector86:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $86
  10223d:	6a 56                	push   $0x56
  jmp __alltraps
  10223f:	e9 71 07 00 00       	jmp    1029b5 <__alltraps>

00102244 <vector87>:
.globl vector87
vector87:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $87
  102246:	6a 57                	push   $0x57
  jmp __alltraps
  102248:	e9 68 07 00 00       	jmp    1029b5 <__alltraps>

0010224d <vector88>:
.globl vector88
vector88:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $88
  10224f:	6a 58                	push   $0x58
  jmp __alltraps
  102251:	e9 5f 07 00 00       	jmp    1029b5 <__alltraps>

00102256 <vector89>:
.globl vector89
vector89:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $89
  102258:	6a 59                	push   $0x59
  jmp __alltraps
  10225a:	e9 56 07 00 00       	jmp    1029b5 <__alltraps>

0010225f <vector90>:
.globl vector90
vector90:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $90
  102261:	6a 5a                	push   $0x5a
  jmp __alltraps
  102263:	e9 4d 07 00 00       	jmp    1029b5 <__alltraps>

00102268 <vector91>:
.globl vector91
vector91:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $91
  10226a:	6a 5b                	push   $0x5b
  jmp __alltraps
  10226c:	e9 44 07 00 00       	jmp    1029b5 <__alltraps>

00102271 <vector92>:
.globl vector92
vector92:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $92
  102273:	6a 5c                	push   $0x5c
  jmp __alltraps
  102275:	e9 3b 07 00 00       	jmp    1029b5 <__alltraps>

0010227a <vector93>:
.globl vector93
vector93:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $93
  10227c:	6a 5d                	push   $0x5d
  jmp __alltraps
  10227e:	e9 32 07 00 00       	jmp    1029b5 <__alltraps>

00102283 <vector94>:
.globl vector94
vector94:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $94
  102285:	6a 5e                	push   $0x5e
  jmp __alltraps
  102287:	e9 29 07 00 00       	jmp    1029b5 <__alltraps>

0010228c <vector95>:
.globl vector95
vector95:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $95
  10228e:	6a 5f                	push   $0x5f
  jmp __alltraps
  102290:	e9 20 07 00 00       	jmp    1029b5 <__alltraps>

00102295 <vector96>:
.globl vector96
vector96:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $96
  102297:	6a 60                	push   $0x60
  jmp __alltraps
  102299:	e9 17 07 00 00       	jmp    1029b5 <__alltraps>

0010229e <vector97>:
.globl vector97
vector97:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $97
  1022a0:	6a 61                	push   $0x61
  jmp __alltraps
  1022a2:	e9 0e 07 00 00       	jmp    1029b5 <__alltraps>

001022a7 <vector98>:
.globl vector98
vector98:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $98
  1022a9:	6a 62                	push   $0x62
  jmp __alltraps
  1022ab:	e9 05 07 00 00       	jmp    1029b5 <__alltraps>

001022b0 <vector99>:
.globl vector99
vector99:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $99
  1022b2:	6a 63                	push   $0x63
  jmp __alltraps
  1022b4:	e9 fc 06 00 00       	jmp    1029b5 <__alltraps>

001022b9 <vector100>:
.globl vector100
vector100:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $100
  1022bb:	6a 64                	push   $0x64
  jmp __alltraps
  1022bd:	e9 f3 06 00 00       	jmp    1029b5 <__alltraps>

001022c2 <vector101>:
.globl vector101
vector101:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $101
  1022c4:	6a 65                	push   $0x65
  jmp __alltraps
  1022c6:	e9 ea 06 00 00       	jmp    1029b5 <__alltraps>

001022cb <vector102>:
.globl vector102
vector102:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $102
  1022cd:	6a 66                	push   $0x66
  jmp __alltraps
  1022cf:	e9 e1 06 00 00       	jmp    1029b5 <__alltraps>

001022d4 <vector103>:
.globl vector103
vector103:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $103
  1022d6:	6a 67                	push   $0x67
  jmp __alltraps
  1022d8:	e9 d8 06 00 00       	jmp    1029b5 <__alltraps>

001022dd <vector104>:
.globl vector104
vector104:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $104
  1022df:	6a 68                	push   $0x68
  jmp __alltraps
  1022e1:	e9 cf 06 00 00       	jmp    1029b5 <__alltraps>

001022e6 <vector105>:
.globl vector105
vector105:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $105
  1022e8:	6a 69                	push   $0x69
  jmp __alltraps
  1022ea:	e9 c6 06 00 00       	jmp    1029b5 <__alltraps>

001022ef <vector106>:
.globl vector106
vector106:
  pushl $0
  1022ef:	6a 00                	push   $0x0
  pushl $106
  1022f1:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022f3:	e9 bd 06 00 00       	jmp    1029b5 <__alltraps>

001022f8 <vector107>:
.globl vector107
vector107:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $107
  1022fa:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022fc:	e9 b4 06 00 00       	jmp    1029b5 <__alltraps>

00102301 <vector108>:
.globl vector108
vector108:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $108
  102303:	6a 6c                	push   $0x6c
  jmp __alltraps
  102305:	e9 ab 06 00 00       	jmp    1029b5 <__alltraps>

0010230a <vector109>:
.globl vector109
vector109:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $109
  10230c:	6a 6d                	push   $0x6d
  jmp __alltraps
  10230e:	e9 a2 06 00 00       	jmp    1029b5 <__alltraps>

00102313 <vector110>:
.globl vector110
vector110:
  pushl $0
  102313:	6a 00                	push   $0x0
  pushl $110
  102315:	6a 6e                	push   $0x6e
  jmp __alltraps
  102317:	e9 99 06 00 00       	jmp    1029b5 <__alltraps>

0010231c <vector111>:
.globl vector111
vector111:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $111
  10231e:	6a 6f                	push   $0x6f
  jmp __alltraps
  102320:	e9 90 06 00 00       	jmp    1029b5 <__alltraps>

00102325 <vector112>:
.globl vector112
vector112:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $112
  102327:	6a 70                	push   $0x70
  jmp __alltraps
  102329:	e9 87 06 00 00       	jmp    1029b5 <__alltraps>

0010232e <vector113>:
.globl vector113
vector113:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $113
  102330:	6a 71                	push   $0x71
  jmp __alltraps
  102332:	e9 7e 06 00 00       	jmp    1029b5 <__alltraps>

00102337 <vector114>:
.globl vector114
vector114:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $114
  102339:	6a 72                	push   $0x72
  jmp __alltraps
  10233b:	e9 75 06 00 00       	jmp    1029b5 <__alltraps>

00102340 <vector115>:
.globl vector115
vector115:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $115
  102342:	6a 73                	push   $0x73
  jmp __alltraps
  102344:	e9 6c 06 00 00       	jmp    1029b5 <__alltraps>

00102349 <vector116>:
.globl vector116
vector116:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $116
  10234b:	6a 74                	push   $0x74
  jmp __alltraps
  10234d:	e9 63 06 00 00       	jmp    1029b5 <__alltraps>

00102352 <vector117>:
.globl vector117
vector117:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $117
  102354:	6a 75                	push   $0x75
  jmp __alltraps
  102356:	e9 5a 06 00 00       	jmp    1029b5 <__alltraps>

0010235b <vector118>:
.globl vector118
vector118:
  pushl $0
  10235b:	6a 00                	push   $0x0
  pushl $118
  10235d:	6a 76                	push   $0x76
  jmp __alltraps
  10235f:	e9 51 06 00 00       	jmp    1029b5 <__alltraps>

00102364 <vector119>:
.globl vector119
vector119:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $119
  102366:	6a 77                	push   $0x77
  jmp __alltraps
  102368:	e9 48 06 00 00       	jmp    1029b5 <__alltraps>

0010236d <vector120>:
.globl vector120
vector120:
  pushl $0
  10236d:	6a 00                	push   $0x0
  pushl $120
  10236f:	6a 78                	push   $0x78
  jmp __alltraps
  102371:	e9 3f 06 00 00       	jmp    1029b5 <__alltraps>

00102376 <vector121>:
.globl vector121
vector121:
  pushl $0
  102376:	6a 00                	push   $0x0
  pushl $121
  102378:	6a 79                	push   $0x79
  jmp __alltraps
  10237a:	e9 36 06 00 00       	jmp    1029b5 <__alltraps>

0010237f <vector122>:
.globl vector122
vector122:
  pushl $0
  10237f:	6a 00                	push   $0x0
  pushl $122
  102381:	6a 7a                	push   $0x7a
  jmp __alltraps
  102383:	e9 2d 06 00 00       	jmp    1029b5 <__alltraps>

00102388 <vector123>:
.globl vector123
vector123:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $123
  10238a:	6a 7b                	push   $0x7b
  jmp __alltraps
  10238c:	e9 24 06 00 00       	jmp    1029b5 <__alltraps>

00102391 <vector124>:
.globl vector124
vector124:
  pushl $0
  102391:	6a 00                	push   $0x0
  pushl $124
  102393:	6a 7c                	push   $0x7c
  jmp __alltraps
  102395:	e9 1b 06 00 00       	jmp    1029b5 <__alltraps>

0010239a <vector125>:
.globl vector125
vector125:
  pushl $0
  10239a:	6a 00                	push   $0x0
  pushl $125
  10239c:	6a 7d                	push   $0x7d
  jmp __alltraps
  10239e:	e9 12 06 00 00       	jmp    1029b5 <__alltraps>

001023a3 <vector126>:
.globl vector126
vector126:
  pushl $0
  1023a3:	6a 00                	push   $0x0
  pushl $126
  1023a5:	6a 7e                	push   $0x7e
  jmp __alltraps
  1023a7:	e9 09 06 00 00       	jmp    1029b5 <__alltraps>

001023ac <vector127>:
.globl vector127
vector127:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $127
  1023ae:	6a 7f                	push   $0x7f
  jmp __alltraps
  1023b0:	e9 00 06 00 00       	jmp    1029b5 <__alltraps>

001023b5 <vector128>:
.globl vector128
vector128:
  pushl $0
  1023b5:	6a 00                	push   $0x0
  pushl $128
  1023b7:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1023bc:	e9 f4 05 00 00       	jmp    1029b5 <__alltraps>

001023c1 <vector129>:
.globl vector129
vector129:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $129
  1023c3:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1023c8:	e9 e8 05 00 00       	jmp    1029b5 <__alltraps>

001023cd <vector130>:
.globl vector130
vector130:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $130
  1023cf:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1023d4:	e9 dc 05 00 00       	jmp    1029b5 <__alltraps>

001023d9 <vector131>:
.globl vector131
vector131:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $131
  1023db:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023e0:	e9 d0 05 00 00       	jmp    1029b5 <__alltraps>

001023e5 <vector132>:
.globl vector132
vector132:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $132
  1023e7:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1023ec:	e9 c4 05 00 00       	jmp    1029b5 <__alltraps>

001023f1 <vector133>:
.globl vector133
vector133:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $133
  1023f3:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023f8:	e9 b8 05 00 00       	jmp    1029b5 <__alltraps>

001023fd <vector134>:
.globl vector134
vector134:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $134
  1023ff:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102404:	e9 ac 05 00 00       	jmp    1029b5 <__alltraps>

00102409 <vector135>:
.globl vector135
vector135:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $135
  10240b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102410:	e9 a0 05 00 00       	jmp    1029b5 <__alltraps>

00102415 <vector136>:
.globl vector136
vector136:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $136
  102417:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10241c:	e9 94 05 00 00       	jmp    1029b5 <__alltraps>

00102421 <vector137>:
.globl vector137
vector137:
  pushl $0
  102421:	6a 00                	push   $0x0
  pushl $137
  102423:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102428:	e9 88 05 00 00       	jmp    1029b5 <__alltraps>

0010242d <vector138>:
.globl vector138
vector138:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $138
  10242f:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102434:	e9 7c 05 00 00       	jmp    1029b5 <__alltraps>

00102439 <vector139>:
.globl vector139
vector139:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $139
  10243b:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102440:	e9 70 05 00 00       	jmp    1029b5 <__alltraps>

00102445 <vector140>:
.globl vector140
vector140:
  pushl $0
  102445:	6a 00                	push   $0x0
  pushl $140
  102447:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10244c:	e9 64 05 00 00       	jmp    1029b5 <__alltraps>

00102451 <vector141>:
.globl vector141
vector141:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $141
  102453:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102458:	e9 58 05 00 00       	jmp    1029b5 <__alltraps>

0010245d <vector142>:
.globl vector142
vector142:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $142
  10245f:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102464:	e9 4c 05 00 00       	jmp    1029b5 <__alltraps>

00102469 <vector143>:
.globl vector143
vector143:
  pushl $0
  102469:	6a 00                	push   $0x0
  pushl $143
  10246b:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102470:	e9 40 05 00 00       	jmp    1029b5 <__alltraps>

00102475 <vector144>:
.globl vector144
vector144:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $144
  102477:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10247c:	e9 34 05 00 00       	jmp    1029b5 <__alltraps>

00102481 <vector145>:
.globl vector145
vector145:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $145
  102483:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102488:	e9 28 05 00 00       	jmp    1029b5 <__alltraps>

0010248d <vector146>:
.globl vector146
vector146:
  pushl $0
  10248d:	6a 00                	push   $0x0
  pushl $146
  10248f:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102494:	e9 1c 05 00 00       	jmp    1029b5 <__alltraps>

00102499 <vector147>:
.globl vector147
vector147:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $147
  10249b:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1024a0:	e9 10 05 00 00       	jmp    1029b5 <__alltraps>

001024a5 <vector148>:
.globl vector148
vector148:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $148
  1024a7:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1024ac:	e9 04 05 00 00       	jmp    1029b5 <__alltraps>

001024b1 <vector149>:
.globl vector149
vector149:
  pushl $0
  1024b1:	6a 00                	push   $0x0
  pushl $149
  1024b3:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1024b8:	e9 f8 04 00 00       	jmp    1029b5 <__alltraps>

001024bd <vector150>:
.globl vector150
vector150:
  pushl $0
  1024bd:	6a 00                	push   $0x0
  pushl $150
  1024bf:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1024c4:	e9 ec 04 00 00       	jmp    1029b5 <__alltraps>

001024c9 <vector151>:
.globl vector151
vector151:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $151
  1024cb:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1024d0:	e9 e0 04 00 00       	jmp    1029b5 <__alltraps>

001024d5 <vector152>:
.globl vector152
vector152:
  pushl $0
  1024d5:	6a 00                	push   $0x0
  pushl $152
  1024d7:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024dc:	e9 d4 04 00 00       	jmp    1029b5 <__alltraps>

001024e1 <vector153>:
.globl vector153
vector153:
  pushl $0
  1024e1:	6a 00                	push   $0x0
  pushl $153
  1024e3:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1024e8:	e9 c8 04 00 00       	jmp    1029b5 <__alltraps>

001024ed <vector154>:
.globl vector154
vector154:
  pushl $0
  1024ed:	6a 00                	push   $0x0
  pushl $154
  1024ef:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024f4:	e9 bc 04 00 00       	jmp    1029b5 <__alltraps>

001024f9 <vector155>:
.globl vector155
vector155:
  pushl $0
  1024f9:	6a 00                	push   $0x0
  pushl $155
  1024fb:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102500:	e9 b0 04 00 00       	jmp    1029b5 <__alltraps>

00102505 <vector156>:
.globl vector156
vector156:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $156
  102507:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10250c:	e9 a4 04 00 00       	jmp    1029b5 <__alltraps>

00102511 <vector157>:
.globl vector157
vector157:
  pushl $0
  102511:	6a 00                	push   $0x0
  pushl $157
  102513:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102518:	e9 98 04 00 00       	jmp    1029b5 <__alltraps>

0010251d <vector158>:
.globl vector158
vector158:
  pushl $0
  10251d:	6a 00                	push   $0x0
  pushl $158
  10251f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102524:	e9 8c 04 00 00       	jmp    1029b5 <__alltraps>

00102529 <vector159>:
.globl vector159
vector159:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $159
  10252b:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102530:	e9 80 04 00 00       	jmp    1029b5 <__alltraps>

00102535 <vector160>:
.globl vector160
vector160:
  pushl $0
  102535:	6a 00                	push   $0x0
  pushl $160
  102537:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10253c:	e9 74 04 00 00       	jmp    1029b5 <__alltraps>

00102541 <vector161>:
.globl vector161
vector161:
  pushl $0
  102541:	6a 00                	push   $0x0
  pushl $161
  102543:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102548:	e9 68 04 00 00       	jmp    1029b5 <__alltraps>

0010254d <vector162>:
.globl vector162
vector162:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $162
  10254f:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102554:	e9 5c 04 00 00       	jmp    1029b5 <__alltraps>

00102559 <vector163>:
.globl vector163
vector163:
  pushl $0
  102559:	6a 00                	push   $0x0
  pushl $163
  10255b:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102560:	e9 50 04 00 00       	jmp    1029b5 <__alltraps>

00102565 <vector164>:
.globl vector164
vector164:
  pushl $0
  102565:	6a 00                	push   $0x0
  pushl $164
  102567:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10256c:	e9 44 04 00 00       	jmp    1029b5 <__alltraps>

00102571 <vector165>:
.globl vector165
vector165:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $165
  102573:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102578:	e9 38 04 00 00       	jmp    1029b5 <__alltraps>

0010257d <vector166>:
.globl vector166
vector166:
  pushl $0
  10257d:	6a 00                	push   $0x0
  pushl $166
  10257f:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102584:	e9 2c 04 00 00       	jmp    1029b5 <__alltraps>

00102589 <vector167>:
.globl vector167
vector167:
  pushl $0
  102589:	6a 00                	push   $0x0
  pushl $167
  10258b:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102590:	e9 20 04 00 00       	jmp    1029b5 <__alltraps>

00102595 <vector168>:
.globl vector168
vector168:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $168
  102597:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10259c:	e9 14 04 00 00       	jmp    1029b5 <__alltraps>

001025a1 <vector169>:
.globl vector169
vector169:
  pushl $0
  1025a1:	6a 00                	push   $0x0
  pushl $169
  1025a3:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1025a8:	e9 08 04 00 00       	jmp    1029b5 <__alltraps>

001025ad <vector170>:
.globl vector170
vector170:
  pushl $0
  1025ad:	6a 00                	push   $0x0
  pushl $170
  1025af:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1025b4:	e9 fc 03 00 00       	jmp    1029b5 <__alltraps>

001025b9 <vector171>:
.globl vector171
vector171:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $171
  1025bb:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1025c0:	e9 f0 03 00 00       	jmp    1029b5 <__alltraps>

001025c5 <vector172>:
.globl vector172
vector172:
  pushl $0
  1025c5:	6a 00                	push   $0x0
  pushl $172
  1025c7:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1025cc:	e9 e4 03 00 00       	jmp    1029b5 <__alltraps>

001025d1 <vector173>:
.globl vector173
vector173:
  pushl $0
  1025d1:	6a 00                	push   $0x0
  pushl $173
  1025d3:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1025d8:	e9 d8 03 00 00       	jmp    1029b5 <__alltraps>

001025dd <vector174>:
.globl vector174
vector174:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $174
  1025df:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025e4:	e9 cc 03 00 00       	jmp    1029b5 <__alltraps>

001025e9 <vector175>:
.globl vector175
vector175:
  pushl $0
  1025e9:	6a 00                	push   $0x0
  pushl $175
  1025eb:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025f0:	e9 c0 03 00 00       	jmp    1029b5 <__alltraps>

001025f5 <vector176>:
.globl vector176
vector176:
  pushl $0
  1025f5:	6a 00                	push   $0x0
  pushl $176
  1025f7:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025fc:	e9 b4 03 00 00       	jmp    1029b5 <__alltraps>

00102601 <vector177>:
.globl vector177
vector177:
  pushl $0
  102601:	6a 00                	push   $0x0
  pushl $177
  102603:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102608:	e9 a8 03 00 00       	jmp    1029b5 <__alltraps>

0010260d <vector178>:
.globl vector178
vector178:
  pushl $0
  10260d:	6a 00                	push   $0x0
  pushl $178
  10260f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102614:	e9 9c 03 00 00       	jmp    1029b5 <__alltraps>

00102619 <vector179>:
.globl vector179
vector179:
  pushl $0
  102619:	6a 00                	push   $0x0
  pushl $179
  10261b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102620:	e9 90 03 00 00       	jmp    1029b5 <__alltraps>

00102625 <vector180>:
.globl vector180
vector180:
  pushl $0
  102625:	6a 00                	push   $0x0
  pushl $180
  102627:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10262c:	e9 84 03 00 00       	jmp    1029b5 <__alltraps>

00102631 <vector181>:
.globl vector181
vector181:
  pushl $0
  102631:	6a 00                	push   $0x0
  pushl $181
  102633:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102638:	e9 78 03 00 00       	jmp    1029b5 <__alltraps>

0010263d <vector182>:
.globl vector182
vector182:
  pushl $0
  10263d:	6a 00                	push   $0x0
  pushl $182
  10263f:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102644:	e9 6c 03 00 00       	jmp    1029b5 <__alltraps>

00102649 <vector183>:
.globl vector183
vector183:
  pushl $0
  102649:	6a 00                	push   $0x0
  pushl $183
  10264b:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102650:	e9 60 03 00 00       	jmp    1029b5 <__alltraps>

00102655 <vector184>:
.globl vector184
vector184:
  pushl $0
  102655:	6a 00                	push   $0x0
  pushl $184
  102657:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10265c:	e9 54 03 00 00       	jmp    1029b5 <__alltraps>

00102661 <vector185>:
.globl vector185
vector185:
  pushl $0
  102661:	6a 00                	push   $0x0
  pushl $185
  102663:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102668:	e9 48 03 00 00       	jmp    1029b5 <__alltraps>

0010266d <vector186>:
.globl vector186
vector186:
  pushl $0
  10266d:	6a 00                	push   $0x0
  pushl $186
  10266f:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102674:	e9 3c 03 00 00       	jmp    1029b5 <__alltraps>

00102679 <vector187>:
.globl vector187
vector187:
  pushl $0
  102679:	6a 00                	push   $0x0
  pushl $187
  10267b:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102680:	e9 30 03 00 00       	jmp    1029b5 <__alltraps>

00102685 <vector188>:
.globl vector188
vector188:
  pushl $0
  102685:	6a 00                	push   $0x0
  pushl $188
  102687:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10268c:	e9 24 03 00 00       	jmp    1029b5 <__alltraps>

00102691 <vector189>:
.globl vector189
vector189:
  pushl $0
  102691:	6a 00                	push   $0x0
  pushl $189
  102693:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102698:	e9 18 03 00 00       	jmp    1029b5 <__alltraps>

0010269d <vector190>:
.globl vector190
vector190:
  pushl $0
  10269d:	6a 00                	push   $0x0
  pushl $190
  10269f:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1026a4:	e9 0c 03 00 00       	jmp    1029b5 <__alltraps>

001026a9 <vector191>:
.globl vector191
vector191:
  pushl $0
  1026a9:	6a 00                	push   $0x0
  pushl $191
  1026ab:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1026b0:	e9 00 03 00 00       	jmp    1029b5 <__alltraps>

001026b5 <vector192>:
.globl vector192
vector192:
  pushl $0
  1026b5:	6a 00                	push   $0x0
  pushl $192
  1026b7:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1026bc:	e9 f4 02 00 00       	jmp    1029b5 <__alltraps>

001026c1 <vector193>:
.globl vector193
vector193:
  pushl $0
  1026c1:	6a 00                	push   $0x0
  pushl $193
  1026c3:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1026c8:	e9 e8 02 00 00       	jmp    1029b5 <__alltraps>

001026cd <vector194>:
.globl vector194
vector194:
  pushl $0
  1026cd:	6a 00                	push   $0x0
  pushl $194
  1026cf:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1026d4:	e9 dc 02 00 00       	jmp    1029b5 <__alltraps>

001026d9 <vector195>:
.globl vector195
vector195:
  pushl $0
  1026d9:	6a 00                	push   $0x0
  pushl $195
  1026db:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026e0:	e9 d0 02 00 00       	jmp    1029b5 <__alltraps>

001026e5 <vector196>:
.globl vector196
vector196:
  pushl $0
  1026e5:	6a 00                	push   $0x0
  pushl $196
  1026e7:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1026ec:	e9 c4 02 00 00       	jmp    1029b5 <__alltraps>

001026f1 <vector197>:
.globl vector197
vector197:
  pushl $0
  1026f1:	6a 00                	push   $0x0
  pushl $197
  1026f3:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026f8:	e9 b8 02 00 00       	jmp    1029b5 <__alltraps>

001026fd <vector198>:
.globl vector198
vector198:
  pushl $0
  1026fd:	6a 00                	push   $0x0
  pushl $198
  1026ff:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102704:	e9 ac 02 00 00       	jmp    1029b5 <__alltraps>

00102709 <vector199>:
.globl vector199
vector199:
  pushl $0
  102709:	6a 00                	push   $0x0
  pushl $199
  10270b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102710:	e9 a0 02 00 00       	jmp    1029b5 <__alltraps>

00102715 <vector200>:
.globl vector200
vector200:
  pushl $0
  102715:	6a 00                	push   $0x0
  pushl $200
  102717:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10271c:	e9 94 02 00 00       	jmp    1029b5 <__alltraps>

00102721 <vector201>:
.globl vector201
vector201:
  pushl $0
  102721:	6a 00                	push   $0x0
  pushl $201
  102723:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102728:	e9 88 02 00 00       	jmp    1029b5 <__alltraps>

0010272d <vector202>:
.globl vector202
vector202:
  pushl $0
  10272d:	6a 00                	push   $0x0
  pushl $202
  10272f:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102734:	e9 7c 02 00 00       	jmp    1029b5 <__alltraps>

00102739 <vector203>:
.globl vector203
vector203:
  pushl $0
  102739:	6a 00                	push   $0x0
  pushl $203
  10273b:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102740:	e9 70 02 00 00       	jmp    1029b5 <__alltraps>

00102745 <vector204>:
.globl vector204
vector204:
  pushl $0
  102745:	6a 00                	push   $0x0
  pushl $204
  102747:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10274c:	e9 64 02 00 00       	jmp    1029b5 <__alltraps>

00102751 <vector205>:
.globl vector205
vector205:
  pushl $0
  102751:	6a 00                	push   $0x0
  pushl $205
  102753:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102758:	e9 58 02 00 00       	jmp    1029b5 <__alltraps>

0010275d <vector206>:
.globl vector206
vector206:
  pushl $0
  10275d:	6a 00                	push   $0x0
  pushl $206
  10275f:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102764:	e9 4c 02 00 00       	jmp    1029b5 <__alltraps>

00102769 <vector207>:
.globl vector207
vector207:
  pushl $0
  102769:	6a 00                	push   $0x0
  pushl $207
  10276b:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102770:	e9 40 02 00 00       	jmp    1029b5 <__alltraps>

00102775 <vector208>:
.globl vector208
vector208:
  pushl $0
  102775:	6a 00                	push   $0x0
  pushl $208
  102777:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10277c:	e9 34 02 00 00       	jmp    1029b5 <__alltraps>

00102781 <vector209>:
.globl vector209
vector209:
  pushl $0
  102781:	6a 00                	push   $0x0
  pushl $209
  102783:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102788:	e9 28 02 00 00       	jmp    1029b5 <__alltraps>

0010278d <vector210>:
.globl vector210
vector210:
  pushl $0
  10278d:	6a 00                	push   $0x0
  pushl $210
  10278f:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102794:	e9 1c 02 00 00       	jmp    1029b5 <__alltraps>

00102799 <vector211>:
.globl vector211
vector211:
  pushl $0
  102799:	6a 00                	push   $0x0
  pushl $211
  10279b:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1027a0:	e9 10 02 00 00       	jmp    1029b5 <__alltraps>

001027a5 <vector212>:
.globl vector212
vector212:
  pushl $0
  1027a5:	6a 00                	push   $0x0
  pushl $212
  1027a7:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1027ac:	e9 04 02 00 00       	jmp    1029b5 <__alltraps>

001027b1 <vector213>:
.globl vector213
vector213:
  pushl $0
  1027b1:	6a 00                	push   $0x0
  pushl $213
  1027b3:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1027b8:	e9 f8 01 00 00       	jmp    1029b5 <__alltraps>

001027bd <vector214>:
.globl vector214
vector214:
  pushl $0
  1027bd:	6a 00                	push   $0x0
  pushl $214
  1027bf:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1027c4:	e9 ec 01 00 00       	jmp    1029b5 <__alltraps>

001027c9 <vector215>:
.globl vector215
vector215:
  pushl $0
  1027c9:	6a 00                	push   $0x0
  pushl $215
  1027cb:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1027d0:	e9 e0 01 00 00       	jmp    1029b5 <__alltraps>

001027d5 <vector216>:
.globl vector216
vector216:
  pushl $0
  1027d5:	6a 00                	push   $0x0
  pushl $216
  1027d7:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027dc:	e9 d4 01 00 00       	jmp    1029b5 <__alltraps>

001027e1 <vector217>:
.globl vector217
vector217:
  pushl $0
  1027e1:	6a 00                	push   $0x0
  pushl $217
  1027e3:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1027e8:	e9 c8 01 00 00       	jmp    1029b5 <__alltraps>

001027ed <vector218>:
.globl vector218
vector218:
  pushl $0
  1027ed:	6a 00                	push   $0x0
  pushl $218
  1027ef:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027f4:	e9 bc 01 00 00       	jmp    1029b5 <__alltraps>

001027f9 <vector219>:
.globl vector219
vector219:
  pushl $0
  1027f9:	6a 00                	push   $0x0
  pushl $219
  1027fb:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102800:	e9 b0 01 00 00       	jmp    1029b5 <__alltraps>

00102805 <vector220>:
.globl vector220
vector220:
  pushl $0
  102805:	6a 00                	push   $0x0
  pushl $220
  102807:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10280c:	e9 a4 01 00 00       	jmp    1029b5 <__alltraps>

00102811 <vector221>:
.globl vector221
vector221:
  pushl $0
  102811:	6a 00                	push   $0x0
  pushl $221
  102813:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102818:	e9 98 01 00 00       	jmp    1029b5 <__alltraps>

0010281d <vector222>:
.globl vector222
vector222:
  pushl $0
  10281d:	6a 00                	push   $0x0
  pushl $222
  10281f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102824:	e9 8c 01 00 00       	jmp    1029b5 <__alltraps>

00102829 <vector223>:
.globl vector223
vector223:
  pushl $0
  102829:	6a 00                	push   $0x0
  pushl $223
  10282b:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102830:	e9 80 01 00 00       	jmp    1029b5 <__alltraps>

00102835 <vector224>:
.globl vector224
vector224:
  pushl $0
  102835:	6a 00                	push   $0x0
  pushl $224
  102837:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10283c:	e9 74 01 00 00       	jmp    1029b5 <__alltraps>

00102841 <vector225>:
.globl vector225
vector225:
  pushl $0
  102841:	6a 00                	push   $0x0
  pushl $225
  102843:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102848:	e9 68 01 00 00       	jmp    1029b5 <__alltraps>

0010284d <vector226>:
.globl vector226
vector226:
  pushl $0
  10284d:	6a 00                	push   $0x0
  pushl $226
  10284f:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102854:	e9 5c 01 00 00       	jmp    1029b5 <__alltraps>

00102859 <vector227>:
.globl vector227
vector227:
  pushl $0
  102859:	6a 00                	push   $0x0
  pushl $227
  10285b:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102860:	e9 50 01 00 00       	jmp    1029b5 <__alltraps>

00102865 <vector228>:
.globl vector228
vector228:
  pushl $0
  102865:	6a 00                	push   $0x0
  pushl $228
  102867:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10286c:	e9 44 01 00 00       	jmp    1029b5 <__alltraps>

00102871 <vector229>:
.globl vector229
vector229:
  pushl $0
  102871:	6a 00                	push   $0x0
  pushl $229
  102873:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102878:	e9 38 01 00 00       	jmp    1029b5 <__alltraps>

0010287d <vector230>:
.globl vector230
vector230:
  pushl $0
  10287d:	6a 00                	push   $0x0
  pushl $230
  10287f:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102884:	e9 2c 01 00 00       	jmp    1029b5 <__alltraps>

00102889 <vector231>:
.globl vector231
vector231:
  pushl $0
  102889:	6a 00                	push   $0x0
  pushl $231
  10288b:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102890:	e9 20 01 00 00       	jmp    1029b5 <__alltraps>

00102895 <vector232>:
.globl vector232
vector232:
  pushl $0
  102895:	6a 00                	push   $0x0
  pushl $232
  102897:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10289c:	e9 14 01 00 00       	jmp    1029b5 <__alltraps>

001028a1 <vector233>:
.globl vector233
vector233:
  pushl $0
  1028a1:	6a 00                	push   $0x0
  pushl $233
  1028a3:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1028a8:	e9 08 01 00 00       	jmp    1029b5 <__alltraps>

001028ad <vector234>:
.globl vector234
vector234:
  pushl $0
  1028ad:	6a 00                	push   $0x0
  pushl $234
  1028af:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1028b4:	e9 fc 00 00 00       	jmp    1029b5 <__alltraps>

001028b9 <vector235>:
.globl vector235
vector235:
  pushl $0
  1028b9:	6a 00                	push   $0x0
  pushl $235
  1028bb:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1028c0:	e9 f0 00 00 00       	jmp    1029b5 <__alltraps>

001028c5 <vector236>:
.globl vector236
vector236:
  pushl $0
  1028c5:	6a 00                	push   $0x0
  pushl $236
  1028c7:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1028cc:	e9 e4 00 00 00       	jmp    1029b5 <__alltraps>

001028d1 <vector237>:
.globl vector237
vector237:
  pushl $0
  1028d1:	6a 00                	push   $0x0
  pushl $237
  1028d3:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1028d8:	e9 d8 00 00 00       	jmp    1029b5 <__alltraps>

001028dd <vector238>:
.globl vector238
vector238:
  pushl $0
  1028dd:	6a 00                	push   $0x0
  pushl $238
  1028df:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028e4:	e9 cc 00 00 00       	jmp    1029b5 <__alltraps>

001028e9 <vector239>:
.globl vector239
vector239:
  pushl $0
  1028e9:	6a 00                	push   $0x0
  pushl $239
  1028eb:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028f0:	e9 c0 00 00 00       	jmp    1029b5 <__alltraps>

001028f5 <vector240>:
.globl vector240
vector240:
  pushl $0
  1028f5:	6a 00                	push   $0x0
  pushl $240
  1028f7:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028fc:	e9 b4 00 00 00       	jmp    1029b5 <__alltraps>

00102901 <vector241>:
.globl vector241
vector241:
  pushl $0
  102901:	6a 00                	push   $0x0
  pushl $241
  102903:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102908:	e9 a8 00 00 00       	jmp    1029b5 <__alltraps>

0010290d <vector242>:
.globl vector242
vector242:
  pushl $0
  10290d:	6a 00                	push   $0x0
  pushl $242
  10290f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102914:	e9 9c 00 00 00       	jmp    1029b5 <__alltraps>

00102919 <vector243>:
.globl vector243
vector243:
  pushl $0
  102919:	6a 00                	push   $0x0
  pushl $243
  10291b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102920:	e9 90 00 00 00       	jmp    1029b5 <__alltraps>

00102925 <vector244>:
.globl vector244
vector244:
  pushl $0
  102925:	6a 00                	push   $0x0
  pushl $244
  102927:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10292c:	e9 84 00 00 00       	jmp    1029b5 <__alltraps>

00102931 <vector245>:
.globl vector245
vector245:
  pushl $0
  102931:	6a 00                	push   $0x0
  pushl $245
  102933:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102938:	e9 78 00 00 00       	jmp    1029b5 <__alltraps>

0010293d <vector246>:
.globl vector246
vector246:
  pushl $0
  10293d:	6a 00                	push   $0x0
  pushl $246
  10293f:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102944:	e9 6c 00 00 00       	jmp    1029b5 <__alltraps>

00102949 <vector247>:
.globl vector247
vector247:
  pushl $0
  102949:	6a 00                	push   $0x0
  pushl $247
  10294b:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102950:	e9 60 00 00 00       	jmp    1029b5 <__alltraps>

00102955 <vector248>:
.globl vector248
vector248:
  pushl $0
  102955:	6a 00                	push   $0x0
  pushl $248
  102957:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10295c:	e9 54 00 00 00       	jmp    1029b5 <__alltraps>

00102961 <vector249>:
.globl vector249
vector249:
  pushl $0
  102961:	6a 00                	push   $0x0
  pushl $249
  102963:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102968:	e9 48 00 00 00       	jmp    1029b5 <__alltraps>

0010296d <vector250>:
.globl vector250
vector250:
  pushl $0
  10296d:	6a 00                	push   $0x0
  pushl $250
  10296f:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102974:	e9 3c 00 00 00       	jmp    1029b5 <__alltraps>

00102979 <vector251>:
.globl vector251
vector251:
  pushl $0
  102979:	6a 00                	push   $0x0
  pushl $251
  10297b:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102980:	e9 30 00 00 00       	jmp    1029b5 <__alltraps>

00102985 <vector252>:
.globl vector252
vector252:
  pushl $0
  102985:	6a 00                	push   $0x0
  pushl $252
  102987:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10298c:	e9 24 00 00 00       	jmp    1029b5 <__alltraps>

00102991 <vector253>:
.globl vector253
vector253:
  pushl $0
  102991:	6a 00                	push   $0x0
  pushl $253
  102993:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102998:	e9 18 00 00 00       	jmp    1029b5 <__alltraps>

0010299d <vector254>:
.globl vector254
vector254:
  pushl $0
  10299d:	6a 00                	push   $0x0
  pushl $254
  10299f:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1029a4:	e9 0c 00 00 00       	jmp    1029b5 <__alltraps>

001029a9 <vector255>:
.globl vector255
vector255:
  pushl $0
  1029a9:	6a 00                	push   $0x0
  pushl $255
  1029ab:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1029b0:	e9 00 00 00 00       	jmp    1029b5 <__alltraps>

001029b5 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1029b5:	1e                   	push   %ds
    pushl %es
  1029b6:	06                   	push   %es
    pushl %fs
  1029b7:	0f a0                	push   %fs
    pushl %gs
  1029b9:	0f a8                	push   %gs
    pushal
  1029bb:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1029bc:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1029c1:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1029c3:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1029c5:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1029c6:	e8 67 f5 ff ff       	call   101f32 <trap>

    # pop the pushed stack pointer
    popl %esp
  1029cb:	5c                   	pop    %esp

001029cc <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1029cc:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1029cd:	0f a9                	pop    %gs
    popl %fs
  1029cf:	0f a1                	pop    %fs
    popl %es
  1029d1:	07                   	pop    %es
    popl %ds
  1029d2:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1029d3:	83 c4 08             	add    $0x8,%esp
    iret
  1029d6:	cf                   	iret   

001029d7 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1029d7:	55                   	push   %ebp
  1029d8:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1029da:	8b 45 08             	mov    0x8(%ebp),%eax
  1029dd:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1029e0:	b8 23 00 00 00       	mov    $0x23,%eax
  1029e5:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1029e7:	b8 23 00 00 00       	mov    $0x23,%eax
  1029ec:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1029ee:	b8 10 00 00 00       	mov    $0x10,%eax
  1029f3:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1029f5:	b8 10 00 00 00       	mov    $0x10,%eax
  1029fa:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1029fc:	b8 10 00 00 00       	mov    $0x10,%eax
  102a01:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102a03:	ea 0a 2a 10 00 08 00 	ljmp   $0x8,$0x102a0a
}
  102a0a:	5d                   	pop    %ebp
  102a0b:	c3                   	ret    

00102a0c <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a0c:	55                   	push   %ebp
  102a0d:	89 e5                	mov    %esp,%ebp
  102a0f:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102a12:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  102a17:	05 00 04 00 00       	add    $0x400,%eax
  102a1c:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102a21:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102a28:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102a2a:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102a31:	68 00 
  102a33:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a38:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102a3e:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a43:	c1 e8 10             	shr    $0x10,%eax
  102a46:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102a4b:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a52:	83 e0 f0             	and    $0xfffffff0,%eax
  102a55:	83 c8 09             	or     $0x9,%eax
  102a58:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a5d:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a64:	83 c8 10             	or     $0x10,%eax
  102a67:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a6c:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a73:	83 e0 9f             	and    $0xffffff9f,%eax
  102a76:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a7b:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a82:	83 c8 80             	or     $0xffffff80,%eax
  102a85:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a8a:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a91:	83 e0 f0             	and    $0xfffffff0,%eax
  102a94:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a99:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102aa0:	83 e0 ef             	and    $0xffffffef,%eax
  102aa3:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102aa8:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102aaf:	83 e0 df             	and    $0xffffffdf,%eax
  102ab2:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102ab7:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102abe:	83 c8 40             	or     $0x40,%eax
  102ac1:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102ac6:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102acd:	83 e0 7f             	and    $0x7f,%eax
  102ad0:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102ad5:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102ada:	c1 e8 18             	shr    $0x18,%eax
  102add:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102ae2:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102ae9:	83 e0 ef             	and    $0xffffffef,%eax
  102aec:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102af1:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102af8:	e8 da fe ff ff       	call   1029d7 <lgdt>
  102afd:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102b03:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102b07:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102b0a:	c9                   	leave  
  102b0b:	c3                   	ret    

00102b0c <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102b0c:	55                   	push   %ebp
  102b0d:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102b0f:	e8 f8 fe ff ff       	call   102a0c <gdt_init>
}
  102b14:	5d                   	pop    %ebp
  102b15:	c3                   	ret    

00102b16 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102b16:	55                   	push   %ebp
  102b17:	89 e5                	mov    %esp,%ebp
  102b19:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102b1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102b23:	eb 04                	jmp    102b29 <strlen+0x13>
        cnt ++;
  102b25:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  102b29:	8b 45 08             	mov    0x8(%ebp),%eax
  102b2c:	0f b6 00             	movzbl (%eax),%eax
  102b2f:	84 c0                	test   %al,%al
  102b31:	0f 95 c0             	setne  %al
  102b34:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b38:	84 c0                	test   %al,%al
  102b3a:	75 e9                	jne    102b25 <strlen+0xf>
    }
    return cnt;
  102b3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102b3f:	c9                   	leave  
  102b40:	c3                   	ret    

00102b41 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102b41:	55                   	push   %ebp
  102b42:	89 e5                	mov    %esp,%ebp
  102b44:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102b47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102b4e:	eb 04                	jmp    102b54 <strnlen+0x13>
        cnt ++;
  102b50:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b57:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102b5a:	73 13                	jae    102b6f <strnlen+0x2e>
  102b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b5f:	0f b6 00             	movzbl (%eax),%eax
  102b62:	84 c0                	test   %al,%al
  102b64:	0f 95 c0             	setne  %al
  102b67:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b6b:	84 c0                	test   %al,%al
  102b6d:	75 e1                	jne    102b50 <strnlen+0xf>
    }
    return cnt;
  102b6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102b72:	c9                   	leave  
  102b73:	c3                   	ret    

00102b74 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102b74:	55                   	push   %ebp
  102b75:	89 e5                	mov    %esp,%ebp
  102b77:	57                   	push   %edi
  102b78:	56                   	push   %esi
  102b79:	53                   	push   %ebx
  102b7a:	83 ec 24             	sub    $0x24,%esp
  102b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b83:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b86:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102b89:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b8f:	89 d6                	mov    %edx,%esi
  102b91:	89 c3                	mov    %eax,%ebx
  102b93:	89 df                	mov    %ebx,%edi
  102b95:	ac                   	lods   %ds:(%esi),%al
  102b96:	aa                   	stos   %al,%es:(%edi)
  102b97:	84 c0                	test   %al,%al
  102b99:	75 fa                	jne    102b95 <strcpy+0x21>
  102b9b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102b9e:	89 fb                	mov    %edi,%ebx
  102ba0:	89 75 e8             	mov    %esi,-0x18(%ebp)
  102ba3:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  102ba6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ba9:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102baf:	83 c4 24             	add    $0x24,%esp
  102bb2:	5b                   	pop    %ebx
  102bb3:	5e                   	pop    %esi
  102bb4:	5f                   	pop    %edi
  102bb5:	5d                   	pop    %ebp
  102bb6:	c3                   	ret    

00102bb7 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102bb7:	55                   	push   %ebp
  102bb8:	89 e5                	mov    %esp,%ebp
  102bba:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102bc3:	eb 21                	jmp    102be6 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bc8:	0f b6 10             	movzbl (%eax),%edx
  102bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102bce:	88 10                	mov    %dl,(%eax)
  102bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102bd3:	0f b6 00             	movzbl (%eax),%eax
  102bd6:	84 c0                	test   %al,%al
  102bd8:	74 04                	je     102bde <strncpy+0x27>
            src ++;
  102bda:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102bde:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102be2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  102be6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102bea:	75 d9                	jne    102bc5 <strncpy+0xe>
    }
    return dst;
  102bec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102bef:	c9                   	leave  
  102bf0:	c3                   	ret    

00102bf1 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102bf1:	55                   	push   %ebp
  102bf2:	89 e5                	mov    %esp,%ebp
  102bf4:	57                   	push   %edi
  102bf5:	56                   	push   %esi
  102bf6:	53                   	push   %ebx
  102bf7:	83 ec 24             	sub    $0x24,%esp
  102bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  102bfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c03:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile (
  102c06:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102c09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102c0c:	89 d6                	mov    %edx,%esi
  102c0e:	89 c3                	mov    %eax,%ebx
  102c10:	89 df                	mov    %ebx,%edi
  102c12:	ac                   	lods   %ds:(%esi),%al
  102c13:	ae                   	scas   %es:(%edi),%al
  102c14:	75 08                	jne    102c1e <strcmp+0x2d>
  102c16:	84 c0                	test   %al,%al
  102c18:	75 f8                	jne    102c12 <strcmp+0x21>
  102c1a:	31 c0                	xor    %eax,%eax
  102c1c:	eb 04                	jmp    102c22 <strcmp+0x31>
  102c1e:	19 c0                	sbb    %eax,%eax
  102c20:	0c 01                	or     $0x1,%al
  102c22:	89 fb                	mov    %edi,%ebx
  102c24:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102c27:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c2d:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  102c30:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    return ret;
  102c33:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102c36:	83 c4 24             	add    $0x24,%esp
  102c39:	5b                   	pop    %ebx
  102c3a:	5e                   	pop    %esi
  102c3b:	5f                   	pop    %edi
  102c3c:	5d                   	pop    %ebp
  102c3d:	c3                   	ret    

00102c3e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102c3e:	55                   	push   %ebp
  102c3f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102c41:	eb 0c                	jmp    102c4f <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102c43:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102c47:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c4b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102c4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c53:	74 1a                	je     102c6f <strncmp+0x31>
  102c55:	8b 45 08             	mov    0x8(%ebp),%eax
  102c58:	0f b6 00             	movzbl (%eax),%eax
  102c5b:	84 c0                	test   %al,%al
  102c5d:	74 10                	je     102c6f <strncmp+0x31>
  102c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c62:	0f b6 10             	movzbl (%eax),%edx
  102c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c68:	0f b6 00             	movzbl (%eax),%eax
  102c6b:	38 c2                	cmp    %al,%dl
  102c6d:	74 d4                	je     102c43 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102c6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c73:	74 1a                	je     102c8f <strncmp+0x51>
  102c75:	8b 45 08             	mov    0x8(%ebp),%eax
  102c78:	0f b6 00             	movzbl (%eax),%eax
  102c7b:	0f b6 d0             	movzbl %al,%edx
  102c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c81:	0f b6 00             	movzbl (%eax),%eax
  102c84:	0f b6 c0             	movzbl %al,%eax
  102c87:	89 d1                	mov    %edx,%ecx
  102c89:	29 c1                	sub    %eax,%ecx
  102c8b:	89 c8                	mov    %ecx,%eax
  102c8d:	eb 05                	jmp    102c94 <strncmp+0x56>
  102c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c94:	5d                   	pop    %ebp
  102c95:	c3                   	ret    

00102c96 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102c96:	55                   	push   %ebp
  102c97:	89 e5                	mov    %esp,%ebp
  102c99:	83 ec 04             	sub    $0x4,%esp
  102c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c9f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102ca2:	eb 14                	jmp    102cb8 <strchr+0x22>
        if (*s == c) {
  102ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca7:	0f b6 00             	movzbl (%eax),%eax
  102caa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102cad:	75 05                	jne    102cb4 <strchr+0x1e>
            return (char *)s;
  102caf:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb2:	eb 13                	jmp    102cc7 <strchr+0x31>
        }
        s ++;
  102cb4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  102cbb:	0f b6 00             	movzbl (%eax),%eax
  102cbe:	84 c0                	test   %al,%al
  102cc0:	75 e2                	jne    102ca4 <strchr+0xe>
    }
    return NULL;
  102cc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102cc7:	c9                   	leave  
  102cc8:	c3                   	ret    

00102cc9 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102cc9:	55                   	push   %ebp
  102cca:	89 e5                	mov    %esp,%ebp
  102ccc:	83 ec 04             	sub    $0x4,%esp
  102ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cd2:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102cd5:	eb 0f                	jmp    102ce6 <strfind+0x1d>
        if (*s == c) {
  102cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  102cda:	0f b6 00             	movzbl (%eax),%eax
  102cdd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102ce0:	74 10                	je     102cf2 <strfind+0x29>
            break;
        }
        s ++;
  102ce2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce9:	0f b6 00             	movzbl (%eax),%eax
  102cec:	84 c0                	test   %al,%al
  102cee:	75 e7                	jne    102cd7 <strfind+0xe>
  102cf0:	eb 01                	jmp    102cf3 <strfind+0x2a>
            break;
  102cf2:	90                   	nop
    }
    return (char *)s;
  102cf3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102cf6:	c9                   	leave  
  102cf7:	c3                   	ret    

00102cf8 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102cf8:	55                   	push   %ebp
  102cf9:	89 e5                	mov    %esp,%ebp
  102cfb:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102cfe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102d05:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102d0c:	eb 04                	jmp    102d12 <strtol+0x1a>
        s ++;
  102d0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102d12:	8b 45 08             	mov    0x8(%ebp),%eax
  102d15:	0f b6 00             	movzbl (%eax),%eax
  102d18:	3c 20                	cmp    $0x20,%al
  102d1a:	74 f2                	je     102d0e <strtol+0x16>
  102d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1f:	0f b6 00             	movzbl (%eax),%eax
  102d22:	3c 09                	cmp    $0x9,%al
  102d24:	74 e8                	je     102d0e <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102d26:	8b 45 08             	mov    0x8(%ebp),%eax
  102d29:	0f b6 00             	movzbl (%eax),%eax
  102d2c:	3c 2b                	cmp    $0x2b,%al
  102d2e:	75 06                	jne    102d36 <strtol+0x3e>
        s ++;
  102d30:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d34:	eb 15                	jmp    102d4b <strtol+0x53>
    }
    else if (*s == '-') {
  102d36:	8b 45 08             	mov    0x8(%ebp),%eax
  102d39:	0f b6 00             	movzbl (%eax),%eax
  102d3c:	3c 2d                	cmp    $0x2d,%al
  102d3e:	75 0b                	jne    102d4b <strtol+0x53>
        s ++, neg = 1;
  102d40:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d44:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102d4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d4f:	74 06                	je     102d57 <strtol+0x5f>
  102d51:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102d55:	75 24                	jne    102d7b <strtol+0x83>
  102d57:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5a:	0f b6 00             	movzbl (%eax),%eax
  102d5d:	3c 30                	cmp    $0x30,%al
  102d5f:	75 1a                	jne    102d7b <strtol+0x83>
  102d61:	8b 45 08             	mov    0x8(%ebp),%eax
  102d64:	83 c0 01             	add    $0x1,%eax
  102d67:	0f b6 00             	movzbl (%eax),%eax
  102d6a:	3c 78                	cmp    $0x78,%al
  102d6c:	75 0d                	jne    102d7b <strtol+0x83>
        s += 2, base = 16;
  102d6e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102d72:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102d79:	eb 2a                	jmp    102da5 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102d7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d7f:	75 17                	jne    102d98 <strtol+0xa0>
  102d81:	8b 45 08             	mov    0x8(%ebp),%eax
  102d84:	0f b6 00             	movzbl (%eax),%eax
  102d87:	3c 30                	cmp    $0x30,%al
  102d89:	75 0d                	jne    102d98 <strtol+0xa0>
        s ++, base = 8;
  102d8b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d8f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102d96:	eb 0d                	jmp    102da5 <strtol+0xad>
    }
    else if (base == 0) {
  102d98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d9c:	75 07                	jne    102da5 <strtol+0xad>
        base = 10;
  102d9e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102da5:	8b 45 08             	mov    0x8(%ebp),%eax
  102da8:	0f b6 00             	movzbl (%eax),%eax
  102dab:	3c 2f                	cmp    $0x2f,%al
  102dad:	7e 1b                	jle    102dca <strtol+0xd2>
  102daf:	8b 45 08             	mov    0x8(%ebp),%eax
  102db2:	0f b6 00             	movzbl (%eax),%eax
  102db5:	3c 39                	cmp    $0x39,%al
  102db7:	7f 11                	jg     102dca <strtol+0xd2>
            dig = *s - '0';
  102db9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dbc:	0f b6 00             	movzbl (%eax),%eax
  102dbf:	0f be c0             	movsbl %al,%eax
  102dc2:	83 e8 30             	sub    $0x30,%eax
  102dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102dc8:	eb 48                	jmp    102e12 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102dca:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcd:	0f b6 00             	movzbl (%eax),%eax
  102dd0:	3c 60                	cmp    $0x60,%al
  102dd2:	7e 1b                	jle    102def <strtol+0xf7>
  102dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd7:	0f b6 00             	movzbl (%eax),%eax
  102dda:	3c 7a                	cmp    $0x7a,%al
  102ddc:	7f 11                	jg     102def <strtol+0xf7>
            dig = *s - 'a' + 10;
  102dde:	8b 45 08             	mov    0x8(%ebp),%eax
  102de1:	0f b6 00             	movzbl (%eax),%eax
  102de4:	0f be c0             	movsbl %al,%eax
  102de7:	83 e8 57             	sub    $0x57,%eax
  102dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ded:	eb 23                	jmp    102e12 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102def:	8b 45 08             	mov    0x8(%ebp),%eax
  102df2:	0f b6 00             	movzbl (%eax),%eax
  102df5:	3c 40                	cmp    $0x40,%al
  102df7:	7e 3c                	jle    102e35 <strtol+0x13d>
  102df9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfc:	0f b6 00             	movzbl (%eax),%eax
  102dff:	3c 5a                	cmp    $0x5a,%al
  102e01:	7f 32                	jg     102e35 <strtol+0x13d>
            dig = *s - 'A' + 10;
  102e03:	8b 45 08             	mov    0x8(%ebp),%eax
  102e06:	0f b6 00             	movzbl (%eax),%eax
  102e09:	0f be c0             	movsbl %al,%eax
  102e0c:	83 e8 37             	sub    $0x37,%eax
  102e0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e15:	3b 45 10             	cmp    0x10(%ebp),%eax
  102e18:	7d 1a                	jge    102e34 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102e1a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102e1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e21:	89 c2                	mov    %eax,%edx
  102e23:	0f af 55 10          	imul   0x10(%ebp),%edx
  102e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e2a:	01 d0                	add    %edx,%eax
  102e2c:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102e2f:	e9 71 ff ff ff       	jmp    102da5 <strtol+0xad>
            break;
  102e34:	90                   	nop

    if (endptr) {
  102e35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102e39:	74 08                	je     102e43 <strtol+0x14b>
        *endptr = (char *) s;
  102e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e3e:	8b 55 08             	mov    0x8(%ebp),%edx
  102e41:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102e43:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102e47:	74 07                	je     102e50 <strtol+0x158>
  102e49:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e4c:	f7 d8                	neg    %eax
  102e4e:	eb 03                	jmp    102e53 <strtol+0x15b>
  102e50:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102e53:	c9                   	leave  
  102e54:	c3                   	ret    

00102e55 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102e55:	55                   	push   %ebp
  102e56:	89 e5                	mov    %esp,%ebp
  102e58:	57                   	push   %edi
  102e59:	56                   	push   %esi
  102e5a:	53                   	push   %ebx
  102e5b:	83 ec 24             	sub    $0x24,%esp
  102e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e61:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102e64:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
  102e68:	8b 55 08             	mov    0x8(%ebp),%edx
  102e6b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102e6e:	88 45 ef             	mov    %al,-0x11(%ebp)
  102e71:	8b 45 10             	mov    0x10(%ebp),%eax
  102e74:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102e77:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  102e7a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  102e7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102e81:	89 ce                	mov    %ecx,%esi
  102e83:	89 d3                	mov    %edx,%ebx
  102e85:	89 f1                	mov    %esi,%ecx
  102e87:	89 df                	mov    %ebx,%edi
  102e89:	f3 aa                	rep stos %al,%es:(%edi)
  102e8b:	89 fb                	mov    %edi,%ebx
  102e8d:	89 ce                	mov    %ecx,%esi
  102e8f:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  102e92:	89 5d e0             	mov    %ebx,-0x20(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102e98:	83 c4 24             	add    $0x24,%esp
  102e9b:	5b                   	pop    %ebx
  102e9c:	5e                   	pop    %esi
  102e9d:	5f                   	pop    %edi
  102e9e:	5d                   	pop    %ebp
  102e9f:	c3                   	ret    

00102ea0 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102ea0:	55                   	push   %ebp
  102ea1:	89 e5                	mov    %esp,%ebp
  102ea3:	57                   	push   %edi
  102ea4:	56                   	push   %esi
  102ea5:	53                   	push   %ebx
  102ea6:	83 ec 38             	sub    $0x38,%esp
  102ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  102eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eb2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  102eb8:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ebe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102ec1:	73 4e                	jae    102f11 <memmove+0x71>
  102ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ec6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102ec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ecc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102ecf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ed2:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102ed5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ed8:	89 c1                	mov    %eax,%ecx
  102eda:	c1 e9 02             	shr    $0x2,%ecx
    asm volatile (
  102edd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ee0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ee3:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  102ee6:	89 d7                	mov    %edx,%edi
  102ee8:	89 c3                	mov    %eax,%ebx
  102eea:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  102eed:	89 de                	mov    %ebx,%esi
  102eef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102ef1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102ef4:	83 e1 03             	and    $0x3,%ecx
  102ef7:	74 02                	je     102efb <memmove+0x5b>
  102ef9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102efb:	89 f3                	mov    %esi,%ebx
  102efd:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  102f00:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  102f03:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102f06:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  102f09:	89 5d d0             	mov    %ebx,-0x30(%ebp)
            : "memory");
    return dst;
  102f0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102f0f:	eb 3e                	jmp    102f4f <memmove+0xaf>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102f11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f14:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f1a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  102f1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f20:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f26:	01 c2                	add    %eax,%edx
    asm volatile (
  102f28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f2b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102f2e:	89 ce                	mov    %ecx,%esi
  102f30:	89 d3                	mov    %edx,%ebx
  102f32:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  102f35:	89 df                	mov    %ebx,%edi
  102f37:	fd                   	std    
  102f38:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102f3a:	fc                   	cld    
  102f3b:	89 fb                	mov    %edi,%ebx
  102f3d:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  102f40:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  102f43:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102f46:	89 75 c8             	mov    %esi,-0x38(%ebp)
  102f49:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
    return dst;
  102f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102f4f:	83 c4 38             	add    $0x38,%esp
  102f52:	5b                   	pop    %ebx
  102f53:	5e                   	pop    %esi
  102f54:	5f                   	pop    %edi
  102f55:	5d                   	pop    %ebp
  102f56:	c3                   	ret    

00102f57 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102f57:	55                   	push   %ebp
  102f58:	89 e5                	mov    %esp,%ebp
  102f5a:	57                   	push   %edi
  102f5b:	56                   	push   %esi
  102f5c:	53                   	push   %ebx
  102f5d:	83 ec 24             	sub    $0x24,%esp
  102f60:	8b 45 08             	mov    0x8(%ebp),%eax
  102f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f69:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f6c:	8b 45 10             	mov    0x10(%ebp),%eax
  102f6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102f72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f75:	89 c1                	mov    %eax,%ecx
  102f77:	c1 e9 02             	shr    $0x2,%ecx
    asm volatile (
  102f7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f80:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  102f83:	89 d7                	mov    %edx,%edi
  102f85:	89 c3                	mov    %eax,%ebx
  102f87:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  102f8a:	89 de                	mov    %ebx,%esi
  102f8c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102f8e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  102f91:	83 e1 03             	and    $0x3,%ecx
  102f94:	74 02                	je     102f98 <memcpy+0x41>
  102f96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102f98:	89 f3                	mov    %esi,%ebx
  102f9a:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  102f9d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  102fa0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  102fa3:	89 7d e0             	mov    %edi,-0x20(%ebp)
  102fa6:	89 5d dc             	mov    %ebx,-0x24(%ebp)
    return dst;
  102fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102fac:	83 c4 24             	add    $0x24,%esp
  102faf:	5b                   	pop    %ebx
  102fb0:	5e                   	pop    %esi
  102fb1:	5f                   	pop    %edi
  102fb2:	5d                   	pop    %ebp
  102fb3:	c3                   	ret    

00102fb4 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102fb4:	55                   	push   %ebp
  102fb5:	89 e5                	mov    %esp,%ebp
  102fb7:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102fba:	8b 45 08             	mov    0x8(%ebp),%eax
  102fbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fc3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102fc6:	eb 32                	jmp    102ffa <memcmp+0x46>
        if (*s1 != *s2) {
  102fc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102fcb:	0f b6 10             	movzbl (%eax),%edx
  102fce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102fd1:	0f b6 00             	movzbl (%eax),%eax
  102fd4:	38 c2                	cmp    %al,%dl
  102fd6:	74 1a                	je     102ff2 <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102fd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102fdb:	0f b6 00             	movzbl (%eax),%eax
  102fde:	0f b6 d0             	movzbl %al,%edx
  102fe1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102fe4:	0f b6 00             	movzbl (%eax),%eax
  102fe7:	0f b6 c0             	movzbl %al,%eax
  102fea:	89 d1                	mov    %edx,%ecx
  102fec:	29 c1                	sub    %eax,%ecx
  102fee:	89 c8                	mov    %ecx,%eax
  102ff0:	eb 1c                	jmp    10300e <memcmp+0x5a>
        }
        s1 ++, s2 ++;
  102ff2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102ff6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  102ffa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ffe:	0f 95 c0             	setne  %al
  103001:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103005:	84 c0                	test   %al,%al
  103007:	75 bf                	jne    102fc8 <memcmp+0x14>
    }
    return 0;
  103009:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10300e:	c9                   	leave  
  10300f:	c3                   	ret    

00103010 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  103010:	55                   	push   %ebp
  103011:	89 e5                	mov    %esp,%ebp
  103013:	56                   	push   %esi
  103014:	53                   	push   %ebx
  103015:	83 ec 60             	sub    $0x60,%esp
  103018:	8b 45 10             	mov    0x10(%ebp),%eax
  10301b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10301e:	8b 45 14             	mov    0x14(%ebp),%eax
  103021:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  103024:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103027:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10302a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10302d:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  103030:	8b 45 18             	mov    0x18(%ebp),%eax
  103033:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103036:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103039:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10303c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10303f:	89 55 cc             	mov    %edx,-0x34(%ebp)
  103042:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103045:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103048:	89 d3                	mov    %edx,%ebx
  10304a:	89 c6                	mov    %eax,%esi
  10304c:	89 75 e0             	mov    %esi,-0x20(%ebp)
  10304f:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  103052:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103055:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103058:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10305c:	74 1c                	je     10307a <printnum+0x6a>
  10305e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103061:	ba 00 00 00 00       	mov    $0x0,%edx
  103066:	f7 75 e4             	divl   -0x1c(%ebp)
  103069:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10306c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10306f:	ba 00 00 00 00       	mov    $0x0,%edx
  103074:	f7 75 e4             	divl   -0x1c(%ebp)
  103077:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10307a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103080:	89 d6                	mov    %edx,%esi
  103082:	89 c3                	mov    %eax,%ebx
  103084:	89 f0                	mov    %esi,%eax
  103086:	89 da                	mov    %ebx,%edx
  103088:	f7 75 e4             	divl   -0x1c(%ebp)
  10308b:	89 d3                	mov    %edx,%ebx
  10308d:	89 c6                	mov    %eax,%esi
  10308f:	89 75 e0             	mov    %esi,-0x20(%ebp)
  103092:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  103095:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103098:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10309b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10309e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  1030a1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1030a4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1030a7:	89 c3                	mov    %eax,%ebx
  1030a9:	89 d6                	mov    %edx,%esi
  1030ab:	89 5d e8             	mov    %ebx,-0x18(%ebp)
  1030ae:	89 75 ec             	mov    %esi,-0x14(%ebp)
  1030b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1030b4:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1030b7:	8b 45 18             	mov    0x18(%ebp),%eax
  1030ba:	ba 00 00 00 00       	mov    $0x0,%edx
  1030bf:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1030c2:	77 56                	ja     10311a <printnum+0x10a>
  1030c4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1030c7:	72 05                	jb     1030ce <printnum+0xbe>
  1030c9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1030cc:	77 4c                	ja     10311a <printnum+0x10a>
        printnum(putch, putdat, result, base, width - 1, padc);
  1030ce:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1030d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030d4:	8b 45 20             	mov    0x20(%ebp),%eax
  1030d7:	89 44 24 18          	mov    %eax,0x18(%esp)
  1030db:	89 54 24 14          	mov    %edx,0x14(%esp)
  1030df:	8b 45 18             	mov    0x18(%ebp),%eax
  1030e2:	89 44 24 10          	mov    %eax,0x10(%esp)
  1030e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1030ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030f0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1030f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1030fe:	89 04 24             	mov    %eax,(%esp)
  103101:	e8 0a ff ff ff       	call   103010 <printnum>
  103106:	eb 1c                	jmp    103124 <printnum+0x114>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  103108:	8b 45 0c             	mov    0xc(%ebp),%eax
  10310b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10310f:	8b 45 20             	mov    0x20(%ebp),%eax
  103112:	89 04 24             	mov    %eax,(%esp)
  103115:	8b 45 08             	mov    0x8(%ebp),%eax
  103118:	ff d0                	call   *%eax
        while (-- width > 0)
  10311a:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10311e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103122:	7f e4                	jg     103108 <printnum+0xf8>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103124:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103127:	05 70 3e 10 00       	add    $0x103e70,%eax
  10312c:	0f b6 00             	movzbl (%eax),%eax
  10312f:	0f be c0             	movsbl %al,%eax
  103132:	8b 55 0c             	mov    0xc(%ebp),%edx
  103135:	89 54 24 04          	mov    %edx,0x4(%esp)
  103139:	89 04 24             	mov    %eax,(%esp)
  10313c:	8b 45 08             	mov    0x8(%ebp),%eax
  10313f:	ff d0                	call   *%eax
}
  103141:	83 c4 60             	add    $0x60,%esp
  103144:	5b                   	pop    %ebx
  103145:	5e                   	pop    %esi
  103146:	5d                   	pop    %ebp
  103147:	c3                   	ret    

00103148 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  103148:	55                   	push   %ebp
  103149:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10314b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10314f:	7e 14                	jle    103165 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  103151:	8b 45 08             	mov    0x8(%ebp),%eax
  103154:	8b 00                	mov    (%eax),%eax
  103156:	8d 48 08             	lea    0x8(%eax),%ecx
  103159:	8b 55 08             	mov    0x8(%ebp),%edx
  10315c:	89 0a                	mov    %ecx,(%edx)
  10315e:	8b 50 04             	mov    0x4(%eax),%edx
  103161:	8b 00                	mov    (%eax),%eax
  103163:	eb 30                	jmp    103195 <getuint+0x4d>
    }
    else if (lflag) {
  103165:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103169:	74 16                	je     103181 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10316b:	8b 45 08             	mov    0x8(%ebp),%eax
  10316e:	8b 00                	mov    (%eax),%eax
  103170:	8d 48 04             	lea    0x4(%eax),%ecx
  103173:	8b 55 08             	mov    0x8(%ebp),%edx
  103176:	89 0a                	mov    %ecx,(%edx)
  103178:	8b 00                	mov    (%eax),%eax
  10317a:	ba 00 00 00 00       	mov    $0x0,%edx
  10317f:	eb 14                	jmp    103195 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  103181:	8b 45 08             	mov    0x8(%ebp),%eax
  103184:	8b 00                	mov    (%eax),%eax
  103186:	8d 48 04             	lea    0x4(%eax),%ecx
  103189:	8b 55 08             	mov    0x8(%ebp),%edx
  10318c:	89 0a                	mov    %ecx,(%edx)
  10318e:	8b 00                	mov    (%eax),%eax
  103190:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  103195:	5d                   	pop    %ebp
  103196:	c3                   	ret    

00103197 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  103197:	55                   	push   %ebp
  103198:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10319a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10319e:	7e 14                	jle    1031b4 <getint+0x1d>
        return va_arg(*ap, long long);
  1031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a3:	8b 00                	mov    (%eax),%eax
  1031a5:	8d 48 08             	lea    0x8(%eax),%ecx
  1031a8:	8b 55 08             	mov    0x8(%ebp),%edx
  1031ab:	89 0a                	mov    %ecx,(%edx)
  1031ad:	8b 50 04             	mov    0x4(%eax),%edx
  1031b0:	8b 00                	mov    (%eax),%eax
  1031b2:	eb 30                	jmp    1031e4 <getint+0x4d>
    }
    else if (lflag) {
  1031b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1031b8:	74 16                	je     1031d0 <getint+0x39>
        return va_arg(*ap, long);
  1031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1031bd:	8b 00                	mov    (%eax),%eax
  1031bf:	8d 48 04             	lea    0x4(%eax),%ecx
  1031c2:	8b 55 08             	mov    0x8(%ebp),%edx
  1031c5:	89 0a                	mov    %ecx,(%edx)
  1031c7:	8b 00                	mov    (%eax),%eax
  1031c9:	89 c2                	mov    %eax,%edx
  1031cb:	c1 fa 1f             	sar    $0x1f,%edx
  1031ce:	eb 14                	jmp    1031e4 <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
  1031d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d3:	8b 00                	mov    (%eax),%eax
  1031d5:	8d 48 04             	lea    0x4(%eax),%ecx
  1031d8:	8b 55 08             	mov    0x8(%ebp),%edx
  1031db:	89 0a                	mov    %ecx,(%edx)
  1031dd:	8b 00                	mov    (%eax),%eax
  1031df:	89 c2                	mov    %eax,%edx
  1031e1:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
  1031e4:	5d                   	pop    %ebp
  1031e5:	c3                   	ret    

001031e6 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1031e6:	55                   	push   %ebp
  1031e7:	89 e5                	mov    %esp,%ebp
  1031e9:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1031ec:	8d 45 14             	lea    0x14(%ebp),%eax
  1031ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1031f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1031f9:	8b 45 10             	mov    0x10(%ebp),%eax
  1031fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  103200:	8b 45 0c             	mov    0xc(%ebp),%eax
  103203:	89 44 24 04          	mov    %eax,0x4(%esp)
  103207:	8b 45 08             	mov    0x8(%ebp),%eax
  10320a:	89 04 24             	mov    %eax,(%esp)
  10320d:	e8 02 00 00 00       	call   103214 <vprintfmt>
    va_end(ap);
}
  103212:	c9                   	leave  
  103213:	c3                   	ret    

00103214 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  103214:	55                   	push   %ebp
  103215:	89 e5                	mov    %esp,%ebp
  103217:	56                   	push   %esi
  103218:	53                   	push   %ebx
  103219:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10321c:	eb 17                	jmp    103235 <vprintfmt+0x21>
            if (ch == '\0') {
  10321e:	85 db                	test   %ebx,%ebx
  103220:	0f 84 db 03 00 00    	je     103601 <vprintfmt+0x3ed>
                return;
            }
            putch(ch, putdat);
  103226:	8b 45 0c             	mov    0xc(%ebp),%eax
  103229:	89 44 24 04          	mov    %eax,0x4(%esp)
  10322d:	89 1c 24             	mov    %ebx,(%esp)
  103230:	8b 45 08             	mov    0x8(%ebp),%eax
  103233:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103235:	8b 45 10             	mov    0x10(%ebp),%eax
  103238:	0f b6 00             	movzbl (%eax),%eax
  10323b:	0f b6 d8             	movzbl %al,%ebx
  10323e:	83 fb 25             	cmp    $0x25,%ebx
  103241:	0f 95 c0             	setne  %al
  103244:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  103248:	84 c0                	test   %al,%al
  10324a:	75 d2                	jne    10321e <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  10324c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103250:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  103257:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10325a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10325d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103264:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103267:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10326a:	eb 04                	jmp    103270 <vprintfmt+0x5c>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
  10326c:	90                   	nop
  10326d:	eb 01                	jmp    103270 <vprintfmt+0x5c>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
  10326f:	90                   	nop
        switch (ch = *(unsigned char *)fmt ++) {
  103270:	8b 45 10             	mov    0x10(%ebp),%eax
  103273:	0f b6 00             	movzbl (%eax),%eax
  103276:	0f b6 d8             	movzbl %al,%ebx
  103279:	89 d8                	mov    %ebx,%eax
  10327b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  10327f:	83 e8 23             	sub    $0x23,%eax
  103282:	83 f8 55             	cmp    $0x55,%eax
  103285:	0f 87 45 03 00 00    	ja     1035d0 <vprintfmt+0x3bc>
  10328b:	8b 04 85 94 3e 10 00 	mov    0x103e94(,%eax,4),%eax
  103292:	ff e0                	jmp    *%eax
            padc = '-';
  103294:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  103298:	eb d6                	jmp    103270 <vprintfmt+0x5c>
            padc = '0';
  10329a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10329e:	eb d0                	jmp    103270 <vprintfmt+0x5c>
            for (precision = 0; ; ++ fmt) {
  1032a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1032a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1032aa:	89 d0                	mov    %edx,%eax
  1032ac:	c1 e0 02             	shl    $0x2,%eax
  1032af:	01 d0                	add    %edx,%eax
  1032b1:	01 c0                	add    %eax,%eax
  1032b3:	01 d8                	add    %ebx,%eax
  1032b5:	83 e8 30             	sub    $0x30,%eax
  1032b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1032bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1032be:	0f b6 00             	movzbl (%eax),%eax
  1032c1:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1032c4:	83 fb 2f             	cmp    $0x2f,%ebx
  1032c7:	7e 39                	jle    103302 <vprintfmt+0xee>
  1032c9:	83 fb 39             	cmp    $0x39,%ebx
  1032cc:	7f 34                	jg     103302 <vprintfmt+0xee>
            for (precision = 0; ; ++ fmt) {
  1032ce:	83 45 10 01          	addl   $0x1,0x10(%ebp)
            }
  1032d2:	eb d3                	jmp    1032a7 <vprintfmt+0x93>
            precision = va_arg(ap, int);
  1032d4:	8b 45 14             	mov    0x14(%ebp),%eax
  1032d7:	8d 50 04             	lea    0x4(%eax),%edx
  1032da:	89 55 14             	mov    %edx,0x14(%ebp)
  1032dd:	8b 00                	mov    (%eax),%eax
  1032df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1032e2:	eb 1f                	jmp    103303 <vprintfmt+0xef>
            if (width < 0)
  1032e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032e8:	79 82                	jns    10326c <vprintfmt+0x58>
                width = 0;
  1032ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1032f1:	e9 76 ff ff ff       	jmp    10326c <vprintfmt+0x58>
            altflag = 1;
  1032f6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1032fd:	e9 6e ff ff ff       	jmp    103270 <vprintfmt+0x5c>
            goto process_precision;
  103302:	90                   	nop
            if (width < 0)
  103303:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103307:	0f 89 62 ff ff ff    	jns    10326f <vprintfmt+0x5b>
                width = precision, precision = -1;
  10330d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103310:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103313:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10331a:	e9 50 ff ff ff       	jmp    10326f <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10331f:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  103323:	e9 48 ff ff ff       	jmp    103270 <vprintfmt+0x5c>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103328:	8b 45 14             	mov    0x14(%ebp),%eax
  10332b:	8d 50 04             	lea    0x4(%eax),%edx
  10332e:	89 55 14             	mov    %edx,0x14(%ebp)
  103331:	8b 00                	mov    (%eax),%eax
  103333:	8b 55 0c             	mov    0xc(%ebp),%edx
  103336:	89 54 24 04          	mov    %edx,0x4(%esp)
  10333a:	89 04 24             	mov    %eax,(%esp)
  10333d:	8b 45 08             	mov    0x8(%ebp),%eax
  103340:	ff d0                	call   *%eax
            break;
  103342:	e9 b4 02 00 00       	jmp    1035fb <vprintfmt+0x3e7>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103347:	8b 45 14             	mov    0x14(%ebp),%eax
  10334a:	8d 50 04             	lea    0x4(%eax),%edx
  10334d:	89 55 14             	mov    %edx,0x14(%ebp)
  103350:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  103352:	85 db                	test   %ebx,%ebx
  103354:	79 02                	jns    103358 <vprintfmt+0x144>
                err = -err;
  103356:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103358:	83 fb 06             	cmp    $0x6,%ebx
  10335b:	7f 0b                	jg     103368 <vprintfmt+0x154>
  10335d:	8b 34 9d 54 3e 10 00 	mov    0x103e54(,%ebx,4),%esi
  103364:	85 f6                	test   %esi,%esi
  103366:	75 23                	jne    10338b <vprintfmt+0x177>
                printfmt(putch, putdat, "error %d", err);
  103368:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10336c:	c7 44 24 08 81 3e 10 	movl   $0x103e81,0x8(%esp)
  103373:	00 
  103374:	8b 45 0c             	mov    0xc(%ebp),%eax
  103377:	89 44 24 04          	mov    %eax,0x4(%esp)
  10337b:	8b 45 08             	mov    0x8(%ebp),%eax
  10337e:	89 04 24             	mov    %eax,(%esp)
  103381:	e8 60 fe ff ff       	call   1031e6 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103386:	e9 70 02 00 00       	jmp    1035fb <vprintfmt+0x3e7>
                printfmt(putch, putdat, "%s", p);
  10338b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10338f:	c7 44 24 08 8a 3e 10 	movl   $0x103e8a,0x8(%esp)
  103396:	00 
  103397:	8b 45 0c             	mov    0xc(%ebp),%eax
  10339a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10339e:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a1:	89 04 24             	mov    %eax,(%esp)
  1033a4:	e8 3d fe ff ff       	call   1031e6 <printfmt>
            break;
  1033a9:	e9 4d 02 00 00       	jmp    1035fb <vprintfmt+0x3e7>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1033ae:	8b 45 14             	mov    0x14(%ebp),%eax
  1033b1:	8d 50 04             	lea    0x4(%eax),%edx
  1033b4:	89 55 14             	mov    %edx,0x14(%ebp)
  1033b7:	8b 30                	mov    (%eax),%esi
  1033b9:	85 f6                	test   %esi,%esi
  1033bb:	75 05                	jne    1033c2 <vprintfmt+0x1ae>
                p = "(null)";
  1033bd:	be 8d 3e 10 00       	mov    $0x103e8d,%esi
            }
            if (width > 0 && padc != '-') {
  1033c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033c6:	7e 7c                	jle    103444 <vprintfmt+0x230>
  1033c8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1033cc:	74 76                	je     103444 <vprintfmt+0x230>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1033ce:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1033d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033d8:	89 34 24             	mov    %esi,(%esp)
  1033db:	e8 61 f7 ff ff       	call   102b41 <strnlen>
  1033e0:	89 da                	mov    %ebx,%edx
  1033e2:	29 c2                	sub    %eax,%edx
  1033e4:	89 d0                	mov    %edx,%eax
  1033e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033e9:	eb 17                	jmp    103402 <vprintfmt+0x1ee>
                    putch(padc, putdat);
  1033eb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1033ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  1033f2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1033f6:	89 04 24             	mov    %eax,(%esp)
  1033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033fc:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1033fe:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103402:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103406:	7f e3                	jg     1033eb <vprintfmt+0x1d7>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103408:	eb 3a                	jmp    103444 <vprintfmt+0x230>
                if (altflag && (ch < ' ' || ch > '~')) {
  10340a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10340e:	74 1f                	je     10342f <vprintfmt+0x21b>
  103410:	83 fb 1f             	cmp    $0x1f,%ebx
  103413:	7e 05                	jle    10341a <vprintfmt+0x206>
  103415:	83 fb 7e             	cmp    $0x7e,%ebx
  103418:	7e 15                	jle    10342f <vprintfmt+0x21b>
                    putch('?', putdat);
  10341a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10341d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103421:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103428:	8b 45 08             	mov    0x8(%ebp),%eax
  10342b:	ff d0                	call   *%eax
  10342d:	eb 0f                	jmp    10343e <vprintfmt+0x22a>
                }
                else {
                    putch(ch, putdat);
  10342f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103432:	89 44 24 04          	mov    %eax,0x4(%esp)
  103436:	89 1c 24             	mov    %ebx,(%esp)
  103439:	8b 45 08             	mov    0x8(%ebp),%eax
  10343c:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10343e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103442:	eb 01                	jmp    103445 <vprintfmt+0x231>
  103444:	90                   	nop
  103445:	0f b6 06             	movzbl (%esi),%eax
  103448:	0f be d8             	movsbl %al,%ebx
  10344b:	85 db                	test   %ebx,%ebx
  10344d:	0f 95 c0             	setne  %al
  103450:	83 c6 01             	add    $0x1,%esi
  103453:	84 c0                	test   %al,%al
  103455:	74 29                	je     103480 <vprintfmt+0x26c>
  103457:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10345b:	78 ad                	js     10340a <vprintfmt+0x1f6>
  10345d:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  103461:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103465:	79 a3                	jns    10340a <vprintfmt+0x1f6>
                }
            }
            for (; width > 0; width --) {
  103467:	eb 17                	jmp    103480 <vprintfmt+0x26c>
                putch(' ', putdat);
  103469:	8b 45 0c             	mov    0xc(%ebp),%eax
  10346c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103470:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  103477:	8b 45 08             	mov    0x8(%ebp),%eax
  10347a:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  10347c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103480:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103484:	7f e3                	jg     103469 <vprintfmt+0x255>
            }
            break;
  103486:	e9 70 01 00 00       	jmp    1035fb <vprintfmt+0x3e7>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10348b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10348e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103492:	8d 45 14             	lea    0x14(%ebp),%eax
  103495:	89 04 24             	mov    %eax,(%esp)
  103498:	e8 fa fc ff ff       	call   103197 <getint>
  10349d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1034a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034a9:	85 d2                	test   %edx,%edx
  1034ab:	79 26                	jns    1034d3 <vprintfmt+0x2bf>
                putch('-', putdat);
  1034ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034b4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1034be:	ff d0                	call   *%eax
                num = -(long long)num;
  1034c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034c6:	f7 d8                	neg    %eax
  1034c8:	83 d2 00             	adc    $0x0,%edx
  1034cb:	f7 da                	neg    %edx
  1034cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1034d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1034da:	e9 a8 00 00 00       	jmp    103587 <vprintfmt+0x373>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1034df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1034e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034e6:	8d 45 14             	lea    0x14(%ebp),%eax
  1034e9:	89 04 24             	mov    %eax,(%esp)
  1034ec:	e8 57 fc ff ff       	call   103148 <getuint>
  1034f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1034f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1034fe:	e9 84 00 00 00       	jmp    103587 <vprintfmt+0x373>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103503:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103506:	89 44 24 04          	mov    %eax,0x4(%esp)
  10350a:	8d 45 14             	lea    0x14(%ebp),%eax
  10350d:	89 04 24             	mov    %eax,(%esp)
  103510:	e8 33 fc ff ff       	call   103148 <getuint>
  103515:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103518:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10351b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103522:	eb 63                	jmp    103587 <vprintfmt+0x373>

        // pointer
        case 'p':
            putch('0', putdat);
  103524:	8b 45 0c             	mov    0xc(%ebp),%eax
  103527:	89 44 24 04          	mov    %eax,0x4(%esp)
  10352b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103532:	8b 45 08             	mov    0x8(%ebp),%eax
  103535:	ff d0                	call   *%eax
            putch('x', putdat);
  103537:	8b 45 0c             	mov    0xc(%ebp),%eax
  10353a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10353e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103545:	8b 45 08             	mov    0x8(%ebp),%eax
  103548:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10354a:	8b 45 14             	mov    0x14(%ebp),%eax
  10354d:	8d 50 04             	lea    0x4(%eax),%edx
  103550:	89 55 14             	mov    %edx,0x14(%ebp)
  103553:	8b 00                	mov    (%eax),%eax
  103555:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103558:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10355f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103566:	eb 1f                	jmp    103587 <vprintfmt+0x373>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103568:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10356b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10356f:	8d 45 14             	lea    0x14(%ebp),%eax
  103572:	89 04 24             	mov    %eax,(%esp)
  103575:	e8 ce fb ff ff       	call   103148 <getuint>
  10357a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10357d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103580:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103587:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10358b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10358e:	89 54 24 18          	mov    %edx,0x18(%esp)
  103592:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103595:	89 54 24 14          	mov    %edx,0x14(%esp)
  103599:	89 44 24 10          	mov    %eax,0x10(%esp)
  10359d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1035a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1035a7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1035ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1035b5:	89 04 24             	mov    %eax,(%esp)
  1035b8:	e8 53 fa ff ff       	call   103010 <printnum>
            break;
  1035bd:	eb 3c                	jmp    1035fb <vprintfmt+0x3e7>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1035bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035c6:	89 1c 24             	mov    %ebx,(%esp)
  1035c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1035cc:	ff d0                	call   *%eax
            break;
  1035ce:	eb 2b                	jmp    1035fb <vprintfmt+0x3e7>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1035d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035d7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1035de:	8b 45 08             	mov    0x8(%ebp),%eax
  1035e1:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1035e3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1035e7:	eb 04                	jmp    1035ed <vprintfmt+0x3d9>
  1035e9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1035ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1035f0:	83 e8 01             	sub    $0x1,%eax
  1035f3:	0f b6 00             	movzbl (%eax),%eax
  1035f6:	3c 25                	cmp    $0x25,%al
  1035f8:	75 ef                	jne    1035e9 <vprintfmt+0x3d5>
                /* do nothing */;
            break;
  1035fa:	90                   	nop
        }
    }
  1035fb:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1035fc:	e9 34 fc ff ff       	jmp    103235 <vprintfmt+0x21>
                return;
  103601:	90                   	nop
}
  103602:	83 c4 40             	add    $0x40,%esp
  103605:	5b                   	pop    %ebx
  103606:	5e                   	pop    %esi
  103607:	5d                   	pop    %ebp
  103608:	c3                   	ret    

00103609 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103609:	55                   	push   %ebp
  10360a:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10360c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10360f:	8b 40 08             	mov    0x8(%eax),%eax
  103612:	8d 50 01             	lea    0x1(%eax),%edx
  103615:	8b 45 0c             	mov    0xc(%ebp),%eax
  103618:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10361b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10361e:	8b 10                	mov    (%eax),%edx
  103620:	8b 45 0c             	mov    0xc(%ebp),%eax
  103623:	8b 40 04             	mov    0x4(%eax),%eax
  103626:	39 c2                	cmp    %eax,%edx
  103628:	73 12                	jae    10363c <sprintputch+0x33>
        *b->buf ++ = ch;
  10362a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10362d:	8b 00                	mov    (%eax),%eax
  10362f:	8b 55 08             	mov    0x8(%ebp),%edx
  103632:	88 10                	mov    %dl,(%eax)
  103634:	8d 50 01             	lea    0x1(%eax),%edx
  103637:	8b 45 0c             	mov    0xc(%ebp),%eax
  10363a:	89 10                	mov    %edx,(%eax)
    }
}
  10363c:	5d                   	pop    %ebp
  10363d:	c3                   	ret    

0010363e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10363e:	55                   	push   %ebp
  10363f:	89 e5                	mov    %esp,%ebp
  103641:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103644:	8d 45 14             	lea    0x14(%ebp),%eax
  103647:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10364a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10364d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103651:	8b 45 10             	mov    0x10(%ebp),%eax
  103654:	89 44 24 08          	mov    %eax,0x8(%esp)
  103658:	8b 45 0c             	mov    0xc(%ebp),%eax
  10365b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10365f:	8b 45 08             	mov    0x8(%ebp),%eax
  103662:	89 04 24             	mov    %eax,(%esp)
  103665:	e8 08 00 00 00       	call   103672 <vsnprintf>
  10366a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10366d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103670:	c9                   	leave  
  103671:	c3                   	ret    

00103672 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103672:	55                   	push   %ebp
  103673:	89 e5                	mov    %esp,%ebp
  103675:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103678:	8b 45 08             	mov    0x8(%ebp),%eax
  10367b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10367e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103681:	8d 50 ff             	lea    -0x1(%eax),%edx
  103684:	8b 45 08             	mov    0x8(%ebp),%eax
  103687:	01 d0                	add    %edx,%eax
  103689:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10368c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103693:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103697:	74 0a                	je     1036a3 <vsnprintf+0x31>
  103699:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10369c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10369f:	39 c2                	cmp    %eax,%edx
  1036a1:	76 07                	jbe    1036aa <vsnprintf+0x38>
        return -E_INVAL;
  1036a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1036a8:	eb 2a                	jmp    1036d4 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1036aa:	8b 45 14             	mov    0x14(%ebp),%eax
  1036ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1036b1:	8b 45 10             	mov    0x10(%ebp),%eax
  1036b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1036b8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1036bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036bf:	c7 04 24 09 36 10 00 	movl   $0x103609,(%esp)
  1036c6:	e8 49 fb ff ff       	call   103214 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1036cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036ce:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1036d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1036d4:	c9                   	leave  
  1036d5:	c3                   	ret    
