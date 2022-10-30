
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	f3 0f 1e fb          	endbr32 
  100004:	55                   	push   %ebp
  100005:	89 e5                	mov    %esp,%ebp
  100007:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10000a:	b8 20 1d 11 00       	mov    $0x111d20,%eax
  10000f:	2d 16 0a 11 00       	sub    $0x110a16,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 0a 11 00 	movl   $0x110a16,(%esp)
  100027:	e8 71 2f 00 00       	call   102f9d <memset>

    cons_init();                // init the console
  10002c:	e8 fc 15 00 00       	call   10162d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 e0 37 10 00 	movl   $0x1037e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 fc 37 10 00 	movl   $0x1037fc,(%esp)
  100046:	e8 49 02 00 00       	call   100294 <cprintf>

    print_kerninfo();
  10004b:	e8 07 09 00 00       	call   100957 <print_kerninfo>

    grade_backtrace();
  100050:	e8 9a 00 00 00       	call   1000ef <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 f2 2b 00 00       	call   102c4c <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 23 17 00 00       	call   101782 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 a3 18 00 00       	call   101907 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 49 0d 00 00       	call   100db2 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 60 18 00 00       	call   1018ce <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 87 01 00 00       	call   1001fa <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	f3 0f 1e fb          	endbr32 
  100079:	55                   	push   %ebp
  10007a:	89 e5                	mov    %esp,%ebp
  10007c:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100086:	00 
  100087:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008e:	00 
  10008f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100096:	e8 01 0d 00 00       	call   100d9c <mon_backtrace>
}
  10009b:	90                   	nop
  10009c:	c9                   	leave  
  10009d:	c3                   	ret    

0010009e <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10009e:	f3 0f 1e fb          	endbr32 
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	53                   	push   %ebx
  1000a6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a9:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000af:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000b5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000bd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000c1:	89 04 24             	mov    %eax,(%esp)
  1000c4:	e8 ac ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c9:	90                   	nop
  1000ca:	83 c4 14             	add    $0x14,%esp
  1000cd:	5b                   	pop    %ebx
  1000ce:	5d                   	pop    %ebp
  1000cf:	c3                   	ret    

001000d0 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000d0:	f3 0f 1e fb          	endbr32 
  1000d4:	55                   	push   %ebp
  1000d5:	89 e5                	mov    %esp,%ebp
  1000d7:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000da:	8b 45 10             	mov    0x10(%ebp),%eax
  1000dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e4:	89 04 24             	mov    %eax,(%esp)
  1000e7:	e8 b2 ff ff ff       	call   10009e <grade_backtrace1>
}
  1000ec:	90                   	nop
  1000ed:	c9                   	leave  
  1000ee:	c3                   	ret    

001000ef <grade_backtrace>:

void
grade_backtrace(void) {
  1000ef:	f3 0f 1e fb          	endbr32 
  1000f3:	55                   	push   %ebp
  1000f4:	89 e5                	mov    %esp,%ebp
  1000f6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f9:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000fe:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100105:	ff 
  100106:	89 44 24 04          	mov    %eax,0x4(%esp)
  10010a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100111:	e8 ba ff ff ff       	call   1000d0 <grade_backtrace0>
}
  100116:	90                   	nop
  100117:	c9                   	leave  
  100118:	c3                   	ret    

00100119 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100119:	f3 0f 1e fb          	endbr32 
  10011d:	55                   	push   %ebp
  10011e:	89 e5                	mov    %esp,%ebp
  100120:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100123:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100126:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100129:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10012c:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10012f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100133:	83 e0 03             	and    $0x3,%eax
  100136:	89 c2                	mov    %eax,%edx
  100138:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10013d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100141:	89 44 24 04          	mov    %eax,0x4(%esp)
  100145:	c7 04 24 01 38 10 00 	movl   $0x103801,(%esp)
  10014c:	e8 43 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	89 c2                	mov    %eax,%edx
  100157:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10015c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100160:	89 44 24 04          	mov    %eax,0x4(%esp)
  100164:	c7 04 24 0f 38 10 00 	movl   $0x10380f,(%esp)
  10016b:	e8 24 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100170:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100174:	89 c2                	mov    %eax,%edx
  100176:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10017b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100183:	c7 04 24 1d 38 10 00 	movl   $0x10381d,(%esp)
  10018a:	e8 05 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10018f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100193:	89 c2                	mov    %eax,%edx
  100195:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10019a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a2:	c7 04 24 2b 38 10 00 	movl   $0x10382b,(%esp)
  1001a9:	e8 e6 00 00 00       	call   100294 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001ae:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001b2:	89 c2                	mov    %eax,%edx
  1001b4:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 39 38 10 00 	movl   $0x103839,(%esp)
  1001c8:	e8 c7 00 00 00       	call   100294 <cprintf>
    round ++;
  1001cd:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001d2:	40                   	inc    %eax
  1001d3:	a3 20 0a 11 00       	mov    %eax,0x110a20
}
  1001d8:	90                   	nop
  1001d9:	c9                   	leave  
  1001da:	c3                   	ret    

001001db <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001db:	f3 0f 1e fb          	endbr32 
  1001df:	55                   	push   %ebp
  1001e0:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
  1001e2:	83 ec 08             	sub    $0x8,%esp
  1001e5:	cd 78                	int    $0x78
  1001e7:	89 ec                	mov    %ebp,%esp
        "int %0 \n"
        "movl %%ebp, %%esp"
        :
        : "i"(T_SWITCH_TOU)
    );
}
  1001e9:	90                   	nop
  1001ea:	5d                   	pop    %ebp
  1001eb:	c3                   	ret    

001001ec <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001ec:	f3 0f 1e fb          	endbr32 
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  1001f3:	cd 79                	int    $0x79
  1001f5:	89 ec                	mov    %ebp,%esp
        "int %0 \n"
        "movl %%ebp, %%esp \n"
        :
        : "i"(T_SWITCH_TOK)
    );
}
  1001f7:	90                   	nop
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	f3 0f 1e fb          	endbr32 
  1001fe:	55                   	push   %ebp
  1001ff:	89 e5                	mov    %esp,%ebp
  100201:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100204:	e8 10 ff ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100209:	c7 04 24 48 38 10 00 	movl   $0x103848,(%esp)
  100210:	e8 7f 00 00 00       	call   100294 <cprintf>
    lab1_switch_to_user();
  100215:	e8 c1 ff ff ff       	call   1001db <lab1_switch_to_user>
    lab1_print_cur_status();
  10021a:	e8 fa fe ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021f:	c7 04 24 68 38 10 00 	movl   $0x103868,(%esp)
  100226:	e8 69 00 00 00       	call   100294 <cprintf>
    lab1_switch_to_kernel();
  10022b:	e8 bc ff ff ff       	call   1001ec <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100230:	e8 e4 fe ff ff       	call   100119 <lab1_print_cur_status>
}
  100235:	90                   	nop
  100236:	c9                   	leave  
  100237:	c3                   	ret    

00100238 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100238:	f3 0f 1e fb          	endbr32 
  10023c:	55                   	push   %ebp
  10023d:	89 e5                	mov    %esp,%ebp
  10023f:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100242:	8b 45 08             	mov    0x8(%ebp),%eax
  100245:	89 04 24             	mov    %eax,(%esp)
  100248:	e8 11 14 00 00       	call   10165e <cons_putc>
    (*cnt) ++;
  10024d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100250:	8b 00                	mov    (%eax),%eax
  100252:	8d 50 01             	lea    0x1(%eax),%edx
  100255:	8b 45 0c             	mov    0xc(%ebp),%eax
  100258:	89 10                	mov    %edx,(%eax)
}
  10025a:	90                   	nop
  10025b:	c9                   	leave  
  10025c:	c3                   	ret    

0010025d <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10025d:	f3 0f 1e fb          	endbr32 
  100261:	55                   	push   %ebp
  100262:	89 e5                	mov    %esp,%ebp
  100264:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10026e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100271:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100275:	8b 45 08             	mov    0x8(%ebp),%eax
  100278:	89 44 24 08          	mov    %eax,0x8(%esp)
  10027c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10027f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100283:	c7 04 24 38 02 10 00 	movl   $0x100238,(%esp)
  10028a:	e8 7a 30 00 00       	call   103309 <vprintfmt>
    return cnt;
  10028f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100292:	c9                   	leave  
  100293:	c3                   	ret    

00100294 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100294:	f3 0f 1e fb          	endbr32 
  100298:	55                   	push   %ebp
  100299:	89 e5                	mov    %esp,%ebp
  10029b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10029e:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ae:	89 04 24             	mov    %eax,(%esp)
  1002b1:	e8 a7 ff ff ff       	call   10025d <vcprintf>
  1002b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002bc:	c9                   	leave  
  1002bd:	c3                   	ret    

001002be <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002be:	f3 0f 1e fb          	endbr32 
  1002c2:	55                   	push   %ebp
  1002c3:	89 e5                	mov    %esp,%ebp
  1002c5:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cb:	89 04 24             	mov    %eax,(%esp)
  1002ce:	e8 8b 13 00 00       	call   10165e <cons_putc>
}
  1002d3:	90                   	nop
  1002d4:	c9                   	leave  
  1002d5:	c3                   	ret    

001002d6 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002d6:	f3 0f 1e fb          	endbr32 
  1002da:	55                   	push   %ebp
  1002db:	89 e5                	mov    %esp,%ebp
  1002dd:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002e7:	eb 13                	jmp    1002fc <cputs+0x26>
        cputch(c, &cnt);
  1002e9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002ed:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002f4:	89 04 24             	mov    %eax,(%esp)
  1002f7:	e8 3c ff ff ff       	call   100238 <cputch>
    while ((c = *str ++) != '\0') {
  1002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	89 55 08             	mov    %edx,0x8(%ebp)
  100305:	0f b6 00             	movzbl (%eax),%eax
  100308:	88 45 f7             	mov    %al,-0x9(%ebp)
  10030b:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  10030f:	75 d8                	jne    1002e9 <cputs+0x13>
    }
    cputch('\n', &cnt);
  100311:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100314:	89 44 24 04          	mov    %eax,0x4(%esp)
  100318:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10031f:	e8 14 ff ff ff       	call   100238 <cputch>
    return cnt;
  100324:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100327:	c9                   	leave  
  100328:	c3                   	ret    

00100329 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100329:	f3 0f 1e fb          	endbr32 
  10032d:	55                   	push   %ebp
  10032e:	89 e5                	mov    %esp,%ebp
  100330:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100333:	90                   	nop
  100334:	e8 53 13 00 00       	call   10168c <cons_getc>
  100339:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10033c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100340:	74 f2                	je     100334 <getchar+0xb>
        /* do nothing */;
    return c;
  100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100345:	c9                   	leave  
  100346:	c3                   	ret    

00100347 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100347:	f3 0f 1e fb          	endbr32 
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100351:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100355:	74 13                	je     10036a <readline+0x23>
        cprintf("%s", prompt);
  100357:	8b 45 08             	mov    0x8(%ebp),%eax
  10035a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035e:	c7 04 24 87 38 10 00 	movl   $0x103887,(%esp)
  100365:	e8 2a ff ff ff       	call   100294 <cprintf>
    }
    int i = 0, c;
  10036a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100371:	e8 b3 ff ff ff       	call   100329 <getchar>
  100376:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100379:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10037d:	79 07                	jns    100386 <readline+0x3f>
            return NULL;
  10037f:	b8 00 00 00 00       	mov    $0x0,%eax
  100384:	eb 78                	jmp    1003fe <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100386:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10038a:	7e 28                	jle    1003b4 <readline+0x6d>
  10038c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100393:	7f 1f                	jg     1003b4 <readline+0x6d>
            cputchar(c);
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100398:	89 04 24             	mov    %eax,(%esp)
  10039b:	e8 1e ff ff ff       	call   1002be <cputchar>
            buf[i ++] = c;
  1003a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003a3:	8d 50 01             	lea    0x1(%eax),%edx
  1003a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003ac:	88 90 40 0a 11 00    	mov    %dl,0x110a40(%eax)
  1003b2:	eb 45                	jmp    1003f9 <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003b4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003b8:	75 16                	jne    1003d0 <readline+0x89>
  1003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003be:	7e 10                	jle    1003d0 <readline+0x89>
            cputchar(c);
  1003c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c3:	89 04 24             	mov    %eax,(%esp)
  1003c6:	e8 f3 fe ff ff       	call   1002be <cputchar>
            i --;
  1003cb:	ff 4d f4             	decl   -0xc(%ebp)
  1003ce:	eb 29                	jmp    1003f9 <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1003d0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003d4:	74 06                	je     1003dc <readline+0x95>
  1003d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003da:	75 95                	jne    100371 <readline+0x2a>
            cputchar(c);
  1003dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003df:	89 04 24             	mov    %eax,(%esp)
  1003e2:	e8 d7 fe ff ff       	call   1002be <cputchar>
            buf[i] = '\0';
  1003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ea:	05 40 0a 11 00       	add    $0x110a40,%eax
  1003ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003f2:	b8 40 0a 11 00       	mov    $0x110a40,%eax
  1003f7:	eb 05                	jmp    1003fe <readline+0xb7>
        c = getchar();
  1003f9:	e9 73 ff ff ff       	jmp    100371 <readline+0x2a>
        }
    }
}
  1003fe:	c9                   	leave  
  1003ff:	c3                   	ret    

00100400 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100400:	f3 0f 1e fb          	endbr32 
  100404:	55                   	push   %ebp
  100405:	89 e5                	mov    %esp,%ebp
  100407:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  10040a:	a1 40 0e 11 00       	mov    0x110e40,%eax
  10040f:	85 c0                	test   %eax,%eax
  100411:	75 5b                	jne    10046e <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100413:	c7 05 40 0e 11 00 01 	movl   $0x1,0x110e40
  10041a:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10041d:	8d 45 14             	lea    0x14(%ebp),%eax
  100420:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100423:	8b 45 0c             	mov    0xc(%ebp),%eax
  100426:	89 44 24 08          	mov    %eax,0x8(%esp)
  10042a:	8b 45 08             	mov    0x8(%ebp),%eax
  10042d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100431:	c7 04 24 8a 38 10 00 	movl   $0x10388a,(%esp)
  100438:	e8 57 fe ff ff       	call   100294 <cprintf>
    vcprintf(fmt, ap);
  10043d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100440:	89 44 24 04          	mov    %eax,0x4(%esp)
  100444:	8b 45 10             	mov    0x10(%ebp),%eax
  100447:	89 04 24             	mov    %eax,(%esp)
  10044a:	e8 0e fe ff ff       	call   10025d <vcprintf>
    cprintf("\n");
  10044f:	c7 04 24 a6 38 10 00 	movl   $0x1038a6,(%esp)
  100456:	e8 39 fe ff ff       	call   100294 <cprintf>
    
    cprintf("stack trackback:\n");
  10045b:	c7 04 24 a8 38 10 00 	movl   $0x1038a8,(%esp)
  100462:	e8 2d fe ff ff       	call   100294 <cprintf>
    print_stackframe();
  100467:	e8 3d 06 00 00       	call   100aa9 <print_stackframe>
  10046c:	eb 01                	jmp    10046f <__panic+0x6f>
        goto panic_dead;
  10046e:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10046f:	e8 66 14 00 00       	call   1018da <intr_disable>
    while (1) {
        kmonitor(NULL);
  100474:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10047b:	e8 43 08 00 00       	call   100cc3 <kmonitor>
  100480:	eb f2                	jmp    100474 <__panic+0x74>

00100482 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100482:	f3 0f 1e fb          	endbr32 
  100486:	55                   	push   %ebp
  100487:	89 e5                	mov    %esp,%ebp
  100489:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10048c:	8d 45 14             	lea    0x14(%ebp),%eax
  10048f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100492:	8b 45 0c             	mov    0xc(%ebp),%eax
  100495:	89 44 24 08          	mov    %eax,0x8(%esp)
  100499:	8b 45 08             	mov    0x8(%ebp),%eax
  10049c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004a0:	c7 04 24 ba 38 10 00 	movl   $0x1038ba,(%esp)
  1004a7:	e8 e8 fd ff ff       	call   100294 <cprintf>
    vcprintf(fmt, ap);
  1004ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004b3:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b6:	89 04 24             	mov    %eax,(%esp)
  1004b9:	e8 9f fd ff ff       	call   10025d <vcprintf>
    cprintf("\n");
  1004be:	c7 04 24 a6 38 10 00 	movl   $0x1038a6,(%esp)
  1004c5:	e8 ca fd ff ff       	call   100294 <cprintf>
    va_end(ap);
}
  1004ca:	90                   	nop
  1004cb:	c9                   	leave  
  1004cc:	c3                   	ret    

001004cd <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004cd:	f3 0f 1e fb          	endbr32 
  1004d1:	55                   	push   %ebp
  1004d2:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004d4:	a1 40 0e 11 00       	mov    0x110e40,%eax
}
  1004d9:	5d                   	pop    %ebp
  1004da:	c3                   	ret    

001004db <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004db:	f3 0f 1e fb          	endbr32 
  1004df:	55                   	push   %ebp
  1004e0:	89 e5                	mov    %esp,%ebp
  1004e2:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e8:	8b 00                	mov    (%eax),%eax
  1004ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f0:	8b 00                	mov    (%eax),%eax
  1004f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004fc:	e9 ca 00 00 00       	jmp    1005cb <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100501:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100504:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100507:	01 d0                	add    %edx,%eax
  100509:	89 c2                	mov    %eax,%edx
  10050b:	c1 ea 1f             	shr    $0x1f,%edx
  10050e:	01 d0                	add    %edx,%eax
  100510:	d1 f8                	sar    %eax
  100512:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100518:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10051b:	eb 03                	jmp    100520 <stab_binsearch+0x45>
            m --;
  10051d:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100523:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100526:	7c 1f                	jl     100547 <stab_binsearch+0x6c>
  100528:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10052b:	89 d0                	mov    %edx,%eax
  10052d:	01 c0                	add    %eax,%eax
  10052f:	01 d0                	add    %edx,%eax
  100531:	c1 e0 02             	shl    $0x2,%eax
  100534:	89 c2                	mov    %eax,%edx
  100536:	8b 45 08             	mov    0x8(%ebp),%eax
  100539:	01 d0                	add    %edx,%eax
  10053b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10053f:	0f b6 c0             	movzbl %al,%eax
  100542:	39 45 14             	cmp    %eax,0x14(%ebp)
  100545:	75 d6                	jne    10051d <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  100547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10054d:	7d 09                	jge    100558 <stab_binsearch+0x7d>
            l = true_m + 1;
  10054f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100552:	40                   	inc    %eax
  100553:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100556:	eb 73                	jmp    1005cb <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  100558:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10055f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100562:	89 d0                	mov    %edx,%eax
  100564:	01 c0                	add    %eax,%eax
  100566:	01 d0                	add    %edx,%eax
  100568:	c1 e0 02             	shl    $0x2,%eax
  10056b:	89 c2                	mov    %eax,%edx
  10056d:	8b 45 08             	mov    0x8(%ebp),%eax
  100570:	01 d0                	add    %edx,%eax
  100572:	8b 40 08             	mov    0x8(%eax),%eax
  100575:	39 45 18             	cmp    %eax,0x18(%ebp)
  100578:	76 11                	jbe    10058b <stab_binsearch+0xb0>
            *region_left = m;
  10057a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100580:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100582:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100585:	40                   	inc    %eax
  100586:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100589:	eb 40                	jmp    1005cb <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	89 d0                	mov    %edx,%eax
  100590:	01 c0                	add    %eax,%eax
  100592:	01 d0                	add    %edx,%eax
  100594:	c1 e0 02             	shl    $0x2,%eax
  100597:	89 c2                	mov    %eax,%edx
  100599:	8b 45 08             	mov    0x8(%ebp),%eax
  10059c:	01 d0                	add    %edx,%eax
  10059e:	8b 40 08             	mov    0x8(%eax),%eax
  1005a1:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005a4:	73 14                	jae    1005ba <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1005af:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005b4:	48                   	dec    %eax
  1005b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005b8:	eb 11                	jmp    1005cb <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c0:	89 10                	mov    %edx,(%eax)
            l = m;
  1005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005c8:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005d1:	0f 8e 2a ff ff ff    	jle    100501 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  1005d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005db:	75 0f                	jne    1005ec <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  1005dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e0:	8b 00                	mov    (%eax),%eax
  1005e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1005e8:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005ea:	eb 3e                	jmp    10062a <stab_binsearch+0x14f>
        l = *region_right;
  1005ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1005ef:	8b 00                	mov    (%eax),%eax
  1005f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005f4:	eb 03                	jmp    1005f9 <stab_binsearch+0x11e>
  1005f6:	ff 4d fc             	decl   -0x4(%ebp)
  1005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fc:	8b 00                	mov    (%eax),%eax
  1005fe:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100601:	7e 1f                	jle    100622 <stab_binsearch+0x147>
  100603:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100606:	89 d0                	mov    %edx,%eax
  100608:	01 c0                	add    %eax,%eax
  10060a:	01 d0                	add    %edx,%eax
  10060c:	c1 e0 02             	shl    $0x2,%eax
  10060f:	89 c2                	mov    %eax,%edx
  100611:	8b 45 08             	mov    0x8(%ebp),%eax
  100614:	01 d0                	add    %edx,%eax
  100616:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10061a:	0f b6 c0             	movzbl %al,%eax
  10061d:	39 45 14             	cmp    %eax,0x14(%ebp)
  100620:	75 d4                	jne    1005f6 <stab_binsearch+0x11b>
        *region_left = l;
  100622:	8b 45 0c             	mov    0xc(%ebp),%eax
  100625:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100628:	89 10                	mov    %edx,(%eax)
}
  10062a:	90                   	nop
  10062b:	c9                   	leave  
  10062c:	c3                   	ret    

0010062d <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10062d:	f3 0f 1e fb          	endbr32 
  100631:	55                   	push   %ebp
  100632:	89 e5                	mov    %esp,%ebp
  100634:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100637:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063a:	c7 00 d8 38 10 00    	movl   $0x1038d8,(%eax)
    info->eip_line = 0;
  100640:	8b 45 0c             	mov    0xc(%ebp),%eax
  100643:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10064a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064d:	c7 40 08 d8 38 10 00 	movl   $0x1038d8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100654:	8b 45 0c             	mov    0xc(%ebp),%eax
  100657:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10065e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100661:	8b 55 08             	mov    0x8(%ebp),%edx
  100664:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100667:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100671:	c7 45 f4 6c 41 10 00 	movl   $0x10416c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100678:	c7 45 f0 10 d0 10 00 	movl   $0x10d010,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10067f:	c7 45 ec 11 d0 10 00 	movl   $0x10d011,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100686:	c7 45 e8 e8 f0 10 00 	movl   $0x10f0e8,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100690:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100693:	76 0b                	jbe    1006a0 <debuginfo_eip+0x73>
  100695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100698:	48                   	dec    %eax
  100699:	0f b6 00             	movzbl (%eax),%eax
  10069c:	84 c0                	test   %al,%al
  10069e:	74 0a                	je     1006aa <debuginfo_eip+0x7d>
        return -1;
  1006a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a5:	e9 ab 02 00 00       	jmp    100955 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006b4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006b7:	c1 f8 02             	sar    $0x2,%eax
  1006ba:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006c0:	48                   	dec    %eax
  1006c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1006c7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006cb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006d2:	00 
  1006d3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 ef fd ff ff       	call   1004db <stab_binsearch>
    if (lfile == 0)
  1006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ef:	85 c0                	test   %eax,%eax
  1006f1:	75 0a                	jne    1006fd <debuginfo_eip+0xd0>
        return -1;
  1006f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006f8:	e9 58 02 00 00       	jmp    100955 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100700:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100706:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100709:	8b 45 08             	mov    0x8(%ebp),%eax
  10070c:	89 44 24 10          	mov    %eax,0x10(%esp)
  100710:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100717:	00 
  100718:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10071b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100722:	89 44 24 04          	mov    %eax,0x4(%esp)
  100726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100729:	89 04 24             	mov    %eax,(%esp)
  10072c:	e8 aa fd ff ff       	call   1004db <stab_binsearch>

    if (lfun <= rfun) {
  100731:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100734:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100737:	39 c2                	cmp    %eax,%edx
  100739:	7f 78                	jg     1007b3 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10073b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10073e:	89 c2                	mov    %eax,%edx
  100740:	89 d0                	mov    %edx,%eax
  100742:	01 c0                	add    %eax,%eax
  100744:	01 d0                	add    %edx,%eax
  100746:	c1 e0 02             	shl    $0x2,%eax
  100749:	89 c2                	mov    %eax,%edx
  10074b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	8b 10                	mov    (%eax),%edx
  100752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100755:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100758:	39 c2                	cmp    %eax,%edx
  10075a:	73 22                	jae    10077e <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10075c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075f:	89 c2                	mov    %eax,%edx
  100761:	89 d0                	mov    %edx,%eax
  100763:	01 c0                	add    %eax,%eax
  100765:	01 d0                	add    %edx,%eax
  100767:	c1 e0 02             	shl    $0x2,%eax
  10076a:	89 c2                	mov    %eax,%edx
  10076c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076f:	01 d0                	add    %edx,%eax
  100771:	8b 10                	mov    (%eax),%edx
  100773:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100776:	01 c2                	add    %eax,%edx
  100778:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10077e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100781:	89 c2                	mov    %eax,%edx
  100783:	89 d0                	mov    %edx,%eax
  100785:	01 c0                	add    %eax,%eax
  100787:	01 d0                	add    %edx,%eax
  100789:	c1 e0 02             	shl    $0x2,%eax
  10078c:	89 c2                	mov    %eax,%edx
  10078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100791:	01 d0                	add    %edx,%eax
  100793:	8b 50 08             	mov    0x8(%eax),%edx
  100796:	8b 45 0c             	mov    0xc(%ebp),%eax
  100799:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10079c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079f:	8b 40 10             	mov    0x10(%eax),%eax
  1007a2:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007b1:	eb 15                	jmp    1007c8 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b6:	8b 55 08             	mov    0x8(%ebp),%edx
  1007b9:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007cb:	8b 40 08             	mov    0x8(%eax),%eax
  1007ce:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007d5:	00 
  1007d6:	89 04 24             	mov    %eax,(%esp)
  1007d9:	e8 33 26 00 00       	call   102e11 <strfind>
  1007de:	8b 55 0c             	mov    0xc(%ebp),%edx
  1007e1:	8b 52 08             	mov    0x8(%edx),%edx
  1007e4:	29 d0                	sub    %edx,%eax
  1007e6:	89 c2                	mov    %eax,%edx
  1007e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007eb:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1007f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007f5:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007fc:	00 
  1007fd:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100800:	89 44 24 08          	mov    %eax,0x8(%esp)
  100804:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100807:	89 44 24 04          	mov    %eax,0x4(%esp)
  10080b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10080e:	89 04 24             	mov    %eax,(%esp)
  100811:	e8 c5 fc ff ff       	call   1004db <stab_binsearch>
    if (lline <= rline) {
  100816:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100819:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10081c:	39 c2                	cmp    %eax,%edx
  10081e:	7f 23                	jg     100843 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100820:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100823:	89 c2                	mov    %eax,%edx
  100825:	89 d0                	mov    %edx,%eax
  100827:	01 c0                	add    %eax,%eax
  100829:	01 d0                	add    %edx,%eax
  10082b:	c1 e0 02             	shl    $0x2,%eax
  10082e:	89 c2                	mov    %eax,%edx
  100830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100833:	01 d0                	add    %edx,%eax
  100835:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100839:	89 c2                	mov    %eax,%edx
  10083b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10083e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100841:	eb 11                	jmp    100854 <debuginfo_eip+0x227>
        return -1;
  100843:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100848:	e9 08 01 00 00       	jmp    100955 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100850:	48                   	dec    %eax
  100851:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100854:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10085a:	39 c2                	cmp    %eax,%edx
  10085c:	7c 56                	jl     1008b4 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  10085e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	89 d0                	mov    %edx,%eax
  100865:	01 c0                	add    %eax,%eax
  100867:	01 d0                	add    %edx,%eax
  100869:	c1 e0 02             	shl    $0x2,%eax
  10086c:	89 c2                	mov    %eax,%edx
  10086e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100871:	01 d0                	add    %edx,%eax
  100873:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100877:	3c 84                	cmp    $0x84,%al
  100879:	74 39                	je     1008b4 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10087b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10087e:	89 c2                	mov    %eax,%edx
  100880:	89 d0                	mov    %edx,%eax
  100882:	01 c0                	add    %eax,%eax
  100884:	01 d0                	add    %edx,%eax
  100886:	c1 e0 02             	shl    $0x2,%eax
  100889:	89 c2                	mov    %eax,%edx
  10088b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10088e:	01 d0                	add    %edx,%eax
  100890:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100894:	3c 64                	cmp    $0x64,%al
  100896:	75 b5                	jne    10084d <debuginfo_eip+0x220>
  100898:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089b:	89 c2                	mov    %eax,%edx
  10089d:	89 d0                	mov    %edx,%eax
  10089f:	01 c0                	add    %eax,%eax
  1008a1:	01 d0                	add    %edx,%eax
  1008a3:	c1 e0 02             	shl    $0x2,%eax
  1008a6:	89 c2                	mov    %eax,%edx
  1008a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ab:	01 d0                	add    %edx,%eax
  1008ad:	8b 40 08             	mov    0x8(%eax),%eax
  1008b0:	85 c0                	test   %eax,%eax
  1008b2:	74 99                	je     10084d <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008ba:	39 c2                	cmp    %eax,%edx
  1008bc:	7c 42                	jl     100900 <debuginfo_eip+0x2d3>
  1008be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c1:	89 c2                	mov    %eax,%edx
  1008c3:	89 d0                	mov    %edx,%eax
  1008c5:	01 c0                	add    %eax,%eax
  1008c7:	01 d0                	add    %edx,%eax
  1008c9:	c1 e0 02             	shl    $0x2,%eax
  1008cc:	89 c2                	mov    %eax,%edx
  1008ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d1:	01 d0                	add    %edx,%eax
  1008d3:	8b 10                	mov    (%eax),%edx
  1008d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008d8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1008db:	39 c2                	cmp    %eax,%edx
  1008dd:	73 21                	jae    100900 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e2:	89 c2                	mov    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	01 c0                	add    %eax,%eax
  1008e8:	01 d0                	add    %edx,%eax
  1008ea:	c1 e0 02             	shl    $0x2,%eax
  1008ed:	89 c2                	mov    %eax,%edx
  1008ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f2:	01 d0                	add    %edx,%eax
  1008f4:	8b 10                	mov    (%eax),%edx
  1008f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008f9:	01 c2                	add    %eax,%edx
  1008fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008fe:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100900:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100903:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100906:	39 c2                	cmp    %eax,%edx
  100908:	7d 46                	jge    100950 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  10090a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10090d:	40                   	inc    %eax
  10090e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100911:	eb 16                	jmp    100929 <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100913:	8b 45 0c             	mov    0xc(%ebp),%eax
  100916:	8b 40 14             	mov    0x14(%eax),%eax
  100919:	8d 50 01             	lea    0x1(%eax),%edx
  10091c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10091f:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100922:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100925:	40                   	inc    %eax
  100926:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100929:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10092c:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10092f:	39 c2                	cmp    %eax,%edx
  100931:	7d 1d                	jge    100950 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100933:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100936:	89 c2                	mov    %eax,%edx
  100938:	89 d0                	mov    %edx,%eax
  10093a:	01 c0                	add    %eax,%eax
  10093c:	01 d0                	add    %edx,%eax
  10093e:	c1 e0 02             	shl    $0x2,%eax
  100941:	89 c2                	mov    %eax,%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10094c:	3c a0                	cmp    $0xa0,%al
  10094e:	74 c3                	je     100913 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100950:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100955:	c9                   	leave  
  100956:	c3                   	ret    

00100957 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100957:	f3 0f 1e fb          	endbr32 
  10095b:	55                   	push   %ebp
  10095c:	89 e5                	mov    %esp,%ebp
  10095e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100961:	c7 04 24 e2 38 10 00 	movl   $0x1038e2,(%esp)
  100968:	e8 27 f9 ff ff       	call   100294 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10096d:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100974:	00 
  100975:	c7 04 24 fb 38 10 00 	movl   $0x1038fb,(%esp)
  10097c:	e8 13 f9 ff ff       	call   100294 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100981:	c7 44 24 04 c1 37 10 	movl   $0x1037c1,0x4(%esp)
  100988:	00 
  100989:	c7 04 24 13 39 10 00 	movl   $0x103913,(%esp)
  100990:	e8 ff f8 ff ff       	call   100294 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100995:	c7 44 24 04 16 0a 11 	movl   $0x110a16,0x4(%esp)
  10099c:	00 
  10099d:	c7 04 24 2b 39 10 00 	movl   $0x10392b,(%esp)
  1009a4:	e8 eb f8 ff ff       	call   100294 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009a9:	c7 44 24 04 20 1d 11 	movl   $0x111d20,0x4(%esp)
  1009b0:	00 
  1009b1:	c7 04 24 43 39 10 00 	movl   $0x103943,(%esp)
  1009b8:	e8 d7 f8 ff ff       	call   100294 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009bd:	b8 20 1d 11 00       	mov    $0x111d20,%eax
  1009c2:	2d 00 00 10 00       	sub    $0x100000,%eax
  1009c7:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009cc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009d2:	85 c0                	test   %eax,%eax
  1009d4:	0f 48 c2             	cmovs  %edx,%eax
  1009d7:	c1 f8 0a             	sar    $0xa,%eax
  1009da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009de:	c7 04 24 5c 39 10 00 	movl   $0x10395c,(%esp)
  1009e5:	e8 aa f8 ff ff       	call   100294 <cprintf>
}
  1009ea:	90                   	nop
  1009eb:	c9                   	leave  
  1009ec:	c3                   	ret    

001009ed <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009ed:	f3 0f 1e fb          	endbr32 
  1009f1:	55                   	push   %ebp
  1009f2:	89 e5                	mov    %esp,%ebp
  1009f4:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009fa:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a01:	8b 45 08             	mov    0x8(%ebp),%eax
  100a04:	89 04 24             	mov    %eax,(%esp)
  100a07:	e8 21 fc ff ff       	call   10062d <debuginfo_eip>
  100a0c:	85 c0                	test   %eax,%eax
  100a0e:	74 15                	je     100a25 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a10:	8b 45 08             	mov    0x8(%ebp),%eax
  100a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a17:	c7 04 24 86 39 10 00 	movl   $0x103986,(%esp)
  100a1e:	e8 71 f8 ff ff       	call   100294 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a23:	eb 6c                	jmp    100a91 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a2c:	eb 1b                	jmp    100a49 <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a34:	01 d0                	add    %edx,%eax
  100a36:	0f b6 10             	movzbl (%eax),%edx
  100a39:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a42:	01 c8                	add    %ecx,%eax
  100a44:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a46:	ff 45 f4             	incl   -0xc(%ebp)
  100a49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a4c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a4f:	7c dd                	jl     100a2e <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a51:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5a:	01 d0                	add    %edx,%eax
  100a5c:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a62:	8b 55 08             	mov    0x8(%ebp),%edx
  100a65:	89 d1                	mov    %edx,%ecx
  100a67:	29 c1                	sub    %eax,%ecx
  100a69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a6f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a73:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a79:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a7d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a81:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a85:	c7 04 24 a2 39 10 00 	movl   $0x1039a2,(%esp)
  100a8c:	e8 03 f8 ff ff       	call   100294 <cprintf>
}
  100a91:	90                   	nop
  100a92:	c9                   	leave  
  100a93:	c3                   	ret    

00100a94 <read_eip>:

// read_eip必须定义为常规函数而不是inline函数，因为这样的话在调用read_eip时会把当前指令的下一条指令的地址（也就是eip寄存器的值）压栈，
// 那么在进入read_eip函数内部后便可以从栈中获取到调用前eip寄存器的值。
static __noinline uint32_t
read_eip(void) {
  100a94:	f3 0f 1e fb          	endbr32 
  100a98:	55                   	push   %ebp
  100a99:	89 e5                	mov    %esp,%ebp
  100a9b:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a9e:	8b 45 04             	mov    0x4(%ebp),%eax
  100aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100aa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100aa7:	c9                   	leave  
  100aa8:	c3                   	ret    

00100aa9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100aa9:	f3 0f 1e fb          	endbr32 
  100aad:	55                   	push   %ebp
  100aae:	89 e5                	mov    %esp,%ebp
  100ab0:	53                   	push   %ebx
  100ab1:	83 ec 34             	sub    $0x34,%esp

// read_ebp必须定义为inline函数，否则获取的是执行read_ebp函数时的ebp寄存器的值
static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100ab4:	89 e8                	mov    %ebp,%eax
  100ab6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
  100ab9:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uint32_t ebp = read_ebp(), eip = read_eip();//对应(1)、(2)
  100abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100abf:	e8 d0 ff ff ff       	call   100a94 <read_eip>
  100ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
     int i;
     for (i = 0; i < STACKFRAME_DEPTH && ebp; i++)
  100ac7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100ace:	eb 6c                	jmp    100b3c <print_stackframe+0x93>
     {
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip, ((uint32_t*)ebp + 2)[0], ((uint32_t*)ebp + 2)[1], ((uint32_t*)ebp + 2)[2], ((uint32_t*)ebp + 2)[3]); //对应(3.1)、(3.2)、(3.3)
  100ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad3:	83 c0 14             	add    $0x14,%eax
  100ad6:	8b 18                	mov    (%eax),%ebx
  100ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100adb:	83 c0 10             	add    $0x10,%eax
  100ade:	8b 08                	mov    (%eax),%ecx
  100ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae3:	83 c0 0c             	add    $0xc,%eax
  100ae6:	8b 10                	mov    (%eax),%edx
  100ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aeb:	83 c0 08             	add    $0x8,%eax
  100aee:	8b 00                	mov    (%eax),%eax
  100af0:	89 5c 24 18          	mov    %ebx,0x18(%esp)
  100af4:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  100af8:	89 54 24 10          	mov    %edx,0x10(%esp)
  100afc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b03:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b0e:	c7 04 24 b4 39 10 00 	movl   $0x1039b4,(%esp)
  100b15:	e8 7a f7 ff ff       	call   100294 <cprintf>
        print_debuginfo(eip - 1); //对应(3.4)，由于变量eip存放的是下一条指令的地址，因此将变量eip的值减去1，得到的指令地址就属于当前指令的范围了。由于只要输入的地址属于当前指令的起始和结束位置之间，print_debuginfo都能搜索到当前指令，因此这里减去1即可。
  100b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b1d:	48                   	dec    %eax
  100b1e:	89 04 24             	mov    %eax,(%esp)
  100b21:	e8 c7 fe ff ff       	call   1009ed <print_debuginfo>
        eip = *(uint32_t*)(ebp + 4), ebp = *(uint32_t*)ebp; //对应(3.5)，这里默认ss基址为0
  100b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b29:	83 c0 04             	add    $0x4,%eax
  100b2c:	8b 00                	mov    (%eax),%eax
  100b2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  100b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b34:	8b 00                	mov    (%eax),%eax
  100b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
     for (i = 0; i < STACKFRAME_DEPTH && ebp; i++)
  100b39:	ff 45 ec             	incl   -0x14(%ebp)
  100b3c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b40:	7f 06                	jg     100b48 <print_stackframe+0x9f>
  100b42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b46:	75 88                	jne    100ad0 <print_stackframe+0x27>
     }
}
  100b48:	90                   	nop
  100b49:	83 c4 34             	add    $0x34,%esp
  100b4c:	5b                   	pop    %ebx
  100b4d:	5d                   	pop    %ebp
  100b4e:	c3                   	ret    

00100b4f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b4f:	f3 0f 1e fb          	endbr32 
  100b53:	55                   	push   %ebp
  100b54:	89 e5                	mov    %esp,%ebp
  100b56:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b60:	eb 0c                	jmp    100b6e <parse+0x1f>
            *buf ++ = '\0';
  100b62:	8b 45 08             	mov    0x8(%ebp),%eax
  100b65:	8d 50 01             	lea    0x1(%eax),%edx
  100b68:	89 55 08             	mov    %edx,0x8(%ebp)
  100b6b:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b71:	0f b6 00             	movzbl (%eax),%eax
  100b74:	84 c0                	test   %al,%al
  100b76:	74 1d                	je     100b95 <parse+0x46>
  100b78:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7b:	0f b6 00             	movzbl (%eax),%eax
  100b7e:	0f be c0             	movsbl %al,%eax
  100b81:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b85:	c7 04 24 6c 3a 10 00 	movl   $0x103a6c,(%esp)
  100b8c:	e8 4a 22 00 00       	call   102ddb <strchr>
  100b91:	85 c0                	test   %eax,%eax
  100b93:	75 cd                	jne    100b62 <parse+0x13>
        }
        if (*buf == '\0') {
  100b95:	8b 45 08             	mov    0x8(%ebp),%eax
  100b98:	0f b6 00             	movzbl (%eax),%eax
  100b9b:	84 c0                	test   %al,%al
  100b9d:	74 65                	je     100c04 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b9f:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ba3:	75 14                	jne    100bb9 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ba5:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bac:	00 
  100bad:	c7 04 24 71 3a 10 00 	movl   $0x103a71,(%esp)
  100bb4:	e8 db f6 ff ff       	call   100294 <cprintf>
        }
        argv[argc ++] = buf;
  100bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bbc:	8d 50 01             	lea    0x1(%eax),%edx
  100bbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bc2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bcc:	01 c2                	add    %eax,%edx
  100bce:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd1:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bd3:	eb 03                	jmp    100bd8 <parse+0x89>
            buf ++;
  100bd5:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  100bdb:	0f b6 00             	movzbl (%eax),%eax
  100bde:	84 c0                	test   %al,%al
  100be0:	74 8c                	je     100b6e <parse+0x1f>
  100be2:	8b 45 08             	mov    0x8(%ebp),%eax
  100be5:	0f b6 00             	movzbl (%eax),%eax
  100be8:	0f be c0             	movsbl %al,%eax
  100beb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bef:	c7 04 24 6c 3a 10 00 	movl   $0x103a6c,(%esp)
  100bf6:	e8 e0 21 00 00       	call   102ddb <strchr>
  100bfb:	85 c0                	test   %eax,%eax
  100bfd:	74 d6                	je     100bd5 <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bff:	e9 6a ff ff ff       	jmp    100b6e <parse+0x1f>
            break;
  100c04:	90                   	nop
        }
    }
    return argc;
  100c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c08:	c9                   	leave  
  100c09:	c3                   	ret    

00100c0a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c0a:	f3 0f 1e fb          	endbr32 
  100c0e:	55                   	push   %ebp
  100c0f:	89 e5                	mov    %esp,%ebp
  100c11:	53                   	push   %ebx
  100c12:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c15:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c18:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  100c1f:	89 04 24             	mov    %eax,(%esp)
  100c22:	e8 28 ff ff ff       	call   100b4f <parse>
  100c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c2e:	75 0a                	jne    100c3a <runcmd+0x30>
        return 0;
  100c30:	b8 00 00 00 00       	mov    $0x0,%eax
  100c35:	e9 83 00 00 00       	jmp    100cbd <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c41:	eb 5a                	jmp    100c9d <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c43:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c49:	89 d0                	mov    %edx,%eax
  100c4b:	01 c0                	add    %eax,%eax
  100c4d:	01 d0                	add    %edx,%eax
  100c4f:	c1 e0 02             	shl    $0x2,%eax
  100c52:	05 00 00 11 00       	add    $0x110000,%eax
  100c57:	8b 00                	mov    (%eax),%eax
  100c59:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c5d:	89 04 24             	mov    %eax,(%esp)
  100c60:	e8 d2 20 00 00       	call   102d37 <strcmp>
  100c65:	85 c0                	test   %eax,%eax
  100c67:	75 31                	jne    100c9a <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c6c:	89 d0                	mov    %edx,%eax
  100c6e:	01 c0                	add    %eax,%eax
  100c70:	01 d0                	add    %edx,%eax
  100c72:	c1 e0 02             	shl    $0x2,%eax
  100c75:	05 08 00 11 00       	add    $0x110008,%eax
  100c7a:	8b 10                	mov    (%eax),%edx
  100c7c:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c7f:	83 c0 04             	add    $0x4,%eax
  100c82:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c85:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c93:	89 1c 24             	mov    %ebx,(%esp)
  100c96:	ff d2                	call   *%edx
  100c98:	eb 23                	jmp    100cbd <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c9a:	ff 45 f4             	incl   -0xc(%ebp)
  100c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca0:	83 f8 02             	cmp    $0x2,%eax
  100ca3:	76 9e                	jbe    100c43 <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ca5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ca8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cac:	c7 04 24 8f 3a 10 00 	movl   $0x103a8f,(%esp)
  100cb3:	e8 dc f5 ff ff       	call   100294 <cprintf>
    return 0;
  100cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbd:	83 c4 64             	add    $0x64,%esp
  100cc0:	5b                   	pop    %ebx
  100cc1:	5d                   	pop    %ebp
  100cc2:	c3                   	ret    

00100cc3 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100cc3:	f3 0f 1e fb          	endbr32 
  100cc7:	55                   	push   %ebp
  100cc8:	89 e5                	mov    %esp,%ebp
  100cca:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100ccd:	c7 04 24 a8 3a 10 00 	movl   $0x103aa8,(%esp)
  100cd4:	e8 bb f5 ff ff       	call   100294 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cd9:	c7 04 24 d0 3a 10 00 	movl   $0x103ad0,(%esp)
  100ce0:	e8 af f5 ff ff       	call   100294 <cprintf>

    if (tf != NULL) {
  100ce5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ce9:	74 0b                	je     100cf6 <kmonitor+0x33>
        print_trapframe(tf);
  100ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  100cee:	89 04 24             	mov    %eax,(%esp)
  100cf1:	e8 50 0e 00 00       	call   101b46 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cf6:	c7 04 24 f5 3a 10 00 	movl   $0x103af5,(%esp)
  100cfd:	e8 45 f6 ff ff       	call   100347 <readline>
  100d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d09:	74 eb                	je     100cf6 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  100d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d15:	89 04 24             	mov    %eax,(%esp)
  100d18:	e8 ed fe ff ff       	call   100c0a <runcmd>
  100d1d:	85 c0                	test   %eax,%eax
  100d1f:	78 02                	js     100d23 <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d21:	eb d3                	jmp    100cf6 <kmonitor+0x33>
                break;
  100d23:	90                   	nop
            }
        }
    }
}
  100d24:	90                   	nop
  100d25:	c9                   	leave  
  100d26:	c3                   	ret    

00100d27 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d27:	f3 0f 1e fb          	endbr32 
  100d2b:	55                   	push   %ebp
  100d2c:	89 e5                	mov    %esp,%ebp
  100d2e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d38:	eb 3d                	jmp    100d77 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d3d:	89 d0                	mov    %edx,%eax
  100d3f:	01 c0                	add    %eax,%eax
  100d41:	01 d0                	add    %edx,%eax
  100d43:	c1 e0 02             	shl    $0x2,%eax
  100d46:	05 04 00 11 00       	add    $0x110004,%eax
  100d4b:	8b 08                	mov    (%eax),%ecx
  100d4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d50:	89 d0                	mov    %edx,%eax
  100d52:	01 c0                	add    %eax,%eax
  100d54:	01 d0                	add    %edx,%eax
  100d56:	c1 e0 02             	shl    $0x2,%eax
  100d59:	05 00 00 11 00       	add    $0x110000,%eax
  100d5e:	8b 00                	mov    (%eax),%eax
  100d60:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d64:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d68:	c7 04 24 f9 3a 10 00 	movl   $0x103af9,(%esp)
  100d6f:	e8 20 f5 ff ff       	call   100294 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d74:	ff 45 f4             	incl   -0xc(%ebp)
  100d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d7a:	83 f8 02             	cmp    $0x2,%eax
  100d7d:	76 bb                	jbe    100d3a <mon_help+0x13>
    }
    return 0;
  100d7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d84:	c9                   	leave  
  100d85:	c3                   	ret    

00100d86 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d86:	f3 0f 1e fb          	endbr32 
  100d8a:	55                   	push   %ebp
  100d8b:	89 e5                	mov    %esp,%ebp
  100d8d:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d90:	e8 c2 fb ff ff       	call   100957 <print_kerninfo>
    return 0;
  100d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d9a:	c9                   	leave  
  100d9b:	c3                   	ret    

00100d9c <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d9c:	f3 0f 1e fb          	endbr32 
  100da0:	55                   	push   %ebp
  100da1:	89 e5                	mov    %esp,%ebp
  100da3:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100da6:	e8 fe fc ff ff       	call   100aa9 <print_stackframe>
    return 0;
  100dab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100db0:	c9                   	leave  
  100db1:	c3                   	ret    

00100db2 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100db2:	f3 0f 1e fb          	endbr32 
  100db6:	55                   	push   %ebp
  100db7:	89 e5                	mov    %esp,%ebp
  100db9:	83 ec 28             	sub    $0x28,%esp
  100dbc:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100dc2:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dc6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dca:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dce:	ee                   	out    %al,(%dx)
}
  100dcf:	90                   	nop
  100dd0:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dd6:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dda:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dde:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100de2:	ee                   	out    %al,(%dx)
}
  100de3:	90                   	nop
  100de4:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100dea:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dee:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100df2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100df6:	ee                   	out    %al,(%dx)
}
  100df7:	90                   	nop
    // 设置时钟每秒中断100次
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100df8:	c7 05 08 19 11 00 00 	movl   $0x0,0x111908
  100dff:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e02:	c7 04 24 02 3b 10 00 	movl   $0x103b02,(%esp)
  100e09:	e8 86 f4 ff ff       	call   100294 <cprintf>
    pic_enable(IRQ_TIMER); // 通过中断控制器使能时钟中断
  100e0e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e15:	e8 31 09 00 00       	call   10174b <pic_enable>
}
  100e1a:	90                   	nop
  100e1b:	c9                   	leave  
  100e1c:	c3                   	ret    

00100e1d <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e1d:	f3 0f 1e fb          	endbr32 
  100e21:	55                   	push   %ebp
  100e22:	89 e5                	mov    %esp,%ebp
  100e24:	83 ec 10             	sub    $0x10,%esp
  100e27:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e2d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e31:	89 c2                	mov    %eax,%edx
  100e33:	ec                   	in     (%dx),%al
  100e34:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e37:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e3d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e41:	89 c2                	mov    %eax,%edx
  100e43:	ec                   	in     (%dx),%al
  100e44:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e47:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e4d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e51:	89 c2                	mov    %eax,%edx
  100e53:	ec                   	in     (%dx),%al
  100e54:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e57:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e5d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e61:	89 c2                	mov    %eax,%edx
  100e63:	ec                   	in     (%dx),%al
  100e64:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e67:	90                   	nop
  100e68:	c9                   	leave  
  100e69:	c3                   	ret    

00100e6a <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e6a:	f3 0f 1e fb          	endbr32 
  100e6e:	55                   	push   %ebp
  100e6f:	89 e5                	mov    %esp,%ebp
  100e71:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e74:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7e:	0f b7 00             	movzwl (%eax),%eax
  100e81:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e88:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e90:	0f b7 00             	movzwl (%eax),%eax
  100e93:	0f b7 c0             	movzwl %ax,%eax
  100e96:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e9b:	74 12                	je     100eaf <cga_init+0x45>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e9d:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100ea4:	66 c7 05 66 0e 11 00 	movw   $0x3b4,0x110e66
  100eab:	b4 03 
  100ead:	eb 13                	jmp    100ec2 <cga_init+0x58>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eb6:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100eb9:	66 c7 05 66 0e 11 00 	movw   $0x3d4,0x110e66
  100ec0:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100ec2:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100ec9:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ecd:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ed1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ed5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ed9:	ee                   	out    %al,(%dx)
}
  100eda:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100edb:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100ee2:	40                   	inc    %eax
  100ee3:	0f b7 c0             	movzwl %ax,%eax
  100ee6:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eea:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100eee:	89 c2                	mov    %eax,%edx
  100ef0:	ec                   	in     (%dx),%al
  100ef1:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100ef4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ef8:	0f b6 c0             	movzbl %al,%eax
  100efb:	c1 e0 08             	shl    $0x8,%eax
  100efe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f01:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f08:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f0c:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f10:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f14:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f18:	ee                   	out    %al,(%dx)
}
  100f19:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100f1a:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f21:	40                   	inc    %eax
  100f22:	0f b7 c0             	movzwl %ax,%eax
  100f25:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f29:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f2d:	89 c2                	mov    %eax,%edx
  100f2f:	ec                   	in     (%dx),%al
  100f30:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f33:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f37:	0f b6 c0             	movzbl %al,%eax
  100f3a:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f40:	a3 60 0e 11 00       	mov    %eax,0x110e60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f48:	0f b7 c0             	movzwl %ax,%eax
  100f4b:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
}
  100f51:	90                   	nop
  100f52:	c9                   	leave  
  100f53:	c3                   	ret    

00100f54 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f54:	f3 0f 1e fb          	endbr32 
  100f58:	55                   	push   %ebp
  100f59:	89 e5                	mov    %esp,%ebp
  100f5b:	83 ec 48             	sub    $0x48,%esp
  100f5e:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f64:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f68:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f6c:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f70:	ee                   	out    %al,(%dx)
}
  100f71:	90                   	nop
  100f72:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f78:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f7c:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f80:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f84:	ee                   	out    %al,(%dx)
}
  100f85:	90                   	nop
  100f86:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f8c:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f90:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f94:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f98:	ee                   	out    %al,(%dx)
}
  100f99:	90                   	nop
  100f9a:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fa0:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fa4:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fa8:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fac:	ee                   	out    %al,(%dx)
}
  100fad:	90                   	nop
  100fae:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fb4:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fb8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fbc:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fc0:	ee                   	out    %al,(%dx)
}
  100fc1:	90                   	nop
  100fc2:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fc8:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fcc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fd0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fd4:	ee                   	out    %al,(%dx)
}
  100fd5:	90                   	nop
  100fd6:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fdc:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fe0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fe4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fe8:	ee                   	out    %al,(%dx)
}
  100fe9:	90                   	nop
  100fea:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ff0:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ff4:	89 c2                	mov    %eax,%edx
  100ff6:	ec                   	in     (%dx),%al
  100ff7:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ffa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts，使能串口1接收字符后产生中断
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ffe:	3c ff                	cmp    $0xff,%al
  101000:	0f 95 c0             	setne  %al
  101003:	0f b6 c0             	movzbl %al,%eax
  101006:	a3 68 0e 11 00       	mov    %eax,0x110e68
  10100b:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101011:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101015:	89 c2                	mov    %eax,%edx
  101017:	ec                   	in     (%dx),%al
  101018:	88 45 f1             	mov    %al,-0xf(%ebp)
  10101b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101021:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101025:	89 c2                	mov    %eax,%edx
  101027:	ec                   	in     (%dx),%al
  101028:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10102b:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101030:	85 c0                	test   %eax,%eax
  101032:	74 0c                	je     101040 <serial_init+0xec>
        pic_enable(IRQ_COM1); // 通过中断控制器使能串口1中断
  101034:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10103b:	e8 0b 07 00 00       	call   10174b <pic_enable>
    }
}
  101040:	90                   	nop
  101041:	c9                   	leave  
  101042:	c3                   	ret    

00101043 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101043:	f3 0f 1e fb          	endbr32 
  101047:	55                   	push   %ebp
  101048:	89 e5                	mov    %esp,%ebp
  10104a:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10104d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101054:	eb 08                	jmp    10105e <lpt_putc_sub+0x1b>
        delay();
  101056:	e8 c2 fd ff ff       	call   100e1d <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10105b:	ff 45 fc             	incl   -0x4(%ebp)
  10105e:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101064:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101068:	89 c2                	mov    %eax,%edx
  10106a:	ec                   	in     (%dx),%al
  10106b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10106e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101072:	84 c0                	test   %al,%al
  101074:	78 09                	js     10107f <lpt_putc_sub+0x3c>
  101076:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10107d:	7e d7                	jle    101056 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  10107f:	8b 45 08             	mov    0x8(%ebp),%eax
  101082:	0f b6 c0             	movzbl %al,%eax
  101085:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  10108b:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10108e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101092:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101096:	ee                   	out    %al,(%dx)
}
  101097:	90                   	nop
  101098:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10109e:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010a2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010a6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010aa:	ee                   	out    %al,(%dx)
}
  1010ab:	90                   	nop
  1010ac:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010b2:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010b6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010ba:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010be:	ee                   	out    %al,(%dx)
}
  1010bf:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010c0:	90                   	nop
  1010c1:	c9                   	leave  
  1010c2:	c3                   	ret    

001010c3 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010c3:	f3 0f 1e fb          	endbr32 
  1010c7:	55                   	push   %ebp
  1010c8:	89 e5                	mov    %esp,%ebp
  1010ca:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010cd:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010d1:	74 0d                	je     1010e0 <lpt_putc+0x1d>
        lpt_putc_sub(c);
  1010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d6:	89 04 24             	mov    %eax,(%esp)
  1010d9:	e8 65 ff ff ff       	call   101043 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010de:	eb 24                	jmp    101104 <lpt_putc+0x41>
        lpt_putc_sub('\b');
  1010e0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e7:	e8 57 ff ff ff       	call   101043 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010ec:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010f3:	e8 4b ff ff ff       	call   101043 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010f8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010ff:	e8 3f ff ff ff       	call   101043 <lpt_putc_sub>
}
  101104:	90                   	nop
  101105:	c9                   	leave  
  101106:	c3                   	ret    

00101107 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101107:	f3 0f 1e fb          	endbr32 
  10110b:	55                   	push   %ebp
  10110c:	89 e5                	mov    %esp,%ebp
  10110e:	53                   	push   %ebx
  10110f:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101112:	8b 45 08             	mov    0x8(%ebp),%eax
  101115:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10111a:	85 c0                	test   %eax,%eax
  10111c:	75 07                	jne    101125 <cga_putc+0x1e>
        c |= 0x0700;
  10111e:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101125:	8b 45 08             	mov    0x8(%ebp),%eax
  101128:	0f b6 c0             	movzbl %al,%eax
  10112b:	83 f8 0d             	cmp    $0xd,%eax
  10112e:	74 72                	je     1011a2 <cga_putc+0x9b>
  101130:	83 f8 0d             	cmp    $0xd,%eax
  101133:	0f 8f a3 00 00 00    	jg     1011dc <cga_putc+0xd5>
  101139:	83 f8 08             	cmp    $0x8,%eax
  10113c:	74 0a                	je     101148 <cga_putc+0x41>
  10113e:	83 f8 0a             	cmp    $0xa,%eax
  101141:	74 4c                	je     10118f <cga_putc+0x88>
  101143:	e9 94 00 00 00       	jmp    1011dc <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  101148:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  10114f:	85 c0                	test   %eax,%eax
  101151:	0f 84 af 00 00 00    	je     101206 <cga_putc+0xff>
            crt_pos --;
  101157:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  10115e:	48                   	dec    %eax
  10115f:	0f b7 c0             	movzwl %ax,%eax
  101162:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101168:	8b 45 08             	mov    0x8(%ebp),%eax
  10116b:	98                   	cwtl   
  10116c:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101171:	98                   	cwtl   
  101172:	83 c8 20             	or     $0x20,%eax
  101175:	98                   	cwtl   
  101176:	8b 15 60 0e 11 00    	mov    0x110e60,%edx
  10117c:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  101183:	01 c9                	add    %ecx,%ecx
  101185:	01 ca                	add    %ecx,%edx
  101187:	0f b7 c0             	movzwl %ax,%eax
  10118a:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10118d:	eb 77                	jmp    101206 <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  10118f:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101196:	83 c0 50             	add    $0x50,%eax
  101199:	0f b7 c0             	movzwl %ax,%eax
  10119c:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011a2:	0f b7 1d 64 0e 11 00 	movzwl 0x110e64,%ebx
  1011a9:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  1011b0:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011b5:	89 c8                	mov    %ecx,%eax
  1011b7:	f7 e2                	mul    %edx
  1011b9:	c1 ea 06             	shr    $0x6,%edx
  1011bc:	89 d0                	mov    %edx,%eax
  1011be:	c1 e0 02             	shl    $0x2,%eax
  1011c1:	01 d0                	add    %edx,%eax
  1011c3:	c1 e0 04             	shl    $0x4,%eax
  1011c6:	29 c1                	sub    %eax,%ecx
  1011c8:	89 c8                	mov    %ecx,%eax
  1011ca:	0f b7 c0             	movzwl %ax,%eax
  1011cd:	29 c3                	sub    %eax,%ebx
  1011cf:	89 d8                	mov    %ebx,%eax
  1011d1:	0f b7 c0             	movzwl %ax,%eax
  1011d4:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
        break;
  1011da:	eb 2b                	jmp    101207 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011dc:	8b 0d 60 0e 11 00    	mov    0x110e60,%ecx
  1011e2:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1011e9:	8d 50 01             	lea    0x1(%eax),%edx
  1011ec:	0f b7 d2             	movzwl %dx,%edx
  1011ef:	66 89 15 64 0e 11 00 	mov    %dx,0x110e64
  1011f6:	01 c0                	add    %eax,%eax
  1011f8:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1011fe:	0f b7 c0             	movzwl %ax,%eax
  101201:	66 89 02             	mov    %ax,(%edx)
        break;
  101204:	eb 01                	jmp    101207 <cga_putc+0x100>
        break;
  101206:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101207:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  10120e:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101213:	76 5d                	jbe    101272 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101215:	a1 60 0e 11 00       	mov    0x110e60,%eax
  10121a:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101220:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101225:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10122c:	00 
  10122d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101231:	89 04 24             	mov    %eax,(%esp)
  101234:	e8 a7 1d 00 00       	call   102fe0 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101239:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101240:	eb 14                	jmp    101256 <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  101242:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101247:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10124a:	01 d2                	add    %edx,%edx
  10124c:	01 d0                	add    %edx,%eax
  10124e:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101253:	ff 45 f4             	incl   -0xc(%ebp)
  101256:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10125d:	7e e3                	jle    101242 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  10125f:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101266:	83 e8 50             	sub    $0x50,%eax
  101269:	0f b7 c0             	movzwl %ax,%eax
  10126c:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101272:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  101279:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  10127d:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101281:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101285:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101289:	ee                   	out    %al,(%dx)
}
  10128a:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  10128b:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101292:	c1 e8 08             	shr    $0x8,%eax
  101295:	0f b7 c0             	movzwl %ax,%eax
  101298:	0f b6 c0             	movzbl %al,%eax
  10129b:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  1012a2:	42                   	inc    %edx
  1012a3:	0f b7 d2             	movzwl %dx,%edx
  1012a6:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012aa:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012ad:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012b1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012b5:	ee                   	out    %al,(%dx)
}
  1012b6:	90                   	nop
    outb(addr_6845, 15);
  1012b7:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  1012be:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012c2:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012c6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012ca:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012ce:	ee                   	out    %al,(%dx)
}
  1012cf:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1012d0:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012d7:	0f b6 c0             	movzbl %al,%eax
  1012da:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  1012e1:	42                   	inc    %edx
  1012e2:	0f b7 d2             	movzwl %dx,%edx
  1012e5:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012e9:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012ec:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012f0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012f4:	ee                   	out    %al,(%dx)
}
  1012f5:	90                   	nop
}
  1012f6:	90                   	nop
  1012f7:	83 c4 34             	add    $0x34,%esp
  1012fa:	5b                   	pop    %ebx
  1012fb:	5d                   	pop    %ebp
  1012fc:	c3                   	ret    

001012fd <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012fd:	f3 0f 1e fb          	endbr32 
  101301:	55                   	push   %ebp
  101302:	89 e5                	mov    %esp,%ebp
  101304:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101307:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10130e:	eb 08                	jmp    101318 <serial_putc_sub+0x1b>
        delay();
  101310:	e8 08 fb ff ff       	call   100e1d <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101315:	ff 45 fc             	incl   -0x4(%ebp)
  101318:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10131e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101322:	89 c2                	mov    %eax,%edx
  101324:	ec                   	in     (%dx),%al
  101325:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101328:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10132c:	0f b6 c0             	movzbl %al,%eax
  10132f:	83 e0 20             	and    $0x20,%eax
  101332:	85 c0                	test   %eax,%eax
  101334:	75 09                	jne    10133f <serial_putc_sub+0x42>
  101336:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10133d:	7e d1                	jle    101310 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  10133f:	8b 45 08             	mov    0x8(%ebp),%eax
  101342:	0f b6 c0             	movzbl %al,%eax
  101345:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10134b:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10134e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101352:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101356:	ee                   	out    %al,(%dx)
}
  101357:	90                   	nop
}
  101358:	90                   	nop
  101359:	c9                   	leave  
  10135a:	c3                   	ret    

0010135b <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10135b:	f3 0f 1e fb          	endbr32 
  10135f:	55                   	push   %ebp
  101360:	89 e5                	mov    %esp,%ebp
  101362:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101365:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101369:	74 0d                	je     101378 <serial_putc+0x1d>
        serial_putc_sub(c);
  10136b:	8b 45 08             	mov    0x8(%ebp),%eax
  10136e:	89 04 24             	mov    %eax,(%esp)
  101371:	e8 87 ff ff ff       	call   1012fd <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101376:	eb 24                	jmp    10139c <serial_putc+0x41>
        serial_putc_sub('\b');
  101378:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10137f:	e8 79 ff ff ff       	call   1012fd <serial_putc_sub>
        serial_putc_sub(' ');
  101384:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10138b:	e8 6d ff ff ff       	call   1012fd <serial_putc_sub>
        serial_putc_sub('\b');
  101390:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101397:	e8 61 ff ff ff       	call   1012fd <serial_putc_sub>
}
  10139c:	90                   	nop
  10139d:	c9                   	leave  
  10139e:	c3                   	ret    

0010139f <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10139f:	f3 0f 1e fb          	endbr32 
  1013a3:	55                   	push   %ebp
  1013a4:	89 e5                	mov    %esp,%ebp
  1013a6:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013a9:	eb 33                	jmp    1013de <cons_intr+0x3f>
        if (c != 0) {
  1013ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013af:	74 2d                	je     1013de <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  1013b1:	a1 84 10 11 00       	mov    0x111084,%eax
  1013b6:	8d 50 01             	lea    0x1(%eax),%edx
  1013b9:	89 15 84 10 11 00    	mov    %edx,0x111084
  1013bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013c2:	88 90 80 0e 11 00    	mov    %dl,0x110e80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013c8:	a1 84 10 11 00       	mov    0x111084,%eax
  1013cd:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013d2:	75 0a                	jne    1013de <cons_intr+0x3f>
                cons.wpos = 0;
  1013d4:	c7 05 84 10 11 00 00 	movl   $0x0,0x111084
  1013db:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013de:	8b 45 08             	mov    0x8(%ebp),%eax
  1013e1:	ff d0                	call   *%eax
  1013e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013e6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013ea:	75 bf                	jne    1013ab <cons_intr+0xc>
            }
        }
    }
}
  1013ec:	90                   	nop
  1013ed:	90                   	nop
  1013ee:	c9                   	leave  
  1013ef:	c3                   	ret    

001013f0 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013f0:	f3 0f 1e fb          	endbr32 
  1013f4:	55                   	push   %ebp
  1013f5:	89 e5                	mov    %esp,%ebp
  1013f7:	83 ec 10             	sub    $0x10,%esp
  1013fa:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101400:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101404:	89 c2                	mov    %eax,%edx
  101406:	ec                   	in     (%dx),%al
  101407:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10140a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10140e:	0f b6 c0             	movzbl %al,%eax
  101411:	83 e0 01             	and    $0x1,%eax
  101414:	85 c0                	test   %eax,%eax
  101416:	75 07                	jne    10141f <serial_proc_data+0x2f>
        return -1;
  101418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10141d:	eb 2a                	jmp    101449 <serial_proc_data+0x59>
  10141f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101425:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101429:	89 c2                	mov    %eax,%edx
  10142b:	ec                   	in     (%dx),%al
  10142c:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10142f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101433:	0f b6 c0             	movzbl %al,%eax
  101436:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101439:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10143d:	75 07                	jne    101446 <serial_proc_data+0x56>
        c = '\b';
  10143f:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101446:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101449:	c9                   	leave  
  10144a:	c3                   	ret    

0010144b <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10144b:	f3 0f 1e fb          	endbr32 
  10144f:	55                   	push   %ebp
  101450:	89 e5                	mov    %esp,%ebp
  101452:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101455:	a1 68 0e 11 00       	mov    0x110e68,%eax
  10145a:	85 c0                	test   %eax,%eax
  10145c:	74 0c                	je     10146a <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  10145e:	c7 04 24 f0 13 10 00 	movl   $0x1013f0,(%esp)
  101465:	e8 35 ff ff ff       	call   10139f <cons_intr>
    }
}
  10146a:	90                   	nop
  10146b:	c9                   	leave  
  10146c:	c3                   	ret    

0010146d <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10146d:	f3 0f 1e fb          	endbr32 
  101471:	55                   	push   %ebp
  101472:	89 e5                	mov    %esp,%ebp
  101474:	83 ec 38             	sub    $0x38,%esp
  101477:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10147d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101480:	89 c2                	mov    %eax,%edx
  101482:	ec                   	in     (%dx),%al
  101483:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101486:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10148a:	0f b6 c0             	movzbl %al,%eax
  10148d:	83 e0 01             	and    $0x1,%eax
  101490:	85 c0                	test   %eax,%eax
  101492:	75 0a                	jne    10149e <kbd_proc_data+0x31>
        return -1;
  101494:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101499:	e9 56 01 00 00       	jmp    1015f4 <kbd_proc_data+0x187>
  10149e:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014a7:	89 c2                	mov    %eax,%edx
  1014a9:	ec                   	in     (%dx),%al
  1014aa:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014ad:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014b1:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014b4:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014b8:	75 17                	jne    1014d1 <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  1014ba:	a1 88 10 11 00       	mov    0x111088,%eax
  1014bf:	83 c8 40             	or     $0x40,%eax
  1014c2:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  1014c7:	b8 00 00 00 00       	mov    $0x0,%eax
  1014cc:	e9 23 01 00 00       	jmp    1015f4 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1014d1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d5:	84 c0                	test   %al,%al
  1014d7:	79 45                	jns    10151e <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014d9:	a1 88 10 11 00       	mov    0x111088,%eax
  1014de:	83 e0 40             	and    $0x40,%eax
  1014e1:	85 c0                	test   %eax,%eax
  1014e3:	75 08                	jne    1014ed <kbd_proc_data+0x80>
  1014e5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e9:	24 7f                	and    $0x7f,%al
  1014eb:	eb 04                	jmp    1014f1 <kbd_proc_data+0x84>
  1014ed:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f1:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014f4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f8:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  1014ff:	0c 40                	or     $0x40,%al
  101501:	0f b6 c0             	movzbl %al,%eax
  101504:	f7 d0                	not    %eax
  101506:	89 c2                	mov    %eax,%edx
  101508:	a1 88 10 11 00       	mov    0x111088,%eax
  10150d:	21 d0                	and    %edx,%eax
  10150f:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  101514:	b8 00 00 00 00       	mov    $0x0,%eax
  101519:	e9 d6 00 00 00       	jmp    1015f4 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10151e:	a1 88 10 11 00       	mov    0x111088,%eax
  101523:	83 e0 40             	and    $0x40,%eax
  101526:	85 c0                	test   %eax,%eax
  101528:	74 11                	je     10153b <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10152a:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10152e:	a1 88 10 11 00       	mov    0x111088,%eax
  101533:	83 e0 bf             	and    $0xffffffbf,%eax
  101536:	a3 88 10 11 00       	mov    %eax,0x111088
    }

    shift |= shiftcode[data];
  10153b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10153f:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  101546:	0f b6 d0             	movzbl %al,%edx
  101549:	a1 88 10 11 00       	mov    0x111088,%eax
  10154e:	09 d0                	or     %edx,%eax
  101550:	a3 88 10 11 00       	mov    %eax,0x111088
    shift ^= togglecode[data];
  101555:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101559:	0f b6 80 40 01 11 00 	movzbl 0x110140(%eax),%eax
  101560:	0f b6 d0             	movzbl %al,%edx
  101563:	a1 88 10 11 00       	mov    0x111088,%eax
  101568:	31 d0                	xor    %edx,%eax
  10156a:	a3 88 10 11 00       	mov    %eax,0x111088

    c = charcode[shift & (CTL | SHIFT)][data];
  10156f:	a1 88 10 11 00       	mov    0x111088,%eax
  101574:	83 e0 03             	and    $0x3,%eax
  101577:	8b 14 85 40 05 11 00 	mov    0x110540(,%eax,4),%edx
  10157e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101582:	01 d0                	add    %edx,%eax
  101584:	0f b6 00             	movzbl (%eax),%eax
  101587:	0f b6 c0             	movzbl %al,%eax
  10158a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10158d:	a1 88 10 11 00       	mov    0x111088,%eax
  101592:	83 e0 08             	and    $0x8,%eax
  101595:	85 c0                	test   %eax,%eax
  101597:	74 22                	je     1015bb <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101599:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10159d:	7e 0c                	jle    1015ab <kbd_proc_data+0x13e>
  10159f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015a3:	7f 06                	jg     1015ab <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1015a5:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015a9:	eb 10                	jmp    1015bb <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1015ab:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015af:	7e 0a                	jle    1015bb <kbd_proc_data+0x14e>
  1015b1:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015b5:	7f 04                	jg     1015bb <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1015b7:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015bb:	a1 88 10 11 00       	mov    0x111088,%eax
  1015c0:	f7 d0                	not    %eax
  1015c2:	83 e0 06             	and    $0x6,%eax
  1015c5:	85 c0                	test   %eax,%eax
  1015c7:	75 28                	jne    1015f1 <kbd_proc_data+0x184>
  1015c9:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015d0:	75 1f                	jne    1015f1 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1015d2:	c7 04 24 1d 3b 10 00 	movl   $0x103b1d,(%esp)
  1015d9:	e8 b6 ec ff ff       	call   100294 <cprintf>
  1015de:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015e4:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1015e8:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1015ef:	ee                   	out    %al,(%dx)
}
  1015f0:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015f4:	c9                   	leave  
  1015f5:	c3                   	ret    

001015f6 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015f6:	f3 0f 1e fb          	endbr32 
  1015fa:	55                   	push   %ebp
  1015fb:	89 e5                	mov    %esp,%ebp
  1015fd:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101600:	c7 04 24 6d 14 10 00 	movl   $0x10146d,(%esp)
  101607:	e8 93 fd ff ff       	call   10139f <cons_intr>
}
  10160c:	90                   	nop
  10160d:	c9                   	leave  
  10160e:	c3                   	ret    

0010160f <kbd_init>:

static void
kbd_init(void) {
  10160f:	f3 0f 1e fb          	endbr32 
  101613:	55                   	push   %ebp
  101614:	89 e5                	mov    %esp,%ebp
  101616:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101619:	e8 d8 ff ff ff       	call   1015f6 <kbd_intr>
    pic_enable(IRQ_KBD); // 通过中断控制器使能键盘输入中断
  10161e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101625:	e8 21 01 00 00       	call   10174b <pic_enable>
}
  10162a:	90                   	nop
  10162b:	c9                   	leave  
  10162c:	c3                   	ret    

0010162d <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10162d:	f3 0f 1e fb          	endbr32 
  101631:	55                   	push   %ebp
  101632:	89 e5                	mov    %esp,%ebp
  101634:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101637:	e8 2e f8 ff ff       	call   100e6a <cga_init>
    serial_init();
  10163c:	e8 13 f9 ff ff       	call   100f54 <serial_init>
    kbd_init();
  101641:	e8 c9 ff ff ff       	call   10160f <kbd_init>
    if (!serial_exists) {
  101646:	a1 68 0e 11 00       	mov    0x110e68,%eax
  10164b:	85 c0                	test   %eax,%eax
  10164d:	75 0c                	jne    10165b <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10164f:	c7 04 24 29 3b 10 00 	movl   $0x103b29,(%esp)
  101656:	e8 39 ec ff ff       	call   100294 <cprintf>
    }
}
  10165b:	90                   	nop
  10165c:	c9                   	leave  
  10165d:	c3                   	ret    

0010165e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10165e:	f3 0f 1e fb          	endbr32 
  101662:	55                   	push   %ebp
  101663:	89 e5                	mov    %esp,%ebp
  101665:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101668:	8b 45 08             	mov    0x8(%ebp),%eax
  10166b:	89 04 24             	mov    %eax,(%esp)
  10166e:	e8 50 fa ff ff       	call   1010c3 <lpt_putc>
    cga_putc(c);
  101673:	8b 45 08             	mov    0x8(%ebp),%eax
  101676:	89 04 24             	mov    %eax,(%esp)
  101679:	e8 89 fa ff ff       	call   101107 <cga_putc>
    serial_putc(c);
  10167e:	8b 45 08             	mov    0x8(%ebp),%eax
  101681:	89 04 24             	mov    %eax,(%esp)
  101684:	e8 d2 fc ff ff       	call   10135b <serial_putc>
}
  101689:	90                   	nop
  10168a:	c9                   	leave  
  10168b:	c3                   	ret    

0010168c <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10168c:	f3 0f 1e fb          	endbr32 
  101690:	55                   	push   %ebp
  101691:	89 e5                	mov    %esp,%ebp
  101693:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  101696:	e8 b0 fd ff ff       	call   10144b <serial_intr>
    kbd_intr();
  10169b:	e8 56 ff ff ff       	call   1015f6 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016a0:	8b 15 80 10 11 00    	mov    0x111080,%edx
  1016a6:	a1 84 10 11 00       	mov    0x111084,%eax
  1016ab:	39 c2                	cmp    %eax,%edx
  1016ad:	74 36                	je     1016e5 <cons_getc+0x59>
        c = cons.buf[cons.rpos ++];
  1016af:	a1 80 10 11 00       	mov    0x111080,%eax
  1016b4:	8d 50 01             	lea    0x1(%eax),%edx
  1016b7:	89 15 80 10 11 00    	mov    %edx,0x111080
  1016bd:	0f b6 80 80 0e 11 00 	movzbl 0x110e80(%eax),%eax
  1016c4:	0f b6 c0             	movzbl %al,%eax
  1016c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1016ca:	a1 80 10 11 00       	mov    0x111080,%eax
  1016cf:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016d4:	75 0a                	jne    1016e0 <cons_getc+0x54>
            cons.rpos = 0;
  1016d6:	c7 05 80 10 11 00 00 	movl   $0x0,0x111080
  1016dd:	00 00 00 
        }
        return c;
  1016e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016e3:	eb 05                	jmp    1016ea <cons_getc+0x5e>
    }
    return 0;
  1016e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1016ea:	c9                   	leave  
  1016eb:	c3                   	ret    

001016ec <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ec:	f3 0f 1e fb          	endbr32 
  1016f0:	55                   	push   %ebp
  1016f1:	89 e5                	mov    %esp,%ebp
  1016f3:	83 ec 14             	sub    $0x14,%esp
  1016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1016f9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101700:	66 a3 50 05 11 00    	mov    %ax,0x110550
    if (did_init) {
  101706:	a1 8c 10 11 00       	mov    0x11108c,%eax
  10170b:	85 c0                	test   %eax,%eax
  10170d:	74 39                	je     101748 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  10170f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101712:	0f b6 c0             	movzbl %al,%eax
  101715:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  10171b:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10171e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101722:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101726:	ee                   	out    %al,(%dx)
}
  101727:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  101728:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10172c:	c1 e8 08             	shr    $0x8,%eax
  10172f:	0f b7 c0             	movzwl %ax,%eax
  101732:	0f b6 c0             	movzbl %al,%eax
  101735:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  10173b:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10173e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101742:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101746:	ee                   	out    %al,(%dx)
}
  101747:	90                   	nop
    }
}
  101748:	90                   	nop
  101749:	c9                   	leave  
  10174a:	c3                   	ret    

0010174b <pic_enable>:

void
pic_enable(unsigned int irq) {
  10174b:	f3 0f 1e fb          	endbr32 
  10174f:	55                   	push   %ebp
  101750:	89 e5                	mov    %esp,%ebp
  101752:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101755:	8b 45 08             	mov    0x8(%ebp),%eax
  101758:	ba 01 00 00 00       	mov    $0x1,%edx
  10175d:	88 c1                	mov    %al,%cl
  10175f:	d3 e2                	shl    %cl,%edx
  101761:	89 d0                	mov    %edx,%eax
  101763:	98                   	cwtl   
  101764:	f7 d0                	not    %eax
  101766:	0f bf d0             	movswl %ax,%edx
  101769:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  101770:	98                   	cwtl   
  101771:	21 d0                	and    %edx,%eax
  101773:	98                   	cwtl   
  101774:	0f b7 c0             	movzwl %ax,%eax
  101777:	89 04 24             	mov    %eax,(%esp)
  10177a:	e8 6d ff ff ff       	call   1016ec <pic_setmask>
}
  10177f:	90                   	nop
  101780:	c9                   	leave  
  101781:	c3                   	ret    

00101782 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101782:	f3 0f 1e fb          	endbr32 
  101786:	55                   	push   %ebp
  101787:	89 e5                	mov    %esp,%ebp
  101789:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10178c:	c7 05 8c 10 11 00 01 	movl   $0x1,0x11108c
  101793:	00 00 00 
  101796:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  10179c:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017a0:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017a4:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017a8:	ee                   	out    %al,(%dx)
}
  1017a9:	90                   	nop
  1017aa:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1017b0:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017b4:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017b8:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017bc:	ee                   	out    %al,(%dx)
}
  1017bd:	90                   	nop
  1017be:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017c4:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017c8:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017cc:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017d0:	ee                   	out    %al,(%dx)
}
  1017d1:	90                   	nop
  1017d2:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1017d8:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017dc:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017e0:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017e4:	ee                   	out    %al,(%dx)
}
  1017e5:	90                   	nop
  1017e6:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1017ec:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017f0:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017f4:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017f8:	ee                   	out    %al,(%dx)
}
  1017f9:	90                   	nop
  1017fa:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101800:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101804:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101808:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10180c:	ee                   	out    %al,(%dx)
}
  10180d:	90                   	nop
  10180e:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101814:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101818:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10181c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101820:	ee                   	out    %al,(%dx)
}
  101821:	90                   	nop
  101822:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101828:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10182c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101830:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101834:	ee                   	out    %al,(%dx)
}
  101835:	90                   	nop
  101836:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  10183c:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101840:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101844:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101848:	ee                   	out    %al,(%dx)
}
  101849:	90                   	nop
  10184a:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101850:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101854:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101858:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10185c:	ee                   	out    %al,(%dx)
}
  10185d:	90                   	nop
  10185e:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101864:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101868:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10186c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101870:	ee                   	out    %al,(%dx)
}
  101871:	90                   	nop
  101872:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101878:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10187c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101880:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101884:	ee                   	out    %al,(%dx)
}
  101885:	90                   	nop
  101886:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  10188c:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101890:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101894:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101898:	ee                   	out    %al,(%dx)
}
  101899:	90                   	nop
  10189a:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018a0:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018a4:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018a8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1018ac:	ee                   	out    %al,(%dx)
}
  1018ad:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018ae:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018b5:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1018ba:	74 0f                	je     1018cb <pic_init+0x149>
        pic_setmask(irq_mask);
  1018bc:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018c3:	89 04 24             	mov    %eax,(%esp)
  1018c6:	e8 21 fe ff ff       	call   1016ec <pic_setmask>
    }
}
  1018cb:	90                   	nop
  1018cc:	c9                   	leave  
  1018cd:	c3                   	ret    

001018ce <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1018ce:	f3 0f 1e fb          	endbr32 
  1018d2:	55                   	push   %ebp
  1018d3:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1018d5:	fb                   	sti    
}
  1018d6:	90                   	nop
    sti();
}
  1018d7:	90                   	nop
  1018d8:	5d                   	pop    %ebp
  1018d9:	c3                   	ret    

001018da <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1018da:	f3 0f 1e fb          	endbr32 
  1018de:	55                   	push   %ebp
  1018df:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  1018e1:	fa                   	cli    
}
  1018e2:	90                   	nop
    cli();
}
  1018e3:	90                   	nop
  1018e4:	5d                   	pop    %ebp
  1018e5:	c3                   	ret    

001018e6 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1018e6:	f3 0f 1e fb          	endbr32 
  1018ea:	55                   	push   %ebp
  1018eb:	89 e5                	mov    %esp,%ebp
  1018ed:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1018f0:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018f7:	00 
  1018f8:	c7 04 24 60 3b 10 00 	movl   $0x103b60,(%esp)
  1018ff:	e8 90 e9 ff ff       	call   100294 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101904:	90                   	nop
  101905:	c9                   	leave  
  101906:	c3                   	ret    

00101907 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101907:	f3 0f 1e fb          	endbr32 
  10190b:	55                   	push   %ebp
  10190c:	89 e5                	mov    %esp,%ebp
  10190e:	83 ec 10             	sub    $0x10,%esp
      */
    // (1)
    extern uintptr_t __vectors[];
    // (2)
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101911:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101918:	e9 c4 00 00 00       	jmp    1019e1 <idt_init+0xda>
        SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL); // trapno = i, gd_type = Interrupt-gate descriptor, DPL = 0
  10191d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101920:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  101927:	0f b7 d0             	movzwl %ax,%edx
  10192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192d:	66 89 14 c5 a0 10 11 	mov    %dx,0x1110a0(,%eax,8)
  101934:	00 
  101935:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101938:	66 c7 04 c5 a2 10 11 	movw   $0x8,0x1110a2(,%eax,8)
  10193f:	00 08 00 
  101942:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101945:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  10194c:	00 
  10194d:	80 e2 e0             	and    $0xe0,%dl
  101950:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  101957:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195a:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  101961:	00 
  101962:	80 e2 1f             	and    $0x1f,%dl
  101965:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  10196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196f:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  101976:	00 
  101977:	80 e2 f0             	and    $0xf0,%dl
  10197a:	80 ca 0e             	or     $0xe,%dl
  10197d:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101987:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  10198e:	00 
  10198f:	80 e2 ef             	and    $0xef,%dl
  101992:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  101999:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10199c:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019a3:	00 
  1019a4:	80 e2 9f             	and    $0x9f,%dl
  1019a7:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b1:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019b8:	00 
  1019b9:	80 ca 80             	or     $0x80,%dl
  1019bc:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c6:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  1019cd:	c1 e8 10             	shr    $0x10,%eax
  1019d0:	0f b7 d0             	movzwl %ax,%edx
  1019d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d6:	66 89 14 c5 a6 10 11 	mov    %dx,0x1110a6(,%eax,8)
  1019dd:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1019de:	ff 45 fc             	incl   -0x4(%ebp)
  1019e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e4:	3d ff 00 00 00       	cmp    $0xff,%eax
  1019e9:	0f 86 2e ff ff ff    	jbe    10191d <idt_init+0x16>
    }
	// 系统调用中断
    SETGATE(idt[T_SYSCALL], 1, KERNEL_CS, __vectors[T_SYSCALL], DPL_USER); // trapno = T_SYSCALL = 0x80，gd_type = Trap-gate descriptor，DPL = 3
  1019ef:	a1 e0 07 11 00       	mov    0x1107e0,%eax
  1019f4:	0f b7 c0             	movzwl %ax,%eax
  1019f7:	66 a3 a0 14 11 00    	mov    %ax,0x1114a0
  1019fd:	66 c7 05 a2 14 11 00 	movw   $0x8,0x1114a2
  101a04:	08 00 
  101a06:	0f b6 05 a4 14 11 00 	movzbl 0x1114a4,%eax
  101a0d:	24 e0                	and    $0xe0,%al
  101a0f:	a2 a4 14 11 00       	mov    %al,0x1114a4
  101a14:	0f b6 05 a4 14 11 00 	movzbl 0x1114a4,%eax
  101a1b:	24 1f                	and    $0x1f,%al
  101a1d:	a2 a4 14 11 00       	mov    %al,0x1114a4
  101a22:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a29:	0c 0f                	or     $0xf,%al
  101a2b:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101a30:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a37:	24 ef                	and    $0xef,%al
  101a39:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101a3e:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a45:	0c 60                	or     $0x60,%al
  101a47:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101a4c:	0f b6 05 a5 14 11 00 	movzbl 0x1114a5,%eax
  101a53:	0c 80                	or     $0x80,%al
  101a55:	a2 a5 14 11 00       	mov    %al,0x1114a5
  101a5a:	a1 e0 07 11 00       	mov    0x1107e0,%eax
  101a5f:	c1 e8 10             	shr    $0x10,%eax
  101a62:	0f b7 c0             	movzwl %ax,%eax
  101a65:	66 a3 a6 14 11 00    	mov    %ax,0x1114a6
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
  101a6b:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101a70:	0f b7 c0             	movzwl %ax,%eax
  101a73:	66 a3 68 14 11 00    	mov    %ax,0x111468
  101a79:	66 c7 05 6a 14 11 00 	movw   $0x8,0x11146a
  101a80:	08 00 
  101a82:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101a89:	24 e0                	and    $0xe0,%al
  101a8b:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a90:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101a97:	24 1f                	and    $0x1f,%al
  101a99:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a9e:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101aa5:	0c 0f                	or     $0xf,%al
  101aa7:	a2 6d 14 11 00       	mov    %al,0x11146d
  101aac:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101ab3:	24 ef                	and    $0xef,%al
  101ab5:	a2 6d 14 11 00       	mov    %al,0x11146d
  101aba:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101ac1:	0c 60                	or     $0x60,%al
  101ac3:	a2 6d 14 11 00       	mov    %al,0x11146d
  101ac8:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101acf:	0c 80                	or     $0x80,%al
  101ad1:	a2 6d 14 11 00       	mov    %al,0x11146d
  101ad6:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101adb:	c1 e8 10             	shr    $0x10,%eax
  101ade:	0f b7 c0             	movzwl %ax,%eax
  101ae1:	66 a3 6e 14 11 00    	mov    %ax,0x11146e
  101ae7:	c7 45 f8 60 05 11 00 	movl   $0x110560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101aee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101af1:	0f 01 18             	lidtl  (%eax)
}
  101af4:	90                   	nop
	// (3)
    lidt(&idt_pd);
}
  101af5:	90                   	nop
  101af6:	c9                   	leave  
  101af7:	c3                   	ret    

00101af8 <trapname>:

static const char *
trapname(int trapno) {
  101af8:	f3 0f 1e fb          	endbr32 
  101afc:	55                   	push   %ebp
  101afd:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101aff:	8b 45 08             	mov    0x8(%ebp),%eax
  101b02:	83 f8 13             	cmp    $0x13,%eax
  101b05:	77 0c                	ja     101b13 <trapname+0x1b>
        return excnames[trapno];
  101b07:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0a:	8b 04 85 20 3f 10 00 	mov    0x103f20(,%eax,4),%eax
  101b11:	eb 18                	jmp    101b2b <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b13:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b17:	7e 0d                	jle    101b26 <trapname+0x2e>
  101b19:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b1d:	7f 07                	jg     101b26 <trapname+0x2e>
        return "Hardware Interrupt";
  101b1f:	b8 6a 3b 10 00       	mov    $0x103b6a,%eax
  101b24:	eb 05                	jmp    101b2b <trapname+0x33>
    }
    return "(unknown trap)";
  101b26:	b8 7d 3b 10 00       	mov    $0x103b7d,%eax
}
  101b2b:	5d                   	pop    %ebp
  101b2c:	c3                   	ret    

00101b2d <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b2d:	f3 0f 1e fb          	endbr32 
  101b31:	55                   	push   %ebp
  101b32:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b34:	8b 45 08             	mov    0x8(%ebp),%eax
  101b37:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b3b:	83 f8 08             	cmp    $0x8,%eax
  101b3e:	0f 94 c0             	sete   %al
  101b41:	0f b6 c0             	movzbl %al,%eax
}
  101b44:	5d                   	pop    %ebp
  101b45:	c3                   	ret    

00101b46 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b46:	f3 0f 1e fb          	endbr32 
  101b4a:	55                   	push   %ebp
  101b4b:	89 e5                	mov    %esp,%ebp
  101b4d:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b50:	8b 45 08             	mov    0x8(%ebp),%eax
  101b53:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b57:	c7 04 24 be 3b 10 00 	movl   $0x103bbe,(%esp)
  101b5e:	e8 31 e7 ff ff       	call   100294 <cprintf>
    print_regs(&tf->tf_regs);
  101b63:	8b 45 08             	mov    0x8(%ebp),%eax
  101b66:	89 04 24             	mov    %eax,(%esp)
  101b69:	e8 8d 01 00 00       	call   101cfb <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b71:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b75:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b79:	c7 04 24 cf 3b 10 00 	movl   $0x103bcf,(%esp)
  101b80:	e8 0f e7 ff ff       	call   100294 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b85:	8b 45 08             	mov    0x8(%ebp),%eax
  101b88:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b90:	c7 04 24 e2 3b 10 00 	movl   $0x103be2,(%esp)
  101b97:	e8 f8 e6 ff ff       	call   100294 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba7:	c7 04 24 f5 3b 10 00 	movl   $0x103bf5,(%esp)
  101bae:	e8 e1 e6 ff ff       	call   100294 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb6:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101bba:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbe:	c7 04 24 08 3c 10 00 	movl   $0x103c08,(%esp)
  101bc5:	e8 ca e6 ff ff       	call   100294 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101bca:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcd:	8b 40 30             	mov    0x30(%eax),%eax
  101bd0:	89 04 24             	mov    %eax,(%esp)
  101bd3:	e8 20 ff ff ff       	call   101af8 <trapname>
  101bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  101bdb:	8b 52 30             	mov    0x30(%edx),%edx
  101bde:	89 44 24 08          	mov    %eax,0x8(%esp)
  101be2:	89 54 24 04          	mov    %edx,0x4(%esp)
  101be6:	c7 04 24 1b 3c 10 00 	movl   $0x103c1b,(%esp)
  101bed:	e8 a2 e6 ff ff       	call   100294 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf5:	8b 40 34             	mov    0x34(%eax),%eax
  101bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfc:	c7 04 24 2d 3c 10 00 	movl   $0x103c2d,(%esp)
  101c03:	e8 8c e6 ff ff       	call   100294 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c08:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0b:	8b 40 38             	mov    0x38(%eax),%eax
  101c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c12:	c7 04 24 3c 3c 10 00 	movl   $0x103c3c,(%esp)
  101c19:	e8 76 e6 ff ff       	call   100294 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c21:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c25:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c29:	c7 04 24 4b 3c 10 00 	movl   $0x103c4b,(%esp)
  101c30:	e8 5f e6 ff ff       	call   100294 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c35:	8b 45 08             	mov    0x8(%ebp),%eax
  101c38:	8b 40 40             	mov    0x40(%eax),%eax
  101c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3f:	c7 04 24 5e 3c 10 00 	movl   $0x103c5e,(%esp)
  101c46:	e8 49 e6 ff ff       	call   100294 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c52:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c59:	eb 3d                	jmp    101c98 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5e:	8b 50 40             	mov    0x40(%eax),%edx
  101c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c64:	21 d0                	and    %edx,%eax
  101c66:	85 c0                	test   %eax,%eax
  101c68:	74 28                	je     101c92 <print_trapframe+0x14c>
  101c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c6d:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101c74:	85 c0                	test   %eax,%eax
  101c76:	74 1a                	je     101c92 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c7b:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101c82:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c86:	c7 04 24 6d 3c 10 00 	movl   $0x103c6d,(%esp)
  101c8d:	e8 02 e6 ff ff       	call   100294 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c92:	ff 45 f4             	incl   -0xc(%ebp)
  101c95:	d1 65 f0             	shll   -0x10(%ebp)
  101c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c9b:	83 f8 17             	cmp    $0x17,%eax
  101c9e:	76 bb                	jbe    101c5b <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca3:	8b 40 40             	mov    0x40(%eax),%eax
  101ca6:	c1 e8 0c             	shr    $0xc,%eax
  101ca9:	83 e0 03             	and    $0x3,%eax
  101cac:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb0:	c7 04 24 71 3c 10 00 	movl   $0x103c71,(%esp)
  101cb7:	e8 d8 e5 ff ff       	call   100294 <cprintf>

    if (!trap_in_kernel(tf)) {
  101cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbf:	89 04 24             	mov    %eax,(%esp)
  101cc2:	e8 66 fe ff ff       	call   101b2d <trap_in_kernel>
  101cc7:	85 c0                	test   %eax,%eax
  101cc9:	75 2d                	jne    101cf8 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cce:	8b 40 44             	mov    0x44(%eax),%eax
  101cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd5:	c7 04 24 7a 3c 10 00 	movl   $0x103c7a,(%esp)
  101cdc:	e8 b3 e5 ff ff       	call   100294 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce4:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cec:	c7 04 24 89 3c 10 00 	movl   $0x103c89,(%esp)
  101cf3:	e8 9c e5 ff ff       	call   100294 <cprintf>
    }
}
  101cf8:	90                   	nop
  101cf9:	c9                   	leave  
  101cfa:	c3                   	ret    

00101cfb <print_regs>:

void
print_regs(struct pushregs *regs) {
  101cfb:	f3 0f 1e fb          	endbr32 
  101cff:	55                   	push   %ebp
  101d00:	89 e5                	mov    %esp,%ebp
  101d02:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d05:	8b 45 08             	mov    0x8(%ebp),%eax
  101d08:	8b 00                	mov    (%eax),%eax
  101d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d0e:	c7 04 24 9c 3c 10 00 	movl   $0x103c9c,(%esp)
  101d15:	e8 7a e5 ff ff       	call   100294 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1d:	8b 40 04             	mov    0x4(%eax),%eax
  101d20:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d24:	c7 04 24 ab 3c 10 00 	movl   $0x103cab,(%esp)
  101d2b:	e8 64 e5 ff ff       	call   100294 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d30:	8b 45 08             	mov    0x8(%ebp),%eax
  101d33:	8b 40 08             	mov    0x8(%eax),%eax
  101d36:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d3a:	c7 04 24 ba 3c 10 00 	movl   $0x103cba,(%esp)
  101d41:	e8 4e e5 ff ff       	call   100294 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d46:	8b 45 08             	mov    0x8(%ebp),%eax
  101d49:	8b 40 0c             	mov    0xc(%eax),%eax
  101d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d50:	c7 04 24 c9 3c 10 00 	movl   $0x103cc9,(%esp)
  101d57:	e8 38 e5 ff ff       	call   100294 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5f:	8b 40 10             	mov    0x10(%eax),%eax
  101d62:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d66:	c7 04 24 d8 3c 10 00 	movl   $0x103cd8,(%esp)
  101d6d:	e8 22 e5 ff ff       	call   100294 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d72:	8b 45 08             	mov    0x8(%ebp),%eax
  101d75:	8b 40 14             	mov    0x14(%eax),%eax
  101d78:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d7c:	c7 04 24 e7 3c 10 00 	movl   $0x103ce7,(%esp)
  101d83:	e8 0c e5 ff ff       	call   100294 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d88:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8b:	8b 40 18             	mov    0x18(%eax),%eax
  101d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d92:	c7 04 24 f6 3c 10 00 	movl   $0x103cf6,(%esp)
  101d99:	e8 f6 e4 ff ff       	call   100294 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101da1:	8b 40 1c             	mov    0x1c(%eax),%eax
  101da4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101da8:	c7 04 24 05 3d 10 00 	movl   $0x103d05,(%esp)
  101daf:	e8 e0 e4 ff ff       	call   100294 <cprintf>
}
  101db4:	90                   	nop
  101db5:	c9                   	leave  
  101db6:	c3                   	ret    

00101db7 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101db7:	f3 0f 1e fb          	endbr32 
  101dbb:	55                   	push   %ebp
  101dbc:	89 e5                	mov    %esp,%ebp
  101dbe:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc4:	8b 40 30             	mov    0x30(%eax),%eax
  101dc7:	83 f8 79             	cmp    $0x79,%eax
  101dca:	0f 84 06 02 00 00    	je     101fd6 <trap_dispatch+0x21f>
  101dd0:	83 f8 79             	cmp    $0x79,%eax
  101dd3:	0f 87 4e 02 00 00    	ja     102027 <trap_dispatch+0x270>
  101dd9:	83 f8 78             	cmp    $0x78,%eax
  101ddc:	0f 84 92 01 00 00    	je     101f74 <trap_dispatch+0x1bd>
  101de2:	83 f8 78             	cmp    $0x78,%eax
  101de5:	0f 87 3c 02 00 00    	ja     102027 <trap_dispatch+0x270>
  101deb:	83 f8 2f             	cmp    $0x2f,%eax
  101dee:	0f 87 33 02 00 00    	ja     102027 <trap_dispatch+0x270>
  101df4:	83 f8 2e             	cmp    $0x2e,%eax
  101df7:	0f 83 5f 02 00 00    	jae    10205c <trap_dispatch+0x2a5>
  101dfd:	83 f8 24             	cmp    $0x24,%eax
  101e00:	74 5e                	je     101e60 <trap_dispatch+0xa9>
  101e02:	83 f8 24             	cmp    $0x24,%eax
  101e05:	0f 87 1c 02 00 00    	ja     102027 <trap_dispatch+0x270>
  101e0b:	83 f8 20             	cmp    $0x20,%eax
  101e0e:	74 0a                	je     101e1a <trap_dispatch+0x63>
  101e10:	83 f8 21             	cmp    $0x21,%eax
  101e13:	74 74                	je     101e89 <trap_dispatch+0xd2>
  101e15:	e9 0d 02 00 00       	jmp    102027 <trap_dispatch+0x270>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a function, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++; // (1)
  101e1a:	a1 08 19 11 00       	mov    0x111908,%eax
  101e1f:	40                   	inc    %eax
  101e20:	a3 08 19 11 00       	mov    %eax,0x111908
        if (ticks % TICK_NUM == 0) {
  101e25:	8b 0d 08 19 11 00    	mov    0x111908,%ecx
  101e2b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e30:	89 c8                	mov    %ecx,%eax
  101e32:	f7 e2                	mul    %edx
  101e34:	c1 ea 05             	shr    $0x5,%edx
  101e37:	89 d0                	mov    %edx,%eax
  101e39:	c1 e0 02             	shl    $0x2,%eax
  101e3c:	01 d0                	add    %edx,%eax
  101e3e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101e45:	01 d0                	add    %edx,%eax
  101e47:	c1 e0 02             	shl    $0x2,%eax
  101e4a:	29 c1                	sub    %eax,%ecx
  101e4c:	89 ca                	mov    %ecx,%edx
  101e4e:	85 d2                	test   %edx,%edx
  101e50:	0f 85 09 02 00 00    	jne    10205f <trap_dispatch+0x2a8>
            print_ticks(); // (2)
  101e56:	e8 8b fa ff ff       	call   1018e6 <print_ticks>
        }
        break;
  101e5b:	e9 ff 01 00 00       	jmp    10205f <trap_dispatch+0x2a8>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e60:	e8 27 f8 ff ff       	call   10168c <cons_getc>
  101e65:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e68:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e6c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e70:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e74:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e78:	c7 04 24 14 3d 10 00 	movl   $0x103d14,(%esp)
  101e7f:	e8 10 e4 ff ff       	call   100294 <cprintf>
        break;
  101e84:	e9 e0 01 00 00       	jmp    102069 <trap_dispatch+0x2b2>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e89:	e8 fe f7 ff ff       	call   10168c <cons_getc>
  101e8e:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e91:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e95:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e99:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ea1:	c7 04 24 26 3d 10 00 	movl   $0x103d26,(%esp)
  101ea8:	e8 e7 e3 ff ff       	call   100294 <cprintf>
        if(c == '0' && (tf->tf_cs & 3) != 0)
  101ead:	80 7d f7 30          	cmpb   $0x30,-0x9(%ebp)
  101eb1:	75 52                	jne    101f05 <trap_dispatch+0x14e>
  101eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101eba:	83 e0 03             	and    $0x3,%eax
  101ebd:	85 c0                	test   %eax,%eax
  101ebf:	74 44                	je     101f05 <trap_dispatch+0x14e>
        {
                cprintf("Input 0......switch to kernel\n");
  101ec1:	c7 04 24 38 3d 10 00 	movl   $0x103d38,(%esp)
  101ec8:	e8 c7 e3 ff ff       	call   100294 <cprintf>
                tf->tf_cs = KERNEL_CS;
  101ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed0:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
                tf->tf_ds = tf->tf_es = KERNEL_DS;
  101ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed9:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101edf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee2:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee9:	66 89 50 2c          	mov    %dx,0x2c(%eax)
                tf->tf_eflags &= ~FL_IOPL_MASK;
  101eed:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef0:	8b 40 40             	mov    0x40(%eax),%eax
  101ef3:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101ef8:	89 c2                	mov    %eax,%edx
  101efa:	8b 45 08             	mov    0x8(%ebp),%eax
  101efd:	89 50 40             	mov    %edx,0x40(%eax)
                cprintf("Input 3......switch to user\n");
                tf->tf_cs = USER_CS;
                tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
                tf->tf_eflags |= FL_IOPL_MASK;
        }
        break;
  101f00:	e9 5d 01 00 00       	jmp    102062 <trap_dispatch+0x2ab>
        else if (c == '3' && (tf->tf_cs & 3) != 3)
  101f05:	80 7d f7 33          	cmpb   $0x33,-0x9(%ebp)
  101f09:	0f 85 53 01 00 00    	jne    102062 <trap_dispatch+0x2ab>
  101f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101f12:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f16:	83 e0 03             	and    $0x3,%eax
  101f19:	83 f8 03             	cmp    $0x3,%eax
  101f1c:	0f 84 40 01 00 00    	je     102062 <trap_dispatch+0x2ab>
                cprintf("Input 3......switch to user\n");
  101f22:	c7 04 24 57 3d 10 00 	movl   $0x103d57,(%esp)
  101f29:	e8 66 e3 ff ff       	call   100294 <cprintf>
                tf->tf_cs = USER_CS;
  101f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f31:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
                tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  101f37:	8b 45 08             	mov    0x8(%ebp),%eax
  101f3a:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101f40:	8b 45 08             	mov    0x8(%ebp),%eax
  101f43:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101f47:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4a:	66 89 50 28          	mov    %dx,0x28(%eax)
  101f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f51:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f55:	8b 45 08             	mov    0x8(%ebp),%eax
  101f58:	66 89 50 2c          	mov    %dx,0x2c(%eax)
                tf->tf_eflags |= FL_IOPL_MASK;
  101f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5f:	8b 40 40             	mov    0x40(%eax),%eax
  101f62:	0d 00 30 00 00       	or     $0x3000,%eax
  101f67:	89 c2                	mov    %eax,%edx
  101f69:	8b 45 08             	mov    0x8(%ebp),%eax
  101f6c:	89 50 40             	mov    %edx,0x40(%eax)
        break;
  101f6f:	e9 ee 00 00 00       	jmp    102062 <trap_dispatch+0x2ab>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
 	case T_SWITCH_TOU:
        if(tf->tf_cs != USER_CS)	//检查是不是用户态，不是就操作
  101f74:	8b 45 08             	mov    0x8(%ebp),%eax
  101f77:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f7b:	83 f8 1b             	cmp    $0x1b,%eax
  101f7e:	0f 84 e1 00 00 00    	je     102065 <trap_dispatch+0x2ae>
        {
                cprintf("Switch to user\n");
  101f84:	c7 04 24 74 3d 10 00 	movl   $0x103d74,(%esp)
  101f8b:	e8 04 e3 ff ff       	call   100294 <cprintf>
                // 设置用户态对应的cs,ds,es,ss四个寄存器
            	tf->tf_cs = USER_CS;
  101f90:	8b 45 08             	mov    0x8(%ebp),%eax
  101f93:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
                tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  101f99:	8b 45 08             	mov    0x8(%ebp),%eax
  101f9c:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa5:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  101fac:	66 89 50 28          	mov    %dx,0x28(%eax)
  101fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  101fb3:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  101fba:	66 89 50 2c          	mov    %dx,0x2c(%eax)
                // 降低IO权限，使用户态可以使用IO
                tf->tf_eflags |= FL_IOPL_MASK;
  101fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  101fc1:	8b 40 40             	mov    0x40(%eax),%eax
  101fc4:	0d 00 30 00 00       	or     $0x3000,%eax
  101fc9:	89 c2                	mov    %eax,%edx
  101fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101fce:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  101fd1:	e9 8f 00 00 00       	jmp    102065 <trap_dispatch+0x2ae>

	case T_SWITCH_TOK:
        if(tf->tf_cs != KERNEL_CS)	//检查是不是内核态，不是就操作
  101fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fdd:	83 f8 08             	cmp    $0x8,%eax
  101fe0:	0f 84 82 00 00 00    	je     102068 <trap_dispatch+0x2b1>
        {          
                cprintf("Switch to kernel\n");
  101fe6:	c7 04 24 84 3d 10 00 	movl   $0x103d84,(%esp)
  101fed:	e8 a2 e2 ff ff       	call   100294 <cprintf>
            	// 设置内核态对应的cs,ds,es三个寄存器
                tf->tf_cs = KERNEL_CS;
  101ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ff5:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
                tf->tf_ds = tf->tf_es = KERNEL_DS;
  101ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ffe:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  102004:	8b 45 08             	mov    0x8(%ebp),%eax
  102007:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  10200b:	8b 45 08             	mov    0x8(%ebp),%eax
  10200e:	66 89 50 2c          	mov    %dx,0x2c(%eax)
				// 用户态不再能使用I/O
                tf->tf_eflags &= ~FL_IOPL_MASK;
  102012:	8b 45 08             	mov    0x8(%ebp),%eax
  102015:	8b 40 40             	mov    0x40(%eax),%eax
  102018:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  10201d:	89 c2                	mov    %eax,%edx
  10201f:	8b 45 08             	mov    0x8(%ebp),%eax
  102022:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  102025:	eb 41                	jmp    102068 <trap_dispatch+0x2b1>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  102027:	8b 45 08             	mov    0x8(%ebp),%eax
  10202a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10202e:	83 e0 03             	and    $0x3,%eax
  102031:	85 c0                	test   %eax,%eax
  102033:	75 34                	jne    102069 <trap_dispatch+0x2b2>
            print_trapframe(tf);
  102035:	8b 45 08             	mov    0x8(%ebp),%eax
  102038:	89 04 24             	mov    %eax,(%esp)
  10203b:	e8 06 fb ff ff       	call   101b46 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  102040:	c7 44 24 08 96 3d 10 	movl   $0x103d96,0x8(%esp)
  102047:	00 
  102048:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  10204f:	00 
  102050:	c7 04 24 b2 3d 10 00 	movl   $0x103db2,(%esp)
  102057:	e8 a4 e3 ff ff       	call   100400 <__panic>
        break;
  10205c:	90                   	nop
  10205d:	eb 0a                	jmp    102069 <trap_dispatch+0x2b2>
        break;
  10205f:	90                   	nop
  102060:	eb 07                	jmp    102069 <trap_dispatch+0x2b2>
        break;
  102062:	90                   	nop
  102063:	eb 04                	jmp    102069 <trap_dispatch+0x2b2>
        break;
  102065:	90                   	nop
  102066:	eb 01                	jmp    102069 <trap_dispatch+0x2b2>
        break;
  102068:	90                   	nop
        }
    }
}
  102069:	90                   	nop
  10206a:	c9                   	leave  
  10206b:	c3                   	ret    

0010206c <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  10206c:	f3 0f 1e fb          	endbr32 
  102070:	55                   	push   %ebp
  102071:	89 e5                	mov    %esp,%ebp
  102073:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  102076:	8b 45 08             	mov    0x8(%ebp),%eax
  102079:	89 04 24             	mov    %eax,(%esp)
  10207c:	e8 36 fd ff ff       	call   101db7 <trap_dispatch>
}
  102081:	90                   	nop
  102082:	c9                   	leave  
  102083:	c3                   	ret    

00102084 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $0
  102086:	6a 00                	push   $0x0
  jmp __alltraps
  102088:	e9 69 0a 00 00       	jmp    102af6 <__alltraps>

0010208d <vector1>:
.globl vector1
vector1:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $1
  10208f:	6a 01                	push   $0x1
  jmp __alltraps
  102091:	e9 60 0a 00 00       	jmp    102af6 <__alltraps>

00102096 <vector2>:
.globl vector2
vector2:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $2
  102098:	6a 02                	push   $0x2
  jmp __alltraps
  10209a:	e9 57 0a 00 00       	jmp    102af6 <__alltraps>

0010209f <vector3>:
.globl vector3
vector3:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $3
  1020a1:	6a 03                	push   $0x3
  jmp __alltraps
  1020a3:	e9 4e 0a 00 00       	jmp    102af6 <__alltraps>

001020a8 <vector4>:
.globl vector4
vector4:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $4
  1020aa:	6a 04                	push   $0x4
  jmp __alltraps
  1020ac:	e9 45 0a 00 00       	jmp    102af6 <__alltraps>

001020b1 <vector5>:
.globl vector5
vector5:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $5
  1020b3:	6a 05                	push   $0x5
  jmp __alltraps
  1020b5:	e9 3c 0a 00 00       	jmp    102af6 <__alltraps>

001020ba <vector6>:
.globl vector6
vector6:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $6
  1020bc:	6a 06                	push   $0x6
  jmp __alltraps
  1020be:	e9 33 0a 00 00       	jmp    102af6 <__alltraps>

001020c3 <vector7>:
.globl vector7
vector7:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $7
  1020c5:	6a 07                	push   $0x7
  jmp __alltraps
  1020c7:	e9 2a 0a 00 00       	jmp    102af6 <__alltraps>

001020cc <vector8>:
.globl vector8
vector8:
  pushl $8
  1020cc:	6a 08                	push   $0x8
  jmp __alltraps
  1020ce:	e9 23 0a 00 00       	jmp    102af6 <__alltraps>

001020d3 <vector9>:
.globl vector9
vector9:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $9
  1020d5:	6a 09                	push   $0x9
  jmp __alltraps
  1020d7:	e9 1a 0a 00 00       	jmp    102af6 <__alltraps>

001020dc <vector10>:
.globl vector10
vector10:
  pushl $10
  1020dc:	6a 0a                	push   $0xa
  jmp __alltraps
  1020de:	e9 13 0a 00 00       	jmp    102af6 <__alltraps>

001020e3 <vector11>:
.globl vector11
vector11:
  pushl $11
  1020e3:	6a 0b                	push   $0xb
  jmp __alltraps
  1020e5:	e9 0c 0a 00 00       	jmp    102af6 <__alltraps>

001020ea <vector12>:
.globl vector12
vector12:
  pushl $12
  1020ea:	6a 0c                	push   $0xc
  jmp __alltraps
  1020ec:	e9 05 0a 00 00       	jmp    102af6 <__alltraps>

001020f1 <vector13>:
.globl vector13
vector13:
  pushl $13
  1020f1:	6a 0d                	push   $0xd
  jmp __alltraps
  1020f3:	e9 fe 09 00 00       	jmp    102af6 <__alltraps>

001020f8 <vector14>:
.globl vector14
vector14:
  pushl $14
  1020f8:	6a 0e                	push   $0xe
  jmp __alltraps
  1020fa:	e9 f7 09 00 00       	jmp    102af6 <__alltraps>

001020ff <vector15>:
.globl vector15
vector15:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $15
  102101:	6a 0f                	push   $0xf
  jmp __alltraps
  102103:	e9 ee 09 00 00       	jmp    102af6 <__alltraps>

00102108 <vector16>:
.globl vector16
vector16:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $16
  10210a:	6a 10                	push   $0x10
  jmp __alltraps
  10210c:	e9 e5 09 00 00       	jmp    102af6 <__alltraps>

00102111 <vector17>:
.globl vector17
vector17:
  pushl $17
  102111:	6a 11                	push   $0x11
  jmp __alltraps
  102113:	e9 de 09 00 00       	jmp    102af6 <__alltraps>

00102118 <vector18>:
.globl vector18
vector18:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $18
  10211a:	6a 12                	push   $0x12
  jmp __alltraps
  10211c:	e9 d5 09 00 00       	jmp    102af6 <__alltraps>

00102121 <vector19>:
.globl vector19
vector19:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $19
  102123:	6a 13                	push   $0x13
  jmp __alltraps
  102125:	e9 cc 09 00 00       	jmp    102af6 <__alltraps>

0010212a <vector20>:
.globl vector20
vector20:
  pushl $0
  10212a:	6a 00                	push   $0x0
  pushl $20
  10212c:	6a 14                	push   $0x14
  jmp __alltraps
  10212e:	e9 c3 09 00 00       	jmp    102af6 <__alltraps>

00102133 <vector21>:
.globl vector21
vector21:
  pushl $0
  102133:	6a 00                	push   $0x0
  pushl $21
  102135:	6a 15                	push   $0x15
  jmp __alltraps
  102137:	e9 ba 09 00 00       	jmp    102af6 <__alltraps>

0010213c <vector22>:
.globl vector22
vector22:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $22
  10213e:	6a 16                	push   $0x16
  jmp __alltraps
  102140:	e9 b1 09 00 00       	jmp    102af6 <__alltraps>

00102145 <vector23>:
.globl vector23
vector23:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $23
  102147:	6a 17                	push   $0x17
  jmp __alltraps
  102149:	e9 a8 09 00 00       	jmp    102af6 <__alltraps>

0010214e <vector24>:
.globl vector24
vector24:
  pushl $0
  10214e:	6a 00                	push   $0x0
  pushl $24
  102150:	6a 18                	push   $0x18
  jmp __alltraps
  102152:	e9 9f 09 00 00       	jmp    102af6 <__alltraps>

00102157 <vector25>:
.globl vector25
vector25:
  pushl $0
  102157:	6a 00                	push   $0x0
  pushl $25
  102159:	6a 19                	push   $0x19
  jmp __alltraps
  10215b:	e9 96 09 00 00       	jmp    102af6 <__alltraps>

00102160 <vector26>:
.globl vector26
vector26:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $26
  102162:	6a 1a                	push   $0x1a
  jmp __alltraps
  102164:	e9 8d 09 00 00       	jmp    102af6 <__alltraps>

00102169 <vector27>:
.globl vector27
vector27:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $27
  10216b:	6a 1b                	push   $0x1b
  jmp __alltraps
  10216d:	e9 84 09 00 00       	jmp    102af6 <__alltraps>

00102172 <vector28>:
.globl vector28
vector28:
  pushl $0
  102172:	6a 00                	push   $0x0
  pushl $28
  102174:	6a 1c                	push   $0x1c
  jmp __alltraps
  102176:	e9 7b 09 00 00       	jmp    102af6 <__alltraps>

0010217b <vector29>:
.globl vector29
vector29:
  pushl $0
  10217b:	6a 00                	push   $0x0
  pushl $29
  10217d:	6a 1d                	push   $0x1d
  jmp __alltraps
  10217f:	e9 72 09 00 00       	jmp    102af6 <__alltraps>

00102184 <vector30>:
.globl vector30
vector30:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $30
  102186:	6a 1e                	push   $0x1e
  jmp __alltraps
  102188:	e9 69 09 00 00       	jmp    102af6 <__alltraps>

0010218d <vector31>:
.globl vector31
vector31:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $31
  10218f:	6a 1f                	push   $0x1f
  jmp __alltraps
  102191:	e9 60 09 00 00       	jmp    102af6 <__alltraps>

00102196 <vector32>:
.globl vector32
vector32:
  pushl $0
  102196:	6a 00                	push   $0x0
  pushl $32
  102198:	6a 20                	push   $0x20
  jmp __alltraps
  10219a:	e9 57 09 00 00       	jmp    102af6 <__alltraps>

0010219f <vector33>:
.globl vector33
vector33:
  pushl $0
  10219f:	6a 00                	push   $0x0
  pushl $33
  1021a1:	6a 21                	push   $0x21
  jmp __alltraps
  1021a3:	e9 4e 09 00 00       	jmp    102af6 <__alltraps>

001021a8 <vector34>:
.globl vector34
vector34:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $34
  1021aa:	6a 22                	push   $0x22
  jmp __alltraps
  1021ac:	e9 45 09 00 00       	jmp    102af6 <__alltraps>

001021b1 <vector35>:
.globl vector35
vector35:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $35
  1021b3:	6a 23                	push   $0x23
  jmp __alltraps
  1021b5:	e9 3c 09 00 00       	jmp    102af6 <__alltraps>

001021ba <vector36>:
.globl vector36
vector36:
  pushl $0
  1021ba:	6a 00                	push   $0x0
  pushl $36
  1021bc:	6a 24                	push   $0x24
  jmp __alltraps
  1021be:	e9 33 09 00 00       	jmp    102af6 <__alltraps>

001021c3 <vector37>:
.globl vector37
vector37:
  pushl $0
  1021c3:	6a 00                	push   $0x0
  pushl $37
  1021c5:	6a 25                	push   $0x25
  jmp __alltraps
  1021c7:	e9 2a 09 00 00       	jmp    102af6 <__alltraps>

001021cc <vector38>:
.globl vector38
vector38:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $38
  1021ce:	6a 26                	push   $0x26
  jmp __alltraps
  1021d0:	e9 21 09 00 00       	jmp    102af6 <__alltraps>

001021d5 <vector39>:
.globl vector39
vector39:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $39
  1021d7:	6a 27                	push   $0x27
  jmp __alltraps
  1021d9:	e9 18 09 00 00       	jmp    102af6 <__alltraps>

001021de <vector40>:
.globl vector40
vector40:
  pushl $0
  1021de:	6a 00                	push   $0x0
  pushl $40
  1021e0:	6a 28                	push   $0x28
  jmp __alltraps
  1021e2:	e9 0f 09 00 00       	jmp    102af6 <__alltraps>

001021e7 <vector41>:
.globl vector41
vector41:
  pushl $0
  1021e7:	6a 00                	push   $0x0
  pushl $41
  1021e9:	6a 29                	push   $0x29
  jmp __alltraps
  1021eb:	e9 06 09 00 00       	jmp    102af6 <__alltraps>

001021f0 <vector42>:
.globl vector42
vector42:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $42
  1021f2:	6a 2a                	push   $0x2a
  jmp __alltraps
  1021f4:	e9 fd 08 00 00       	jmp    102af6 <__alltraps>

001021f9 <vector43>:
.globl vector43
vector43:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $43
  1021fb:	6a 2b                	push   $0x2b
  jmp __alltraps
  1021fd:	e9 f4 08 00 00       	jmp    102af6 <__alltraps>

00102202 <vector44>:
.globl vector44
vector44:
  pushl $0
  102202:	6a 00                	push   $0x0
  pushl $44
  102204:	6a 2c                	push   $0x2c
  jmp __alltraps
  102206:	e9 eb 08 00 00       	jmp    102af6 <__alltraps>

0010220b <vector45>:
.globl vector45
vector45:
  pushl $0
  10220b:	6a 00                	push   $0x0
  pushl $45
  10220d:	6a 2d                	push   $0x2d
  jmp __alltraps
  10220f:	e9 e2 08 00 00       	jmp    102af6 <__alltraps>

00102214 <vector46>:
.globl vector46
vector46:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $46
  102216:	6a 2e                	push   $0x2e
  jmp __alltraps
  102218:	e9 d9 08 00 00       	jmp    102af6 <__alltraps>

0010221d <vector47>:
.globl vector47
vector47:
  pushl $0
  10221d:	6a 00                	push   $0x0
  pushl $47
  10221f:	6a 2f                	push   $0x2f
  jmp __alltraps
  102221:	e9 d0 08 00 00       	jmp    102af6 <__alltraps>

00102226 <vector48>:
.globl vector48
vector48:
  pushl $0
  102226:	6a 00                	push   $0x0
  pushl $48
  102228:	6a 30                	push   $0x30
  jmp __alltraps
  10222a:	e9 c7 08 00 00       	jmp    102af6 <__alltraps>

0010222f <vector49>:
.globl vector49
vector49:
  pushl $0
  10222f:	6a 00                	push   $0x0
  pushl $49
  102231:	6a 31                	push   $0x31
  jmp __alltraps
  102233:	e9 be 08 00 00       	jmp    102af6 <__alltraps>

00102238 <vector50>:
.globl vector50
vector50:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $50
  10223a:	6a 32                	push   $0x32
  jmp __alltraps
  10223c:	e9 b5 08 00 00       	jmp    102af6 <__alltraps>

00102241 <vector51>:
.globl vector51
vector51:
  pushl $0
  102241:	6a 00                	push   $0x0
  pushl $51
  102243:	6a 33                	push   $0x33
  jmp __alltraps
  102245:	e9 ac 08 00 00       	jmp    102af6 <__alltraps>

0010224a <vector52>:
.globl vector52
vector52:
  pushl $0
  10224a:	6a 00                	push   $0x0
  pushl $52
  10224c:	6a 34                	push   $0x34
  jmp __alltraps
  10224e:	e9 a3 08 00 00       	jmp    102af6 <__alltraps>

00102253 <vector53>:
.globl vector53
vector53:
  pushl $0
  102253:	6a 00                	push   $0x0
  pushl $53
  102255:	6a 35                	push   $0x35
  jmp __alltraps
  102257:	e9 9a 08 00 00       	jmp    102af6 <__alltraps>

0010225c <vector54>:
.globl vector54
vector54:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $54
  10225e:	6a 36                	push   $0x36
  jmp __alltraps
  102260:	e9 91 08 00 00       	jmp    102af6 <__alltraps>

00102265 <vector55>:
.globl vector55
vector55:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $55
  102267:	6a 37                	push   $0x37
  jmp __alltraps
  102269:	e9 88 08 00 00       	jmp    102af6 <__alltraps>

0010226e <vector56>:
.globl vector56
vector56:
  pushl $0
  10226e:	6a 00                	push   $0x0
  pushl $56
  102270:	6a 38                	push   $0x38
  jmp __alltraps
  102272:	e9 7f 08 00 00       	jmp    102af6 <__alltraps>

00102277 <vector57>:
.globl vector57
vector57:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $57
  102279:	6a 39                	push   $0x39
  jmp __alltraps
  10227b:	e9 76 08 00 00       	jmp    102af6 <__alltraps>

00102280 <vector58>:
.globl vector58
vector58:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $58
  102282:	6a 3a                	push   $0x3a
  jmp __alltraps
  102284:	e9 6d 08 00 00       	jmp    102af6 <__alltraps>

00102289 <vector59>:
.globl vector59
vector59:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $59
  10228b:	6a 3b                	push   $0x3b
  jmp __alltraps
  10228d:	e9 64 08 00 00       	jmp    102af6 <__alltraps>

00102292 <vector60>:
.globl vector60
vector60:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $60
  102294:	6a 3c                	push   $0x3c
  jmp __alltraps
  102296:	e9 5b 08 00 00       	jmp    102af6 <__alltraps>

0010229b <vector61>:
.globl vector61
vector61:
  pushl $0
  10229b:	6a 00                	push   $0x0
  pushl $61
  10229d:	6a 3d                	push   $0x3d
  jmp __alltraps
  10229f:	e9 52 08 00 00       	jmp    102af6 <__alltraps>

001022a4 <vector62>:
.globl vector62
vector62:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $62
  1022a6:	6a 3e                	push   $0x3e
  jmp __alltraps
  1022a8:	e9 49 08 00 00       	jmp    102af6 <__alltraps>

001022ad <vector63>:
.globl vector63
vector63:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $63
  1022af:	6a 3f                	push   $0x3f
  jmp __alltraps
  1022b1:	e9 40 08 00 00       	jmp    102af6 <__alltraps>

001022b6 <vector64>:
.globl vector64
vector64:
  pushl $0
  1022b6:	6a 00                	push   $0x0
  pushl $64
  1022b8:	6a 40                	push   $0x40
  jmp __alltraps
  1022ba:	e9 37 08 00 00       	jmp    102af6 <__alltraps>

001022bf <vector65>:
.globl vector65
vector65:
  pushl $0
  1022bf:	6a 00                	push   $0x0
  pushl $65
  1022c1:	6a 41                	push   $0x41
  jmp __alltraps
  1022c3:	e9 2e 08 00 00       	jmp    102af6 <__alltraps>

001022c8 <vector66>:
.globl vector66
vector66:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $66
  1022ca:	6a 42                	push   $0x42
  jmp __alltraps
  1022cc:	e9 25 08 00 00       	jmp    102af6 <__alltraps>

001022d1 <vector67>:
.globl vector67
vector67:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $67
  1022d3:	6a 43                	push   $0x43
  jmp __alltraps
  1022d5:	e9 1c 08 00 00       	jmp    102af6 <__alltraps>

001022da <vector68>:
.globl vector68
vector68:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $68
  1022dc:	6a 44                	push   $0x44
  jmp __alltraps
  1022de:	e9 13 08 00 00       	jmp    102af6 <__alltraps>

001022e3 <vector69>:
.globl vector69
vector69:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $69
  1022e5:	6a 45                	push   $0x45
  jmp __alltraps
  1022e7:	e9 0a 08 00 00       	jmp    102af6 <__alltraps>

001022ec <vector70>:
.globl vector70
vector70:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $70
  1022ee:	6a 46                	push   $0x46
  jmp __alltraps
  1022f0:	e9 01 08 00 00       	jmp    102af6 <__alltraps>

001022f5 <vector71>:
.globl vector71
vector71:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $71
  1022f7:	6a 47                	push   $0x47
  jmp __alltraps
  1022f9:	e9 f8 07 00 00       	jmp    102af6 <__alltraps>

001022fe <vector72>:
.globl vector72
vector72:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $72
  102300:	6a 48                	push   $0x48
  jmp __alltraps
  102302:	e9 ef 07 00 00       	jmp    102af6 <__alltraps>

00102307 <vector73>:
.globl vector73
vector73:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $73
  102309:	6a 49                	push   $0x49
  jmp __alltraps
  10230b:	e9 e6 07 00 00       	jmp    102af6 <__alltraps>

00102310 <vector74>:
.globl vector74
vector74:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $74
  102312:	6a 4a                	push   $0x4a
  jmp __alltraps
  102314:	e9 dd 07 00 00       	jmp    102af6 <__alltraps>

00102319 <vector75>:
.globl vector75
vector75:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $75
  10231b:	6a 4b                	push   $0x4b
  jmp __alltraps
  10231d:	e9 d4 07 00 00       	jmp    102af6 <__alltraps>

00102322 <vector76>:
.globl vector76
vector76:
  pushl $0
  102322:	6a 00                	push   $0x0
  pushl $76
  102324:	6a 4c                	push   $0x4c
  jmp __alltraps
  102326:	e9 cb 07 00 00       	jmp    102af6 <__alltraps>

0010232b <vector77>:
.globl vector77
vector77:
  pushl $0
  10232b:	6a 00                	push   $0x0
  pushl $77
  10232d:	6a 4d                	push   $0x4d
  jmp __alltraps
  10232f:	e9 c2 07 00 00       	jmp    102af6 <__alltraps>

00102334 <vector78>:
.globl vector78
vector78:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $78
  102336:	6a 4e                	push   $0x4e
  jmp __alltraps
  102338:	e9 b9 07 00 00       	jmp    102af6 <__alltraps>

0010233d <vector79>:
.globl vector79
vector79:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $79
  10233f:	6a 4f                	push   $0x4f
  jmp __alltraps
  102341:	e9 b0 07 00 00       	jmp    102af6 <__alltraps>

00102346 <vector80>:
.globl vector80
vector80:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $80
  102348:	6a 50                	push   $0x50
  jmp __alltraps
  10234a:	e9 a7 07 00 00       	jmp    102af6 <__alltraps>

0010234f <vector81>:
.globl vector81
vector81:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $81
  102351:	6a 51                	push   $0x51
  jmp __alltraps
  102353:	e9 9e 07 00 00       	jmp    102af6 <__alltraps>

00102358 <vector82>:
.globl vector82
vector82:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $82
  10235a:	6a 52                	push   $0x52
  jmp __alltraps
  10235c:	e9 95 07 00 00       	jmp    102af6 <__alltraps>

00102361 <vector83>:
.globl vector83
vector83:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $83
  102363:	6a 53                	push   $0x53
  jmp __alltraps
  102365:	e9 8c 07 00 00       	jmp    102af6 <__alltraps>

0010236a <vector84>:
.globl vector84
vector84:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $84
  10236c:	6a 54                	push   $0x54
  jmp __alltraps
  10236e:	e9 83 07 00 00       	jmp    102af6 <__alltraps>

00102373 <vector85>:
.globl vector85
vector85:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $85
  102375:	6a 55                	push   $0x55
  jmp __alltraps
  102377:	e9 7a 07 00 00       	jmp    102af6 <__alltraps>

0010237c <vector86>:
.globl vector86
vector86:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $86
  10237e:	6a 56                	push   $0x56
  jmp __alltraps
  102380:	e9 71 07 00 00       	jmp    102af6 <__alltraps>

00102385 <vector87>:
.globl vector87
vector87:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $87
  102387:	6a 57                	push   $0x57
  jmp __alltraps
  102389:	e9 68 07 00 00       	jmp    102af6 <__alltraps>

0010238e <vector88>:
.globl vector88
vector88:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $88
  102390:	6a 58                	push   $0x58
  jmp __alltraps
  102392:	e9 5f 07 00 00       	jmp    102af6 <__alltraps>

00102397 <vector89>:
.globl vector89
vector89:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $89
  102399:	6a 59                	push   $0x59
  jmp __alltraps
  10239b:	e9 56 07 00 00       	jmp    102af6 <__alltraps>

001023a0 <vector90>:
.globl vector90
vector90:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $90
  1023a2:	6a 5a                	push   $0x5a
  jmp __alltraps
  1023a4:	e9 4d 07 00 00       	jmp    102af6 <__alltraps>

001023a9 <vector91>:
.globl vector91
vector91:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $91
  1023ab:	6a 5b                	push   $0x5b
  jmp __alltraps
  1023ad:	e9 44 07 00 00       	jmp    102af6 <__alltraps>

001023b2 <vector92>:
.globl vector92
vector92:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $92
  1023b4:	6a 5c                	push   $0x5c
  jmp __alltraps
  1023b6:	e9 3b 07 00 00       	jmp    102af6 <__alltraps>

001023bb <vector93>:
.globl vector93
vector93:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $93
  1023bd:	6a 5d                	push   $0x5d
  jmp __alltraps
  1023bf:	e9 32 07 00 00       	jmp    102af6 <__alltraps>

001023c4 <vector94>:
.globl vector94
vector94:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $94
  1023c6:	6a 5e                	push   $0x5e
  jmp __alltraps
  1023c8:	e9 29 07 00 00       	jmp    102af6 <__alltraps>

001023cd <vector95>:
.globl vector95
vector95:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $95
  1023cf:	6a 5f                	push   $0x5f
  jmp __alltraps
  1023d1:	e9 20 07 00 00       	jmp    102af6 <__alltraps>

001023d6 <vector96>:
.globl vector96
vector96:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $96
  1023d8:	6a 60                	push   $0x60
  jmp __alltraps
  1023da:	e9 17 07 00 00       	jmp    102af6 <__alltraps>

001023df <vector97>:
.globl vector97
vector97:
  pushl $0
  1023df:	6a 00                	push   $0x0
  pushl $97
  1023e1:	6a 61                	push   $0x61
  jmp __alltraps
  1023e3:	e9 0e 07 00 00       	jmp    102af6 <__alltraps>

001023e8 <vector98>:
.globl vector98
vector98:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $98
  1023ea:	6a 62                	push   $0x62
  jmp __alltraps
  1023ec:	e9 05 07 00 00       	jmp    102af6 <__alltraps>

001023f1 <vector99>:
.globl vector99
vector99:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $99
  1023f3:	6a 63                	push   $0x63
  jmp __alltraps
  1023f5:	e9 fc 06 00 00       	jmp    102af6 <__alltraps>

001023fa <vector100>:
.globl vector100
vector100:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $100
  1023fc:	6a 64                	push   $0x64
  jmp __alltraps
  1023fe:	e9 f3 06 00 00       	jmp    102af6 <__alltraps>

00102403 <vector101>:
.globl vector101
vector101:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $101
  102405:	6a 65                	push   $0x65
  jmp __alltraps
  102407:	e9 ea 06 00 00       	jmp    102af6 <__alltraps>

0010240c <vector102>:
.globl vector102
vector102:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $102
  10240e:	6a 66                	push   $0x66
  jmp __alltraps
  102410:	e9 e1 06 00 00       	jmp    102af6 <__alltraps>

00102415 <vector103>:
.globl vector103
vector103:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $103
  102417:	6a 67                	push   $0x67
  jmp __alltraps
  102419:	e9 d8 06 00 00       	jmp    102af6 <__alltraps>

0010241e <vector104>:
.globl vector104
vector104:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $104
  102420:	6a 68                	push   $0x68
  jmp __alltraps
  102422:	e9 cf 06 00 00       	jmp    102af6 <__alltraps>

00102427 <vector105>:
.globl vector105
vector105:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $105
  102429:	6a 69                	push   $0x69
  jmp __alltraps
  10242b:	e9 c6 06 00 00       	jmp    102af6 <__alltraps>

00102430 <vector106>:
.globl vector106
vector106:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $106
  102432:	6a 6a                	push   $0x6a
  jmp __alltraps
  102434:	e9 bd 06 00 00       	jmp    102af6 <__alltraps>

00102439 <vector107>:
.globl vector107
vector107:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $107
  10243b:	6a 6b                	push   $0x6b
  jmp __alltraps
  10243d:	e9 b4 06 00 00       	jmp    102af6 <__alltraps>

00102442 <vector108>:
.globl vector108
vector108:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $108
  102444:	6a 6c                	push   $0x6c
  jmp __alltraps
  102446:	e9 ab 06 00 00       	jmp    102af6 <__alltraps>

0010244b <vector109>:
.globl vector109
vector109:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $109
  10244d:	6a 6d                	push   $0x6d
  jmp __alltraps
  10244f:	e9 a2 06 00 00       	jmp    102af6 <__alltraps>

00102454 <vector110>:
.globl vector110
vector110:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $110
  102456:	6a 6e                	push   $0x6e
  jmp __alltraps
  102458:	e9 99 06 00 00       	jmp    102af6 <__alltraps>

0010245d <vector111>:
.globl vector111
vector111:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $111
  10245f:	6a 6f                	push   $0x6f
  jmp __alltraps
  102461:	e9 90 06 00 00       	jmp    102af6 <__alltraps>

00102466 <vector112>:
.globl vector112
vector112:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $112
  102468:	6a 70                	push   $0x70
  jmp __alltraps
  10246a:	e9 87 06 00 00       	jmp    102af6 <__alltraps>

0010246f <vector113>:
.globl vector113
vector113:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $113
  102471:	6a 71                	push   $0x71
  jmp __alltraps
  102473:	e9 7e 06 00 00       	jmp    102af6 <__alltraps>

00102478 <vector114>:
.globl vector114
vector114:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $114
  10247a:	6a 72                	push   $0x72
  jmp __alltraps
  10247c:	e9 75 06 00 00       	jmp    102af6 <__alltraps>

00102481 <vector115>:
.globl vector115
vector115:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $115
  102483:	6a 73                	push   $0x73
  jmp __alltraps
  102485:	e9 6c 06 00 00       	jmp    102af6 <__alltraps>

0010248a <vector116>:
.globl vector116
vector116:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $116
  10248c:	6a 74                	push   $0x74
  jmp __alltraps
  10248e:	e9 63 06 00 00       	jmp    102af6 <__alltraps>

00102493 <vector117>:
.globl vector117
vector117:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $117
  102495:	6a 75                	push   $0x75
  jmp __alltraps
  102497:	e9 5a 06 00 00       	jmp    102af6 <__alltraps>

0010249c <vector118>:
.globl vector118
vector118:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $118
  10249e:	6a 76                	push   $0x76
  jmp __alltraps
  1024a0:	e9 51 06 00 00       	jmp    102af6 <__alltraps>

001024a5 <vector119>:
.globl vector119
vector119:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $119
  1024a7:	6a 77                	push   $0x77
  jmp __alltraps
  1024a9:	e9 48 06 00 00       	jmp    102af6 <__alltraps>

001024ae <vector120>:
.globl vector120
vector120:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $120
  1024b0:	6a 78                	push   $0x78
  jmp __alltraps
  1024b2:	e9 3f 06 00 00       	jmp    102af6 <__alltraps>

001024b7 <vector121>:
.globl vector121
vector121:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $121
  1024b9:	6a 79                	push   $0x79
  jmp __alltraps
  1024bb:	e9 36 06 00 00       	jmp    102af6 <__alltraps>

001024c0 <vector122>:
.globl vector122
vector122:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $122
  1024c2:	6a 7a                	push   $0x7a
  jmp __alltraps
  1024c4:	e9 2d 06 00 00       	jmp    102af6 <__alltraps>

001024c9 <vector123>:
.globl vector123
vector123:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $123
  1024cb:	6a 7b                	push   $0x7b
  jmp __alltraps
  1024cd:	e9 24 06 00 00       	jmp    102af6 <__alltraps>

001024d2 <vector124>:
.globl vector124
vector124:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $124
  1024d4:	6a 7c                	push   $0x7c
  jmp __alltraps
  1024d6:	e9 1b 06 00 00       	jmp    102af6 <__alltraps>

001024db <vector125>:
.globl vector125
vector125:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $125
  1024dd:	6a 7d                	push   $0x7d
  jmp __alltraps
  1024df:	e9 12 06 00 00       	jmp    102af6 <__alltraps>

001024e4 <vector126>:
.globl vector126
vector126:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $126
  1024e6:	6a 7e                	push   $0x7e
  jmp __alltraps
  1024e8:	e9 09 06 00 00       	jmp    102af6 <__alltraps>

001024ed <vector127>:
.globl vector127
vector127:
  pushl $0
  1024ed:	6a 00                	push   $0x0
  pushl $127
  1024ef:	6a 7f                	push   $0x7f
  jmp __alltraps
  1024f1:	e9 00 06 00 00       	jmp    102af6 <__alltraps>

001024f6 <vector128>:
.globl vector128
vector128:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $128
  1024f8:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1024fd:	e9 f4 05 00 00       	jmp    102af6 <__alltraps>

00102502 <vector129>:
.globl vector129
vector129:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $129
  102504:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102509:	e9 e8 05 00 00       	jmp    102af6 <__alltraps>

0010250e <vector130>:
.globl vector130
vector130:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $130
  102510:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102515:	e9 dc 05 00 00       	jmp    102af6 <__alltraps>

0010251a <vector131>:
.globl vector131
vector131:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $131
  10251c:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102521:	e9 d0 05 00 00       	jmp    102af6 <__alltraps>

00102526 <vector132>:
.globl vector132
vector132:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $132
  102528:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10252d:	e9 c4 05 00 00       	jmp    102af6 <__alltraps>

00102532 <vector133>:
.globl vector133
vector133:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $133
  102534:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102539:	e9 b8 05 00 00       	jmp    102af6 <__alltraps>

0010253e <vector134>:
.globl vector134
vector134:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $134
  102540:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102545:	e9 ac 05 00 00       	jmp    102af6 <__alltraps>

0010254a <vector135>:
.globl vector135
vector135:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $135
  10254c:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102551:	e9 a0 05 00 00       	jmp    102af6 <__alltraps>

00102556 <vector136>:
.globl vector136
vector136:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $136
  102558:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10255d:	e9 94 05 00 00       	jmp    102af6 <__alltraps>

00102562 <vector137>:
.globl vector137
vector137:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $137
  102564:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102569:	e9 88 05 00 00       	jmp    102af6 <__alltraps>

0010256e <vector138>:
.globl vector138
vector138:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $138
  102570:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102575:	e9 7c 05 00 00       	jmp    102af6 <__alltraps>

0010257a <vector139>:
.globl vector139
vector139:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $139
  10257c:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102581:	e9 70 05 00 00       	jmp    102af6 <__alltraps>

00102586 <vector140>:
.globl vector140
vector140:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $140
  102588:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10258d:	e9 64 05 00 00       	jmp    102af6 <__alltraps>

00102592 <vector141>:
.globl vector141
vector141:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $141
  102594:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102599:	e9 58 05 00 00       	jmp    102af6 <__alltraps>

0010259e <vector142>:
.globl vector142
vector142:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $142
  1025a0:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1025a5:	e9 4c 05 00 00       	jmp    102af6 <__alltraps>

001025aa <vector143>:
.globl vector143
vector143:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $143
  1025ac:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1025b1:	e9 40 05 00 00       	jmp    102af6 <__alltraps>

001025b6 <vector144>:
.globl vector144
vector144:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $144
  1025b8:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1025bd:	e9 34 05 00 00       	jmp    102af6 <__alltraps>

001025c2 <vector145>:
.globl vector145
vector145:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $145
  1025c4:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1025c9:	e9 28 05 00 00       	jmp    102af6 <__alltraps>

001025ce <vector146>:
.globl vector146
vector146:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $146
  1025d0:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1025d5:	e9 1c 05 00 00       	jmp    102af6 <__alltraps>

001025da <vector147>:
.globl vector147
vector147:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $147
  1025dc:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1025e1:	e9 10 05 00 00       	jmp    102af6 <__alltraps>

001025e6 <vector148>:
.globl vector148
vector148:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $148
  1025e8:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1025ed:	e9 04 05 00 00       	jmp    102af6 <__alltraps>

001025f2 <vector149>:
.globl vector149
vector149:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $149
  1025f4:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1025f9:	e9 f8 04 00 00       	jmp    102af6 <__alltraps>

001025fe <vector150>:
.globl vector150
vector150:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $150
  102600:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102605:	e9 ec 04 00 00       	jmp    102af6 <__alltraps>

0010260a <vector151>:
.globl vector151
vector151:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $151
  10260c:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102611:	e9 e0 04 00 00       	jmp    102af6 <__alltraps>

00102616 <vector152>:
.globl vector152
vector152:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $152
  102618:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10261d:	e9 d4 04 00 00       	jmp    102af6 <__alltraps>

00102622 <vector153>:
.globl vector153
vector153:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $153
  102624:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102629:	e9 c8 04 00 00       	jmp    102af6 <__alltraps>

0010262e <vector154>:
.globl vector154
vector154:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $154
  102630:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102635:	e9 bc 04 00 00       	jmp    102af6 <__alltraps>

0010263a <vector155>:
.globl vector155
vector155:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $155
  10263c:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102641:	e9 b0 04 00 00       	jmp    102af6 <__alltraps>

00102646 <vector156>:
.globl vector156
vector156:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $156
  102648:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10264d:	e9 a4 04 00 00       	jmp    102af6 <__alltraps>

00102652 <vector157>:
.globl vector157
vector157:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $157
  102654:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102659:	e9 98 04 00 00       	jmp    102af6 <__alltraps>

0010265e <vector158>:
.globl vector158
vector158:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $158
  102660:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102665:	e9 8c 04 00 00       	jmp    102af6 <__alltraps>

0010266a <vector159>:
.globl vector159
vector159:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $159
  10266c:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102671:	e9 80 04 00 00       	jmp    102af6 <__alltraps>

00102676 <vector160>:
.globl vector160
vector160:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $160
  102678:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10267d:	e9 74 04 00 00       	jmp    102af6 <__alltraps>

00102682 <vector161>:
.globl vector161
vector161:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $161
  102684:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102689:	e9 68 04 00 00       	jmp    102af6 <__alltraps>

0010268e <vector162>:
.globl vector162
vector162:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $162
  102690:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102695:	e9 5c 04 00 00       	jmp    102af6 <__alltraps>

0010269a <vector163>:
.globl vector163
vector163:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $163
  10269c:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1026a1:	e9 50 04 00 00       	jmp    102af6 <__alltraps>

001026a6 <vector164>:
.globl vector164
vector164:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $164
  1026a8:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1026ad:	e9 44 04 00 00       	jmp    102af6 <__alltraps>

001026b2 <vector165>:
.globl vector165
vector165:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $165
  1026b4:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1026b9:	e9 38 04 00 00       	jmp    102af6 <__alltraps>

001026be <vector166>:
.globl vector166
vector166:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $166
  1026c0:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1026c5:	e9 2c 04 00 00       	jmp    102af6 <__alltraps>

001026ca <vector167>:
.globl vector167
vector167:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $167
  1026cc:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1026d1:	e9 20 04 00 00       	jmp    102af6 <__alltraps>

001026d6 <vector168>:
.globl vector168
vector168:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $168
  1026d8:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1026dd:	e9 14 04 00 00       	jmp    102af6 <__alltraps>

001026e2 <vector169>:
.globl vector169
vector169:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $169
  1026e4:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1026e9:	e9 08 04 00 00       	jmp    102af6 <__alltraps>

001026ee <vector170>:
.globl vector170
vector170:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $170
  1026f0:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1026f5:	e9 fc 03 00 00       	jmp    102af6 <__alltraps>

001026fa <vector171>:
.globl vector171
vector171:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $171
  1026fc:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102701:	e9 f0 03 00 00       	jmp    102af6 <__alltraps>

00102706 <vector172>:
.globl vector172
vector172:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $172
  102708:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10270d:	e9 e4 03 00 00       	jmp    102af6 <__alltraps>

00102712 <vector173>:
.globl vector173
vector173:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $173
  102714:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102719:	e9 d8 03 00 00       	jmp    102af6 <__alltraps>

0010271e <vector174>:
.globl vector174
vector174:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $174
  102720:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102725:	e9 cc 03 00 00       	jmp    102af6 <__alltraps>

0010272a <vector175>:
.globl vector175
vector175:
  pushl $0
  10272a:	6a 00                	push   $0x0
  pushl $175
  10272c:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102731:	e9 c0 03 00 00       	jmp    102af6 <__alltraps>

00102736 <vector176>:
.globl vector176
vector176:
  pushl $0
  102736:	6a 00                	push   $0x0
  pushl $176
  102738:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10273d:	e9 b4 03 00 00       	jmp    102af6 <__alltraps>

00102742 <vector177>:
.globl vector177
vector177:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $177
  102744:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102749:	e9 a8 03 00 00       	jmp    102af6 <__alltraps>

0010274e <vector178>:
.globl vector178
vector178:
  pushl $0
  10274e:	6a 00                	push   $0x0
  pushl $178
  102750:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102755:	e9 9c 03 00 00       	jmp    102af6 <__alltraps>

0010275a <vector179>:
.globl vector179
vector179:
  pushl $0
  10275a:	6a 00                	push   $0x0
  pushl $179
  10275c:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102761:	e9 90 03 00 00       	jmp    102af6 <__alltraps>

00102766 <vector180>:
.globl vector180
vector180:
  pushl $0
  102766:	6a 00                	push   $0x0
  pushl $180
  102768:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10276d:	e9 84 03 00 00       	jmp    102af6 <__alltraps>

00102772 <vector181>:
.globl vector181
vector181:
  pushl $0
  102772:	6a 00                	push   $0x0
  pushl $181
  102774:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102779:	e9 78 03 00 00       	jmp    102af6 <__alltraps>

0010277e <vector182>:
.globl vector182
vector182:
  pushl $0
  10277e:	6a 00                	push   $0x0
  pushl $182
  102780:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102785:	e9 6c 03 00 00       	jmp    102af6 <__alltraps>

0010278a <vector183>:
.globl vector183
vector183:
  pushl $0
  10278a:	6a 00                	push   $0x0
  pushl $183
  10278c:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102791:	e9 60 03 00 00       	jmp    102af6 <__alltraps>

00102796 <vector184>:
.globl vector184
vector184:
  pushl $0
  102796:	6a 00                	push   $0x0
  pushl $184
  102798:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10279d:	e9 54 03 00 00       	jmp    102af6 <__alltraps>

001027a2 <vector185>:
.globl vector185
vector185:
  pushl $0
  1027a2:	6a 00                	push   $0x0
  pushl $185
  1027a4:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1027a9:	e9 48 03 00 00       	jmp    102af6 <__alltraps>

001027ae <vector186>:
.globl vector186
vector186:
  pushl $0
  1027ae:	6a 00                	push   $0x0
  pushl $186
  1027b0:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1027b5:	e9 3c 03 00 00       	jmp    102af6 <__alltraps>

001027ba <vector187>:
.globl vector187
vector187:
  pushl $0
  1027ba:	6a 00                	push   $0x0
  pushl $187
  1027bc:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1027c1:	e9 30 03 00 00       	jmp    102af6 <__alltraps>

001027c6 <vector188>:
.globl vector188
vector188:
  pushl $0
  1027c6:	6a 00                	push   $0x0
  pushl $188
  1027c8:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1027cd:	e9 24 03 00 00       	jmp    102af6 <__alltraps>

001027d2 <vector189>:
.globl vector189
vector189:
  pushl $0
  1027d2:	6a 00                	push   $0x0
  pushl $189
  1027d4:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1027d9:	e9 18 03 00 00       	jmp    102af6 <__alltraps>

001027de <vector190>:
.globl vector190
vector190:
  pushl $0
  1027de:	6a 00                	push   $0x0
  pushl $190
  1027e0:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1027e5:	e9 0c 03 00 00       	jmp    102af6 <__alltraps>

001027ea <vector191>:
.globl vector191
vector191:
  pushl $0
  1027ea:	6a 00                	push   $0x0
  pushl $191
  1027ec:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1027f1:	e9 00 03 00 00       	jmp    102af6 <__alltraps>

001027f6 <vector192>:
.globl vector192
vector192:
  pushl $0
  1027f6:	6a 00                	push   $0x0
  pushl $192
  1027f8:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1027fd:	e9 f4 02 00 00       	jmp    102af6 <__alltraps>

00102802 <vector193>:
.globl vector193
vector193:
  pushl $0
  102802:	6a 00                	push   $0x0
  pushl $193
  102804:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102809:	e9 e8 02 00 00       	jmp    102af6 <__alltraps>

0010280e <vector194>:
.globl vector194
vector194:
  pushl $0
  10280e:	6a 00                	push   $0x0
  pushl $194
  102810:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102815:	e9 dc 02 00 00       	jmp    102af6 <__alltraps>

0010281a <vector195>:
.globl vector195
vector195:
  pushl $0
  10281a:	6a 00                	push   $0x0
  pushl $195
  10281c:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102821:	e9 d0 02 00 00       	jmp    102af6 <__alltraps>

00102826 <vector196>:
.globl vector196
vector196:
  pushl $0
  102826:	6a 00                	push   $0x0
  pushl $196
  102828:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10282d:	e9 c4 02 00 00       	jmp    102af6 <__alltraps>

00102832 <vector197>:
.globl vector197
vector197:
  pushl $0
  102832:	6a 00                	push   $0x0
  pushl $197
  102834:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102839:	e9 b8 02 00 00       	jmp    102af6 <__alltraps>

0010283e <vector198>:
.globl vector198
vector198:
  pushl $0
  10283e:	6a 00                	push   $0x0
  pushl $198
  102840:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102845:	e9 ac 02 00 00       	jmp    102af6 <__alltraps>

0010284a <vector199>:
.globl vector199
vector199:
  pushl $0
  10284a:	6a 00                	push   $0x0
  pushl $199
  10284c:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102851:	e9 a0 02 00 00       	jmp    102af6 <__alltraps>

00102856 <vector200>:
.globl vector200
vector200:
  pushl $0
  102856:	6a 00                	push   $0x0
  pushl $200
  102858:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10285d:	e9 94 02 00 00       	jmp    102af6 <__alltraps>

00102862 <vector201>:
.globl vector201
vector201:
  pushl $0
  102862:	6a 00                	push   $0x0
  pushl $201
  102864:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102869:	e9 88 02 00 00       	jmp    102af6 <__alltraps>

0010286e <vector202>:
.globl vector202
vector202:
  pushl $0
  10286e:	6a 00                	push   $0x0
  pushl $202
  102870:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102875:	e9 7c 02 00 00       	jmp    102af6 <__alltraps>

0010287a <vector203>:
.globl vector203
vector203:
  pushl $0
  10287a:	6a 00                	push   $0x0
  pushl $203
  10287c:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102881:	e9 70 02 00 00       	jmp    102af6 <__alltraps>

00102886 <vector204>:
.globl vector204
vector204:
  pushl $0
  102886:	6a 00                	push   $0x0
  pushl $204
  102888:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10288d:	e9 64 02 00 00       	jmp    102af6 <__alltraps>

00102892 <vector205>:
.globl vector205
vector205:
  pushl $0
  102892:	6a 00                	push   $0x0
  pushl $205
  102894:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102899:	e9 58 02 00 00       	jmp    102af6 <__alltraps>

0010289e <vector206>:
.globl vector206
vector206:
  pushl $0
  10289e:	6a 00                	push   $0x0
  pushl $206
  1028a0:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1028a5:	e9 4c 02 00 00       	jmp    102af6 <__alltraps>

001028aa <vector207>:
.globl vector207
vector207:
  pushl $0
  1028aa:	6a 00                	push   $0x0
  pushl $207
  1028ac:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1028b1:	e9 40 02 00 00       	jmp    102af6 <__alltraps>

001028b6 <vector208>:
.globl vector208
vector208:
  pushl $0
  1028b6:	6a 00                	push   $0x0
  pushl $208
  1028b8:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1028bd:	e9 34 02 00 00       	jmp    102af6 <__alltraps>

001028c2 <vector209>:
.globl vector209
vector209:
  pushl $0
  1028c2:	6a 00                	push   $0x0
  pushl $209
  1028c4:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1028c9:	e9 28 02 00 00       	jmp    102af6 <__alltraps>

001028ce <vector210>:
.globl vector210
vector210:
  pushl $0
  1028ce:	6a 00                	push   $0x0
  pushl $210
  1028d0:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1028d5:	e9 1c 02 00 00       	jmp    102af6 <__alltraps>

001028da <vector211>:
.globl vector211
vector211:
  pushl $0
  1028da:	6a 00                	push   $0x0
  pushl $211
  1028dc:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1028e1:	e9 10 02 00 00       	jmp    102af6 <__alltraps>

001028e6 <vector212>:
.globl vector212
vector212:
  pushl $0
  1028e6:	6a 00                	push   $0x0
  pushl $212
  1028e8:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1028ed:	e9 04 02 00 00       	jmp    102af6 <__alltraps>

001028f2 <vector213>:
.globl vector213
vector213:
  pushl $0
  1028f2:	6a 00                	push   $0x0
  pushl $213
  1028f4:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1028f9:	e9 f8 01 00 00       	jmp    102af6 <__alltraps>

001028fe <vector214>:
.globl vector214
vector214:
  pushl $0
  1028fe:	6a 00                	push   $0x0
  pushl $214
  102900:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102905:	e9 ec 01 00 00       	jmp    102af6 <__alltraps>

0010290a <vector215>:
.globl vector215
vector215:
  pushl $0
  10290a:	6a 00                	push   $0x0
  pushl $215
  10290c:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102911:	e9 e0 01 00 00       	jmp    102af6 <__alltraps>

00102916 <vector216>:
.globl vector216
vector216:
  pushl $0
  102916:	6a 00                	push   $0x0
  pushl $216
  102918:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10291d:	e9 d4 01 00 00       	jmp    102af6 <__alltraps>

00102922 <vector217>:
.globl vector217
vector217:
  pushl $0
  102922:	6a 00                	push   $0x0
  pushl $217
  102924:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102929:	e9 c8 01 00 00       	jmp    102af6 <__alltraps>

0010292e <vector218>:
.globl vector218
vector218:
  pushl $0
  10292e:	6a 00                	push   $0x0
  pushl $218
  102930:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102935:	e9 bc 01 00 00       	jmp    102af6 <__alltraps>

0010293a <vector219>:
.globl vector219
vector219:
  pushl $0
  10293a:	6a 00                	push   $0x0
  pushl $219
  10293c:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102941:	e9 b0 01 00 00       	jmp    102af6 <__alltraps>

00102946 <vector220>:
.globl vector220
vector220:
  pushl $0
  102946:	6a 00                	push   $0x0
  pushl $220
  102948:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10294d:	e9 a4 01 00 00       	jmp    102af6 <__alltraps>

00102952 <vector221>:
.globl vector221
vector221:
  pushl $0
  102952:	6a 00                	push   $0x0
  pushl $221
  102954:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102959:	e9 98 01 00 00       	jmp    102af6 <__alltraps>

0010295e <vector222>:
.globl vector222
vector222:
  pushl $0
  10295e:	6a 00                	push   $0x0
  pushl $222
  102960:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102965:	e9 8c 01 00 00       	jmp    102af6 <__alltraps>

0010296a <vector223>:
.globl vector223
vector223:
  pushl $0
  10296a:	6a 00                	push   $0x0
  pushl $223
  10296c:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102971:	e9 80 01 00 00       	jmp    102af6 <__alltraps>

00102976 <vector224>:
.globl vector224
vector224:
  pushl $0
  102976:	6a 00                	push   $0x0
  pushl $224
  102978:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10297d:	e9 74 01 00 00       	jmp    102af6 <__alltraps>

00102982 <vector225>:
.globl vector225
vector225:
  pushl $0
  102982:	6a 00                	push   $0x0
  pushl $225
  102984:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102989:	e9 68 01 00 00       	jmp    102af6 <__alltraps>

0010298e <vector226>:
.globl vector226
vector226:
  pushl $0
  10298e:	6a 00                	push   $0x0
  pushl $226
  102990:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102995:	e9 5c 01 00 00       	jmp    102af6 <__alltraps>

0010299a <vector227>:
.globl vector227
vector227:
  pushl $0
  10299a:	6a 00                	push   $0x0
  pushl $227
  10299c:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1029a1:	e9 50 01 00 00       	jmp    102af6 <__alltraps>

001029a6 <vector228>:
.globl vector228
vector228:
  pushl $0
  1029a6:	6a 00                	push   $0x0
  pushl $228
  1029a8:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1029ad:	e9 44 01 00 00       	jmp    102af6 <__alltraps>

001029b2 <vector229>:
.globl vector229
vector229:
  pushl $0
  1029b2:	6a 00                	push   $0x0
  pushl $229
  1029b4:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1029b9:	e9 38 01 00 00       	jmp    102af6 <__alltraps>

001029be <vector230>:
.globl vector230
vector230:
  pushl $0
  1029be:	6a 00                	push   $0x0
  pushl $230
  1029c0:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1029c5:	e9 2c 01 00 00       	jmp    102af6 <__alltraps>

001029ca <vector231>:
.globl vector231
vector231:
  pushl $0
  1029ca:	6a 00                	push   $0x0
  pushl $231
  1029cc:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1029d1:	e9 20 01 00 00       	jmp    102af6 <__alltraps>

001029d6 <vector232>:
.globl vector232
vector232:
  pushl $0
  1029d6:	6a 00                	push   $0x0
  pushl $232
  1029d8:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1029dd:	e9 14 01 00 00       	jmp    102af6 <__alltraps>

001029e2 <vector233>:
.globl vector233
vector233:
  pushl $0
  1029e2:	6a 00                	push   $0x0
  pushl $233
  1029e4:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1029e9:	e9 08 01 00 00       	jmp    102af6 <__alltraps>

001029ee <vector234>:
.globl vector234
vector234:
  pushl $0
  1029ee:	6a 00                	push   $0x0
  pushl $234
  1029f0:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1029f5:	e9 fc 00 00 00       	jmp    102af6 <__alltraps>

001029fa <vector235>:
.globl vector235
vector235:
  pushl $0
  1029fa:	6a 00                	push   $0x0
  pushl $235
  1029fc:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102a01:	e9 f0 00 00 00       	jmp    102af6 <__alltraps>

00102a06 <vector236>:
.globl vector236
vector236:
  pushl $0
  102a06:	6a 00                	push   $0x0
  pushl $236
  102a08:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102a0d:	e9 e4 00 00 00       	jmp    102af6 <__alltraps>

00102a12 <vector237>:
.globl vector237
vector237:
  pushl $0
  102a12:	6a 00                	push   $0x0
  pushl $237
  102a14:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102a19:	e9 d8 00 00 00       	jmp    102af6 <__alltraps>

00102a1e <vector238>:
.globl vector238
vector238:
  pushl $0
  102a1e:	6a 00                	push   $0x0
  pushl $238
  102a20:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102a25:	e9 cc 00 00 00       	jmp    102af6 <__alltraps>

00102a2a <vector239>:
.globl vector239
vector239:
  pushl $0
  102a2a:	6a 00                	push   $0x0
  pushl $239
  102a2c:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102a31:	e9 c0 00 00 00       	jmp    102af6 <__alltraps>

00102a36 <vector240>:
.globl vector240
vector240:
  pushl $0
  102a36:	6a 00                	push   $0x0
  pushl $240
  102a38:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102a3d:	e9 b4 00 00 00       	jmp    102af6 <__alltraps>

00102a42 <vector241>:
.globl vector241
vector241:
  pushl $0
  102a42:	6a 00                	push   $0x0
  pushl $241
  102a44:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102a49:	e9 a8 00 00 00       	jmp    102af6 <__alltraps>

00102a4e <vector242>:
.globl vector242
vector242:
  pushl $0
  102a4e:	6a 00                	push   $0x0
  pushl $242
  102a50:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102a55:	e9 9c 00 00 00       	jmp    102af6 <__alltraps>

00102a5a <vector243>:
.globl vector243
vector243:
  pushl $0
  102a5a:	6a 00                	push   $0x0
  pushl $243
  102a5c:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102a61:	e9 90 00 00 00       	jmp    102af6 <__alltraps>

00102a66 <vector244>:
.globl vector244
vector244:
  pushl $0
  102a66:	6a 00                	push   $0x0
  pushl $244
  102a68:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102a6d:	e9 84 00 00 00       	jmp    102af6 <__alltraps>

00102a72 <vector245>:
.globl vector245
vector245:
  pushl $0
  102a72:	6a 00                	push   $0x0
  pushl $245
  102a74:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102a79:	e9 78 00 00 00       	jmp    102af6 <__alltraps>

00102a7e <vector246>:
.globl vector246
vector246:
  pushl $0
  102a7e:	6a 00                	push   $0x0
  pushl $246
  102a80:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102a85:	e9 6c 00 00 00       	jmp    102af6 <__alltraps>

00102a8a <vector247>:
.globl vector247
vector247:
  pushl $0
  102a8a:	6a 00                	push   $0x0
  pushl $247
  102a8c:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102a91:	e9 60 00 00 00       	jmp    102af6 <__alltraps>

00102a96 <vector248>:
.globl vector248
vector248:
  pushl $0
  102a96:	6a 00                	push   $0x0
  pushl $248
  102a98:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102a9d:	e9 54 00 00 00       	jmp    102af6 <__alltraps>

00102aa2 <vector249>:
.globl vector249
vector249:
  pushl $0
  102aa2:	6a 00                	push   $0x0
  pushl $249
  102aa4:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102aa9:	e9 48 00 00 00       	jmp    102af6 <__alltraps>

00102aae <vector250>:
.globl vector250
vector250:
  pushl $0
  102aae:	6a 00                	push   $0x0
  pushl $250
  102ab0:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102ab5:	e9 3c 00 00 00       	jmp    102af6 <__alltraps>

00102aba <vector251>:
.globl vector251
vector251:
  pushl $0
  102aba:	6a 00                	push   $0x0
  pushl $251
  102abc:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102ac1:	e9 30 00 00 00       	jmp    102af6 <__alltraps>

00102ac6 <vector252>:
.globl vector252
vector252:
  pushl $0
  102ac6:	6a 00                	push   $0x0
  pushl $252
  102ac8:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102acd:	e9 24 00 00 00       	jmp    102af6 <__alltraps>

00102ad2 <vector253>:
.globl vector253
vector253:
  pushl $0
  102ad2:	6a 00                	push   $0x0
  pushl $253
  102ad4:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102ad9:	e9 18 00 00 00       	jmp    102af6 <__alltraps>

00102ade <vector254>:
.globl vector254
vector254:
  pushl $0
  102ade:	6a 00                	push   $0x0
  pushl $254
  102ae0:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102ae5:	e9 0c 00 00 00       	jmp    102af6 <__alltraps>

00102aea <vector255>:
.globl vector255
vector255:
  pushl $0
  102aea:	6a 00                	push   $0x0
  pushl $255
  102aec:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102af1:	e9 00 00 00 00       	jmp    102af6 <__alltraps>

00102af6 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102af6:	1e                   	push   %ds
    pushl %es
  102af7:	06                   	push   %es
    pushl %fs
  102af8:	0f a0                	push   %fs
    pushl %gs
  102afa:	0f a8                	push   %gs
    pushal
  102afc:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102afd:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102b02:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102b04:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102b06:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102b07:	e8 60 f5 ff ff       	call   10206c <trap>

    # pop the pushed stack pointer
    popl %esp
  102b0c:	5c                   	pop    %esp

00102b0d <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102b0d:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102b0e:	0f a9                	pop    %gs
    popl %fs
  102b10:	0f a1                	pop    %fs
    popl %es
  102b12:	07                   	pop    %es
    popl %ds
  102b13:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102b14:	83 c4 08             	add    $0x8,%esp
    iret
  102b17:	cf                   	iret   

00102b18 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102b18:	55                   	push   %ebp
  102b19:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b1e:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102b21:	b8 23 00 00 00       	mov    $0x23,%eax
  102b26:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102b28:	b8 23 00 00 00       	mov    $0x23,%eax
  102b2d:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102b2f:	b8 10 00 00 00       	mov    $0x10,%eax
  102b34:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102b36:	b8 10 00 00 00       	mov    $0x10,%eax
  102b3b:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102b3d:	b8 10 00 00 00       	mov    $0x10,%eax
  102b42:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102b44:	ea 4b 2b 10 00 08 00 	ljmp   $0x8,$0x102b4b
}
  102b4b:	90                   	nop
  102b4c:	5d                   	pop    %ebp
  102b4d:	c3                   	ret    

00102b4e <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102b4e:	f3 0f 1e fb          	endbr32 
  102b52:	55                   	push   %ebp
  102b53:	89 e5                	mov    %esp,%ebp
  102b55:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102b58:	b8 20 19 11 00       	mov    $0x111920,%eax
  102b5d:	05 00 04 00 00       	add    $0x400,%eax
  102b62:	a3 a4 18 11 00       	mov    %eax,0x1118a4
    ts.ts_ss0 = KERNEL_DS;
  102b67:	66 c7 05 a8 18 11 00 	movw   $0x10,0x1118a8
  102b6e:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102b70:	66 c7 05 08 0a 11 00 	movw   $0x68,0x110a08
  102b77:	68 00 
  102b79:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102b7e:	0f b7 c0             	movzwl %ax,%eax
  102b81:	66 a3 0a 0a 11 00    	mov    %ax,0x110a0a
  102b87:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102b8c:	c1 e8 10             	shr    $0x10,%eax
  102b8f:	a2 0c 0a 11 00       	mov    %al,0x110a0c
  102b94:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b9b:	24 f0                	and    $0xf0,%al
  102b9d:	0c 09                	or     $0x9,%al
  102b9f:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102ba4:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102bab:	0c 10                	or     $0x10,%al
  102bad:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102bb2:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102bb9:	24 9f                	and    $0x9f,%al
  102bbb:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102bc0:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102bc7:	0c 80                	or     $0x80,%al
  102bc9:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102bce:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102bd5:	24 f0                	and    $0xf0,%al
  102bd7:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102bdc:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102be3:	24 ef                	and    $0xef,%al
  102be5:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102bea:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102bf1:	24 df                	and    $0xdf,%al
  102bf3:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102bf8:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102bff:	0c 40                	or     $0x40,%al
  102c01:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102c06:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102c0d:	24 7f                	and    $0x7f,%al
  102c0f:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102c14:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102c19:	c1 e8 18             	shr    $0x18,%eax
  102c1c:	a2 0f 0a 11 00       	mov    %al,0x110a0f
    gdt[SEG_TSS].sd_s = 0;
  102c21:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102c28:	24 ef                	and    $0xef,%al
  102c2a:	a2 0d 0a 11 00       	mov    %al,0x110a0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102c2f:	c7 04 24 10 0a 11 00 	movl   $0x110a10,(%esp)
  102c36:	e8 dd fe ff ff       	call   102b18 <lgdt>
  102c3b:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102c41:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102c45:	0f 00 d8             	ltr    %ax
}
  102c48:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102c49:	90                   	nop
  102c4a:	c9                   	leave  
  102c4b:	c3                   	ret    

00102c4c <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102c4c:	f3 0f 1e fb          	endbr32 
  102c50:	55                   	push   %ebp
  102c51:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102c53:	e8 f6 fe ff ff       	call   102b4e <gdt_init>
}
  102c58:	90                   	nop
  102c59:	5d                   	pop    %ebp
  102c5a:	c3                   	ret    

00102c5b <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102c5b:	f3 0f 1e fb          	endbr32 
  102c5f:	55                   	push   %ebp
  102c60:	89 e5                	mov    %esp,%ebp
  102c62:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102c6c:	eb 03                	jmp    102c71 <strlen+0x16>
        cnt ++;
  102c6e:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102c71:	8b 45 08             	mov    0x8(%ebp),%eax
  102c74:	8d 50 01             	lea    0x1(%eax),%edx
  102c77:	89 55 08             	mov    %edx,0x8(%ebp)
  102c7a:	0f b6 00             	movzbl (%eax),%eax
  102c7d:	84 c0                	test   %al,%al
  102c7f:	75 ed                	jne    102c6e <strlen+0x13>
    }
    return cnt;
  102c81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c84:	c9                   	leave  
  102c85:	c3                   	ret    

00102c86 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102c86:	f3 0f 1e fb          	endbr32 
  102c8a:	55                   	push   %ebp
  102c8b:	89 e5                	mov    %esp,%ebp
  102c8d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c97:	eb 03                	jmp    102c9c <strnlen+0x16>
        cnt ++;
  102c99:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c9f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102ca2:	73 10                	jae    102cb4 <strnlen+0x2e>
  102ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca7:	8d 50 01             	lea    0x1(%eax),%edx
  102caa:	89 55 08             	mov    %edx,0x8(%ebp)
  102cad:	0f b6 00             	movzbl (%eax),%eax
  102cb0:	84 c0                	test   %al,%al
  102cb2:	75 e5                	jne    102c99 <strnlen+0x13>
    }
    return cnt;
  102cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102cb7:	c9                   	leave  
  102cb8:	c3                   	ret    

00102cb9 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102cb9:	f3 0f 1e fb          	endbr32 
  102cbd:	55                   	push   %ebp
  102cbe:	89 e5                	mov    %esp,%ebp
  102cc0:	57                   	push   %edi
  102cc1:	56                   	push   %esi
  102cc2:	83 ec 20             	sub    $0x20,%esp
  102cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cce:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102cd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cd7:	89 d1                	mov    %edx,%ecx
  102cd9:	89 c2                	mov    %eax,%edx
  102cdb:	89 ce                	mov    %ecx,%esi
  102cdd:	89 d7                	mov    %edx,%edi
  102cdf:	ac                   	lods   %ds:(%esi),%al
  102ce0:	aa                   	stos   %al,%es:(%edi)
  102ce1:	84 c0                	test   %al,%al
  102ce3:	75 fa                	jne    102cdf <strcpy+0x26>
  102ce5:	89 fa                	mov    %edi,%edx
  102ce7:	89 f1                	mov    %esi,%ecx
  102ce9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102cec:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102cef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102cf5:	83 c4 20             	add    $0x20,%esp
  102cf8:	5e                   	pop    %esi
  102cf9:	5f                   	pop    %edi
  102cfa:	5d                   	pop    %ebp
  102cfb:	c3                   	ret    

00102cfc <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102cfc:	f3 0f 1e fb          	endbr32 
  102d00:	55                   	push   %ebp
  102d01:	89 e5                	mov    %esp,%ebp
  102d03:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102d06:	8b 45 08             	mov    0x8(%ebp),%eax
  102d09:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102d0c:	eb 1e                	jmp    102d2c <strncpy+0x30>
        if ((*p = *src) != '\0') {
  102d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d11:	0f b6 10             	movzbl (%eax),%edx
  102d14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d17:	88 10                	mov    %dl,(%eax)
  102d19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d1c:	0f b6 00             	movzbl (%eax),%eax
  102d1f:	84 c0                	test   %al,%al
  102d21:	74 03                	je     102d26 <strncpy+0x2a>
            src ++;
  102d23:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102d26:	ff 45 fc             	incl   -0x4(%ebp)
  102d29:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102d2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d30:	75 dc                	jne    102d0e <strncpy+0x12>
    }
    return dst;
  102d32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102d35:	c9                   	leave  
  102d36:	c3                   	ret    

00102d37 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102d37:	f3 0f 1e fb          	endbr32 
  102d3b:	55                   	push   %ebp
  102d3c:	89 e5                	mov    %esp,%ebp
  102d3e:	57                   	push   %edi
  102d3f:	56                   	push   %esi
  102d40:	83 ec 20             	sub    $0x20,%esp
  102d43:	8b 45 08             	mov    0x8(%ebp),%eax
  102d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102d4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d55:	89 d1                	mov    %edx,%ecx
  102d57:	89 c2                	mov    %eax,%edx
  102d59:	89 ce                	mov    %ecx,%esi
  102d5b:	89 d7                	mov    %edx,%edi
  102d5d:	ac                   	lods   %ds:(%esi),%al
  102d5e:	ae                   	scas   %es:(%edi),%al
  102d5f:	75 08                	jne    102d69 <strcmp+0x32>
  102d61:	84 c0                	test   %al,%al
  102d63:	75 f8                	jne    102d5d <strcmp+0x26>
  102d65:	31 c0                	xor    %eax,%eax
  102d67:	eb 04                	jmp    102d6d <strcmp+0x36>
  102d69:	19 c0                	sbb    %eax,%eax
  102d6b:	0c 01                	or     $0x1,%al
  102d6d:	89 fa                	mov    %edi,%edx
  102d6f:	89 f1                	mov    %esi,%ecx
  102d71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d74:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d77:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102d7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102d7d:	83 c4 20             	add    $0x20,%esp
  102d80:	5e                   	pop    %esi
  102d81:	5f                   	pop    %edi
  102d82:	5d                   	pop    %ebp
  102d83:	c3                   	ret    

00102d84 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102d84:	f3 0f 1e fb          	endbr32 
  102d88:	55                   	push   %ebp
  102d89:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d8b:	eb 09                	jmp    102d96 <strncmp+0x12>
        n --, s1 ++, s2 ++;
  102d8d:	ff 4d 10             	decl   0x10(%ebp)
  102d90:	ff 45 08             	incl   0x8(%ebp)
  102d93:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d9a:	74 1a                	je     102db6 <strncmp+0x32>
  102d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d9f:	0f b6 00             	movzbl (%eax),%eax
  102da2:	84 c0                	test   %al,%al
  102da4:	74 10                	je     102db6 <strncmp+0x32>
  102da6:	8b 45 08             	mov    0x8(%ebp),%eax
  102da9:	0f b6 10             	movzbl (%eax),%edx
  102dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  102daf:	0f b6 00             	movzbl (%eax),%eax
  102db2:	38 c2                	cmp    %al,%dl
  102db4:	74 d7                	je     102d8d <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102db6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102dba:	74 18                	je     102dd4 <strncmp+0x50>
  102dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  102dbf:	0f b6 00             	movzbl (%eax),%eax
  102dc2:	0f b6 d0             	movzbl %al,%edx
  102dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dc8:	0f b6 00             	movzbl (%eax),%eax
  102dcb:	0f b6 c0             	movzbl %al,%eax
  102dce:	29 c2                	sub    %eax,%edx
  102dd0:	89 d0                	mov    %edx,%eax
  102dd2:	eb 05                	jmp    102dd9 <strncmp+0x55>
  102dd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102dd9:	5d                   	pop    %ebp
  102dda:	c3                   	ret    

00102ddb <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102ddb:	f3 0f 1e fb          	endbr32 
  102ddf:	55                   	push   %ebp
  102de0:	89 e5                	mov    %esp,%ebp
  102de2:	83 ec 04             	sub    $0x4,%esp
  102de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102de8:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102deb:	eb 13                	jmp    102e00 <strchr+0x25>
        if (*s == c) {
  102ded:	8b 45 08             	mov    0x8(%ebp),%eax
  102df0:	0f b6 00             	movzbl (%eax),%eax
  102df3:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102df6:	75 05                	jne    102dfd <strchr+0x22>
            return (char *)s;
  102df8:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfb:	eb 12                	jmp    102e0f <strchr+0x34>
        }
        s ++;
  102dfd:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102e00:	8b 45 08             	mov    0x8(%ebp),%eax
  102e03:	0f b6 00             	movzbl (%eax),%eax
  102e06:	84 c0                	test   %al,%al
  102e08:	75 e3                	jne    102ded <strchr+0x12>
    }
    return NULL;
  102e0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102e0f:	c9                   	leave  
  102e10:	c3                   	ret    

00102e11 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102e11:	f3 0f 1e fb          	endbr32 
  102e15:	55                   	push   %ebp
  102e16:	89 e5                	mov    %esp,%ebp
  102e18:	83 ec 04             	sub    $0x4,%esp
  102e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e1e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102e21:	eb 0e                	jmp    102e31 <strfind+0x20>
        if (*s == c) {
  102e23:	8b 45 08             	mov    0x8(%ebp),%eax
  102e26:	0f b6 00             	movzbl (%eax),%eax
  102e29:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102e2c:	74 0f                	je     102e3d <strfind+0x2c>
            break;
        }
        s ++;
  102e2e:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102e31:	8b 45 08             	mov    0x8(%ebp),%eax
  102e34:	0f b6 00             	movzbl (%eax),%eax
  102e37:	84 c0                	test   %al,%al
  102e39:	75 e8                	jne    102e23 <strfind+0x12>
  102e3b:	eb 01                	jmp    102e3e <strfind+0x2d>
            break;
  102e3d:	90                   	nop
    }
    return (char *)s;
  102e3e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102e41:	c9                   	leave  
  102e42:	c3                   	ret    

00102e43 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102e43:	f3 0f 1e fb          	endbr32 
  102e47:	55                   	push   %ebp
  102e48:	89 e5                	mov    %esp,%ebp
  102e4a:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102e4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102e54:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102e5b:	eb 03                	jmp    102e60 <strtol+0x1d>
        s ++;
  102e5d:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102e60:	8b 45 08             	mov    0x8(%ebp),%eax
  102e63:	0f b6 00             	movzbl (%eax),%eax
  102e66:	3c 20                	cmp    $0x20,%al
  102e68:	74 f3                	je     102e5d <strtol+0x1a>
  102e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6d:	0f b6 00             	movzbl (%eax),%eax
  102e70:	3c 09                	cmp    $0x9,%al
  102e72:	74 e9                	je     102e5d <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  102e74:	8b 45 08             	mov    0x8(%ebp),%eax
  102e77:	0f b6 00             	movzbl (%eax),%eax
  102e7a:	3c 2b                	cmp    $0x2b,%al
  102e7c:	75 05                	jne    102e83 <strtol+0x40>
        s ++;
  102e7e:	ff 45 08             	incl   0x8(%ebp)
  102e81:	eb 14                	jmp    102e97 <strtol+0x54>
    }
    else if (*s == '-') {
  102e83:	8b 45 08             	mov    0x8(%ebp),%eax
  102e86:	0f b6 00             	movzbl (%eax),%eax
  102e89:	3c 2d                	cmp    $0x2d,%al
  102e8b:	75 0a                	jne    102e97 <strtol+0x54>
        s ++, neg = 1;
  102e8d:	ff 45 08             	incl   0x8(%ebp)
  102e90:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102e97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e9b:	74 06                	je     102ea3 <strtol+0x60>
  102e9d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102ea1:	75 22                	jne    102ec5 <strtol+0x82>
  102ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea6:	0f b6 00             	movzbl (%eax),%eax
  102ea9:	3c 30                	cmp    $0x30,%al
  102eab:	75 18                	jne    102ec5 <strtol+0x82>
  102ead:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb0:	40                   	inc    %eax
  102eb1:	0f b6 00             	movzbl (%eax),%eax
  102eb4:	3c 78                	cmp    $0x78,%al
  102eb6:	75 0d                	jne    102ec5 <strtol+0x82>
        s += 2, base = 16;
  102eb8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102ebc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102ec3:	eb 29                	jmp    102eee <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  102ec5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ec9:	75 16                	jne    102ee1 <strtol+0x9e>
  102ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  102ece:	0f b6 00             	movzbl (%eax),%eax
  102ed1:	3c 30                	cmp    $0x30,%al
  102ed3:	75 0c                	jne    102ee1 <strtol+0x9e>
        s ++, base = 8;
  102ed5:	ff 45 08             	incl   0x8(%ebp)
  102ed8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102edf:	eb 0d                	jmp    102eee <strtol+0xab>
    }
    else if (base == 0) {
  102ee1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ee5:	75 07                	jne    102eee <strtol+0xab>
        base = 10;
  102ee7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102eee:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef1:	0f b6 00             	movzbl (%eax),%eax
  102ef4:	3c 2f                	cmp    $0x2f,%al
  102ef6:	7e 1b                	jle    102f13 <strtol+0xd0>
  102ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  102efb:	0f b6 00             	movzbl (%eax),%eax
  102efe:	3c 39                	cmp    $0x39,%al
  102f00:	7f 11                	jg     102f13 <strtol+0xd0>
            dig = *s - '0';
  102f02:	8b 45 08             	mov    0x8(%ebp),%eax
  102f05:	0f b6 00             	movzbl (%eax),%eax
  102f08:	0f be c0             	movsbl %al,%eax
  102f0b:	83 e8 30             	sub    $0x30,%eax
  102f0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f11:	eb 48                	jmp    102f5b <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102f13:	8b 45 08             	mov    0x8(%ebp),%eax
  102f16:	0f b6 00             	movzbl (%eax),%eax
  102f19:	3c 60                	cmp    $0x60,%al
  102f1b:	7e 1b                	jle    102f38 <strtol+0xf5>
  102f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f20:	0f b6 00             	movzbl (%eax),%eax
  102f23:	3c 7a                	cmp    $0x7a,%al
  102f25:	7f 11                	jg     102f38 <strtol+0xf5>
            dig = *s - 'a' + 10;
  102f27:	8b 45 08             	mov    0x8(%ebp),%eax
  102f2a:	0f b6 00             	movzbl (%eax),%eax
  102f2d:	0f be c0             	movsbl %al,%eax
  102f30:	83 e8 57             	sub    $0x57,%eax
  102f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f36:	eb 23                	jmp    102f5b <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102f38:	8b 45 08             	mov    0x8(%ebp),%eax
  102f3b:	0f b6 00             	movzbl (%eax),%eax
  102f3e:	3c 40                	cmp    $0x40,%al
  102f40:	7e 3b                	jle    102f7d <strtol+0x13a>
  102f42:	8b 45 08             	mov    0x8(%ebp),%eax
  102f45:	0f b6 00             	movzbl (%eax),%eax
  102f48:	3c 5a                	cmp    $0x5a,%al
  102f4a:	7f 31                	jg     102f7d <strtol+0x13a>
            dig = *s - 'A' + 10;
  102f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f4f:	0f b6 00             	movzbl (%eax),%eax
  102f52:	0f be c0             	movsbl %al,%eax
  102f55:	83 e8 37             	sub    $0x37,%eax
  102f58:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f5e:	3b 45 10             	cmp    0x10(%ebp),%eax
  102f61:	7d 19                	jge    102f7c <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  102f63:	ff 45 08             	incl   0x8(%ebp)
  102f66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f69:	0f af 45 10          	imul   0x10(%ebp),%eax
  102f6d:	89 c2                	mov    %eax,%edx
  102f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f72:	01 d0                	add    %edx,%eax
  102f74:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102f77:	e9 72 ff ff ff       	jmp    102eee <strtol+0xab>
            break;
  102f7c:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102f7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f81:	74 08                	je     102f8b <strtol+0x148>
        *endptr = (char *) s;
  102f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f86:	8b 55 08             	mov    0x8(%ebp),%edx
  102f89:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102f8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102f8f:	74 07                	je     102f98 <strtol+0x155>
  102f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f94:	f7 d8                	neg    %eax
  102f96:	eb 03                	jmp    102f9b <strtol+0x158>
  102f98:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102f9b:	c9                   	leave  
  102f9c:	c3                   	ret    

00102f9d <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102f9d:	f3 0f 1e fb          	endbr32 
  102fa1:	55                   	push   %ebp
  102fa2:	89 e5                	mov    %esp,%ebp
  102fa4:	57                   	push   %edi
  102fa5:	83 ec 24             	sub    $0x24,%esp
  102fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fab:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102fae:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  102fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  102fb8:	88 55 f7             	mov    %dl,-0x9(%ebp)
  102fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  102fbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102fc1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102fc4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102fc8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102fcb:	89 d7                	mov    %edx,%edi
  102fcd:	f3 aa                	rep stos %al,%es:(%edi)
  102fcf:	89 fa                	mov    %edi,%edx
  102fd1:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102fd4:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102fd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102fda:	83 c4 24             	add    $0x24,%esp
  102fdd:	5f                   	pop    %edi
  102fde:	5d                   	pop    %ebp
  102fdf:	c3                   	ret    

00102fe0 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102fe0:	f3 0f 1e fb          	endbr32 
  102fe4:	55                   	push   %ebp
  102fe5:	89 e5                	mov    %esp,%ebp
  102fe7:	57                   	push   %edi
  102fe8:	56                   	push   %esi
  102fe9:	53                   	push   %ebx
  102fea:	83 ec 30             	sub    $0x30,%esp
  102fed:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ff6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ff9:	8b 45 10             	mov    0x10(%ebp),%eax
  102ffc:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103002:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103005:	73 42                	jae    103049 <memmove+0x69>
  103007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10300a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10300d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103010:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103013:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103016:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103019:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10301c:	c1 e8 02             	shr    $0x2,%eax
  10301f:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103021:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103024:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103027:	89 d7                	mov    %edx,%edi
  103029:	89 c6                	mov    %eax,%esi
  10302b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10302d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103030:	83 e1 03             	and    $0x3,%ecx
  103033:	74 02                	je     103037 <memmove+0x57>
  103035:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103037:	89 f0                	mov    %esi,%eax
  103039:	89 fa                	mov    %edi,%edx
  10303b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10303e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103041:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  103044:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  103047:	eb 36                	jmp    10307f <memmove+0x9f>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103049:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10304c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10304f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103052:	01 c2                	add    %eax,%edx
  103054:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103057:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10305a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10305d:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  103060:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103063:	89 c1                	mov    %eax,%ecx
  103065:	89 d8                	mov    %ebx,%eax
  103067:	89 d6                	mov    %edx,%esi
  103069:	89 c7                	mov    %eax,%edi
  10306b:	fd                   	std    
  10306c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10306e:	fc                   	cld    
  10306f:	89 f8                	mov    %edi,%eax
  103071:	89 f2                	mov    %esi,%edx
  103073:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103076:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103079:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  10307c:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10307f:	83 c4 30             	add    $0x30,%esp
  103082:	5b                   	pop    %ebx
  103083:	5e                   	pop    %esi
  103084:	5f                   	pop    %edi
  103085:	5d                   	pop    %ebp
  103086:	c3                   	ret    

00103087 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103087:	f3 0f 1e fb          	endbr32 
  10308b:	55                   	push   %ebp
  10308c:	89 e5                	mov    %esp,%ebp
  10308e:	57                   	push   %edi
  10308f:	56                   	push   %esi
  103090:	83 ec 20             	sub    $0x20,%esp
  103093:	8b 45 08             	mov    0x8(%ebp),%eax
  103096:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103099:	8b 45 0c             	mov    0xc(%ebp),%eax
  10309c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10309f:	8b 45 10             	mov    0x10(%ebp),%eax
  1030a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1030a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030a8:	c1 e8 02             	shr    $0x2,%eax
  1030ab:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1030ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030b3:	89 d7                	mov    %edx,%edi
  1030b5:	89 c6                	mov    %eax,%esi
  1030b7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1030b9:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1030bc:	83 e1 03             	and    $0x3,%ecx
  1030bf:	74 02                	je     1030c3 <memcpy+0x3c>
  1030c1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1030c3:	89 f0                	mov    %esi,%eax
  1030c5:	89 fa                	mov    %edi,%edx
  1030c7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030ca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1030cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1030d3:	83 c4 20             	add    $0x20,%esp
  1030d6:	5e                   	pop    %esi
  1030d7:	5f                   	pop    %edi
  1030d8:	5d                   	pop    %ebp
  1030d9:	c3                   	ret    

001030da <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1030da:	f3 0f 1e fb          	endbr32 
  1030de:	55                   	push   %ebp
  1030df:	89 e5                	mov    %esp,%ebp
  1030e1:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1030e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1030ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1030f0:	eb 2e                	jmp    103120 <memcmp+0x46>
        if (*s1 != *s2) {
  1030f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030f5:	0f b6 10             	movzbl (%eax),%edx
  1030f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030fb:	0f b6 00             	movzbl (%eax),%eax
  1030fe:	38 c2                	cmp    %al,%dl
  103100:	74 18                	je     10311a <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103102:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103105:	0f b6 00             	movzbl (%eax),%eax
  103108:	0f b6 d0             	movzbl %al,%edx
  10310b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10310e:	0f b6 00             	movzbl (%eax),%eax
  103111:	0f b6 c0             	movzbl %al,%eax
  103114:	29 c2                	sub    %eax,%edx
  103116:	89 d0                	mov    %edx,%eax
  103118:	eb 18                	jmp    103132 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  10311a:	ff 45 fc             	incl   -0x4(%ebp)
  10311d:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  103120:	8b 45 10             	mov    0x10(%ebp),%eax
  103123:	8d 50 ff             	lea    -0x1(%eax),%edx
  103126:	89 55 10             	mov    %edx,0x10(%ebp)
  103129:	85 c0                	test   %eax,%eax
  10312b:	75 c5                	jne    1030f2 <memcmp+0x18>
    }
    return 0;
  10312d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103132:	c9                   	leave  
  103133:	c3                   	ret    

00103134 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  103134:	f3 0f 1e fb          	endbr32 
  103138:	55                   	push   %ebp
  103139:	89 e5                	mov    %esp,%ebp
  10313b:	83 ec 58             	sub    $0x58,%esp
  10313e:	8b 45 10             	mov    0x10(%ebp),%eax
  103141:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103144:	8b 45 14             	mov    0x14(%ebp),%eax
  103147:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10314a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10314d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103150:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103153:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  103156:	8b 45 18             	mov    0x18(%ebp),%eax
  103159:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10315c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10315f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103162:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103165:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10316b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10316e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103172:	74 1c                	je     103190 <printnum+0x5c>
  103174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103177:	ba 00 00 00 00       	mov    $0x0,%edx
  10317c:	f7 75 e4             	divl   -0x1c(%ebp)
  10317f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  103182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103185:	ba 00 00 00 00       	mov    $0x0,%edx
  10318a:	f7 75 e4             	divl   -0x1c(%ebp)
  10318d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103190:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103193:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103196:	f7 75 e4             	divl   -0x1c(%ebp)
  103199:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10319c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10319f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1031a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031a8:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1031ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1031ae:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1031b1:	8b 45 18             	mov    0x18(%ebp),%eax
  1031b4:	ba 00 00 00 00       	mov    $0x0,%edx
  1031b9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1031bc:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1031bf:	19 d1                	sbb    %edx,%ecx
  1031c1:	72 4c                	jb     10320f <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  1031c3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1031c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1031c9:	8b 45 20             	mov    0x20(%ebp),%eax
  1031cc:	89 44 24 18          	mov    %eax,0x18(%esp)
  1031d0:	89 54 24 14          	mov    %edx,0x14(%esp)
  1031d4:	8b 45 18             	mov    0x18(%ebp),%eax
  1031d7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1031db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1031e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1031e5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1031e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1031f3:	89 04 24             	mov    %eax,(%esp)
  1031f6:	e8 39 ff ff ff       	call   103134 <printnum>
  1031fb:	eb 1b                	jmp    103218 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1031fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  103200:	89 44 24 04          	mov    %eax,0x4(%esp)
  103204:	8b 45 20             	mov    0x20(%ebp),%eax
  103207:	89 04 24             	mov    %eax,(%esp)
  10320a:	8b 45 08             	mov    0x8(%ebp),%eax
  10320d:	ff d0                	call   *%eax
        while (-- width > 0)
  10320f:	ff 4d 1c             	decl   0x1c(%ebp)
  103212:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103216:	7f e5                	jg     1031fd <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  103218:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10321b:	05 f0 3f 10 00       	add    $0x103ff0,%eax
  103220:	0f b6 00             	movzbl (%eax),%eax
  103223:	0f be c0             	movsbl %al,%eax
  103226:	8b 55 0c             	mov    0xc(%ebp),%edx
  103229:	89 54 24 04          	mov    %edx,0x4(%esp)
  10322d:	89 04 24             	mov    %eax,(%esp)
  103230:	8b 45 08             	mov    0x8(%ebp),%eax
  103233:	ff d0                	call   *%eax
}
  103235:	90                   	nop
  103236:	c9                   	leave  
  103237:	c3                   	ret    

00103238 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  103238:	f3 0f 1e fb          	endbr32 
  10323c:	55                   	push   %ebp
  10323d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10323f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103243:	7e 14                	jle    103259 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  103245:	8b 45 08             	mov    0x8(%ebp),%eax
  103248:	8b 00                	mov    (%eax),%eax
  10324a:	8d 48 08             	lea    0x8(%eax),%ecx
  10324d:	8b 55 08             	mov    0x8(%ebp),%edx
  103250:	89 0a                	mov    %ecx,(%edx)
  103252:	8b 50 04             	mov    0x4(%eax),%edx
  103255:	8b 00                	mov    (%eax),%eax
  103257:	eb 30                	jmp    103289 <getuint+0x51>
    }
    else if (lflag) {
  103259:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10325d:	74 16                	je     103275 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  10325f:	8b 45 08             	mov    0x8(%ebp),%eax
  103262:	8b 00                	mov    (%eax),%eax
  103264:	8d 48 04             	lea    0x4(%eax),%ecx
  103267:	8b 55 08             	mov    0x8(%ebp),%edx
  10326a:	89 0a                	mov    %ecx,(%edx)
  10326c:	8b 00                	mov    (%eax),%eax
  10326e:	ba 00 00 00 00       	mov    $0x0,%edx
  103273:	eb 14                	jmp    103289 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  103275:	8b 45 08             	mov    0x8(%ebp),%eax
  103278:	8b 00                	mov    (%eax),%eax
  10327a:	8d 48 04             	lea    0x4(%eax),%ecx
  10327d:	8b 55 08             	mov    0x8(%ebp),%edx
  103280:	89 0a                	mov    %ecx,(%edx)
  103282:	8b 00                	mov    (%eax),%eax
  103284:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  103289:	5d                   	pop    %ebp
  10328a:	c3                   	ret    

0010328b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10328b:	f3 0f 1e fb          	endbr32 
  10328f:	55                   	push   %ebp
  103290:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103292:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103296:	7e 14                	jle    1032ac <getint+0x21>
        return va_arg(*ap, long long);
  103298:	8b 45 08             	mov    0x8(%ebp),%eax
  10329b:	8b 00                	mov    (%eax),%eax
  10329d:	8d 48 08             	lea    0x8(%eax),%ecx
  1032a0:	8b 55 08             	mov    0x8(%ebp),%edx
  1032a3:	89 0a                	mov    %ecx,(%edx)
  1032a5:	8b 50 04             	mov    0x4(%eax),%edx
  1032a8:	8b 00                	mov    (%eax),%eax
  1032aa:	eb 28                	jmp    1032d4 <getint+0x49>
    }
    else if (lflag) {
  1032ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032b0:	74 12                	je     1032c4 <getint+0x39>
        return va_arg(*ap, long);
  1032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b5:	8b 00                	mov    (%eax),%eax
  1032b7:	8d 48 04             	lea    0x4(%eax),%ecx
  1032ba:	8b 55 08             	mov    0x8(%ebp),%edx
  1032bd:	89 0a                	mov    %ecx,(%edx)
  1032bf:	8b 00                	mov    (%eax),%eax
  1032c1:	99                   	cltd   
  1032c2:	eb 10                	jmp    1032d4 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  1032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c7:	8b 00                	mov    (%eax),%eax
  1032c9:	8d 48 04             	lea    0x4(%eax),%ecx
  1032cc:	8b 55 08             	mov    0x8(%ebp),%edx
  1032cf:	89 0a                	mov    %ecx,(%edx)
  1032d1:	8b 00                	mov    (%eax),%eax
  1032d3:	99                   	cltd   
    }
}
  1032d4:	5d                   	pop    %ebp
  1032d5:	c3                   	ret    

001032d6 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1032d6:	f3 0f 1e fb          	endbr32 
  1032da:	55                   	push   %ebp
  1032db:	89 e5                	mov    %esp,%ebp
  1032dd:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1032e0:	8d 45 14             	lea    0x14(%ebp),%eax
  1032e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1032e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1032f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1032f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1032fe:	89 04 24             	mov    %eax,(%esp)
  103301:	e8 03 00 00 00       	call   103309 <vprintfmt>
    va_end(ap);
}
  103306:	90                   	nop
  103307:	c9                   	leave  
  103308:	c3                   	ret    

00103309 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  103309:	f3 0f 1e fb          	endbr32 
  10330d:	55                   	push   %ebp
  10330e:	89 e5                	mov    %esp,%ebp
  103310:	56                   	push   %esi
  103311:	53                   	push   %ebx
  103312:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103315:	eb 17                	jmp    10332e <vprintfmt+0x25>
            if (ch == '\0') {
  103317:	85 db                	test   %ebx,%ebx
  103319:	0f 84 c0 03 00 00    	je     1036df <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  10331f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103322:	89 44 24 04          	mov    %eax,0x4(%esp)
  103326:	89 1c 24             	mov    %ebx,(%esp)
  103329:	8b 45 08             	mov    0x8(%ebp),%eax
  10332c:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10332e:	8b 45 10             	mov    0x10(%ebp),%eax
  103331:	8d 50 01             	lea    0x1(%eax),%edx
  103334:	89 55 10             	mov    %edx,0x10(%ebp)
  103337:	0f b6 00             	movzbl (%eax),%eax
  10333a:	0f b6 d8             	movzbl %al,%ebx
  10333d:	83 fb 25             	cmp    $0x25,%ebx
  103340:	75 d5                	jne    103317 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  103342:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103346:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10334d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103350:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103353:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10335a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10335d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103360:	8b 45 10             	mov    0x10(%ebp),%eax
  103363:	8d 50 01             	lea    0x1(%eax),%edx
  103366:	89 55 10             	mov    %edx,0x10(%ebp)
  103369:	0f b6 00             	movzbl (%eax),%eax
  10336c:	0f b6 d8             	movzbl %al,%ebx
  10336f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103372:	83 f8 55             	cmp    $0x55,%eax
  103375:	0f 87 38 03 00 00    	ja     1036b3 <vprintfmt+0x3aa>
  10337b:	8b 04 85 14 40 10 00 	mov    0x104014(,%eax,4),%eax
  103382:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103385:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  103389:	eb d5                	jmp    103360 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10338b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10338f:	eb cf                	jmp    103360 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103391:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  103398:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10339b:	89 d0                	mov    %edx,%eax
  10339d:	c1 e0 02             	shl    $0x2,%eax
  1033a0:	01 d0                	add    %edx,%eax
  1033a2:	01 c0                	add    %eax,%eax
  1033a4:	01 d8                	add    %ebx,%eax
  1033a6:	83 e8 30             	sub    $0x30,%eax
  1033a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1033ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1033af:	0f b6 00             	movzbl (%eax),%eax
  1033b2:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1033b5:	83 fb 2f             	cmp    $0x2f,%ebx
  1033b8:	7e 38                	jle    1033f2 <vprintfmt+0xe9>
  1033ba:	83 fb 39             	cmp    $0x39,%ebx
  1033bd:	7f 33                	jg     1033f2 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  1033bf:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1033c2:	eb d4                	jmp    103398 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1033c4:	8b 45 14             	mov    0x14(%ebp),%eax
  1033c7:	8d 50 04             	lea    0x4(%eax),%edx
  1033ca:	89 55 14             	mov    %edx,0x14(%ebp)
  1033cd:	8b 00                	mov    (%eax),%eax
  1033cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1033d2:	eb 1f                	jmp    1033f3 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  1033d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033d8:	79 86                	jns    103360 <vprintfmt+0x57>
                width = 0;
  1033da:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1033e1:	e9 7a ff ff ff       	jmp    103360 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  1033e6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1033ed:	e9 6e ff ff ff       	jmp    103360 <vprintfmt+0x57>
            goto process_precision;
  1033f2:	90                   	nop

        process_precision:
            if (width < 0)
  1033f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033f7:	0f 89 63 ff ff ff    	jns    103360 <vprintfmt+0x57>
                width = precision, precision = -1;
  1033fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103400:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103403:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10340a:	e9 51 ff ff ff       	jmp    103360 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10340f:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  103412:	e9 49 ff ff ff       	jmp    103360 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103417:	8b 45 14             	mov    0x14(%ebp),%eax
  10341a:	8d 50 04             	lea    0x4(%eax),%edx
  10341d:	89 55 14             	mov    %edx,0x14(%ebp)
  103420:	8b 00                	mov    (%eax),%eax
  103422:	8b 55 0c             	mov    0xc(%ebp),%edx
  103425:	89 54 24 04          	mov    %edx,0x4(%esp)
  103429:	89 04 24             	mov    %eax,(%esp)
  10342c:	8b 45 08             	mov    0x8(%ebp),%eax
  10342f:	ff d0                	call   *%eax
            break;
  103431:	e9 a4 02 00 00       	jmp    1036da <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103436:	8b 45 14             	mov    0x14(%ebp),%eax
  103439:	8d 50 04             	lea    0x4(%eax),%edx
  10343c:	89 55 14             	mov    %edx,0x14(%ebp)
  10343f:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  103441:	85 db                	test   %ebx,%ebx
  103443:	79 02                	jns    103447 <vprintfmt+0x13e>
                err = -err;
  103445:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103447:	83 fb 06             	cmp    $0x6,%ebx
  10344a:	7f 0b                	jg     103457 <vprintfmt+0x14e>
  10344c:	8b 34 9d d4 3f 10 00 	mov    0x103fd4(,%ebx,4),%esi
  103453:	85 f6                	test   %esi,%esi
  103455:	75 23                	jne    10347a <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  103457:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10345b:	c7 44 24 08 01 40 10 	movl   $0x104001,0x8(%esp)
  103462:	00 
  103463:	8b 45 0c             	mov    0xc(%ebp),%eax
  103466:	89 44 24 04          	mov    %eax,0x4(%esp)
  10346a:	8b 45 08             	mov    0x8(%ebp),%eax
  10346d:	89 04 24             	mov    %eax,(%esp)
  103470:	e8 61 fe ff ff       	call   1032d6 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103475:	e9 60 02 00 00       	jmp    1036da <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  10347a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10347e:	c7 44 24 08 0a 40 10 	movl   $0x10400a,0x8(%esp)
  103485:	00 
  103486:	8b 45 0c             	mov    0xc(%ebp),%eax
  103489:	89 44 24 04          	mov    %eax,0x4(%esp)
  10348d:	8b 45 08             	mov    0x8(%ebp),%eax
  103490:	89 04 24             	mov    %eax,(%esp)
  103493:	e8 3e fe ff ff       	call   1032d6 <printfmt>
            break;
  103498:	e9 3d 02 00 00       	jmp    1036da <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10349d:	8b 45 14             	mov    0x14(%ebp),%eax
  1034a0:	8d 50 04             	lea    0x4(%eax),%edx
  1034a3:	89 55 14             	mov    %edx,0x14(%ebp)
  1034a6:	8b 30                	mov    (%eax),%esi
  1034a8:	85 f6                	test   %esi,%esi
  1034aa:	75 05                	jne    1034b1 <vprintfmt+0x1a8>
                p = "(null)";
  1034ac:	be 0d 40 10 00       	mov    $0x10400d,%esi
            }
            if (width > 0 && padc != '-') {
  1034b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1034b5:	7e 76                	jle    10352d <vprintfmt+0x224>
  1034b7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1034bb:	74 70                	je     10352d <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1034bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034c4:	89 34 24             	mov    %esi,(%esp)
  1034c7:	e8 ba f7 ff ff       	call   102c86 <strnlen>
  1034cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1034cf:	29 c2                	sub    %eax,%edx
  1034d1:	89 d0                	mov    %edx,%eax
  1034d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1034d6:	eb 16                	jmp    1034ee <vprintfmt+0x1e5>
                    putch(padc, putdat);
  1034d8:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1034dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1034df:	89 54 24 04          	mov    %edx,0x4(%esp)
  1034e3:	89 04 24             	mov    %eax,(%esp)
  1034e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1034e9:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1034eb:	ff 4d e8             	decl   -0x18(%ebp)
  1034ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1034f2:	7f e4                	jg     1034d8 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1034f4:	eb 37                	jmp    10352d <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  1034f6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1034fa:	74 1f                	je     10351b <vprintfmt+0x212>
  1034fc:	83 fb 1f             	cmp    $0x1f,%ebx
  1034ff:	7e 05                	jle    103506 <vprintfmt+0x1fd>
  103501:	83 fb 7e             	cmp    $0x7e,%ebx
  103504:	7e 15                	jle    10351b <vprintfmt+0x212>
                    putch('?', putdat);
  103506:	8b 45 0c             	mov    0xc(%ebp),%eax
  103509:	89 44 24 04          	mov    %eax,0x4(%esp)
  10350d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103514:	8b 45 08             	mov    0x8(%ebp),%eax
  103517:	ff d0                	call   *%eax
  103519:	eb 0f                	jmp    10352a <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  10351b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10351e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103522:	89 1c 24             	mov    %ebx,(%esp)
  103525:	8b 45 08             	mov    0x8(%ebp),%eax
  103528:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10352a:	ff 4d e8             	decl   -0x18(%ebp)
  10352d:	89 f0                	mov    %esi,%eax
  10352f:	8d 70 01             	lea    0x1(%eax),%esi
  103532:	0f b6 00             	movzbl (%eax),%eax
  103535:	0f be d8             	movsbl %al,%ebx
  103538:	85 db                	test   %ebx,%ebx
  10353a:	74 27                	je     103563 <vprintfmt+0x25a>
  10353c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103540:	78 b4                	js     1034f6 <vprintfmt+0x1ed>
  103542:	ff 4d e4             	decl   -0x1c(%ebp)
  103545:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103549:	79 ab                	jns    1034f6 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  10354b:	eb 16                	jmp    103563 <vprintfmt+0x25a>
                putch(' ', putdat);
  10354d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103550:	89 44 24 04          	mov    %eax,0x4(%esp)
  103554:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10355b:	8b 45 08             	mov    0x8(%ebp),%eax
  10355e:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  103560:	ff 4d e8             	decl   -0x18(%ebp)
  103563:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103567:	7f e4                	jg     10354d <vprintfmt+0x244>
            }
            break;
  103569:	e9 6c 01 00 00       	jmp    1036da <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10356e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103571:	89 44 24 04          	mov    %eax,0x4(%esp)
  103575:	8d 45 14             	lea    0x14(%ebp),%eax
  103578:	89 04 24             	mov    %eax,(%esp)
  10357b:	e8 0b fd ff ff       	call   10328b <getint>
  103580:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103583:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103589:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10358c:	85 d2                	test   %edx,%edx
  10358e:	79 26                	jns    1035b6 <vprintfmt+0x2ad>
                putch('-', putdat);
  103590:	8b 45 0c             	mov    0xc(%ebp),%eax
  103593:	89 44 24 04          	mov    %eax,0x4(%esp)
  103597:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10359e:	8b 45 08             	mov    0x8(%ebp),%eax
  1035a1:	ff d0                	call   *%eax
                num = -(long long)num;
  1035a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1035a9:	f7 d8                	neg    %eax
  1035ab:	83 d2 00             	adc    $0x0,%edx
  1035ae:	f7 da                	neg    %edx
  1035b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1035b6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1035bd:	e9 a8 00 00 00       	jmp    10366a <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1035c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035c9:	8d 45 14             	lea    0x14(%ebp),%eax
  1035cc:	89 04 24             	mov    %eax,(%esp)
  1035cf:	e8 64 fc ff ff       	call   103238 <getuint>
  1035d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1035da:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1035e1:	e9 84 00 00 00       	jmp    10366a <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1035e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035ed:	8d 45 14             	lea    0x14(%ebp),%eax
  1035f0:	89 04 24             	mov    %eax,(%esp)
  1035f3:	e8 40 fc ff ff       	call   103238 <getuint>
  1035f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1035fe:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103605:	eb 63                	jmp    10366a <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  103607:	8b 45 0c             	mov    0xc(%ebp),%eax
  10360a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10360e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103615:	8b 45 08             	mov    0x8(%ebp),%eax
  103618:	ff d0                	call   *%eax
            putch('x', putdat);
  10361a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10361d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103621:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103628:	8b 45 08             	mov    0x8(%ebp),%eax
  10362b:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10362d:	8b 45 14             	mov    0x14(%ebp),%eax
  103630:	8d 50 04             	lea    0x4(%eax),%edx
  103633:	89 55 14             	mov    %edx,0x14(%ebp)
  103636:	8b 00                	mov    (%eax),%eax
  103638:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10363b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103642:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103649:	eb 1f                	jmp    10366a <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10364b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10364e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103652:	8d 45 14             	lea    0x14(%ebp),%eax
  103655:	89 04 24             	mov    %eax,(%esp)
  103658:	e8 db fb ff ff       	call   103238 <getuint>
  10365d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103660:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103663:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10366a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10366e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103671:	89 54 24 18          	mov    %edx,0x18(%esp)
  103675:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103678:	89 54 24 14          	mov    %edx,0x14(%esp)
  10367c:	89 44 24 10          	mov    %eax,0x10(%esp)
  103680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103686:	89 44 24 08          	mov    %eax,0x8(%esp)
  10368a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10368e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103691:	89 44 24 04          	mov    %eax,0x4(%esp)
  103695:	8b 45 08             	mov    0x8(%ebp),%eax
  103698:	89 04 24             	mov    %eax,(%esp)
  10369b:	e8 94 fa ff ff       	call   103134 <printnum>
            break;
  1036a0:	eb 38                	jmp    1036da <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1036a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036a9:	89 1c 24             	mov    %ebx,(%esp)
  1036ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1036af:	ff d0                	call   *%eax
            break;
  1036b1:	eb 27                	jmp    1036da <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1036b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036ba:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1036c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1036c4:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1036c6:	ff 4d 10             	decl   0x10(%ebp)
  1036c9:	eb 03                	jmp    1036ce <vprintfmt+0x3c5>
  1036cb:	ff 4d 10             	decl   0x10(%ebp)
  1036ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1036d1:	48                   	dec    %eax
  1036d2:	0f b6 00             	movzbl (%eax),%eax
  1036d5:	3c 25                	cmp    $0x25,%al
  1036d7:	75 f2                	jne    1036cb <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  1036d9:	90                   	nop
    while (1) {
  1036da:	e9 36 fc ff ff       	jmp    103315 <vprintfmt+0xc>
                return;
  1036df:	90                   	nop
        }
    }
}
  1036e0:	83 c4 40             	add    $0x40,%esp
  1036e3:	5b                   	pop    %ebx
  1036e4:	5e                   	pop    %esi
  1036e5:	5d                   	pop    %ebp
  1036e6:	c3                   	ret    

001036e7 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1036e7:	f3 0f 1e fb          	endbr32 
  1036eb:	55                   	push   %ebp
  1036ec:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1036ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036f1:	8b 40 08             	mov    0x8(%eax),%eax
  1036f4:	8d 50 01             	lea    0x1(%eax),%edx
  1036f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036fa:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1036fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  103700:	8b 10                	mov    (%eax),%edx
  103702:	8b 45 0c             	mov    0xc(%ebp),%eax
  103705:	8b 40 04             	mov    0x4(%eax),%eax
  103708:	39 c2                	cmp    %eax,%edx
  10370a:	73 12                	jae    10371e <sprintputch+0x37>
        *b->buf ++ = ch;
  10370c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10370f:	8b 00                	mov    (%eax),%eax
  103711:	8d 48 01             	lea    0x1(%eax),%ecx
  103714:	8b 55 0c             	mov    0xc(%ebp),%edx
  103717:	89 0a                	mov    %ecx,(%edx)
  103719:	8b 55 08             	mov    0x8(%ebp),%edx
  10371c:	88 10                	mov    %dl,(%eax)
    }
}
  10371e:	90                   	nop
  10371f:	5d                   	pop    %ebp
  103720:	c3                   	ret    

00103721 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103721:	f3 0f 1e fb          	endbr32 
  103725:	55                   	push   %ebp
  103726:	89 e5                	mov    %esp,%ebp
  103728:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10372b:	8d 45 14             	lea    0x14(%ebp),%eax
  10372e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103734:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103738:	8b 45 10             	mov    0x10(%ebp),%eax
  10373b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10373f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103742:	89 44 24 04          	mov    %eax,0x4(%esp)
  103746:	8b 45 08             	mov    0x8(%ebp),%eax
  103749:	89 04 24             	mov    %eax,(%esp)
  10374c:	e8 08 00 00 00       	call   103759 <vsnprintf>
  103751:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103754:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103757:	c9                   	leave  
  103758:	c3                   	ret    

00103759 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103759:	f3 0f 1e fb          	endbr32 
  10375d:	55                   	push   %ebp
  10375e:	89 e5                	mov    %esp,%ebp
  103760:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103763:	8b 45 08             	mov    0x8(%ebp),%eax
  103766:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103769:	8b 45 0c             	mov    0xc(%ebp),%eax
  10376c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10376f:	8b 45 08             	mov    0x8(%ebp),%eax
  103772:	01 d0                	add    %edx,%eax
  103774:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103777:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10377e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103782:	74 0a                	je     10378e <vsnprintf+0x35>
  103784:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10378a:	39 c2                	cmp    %eax,%edx
  10378c:	76 07                	jbe    103795 <vsnprintf+0x3c>
        return -E_INVAL;
  10378e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103793:	eb 2a                	jmp    1037bf <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103795:	8b 45 14             	mov    0x14(%ebp),%eax
  103798:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10379c:	8b 45 10             	mov    0x10(%ebp),%eax
  10379f:	89 44 24 08          	mov    %eax,0x8(%esp)
  1037a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1037a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037aa:	c7 04 24 e7 36 10 00 	movl   $0x1036e7,(%esp)
  1037b1:	e8 53 fb ff ff       	call   103309 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1037b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037b9:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1037bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1037bf:	c9                   	leave  
  1037c0:	c3                   	ret    
