
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
# kern_entry函数的主要任务是为执行kern_init建立一个良好的C语言运行环境（设置堆栈），而且临时建立了一个段映射关系，为之后建立分页机制的过程做一个准备
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 10 12 40       	mov    $0x40121000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 10 12 00       	mov    %eax,0x121000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 00 12 00       	mov    $0x120000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	f3 0f 1e fb          	endbr32 
  10003a:	55                   	push   %ebp
  10003b:	89 e5                	mov    %esp,%ebp
  10003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100040:	b8 44 3f 12 00       	mov    $0x123f44,%eax
  100045:	2d 36 0a 12 00       	sub    $0x120a36,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 0a 12 00 	movl   $0x120a36,(%esp)
  10005d:	e8 14 98 00 00       	call   109876 <memset>

    cons_init();                // init the console
  100062:	e8 3a 16 00 00       	call   1016a1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 a0 a0 10 00 	movl   $0x10a0a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 bc a0 10 00 	movl   $0x10a0bc,(%esp)
  10007c:	e8 49 02 00 00       	call   1002ca <cprintf>

    print_kerninfo();
  100081:	e8 07 09 00 00       	call   10098d <print_kerninfo>

    grade_backtrace();
  100086:	e8 9a 00 00 00       	call   100125 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 44 34 00 00       	call   1034d4 <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 87 17 00 00       	call   10181c <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 2c 19 00 00       	call   1019c6 <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 49 0d 00 00       	call   100de8 <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 c4 18 00 00       	call   101968 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  1000a4:	e8 87 01 00 00       	call   100230 <lab1_switch_test>

    /* do nothing */
    while (1);
  1000a9:	eb fe                	jmp    1000a9 <kern_init+0x73>

001000ab <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000ab:	f3 0f 1e fb          	endbr32 
  1000af:	55                   	push   %ebp
  1000b0:	89 e5                	mov    %esp,%ebp
  1000b2:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000bc:	00 
  1000bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000c4:	00 
  1000c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000cc:	e8 01 0d 00 00       	call   100dd2 <mon_backtrace>
}
  1000d1:	90                   	nop
  1000d2:	c9                   	leave  
  1000d3:	c3                   	ret    

001000d4 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000d4:	f3 0f 1e fb          	endbr32 
  1000d8:	55                   	push   %ebp
  1000d9:	89 e5                	mov    %esp,%ebp
  1000db:	53                   	push   %ebx
  1000dc:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000df:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000e5:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ef:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000f7:	89 04 24             	mov    %eax,(%esp)
  1000fa:	e8 ac ff ff ff       	call   1000ab <grade_backtrace2>
}
  1000ff:	90                   	nop
  100100:	83 c4 14             	add    $0x14,%esp
  100103:	5b                   	pop    %ebx
  100104:	5d                   	pop    %ebp
  100105:	c3                   	ret    

00100106 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  100106:	f3 0f 1e fb          	endbr32 
  10010a:	55                   	push   %ebp
  10010b:	89 e5                	mov    %esp,%ebp
  10010d:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  100110:	8b 45 10             	mov    0x10(%ebp),%eax
  100113:	89 44 24 04          	mov    %eax,0x4(%esp)
  100117:	8b 45 08             	mov    0x8(%ebp),%eax
  10011a:	89 04 24             	mov    %eax,(%esp)
  10011d:	e8 b2 ff ff ff       	call   1000d4 <grade_backtrace1>
}
  100122:	90                   	nop
  100123:	c9                   	leave  
  100124:	c3                   	ret    

00100125 <grade_backtrace>:

void
grade_backtrace(void) {
  100125:	f3 0f 1e fb          	endbr32 
  100129:	55                   	push   %ebp
  10012a:	89 e5                	mov    %esp,%ebp
  10012c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10012f:	b8 36 00 10 00       	mov    $0x100036,%eax
  100134:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  10013b:	ff 
  10013c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100147:	e8 ba ff ff ff       	call   100106 <grade_backtrace0>
}
  10014c:	90                   	nop
  10014d:	c9                   	leave  
  10014e:	c3                   	ret    

0010014f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10014f:	f3 0f 1e fb          	endbr32 
  100153:	55                   	push   %ebp
  100154:	89 e5                	mov    %esp,%ebp
  100156:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100159:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10015c:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10015f:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100162:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100165:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100169:	83 e0 03             	and    $0x3,%eax
  10016c:	89 c2                	mov    %eax,%edx
  10016e:	a1 00 30 12 00       	mov    0x123000,%eax
  100173:	89 54 24 08          	mov    %edx,0x8(%esp)
  100177:	89 44 24 04          	mov    %eax,0x4(%esp)
  10017b:	c7 04 24 c1 a0 10 00 	movl   $0x10a0c1,(%esp)
  100182:	e8 43 01 00 00       	call   1002ca <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100187:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10018b:	89 c2                	mov    %eax,%edx
  10018d:	a1 00 30 12 00       	mov    0x123000,%eax
  100192:	89 54 24 08          	mov    %edx,0x8(%esp)
  100196:	89 44 24 04          	mov    %eax,0x4(%esp)
  10019a:	c7 04 24 cf a0 10 00 	movl   $0x10a0cf,(%esp)
  1001a1:	e8 24 01 00 00       	call   1002ca <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  1001a6:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001aa:	89 c2                	mov    %eax,%edx
  1001ac:	a1 00 30 12 00       	mov    0x123000,%eax
  1001b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b9:	c7 04 24 dd a0 10 00 	movl   $0x10a0dd,(%esp)
  1001c0:	e8 05 01 00 00       	call   1002ca <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001c5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001c9:	89 c2                	mov    %eax,%edx
  1001cb:	a1 00 30 12 00       	mov    0x123000,%eax
  1001d0:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d8:	c7 04 24 eb a0 10 00 	movl   $0x10a0eb,(%esp)
  1001df:	e8 e6 00 00 00       	call   1002ca <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001e4:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001e8:	89 c2                	mov    %eax,%edx
  1001ea:	a1 00 30 12 00       	mov    0x123000,%eax
  1001ef:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001f7:	c7 04 24 f9 a0 10 00 	movl   $0x10a0f9,(%esp)
  1001fe:	e8 c7 00 00 00       	call   1002ca <cprintf>
    round ++;
  100203:	a1 00 30 12 00       	mov    0x123000,%eax
  100208:	40                   	inc    %eax
  100209:	a3 00 30 12 00       	mov    %eax,0x123000
}
  10020e:	90                   	nop
  10020f:	c9                   	leave  
  100210:	c3                   	ret    

00100211 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  100211:	f3 0f 1e fb          	endbr32 
  100215:	55                   	push   %ebp
  100216:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
  100218:	83 ec 08             	sub    $0x8,%esp
  10021b:	cd 78                	int    $0x78
  10021d:	89 ec                	mov    %ebp,%esp
        "int %0 \n"                 // int 指令将 eflag、cs、eip 压栈
        "movl %%ebp, %%esp"
        :
        : "i"(T_SWITCH_TOU)
    );
}
  10021f:	90                   	nop
  100220:	5d                   	pop    %ebp
  100221:	c3                   	ret    

00100222 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100222:	f3 0f 1e fb          	endbr32 
  100226:	55                   	push   %ebp
  100227:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  100229:	cd 79                	int    $0x79
  10022b:	89 ec                	mov    %ebp,%esp
        "int %0 \n"
        "movl %%ebp, %%esp \n"
        :
        : "i"(T_SWITCH_TOK)
    );
}
  10022d:	90                   	nop
  10022e:	5d                   	pop    %ebp
  10022f:	c3                   	ret    

00100230 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100230:	f3 0f 1e fb          	endbr32 
  100234:	55                   	push   %ebp
  100235:	89 e5                	mov    %esp,%ebp
  100237:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10023a:	e8 10 ff ff ff       	call   10014f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10023f:	c7 04 24 08 a1 10 00 	movl   $0x10a108,(%esp)
  100246:	e8 7f 00 00 00       	call   1002ca <cprintf>
    lab1_switch_to_user();
  10024b:	e8 c1 ff ff ff       	call   100211 <lab1_switch_to_user>
    lab1_print_cur_status();
  100250:	e8 fa fe ff ff       	call   10014f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100255:	c7 04 24 28 a1 10 00 	movl   $0x10a128,(%esp)
  10025c:	e8 69 00 00 00       	call   1002ca <cprintf>
    lab1_switch_to_kernel();
  100261:	e8 bc ff ff ff       	call   100222 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100266:	e8 e4 fe ff ff       	call   10014f <lab1_print_cur_status>
}
  10026b:	90                   	nop
  10026c:	c9                   	leave  
  10026d:	c3                   	ret    

0010026e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10026e:	f3 0f 1e fb          	endbr32 
  100272:	55                   	push   %ebp
  100273:	89 e5                	mov    %esp,%ebp
  100275:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100278:	8b 45 08             	mov    0x8(%ebp),%eax
  10027b:	89 04 24             	mov    %eax,(%esp)
  10027e:	e8 4f 14 00 00       	call   1016d2 <cons_putc>
    (*cnt) ++;
  100283:	8b 45 0c             	mov    0xc(%ebp),%eax
  100286:	8b 00                	mov    (%eax),%eax
  100288:	8d 50 01             	lea    0x1(%eax),%edx
  10028b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10028e:	89 10                	mov    %edx,(%eax)
}
  100290:	90                   	nop
  100291:	c9                   	leave  
  100292:	c3                   	ret    

00100293 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100293:	f3 0f 1e fb          	endbr32 
  100297:	55                   	push   %ebp
  100298:	89 e5                	mov    %esp,%ebp
  10029a:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10029d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002b9:	c7 04 24 6e 02 10 00 	movl   $0x10026e,(%esp)
  1002c0:	e8 1d 99 00 00       	call   109be2 <vprintfmt>
    return cnt;
  1002c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002c8:	c9                   	leave  
  1002c9:	c3                   	ret    

001002ca <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002ca:	f3 0f 1e fb          	endbr32 
  1002ce:	55                   	push   %ebp
  1002cf:	89 e5                	mov    %esp,%ebp
  1002d1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002d4:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1002e4:	89 04 24             	mov    %eax,(%esp)
  1002e7:	e8 a7 ff ff ff       	call   100293 <vcprintf>
  1002ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002f2:	c9                   	leave  
  1002f3:	c3                   	ret    

001002f4 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002f4:	f3 0f 1e fb          	endbr32 
  1002f8:	55                   	push   %ebp
  1002f9:	89 e5                	mov    %esp,%ebp
  1002fb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002fe:	8b 45 08             	mov    0x8(%ebp),%eax
  100301:	89 04 24             	mov    %eax,(%esp)
  100304:	e8 c9 13 00 00       	call   1016d2 <cons_putc>
}
  100309:	90                   	nop
  10030a:	c9                   	leave  
  10030b:	c3                   	ret    

0010030c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10030c:	f3 0f 1e fb          	endbr32 
  100310:	55                   	push   %ebp
  100311:	89 e5                	mov    %esp,%ebp
  100313:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100316:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10031d:	eb 13                	jmp    100332 <cputs+0x26>
        cputch(c, &cnt);
  10031f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100323:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100326:	89 54 24 04          	mov    %edx,0x4(%esp)
  10032a:	89 04 24             	mov    %eax,(%esp)
  10032d:	e8 3c ff ff ff       	call   10026e <cputch>
    while ((c = *str ++) != '\0') {
  100332:	8b 45 08             	mov    0x8(%ebp),%eax
  100335:	8d 50 01             	lea    0x1(%eax),%edx
  100338:	89 55 08             	mov    %edx,0x8(%ebp)
  10033b:	0f b6 00             	movzbl (%eax),%eax
  10033e:	88 45 f7             	mov    %al,-0x9(%ebp)
  100341:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100345:	75 d8                	jne    10031f <cputs+0x13>
    }
    cputch('\n', &cnt);
  100347:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10034a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100355:	e8 14 ff ff ff       	call   10026e <cputch>
    return cnt;
  10035a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10035d:	c9                   	leave  
  10035e:	c3                   	ret    

0010035f <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10035f:	f3 0f 1e fb          	endbr32 
  100363:	55                   	push   %ebp
  100364:	89 e5                	mov    %esp,%ebp
  100366:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100369:	90                   	nop
  10036a:	e8 a4 13 00 00       	call   101713 <cons_getc>
  10036f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100376:	74 f2                	je     10036a <getchar+0xb>
        /* do nothing */;
    return c;
  100378:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10037b:	c9                   	leave  
  10037c:	c3                   	ret    

0010037d <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10037d:	f3 0f 1e fb          	endbr32 
  100381:	55                   	push   %ebp
  100382:	89 e5                	mov    %esp,%ebp
  100384:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100387:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10038b:	74 13                	je     1003a0 <readline+0x23>
        cprintf("%s", prompt);
  10038d:	8b 45 08             	mov    0x8(%ebp),%eax
  100390:	89 44 24 04          	mov    %eax,0x4(%esp)
  100394:	c7 04 24 47 a1 10 00 	movl   $0x10a147,(%esp)
  10039b:	e8 2a ff ff ff       	call   1002ca <cprintf>
    }
    int i = 0, c;
  1003a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  1003a7:	e8 b3 ff ff ff       	call   10035f <getchar>
  1003ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  1003af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1003b3:	79 07                	jns    1003bc <readline+0x3f>
            return NULL;
  1003b5:	b8 00 00 00 00       	mov    $0x0,%eax
  1003ba:	eb 78                	jmp    100434 <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  1003bc:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  1003c0:	7e 28                	jle    1003ea <readline+0x6d>
  1003c2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  1003c9:	7f 1f                	jg     1003ea <readline+0x6d>
            cputchar(c);
  1003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003ce:	89 04 24             	mov    %eax,(%esp)
  1003d1:	e8 1e ff ff ff       	call   1002f4 <cputchar>
            buf[i ++] = c;
  1003d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003d9:	8d 50 01             	lea    0x1(%eax),%edx
  1003dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003e2:	88 90 20 30 12 00    	mov    %dl,0x123020(%eax)
  1003e8:	eb 45                	jmp    10042f <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003ea:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003ee:	75 16                	jne    100406 <readline+0x89>
  1003f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003f4:	7e 10                	jle    100406 <readline+0x89>
            cputchar(c);
  1003f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f9:	89 04 24             	mov    %eax,(%esp)
  1003fc:	e8 f3 fe ff ff       	call   1002f4 <cputchar>
            i --;
  100401:	ff 4d f4             	decl   -0xc(%ebp)
  100404:	eb 29                	jmp    10042f <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  100406:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10040a:	74 06                	je     100412 <readline+0x95>
  10040c:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100410:	75 95                	jne    1003a7 <readline+0x2a>
            cputchar(c);
  100412:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100415:	89 04 24             	mov    %eax,(%esp)
  100418:	e8 d7 fe ff ff       	call   1002f4 <cputchar>
            buf[i] = '\0';
  10041d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100420:	05 20 30 12 00       	add    $0x123020,%eax
  100425:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100428:	b8 20 30 12 00       	mov    $0x123020,%eax
  10042d:	eb 05                	jmp    100434 <readline+0xb7>
        c = getchar();
  10042f:	e9 73 ff ff ff       	jmp    1003a7 <readline+0x2a>
        }
    }
}
  100434:	c9                   	leave  
  100435:	c3                   	ret    

00100436 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100436:	f3 0f 1e fb          	endbr32 
  10043a:	55                   	push   %ebp
  10043b:	89 e5                	mov    %esp,%ebp
  10043d:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100440:	a1 20 34 12 00       	mov    0x123420,%eax
  100445:	85 c0                	test   %eax,%eax
  100447:	75 5b                	jne    1004a4 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100449:	c7 05 20 34 12 00 01 	movl   $0x1,0x123420
  100450:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100453:	8d 45 14             	lea    0x14(%ebp),%eax
  100456:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100459:	8b 45 0c             	mov    0xc(%ebp),%eax
  10045c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100460:	8b 45 08             	mov    0x8(%ebp),%eax
  100463:	89 44 24 04          	mov    %eax,0x4(%esp)
  100467:	c7 04 24 4a a1 10 00 	movl   $0x10a14a,(%esp)
  10046e:	e8 57 fe ff ff       	call   1002ca <cprintf>
    vcprintf(fmt, ap);
  100473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100476:	89 44 24 04          	mov    %eax,0x4(%esp)
  10047a:	8b 45 10             	mov    0x10(%ebp),%eax
  10047d:	89 04 24             	mov    %eax,(%esp)
  100480:	e8 0e fe ff ff       	call   100293 <vcprintf>
    cprintf("\n");
  100485:	c7 04 24 66 a1 10 00 	movl   $0x10a166,(%esp)
  10048c:	e8 39 fe ff ff       	call   1002ca <cprintf>
    
    cprintf("stack trackback:\n");
  100491:	c7 04 24 68 a1 10 00 	movl   $0x10a168,(%esp)
  100498:	e8 2d fe ff ff       	call   1002ca <cprintf>
    print_stackframe();
  10049d:	e8 3d 06 00 00       	call   100adf <print_stackframe>
  1004a2:	eb 01                	jmp    1004a5 <__panic+0x6f>
        goto panic_dead;
  1004a4:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  1004a5:	e8 ca 14 00 00       	call   101974 <intr_disable>
    while (1) {
        kmonitor(NULL);
  1004aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1004b1:	e8 43 08 00 00       	call   100cf9 <kmonitor>
  1004b6:	eb f2                	jmp    1004aa <__panic+0x74>

001004b8 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  1004b8:	f3 0f 1e fb          	endbr32 
  1004bc:	55                   	push   %ebp
  1004bd:	89 e5                	mov    %esp,%ebp
  1004bf:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  1004c2:	8d 45 14             	lea    0x14(%ebp),%eax
  1004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  1004c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1004d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004d6:	c7 04 24 7a a1 10 00 	movl   $0x10a17a,(%esp)
  1004dd:	e8 e8 fd ff ff       	call   1002ca <cprintf>
    vcprintf(fmt, ap);
  1004e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004e9:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ec:	89 04 24             	mov    %eax,(%esp)
  1004ef:	e8 9f fd ff ff       	call   100293 <vcprintf>
    cprintf("\n");
  1004f4:	c7 04 24 66 a1 10 00 	movl   $0x10a166,(%esp)
  1004fb:	e8 ca fd ff ff       	call   1002ca <cprintf>
    va_end(ap);
}
  100500:	90                   	nop
  100501:	c9                   	leave  
  100502:	c3                   	ret    

00100503 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100503:	f3 0f 1e fb          	endbr32 
  100507:	55                   	push   %ebp
  100508:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10050a:	a1 20 34 12 00       	mov    0x123420,%eax
}
  10050f:	5d                   	pop    %ebp
  100510:	c3                   	ret    

00100511 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100511:	f3 0f 1e fb          	endbr32 
  100515:	55                   	push   %ebp
  100516:	89 e5                	mov    %esp,%ebp
  100518:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  10051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051e:	8b 00                	mov    (%eax),%eax
  100520:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100523:	8b 45 10             	mov    0x10(%ebp),%eax
  100526:	8b 00                	mov    (%eax),%eax
  100528:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10052b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100532:	e9 ca 00 00 00       	jmp    100601 <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100537:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10053a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10053d:	01 d0                	add    %edx,%eax
  10053f:	89 c2                	mov    %eax,%edx
  100541:	c1 ea 1f             	shr    $0x1f,%edx
  100544:	01 d0                	add    %edx,%eax
  100546:	d1 f8                	sar    %eax
  100548:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10054b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10054e:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100551:	eb 03                	jmp    100556 <stab_binsearch+0x45>
            m --;
  100553:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100559:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10055c:	7c 1f                	jl     10057d <stab_binsearch+0x6c>
  10055e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100561:	89 d0                	mov    %edx,%eax
  100563:	01 c0                	add    %eax,%eax
  100565:	01 d0                	add    %edx,%eax
  100567:	c1 e0 02             	shl    $0x2,%eax
  10056a:	89 c2                	mov    %eax,%edx
  10056c:	8b 45 08             	mov    0x8(%ebp),%eax
  10056f:	01 d0                	add    %edx,%eax
  100571:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100575:	0f b6 c0             	movzbl %al,%eax
  100578:	39 45 14             	cmp    %eax,0x14(%ebp)
  10057b:	75 d6                	jne    100553 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  10057d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100580:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100583:	7d 09                	jge    10058e <stab_binsearch+0x7d>
            l = true_m + 1;
  100585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100588:	40                   	inc    %eax
  100589:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10058c:	eb 73                	jmp    100601 <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  10058e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100595:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100598:	89 d0                	mov    %edx,%eax
  10059a:	01 c0                	add    %eax,%eax
  10059c:	01 d0                	add    %edx,%eax
  10059e:	c1 e0 02             	shl    $0x2,%eax
  1005a1:	89 c2                	mov    %eax,%edx
  1005a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a6:	01 d0                	add    %edx,%eax
  1005a8:	8b 40 08             	mov    0x8(%eax),%eax
  1005ab:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005ae:	76 11                	jbe    1005c1 <stab_binsearch+0xb0>
            *region_left = m;
  1005b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b6:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1005b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1005bb:	40                   	inc    %eax
  1005bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1005bf:	eb 40                	jmp    100601 <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  1005c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c4:	89 d0                	mov    %edx,%eax
  1005c6:	01 c0                	add    %eax,%eax
  1005c8:	01 d0                	add    %edx,%eax
  1005ca:	c1 e0 02             	shl    $0x2,%eax
  1005cd:	89 c2                	mov    %eax,%edx
  1005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d2:	01 d0                	add    %edx,%eax
  1005d4:	8b 40 08             	mov    0x8(%eax),%eax
  1005d7:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005da:	73 14                	jae    1005f0 <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005df:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005e2:	8b 45 10             	mov    0x10(%ebp),%eax
  1005e5:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005ea:	48                   	dec    %eax
  1005eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005ee:	eb 11                	jmp    100601 <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005f6:	89 10                	mov    %edx,(%eax)
            l = m;
  1005f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005fe:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  100601:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100604:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100607:	0f 8e 2a ff ff ff    	jle    100537 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  10060d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100611:	75 0f                	jne    100622 <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  100613:	8b 45 0c             	mov    0xc(%ebp),%eax
  100616:	8b 00                	mov    (%eax),%eax
  100618:	8d 50 ff             	lea    -0x1(%eax),%edx
  10061b:	8b 45 10             	mov    0x10(%ebp),%eax
  10061e:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100620:	eb 3e                	jmp    100660 <stab_binsearch+0x14f>
        l = *region_right;
  100622:	8b 45 10             	mov    0x10(%ebp),%eax
  100625:	8b 00                	mov    (%eax),%eax
  100627:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10062a:	eb 03                	jmp    10062f <stab_binsearch+0x11e>
  10062c:	ff 4d fc             	decl   -0x4(%ebp)
  10062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100632:	8b 00                	mov    (%eax),%eax
  100634:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100637:	7e 1f                	jle    100658 <stab_binsearch+0x147>
  100639:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10063c:	89 d0                	mov    %edx,%eax
  10063e:	01 c0                	add    %eax,%eax
  100640:	01 d0                	add    %edx,%eax
  100642:	c1 e0 02             	shl    $0x2,%eax
  100645:	89 c2                	mov    %eax,%edx
  100647:	8b 45 08             	mov    0x8(%ebp),%eax
  10064a:	01 d0                	add    %edx,%eax
  10064c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100650:	0f b6 c0             	movzbl %al,%eax
  100653:	39 45 14             	cmp    %eax,0x14(%ebp)
  100656:	75 d4                	jne    10062c <stab_binsearch+0x11b>
        *region_left = l;
  100658:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10065e:	89 10                	mov    %edx,(%eax)
}
  100660:	90                   	nop
  100661:	c9                   	leave  
  100662:	c3                   	ret    

00100663 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100663:	f3 0f 1e fb          	endbr32 
  100667:	55                   	push   %ebp
  100668:	89 e5                	mov    %esp,%ebp
  10066a:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10066d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100670:	c7 00 98 a1 10 00    	movl   $0x10a198,(%eax)
    info->eip_line = 0;
  100676:	8b 45 0c             	mov    0xc(%ebp),%eax
  100679:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	c7 40 08 98 a1 10 00 	movl   $0x10a198,0x8(%eax)
    info->eip_fn_namelen = 9;
  10068a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10068d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100694:	8b 45 0c             	mov    0xc(%ebp),%eax
  100697:	8b 55 08             	mov    0x8(%ebp),%edx
  10069a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10069d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  1006a7:	c7 45 f4 90 b8 10 00 	movl   $0x10b890,-0xc(%ebp)
    stab_end = __STAB_END__;
  1006ae:	c7 45 f0 90 a5 11 00 	movl   $0x11a590,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1006b5:	c7 45 ec 91 a5 11 00 	movl   $0x11a591,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1006bc:	c7 45 e8 ca d3 11 00 	movl   $0x11d3ca,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1006c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006c6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1006c9:	76 0b                	jbe    1006d6 <debuginfo_eip+0x73>
  1006cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006ce:	48                   	dec    %eax
  1006cf:	0f b6 00             	movzbl (%eax),%eax
  1006d2:	84 c0                	test   %al,%al
  1006d4:	74 0a                	je     1006e0 <debuginfo_eip+0x7d>
        return -1;
  1006d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006db:	e9 ab 02 00 00       	jmp    10098b <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006ea:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006ed:	c1 f8 02             	sar    $0x2,%eax
  1006f0:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006f6:	48                   	dec    %eax
  1006f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1006fd:	89 44 24 10          	mov    %eax,0x10(%esp)
  100701:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100708:	00 
  100709:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10070c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100710:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100713:	89 44 24 04          	mov    %eax,0x4(%esp)
  100717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071a:	89 04 24             	mov    %eax,(%esp)
  10071d:	e8 ef fd ff ff       	call   100511 <stab_binsearch>
    if (lfile == 0)
  100722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100725:	85 c0                	test   %eax,%eax
  100727:	75 0a                	jne    100733 <debuginfo_eip+0xd0>
        return -1;
  100729:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072e:	e9 58 02 00 00       	jmp    10098b <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100736:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100739:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10073c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10073f:	8b 45 08             	mov    0x8(%ebp),%eax
  100742:	89 44 24 10          	mov    %eax,0x10(%esp)
  100746:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10074d:	00 
  10074e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100751:	89 44 24 08          	mov    %eax,0x8(%esp)
  100755:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100758:	89 44 24 04          	mov    %eax,0x4(%esp)
  10075c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075f:	89 04 24             	mov    %eax,(%esp)
  100762:	e8 aa fd ff ff       	call   100511 <stab_binsearch>

    if (lfun <= rfun) {
  100767:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10076a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10076d:	39 c2                	cmp    %eax,%edx
  10076f:	7f 78                	jg     1007e9 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100771:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100774:	89 c2                	mov    %eax,%edx
  100776:	89 d0                	mov    %edx,%eax
  100778:	01 c0                	add    %eax,%eax
  10077a:	01 d0                	add    %edx,%eax
  10077c:	c1 e0 02             	shl    $0x2,%eax
  10077f:	89 c2                	mov    %eax,%edx
  100781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100784:	01 d0                	add    %edx,%eax
  100786:	8b 10                	mov    (%eax),%edx
  100788:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10078b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10078e:	39 c2                	cmp    %eax,%edx
  100790:	73 22                	jae    1007b4 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100792:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100795:	89 c2                	mov    %eax,%edx
  100797:	89 d0                	mov    %edx,%eax
  100799:	01 c0                	add    %eax,%eax
  10079b:	01 d0                	add    %edx,%eax
  10079d:	c1 e0 02             	shl    $0x2,%eax
  1007a0:	89 c2                	mov    %eax,%edx
  1007a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a5:	01 d0                	add    %edx,%eax
  1007a7:	8b 10                	mov    (%eax),%edx
  1007a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ac:	01 c2                	add    %eax,%edx
  1007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b1:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1007b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	89 d0                	mov    %edx,%eax
  1007bb:	01 c0                	add    %eax,%eax
  1007bd:	01 d0                	add    %edx,%eax
  1007bf:	c1 e0 02             	shl    $0x2,%eax
  1007c2:	89 c2                	mov    %eax,%edx
  1007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c7:	01 d0                	add    %edx,%eax
  1007c9:	8b 50 08             	mov    0x8(%eax),%edx
  1007cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007cf:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1007d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007d5:	8b 40 10             	mov    0x10(%eax),%eax
  1007d8:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007de:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007e7:	eb 15                	jmp    1007fe <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ec:	8b 55 08             	mov    0x8(%ebp),%edx
  1007ef:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  100801:	8b 40 08             	mov    0x8(%eax),%eax
  100804:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  10080b:	00 
  10080c:	89 04 24             	mov    %eax,(%esp)
  10080f:	e8 d6 8e 00 00       	call   1096ea <strfind>
  100814:	8b 55 0c             	mov    0xc(%ebp),%edx
  100817:	8b 52 08             	mov    0x8(%edx),%edx
  10081a:	29 d0                	sub    %edx,%eax
  10081c:	89 c2                	mov    %eax,%edx
  10081e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100821:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100824:	8b 45 08             	mov    0x8(%ebp),%eax
  100827:	89 44 24 10          	mov    %eax,0x10(%esp)
  10082b:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100832:	00 
  100833:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100836:	89 44 24 08          	mov    %eax,0x8(%esp)
  10083a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10083d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100844:	89 04 24             	mov    %eax,(%esp)
  100847:	e8 c5 fc ff ff       	call   100511 <stab_binsearch>
    if (lline <= rline) {
  10084c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10084f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100852:	39 c2                	cmp    %eax,%edx
  100854:	7f 23                	jg     100879 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100856:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100859:	89 c2                	mov    %eax,%edx
  10085b:	89 d0                	mov    %edx,%eax
  10085d:	01 c0                	add    %eax,%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	c1 e0 02             	shl    $0x2,%eax
  100864:	89 c2                	mov    %eax,%edx
  100866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100869:	01 d0                	add    %edx,%eax
  10086b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10086f:	89 c2                	mov    %eax,%edx
  100871:	8b 45 0c             	mov    0xc(%ebp),%eax
  100874:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100877:	eb 11                	jmp    10088a <debuginfo_eip+0x227>
        return -1;
  100879:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10087e:	e9 08 01 00 00       	jmp    10098b <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100883:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100886:	48                   	dec    %eax
  100887:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10088a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10088d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100890:	39 c2                	cmp    %eax,%edx
  100892:	7c 56                	jl     1008ea <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  100894:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100897:	89 c2                	mov    %eax,%edx
  100899:	89 d0                	mov    %edx,%eax
  10089b:	01 c0                	add    %eax,%eax
  10089d:	01 d0                	add    %edx,%eax
  10089f:	c1 e0 02             	shl    $0x2,%eax
  1008a2:	89 c2                	mov    %eax,%edx
  1008a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a7:	01 d0                	add    %edx,%eax
  1008a9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008ad:	3c 84                	cmp    $0x84,%al
  1008af:	74 39                	je     1008ea <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1008b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b4:	89 c2                	mov    %eax,%edx
  1008b6:	89 d0                	mov    %edx,%eax
  1008b8:	01 c0                	add    %eax,%eax
  1008ba:	01 d0                	add    %edx,%eax
  1008bc:	c1 e0 02             	shl    $0x2,%eax
  1008bf:	89 c2                	mov    %eax,%edx
  1008c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c4:	01 d0                	add    %edx,%eax
  1008c6:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008ca:	3c 64                	cmp    $0x64,%al
  1008cc:	75 b5                	jne    100883 <debuginfo_eip+0x220>
  1008ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d1:	89 c2                	mov    %eax,%edx
  1008d3:	89 d0                	mov    %edx,%eax
  1008d5:	01 c0                	add    %eax,%eax
  1008d7:	01 d0                	add    %edx,%eax
  1008d9:	c1 e0 02             	shl    $0x2,%eax
  1008dc:	89 c2                	mov    %eax,%edx
  1008de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e1:	01 d0                	add    %edx,%eax
  1008e3:	8b 40 08             	mov    0x8(%eax),%eax
  1008e6:	85 c0                	test   %eax,%eax
  1008e8:	74 99                	je     100883 <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008f0:	39 c2                	cmp    %eax,%edx
  1008f2:	7c 42                	jl     100936 <debuginfo_eip+0x2d3>
  1008f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f7:	89 c2                	mov    %eax,%edx
  1008f9:	89 d0                	mov    %edx,%eax
  1008fb:	01 c0                	add    %eax,%eax
  1008fd:	01 d0                	add    %edx,%eax
  1008ff:	c1 e0 02             	shl    $0x2,%eax
  100902:	89 c2                	mov    %eax,%edx
  100904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100907:	01 d0                	add    %edx,%eax
  100909:	8b 10                	mov    (%eax),%edx
  10090b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10090e:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100911:	39 c2                	cmp    %eax,%edx
  100913:	73 21                	jae    100936 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100915:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100918:	89 c2                	mov    %eax,%edx
  10091a:	89 d0                	mov    %edx,%eax
  10091c:	01 c0                	add    %eax,%eax
  10091e:	01 d0                	add    %edx,%eax
  100920:	c1 e0 02             	shl    $0x2,%eax
  100923:	89 c2                	mov    %eax,%edx
  100925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100928:	01 d0                	add    %edx,%eax
  10092a:	8b 10                	mov    (%eax),%edx
  10092c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10092f:	01 c2                	add    %eax,%edx
  100931:	8b 45 0c             	mov    0xc(%ebp),%eax
  100934:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100936:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100939:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10093c:	39 c2                	cmp    %eax,%edx
  10093e:	7d 46                	jge    100986 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  100940:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100943:	40                   	inc    %eax
  100944:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100947:	eb 16                	jmp    10095f <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100949:	8b 45 0c             	mov    0xc(%ebp),%eax
  10094c:	8b 40 14             	mov    0x14(%eax),%eax
  10094f:	8d 50 01             	lea    0x1(%eax),%edx
  100952:	8b 45 0c             	mov    0xc(%ebp),%eax
  100955:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100958:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10095b:	40                   	inc    %eax
  10095c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10095f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100962:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100965:	39 c2                	cmp    %eax,%edx
  100967:	7d 1d                	jge    100986 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100969:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10096c:	89 c2                	mov    %eax,%edx
  10096e:	89 d0                	mov    %edx,%eax
  100970:	01 c0                	add    %eax,%eax
  100972:	01 d0                	add    %edx,%eax
  100974:	c1 e0 02             	shl    $0x2,%eax
  100977:	89 c2                	mov    %eax,%edx
  100979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10097c:	01 d0                	add    %edx,%eax
  10097e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100982:	3c a0                	cmp    $0xa0,%al
  100984:	74 c3                	je     100949 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100986:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10098b:	c9                   	leave  
  10098c:	c3                   	ret    

0010098d <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10098d:	f3 0f 1e fb          	endbr32 
  100991:	55                   	push   %ebp
  100992:	89 e5                	mov    %esp,%ebp
  100994:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100997:	c7 04 24 a2 a1 10 00 	movl   $0x10a1a2,(%esp)
  10099e:	e8 27 f9 ff ff       	call   1002ca <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1009a3:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  1009aa:	00 
  1009ab:	c7 04 24 bb a1 10 00 	movl   $0x10a1bb,(%esp)
  1009b2:	e8 13 f9 ff ff       	call   1002ca <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1009b7:	c7 44 24 04 9a a0 10 	movl   $0x10a09a,0x4(%esp)
  1009be:	00 
  1009bf:	c7 04 24 d3 a1 10 00 	movl   $0x10a1d3,(%esp)
  1009c6:	e8 ff f8 ff ff       	call   1002ca <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1009cb:	c7 44 24 04 36 0a 12 	movl   $0x120a36,0x4(%esp)
  1009d2:	00 
  1009d3:	c7 04 24 eb a1 10 00 	movl   $0x10a1eb,(%esp)
  1009da:	e8 eb f8 ff ff       	call   1002ca <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009df:	c7 44 24 04 44 3f 12 	movl   $0x123f44,0x4(%esp)
  1009e6:	00 
  1009e7:	c7 04 24 03 a2 10 00 	movl   $0x10a203,(%esp)
  1009ee:	e8 d7 f8 ff ff       	call   1002ca <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009f3:	b8 44 3f 12 00       	mov    $0x123f44,%eax
  1009f8:	2d 36 00 10 00       	sub    $0x100036,%eax
  1009fd:	05 ff 03 00 00       	add    $0x3ff,%eax
  100a02:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100a08:	85 c0                	test   %eax,%eax
  100a0a:	0f 48 c2             	cmovs  %edx,%eax
  100a0d:	c1 f8 0a             	sar    $0xa,%eax
  100a10:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a14:	c7 04 24 1c a2 10 00 	movl   $0x10a21c,(%esp)
  100a1b:	e8 aa f8 ff ff       	call   1002ca <cprintf>
}
  100a20:	90                   	nop
  100a21:	c9                   	leave  
  100a22:	c3                   	ret    

00100a23 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100a23:	f3 0f 1e fb          	endbr32 
  100a27:	55                   	push   %ebp
  100a28:	89 e5                	mov    %esp,%ebp
  100a2a:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100a30:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a37:	8b 45 08             	mov    0x8(%ebp),%eax
  100a3a:	89 04 24             	mov    %eax,(%esp)
  100a3d:	e8 21 fc ff ff       	call   100663 <debuginfo_eip>
  100a42:	85 c0                	test   %eax,%eax
  100a44:	74 15                	je     100a5b <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a46:	8b 45 08             	mov    0x8(%ebp),%eax
  100a49:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a4d:	c7 04 24 46 a2 10 00 	movl   $0x10a246,(%esp)
  100a54:	e8 71 f8 ff ff       	call   1002ca <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a59:	eb 6c                	jmp    100ac7 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a62:	eb 1b                	jmp    100a7f <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a6a:	01 d0                	add    %edx,%eax
  100a6c:	0f b6 10             	movzbl (%eax),%edx
  100a6f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a78:	01 c8                	add    %ecx,%eax
  100a7a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a7c:	ff 45 f4             	incl   -0xc(%ebp)
  100a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a82:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a85:	7c dd                	jl     100a64 <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a87:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a90:	01 d0                	add    %edx,%eax
  100a92:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a95:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a98:	8b 55 08             	mov    0x8(%ebp),%edx
  100a9b:	89 d1                	mov    %edx,%ecx
  100a9d:	29 c1                	sub    %eax,%ecx
  100a9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100aa2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100aa5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100aa9:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100aaf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100ab3:	89 54 24 08          	mov    %edx,0x8(%esp)
  100ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100abb:	c7 04 24 62 a2 10 00 	movl   $0x10a262,(%esp)
  100ac2:	e8 03 f8 ff ff       	call   1002ca <cprintf>
}
  100ac7:	90                   	nop
  100ac8:	c9                   	leave  
  100ac9:	c3                   	ret    

00100aca <read_eip>:

// read_eip必须定义为常规函数而不是inline函数，因为这样的话在调用read_eip时会把当前指令的下一条指令的地址（也就是eip寄存器的值）压栈，
// 那么在进入read_eip函数内部后便可以从栈中获取到调用前eip寄存器的值。
static __noinline uint32_t
read_eip(void) {
  100aca:	f3 0f 1e fb          	endbr32 
  100ace:	55                   	push   %ebp
  100acf:	89 e5                	mov    %esp,%ebp
  100ad1:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100ad4:	8b 45 04             	mov    0x4(%ebp),%eax
  100ad7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100ada:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100add:	c9                   	leave  
  100ade:	c3                   	ret    

00100adf <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100adf:	f3 0f 1e fb          	endbr32 
  100ae3:	55                   	push   %ebp
  100ae4:	89 e5                	mov    %esp,%ebp
  100ae6:	53                   	push   %ebx
  100ae7:	83 ec 34             	sub    $0x34,%esp

// read_ebp必须定义为inline函数，否则获取的是执行read_ebp函数时的ebp寄存器的值
static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100aea:	89 e8                	mov    %ebp,%eax
  100aec:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
  100aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uint32_t ebp = read_ebp(), eip = read_eip();//对应(1)、(2)
  100af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100af5:	e8 d0 ff ff ff       	call   100aca <read_eip>
  100afa:	89 45 f0             	mov    %eax,-0x10(%ebp)
     int i;
     for (i = 0; i < STACKFRAME_DEPTH && ebp; i++)
  100afd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100b04:	eb 6c                	jmp    100b72 <print_stackframe+0x93>
     {
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip, ((uint32_t*)ebp + 2)[0], ((uint32_t*)ebp + 2)[1], ((uint32_t*)ebp + 2)[2], ((uint32_t*)ebp + 2)[3]); //对应(3.1)、(3.2)、(3.3)
  100b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b09:	83 c0 14             	add    $0x14,%eax
  100b0c:	8b 18                	mov    (%eax),%ebx
  100b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b11:	83 c0 10             	add    $0x10,%eax
  100b14:	8b 08                	mov    (%eax),%ecx
  100b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b19:	83 c0 0c             	add    $0xc,%eax
  100b1c:	8b 10                	mov    (%eax),%edx
  100b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b21:	83 c0 08             	add    $0x8,%eax
  100b24:	8b 00                	mov    (%eax),%eax
  100b26:	89 5c 24 18          	mov    %ebx,0x18(%esp)
  100b2a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  100b2e:	89 54 24 10          	mov    %edx,0x10(%esp)
  100b32:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b39:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b44:	c7 04 24 74 a2 10 00 	movl   $0x10a274,(%esp)
  100b4b:	e8 7a f7 ff ff       	call   1002ca <cprintf>
        print_debuginfo(eip - 1); //对应(3.4)，由于变量eip存放的是下一条指令的地址，因此将变量eip的值减去1，得到的指令地址就属于当前指令的范围了。由于只要输入的地址属于当前指令的起始和结束位置之间，print_debuginfo都能搜索到当前指令，因此这里减去1即可。
  100b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b53:	48                   	dec    %eax
  100b54:	89 04 24             	mov    %eax,(%esp)
  100b57:	e8 c7 fe ff ff       	call   100a23 <print_debuginfo>
        eip = *(uint32_t*)(ebp + 4), ebp = *(uint32_t*)ebp; //对应(3.5)，这里默认ss基址为0
  100b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b5f:	83 c0 04             	add    $0x4,%eax
  100b62:	8b 00                	mov    (%eax),%eax
  100b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  100b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b6a:	8b 00                	mov    (%eax),%eax
  100b6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
     for (i = 0; i < STACKFRAME_DEPTH && ebp; i++)
  100b6f:	ff 45 ec             	incl   -0x14(%ebp)
  100b72:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b76:	7f 06                	jg     100b7e <print_stackframe+0x9f>
  100b78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b7c:	75 88                	jne    100b06 <print_stackframe+0x27>
     }
}
  100b7e:	90                   	nop
  100b7f:	83 c4 34             	add    $0x34,%esp
  100b82:	5b                   	pop    %ebx
  100b83:	5d                   	pop    %ebp
  100b84:	c3                   	ret    

00100b85 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b85:	f3 0f 1e fb          	endbr32 
  100b89:	55                   	push   %ebp
  100b8a:	89 e5                	mov    %esp,%ebp
  100b8c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b96:	eb 0c                	jmp    100ba4 <parse+0x1f>
            *buf ++ = '\0';
  100b98:	8b 45 08             	mov    0x8(%ebp),%eax
  100b9b:	8d 50 01             	lea    0x1(%eax),%edx
  100b9e:	89 55 08             	mov    %edx,0x8(%ebp)
  100ba1:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba7:	0f b6 00             	movzbl (%eax),%eax
  100baa:	84 c0                	test   %al,%al
  100bac:	74 1d                	je     100bcb <parse+0x46>
  100bae:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb1:	0f b6 00             	movzbl (%eax),%eax
  100bb4:	0f be c0             	movsbl %al,%eax
  100bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bbb:	c7 04 24 2c a3 10 00 	movl   $0x10a32c,(%esp)
  100bc2:	e8 ed 8a 00 00       	call   1096b4 <strchr>
  100bc7:	85 c0                	test   %eax,%eax
  100bc9:	75 cd                	jne    100b98 <parse+0x13>
        }
        if (*buf == '\0') {
  100bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  100bce:	0f b6 00             	movzbl (%eax),%eax
  100bd1:	84 c0                	test   %al,%al
  100bd3:	74 65                	je     100c3a <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100bd5:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bd9:	75 14                	jne    100bef <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bdb:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100be2:	00 
  100be3:	c7 04 24 31 a3 10 00 	movl   $0x10a331,(%esp)
  100bea:	e8 db f6 ff ff       	call   1002ca <cprintf>
        }
        argv[argc ++] = buf;
  100bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bf2:	8d 50 01             	lea    0x1(%eax),%edx
  100bf5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bf8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c02:	01 c2                	add    %eax,%edx
  100c04:	8b 45 08             	mov    0x8(%ebp),%eax
  100c07:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c09:	eb 03                	jmp    100c0e <parse+0x89>
            buf ++;
  100c0b:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c11:	0f b6 00             	movzbl (%eax),%eax
  100c14:	84 c0                	test   %al,%al
  100c16:	74 8c                	je     100ba4 <parse+0x1f>
  100c18:	8b 45 08             	mov    0x8(%ebp),%eax
  100c1b:	0f b6 00             	movzbl (%eax),%eax
  100c1e:	0f be c0             	movsbl %al,%eax
  100c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c25:	c7 04 24 2c a3 10 00 	movl   $0x10a32c,(%esp)
  100c2c:	e8 83 8a 00 00       	call   1096b4 <strchr>
  100c31:	85 c0                	test   %eax,%eax
  100c33:	74 d6                	je     100c0b <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c35:	e9 6a ff ff ff       	jmp    100ba4 <parse+0x1f>
            break;
  100c3a:	90                   	nop
        }
    }
    return argc;
  100c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c3e:	c9                   	leave  
  100c3f:	c3                   	ret    

00100c40 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c40:	f3 0f 1e fb          	endbr32 
  100c44:	55                   	push   %ebp
  100c45:	89 e5                	mov    %esp,%ebp
  100c47:	53                   	push   %ebx
  100c48:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c4b:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c52:	8b 45 08             	mov    0x8(%ebp),%eax
  100c55:	89 04 24             	mov    %eax,(%esp)
  100c58:	e8 28 ff ff ff       	call   100b85 <parse>
  100c5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c64:	75 0a                	jne    100c70 <runcmd+0x30>
        return 0;
  100c66:	b8 00 00 00 00       	mov    $0x0,%eax
  100c6b:	e9 83 00 00 00       	jmp    100cf3 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c77:	eb 5a                	jmp    100cd3 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c79:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c7f:	89 d0                	mov    %edx,%eax
  100c81:	01 c0                	add    %eax,%eax
  100c83:	01 d0                	add    %edx,%eax
  100c85:	c1 e0 02             	shl    $0x2,%eax
  100c88:	05 00 00 12 00       	add    $0x120000,%eax
  100c8d:	8b 00                	mov    (%eax),%eax
  100c8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c93:	89 04 24             	mov    %eax,(%esp)
  100c96:	e8 75 89 00 00       	call   109610 <strcmp>
  100c9b:	85 c0                	test   %eax,%eax
  100c9d:	75 31                	jne    100cd0 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ca2:	89 d0                	mov    %edx,%eax
  100ca4:	01 c0                	add    %eax,%eax
  100ca6:	01 d0                	add    %edx,%eax
  100ca8:	c1 e0 02             	shl    $0x2,%eax
  100cab:	05 08 00 12 00       	add    $0x120008,%eax
  100cb0:	8b 10                	mov    (%eax),%edx
  100cb2:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100cb5:	83 c0 04             	add    $0x4,%eax
  100cb8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100cbb:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100cbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100cc1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cc9:	89 1c 24             	mov    %ebx,(%esp)
  100ccc:	ff d2                	call   *%edx
  100cce:	eb 23                	jmp    100cf3 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cd0:	ff 45 f4             	incl   -0xc(%ebp)
  100cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cd6:	83 f8 02             	cmp    $0x2,%eax
  100cd9:	76 9e                	jbe    100c79 <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100cdb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cde:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce2:	c7 04 24 4f a3 10 00 	movl   $0x10a34f,(%esp)
  100ce9:	e8 dc f5 ff ff       	call   1002ca <cprintf>
    return 0;
  100cee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cf3:	83 c4 64             	add    $0x64,%esp
  100cf6:	5b                   	pop    %ebx
  100cf7:	5d                   	pop    %ebp
  100cf8:	c3                   	ret    

00100cf9 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100cf9:	f3 0f 1e fb          	endbr32 
  100cfd:	55                   	push   %ebp
  100cfe:	89 e5                	mov    %esp,%ebp
  100d00:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100d03:	c7 04 24 68 a3 10 00 	movl   $0x10a368,(%esp)
  100d0a:	e8 bb f5 ff ff       	call   1002ca <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100d0f:	c7 04 24 90 a3 10 00 	movl   $0x10a390,(%esp)
  100d16:	e8 af f5 ff ff       	call   1002ca <cprintf>

    if (tf != NULL) {
  100d1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d1f:	74 0b                	je     100d2c <kmonitor+0x33>
        print_trapframe(tf);
  100d21:	8b 45 08             	mov    0x8(%ebp),%eax
  100d24:	89 04 24             	mov    %eax,(%esp)
  100d27:	e8 d9 0e 00 00       	call   101c05 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d2c:	c7 04 24 b5 a3 10 00 	movl   $0x10a3b5,(%esp)
  100d33:	e8 45 f6 ff ff       	call   10037d <readline>
  100d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d3f:	74 eb                	je     100d2c <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d41:	8b 45 08             	mov    0x8(%ebp),%eax
  100d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d4b:	89 04 24             	mov    %eax,(%esp)
  100d4e:	e8 ed fe ff ff       	call   100c40 <runcmd>
  100d53:	85 c0                	test   %eax,%eax
  100d55:	78 02                	js     100d59 <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d57:	eb d3                	jmp    100d2c <kmonitor+0x33>
                break;
  100d59:	90                   	nop
            }
        }
    }
}
  100d5a:	90                   	nop
  100d5b:	c9                   	leave  
  100d5c:	c3                   	ret    

00100d5d <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d5d:	f3 0f 1e fb          	endbr32 
  100d61:	55                   	push   %ebp
  100d62:	89 e5                	mov    %esp,%ebp
  100d64:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d6e:	eb 3d                	jmp    100dad <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d73:	89 d0                	mov    %edx,%eax
  100d75:	01 c0                	add    %eax,%eax
  100d77:	01 d0                	add    %edx,%eax
  100d79:	c1 e0 02             	shl    $0x2,%eax
  100d7c:	05 04 00 12 00       	add    $0x120004,%eax
  100d81:	8b 08                	mov    (%eax),%ecx
  100d83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d86:	89 d0                	mov    %edx,%eax
  100d88:	01 c0                	add    %eax,%eax
  100d8a:	01 d0                	add    %edx,%eax
  100d8c:	c1 e0 02             	shl    $0x2,%eax
  100d8f:	05 00 00 12 00       	add    $0x120000,%eax
  100d94:	8b 00                	mov    (%eax),%eax
  100d96:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d9e:	c7 04 24 b9 a3 10 00 	movl   $0x10a3b9,(%esp)
  100da5:	e8 20 f5 ff ff       	call   1002ca <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100daa:	ff 45 f4             	incl   -0xc(%ebp)
  100dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100db0:	83 f8 02             	cmp    $0x2,%eax
  100db3:	76 bb                	jbe    100d70 <mon_help+0x13>
    }
    return 0;
  100db5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dba:	c9                   	leave  
  100dbb:	c3                   	ret    

00100dbc <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100dbc:	f3 0f 1e fb          	endbr32 
  100dc0:	55                   	push   %ebp
  100dc1:	89 e5                	mov    %esp,%ebp
  100dc3:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100dc6:	e8 c2 fb ff ff       	call   10098d <print_kerninfo>
    return 0;
  100dcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dd0:	c9                   	leave  
  100dd1:	c3                   	ret    

00100dd2 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100dd2:	f3 0f 1e fb          	endbr32 
  100dd6:	55                   	push   %ebp
  100dd7:	89 e5                	mov    %esp,%ebp
  100dd9:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100ddc:	e8 fe fc ff ff       	call   100adf <print_stackframe>
    return 0;
  100de1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100de6:	c9                   	leave  
  100de7:	c3                   	ret    

00100de8 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100de8:	f3 0f 1e fb          	endbr32 
  100dec:	55                   	push   %ebp
  100ded:	89 e5                	mov    %esp,%ebp
  100def:	83 ec 28             	sub    $0x28,%esp
  100df2:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100df8:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100dfc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e00:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e04:	ee                   	out    %al,(%dx)
}
  100e05:	90                   	nop
  100e06:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100e0c:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e10:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e14:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e18:	ee                   	out    %al,(%dx)
}
  100e19:	90                   	nop
  100e1a:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e20:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e24:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e28:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e2c:	ee                   	out    %al,(%dx)
}
  100e2d:	90                   	nop
    // 设置时钟每秒中断100次
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e2e:	c7 05 28 3f 12 00 00 	movl   $0x0,0x123f28
  100e35:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e38:	c7 04 24 c2 a3 10 00 	movl   $0x10a3c2,(%esp)
  100e3f:	e8 86 f4 ff ff       	call   1002ca <cprintf>
    pic_enable(IRQ_TIMER); // 通过中断控制器使能时钟中断
  100e44:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e4b:	e8 95 09 00 00       	call   1017e5 <pic_enable>
}
  100e50:	90                   	nop
  100e51:	c9                   	leave  
  100e52:	c3                   	ret    

00100e53 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e53:	55                   	push   %ebp
  100e54:	89 e5                	mov    %esp,%ebp
  100e56:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e59:	9c                   	pushf  
  100e5a:	58                   	pop    %eax
  100e5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e61:	25 00 02 00 00       	and    $0x200,%eax
  100e66:	85 c0                	test   %eax,%eax
  100e68:	74 0c                	je     100e76 <__intr_save+0x23>
        intr_disable();
  100e6a:	e8 05 0b 00 00       	call   101974 <intr_disable>
        return 1;
  100e6f:	b8 01 00 00 00       	mov    $0x1,%eax
  100e74:	eb 05                	jmp    100e7b <__intr_save+0x28>
    }
    return 0;
  100e76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e7b:	c9                   	leave  
  100e7c:	c3                   	ret    

00100e7d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e7d:	55                   	push   %ebp
  100e7e:	89 e5                	mov    %esp,%ebp
  100e80:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e87:	74 05                	je     100e8e <__intr_restore+0x11>
        intr_enable();
  100e89:	e8 da 0a 00 00       	call   101968 <intr_enable>
    }
}
  100e8e:	90                   	nop
  100e8f:	c9                   	leave  
  100e90:	c3                   	ret    

00100e91 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e91:	f3 0f 1e fb          	endbr32 
  100e95:	55                   	push   %ebp
  100e96:	89 e5                	mov    %esp,%ebp
  100e98:	83 ec 10             	sub    $0x10,%esp
  100e9b:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ea1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ea5:	89 c2                	mov    %eax,%edx
  100ea7:	ec                   	in     (%dx),%al
  100ea8:	88 45 f1             	mov    %al,-0xf(%ebp)
  100eab:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100eb1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100eb5:	89 c2                	mov    %eax,%edx
  100eb7:	ec                   	in     (%dx),%al
  100eb8:	88 45 f5             	mov    %al,-0xb(%ebp)
  100ebb:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100ec1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ec5:	89 c2                	mov    %eax,%edx
  100ec7:	ec                   	in     (%dx),%al
  100ec8:	88 45 f9             	mov    %al,-0x7(%ebp)
  100ecb:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100ed1:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ed5:	89 c2                	mov    %eax,%edx
  100ed7:	ec                   	in     (%dx),%al
  100ed8:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100edb:	90                   	nop
  100edc:	c9                   	leave  
  100edd:	c3                   	ret    

00100ede <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100ede:	f3 0f 1e fb          	endbr32 
  100ee2:	55                   	push   %ebp
  100ee3:	89 e5                	mov    %esp,%ebp
  100ee5:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100ee8:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100eef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ef2:	0f b7 00             	movzwl (%eax),%eax
  100ef5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100efc:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f04:	0f b7 00             	movzwl (%eax),%eax
  100f07:	0f b7 c0             	movzwl %ax,%eax
  100f0a:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100f0f:	74 12                	je     100f23 <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100f11:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100f18:	66 c7 05 46 34 12 00 	movw   $0x3b4,0x123446
  100f1f:	b4 03 
  100f21:	eb 13                	jmp    100f36 <cga_init+0x58>
    } else {
        *cp = was;
  100f23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f26:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100f2a:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100f2d:	66 c7 05 46 34 12 00 	movw   $0x3d4,0x123446
  100f34:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f36:	0f b7 05 46 34 12 00 	movzwl 0x123446,%eax
  100f3d:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f41:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f45:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f49:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f4d:	ee                   	out    %al,(%dx)
}
  100f4e:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f4f:	0f b7 05 46 34 12 00 	movzwl 0x123446,%eax
  100f56:	40                   	inc    %eax
  100f57:	0f b7 c0             	movzwl %ax,%eax
  100f5a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f5e:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f62:	89 c2                	mov    %eax,%edx
  100f64:	ec                   	in     (%dx),%al
  100f65:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f68:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f6c:	0f b6 c0             	movzbl %al,%eax
  100f6f:	c1 e0 08             	shl    $0x8,%eax
  100f72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f75:	0f b7 05 46 34 12 00 	movzwl 0x123446,%eax
  100f7c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f80:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f84:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f88:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f8c:	ee                   	out    %al,(%dx)
}
  100f8d:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f8e:	0f b7 05 46 34 12 00 	movzwl 0x123446,%eax
  100f95:	40                   	inc    %eax
  100f96:	0f b7 c0             	movzwl %ax,%eax
  100f99:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f9d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fa1:	89 c2                	mov    %eax,%edx
  100fa3:	ec                   	in     (%dx),%al
  100fa4:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100fa7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fab:	0f b6 c0             	movzbl %al,%eax
  100fae:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fb4:	a3 40 34 12 00       	mov    %eax,0x123440
    crt_pos = pos;
  100fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100fbc:	0f b7 c0             	movzwl %ax,%eax
  100fbf:	66 a3 44 34 12 00    	mov    %ax,0x123444
}
  100fc5:	90                   	nop
  100fc6:	c9                   	leave  
  100fc7:	c3                   	ret    

00100fc8 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100fc8:	f3 0f 1e fb          	endbr32 
  100fcc:	55                   	push   %ebp
  100fcd:	89 e5                	mov    %esp,%ebp
  100fcf:	83 ec 48             	sub    $0x48,%esp
  100fd2:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100fd8:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fdc:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100fe0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100fe4:	ee                   	out    %al,(%dx)
}
  100fe5:	90                   	nop
  100fe6:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100fec:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ff0:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100ff4:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100ff8:	ee                   	out    %al,(%dx)
}
  100ff9:	90                   	nop
  100ffa:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  101000:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101004:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101008:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10100c:	ee                   	out    %al,(%dx)
}
  10100d:	90                   	nop
  10100e:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  101014:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101018:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10101c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101020:	ee                   	out    %al,(%dx)
}
  101021:	90                   	nop
  101022:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  101028:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10102c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101030:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101034:	ee                   	out    %al,(%dx)
}
  101035:	90                   	nop
  101036:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  10103c:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101040:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101044:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101048:	ee                   	out    %al,(%dx)
}
  101049:	90                   	nop
  10104a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101050:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101054:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101058:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10105c:	ee                   	out    %al,(%dx)
}
  10105d:	90                   	nop
  10105e:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101064:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101068:	89 c2                	mov    %eax,%edx
  10106a:	ec                   	in     (%dx),%al
  10106b:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  10106e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts，使能串口1接收字符后产生中断
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101072:	3c ff                	cmp    $0xff,%al
  101074:	0f 95 c0             	setne  %al
  101077:	0f b6 c0             	movzbl %al,%eax
  10107a:	a3 48 34 12 00       	mov    %eax,0x123448
  10107f:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101085:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101089:	89 c2                	mov    %eax,%edx
  10108b:	ec                   	in     (%dx),%al
  10108c:	88 45 f1             	mov    %al,-0xf(%ebp)
  10108f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101095:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101099:	89 c2                	mov    %eax,%edx
  10109b:	ec                   	in     (%dx),%al
  10109c:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10109f:	a1 48 34 12 00       	mov    0x123448,%eax
  1010a4:	85 c0                	test   %eax,%eax
  1010a6:	74 0c                	je     1010b4 <serial_init+0xec>
        pic_enable(IRQ_COM1); // 通过中断控制器使能串口1中断
  1010a8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1010af:	e8 31 07 00 00       	call   1017e5 <pic_enable>
    }
}
  1010b4:	90                   	nop
  1010b5:	c9                   	leave  
  1010b6:	c3                   	ret    

001010b7 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  1010b7:	f3 0f 1e fb          	endbr32 
  1010bb:	55                   	push   %ebp
  1010bc:	89 e5                	mov    %esp,%ebp
  1010be:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1010c8:	eb 08                	jmp    1010d2 <lpt_putc_sub+0x1b>
        delay();
  1010ca:	e8 c2 fd ff ff       	call   100e91 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010cf:	ff 45 fc             	incl   -0x4(%ebp)
  1010d2:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010d8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010dc:	89 c2                	mov    %eax,%edx
  1010de:	ec                   	in     (%dx),%al
  1010df:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010e2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010e6:	84 c0                	test   %al,%al
  1010e8:	78 09                	js     1010f3 <lpt_putc_sub+0x3c>
  1010ea:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010f1:	7e d7                	jle    1010ca <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  1010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f6:	0f b6 c0             	movzbl %al,%eax
  1010f9:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010ff:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101102:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101106:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10110a:	ee                   	out    %al,(%dx)
}
  10110b:	90                   	nop
  10110c:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101112:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101116:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10111a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10111e:	ee                   	out    %al,(%dx)
}
  10111f:	90                   	nop
  101120:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101126:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10112a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10112e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101132:	ee                   	out    %al,(%dx)
}
  101133:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101134:	90                   	nop
  101135:	c9                   	leave  
  101136:	c3                   	ret    

00101137 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101137:	f3 0f 1e fb          	endbr32 
  10113b:	55                   	push   %ebp
  10113c:	89 e5                	mov    %esp,%ebp
  10113e:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101141:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101145:	74 0d                	je     101154 <lpt_putc+0x1d>
        lpt_putc_sub(c);
  101147:	8b 45 08             	mov    0x8(%ebp),%eax
  10114a:	89 04 24             	mov    %eax,(%esp)
  10114d:	e8 65 ff ff ff       	call   1010b7 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101152:	eb 24                	jmp    101178 <lpt_putc+0x41>
        lpt_putc_sub('\b');
  101154:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10115b:	e8 57 ff ff ff       	call   1010b7 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101160:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101167:	e8 4b ff ff ff       	call   1010b7 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10116c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101173:	e8 3f ff ff ff       	call   1010b7 <lpt_putc_sub>
}
  101178:	90                   	nop
  101179:	c9                   	leave  
  10117a:	c3                   	ret    

0010117b <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10117b:	f3 0f 1e fb          	endbr32 
  10117f:	55                   	push   %ebp
  101180:	89 e5                	mov    %esp,%ebp
  101182:	53                   	push   %ebx
  101183:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101186:	8b 45 08             	mov    0x8(%ebp),%eax
  101189:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10118e:	85 c0                	test   %eax,%eax
  101190:	75 07                	jne    101199 <cga_putc+0x1e>
        c |= 0x0700;
  101192:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101199:	8b 45 08             	mov    0x8(%ebp),%eax
  10119c:	0f b6 c0             	movzbl %al,%eax
  10119f:	83 f8 0d             	cmp    $0xd,%eax
  1011a2:	74 72                	je     101216 <cga_putc+0x9b>
  1011a4:	83 f8 0d             	cmp    $0xd,%eax
  1011a7:	0f 8f a3 00 00 00    	jg     101250 <cga_putc+0xd5>
  1011ad:	83 f8 08             	cmp    $0x8,%eax
  1011b0:	74 0a                	je     1011bc <cga_putc+0x41>
  1011b2:	83 f8 0a             	cmp    $0xa,%eax
  1011b5:	74 4c                	je     101203 <cga_putc+0x88>
  1011b7:	e9 94 00 00 00       	jmp    101250 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  1011bc:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  1011c3:	85 c0                	test   %eax,%eax
  1011c5:	0f 84 af 00 00 00    	je     10127a <cga_putc+0xff>
            crt_pos --;
  1011cb:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  1011d2:	48                   	dec    %eax
  1011d3:	0f b7 c0             	movzwl %ax,%eax
  1011d6:	66 a3 44 34 12 00    	mov    %ax,0x123444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1011df:	98                   	cwtl   
  1011e0:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011e5:	98                   	cwtl   
  1011e6:	83 c8 20             	or     $0x20,%eax
  1011e9:	98                   	cwtl   
  1011ea:	8b 15 40 34 12 00    	mov    0x123440,%edx
  1011f0:	0f b7 0d 44 34 12 00 	movzwl 0x123444,%ecx
  1011f7:	01 c9                	add    %ecx,%ecx
  1011f9:	01 ca                	add    %ecx,%edx
  1011fb:	0f b7 c0             	movzwl %ax,%eax
  1011fe:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101201:	eb 77                	jmp    10127a <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  101203:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  10120a:	83 c0 50             	add    $0x50,%eax
  10120d:	0f b7 c0             	movzwl %ax,%eax
  101210:	66 a3 44 34 12 00    	mov    %ax,0x123444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101216:	0f b7 1d 44 34 12 00 	movzwl 0x123444,%ebx
  10121d:	0f b7 0d 44 34 12 00 	movzwl 0x123444,%ecx
  101224:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101229:	89 c8                	mov    %ecx,%eax
  10122b:	f7 e2                	mul    %edx
  10122d:	c1 ea 06             	shr    $0x6,%edx
  101230:	89 d0                	mov    %edx,%eax
  101232:	c1 e0 02             	shl    $0x2,%eax
  101235:	01 d0                	add    %edx,%eax
  101237:	c1 e0 04             	shl    $0x4,%eax
  10123a:	29 c1                	sub    %eax,%ecx
  10123c:	89 c8                	mov    %ecx,%eax
  10123e:	0f b7 c0             	movzwl %ax,%eax
  101241:	29 c3                	sub    %eax,%ebx
  101243:	89 d8                	mov    %ebx,%eax
  101245:	0f b7 c0             	movzwl %ax,%eax
  101248:	66 a3 44 34 12 00    	mov    %ax,0x123444
        break;
  10124e:	eb 2b                	jmp    10127b <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101250:	8b 0d 40 34 12 00    	mov    0x123440,%ecx
  101256:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  10125d:	8d 50 01             	lea    0x1(%eax),%edx
  101260:	0f b7 d2             	movzwl %dx,%edx
  101263:	66 89 15 44 34 12 00 	mov    %dx,0x123444
  10126a:	01 c0                	add    %eax,%eax
  10126c:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10126f:	8b 45 08             	mov    0x8(%ebp),%eax
  101272:	0f b7 c0             	movzwl %ax,%eax
  101275:	66 89 02             	mov    %ax,(%edx)
        break;
  101278:	eb 01                	jmp    10127b <cga_putc+0x100>
        break;
  10127a:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10127b:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  101282:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101287:	76 5d                	jbe    1012e6 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101289:	a1 40 34 12 00       	mov    0x123440,%eax
  10128e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101294:	a1 40 34 12 00       	mov    0x123440,%eax
  101299:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1012a0:	00 
  1012a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  1012a5:	89 04 24             	mov    %eax,(%esp)
  1012a8:	e8 0c 86 00 00       	call   1098b9 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012ad:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1012b4:	eb 14                	jmp    1012ca <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  1012b6:	a1 40 34 12 00       	mov    0x123440,%eax
  1012bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012be:	01 d2                	add    %edx,%edx
  1012c0:	01 d0                	add    %edx,%eax
  1012c2:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012c7:	ff 45 f4             	incl   -0xc(%ebp)
  1012ca:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1012d1:	7e e3                	jle    1012b6 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  1012d3:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  1012da:	83 e8 50             	sub    $0x50,%eax
  1012dd:	0f b7 c0             	movzwl %ax,%eax
  1012e0:	66 a3 44 34 12 00    	mov    %ax,0x123444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012e6:	0f b7 05 46 34 12 00 	movzwl 0x123446,%eax
  1012ed:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1012f1:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012f5:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012f9:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012fd:	ee                   	out    %al,(%dx)
}
  1012fe:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012ff:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  101306:	c1 e8 08             	shr    $0x8,%eax
  101309:	0f b7 c0             	movzwl %ax,%eax
  10130c:	0f b6 c0             	movzbl %al,%eax
  10130f:	0f b7 15 46 34 12 00 	movzwl 0x123446,%edx
  101316:	42                   	inc    %edx
  101317:	0f b7 d2             	movzwl %dx,%edx
  10131a:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10131e:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101321:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101325:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101329:	ee                   	out    %al,(%dx)
}
  10132a:	90                   	nop
    outb(addr_6845, 15);
  10132b:	0f b7 05 46 34 12 00 	movzwl 0x123446,%eax
  101332:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101336:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10133a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10133e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101342:	ee                   	out    %al,(%dx)
}
  101343:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101344:	0f b7 05 44 34 12 00 	movzwl 0x123444,%eax
  10134b:	0f b6 c0             	movzbl %al,%eax
  10134e:	0f b7 15 46 34 12 00 	movzwl 0x123446,%edx
  101355:	42                   	inc    %edx
  101356:	0f b7 d2             	movzwl %dx,%edx
  101359:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  10135d:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101360:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101364:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101368:	ee                   	out    %al,(%dx)
}
  101369:	90                   	nop
}
  10136a:	90                   	nop
  10136b:	83 c4 34             	add    $0x34,%esp
  10136e:	5b                   	pop    %ebx
  10136f:	5d                   	pop    %ebp
  101370:	c3                   	ret    

00101371 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101371:	f3 0f 1e fb          	endbr32 
  101375:	55                   	push   %ebp
  101376:	89 e5                	mov    %esp,%ebp
  101378:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10137b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101382:	eb 08                	jmp    10138c <serial_putc_sub+0x1b>
        delay();
  101384:	e8 08 fb ff ff       	call   100e91 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101389:	ff 45 fc             	incl   -0x4(%ebp)
  10138c:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101392:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101396:	89 c2                	mov    %eax,%edx
  101398:	ec                   	in     (%dx),%al
  101399:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10139c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1013a0:	0f b6 c0             	movzbl %al,%eax
  1013a3:	83 e0 20             	and    $0x20,%eax
  1013a6:	85 c0                	test   %eax,%eax
  1013a8:	75 09                	jne    1013b3 <serial_putc_sub+0x42>
  1013aa:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1013b1:	7e d1                	jle    101384 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  1013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1013b6:	0f b6 c0             	movzbl %al,%eax
  1013b9:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1013bf:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1013c2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1013c6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1013ca:	ee                   	out    %al,(%dx)
}
  1013cb:	90                   	nop
}
  1013cc:	90                   	nop
  1013cd:	c9                   	leave  
  1013ce:	c3                   	ret    

001013cf <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1013cf:	f3 0f 1e fb          	endbr32 
  1013d3:	55                   	push   %ebp
  1013d4:	89 e5                	mov    %esp,%ebp
  1013d6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1013d9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013dd:	74 0d                	je     1013ec <serial_putc+0x1d>
        serial_putc_sub(c);
  1013df:	8b 45 08             	mov    0x8(%ebp),%eax
  1013e2:	89 04 24             	mov    %eax,(%esp)
  1013e5:	e8 87 ff ff ff       	call   101371 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013ea:	eb 24                	jmp    101410 <serial_putc+0x41>
        serial_putc_sub('\b');
  1013ec:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013f3:	e8 79 ff ff ff       	call   101371 <serial_putc_sub>
        serial_putc_sub(' ');
  1013f8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013ff:	e8 6d ff ff ff       	call   101371 <serial_putc_sub>
        serial_putc_sub('\b');
  101404:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10140b:	e8 61 ff ff ff       	call   101371 <serial_putc_sub>
}
  101410:	90                   	nop
  101411:	c9                   	leave  
  101412:	c3                   	ret    

00101413 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101413:	f3 0f 1e fb          	endbr32 
  101417:	55                   	push   %ebp
  101418:	89 e5                	mov    %esp,%ebp
  10141a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10141d:	eb 33                	jmp    101452 <cons_intr+0x3f>
        if (c != 0) {
  10141f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101423:	74 2d                	je     101452 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  101425:	a1 64 36 12 00       	mov    0x123664,%eax
  10142a:	8d 50 01             	lea    0x1(%eax),%edx
  10142d:	89 15 64 36 12 00    	mov    %edx,0x123664
  101433:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101436:	88 90 60 34 12 00    	mov    %dl,0x123460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10143c:	a1 64 36 12 00       	mov    0x123664,%eax
  101441:	3d 00 02 00 00       	cmp    $0x200,%eax
  101446:	75 0a                	jne    101452 <cons_intr+0x3f>
                cons.wpos = 0;
  101448:	c7 05 64 36 12 00 00 	movl   $0x0,0x123664
  10144f:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101452:	8b 45 08             	mov    0x8(%ebp),%eax
  101455:	ff d0                	call   *%eax
  101457:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10145a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10145e:	75 bf                	jne    10141f <cons_intr+0xc>
            }
        }
    }
}
  101460:	90                   	nop
  101461:	90                   	nop
  101462:	c9                   	leave  
  101463:	c3                   	ret    

00101464 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101464:	f3 0f 1e fb          	endbr32 
  101468:	55                   	push   %ebp
  101469:	89 e5                	mov    %esp,%ebp
  10146b:	83 ec 10             	sub    $0x10,%esp
  10146e:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101474:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101478:	89 c2                	mov    %eax,%edx
  10147a:	ec                   	in     (%dx),%al
  10147b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10147e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101482:	0f b6 c0             	movzbl %al,%eax
  101485:	83 e0 01             	and    $0x1,%eax
  101488:	85 c0                	test   %eax,%eax
  10148a:	75 07                	jne    101493 <serial_proc_data+0x2f>
        return -1;
  10148c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101491:	eb 2a                	jmp    1014bd <serial_proc_data+0x59>
  101493:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101499:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10149d:	89 c2                	mov    %eax,%edx
  10149f:	ec                   	in     (%dx),%al
  1014a0:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1014a3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1014a7:	0f b6 c0             	movzbl %al,%eax
  1014aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1014ad:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1014b1:	75 07                	jne    1014ba <serial_proc_data+0x56>
        c = '\b';
  1014b3:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1014ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1014bd:	c9                   	leave  
  1014be:	c3                   	ret    

001014bf <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1014bf:	f3 0f 1e fb          	endbr32 
  1014c3:	55                   	push   %ebp
  1014c4:	89 e5                	mov    %esp,%ebp
  1014c6:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1014c9:	a1 48 34 12 00       	mov    0x123448,%eax
  1014ce:	85 c0                	test   %eax,%eax
  1014d0:	74 0c                	je     1014de <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1014d2:	c7 04 24 64 14 10 00 	movl   $0x101464,(%esp)
  1014d9:	e8 35 ff ff ff       	call   101413 <cons_intr>
    }
}
  1014de:	90                   	nop
  1014df:	c9                   	leave  
  1014e0:	c3                   	ret    

001014e1 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014e1:	f3 0f 1e fb          	endbr32 
  1014e5:	55                   	push   %ebp
  1014e6:	89 e5                	mov    %esp,%ebp
  1014e8:	83 ec 38             	sub    $0x38,%esp
  1014eb:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014f4:	89 c2                	mov    %eax,%edx
  1014f6:	ec                   	in     (%dx),%al
  1014f7:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014fa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014fe:	0f b6 c0             	movzbl %al,%eax
  101501:	83 e0 01             	and    $0x1,%eax
  101504:	85 c0                	test   %eax,%eax
  101506:	75 0a                	jne    101512 <kbd_proc_data+0x31>
        return -1;
  101508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10150d:	e9 56 01 00 00       	jmp    101668 <kbd_proc_data+0x187>
  101512:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10151b:	89 c2                	mov    %eax,%edx
  10151d:	ec                   	in     (%dx),%al
  10151e:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101521:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101525:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101528:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10152c:	75 17                	jne    101545 <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  10152e:	a1 68 36 12 00       	mov    0x123668,%eax
  101533:	83 c8 40             	or     $0x40,%eax
  101536:	a3 68 36 12 00       	mov    %eax,0x123668
        return 0;
  10153b:	b8 00 00 00 00       	mov    $0x0,%eax
  101540:	e9 23 01 00 00       	jmp    101668 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101545:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101549:	84 c0                	test   %al,%al
  10154b:	79 45                	jns    101592 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10154d:	a1 68 36 12 00       	mov    0x123668,%eax
  101552:	83 e0 40             	and    $0x40,%eax
  101555:	85 c0                	test   %eax,%eax
  101557:	75 08                	jne    101561 <kbd_proc_data+0x80>
  101559:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10155d:	24 7f                	and    $0x7f,%al
  10155f:	eb 04                	jmp    101565 <kbd_proc_data+0x84>
  101561:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101565:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101568:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10156c:	0f b6 80 40 00 12 00 	movzbl 0x120040(%eax),%eax
  101573:	0c 40                	or     $0x40,%al
  101575:	0f b6 c0             	movzbl %al,%eax
  101578:	f7 d0                	not    %eax
  10157a:	89 c2                	mov    %eax,%edx
  10157c:	a1 68 36 12 00       	mov    0x123668,%eax
  101581:	21 d0                	and    %edx,%eax
  101583:	a3 68 36 12 00       	mov    %eax,0x123668
        return 0;
  101588:	b8 00 00 00 00       	mov    $0x0,%eax
  10158d:	e9 d6 00 00 00       	jmp    101668 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101592:	a1 68 36 12 00       	mov    0x123668,%eax
  101597:	83 e0 40             	and    $0x40,%eax
  10159a:	85 c0                	test   %eax,%eax
  10159c:	74 11                	je     1015af <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10159e:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1015a2:	a1 68 36 12 00       	mov    0x123668,%eax
  1015a7:	83 e0 bf             	and    $0xffffffbf,%eax
  1015aa:	a3 68 36 12 00       	mov    %eax,0x123668
    }

    shift |= shiftcode[data];
  1015af:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015b3:	0f b6 80 40 00 12 00 	movzbl 0x120040(%eax),%eax
  1015ba:	0f b6 d0             	movzbl %al,%edx
  1015bd:	a1 68 36 12 00       	mov    0x123668,%eax
  1015c2:	09 d0                	or     %edx,%eax
  1015c4:	a3 68 36 12 00       	mov    %eax,0x123668
    shift ^= togglecode[data];
  1015c9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015cd:	0f b6 80 40 01 12 00 	movzbl 0x120140(%eax),%eax
  1015d4:	0f b6 d0             	movzbl %al,%edx
  1015d7:	a1 68 36 12 00       	mov    0x123668,%eax
  1015dc:	31 d0                	xor    %edx,%eax
  1015de:	a3 68 36 12 00       	mov    %eax,0x123668

    c = charcode[shift & (CTL | SHIFT)][data];
  1015e3:	a1 68 36 12 00       	mov    0x123668,%eax
  1015e8:	83 e0 03             	and    $0x3,%eax
  1015eb:	8b 14 85 40 05 12 00 	mov    0x120540(,%eax,4),%edx
  1015f2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015f6:	01 d0                	add    %edx,%eax
  1015f8:	0f b6 00             	movzbl (%eax),%eax
  1015fb:	0f b6 c0             	movzbl %al,%eax
  1015fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101601:	a1 68 36 12 00       	mov    0x123668,%eax
  101606:	83 e0 08             	and    $0x8,%eax
  101609:	85 c0                	test   %eax,%eax
  10160b:	74 22                	je     10162f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10160d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101611:	7e 0c                	jle    10161f <kbd_proc_data+0x13e>
  101613:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101617:	7f 06                	jg     10161f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101619:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10161d:	eb 10                	jmp    10162f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10161f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101623:	7e 0a                	jle    10162f <kbd_proc_data+0x14e>
  101625:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101629:	7f 04                	jg     10162f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10162b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10162f:	a1 68 36 12 00       	mov    0x123668,%eax
  101634:	f7 d0                	not    %eax
  101636:	83 e0 06             	and    $0x6,%eax
  101639:	85 c0                	test   %eax,%eax
  10163b:	75 28                	jne    101665 <kbd_proc_data+0x184>
  10163d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101644:	75 1f                	jne    101665 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101646:	c7 04 24 dd a3 10 00 	movl   $0x10a3dd,(%esp)
  10164d:	e8 78 ec ff ff       	call   1002ca <cprintf>
  101652:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101658:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10165c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101660:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101663:	ee                   	out    %al,(%dx)
}
  101664:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101665:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101668:	c9                   	leave  
  101669:	c3                   	ret    

0010166a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10166a:	f3 0f 1e fb          	endbr32 
  10166e:	55                   	push   %ebp
  10166f:	89 e5                	mov    %esp,%ebp
  101671:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101674:	c7 04 24 e1 14 10 00 	movl   $0x1014e1,(%esp)
  10167b:	e8 93 fd ff ff       	call   101413 <cons_intr>
}
  101680:	90                   	nop
  101681:	c9                   	leave  
  101682:	c3                   	ret    

00101683 <kbd_init>:

static void
kbd_init(void) {
  101683:	f3 0f 1e fb          	endbr32 
  101687:	55                   	push   %ebp
  101688:	89 e5                	mov    %esp,%ebp
  10168a:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10168d:	e8 d8 ff ff ff       	call   10166a <kbd_intr>
    pic_enable(IRQ_KBD); // 通过中断控制器使能键盘输入中断
  101692:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101699:	e8 47 01 00 00       	call   1017e5 <pic_enable>
}
  10169e:	90                   	nop
  10169f:	c9                   	leave  
  1016a0:	c3                   	ret    

001016a1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1016a1:	f3 0f 1e fb          	endbr32 
  1016a5:	55                   	push   %ebp
  1016a6:	89 e5                	mov    %esp,%ebp
  1016a8:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1016ab:	e8 2e f8 ff ff       	call   100ede <cga_init>
    serial_init();
  1016b0:	e8 13 f9 ff ff       	call   100fc8 <serial_init>
    kbd_init();
  1016b5:	e8 c9 ff ff ff       	call   101683 <kbd_init>
    if (!serial_exists) {
  1016ba:	a1 48 34 12 00       	mov    0x123448,%eax
  1016bf:	85 c0                	test   %eax,%eax
  1016c1:	75 0c                	jne    1016cf <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1016c3:	c7 04 24 e9 a3 10 00 	movl   $0x10a3e9,(%esp)
  1016ca:	e8 fb eb ff ff       	call   1002ca <cprintf>
    }
}
  1016cf:	90                   	nop
  1016d0:	c9                   	leave  
  1016d1:	c3                   	ret    

001016d2 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1016d2:	f3 0f 1e fb          	endbr32 
  1016d6:	55                   	push   %ebp
  1016d7:	89 e5                	mov    %esp,%ebp
  1016d9:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1016dc:	e8 72 f7 ff ff       	call   100e53 <__intr_save>
  1016e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1016e7:	89 04 24             	mov    %eax,(%esp)
  1016ea:	e8 48 fa ff ff       	call   101137 <lpt_putc>
        cga_putc(c);
  1016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1016f2:	89 04 24             	mov    %eax,(%esp)
  1016f5:	e8 81 fa ff ff       	call   10117b <cga_putc>
        serial_putc(c);
  1016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1016fd:	89 04 24             	mov    %eax,(%esp)
  101700:	e8 ca fc ff ff       	call   1013cf <serial_putc>
    }
    local_intr_restore(intr_flag);
  101705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101708:	89 04 24             	mov    %eax,(%esp)
  10170b:	e8 6d f7 ff ff       	call   100e7d <__intr_restore>
}
  101710:	90                   	nop
  101711:	c9                   	leave  
  101712:	c3                   	ret    

00101713 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101713:	f3 0f 1e fb          	endbr32 
  101717:	55                   	push   %ebp
  101718:	89 e5                	mov    %esp,%ebp
  10171a:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10171d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101724:	e8 2a f7 ff ff       	call   100e53 <__intr_save>
  101729:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10172c:	e8 8e fd ff ff       	call   1014bf <serial_intr>
        kbd_intr();
  101731:	e8 34 ff ff ff       	call   10166a <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101736:	8b 15 60 36 12 00    	mov    0x123660,%edx
  10173c:	a1 64 36 12 00       	mov    0x123664,%eax
  101741:	39 c2                	cmp    %eax,%edx
  101743:	74 31                	je     101776 <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
  101745:	a1 60 36 12 00       	mov    0x123660,%eax
  10174a:	8d 50 01             	lea    0x1(%eax),%edx
  10174d:	89 15 60 36 12 00    	mov    %edx,0x123660
  101753:	0f b6 80 60 34 12 00 	movzbl 0x123460(%eax),%eax
  10175a:	0f b6 c0             	movzbl %al,%eax
  10175d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101760:	a1 60 36 12 00       	mov    0x123660,%eax
  101765:	3d 00 02 00 00       	cmp    $0x200,%eax
  10176a:	75 0a                	jne    101776 <cons_getc+0x63>
                cons.rpos = 0;
  10176c:	c7 05 60 36 12 00 00 	movl   $0x0,0x123660
  101773:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101779:	89 04 24             	mov    %eax,(%esp)
  10177c:	e8 fc f6 ff ff       	call   100e7d <__intr_restore>
    return c;
  101781:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101784:	c9                   	leave  
  101785:	c3                   	ret    

00101786 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101786:	f3 0f 1e fb          	endbr32 
  10178a:	55                   	push   %ebp
  10178b:	89 e5                	mov    %esp,%ebp
  10178d:	83 ec 14             	sub    $0x14,%esp
  101790:	8b 45 08             	mov    0x8(%ebp),%eax
  101793:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10179a:	66 a3 50 05 12 00    	mov    %ax,0x120550
    if (did_init) {
  1017a0:	a1 6c 36 12 00       	mov    0x12366c,%eax
  1017a5:	85 c0                	test   %eax,%eax
  1017a7:	74 39                	je     1017e2 <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  1017a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017ac:	0f b6 c0             	movzbl %al,%eax
  1017af:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1017b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017bc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017c0:	ee                   	out    %al,(%dx)
}
  1017c1:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1017c2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1017c6:	c1 e8 08             	shr    $0x8,%eax
  1017c9:	0f b7 c0             	movzwl %ax,%eax
  1017cc:	0f b6 c0             	movzbl %al,%eax
  1017cf:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1017d5:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017d8:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017dc:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017e0:	ee                   	out    %al,(%dx)
}
  1017e1:	90                   	nop
    }
}
  1017e2:	90                   	nop
  1017e3:	c9                   	leave  
  1017e4:	c3                   	ret    

001017e5 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1017e5:	f3 0f 1e fb          	endbr32 
  1017e9:	55                   	push   %ebp
  1017ea:	89 e5                	mov    %esp,%ebp
  1017ec:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1017f2:	ba 01 00 00 00       	mov    $0x1,%edx
  1017f7:	88 c1                	mov    %al,%cl
  1017f9:	d3 e2                	shl    %cl,%edx
  1017fb:	89 d0                	mov    %edx,%eax
  1017fd:	98                   	cwtl   
  1017fe:	f7 d0                	not    %eax
  101800:	0f bf d0             	movswl %ax,%edx
  101803:	0f b7 05 50 05 12 00 	movzwl 0x120550,%eax
  10180a:	98                   	cwtl   
  10180b:	21 d0                	and    %edx,%eax
  10180d:	98                   	cwtl   
  10180e:	0f b7 c0             	movzwl %ax,%eax
  101811:	89 04 24             	mov    %eax,(%esp)
  101814:	e8 6d ff ff ff       	call   101786 <pic_setmask>
}
  101819:	90                   	nop
  10181a:	c9                   	leave  
  10181b:	c3                   	ret    

0010181c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10181c:	f3 0f 1e fb          	endbr32 
  101820:	55                   	push   %ebp
  101821:	89 e5                	mov    %esp,%ebp
  101823:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101826:	c7 05 6c 36 12 00 01 	movl   $0x1,0x12366c
  10182d:	00 00 00 
  101830:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101836:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10183a:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10183e:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101842:	ee                   	out    %al,(%dx)
}
  101843:	90                   	nop
  101844:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  10184a:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10184e:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101852:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101856:	ee                   	out    %al,(%dx)
}
  101857:	90                   	nop
  101858:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10185e:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101862:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101866:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10186a:	ee                   	out    %al,(%dx)
}
  10186b:	90                   	nop
  10186c:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101872:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101876:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10187a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10187e:	ee                   	out    %al,(%dx)
}
  10187f:	90                   	nop
  101880:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101886:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10188a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10188e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101892:	ee                   	out    %al,(%dx)
}
  101893:	90                   	nop
  101894:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10189a:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10189e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1018a2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1018a6:	ee                   	out    %al,(%dx)
}
  1018a7:	90                   	nop
  1018a8:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1018ae:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018b2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1018b6:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1018ba:	ee                   	out    %al,(%dx)
}
  1018bb:	90                   	nop
  1018bc:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1018c2:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018c6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1018ca:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1018ce:	ee                   	out    %al,(%dx)
}
  1018cf:	90                   	nop
  1018d0:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1018d6:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018da:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1018de:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1018e2:	ee                   	out    %al,(%dx)
}
  1018e3:	90                   	nop
  1018e4:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1018ea:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018ee:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1018f2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1018f6:	ee                   	out    %al,(%dx)
}
  1018f7:	90                   	nop
  1018f8:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1018fe:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101902:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101906:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10190a:	ee                   	out    %al,(%dx)
}
  10190b:	90                   	nop
  10190c:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101912:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101916:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10191a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10191e:	ee                   	out    %al,(%dx)
}
  10191f:	90                   	nop
  101920:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101926:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10192a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10192e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101932:	ee                   	out    %al,(%dx)
}
  101933:	90                   	nop
  101934:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  10193a:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10193e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101942:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101946:	ee                   	out    %al,(%dx)
}
  101947:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101948:	0f b7 05 50 05 12 00 	movzwl 0x120550,%eax
  10194f:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101954:	74 0f                	je     101965 <pic_init+0x149>
        pic_setmask(irq_mask);
  101956:	0f b7 05 50 05 12 00 	movzwl 0x120550,%eax
  10195d:	89 04 24             	mov    %eax,(%esp)
  101960:	e8 21 fe ff ff       	call   101786 <pic_setmask>
    }
}
  101965:	90                   	nop
  101966:	c9                   	leave  
  101967:	c3                   	ret    

00101968 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101968:	f3 0f 1e fb          	endbr32 
  10196c:	55                   	push   %ebp
  10196d:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  10196f:	fb                   	sti    
}
  101970:	90                   	nop
    sti();
}
  101971:	90                   	nop
  101972:	5d                   	pop    %ebp
  101973:	c3                   	ret    

00101974 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101974:	f3 0f 1e fb          	endbr32 
  101978:	55                   	push   %ebp
  101979:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  10197b:	fa                   	cli    
}
  10197c:	90                   	nop
    cli();
}
  10197d:	90                   	nop
  10197e:	5d                   	pop    %ebp
  10197f:	c3                   	ret    

00101980 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101980:	f3 0f 1e fb          	endbr32 
  101984:	55                   	push   %ebp
  101985:	89 e5                	mov    %esp,%ebp
  101987:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10198a:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101991:	00 
  101992:	c7 04 24 20 a4 10 00 	movl   $0x10a420,(%esp)
  101999:	e8 2c e9 ff ff       	call   1002ca <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10199e:	c7 04 24 2a a4 10 00 	movl   $0x10a42a,(%esp)
  1019a5:	e8 20 e9 ff ff       	call   1002ca <cprintf>
    panic("EOT: kernel seems ok.");
  1019aa:	c7 44 24 08 38 a4 10 	movl   $0x10a438,0x8(%esp)
  1019b1:	00 
  1019b2:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1019b9:	00 
  1019ba:	c7 04 24 4e a4 10 00 	movl   $0x10a44e,(%esp)
  1019c1:	e8 70 ea ff ff       	call   100436 <__panic>

001019c6 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1019c6:	f3 0f 1e fb          	endbr32 
  1019ca:	55                   	push   %ebp
  1019cb:	89 e5                	mov    %esp,%ebp
  1019cd:	83 ec 10             	sub    $0x10,%esp
      */
    // (1)
    extern uintptr_t __vectors[];
    // (2)
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1019d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1019d7:	e9 c4 00 00 00       	jmp    101aa0 <idt_init+0xda>
        SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL); // trapno = i, gd_type = Interrupt-gate descriptor, DPL = 0
  1019dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019df:	8b 04 85 e0 05 12 00 	mov    0x1205e0(,%eax,4),%eax
  1019e6:	0f b7 d0             	movzwl %ax,%edx
  1019e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ec:	66 89 14 c5 80 36 12 	mov    %dx,0x123680(,%eax,8)
  1019f3:	00 
  1019f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f7:	66 c7 04 c5 82 36 12 	movw   $0x8,0x123682(,%eax,8)
  1019fe:	00 08 00 
  101a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a04:	0f b6 14 c5 84 36 12 	movzbl 0x123684(,%eax,8),%edx
  101a0b:	00 
  101a0c:	80 e2 e0             	and    $0xe0,%dl
  101a0f:	88 14 c5 84 36 12 00 	mov    %dl,0x123684(,%eax,8)
  101a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a19:	0f b6 14 c5 84 36 12 	movzbl 0x123684(,%eax,8),%edx
  101a20:	00 
  101a21:	80 e2 1f             	and    $0x1f,%dl
  101a24:	88 14 c5 84 36 12 00 	mov    %dl,0x123684(,%eax,8)
  101a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a2e:	0f b6 14 c5 85 36 12 	movzbl 0x123685(,%eax,8),%edx
  101a35:	00 
  101a36:	80 e2 f0             	and    $0xf0,%dl
  101a39:	80 ca 0e             	or     $0xe,%dl
  101a3c:	88 14 c5 85 36 12 00 	mov    %dl,0x123685(,%eax,8)
  101a43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a46:	0f b6 14 c5 85 36 12 	movzbl 0x123685(,%eax,8),%edx
  101a4d:	00 
  101a4e:	80 e2 ef             	and    $0xef,%dl
  101a51:	88 14 c5 85 36 12 00 	mov    %dl,0x123685(,%eax,8)
  101a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a5b:	0f b6 14 c5 85 36 12 	movzbl 0x123685(,%eax,8),%edx
  101a62:	00 
  101a63:	80 e2 9f             	and    $0x9f,%dl
  101a66:	88 14 c5 85 36 12 00 	mov    %dl,0x123685(,%eax,8)
  101a6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a70:	0f b6 14 c5 85 36 12 	movzbl 0x123685(,%eax,8),%edx
  101a77:	00 
  101a78:	80 ca 80             	or     $0x80,%dl
  101a7b:	88 14 c5 85 36 12 00 	mov    %dl,0x123685(,%eax,8)
  101a82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a85:	8b 04 85 e0 05 12 00 	mov    0x1205e0(,%eax,4),%eax
  101a8c:	c1 e8 10             	shr    $0x10,%eax
  101a8f:	0f b7 d0             	movzwl %ax,%edx
  101a92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a95:	66 89 14 c5 86 36 12 	mov    %dx,0x123686(,%eax,8)
  101a9c:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101a9d:	ff 45 fc             	incl   -0x4(%ebp)
  101aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101aa3:	3d ff 00 00 00       	cmp    $0xff,%eax
  101aa8:	0f 86 2e ff ff ff    	jbe    1019dc <idt_init+0x16>
    }
	// 系统调用中断
    SETGATE(idt[T_SYSCALL], 1, KERNEL_CS, __vectors[T_SYSCALL], DPL_USER); // trapno = T_SYSCALL = 0x80，gd_type = Trap-gate descriptor，DPL = 3
  101aae:	a1 e0 07 12 00       	mov    0x1207e0,%eax
  101ab3:	0f b7 c0             	movzwl %ax,%eax
  101ab6:	66 a3 80 3a 12 00    	mov    %ax,0x123a80
  101abc:	66 c7 05 82 3a 12 00 	movw   $0x8,0x123a82
  101ac3:	08 00 
  101ac5:	0f b6 05 84 3a 12 00 	movzbl 0x123a84,%eax
  101acc:	24 e0                	and    $0xe0,%al
  101ace:	a2 84 3a 12 00       	mov    %al,0x123a84
  101ad3:	0f b6 05 84 3a 12 00 	movzbl 0x123a84,%eax
  101ada:	24 1f                	and    $0x1f,%al
  101adc:	a2 84 3a 12 00       	mov    %al,0x123a84
  101ae1:	0f b6 05 85 3a 12 00 	movzbl 0x123a85,%eax
  101ae8:	0c 0f                	or     $0xf,%al
  101aea:	a2 85 3a 12 00       	mov    %al,0x123a85
  101aef:	0f b6 05 85 3a 12 00 	movzbl 0x123a85,%eax
  101af6:	24 ef                	and    $0xef,%al
  101af8:	a2 85 3a 12 00       	mov    %al,0x123a85
  101afd:	0f b6 05 85 3a 12 00 	movzbl 0x123a85,%eax
  101b04:	0c 60                	or     $0x60,%al
  101b06:	a2 85 3a 12 00       	mov    %al,0x123a85
  101b0b:	0f b6 05 85 3a 12 00 	movzbl 0x123a85,%eax
  101b12:	0c 80                	or     $0x80,%al
  101b14:	a2 85 3a 12 00       	mov    %al,0x123a85
  101b19:	a1 e0 07 12 00       	mov    0x1207e0,%eax
  101b1e:	c1 e8 10             	shr    $0x10,%eax
  101b21:	0f b7 c0             	movzwl %ax,%eax
  101b24:	66 a3 86 3a 12 00    	mov    %ax,0x123a86
    SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], DPL_USER);
  101b2a:	a1 c4 07 12 00       	mov    0x1207c4,%eax
  101b2f:	0f b7 c0             	movzwl %ax,%eax
  101b32:	66 a3 48 3a 12 00    	mov    %ax,0x123a48
  101b38:	66 c7 05 4a 3a 12 00 	movw   $0x8,0x123a4a
  101b3f:	08 00 
  101b41:	0f b6 05 4c 3a 12 00 	movzbl 0x123a4c,%eax
  101b48:	24 e0                	and    $0xe0,%al
  101b4a:	a2 4c 3a 12 00       	mov    %al,0x123a4c
  101b4f:	0f b6 05 4c 3a 12 00 	movzbl 0x123a4c,%eax
  101b56:	24 1f                	and    $0x1f,%al
  101b58:	a2 4c 3a 12 00       	mov    %al,0x123a4c
  101b5d:	0f b6 05 4d 3a 12 00 	movzbl 0x123a4d,%eax
  101b64:	0c 0f                	or     $0xf,%al
  101b66:	a2 4d 3a 12 00       	mov    %al,0x123a4d
  101b6b:	0f b6 05 4d 3a 12 00 	movzbl 0x123a4d,%eax
  101b72:	24 ef                	and    $0xef,%al
  101b74:	a2 4d 3a 12 00       	mov    %al,0x123a4d
  101b79:	0f b6 05 4d 3a 12 00 	movzbl 0x123a4d,%eax
  101b80:	0c 60                	or     $0x60,%al
  101b82:	a2 4d 3a 12 00       	mov    %al,0x123a4d
  101b87:	0f b6 05 4d 3a 12 00 	movzbl 0x123a4d,%eax
  101b8e:	0c 80                	or     $0x80,%al
  101b90:	a2 4d 3a 12 00       	mov    %al,0x123a4d
  101b95:	a1 c4 07 12 00       	mov    0x1207c4,%eax
  101b9a:	c1 e8 10             	shr    $0x10,%eax
  101b9d:	0f b7 c0             	movzwl %ax,%eax
  101ba0:	66 a3 4e 3a 12 00    	mov    %ax,0x123a4e
  101ba6:	c7 45 f8 60 05 12 00 	movl   $0x120560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101bad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101bb0:	0f 01 18             	lidtl  (%eax)
}
  101bb3:	90                   	nop
	// (3)
    lidt(&idt_pd);
}
  101bb4:	90                   	nop
  101bb5:	c9                   	leave  
  101bb6:	c3                   	ret    

00101bb7 <trapname>:

static const char *
trapname(int trapno) {
  101bb7:	f3 0f 1e fb          	endbr32 
  101bbb:	55                   	push   %ebp
  101bbc:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc1:	83 f8 13             	cmp    $0x13,%eax
  101bc4:	77 0c                	ja     101bd2 <trapname+0x1b>
        return excnames[trapno];
  101bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc9:	8b 04 85 00 a8 10 00 	mov    0x10a800(,%eax,4),%eax
  101bd0:	eb 18                	jmp    101bea <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101bd2:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101bd6:	7e 0d                	jle    101be5 <trapname+0x2e>
  101bd8:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101bdc:	7f 07                	jg     101be5 <trapname+0x2e>
        return "Hardware Interrupt";
  101bde:	b8 5f a4 10 00       	mov    $0x10a45f,%eax
  101be3:	eb 05                	jmp    101bea <trapname+0x33>
    }
    return "(unknown trap)";
  101be5:	b8 72 a4 10 00       	mov    $0x10a472,%eax
}
  101bea:	5d                   	pop    %ebp
  101beb:	c3                   	ret    

00101bec <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101bec:	f3 0f 1e fb          	endbr32 
  101bf0:	55                   	push   %ebp
  101bf1:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bfa:	83 f8 08             	cmp    $0x8,%eax
  101bfd:	0f 94 c0             	sete   %al
  101c00:	0f b6 c0             	movzbl %al,%eax
}
  101c03:	5d                   	pop    %ebp
  101c04:	c3                   	ret    

00101c05 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101c05:	f3 0f 1e fb          	endbr32 
  101c09:	55                   	push   %ebp
  101c0a:	89 e5                	mov    %esp,%ebp
  101c0c:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c12:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c16:	c7 04 24 b3 a4 10 00 	movl   $0x10a4b3,(%esp)
  101c1d:	e8 a8 e6 ff ff       	call   1002ca <cprintf>
    print_regs(&tf->tf_regs);
  101c22:	8b 45 08             	mov    0x8(%ebp),%eax
  101c25:	89 04 24             	mov    %eax,(%esp)
  101c28:	e8 8d 01 00 00       	call   101dba <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c30:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c38:	c7 04 24 c4 a4 10 00 	movl   $0x10a4c4,(%esp)
  101c3f:	e8 86 e6 ff ff       	call   1002ca <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101c44:	8b 45 08             	mov    0x8(%ebp),%eax
  101c47:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4f:	c7 04 24 d7 a4 10 00 	movl   $0x10a4d7,(%esp)
  101c56:	e8 6f e6 ff ff       	call   1002ca <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5e:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101c62:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c66:	c7 04 24 ea a4 10 00 	movl   $0x10a4ea,(%esp)
  101c6d:	e8 58 e6 ff ff       	call   1002ca <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101c72:	8b 45 08             	mov    0x8(%ebp),%eax
  101c75:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101c79:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7d:	c7 04 24 fd a4 10 00 	movl   $0x10a4fd,(%esp)
  101c84:	e8 41 e6 ff ff       	call   1002ca <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101c89:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8c:	8b 40 30             	mov    0x30(%eax),%eax
  101c8f:	89 04 24             	mov    %eax,(%esp)
  101c92:	e8 20 ff ff ff       	call   101bb7 <trapname>
  101c97:	8b 55 08             	mov    0x8(%ebp),%edx
  101c9a:	8b 52 30             	mov    0x30(%edx),%edx
  101c9d:	89 44 24 08          	mov    %eax,0x8(%esp)
  101ca1:	89 54 24 04          	mov    %edx,0x4(%esp)
  101ca5:	c7 04 24 10 a5 10 00 	movl   $0x10a510,(%esp)
  101cac:	e8 19 e6 ff ff       	call   1002ca <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb4:	8b 40 34             	mov    0x34(%eax),%eax
  101cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbb:	c7 04 24 22 a5 10 00 	movl   $0x10a522,(%esp)
  101cc2:	e8 03 e6 ff ff       	call   1002ca <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101cca:	8b 40 38             	mov    0x38(%eax),%eax
  101ccd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd1:	c7 04 24 31 a5 10 00 	movl   $0x10a531,(%esp)
  101cd8:	e8 ed e5 ff ff       	call   1002ca <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ce4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce8:	c7 04 24 40 a5 10 00 	movl   $0x10a540,(%esp)
  101cef:	e8 d6 e5 ff ff       	call   1002ca <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf7:	8b 40 40             	mov    0x40(%eax),%eax
  101cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfe:	c7 04 24 53 a5 10 00 	movl   $0x10a553,(%esp)
  101d05:	e8 c0 e5 ff ff       	call   1002ca <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101d0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101d11:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101d18:	eb 3d                	jmp    101d57 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1d:	8b 50 40             	mov    0x40(%eax),%edx
  101d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101d23:	21 d0                	and    %edx,%eax
  101d25:	85 c0                	test   %eax,%eax
  101d27:	74 28                	je     101d51 <print_trapframe+0x14c>
  101d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d2c:	8b 04 85 80 05 12 00 	mov    0x120580(,%eax,4),%eax
  101d33:	85 c0                	test   %eax,%eax
  101d35:	74 1a                	je     101d51 <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d3a:	8b 04 85 80 05 12 00 	mov    0x120580(,%eax,4),%eax
  101d41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d45:	c7 04 24 62 a5 10 00 	movl   $0x10a562,(%esp)
  101d4c:	e8 79 e5 ff ff       	call   1002ca <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101d51:	ff 45 f4             	incl   -0xc(%ebp)
  101d54:	d1 65 f0             	shll   -0x10(%ebp)
  101d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101d5a:	83 f8 17             	cmp    $0x17,%eax
  101d5d:	76 bb                	jbe    101d1a <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d62:	8b 40 40             	mov    0x40(%eax),%eax
  101d65:	c1 e8 0c             	shr    $0xc,%eax
  101d68:	83 e0 03             	and    $0x3,%eax
  101d6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d6f:	c7 04 24 66 a5 10 00 	movl   $0x10a566,(%esp)
  101d76:	e8 4f e5 ff ff       	call   1002ca <cprintf>

    if (!trap_in_kernel(tf)) {
  101d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d7e:	89 04 24             	mov    %eax,(%esp)
  101d81:	e8 66 fe ff ff       	call   101bec <trap_in_kernel>
  101d86:	85 c0                	test   %eax,%eax
  101d88:	75 2d                	jne    101db7 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8d:	8b 40 44             	mov    0x44(%eax),%eax
  101d90:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d94:	c7 04 24 6f a5 10 00 	movl   $0x10a56f,(%esp)
  101d9b:	e8 2a e5 ff ff       	call   1002ca <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101da0:	8b 45 08             	mov    0x8(%ebp),%eax
  101da3:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101da7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dab:	c7 04 24 7e a5 10 00 	movl   $0x10a57e,(%esp)
  101db2:	e8 13 e5 ff ff       	call   1002ca <cprintf>
    }
}
  101db7:	90                   	nop
  101db8:	c9                   	leave  
  101db9:	c3                   	ret    

00101dba <print_regs>:

void
print_regs(struct pushregs *regs) {
  101dba:	f3 0f 1e fb          	endbr32 
  101dbe:	55                   	push   %ebp
  101dbf:	89 e5                	mov    %esp,%ebp
  101dc1:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc7:	8b 00                	mov    (%eax),%eax
  101dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dcd:	c7 04 24 91 a5 10 00 	movl   $0x10a591,(%esp)
  101dd4:	e8 f1 e4 ff ff       	call   1002ca <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  101ddc:	8b 40 04             	mov    0x4(%eax),%eax
  101ddf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101de3:	c7 04 24 a0 a5 10 00 	movl   $0x10a5a0,(%esp)
  101dea:	e8 db e4 ff ff       	call   1002ca <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101def:	8b 45 08             	mov    0x8(%ebp),%eax
  101df2:	8b 40 08             	mov    0x8(%eax),%eax
  101df5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101df9:	c7 04 24 af a5 10 00 	movl   $0x10a5af,(%esp)
  101e00:	e8 c5 e4 ff ff       	call   1002ca <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101e05:	8b 45 08             	mov    0x8(%ebp),%eax
  101e08:	8b 40 0c             	mov    0xc(%eax),%eax
  101e0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e0f:	c7 04 24 be a5 10 00 	movl   $0x10a5be,(%esp)
  101e16:	e8 af e4 ff ff       	call   1002ca <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1e:	8b 40 10             	mov    0x10(%eax),%eax
  101e21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e25:	c7 04 24 cd a5 10 00 	movl   $0x10a5cd,(%esp)
  101e2c:	e8 99 e4 ff ff       	call   1002ca <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101e31:	8b 45 08             	mov    0x8(%ebp),%eax
  101e34:	8b 40 14             	mov    0x14(%eax),%eax
  101e37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e3b:	c7 04 24 dc a5 10 00 	movl   $0x10a5dc,(%esp)
  101e42:	e8 83 e4 ff ff       	call   1002ca <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101e47:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4a:	8b 40 18             	mov    0x18(%eax),%eax
  101e4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e51:	c7 04 24 eb a5 10 00 	movl   $0x10a5eb,(%esp)
  101e58:	e8 6d e4 ff ff       	call   1002ca <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e60:	8b 40 1c             	mov    0x1c(%eax),%eax
  101e63:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e67:	c7 04 24 fa a5 10 00 	movl   $0x10a5fa,(%esp)
  101e6e:	e8 57 e4 ff ff       	call   1002ca <cprintf>
}
  101e73:	90                   	nop
  101e74:	c9                   	leave  
  101e75:	c3                   	ret    

00101e76 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101e76:	f3 0f 1e fb          	endbr32 
  101e7a:	55                   	push   %ebp
  101e7b:	89 e5                	mov    %esp,%ebp
  101e7d:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101e80:	8b 45 08             	mov    0x8(%ebp),%eax
  101e83:	8b 40 30             	mov    0x30(%eax),%eax
  101e86:	83 f8 79             	cmp    $0x79,%eax
  101e89:	0f 84 06 02 00 00    	je     102095 <trap_dispatch+0x21f>
  101e8f:	83 f8 79             	cmp    $0x79,%eax
  101e92:	0f 87 4e 02 00 00    	ja     1020e6 <trap_dispatch+0x270>
  101e98:	83 f8 78             	cmp    $0x78,%eax
  101e9b:	0f 84 92 01 00 00    	je     102033 <trap_dispatch+0x1bd>
  101ea1:	83 f8 78             	cmp    $0x78,%eax
  101ea4:	0f 87 3c 02 00 00    	ja     1020e6 <trap_dispatch+0x270>
  101eaa:	83 f8 2f             	cmp    $0x2f,%eax
  101ead:	0f 87 33 02 00 00    	ja     1020e6 <trap_dispatch+0x270>
  101eb3:	83 f8 2e             	cmp    $0x2e,%eax
  101eb6:	0f 83 5f 02 00 00    	jae    10211b <trap_dispatch+0x2a5>
  101ebc:	83 f8 24             	cmp    $0x24,%eax
  101ebf:	74 5e                	je     101f1f <trap_dispatch+0xa9>
  101ec1:	83 f8 24             	cmp    $0x24,%eax
  101ec4:	0f 87 1c 02 00 00    	ja     1020e6 <trap_dispatch+0x270>
  101eca:	83 f8 20             	cmp    $0x20,%eax
  101ecd:	74 0a                	je     101ed9 <trap_dispatch+0x63>
  101ecf:	83 f8 21             	cmp    $0x21,%eax
  101ed2:	74 74                	je     101f48 <trap_dispatch+0xd2>
  101ed4:	e9 0d 02 00 00       	jmp    1020e6 <trap_dispatch+0x270>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a function, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++; // (1)
  101ed9:	a1 28 3f 12 00       	mov    0x123f28,%eax
  101ede:	40                   	inc    %eax
  101edf:	a3 28 3f 12 00       	mov    %eax,0x123f28
        if (ticks % TICK_NUM == 0) {
  101ee4:	8b 0d 28 3f 12 00    	mov    0x123f28,%ecx
  101eea:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101eef:	89 c8                	mov    %ecx,%eax
  101ef1:	f7 e2                	mul    %edx
  101ef3:	c1 ea 05             	shr    $0x5,%edx
  101ef6:	89 d0                	mov    %edx,%eax
  101ef8:	c1 e0 02             	shl    $0x2,%eax
  101efb:	01 d0                	add    %edx,%eax
  101efd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101f04:	01 d0                	add    %edx,%eax
  101f06:	c1 e0 02             	shl    $0x2,%eax
  101f09:	29 c1                	sub    %eax,%ecx
  101f0b:	89 ca                	mov    %ecx,%edx
  101f0d:	85 d2                	test   %edx,%edx
  101f0f:	0f 85 09 02 00 00    	jne    10211e <trap_dispatch+0x2a8>
            print_ticks(); // (2)
  101f15:	e8 66 fa ff ff       	call   101980 <print_ticks>
        }
        break;
  101f1a:	e9 ff 01 00 00       	jmp    10211e <trap_dispatch+0x2a8>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101f1f:	e8 ef f7 ff ff       	call   101713 <cons_getc>
  101f24:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101f27:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101f2b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101f2f:	89 54 24 08          	mov    %edx,0x8(%esp)
  101f33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f37:	c7 04 24 09 a6 10 00 	movl   $0x10a609,(%esp)
  101f3e:	e8 87 e3 ff ff       	call   1002ca <cprintf>
        break;
  101f43:	e9 e0 01 00 00       	jmp    102128 <trap_dispatch+0x2b2>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101f48:	e8 c6 f7 ff ff       	call   101713 <cons_getc>
  101f4d:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101f50:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101f54:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101f58:	89 54 24 08          	mov    %edx,0x8(%esp)
  101f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f60:	c7 04 24 1b a6 10 00 	movl   $0x10a61b,(%esp)
  101f67:	e8 5e e3 ff ff       	call   1002ca <cprintf>
        if(c == '0' && (tf->tf_cs & 3) != 0)
  101f6c:	80 7d f7 30          	cmpb   $0x30,-0x9(%ebp)
  101f70:	75 52                	jne    101fc4 <trap_dispatch+0x14e>
  101f72:	8b 45 08             	mov    0x8(%ebp),%eax
  101f75:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f79:	83 e0 03             	and    $0x3,%eax
  101f7c:	85 c0                	test   %eax,%eax
  101f7e:	74 44                	je     101fc4 <trap_dispatch+0x14e>
        {
                cprintf("Input 0......switch to kernel\n");
  101f80:	c7 04 24 2c a6 10 00 	movl   $0x10a62c,(%esp)
  101f87:	e8 3e e3 ff ff       	call   1002ca <cprintf>
                tf->tf_cs = KERNEL_CS;
  101f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f8f:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
                tf->tf_ds = tf->tf_es = KERNEL_DS;
  101f95:	8b 45 08             	mov    0x8(%ebp),%eax
  101f98:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa1:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  101fa8:	66 89 50 2c          	mov    %dx,0x2c(%eax)
                tf->tf_eflags &= ~FL_IOPL_MASK;
  101fac:	8b 45 08             	mov    0x8(%ebp),%eax
  101faf:	8b 40 40             	mov    0x40(%eax),%eax
  101fb2:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101fb7:	89 c2                	mov    %eax,%edx
  101fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101fbc:	89 50 40             	mov    %edx,0x40(%eax)
                cprintf("Input 3......switch to user\n");
                tf->tf_cs = USER_CS;
                tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
                tf->tf_eflags |= FL_IOPL_MASK;
        }
        break;
  101fbf:	e9 5d 01 00 00       	jmp    102121 <trap_dispatch+0x2ab>
        else if (c == '3' && (tf->tf_cs & 3) != 3)
  101fc4:	80 7d f7 33          	cmpb   $0x33,-0x9(%ebp)
  101fc8:	0f 85 53 01 00 00    	jne    102121 <trap_dispatch+0x2ab>
  101fce:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fd5:	83 e0 03             	and    $0x3,%eax
  101fd8:	83 f8 03             	cmp    $0x3,%eax
  101fdb:	0f 84 40 01 00 00    	je     102121 <trap_dispatch+0x2ab>
                cprintf("Input 3......switch to user\n");
  101fe1:	c7 04 24 4b a6 10 00 	movl   $0x10a64b,(%esp)
  101fe8:	e8 dd e2 ff ff       	call   1002ca <cprintf>
                tf->tf_cs = USER_CS;
  101fed:	8b 45 08             	mov    0x8(%ebp),%eax
  101ff0:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
                tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  101ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ff9:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  101fff:	8b 45 08             	mov    0x8(%ebp),%eax
  102002:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  102006:	8b 45 08             	mov    0x8(%ebp),%eax
  102009:	66 89 50 28          	mov    %dx,0x28(%eax)
  10200d:	8b 45 08             	mov    0x8(%ebp),%eax
  102010:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  102014:	8b 45 08             	mov    0x8(%ebp),%eax
  102017:	66 89 50 2c          	mov    %dx,0x2c(%eax)
                tf->tf_eflags |= FL_IOPL_MASK;
  10201b:	8b 45 08             	mov    0x8(%ebp),%eax
  10201e:	8b 40 40             	mov    0x40(%eax),%eax
  102021:	0d 00 30 00 00       	or     $0x3000,%eax
  102026:	89 c2                	mov    %eax,%edx
  102028:	8b 45 08             	mov    0x8(%ebp),%eax
  10202b:	89 50 40             	mov    %edx,0x40(%eax)
        break;
  10202e:	e9 ee 00 00 00       	jmp    102121 <trap_dispatch+0x2ab>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
 	case T_SWITCH_TOU:
        if(tf->tf_cs != USER_CS)	//检查是不是用户态，不是就操作
  102033:	8b 45 08             	mov    0x8(%ebp),%eax
  102036:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10203a:	83 f8 1b             	cmp    $0x1b,%eax
  10203d:	0f 84 e1 00 00 00    	je     102124 <trap_dispatch+0x2ae>
        {
                cprintf("Switch to user\n");
  102043:	c7 04 24 68 a6 10 00 	movl   $0x10a668,(%esp)
  10204a:	e8 7b e2 ff ff       	call   1002ca <cprintf>
                // 设置用户态对应的cs,ds,es,ss四个寄存器
            	tf->tf_cs = USER_CS;
  10204f:	8b 45 08             	mov    0x8(%ebp),%eax
  102052:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
                tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
  102058:	8b 45 08             	mov    0x8(%ebp),%eax
  10205b:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
  102061:	8b 45 08             	mov    0x8(%ebp),%eax
  102064:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  102068:	8b 45 08             	mov    0x8(%ebp),%eax
  10206b:	66 89 50 28          	mov    %dx,0x28(%eax)
  10206f:	8b 45 08             	mov    0x8(%ebp),%eax
  102072:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  102076:	8b 45 08             	mov    0x8(%ebp),%eax
  102079:	66 89 50 2c          	mov    %dx,0x2c(%eax)
                // 降低IO权限，使用户态可以使用IO
                tf->tf_eflags |= FL_IOPL_MASK;
  10207d:	8b 45 08             	mov    0x8(%ebp),%eax
  102080:	8b 40 40             	mov    0x40(%eax),%eax
  102083:	0d 00 30 00 00       	or     $0x3000,%eax
  102088:	89 c2                	mov    %eax,%edx
  10208a:	8b 45 08             	mov    0x8(%ebp),%eax
  10208d:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  102090:	e9 8f 00 00 00       	jmp    102124 <trap_dispatch+0x2ae>

	case T_SWITCH_TOK:
        if(tf->tf_cs != KERNEL_CS)	//检查是不是内核态，不是就操作
  102095:	8b 45 08             	mov    0x8(%ebp),%eax
  102098:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10209c:	83 f8 08             	cmp    $0x8,%eax
  10209f:	0f 84 82 00 00 00    	je     102127 <trap_dispatch+0x2b1>
        {          
                cprintf("Switch to kernel\n");
  1020a5:	c7 04 24 78 a6 10 00 	movl   $0x10a678,(%esp)
  1020ac:	e8 19 e2 ff ff       	call   1002ca <cprintf>
            	// 设置内核态对应的cs,ds,es三个寄存器
                tf->tf_cs = KERNEL_CS;
  1020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1020b4:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
                tf->tf_ds = tf->tf_es = KERNEL_DS;
  1020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1020bd:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  1020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1020c6:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  1020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1020cd:	66 89 50 2c          	mov    %dx,0x2c(%eax)
				// 用户态不再能使用I/O
                tf->tf_eflags &= ~FL_IOPL_MASK;
  1020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1020d4:	8b 40 40             	mov    0x40(%eax),%eax
  1020d7:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  1020dc:	89 c2                	mov    %eax,%edx
  1020de:	8b 45 08             	mov    0x8(%ebp),%eax
  1020e1:	89 50 40             	mov    %edx,0x40(%eax)
        }
        break;
  1020e4:	eb 41                	jmp    102127 <trap_dispatch+0x2b1>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  1020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1020e9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1020ed:	83 e0 03             	and    $0x3,%eax
  1020f0:	85 c0                	test   %eax,%eax
  1020f2:	75 34                	jne    102128 <trap_dispatch+0x2b2>
            print_trapframe(tf);
  1020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1020f7:	89 04 24             	mov    %eax,(%esp)
  1020fa:	e8 06 fb ff ff       	call   101c05 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  1020ff:	c7 44 24 08 8a a6 10 	movl   $0x10a68a,0x8(%esp)
  102106:	00 
  102107:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  10210e:	00 
  10210f:	c7 04 24 4e a4 10 00 	movl   $0x10a44e,(%esp)
  102116:	e8 1b e3 ff ff       	call   100436 <__panic>
        break;
  10211b:	90                   	nop
  10211c:	eb 0a                	jmp    102128 <trap_dispatch+0x2b2>
        break;
  10211e:	90                   	nop
  10211f:	eb 07                	jmp    102128 <trap_dispatch+0x2b2>
        break;
  102121:	90                   	nop
  102122:	eb 04                	jmp    102128 <trap_dispatch+0x2b2>
        break;
  102124:	90                   	nop
  102125:	eb 01                	jmp    102128 <trap_dispatch+0x2b2>
        break;
  102127:	90                   	nop
        }
    }
}
  102128:	90                   	nop
  102129:	c9                   	leave  
  10212a:	c3                   	ret    

0010212b <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  10212b:	f3 0f 1e fb          	endbr32 
  10212f:	55                   	push   %ebp
  102130:	89 e5                	mov    %esp,%ebp
  102132:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  102135:	8b 45 08             	mov    0x8(%ebp),%eax
  102138:	89 04 24             	mov    %eax,(%esp)
  10213b:	e8 36 fd ff ff       	call   101e76 <trap_dispatch>
}
  102140:	90                   	nop
  102141:	c9                   	leave  
  102142:	c3                   	ret    

00102143 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $0
  102145:	6a 00                	push   $0x0
  jmp __alltraps
  102147:	e9 69 0a 00 00       	jmp    102bb5 <__alltraps>

0010214c <vector1>:
.globl vector1
vector1:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $1
  10214e:	6a 01                	push   $0x1
  jmp __alltraps
  102150:	e9 60 0a 00 00       	jmp    102bb5 <__alltraps>

00102155 <vector2>:
.globl vector2
vector2:
  pushl $0
  102155:	6a 00                	push   $0x0
  pushl $2
  102157:	6a 02                	push   $0x2
  jmp __alltraps
  102159:	e9 57 0a 00 00       	jmp    102bb5 <__alltraps>

0010215e <vector3>:
.globl vector3
vector3:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $3
  102160:	6a 03                	push   $0x3
  jmp __alltraps
  102162:	e9 4e 0a 00 00       	jmp    102bb5 <__alltraps>

00102167 <vector4>:
.globl vector4
vector4:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $4
  102169:	6a 04                	push   $0x4
  jmp __alltraps
  10216b:	e9 45 0a 00 00       	jmp    102bb5 <__alltraps>

00102170 <vector5>:
.globl vector5
vector5:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $5
  102172:	6a 05                	push   $0x5
  jmp __alltraps
  102174:	e9 3c 0a 00 00       	jmp    102bb5 <__alltraps>

00102179 <vector6>:
.globl vector6
vector6:
  pushl $0
  102179:	6a 00                	push   $0x0
  pushl $6
  10217b:	6a 06                	push   $0x6
  jmp __alltraps
  10217d:	e9 33 0a 00 00       	jmp    102bb5 <__alltraps>

00102182 <vector7>:
.globl vector7
vector7:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $7
  102184:	6a 07                	push   $0x7
  jmp __alltraps
  102186:	e9 2a 0a 00 00       	jmp    102bb5 <__alltraps>

0010218b <vector8>:
.globl vector8
vector8:
  pushl $8
  10218b:	6a 08                	push   $0x8
  jmp __alltraps
  10218d:	e9 23 0a 00 00       	jmp    102bb5 <__alltraps>

00102192 <vector9>:
.globl vector9
vector9:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $9
  102194:	6a 09                	push   $0x9
  jmp __alltraps
  102196:	e9 1a 0a 00 00       	jmp    102bb5 <__alltraps>

0010219b <vector10>:
.globl vector10
vector10:
  pushl $10
  10219b:	6a 0a                	push   $0xa
  jmp __alltraps
  10219d:	e9 13 0a 00 00       	jmp    102bb5 <__alltraps>

001021a2 <vector11>:
.globl vector11
vector11:
  pushl $11
  1021a2:	6a 0b                	push   $0xb
  jmp __alltraps
  1021a4:	e9 0c 0a 00 00       	jmp    102bb5 <__alltraps>

001021a9 <vector12>:
.globl vector12
vector12:
  pushl $12
  1021a9:	6a 0c                	push   $0xc
  jmp __alltraps
  1021ab:	e9 05 0a 00 00       	jmp    102bb5 <__alltraps>

001021b0 <vector13>:
.globl vector13
vector13:
  pushl $13
  1021b0:	6a 0d                	push   $0xd
  jmp __alltraps
  1021b2:	e9 fe 09 00 00       	jmp    102bb5 <__alltraps>

001021b7 <vector14>:
.globl vector14
vector14:
  pushl $14
  1021b7:	6a 0e                	push   $0xe
  jmp __alltraps
  1021b9:	e9 f7 09 00 00       	jmp    102bb5 <__alltraps>

001021be <vector15>:
.globl vector15
vector15:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $15
  1021c0:	6a 0f                	push   $0xf
  jmp __alltraps
  1021c2:	e9 ee 09 00 00       	jmp    102bb5 <__alltraps>

001021c7 <vector16>:
.globl vector16
vector16:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $16
  1021c9:	6a 10                	push   $0x10
  jmp __alltraps
  1021cb:	e9 e5 09 00 00       	jmp    102bb5 <__alltraps>

001021d0 <vector17>:
.globl vector17
vector17:
  pushl $17
  1021d0:	6a 11                	push   $0x11
  jmp __alltraps
  1021d2:	e9 de 09 00 00       	jmp    102bb5 <__alltraps>

001021d7 <vector18>:
.globl vector18
vector18:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $18
  1021d9:	6a 12                	push   $0x12
  jmp __alltraps
  1021db:	e9 d5 09 00 00       	jmp    102bb5 <__alltraps>

001021e0 <vector19>:
.globl vector19
vector19:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $19
  1021e2:	6a 13                	push   $0x13
  jmp __alltraps
  1021e4:	e9 cc 09 00 00       	jmp    102bb5 <__alltraps>

001021e9 <vector20>:
.globl vector20
vector20:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $20
  1021eb:	6a 14                	push   $0x14
  jmp __alltraps
  1021ed:	e9 c3 09 00 00       	jmp    102bb5 <__alltraps>

001021f2 <vector21>:
.globl vector21
vector21:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $21
  1021f4:	6a 15                	push   $0x15
  jmp __alltraps
  1021f6:	e9 ba 09 00 00       	jmp    102bb5 <__alltraps>

001021fb <vector22>:
.globl vector22
vector22:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $22
  1021fd:	6a 16                	push   $0x16
  jmp __alltraps
  1021ff:	e9 b1 09 00 00       	jmp    102bb5 <__alltraps>

00102204 <vector23>:
.globl vector23
vector23:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $23
  102206:	6a 17                	push   $0x17
  jmp __alltraps
  102208:	e9 a8 09 00 00       	jmp    102bb5 <__alltraps>

0010220d <vector24>:
.globl vector24
vector24:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $24
  10220f:	6a 18                	push   $0x18
  jmp __alltraps
  102211:	e9 9f 09 00 00       	jmp    102bb5 <__alltraps>

00102216 <vector25>:
.globl vector25
vector25:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $25
  102218:	6a 19                	push   $0x19
  jmp __alltraps
  10221a:	e9 96 09 00 00       	jmp    102bb5 <__alltraps>

0010221f <vector26>:
.globl vector26
vector26:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $26
  102221:	6a 1a                	push   $0x1a
  jmp __alltraps
  102223:	e9 8d 09 00 00       	jmp    102bb5 <__alltraps>

00102228 <vector27>:
.globl vector27
vector27:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $27
  10222a:	6a 1b                	push   $0x1b
  jmp __alltraps
  10222c:	e9 84 09 00 00       	jmp    102bb5 <__alltraps>

00102231 <vector28>:
.globl vector28
vector28:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $28
  102233:	6a 1c                	push   $0x1c
  jmp __alltraps
  102235:	e9 7b 09 00 00       	jmp    102bb5 <__alltraps>

0010223a <vector29>:
.globl vector29
vector29:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $29
  10223c:	6a 1d                	push   $0x1d
  jmp __alltraps
  10223e:	e9 72 09 00 00       	jmp    102bb5 <__alltraps>

00102243 <vector30>:
.globl vector30
vector30:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $30
  102245:	6a 1e                	push   $0x1e
  jmp __alltraps
  102247:	e9 69 09 00 00       	jmp    102bb5 <__alltraps>

0010224c <vector31>:
.globl vector31
vector31:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $31
  10224e:	6a 1f                	push   $0x1f
  jmp __alltraps
  102250:	e9 60 09 00 00       	jmp    102bb5 <__alltraps>

00102255 <vector32>:
.globl vector32
vector32:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $32
  102257:	6a 20                	push   $0x20
  jmp __alltraps
  102259:	e9 57 09 00 00       	jmp    102bb5 <__alltraps>

0010225e <vector33>:
.globl vector33
vector33:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $33
  102260:	6a 21                	push   $0x21
  jmp __alltraps
  102262:	e9 4e 09 00 00       	jmp    102bb5 <__alltraps>

00102267 <vector34>:
.globl vector34
vector34:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $34
  102269:	6a 22                	push   $0x22
  jmp __alltraps
  10226b:	e9 45 09 00 00       	jmp    102bb5 <__alltraps>

00102270 <vector35>:
.globl vector35
vector35:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $35
  102272:	6a 23                	push   $0x23
  jmp __alltraps
  102274:	e9 3c 09 00 00       	jmp    102bb5 <__alltraps>

00102279 <vector36>:
.globl vector36
vector36:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $36
  10227b:	6a 24                	push   $0x24
  jmp __alltraps
  10227d:	e9 33 09 00 00       	jmp    102bb5 <__alltraps>

00102282 <vector37>:
.globl vector37
vector37:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $37
  102284:	6a 25                	push   $0x25
  jmp __alltraps
  102286:	e9 2a 09 00 00       	jmp    102bb5 <__alltraps>

0010228b <vector38>:
.globl vector38
vector38:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $38
  10228d:	6a 26                	push   $0x26
  jmp __alltraps
  10228f:	e9 21 09 00 00       	jmp    102bb5 <__alltraps>

00102294 <vector39>:
.globl vector39
vector39:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $39
  102296:	6a 27                	push   $0x27
  jmp __alltraps
  102298:	e9 18 09 00 00       	jmp    102bb5 <__alltraps>

0010229d <vector40>:
.globl vector40
vector40:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $40
  10229f:	6a 28                	push   $0x28
  jmp __alltraps
  1022a1:	e9 0f 09 00 00       	jmp    102bb5 <__alltraps>

001022a6 <vector41>:
.globl vector41
vector41:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $41
  1022a8:	6a 29                	push   $0x29
  jmp __alltraps
  1022aa:	e9 06 09 00 00       	jmp    102bb5 <__alltraps>

001022af <vector42>:
.globl vector42
vector42:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $42
  1022b1:	6a 2a                	push   $0x2a
  jmp __alltraps
  1022b3:	e9 fd 08 00 00       	jmp    102bb5 <__alltraps>

001022b8 <vector43>:
.globl vector43
vector43:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $43
  1022ba:	6a 2b                	push   $0x2b
  jmp __alltraps
  1022bc:	e9 f4 08 00 00       	jmp    102bb5 <__alltraps>

001022c1 <vector44>:
.globl vector44
vector44:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $44
  1022c3:	6a 2c                	push   $0x2c
  jmp __alltraps
  1022c5:	e9 eb 08 00 00       	jmp    102bb5 <__alltraps>

001022ca <vector45>:
.globl vector45
vector45:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $45
  1022cc:	6a 2d                	push   $0x2d
  jmp __alltraps
  1022ce:	e9 e2 08 00 00       	jmp    102bb5 <__alltraps>

001022d3 <vector46>:
.globl vector46
vector46:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $46
  1022d5:	6a 2e                	push   $0x2e
  jmp __alltraps
  1022d7:	e9 d9 08 00 00       	jmp    102bb5 <__alltraps>

001022dc <vector47>:
.globl vector47
vector47:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $47
  1022de:	6a 2f                	push   $0x2f
  jmp __alltraps
  1022e0:	e9 d0 08 00 00       	jmp    102bb5 <__alltraps>

001022e5 <vector48>:
.globl vector48
vector48:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $48
  1022e7:	6a 30                	push   $0x30
  jmp __alltraps
  1022e9:	e9 c7 08 00 00       	jmp    102bb5 <__alltraps>

001022ee <vector49>:
.globl vector49
vector49:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $49
  1022f0:	6a 31                	push   $0x31
  jmp __alltraps
  1022f2:	e9 be 08 00 00       	jmp    102bb5 <__alltraps>

001022f7 <vector50>:
.globl vector50
vector50:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $50
  1022f9:	6a 32                	push   $0x32
  jmp __alltraps
  1022fb:	e9 b5 08 00 00       	jmp    102bb5 <__alltraps>

00102300 <vector51>:
.globl vector51
vector51:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $51
  102302:	6a 33                	push   $0x33
  jmp __alltraps
  102304:	e9 ac 08 00 00       	jmp    102bb5 <__alltraps>

00102309 <vector52>:
.globl vector52
vector52:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $52
  10230b:	6a 34                	push   $0x34
  jmp __alltraps
  10230d:	e9 a3 08 00 00       	jmp    102bb5 <__alltraps>

00102312 <vector53>:
.globl vector53
vector53:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $53
  102314:	6a 35                	push   $0x35
  jmp __alltraps
  102316:	e9 9a 08 00 00       	jmp    102bb5 <__alltraps>

0010231b <vector54>:
.globl vector54
vector54:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $54
  10231d:	6a 36                	push   $0x36
  jmp __alltraps
  10231f:	e9 91 08 00 00       	jmp    102bb5 <__alltraps>

00102324 <vector55>:
.globl vector55
vector55:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $55
  102326:	6a 37                	push   $0x37
  jmp __alltraps
  102328:	e9 88 08 00 00       	jmp    102bb5 <__alltraps>

0010232d <vector56>:
.globl vector56
vector56:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $56
  10232f:	6a 38                	push   $0x38
  jmp __alltraps
  102331:	e9 7f 08 00 00       	jmp    102bb5 <__alltraps>

00102336 <vector57>:
.globl vector57
vector57:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $57
  102338:	6a 39                	push   $0x39
  jmp __alltraps
  10233a:	e9 76 08 00 00       	jmp    102bb5 <__alltraps>

0010233f <vector58>:
.globl vector58
vector58:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $58
  102341:	6a 3a                	push   $0x3a
  jmp __alltraps
  102343:	e9 6d 08 00 00       	jmp    102bb5 <__alltraps>

00102348 <vector59>:
.globl vector59
vector59:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $59
  10234a:	6a 3b                	push   $0x3b
  jmp __alltraps
  10234c:	e9 64 08 00 00       	jmp    102bb5 <__alltraps>

00102351 <vector60>:
.globl vector60
vector60:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $60
  102353:	6a 3c                	push   $0x3c
  jmp __alltraps
  102355:	e9 5b 08 00 00       	jmp    102bb5 <__alltraps>

0010235a <vector61>:
.globl vector61
vector61:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $61
  10235c:	6a 3d                	push   $0x3d
  jmp __alltraps
  10235e:	e9 52 08 00 00       	jmp    102bb5 <__alltraps>

00102363 <vector62>:
.globl vector62
vector62:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $62
  102365:	6a 3e                	push   $0x3e
  jmp __alltraps
  102367:	e9 49 08 00 00       	jmp    102bb5 <__alltraps>

0010236c <vector63>:
.globl vector63
vector63:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $63
  10236e:	6a 3f                	push   $0x3f
  jmp __alltraps
  102370:	e9 40 08 00 00       	jmp    102bb5 <__alltraps>

00102375 <vector64>:
.globl vector64
vector64:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $64
  102377:	6a 40                	push   $0x40
  jmp __alltraps
  102379:	e9 37 08 00 00       	jmp    102bb5 <__alltraps>

0010237e <vector65>:
.globl vector65
vector65:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $65
  102380:	6a 41                	push   $0x41
  jmp __alltraps
  102382:	e9 2e 08 00 00       	jmp    102bb5 <__alltraps>

00102387 <vector66>:
.globl vector66
vector66:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $66
  102389:	6a 42                	push   $0x42
  jmp __alltraps
  10238b:	e9 25 08 00 00       	jmp    102bb5 <__alltraps>

00102390 <vector67>:
.globl vector67
vector67:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $67
  102392:	6a 43                	push   $0x43
  jmp __alltraps
  102394:	e9 1c 08 00 00       	jmp    102bb5 <__alltraps>

00102399 <vector68>:
.globl vector68
vector68:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $68
  10239b:	6a 44                	push   $0x44
  jmp __alltraps
  10239d:	e9 13 08 00 00       	jmp    102bb5 <__alltraps>

001023a2 <vector69>:
.globl vector69
vector69:
  pushl $0
  1023a2:	6a 00                	push   $0x0
  pushl $69
  1023a4:	6a 45                	push   $0x45
  jmp __alltraps
  1023a6:	e9 0a 08 00 00       	jmp    102bb5 <__alltraps>

001023ab <vector70>:
.globl vector70
vector70:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $70
  1023ad:	6a 46                	push   $0x46
  jmp __alltraps
  1023af:	e9 01 08 00 00       	jmp    102bb5 <__alltraps>

001023b4 <vector71>:
.globl vector71
vector71:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $71
  1023b6:	6a 47                	push   $0x47
  jmp __alltraps
  1023b8:	e9 f8 07 00 00       	jmp    102bb5 <__alltraps>

001023bd <vector72>:
.globl vector72
vector72:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $72
  1023bf:	6a 48                	push   $0x48
  jmp __alltraps
  1023c1:	e9 ef 07 00 00       	jmp    102bb5 <__alltraps>

001023c6 <vector73>:
.globl vector73
vector73:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $73
  1023c8:	6a 49                	push   $0x49
  jmp __alltraps
  1023ca:	e9 e6 07 00 00       	jmp    102bb5 <__alltraps>

001023cf <vector74>:
.globl vector74
vector74:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $74
  1023d1:	6a 4a                	push   $0x4a
  jmp __alltraps
  1023d3:	e9 dd 07 00 00       	jmp    102bb5 <__alltraps>

001023d8 <vector75>:
.globl vector75
vector75:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $75
  1023da:	6a 4b                	push   $0x4b
  jmp __alltraps
  1023dc:	e9 d4 07 00 00       	jmp    102bb5 <__alltraps>

001023e1 <vector76>:
.globl vector76
vector76:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $76
  1023e3:	6a 4c                	push   $0x4c
  jmp __alltraps
  1023e5:	e9 cb 07 00 00       	jmp    102bb5 <__alltraps>

001023ea <vector77>:
.globl vector77
vector77:
  pushl $0
  1023ea:	6a 00                	push   $0x0
  pushl $77
  1023ec:	6a 4d                	push   $0x4d
  jmp __alltraps
  1023ee:	e9 c2 07 00 00       	jmp    102bb5 <__alltraps>

001023f3 <vector78>:
.globl vector78
vector78:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $78
  1023f5:	6a 4e                	push   $0x4e
  jmp __alltraps
  1023f7:	e9 b9 07 00 00       	jmp    102bb5 <__alltraps>

001023fc <vector79>:
.globl vector79
vector79:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $79
  1023fe:	6a 4f                	push   $0x4f
  jmp __alltraps
  102400:	e9 b0 07 00 00       	jmp    102bb5 <__alltraps>

00102405 <vector80>:
.globl vector80
vector80:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $80
  102407:	6a 50                	push   $0x50
  jmp __alltraps
  102409:	e9 a7 07 00 00       	jmp    102bb5 <__alltraps>

0010240e <vector81>:
.globl vector81
vector81:
  pushl $0
  10240e:	6a 00                	push   $0x0
  pushl $81
  102410:	6a 51                	push   $0x51
  jmp __alltraps
  102412:	e9 9e 07 00 00       	jmp    102bb5 <__alltraps>

00102417 <vector82>:
.globl vector82
vector82:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $82
  102419:	6a 52                	push   $0x52
  jmp __alltraps
  10241b:	e9 95 07 00 00       	jmp    102bb5 <__alltraps>

00102420 <vector83>:
.globl vector83
vector83:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $83
  102422:	6a 53                	push   $0x53
  jmp __alltraps
  102424:	e9 8c 07 00 00       	jmp    102bb5 <__alltraps>

00102429 <vector84>:
.globl vector84
vector84:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $84
  10242b:	6a 54                	push   $0x54
  jmp __alltraps
  10242d:	e9 83 07 00 00       	jmp    102bb5 <__alltraps>

00102432 <vector85>:
.globl vector85
vector85:
  pushl $0
  102432:	6a 00                	push   $0x0
  pushl $85
  102434:	6a 55                	push   $0x55
  jmp __alltraps
  102436:	e9 7a 07 00 00       	jmp    102bb5 <__alltraps>

0010243b <vector86>:
.globl vector86
vector86:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $86
  10243d:	6a 56                	push   $0x56
  jmp __alltraps
  10243f:	e9 71 07 00 00       	jmp    102bb5 <__alltraps>

00102444 <vector87>:
.globl vector87
vector87:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $87
  102446:	6a 57                	push   $0x57
  jmp __alltraps
  102448:	e9 68 07 00 00       	jmp    102bb5 <__alltraps>

0010244d <vector88>:
.globl vector88
vector88:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $88
  10244f:	6a 58                	push   $0x58
  jmp __alltraps
  102451:	e9 5f 07 00 00       	jmp    102bb5 <__alltraps>

00102456 <vector89>:
.globl vector89
vector89:
  pushl $0
  102456:	6a 00                	push   $0x0
  pushl $89
  102458:	6a 59                	push   $0x59
  jmp __alltraps
  10245a:	e9 56 07 00 00       	jmp    102bb5 <__alltraps>

0010245f <vector90>:
.globl vector90
vector90:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $90
  102461:	6a 5a                	push   $0x5a
  jmp __alltraps
  102463:	e9 4d 07 00 00       	jmp    102bb5 <__alltraps>

00102468 <vector91>:
.globl vector91
vector91:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $91
  10246a:	6a 5b                	push   $0x5b
  jmp __alltraps
  10246c:	e9 44 07 00 00       	jmp    102bb5 <__alltraps>

00102471 <vector92>:
.globl vector92
vector92:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $92
  102473:	6a 5c                	push   $0x5c
  jmp __alltraps
  102475:	e9 3b 07 00 00       	jmp    102bb5 <__alltraps>

0010247a <vector93>:
.globl vector93
vector93:
  pushl $0
  10247a:	6a 00                	push   $0x0
  pushl $93
  10247c:	6a 5d                	push   $0x5d
  jmp __alltraps
  10247e:	e9 32 07 00 00       	jmp    102bb5 <__alltraps>

00102483 <vector94>:
.globl vector94
vector94:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $94
  102485:	6a 5e                	push   $0x5e
  jmp __alltraps
  102487:	e9 29 07 00 00       	jmp    102bb5 <__alltraps>

0010248c <vector95>:
.globl vector95
vector95:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $95
  10248e:	6a 5f                	push   $0x5f
  jmp __alltraps
  102490:	e9 20 07 00 00       	jmp    102bb5 <__alltraps>

00102495 <vector96>:
.globl vector96
vector96:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $96
  102497:	6a 60                	push   $0x60
  jmp __alltraps
  102499:	e9 17 07 00 00       	jmp    102bb5 <__alltraps>

0010249e <vector97>:
.globl vector97
vector97:
  pushl $0
  10249e:	6a 00                	push   $0x0
  pushl $97
  1024a0:	6a 61                	push   $0x61
  jmp __alltraps
  1024a2:	e9 0e 07 00 00       	jmp    102bb5 <__alltraps>

001024a7 <vector98>:
.globl vector98
vector98:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $98
  1024a9:	6a 62                	push   $0x62
  jmp __alltraps
  1024ab:	e9 05 07 00 00       	jmp    102bb5 <__alltraps>

001024b0 <vector99>:
.globl vector99
vector99:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $99
  1024b2:	6a 63                	push   $0x63
  jmp __alltraps
  1024b4:	e9 fc 06 00 00       	jmp    102bb5 <__alltraps>

001024b9 <vector100>:
.globl vector100
vector100:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $100
  1024bb:	6a 64                	push   $0x64
  jmp __alltraps
  1024bd:	e9 f3 06 00 00       	jmp    102bb5 <__alltraps>

001024c2 <vector101>:
.globl vector101
vector101:
  pushl $0
  1024c2:	6a 00                	push   $0x0
  pushl $101
  1024c4:	6a 65                	push   $0x65
  jmp __alltraps
  1024c6:	e9 ea 06 00 00       	jmp    102bb5 <__alltraps>

001024cb <vector102>:
.globl vector102
vector102:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $102
  1024cd:	6a 66                	push   $0x66
  jmp __alltraps
  1024cf:	e9 e1 06 00 00       	jmp    102bb5 <__alltraps>

001024d4 <vector103>:
.globl vector103
vector103:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $103
  1024d6:	6a 67                	push   $0x67
  jmp __alltraps
  1024d8:	e9 d8 06 00 00       	jmp    102bb5 <__alltraps>

001024dd <vector104>:
.globl vector104
vector104:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $104
  1024df:	6a 68                	push   $0x68
  jmp __alltraps
  1024e1:	e9 cf 06 00 00       	jmp    102bb5 <__alltraps>

001024e6 <vector105>:
.globl vector105
vector105:
  pushl $0
  1024e6:	6a 00                	push   $0x0
  pushl $105
  1024e8:	6a 69                	push   $0x69
  jmp __alltraps
  1024ea:	e9 c6 06 00 00       	jmp    102bb5 <__alltraps>

001024ef <vector106>:
.globl vector106
vector106:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $106
  1024f1:	6a 6a                	push   $0x6a
  jmp __alltraps
  1024f3:	e9 bd 06 00 00       	jmp    102bb5 <__alltraps>

001024f8 <vector107>:
.globl vector107
vector107:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $107
  1024fa:	6a 6b                	push   $0x6b
  jmp __alltraps
  1024fc:	e9 b4 06 00 00       	jmp    102bb5 <__alltraps>

00102501 <vector108>:
.globl vector108
vector108:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $108
  102503:	6a 6c                	push   $0x6c
  jmp __alltraps
  102505:	e9 ab 06 00 00       	jmp    102bb5 <__alltraps>

0010250a <vector109>:
.globl vector109
vector109:
  pushl $0
  10250a:	6a 00                	push   $0x0
  pushl $109
  10250c:	6a 6d                	push   $0x6d
  jmp __alltraps
  10250e:	e9 a2 06 00 00       	jmp    102bb5 <__alltraps>

00102513 <vector110>:
.globl vector110
vector110:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $110
  102515:	6a 6e                	push   $0x6e
  jmp __alltraps
  102517:	e9 99 06 00 00       	jmp    102bb5 <__alltraps>

0010251c <vector111>:
.globl vector111
vector111:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $111
  10251e:	6a 6f                	push   $0x6f
  jmp __alltraps
  102520:	e9 90 06 00 00       	jmp    102bb5 <__alltraps>

00102525 <vector112>:
.globl vector112
vector112:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $112
  102527:	6a 70                	push   $0x70
  jmp __alltraps
  102529:	e9 87 06 00 00       	jmp    102bb5 <__alltraps>

0010252e <vector113>:
.globl vector113
vector113:
  pushl $0
  10252e:	6a 00                	push   $0x0
  pushl $113
  102530:	6a 71                	push   $0x71
  jmp __alltraps
  102532:	e9 7e 06 00 00       	jmp    102bb5 <__alltraps>

00102537 <vector114>:
.globl vector114
vector114:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $114
  102539:	6a 72                	push   $0x72
  jmp __alltraps
  10253b:	e9 75 06 00 00       	jmp    102bb5 <__alltraps>

00102540 <vector115>:
.globl vector115
vector115:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $115
  102542:	6a 73                	push   $0x73
  jmp __alltraps
  102544:	e9 6c 06 00 00       	jmp    102bb5 <__alltraps>

00102549 <vector116>:
.globl vector116
vector116:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $116
  10254b:	6a 74                	push   $0x74
  jmp __alltraps
  10254d:	e9 63 06 00 00       	jmp    102bb5 <__alltraps>

00102552 <vector117>:
.globl vector117
vector117:
  pushl $0
  102552:	6a 00                	push   $0x0
  pushl $117
  102554:	6a 75                	push   $0x75
  jmp __alltraps
  102556:	e9 5a 06 00 00       	jmp    102bb5 <__alltraps>

0010255b <vector118>:
.globl vector118
vector118:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $118
  10255d:	6a 76                	push   $0x76
  jmp __alltraps
  10255f:	e9 51 06 00 00       	jmp    102bb5 <__alltraps>

00102564 <vector119>:
.globl vector119
vector119:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $119
  102566:	6a 77                	push   $0x77
  jmp __alltraps
  102568:	e9 48 06 00 00       	jmp    102bb5 <__alltraps>

0010256d <vector120>:
.globl vector120
vector120:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $120
  10256f:	6a 78                	push   $0x78
  jmp __alltraps
  102571:	e9 3f 06 00 00       	jmp    102bb5 <__alltraps>

00102576 <vector121>:
.globl vector121
vector121:
  pushl $0
  102576:	6a 00                	push   $0x0
  pushl $121
  102578:	6a 79                	push   $0x79
  jmp __alltraps
  10257a:	e9 36 06 00 00       	jmp    102bb5 <__alltraps>

0010257f <vector122>:
.globl vector122
vector122:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $122
  102581:	6a 7a                	push   $0x7a
  jmp __alltraps
  102583:	e9 2d 06 00 00       	jmp    102bb5 <__alltraps>

00102588 <vector123>:
.globl vector123
vector123:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $123
  10258a:	6a 7b                	push   $0x7b
  jmp __alltraps
  10258c:	e9 24 06 00 00       	jmp    102bb5 <__alltraps>

00102591 <vector124>:
.globl vector124
vector124:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $124
  102593:	6a 7c                	push   $0x7c
  jmp __alltraps
  102595:	e9 1b 06 00 00       	jmp    102bb5 <__alltraps>

0010259a <vector125>:
.globl vector125
vector125:
  pushl $0
  10259a:	6a 00                	push   $0x0
  pushl $125
  10259c:	6a 7d                	push   $0x7d
  jmp __alltraps
  10259e:	e9 12 06 00 00       	jmp    102bb5 <__alltraps>

001025a3 <vector126>:
.globl vector126
vector126:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $126
  1025a5:	6a 7e                	push   $0x7e
  jmp __alltraps
  1025a7:	e9 09 06 00 00       	jmp    102bb5 <__alltraps>

001025ac <vector127>:
.globl vector127
vector127:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $127
  1025ae:	6a 7f                	push   $0x7f
  jmp __alltraps
  1025b0:	e9 00 06 00 00       	jmp    102bb5 <__alltraps>

001025b5 <vector128>:
.globl vector128
vector128:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $128
  1025b7:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1025bc:	e9 f4 05 00 00       	jmp    102bb5 <__alltraps>

001025c1 <vector129>:
.globl vector129
vector129:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $129
  1025c3:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1025c8:	e9 e8 05 00 00       	jmp    102bb5 <__alltraps>

001025cd <vector130>:
.globl vector130
vector130:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $130
  1025cf:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1025d4:	e9 dc 05 00 00       	jmp    102bb5 <__alltraps>

001025d9 <vector131>:
.globl vector131
vector131:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $131
  1025db:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1025e0:	e9 d0 05 00 00       	jmp    102bb5 <__alltraps>

001025e5 <vector132>:
.globl vector132
vector132:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $132
  1025e7:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1025ec:	e9 c4 05 00 00       	jmp    102bb5 <__alltraps>

001025f1 <vector133>:
.globl vector133
vector133:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $133
  1025f3:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1025f8:	e9 b8 05 00 00       	jmp    102bb5 <__alltraps>

001025fd <vector134>:
.globl vector134
vector134:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $134
  1025ff:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102604:	e9 ac 05 00 00       	jmp    102bb5 <__alltraps>

00102609 <vector135>:
.globl vector135
vector135:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $135
  10260b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102610:	e9 a0 05 00 00       	jmp    102bb5 <__alltraps>

00102615 <vector136>:
.globl vector136
vector136:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $136
  102617:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10261c:	e9 94 05 00 00       	jmp    102bb5 <__alltraps>

00102621 <vector137>:
.globl vector137
vector137:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $137
  102623:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102628:	e9 88 05 00 00       	jmp    102bb5 <__alltraps>

0010262d <vector138>:
.globl vector138
vector138:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $138
  10262f:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102634:	e9 7c 05 00 00       	jmp    102bb5 <__alltraps>

00102639 <vector139>:
.globl vector139
vector139:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $139
  10263b:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102640:	e9 70 05 00 00       	jmp    102bb5 <__alltraps>

00102645 <vector140>:
.globl vector140
vector140:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $140
  102647:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10264c:	e9 64 05 00 00       	jmp    102bb5 <__alltraps>

00102651 <vector141>:
.globl vector141
vector141:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $141
  102653:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102658:	e9 58 05 00 00       	jmp    102bb5 <__alltraps>

0010265d <vector142>:
.globl vector142
vector142:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $142
  10265f:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102664:	e9 4c 05 00 00       	jmp    102bb5 <__alltraps>

00102669 <vector143>:
.globl vector143
vector143:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $143
  10266b:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102670:	e9 40 05 00 00       	jmp    102bb5 <__alltraps>

00102675 <vector144>:
.globl vector144
vector144:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $144
  102677:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10267c:	e9 34 05 00 00       	jmp    102bb5 <__alltraps>

00102681 <vector145>:
.globl vector145
vector145:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $145
  102683:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102688:	e9 28 05 00 00       	jmp    102bb5 <__alltraps>

0010268d <vector146>:
.globl vector146
vector146:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $146
  10268f:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102694:	e9 1c 05 00 00       	jmp    102bb5 <__alltraps>

00102699 <vector147>:
.globl vector147
vector147:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $147
  10269b:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1026a0:	e9 10 05 00 00       	jmp    102bb5 <__alltraps>

001026a5 <vector148>:
.globl vector148
vector148:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $148
  1026a7:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1026ac:	e9 04 05 00 00       	jmp    102bb5 <__alltraps>

001026b1 <vector149>:
.globl vector149
vector149:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $149
  1026b3:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1026b8:	e9 f8 04 00 00       	jmp    102bb5 <__alltraps>

001026bd <vector150>:
.globl vector150
vector150:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $150
  1026bf:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1026c4:	e9 ec 04 00 00       	jmp    102bb5 <__alltraps>

001026c9 <vector151>:
.globl vector151
vector151:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $151
  1026cb:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1026d0:	e9 e0 04 00 00       	jmp    102bb5 <__alltraps>

001026d5 <vector152>:
.globl vector152
vector152:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $152
  1026d7:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1026dc:	e9 d4 04 00 00       	jmp    102bb5 <__alltraps>

001026e1 <vector153>:
.globl vector153
vector153:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $153
  1026e3:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1026e8:	e9 c8 04 00 00       	jmp    102bb5 <__alltraps>

001026ed <vector154>:
.globl vector154
vector154:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $154
  1026ef:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1026f4:	e9 bc 04 00 00       	jmp    102bb5 <__alltraps>

001026f9 <vector155>:
.globl vector155
vector155:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $155
  1026fb:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102700:	e9 b0 04 00 00       	jmp    102bb5 <__alltraps>

00102705 <vector156>:
.globl vector156
vector156:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $156
  102707:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10270c:	e9 a4 04 00 00       	jmp    102bb5 <__alltraps>

00102711 <vector157>:
.globl vector157
vector157:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $157
  102713:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102718:	e9 98 04 00 00       	jmp    102bb5 <__alltraps>

0010271d <vector158>:
.globl vector158
vector158:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $158
  10271f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102724:	e9 8c 04 00 00       	jmp    102bb5 <__alltraps>

00102729 <vector159>:
.globl vector159
vector159:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $159
  10272b:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102730:	e9 80 04 00 00       	jmp    102bb5 <__alltraps>

00102735 <vector160>:
.globl vector160
vector160:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $160
  102737:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10273c:	e9 74 04 00 00       	jmp    102bb5 <__alltraps>

00102741 <vector161>:
.globl vector161
vector161:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $161
  102743:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102748:	e9 68 04 00 00       	jmp    102bb5 <__alltraps>

0010274d <vector162>:
.globl vector162
vector162:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $162
  10274f:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102754:	e9 5c 04 00 00       	jmp    102bb5 <__alltraps>

00102759 <vector163>:
.globl vector163
vector163:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $163
  10275b:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102760:	e9 50 04 00 00       	jmp    102bb5 <__alltraps>

00102765 <vector164>:
.globl vector164
vector164:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $164
  102767:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10276c:	e9 44 04 00 00       	jmp    102bb5 <__alltraps>

00102771 <vector165>:
.globl vector165
vector165:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $165
  102773:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102778:	e9 38 04 00 00       	jmp    102bb5 <__alltraps>

0010277d <vector166>:
.globl vector166
vector166:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $166
  10277f:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102784:	e9 2c 04 00 00       	jmp    102bb5 <__alltraps>

00102789 <vector167>:
.globl vector167
vector167:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $167
  10278b:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102790:	e9 20 04 00 00       	jmp    102bb5 <__alltraps>

00102795 <vector168>:
.globl vector168
vector168:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $168
  102797:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10279c:	e9 14 04 00 00       	jmp    102bb5 <__alltraps>

001027a1 <vector169>:
.globl vector169
vector169:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $169
  1027a3:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1027a8:	e9 08 04 00 00       	jmp    102bb5 <__alltraps>

001027ad <vector170>:
.globl vector170
vector170:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $170
  1027af:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1027b4:	e9 fc 03 00 00       	jmp    102bb5 <__alltraps>

001027b9 <vector171>:
.globl vector171
vector171:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $171
  1027bb:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1027c0:	e9 f0 03 00 00       	jmp    102bb5 <__alltraps>

001027c5 <vector172>:
.globl vector172
vector172:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $172
  1027c7:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1027cc:	e9 e4 03 00 00       	jmp    102bb5 <__alltraps>

001027d1 <vector173>:
.globl vector173
vector173:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $173
  1027d3:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1027d8:	e9 d8 03 00 00       	jmp    102bb5 <__alltraps>

001027dd <vector174>:
.globl vector174
vector174:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $174
  1027df:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1027e4:	e9 cc 03 00 00       	jmp    102bb5 <__alltraps>

001027e9 <vector175>:
.globl vector175
vector175:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $175
  1027eb:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1027f0:	e9 c0 03 00 00       	jmp    102bb5 <__alltraps>

001027f5 <vector176>:
.globl vector176
vector176:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $176
  1027f7:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1027fc:	e9 b4 03 00 00       	jmp    102bb5 <__alltraps>

00102801 <vector177>:
.globl vector177
vector177:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $177
  102803:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102808:	e9 a8 03 00 00       	jmp    102bb5 <__alltraps>

0010280d <vector178>:
.globl vector178
vector178:
  pushl $0
  10280d:	6a 00                	push   $0x0
  pushl $178
  10280f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102814:	e9 9c 03 00 00       	jmp    102bb5 <__alltraps>

00102819 <vector179>:
.globl vector179
vector179:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $179
  10281b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102820:	e9 90 03 00 00       	jmp    102bb5 <__alltraps>

00102825 <vector180>:
.globl vector180
vector180:
  pushl $0
  102825:	6a 00                	push   $0x0
  pushl $180
  102827:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10282c:	e9 84 03 00 00       	jmp    102bb5 <__alltraps>

00102831 <vector181>:
.globl vector181
vector181:
  pushl $0
  102831:	6a 00                	push   $0x0
  pushl $181
  102833:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102838:	e9 78 03 00 00       	jmp    102bb5 <__alltraps>

0010283d <vector182>:
.globl vector182
vector182:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $182
  10283f:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102844:	e9 6c 03 00 00       	jmp    102bb5 <__alltraps>

00102849 <vector183>:
.globl vector183
vector183:
  pushl $0
  102849:	6a 00                	push   $0x0
  pushl $183
  10284b:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102850:	e9 60 03 00 00       	jmp    102bb5 <__alltraps>

00102855 <vector184>:
.globl vector184
vector184:
  pushl $0
  102855:	6a 00                	push   $0x0
  pushl $184
  102857:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10285c:	e9 54 03 00 00       	jmp    102bb5 <__alltraps>

00102861 <vector185>:
.globl vector185
vector185:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $185
  102863:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102868:	e9 48 03 00 00       	jmp    102bb5 <__alltraps>

0010286d <vector186>:
.globl vector186
vector186:
  pushl $0
  10286d:	6a 00                	push   $0x0
  pushl $186
  10286f:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102874:	e9 3c 03 00 00       	jmp    102bb5 <__alltraps>

00102879 <vector187>:
.globl vector187
vector187:
  pushl $0
  102879:	6a 00                	push   $0x0
  pushl $187
  10287b:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102880:	e9 30 03 00 00       	jmp    102bb5 <__alltraps>

00102885 <vector188>:
.globl vector188
vector188:
  pushl $0
  102885:	6a 00                	push   $0x0
  pushl $188
  102887:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10288c:	e9 24 03 00 00       	jmp    102bb5 <__alltraps>

00102891 <vector189>:
.globl vector189
vector189:
  pushl $0
  102891:	6a 00                	push   $0x0
  pushl $189
  102893:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102898:	e9 18 03 00 00       	jmp    102bb5 <__alltraps>

0010289d <vector190>:
.globl vector190
vector190:
  pushl $0
  10289d:	6a 00                	push   $0x0
  pushl $190
  10289f:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1028a4:	e9 0c 03 00 00       	jmp    102bb5 <__alltraps>

001028a9 <vector191>:
.globl vector191
vector191:
  pushl $0
  1028a9:	6a 00                	push   $0x0
  pushl $191
  1028ab:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1028b0:	e9 00 03 00 00       	jmp    102bb5 <__alltraps>

001028b5 <vector192>:
.globl vector192
vector192:
  pushl $0
  1028b5:	6a 00                	push   $0x0
  pushl $192
  1028b7:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1028bc:	e9 f4 02 00 00       	jmp    102bb5 <__alltraps>

001028c1 <vector193>:
.globl vector193
vector193:
  pushl $0
  1028c1:	6a 00                	push   $0x0
  pushl $193
  1028c3:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1028c8:	e9 e8 02 00 00       	jmp    102bb5 <__alltraps>

001028cd <vector194>:
.globl vector194
vector194:
  pushl $0
  1028cd:	6a 00                	push   $0x0
  pushl $194
  1028cf:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1028d4:	e9 dc 02 00 00       	jmp    102bb5 <__alltraps>

001028d9 <vector195>:
.globl vector195
vector195:
  pushl $0
  1028d9:	6a 00                	push   $0x0
  pushl $195
  1028db:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1028e0:	e9 d0 02 00 00       	jmp    102bb5 <__alltraps>

001028e5 <vector196>:
.globl vector196
vector196:
  pushl $0
  1028e5:	6a 00                	push   $0x0
  pushl $196
  1028e7:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1028ec:	e9 c4 02 00 00       	jmp    102bb5 <__alltraps>

001028f1 <vector197>:
.globl vector197
vector197:
  pushl $0
  1028f1:	6a 00                	push   $0x0
  pushl $197
  1028f3:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1028f8:	e9 b8 02 00 00       	jmp    102bb5 <__alltraps>

001028fd <vector198>:
.globl vector198
vector198:
  pushl $0
  1028fd:	6a 00                	push   $0x0
  pushl $198
  1028ff:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102904:	e9 ac 02 00 00       	jmp    102bb5 <__alltraps>

00102909 <vector199>:
.globl vector199
vector199:
  pushl $0
  102909:	6a 00                	push   $0x0
  pushl $199
  10290b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102910:	e9 a0 02 00 00       	jmp    102bb5 <__alltraps>

00102915 <vector200>:
.globl vector200
vector200:
  pushl $0
  102915:	6a 00                	push   $0x0
  pushl $200
  102917:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10291c:	e9 94 02 00 00       	jmp    102bb5 <__alltraps>

00102921 <vector201>:
.globl vector201
vector201:
  pushl $0
  102921:	6a 00                	push   $0x0
  pushl $201
  102923:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102928:	e9 88 02 00 00       	jmp    102bb5 <__alltraps>

0010292d <vector202>:
.globl vector202
vector202:
  pushl $0
  10292d:	6a 00                	push   $0x0
  pushl $202
  10292f:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102934:	e9 7c 02 00 00       	jmp    102bb5 <__alltraps>

00102939 <vector203>:
.globl vector203
vector203:
  pushl $0
  102939:	6a 00                	push   $0x0
  pushl $203
  10293b:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102940:	e9 70 02 00 00       	jmp    102bb5 <__alltraps>

00102945 <vector204>:
.globl vector204
vector204:
  pushl $0
  102945:	6a 00                	push   $0x0
  pushl $204
  102947:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10294c:	e9 64 02 00 00       	jmp    102bb5 <__alltraps>

00102951 <vector205>:
.globl vector205
vector205:
  pushl $0
  102951:	6a 00                	push   $0x0
  pushl $205
  102953:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102958:	e9 58 02 00 00       	jmp    102bb5 <__alltraps>

0010295d <vector206>:
.globl vector206
vector206:
  pushl $0
  10295d:	6a 00                	push   $0x0
  pushl $206
  10295f:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102964:	e9 4c 02 00 00       	jmp    102bb5 <__alltraps>

00102969 <vector207>:
.globl vector207
vector207:
  pushl $0
  102969:	6a 00                	push   $0x0
  pushl $207
  10296b:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102970:	e9 40 02 00 00       	jmp    102bb5 <__alltraps>

00102975 <vector208>:
.globl vector208
vector208:
  pushl $0
  102975:	6a 00                	push   $0x0
  pushl $208
  102977:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10297c:	e9 34 02 00 00       	jmp    102bb5 <__alltraps>

00102981 <vector209>:
.globl vector209
vector209:
  pushl $0
  102981:	6a 00                	push   $0x0
  pushl $209
  102983:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102988:	e9 28 02 00 00       	jmp    102bb5 <__alltraps>

0010298d <vector210>:
.globl vector210
vector210:
  pushl $0
  10298d:	6a 00                	push   $0x0
  pushl $210
  10298f:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102994:	e9 1c 02 00 00       	jmp    102bb5 <__alltraps>

00102999 <vector211>:
.globl vector211
vector211:
  pushl $0
  102999:	6a 00                	push   $0x0
  pushl $211
  10299b:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1029a0:	e9 10 02 00 00       	jmp    102bb5 <__alltraps>

001029a5 <vector212>:
.globl vector212
vector212:
  pushl $0
  1029a5:	6a 00                	push   $0x0
  pushl $212
  1029a7:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1029ac:	e9 04 02 00 00       	jmp    102bb5 <__alltraps>

001029b1 <vector213>:
.globl vector213
vector213:
  pushl $0
  1029b1:	6a 00                	push   $0x0
  pushl $213
  1029b3:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1029b8:	e9 f8 01 00 00       	jmp    102bb5 <__alltraps>

001029bd <vector214>:
.globl vector214
vector214:
  pushl $0
  1029bd:	6a 00                	push   $0x0
  pushl $214
  1029bf:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1029c4:	e9 ec 01 00 00       	jmp    102bb5 <__alltraps>

001029c9 <vector215>:
.globl vector215
vector215:
  pushl $0
  1029c9:	6a 00                	push   $0x0
  pushl $215
  1029cb:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1029d0:	e9 e0 01 00 00       	jmp    102bb5 <__alltraps>

001029d5 <vector216>:
.globl vector216
vector216:
  pushl $0
  1029d5:	6a 00                	push   $0x0
  pushl $216
  1029d7:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1029dc:	e9 d4 01 00 00       	jmp    102bb5 <__alltraps>

001029e1 <vector217>:
.globl vector217
vector217:
  pushl $0
  1029e1:	6a 00                	push   $0x0
  pushl $217
  1029e3:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1029e8:	e9 c8 01 00 00       	jmp    102bb5 <__alltraps>

001029ed <vector218>:
.globl vector218
vector218:
  pushl $0
  1029ed:	6a 00                	push   $0x0
  pushl $218
  1029ef:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1029f4:	e9 bc 01 00 00       	jmp    102bb5 <__alltraps>

001029f9 <vector219>:
.globl vector219
vector219:
  pushl $0
  1029f9:	6a 00                	push   $0x0
  pushl $219
  1029fb:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102a00:	e9 b0 01 00 00       	jmp    102bb5 <__alltraps>

00102a05 <vector220>:
.globl vector220
vector220:
  pushl $0
  102a05:	6a 00                	push   $0x0
  pushl $220
  102a07:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102a0c:	e9 a4 01 00 00       	jmp    102bb5 <__alltraps>

00102a11 <vector221>:
.globl vector221
vector221:
  pushl $0
  102a11:	6a 00                	push   $0x0
  pushl $221
  102a13:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102a18:	e9 98 01 00 00       	jmp    102bb5 <__alltraps>

00102a1d <vector222>:
.globl vector222
vector222:
  pushl $0
  102a1d:	6a 00                	push   $0x0
  pushl $222
  102a1f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102a24:	e9 8c 01 00 00       	jmp    102bb5 <__alltraps>

00102a29 <vector223>:
.globl vector223
vector223:
  pushl $0
  102a29:	6a 00                	push   $0x0
  pushl $223
  102a2b:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102a30:	e9 80 01 00 00       	jmp    102bb5 <__alltraps>

00102a35 <vector224>:
.globl vector224
vector224:
  pushl $0
  102a35:	6a 00                	push   $0x0
  pushl $224
  102a37:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102a3c:	e9 74 01 00 00       	jmp    102bb5 <__alltraps>

00102a41 <vector225>:
.globl vector225
vector225:
  pushl $0
  102a41:	6a 00                	push   $0x0
  pushl $225
  102a43:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102a48:	e9 68 01 00 00       	jmp    102bb5 <__alltraps>

00102a4d <vector226>:
.globl vector226
vector226:
  pushl $0
  102a4d:	6a 00                	push   $0x0
  pushl $226
  102a4f:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102a54:	e9 5c 01 00 00       	jmp    102bb5 <__alltraps>

00102a59 <vector227>:
.globl vector227
vector227:
  pushl $0
  102a59:	6a 00                	push   $0x0
  pushl $227
  102a5b:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102a60:	e9 50 01 00 00       	jmp    102bb5 <__alltraps>

00102a65 <vector228>:
.globl vector228
vector228:
  pushl $0
  102a65:	6a 00                	push   $0x0
  pushl $228
  102a67:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102a6c:	e9 44 01 00 00       	jmp    102bb5 <__alltraps>

00102a71 <vector229>:
.globl vector229
vector229:
  pushl $0
  102a71:	6a 00                	push   $0x0
  pushl $229
  102a73:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102a78:	e9 38 01 00 00       	jmp    102bb5 <__alltraps>

00102a7d <vector230>:
.globl vector230
vector230:
  pushl $0
  102a7d:	6a 00                	push   $0x0
  pushl $230
  102a7f:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102a84:	e9 2c 01 00 00       	jmp    102bb5 <__alltraps>

00102a89 <vector231>:
.globl vector231
vector231:
  pushl $0
  102a89:	6a 00                	push   $0x0
  pushl $231
  102a8b:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102a90:	e9 20 01 00 00       	jmp    102bb5 <__alltraps>

00102a95 <vector232>:
.globl vector232
vector232:
  pushl $0
  102a95:	6a 00                	push   $0x0
  pushl $232
  102a97:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102a9c:	e9 14 01 00 00       	jmp    102bb5 <__alltraps>

00102aa1 <vector233>:
.globl vector233
vector233:
  pushl $0
  102aa1:	6a 00                	push   $0x0
  pushl $233
  102aa3:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102aa8:	e9 08 01 00 00       	jmp    102bb5 <__alltraps>

00102aad <vector234>:
.globl vector234
vector234:
  pushl $0
  102aad:	6a 00                	push   $0x0
  pushl $234
  102aaf:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102ab4:	e9 fc 00 00 00       	jmp    102bb5 <__alltraps>

00102ab9 <vector235>:
.globl vector235
vector235:
  pushl $0
  102ab9:	6a 00                	push   $0x0
  pushl $235
  102abb:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102ac0:	e9 f0 00 00 00       	jmp    102bb5 <__alltraps>

00102ac5 <vector236>:
.globl vector236
vector236:
  pushl $0
  102ac5:	6a 00                	push   $0x0
  pushl $236
  102ac7:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102acc:	e9 e4 00 00 00       	jmp    102bb5 <__alltraps>

00102ad1 <vector237>:
.globl vector237
vector237:
  pushl $0
  102ad1:	6a 00                	push   $0x0
  pushl $237
  102ad3:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102ad8:	e9 d8 00 00 00       	jmp    102bb5 <__alltraps>

00102add <vector238>:
.globl vector238
vector238:
  pushl $0
  102add:	6a 00                	push   $0x0
  pushl $238
  102adf:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102ae4:	e9 cc 00 00 00       	jmp    102bb5 <__alltraps>

00102ae9 <vector239>:
.globl vector239
vector239:
  pushl $0
  102ae9:	6a 00                	push   $0x0
  pushl $239
  102aeb:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102af0:	e9 c0 00 00 00       	jmp    102bb5 <__alltraps>

00102af5 <vector240>:
.globl vector240
vector240:
  pushl $0
  102af5:	6a 00                	push   $0x0
  pushl $240
  102af7:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102afc:	e9 b4 00 00 00       	jmp    102bb5 <__alltraps>

00102b01 <vector241>:
.globl vector241
vector241:
  pushl $0
  102b01:	6a 00                	push   $0x0
  pushl $241
  102b03:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102b08:	e9 a8 00 00 00       	jmp    102bb5 <__alltraps>

00102b0d <vector242>:
.globl vector242
vector242:
  pushl $0
  102b0d:	6a 00                	push   $0x0
  pushl $242
  102b0f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102b14:	e9 9c 00 00 00       	jmp    102bb5 <__alltraps>

00102b19 <vector243>:
.globl vector243
vector243:
  pushl $0
  102b19:	6a 00                	push   $0x0
  pushl $243
  102b1b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102b20:	e9 90 00 00 00       	jmp    102bb5 <__alltraps>

00102b25 <vector244>:
.globl vector244
vector244:
  pushl $0
  102b25:	6a 00                	push   $0x0
  pushl $244
  102b27:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102b2c:	e9 84 00 00 00       	jmp    102bb5 <__alltraps>

00102b31 <vector245>:
.globl vector245
vector245:
  pushl $0
  102b31:	6a 00                	push   $0x0
  pushl $245
  102b33:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102b38:	e9 78 00 00 00       	jmp    102bb5 <__alltraps>

00102b3d <vector246>:
.globl vector246
vector246:
  pushl $0
  102b3d:	6a 00                	push   $0x0
  pushl $246
  102b3f:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102b44:	e9 6c 00 00 00       	jmp    102bb5 <__alltraps>

00102b49 <vector247>:
.globl vector247
vector247:
  pushl $0
  102b49:	6a 00                	push   $0x0
  pushl $247
  102b4b:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102b50:	e9 60 00 00 00       	jmp    102bb5 <__alltraps>

00102b55 <vector248>:
.globl vector248
vector248:
  pushl $0
  102b55:	6a 00                	push   $0x0
  pushl $248
  102b57:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102b5c:	e9 54 00 00 00       	jmp    102bb5 <__alltraps>

00102b61 <vector249>:
.globl vector249
vector249:
  pushl $0
  102b61:	6a 00                	push   $0x0
  pushl $249
  102b63:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102b68:	e9 48 00 00 00       	jmp    102bb5 <__alltraps>

00102b6d <vector250>:
.globl vector250
vector250:
  pushl $0
  102b6d:	6a 00                	push   $0x0
  pushl $250
  102b6f:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102b74:	e9 3c 00 00 00       	jmp    102bb5 <__alltraps>

00102b79 <vector251>:
.globl vector251
vector251:
  pushl $0
  102b79:	6a 00                	push   $0x0
  pushl $251
  102b7b:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102b80:	e9 30 00 00 00       	jmp    102bb5 <__alltraps>

00102b85 <vector252>:
.globl vector252
vector252:
  pushl $0
  102b85:	6a 00                	push   $0x0
  pushl $252
  102b87:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102b8c:	e9 24 00 00 00       	jmp    102bb5 <__alltraps>

00102b91 <vector253>:
.globl vector253
vector253:
  pushl $0
  102b91:	6a 00                	push   $0x0
  pushl $253
  102b93:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102b98:	e9 18 00 00 00       	jmp    102bb5 <__alltraps>

00102b9d <vector254>:
.globl vector254
vector254:
  pushl $0
  102b9d:	6a 00                	push   $0x0
  pushl $254
  102b9f:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102ba4:	e9 0c 00 00 00       	jmp    102bb5 <__alltraps>

00102ba9 <vector255>:
.globl vector255
vector255:
  pushl $0
  102ba9:	6a 00                	push   $0x0
  pushl $255
  102bab:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102bb0:	e9 00 00 00 00       	jmp    102bb5 <__alltraps>

00102bb5 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102bb5:	1e                   	push   %ds
    pushl %es
  102bb6:	06                   	push   %es
    pushl %fs
  102bb7:	0f a0                	push   %fs
    pushl %gs
  102bb9:	0f a8                	push   %gs
    pushal                # Push EAX, ECX, EDX, EBX, original ESP, EBP, ESI, and EDI.
  102bbb:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102bbc:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102bc1:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102bc3:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102bc5:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102bc6:	e8 60 f5 ff ff       	call   10212b <trap>

    # pop the pushed stack pointer
    popl %esp
  102bcb:	5c                   	pop    %esp

00102bcc <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102bcc:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102bcd:	0f a9                	pop    %gs
    popl %fs
  102bcf:	0f a1                	pop    %fs
    popl %es
  102bd1:	07                   	pop    %es
    popl %ds
  102bd2:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102bd3:	83 c4 08             	add    $0x8,%esp
    iret                 # 恢复 cs、eflag以及 eip
  102bd6:	cf                   	iret   

00102bd7 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102bd7:	55                   	push   %ebp
  102bd8:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102bda:	a1 34 3f 12 00       	mov    0x123f34,%eax
  102bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  102be2:	29 c2                	sub    %eax,%edx
  102be4:	89 d0                	mov    %edx,%eax
  102be6:	c1 f8 02             	sar    $0x2,%eax
  102be9:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102bef:	5d                   	pop    %ebp
  102bf0:	c3                   	ret    

00102bf1 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102bf1:	55                   	push   %ebp
  102bf2:	89 e5                	mov    %esp,%ebp
  102bf4:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  102bfa:	89 04 24             	mov    %eax,(%esp)
  102bfd:	e8 d5 ff ff ff       	call   102bd7 <page2ppn>
  102c02:	c1 e0 0c             	shl    $0xc,%eax
}
  102c05:	c9                   	leave  
  102c06:	c3                   	ret    

00102c07 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102c07:	55                   	push   %ebp
  102c08:	89 e5                	mov    %esp,%ebp
  102c0a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c10:	c1 e8 0c             	shr    $0xc,%eax
  102c13:	89 c2                	mov    %eax,%edx
  102c15:	a1 80 3e 12 00       	mov    0x123e80,%eax
  102c1a:	39 c2                	cmp    %eax,%edx
  102c1c:	72 1c                	jb     102c3a <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102c1e:	c7 44 24 08 50 a8 10 	movl   $0x10a850,0x8(%esp)
  102c25:	00 
  102c26:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102c2d:	00 
  102c2e:	c7 04 24 6f a8 10 00 	movl   $0x10a86f,(%esp)
  102c35:	e8 fc d7 ff ff       	call   100436 <__panic>
    }
    return &pages[PPN(pa)];
  102c3a:	8b 0d 34 3f 12 00    	mov    0x123f34,%ecx
  102c40:	8b 45 08             	mov    0x8(%ebp),%eax
  102c43:	c1 e8 0c             	shr    $0xc,%eax
  102c46:	89 c2                	mov    %eax,%edx
  102c48:	89 d0                	mov    %edx,%eax
  102c4a:	c1 e0 02             	shl    $0x2,%eax
  102c4d:	01 d0                	add    %edx,%eax
  102c4f:	c1 e0 02             	shl    $0x2,%eax
  102c52:	01 c8                	add    %ecx,%eax
}
  102c54:	c9                   	leave  
  102c55:	c3                   	ret    

00102c56 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102c56:	55                   	push   %ebp
  102c57:	89 e5                	mov    %esp,%ebp
  102c59:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c5f:	89 04 24             	mov    %eax,(%esp)
  102c62:	e8 8a ff ff ff       	call   102bf1 <page2pa>
  102c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c6d:	c1 e8 0c             	shr    $0xc,%eax
  102c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c73:	a1 80 3e 12 00       	mov    0x123e80,%eax
  102c78:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102c7b:	72 23                	jb     102ca0 <page2kva+0x4a>
  102c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c80:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102c84:	c7 44 24 08 80 a8 10 	movl   $0x10a880,0x8(%esp)
  102c8b:	00 
  102c8c:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102c93:	00 
  102c94:	c7 04 24 6f a8 10 00 	movl   $0x10a86f,(%esp)
  102c9b:	e8 96 d7 ff ff       	call   100436 <__panic>
  102ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ca3:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102ca8:	c9                   	leave  
  102ca9:	c3                   	ret    

00102caa <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102caa:	55                   	push   %ebp
  102cab:	89 e5                	mov    %esp,%ebp
  102cad:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb3:	83 e0 01             	and    $0x1,%eax
  102cb6:	85 c0                	test   %eax,%eax
  102cb8:	75 1c                	jne    102cd6 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102cba:	c7 44 24 08 a4 a8 10 	movl   $0x10a8a4,0x8(%esp)
  102cc1:	00 
  102cc2:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102cc9:	00 
  102cca:	c7 04 24 6f a8 10 00 	movl   $0x10a86f,(%esp)
  102cd1:	e8 60 d7 ff ff       	call   100436 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102cde:	89 04 24             	mov    %eax,(%esp)
  102ce1:	e8 21 ff ff ff       	call   102c07 <pa2page>
}
  102ce6:	c9                   	leave  
  102ce7:	c3                   	ret    

00102ce8 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102ce8:	55                   	push   %ebp
  102ce9:	89 e5                	mov    %esp,%ebp
  102ceb:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102cee:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102cf6:	89 04 24             	mov    %eax,(%esp)
  102cf9:	e8 09 ff ff ff       	call   102c07 <pa2page>
}
  102cfe:	c9                   	leave  
  102cff:	c3                   	ret    

00102d00 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102d00:	55                   	push   %ebp
  102d01:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102d03:	8b 45 08             	mov    0x8(%ebp),%eax
  102d06:	8b 00                	mov    (%eax),%eax
}
  102d08:	5d                   	pop    %ebp
  102d09:	c3                   	ret    

00102d0a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102d0a:	55                   	push   %ebp
  102d0b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d13:	89 10                	mov    %edx,(%eax)
}
  102d15:	90                   	nop
  102d16:	5d                   	pop    %ebp
  102d17:	c3                   	ret    

00102d18 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102d18:	55                   	push   %ebp
  102d19:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1e:	8b 00                	mov    (%eax),%eax
  102d20:	8d 50 01             	lea    0x1(%eax),%edx
  102d23:	8b 45 08             	mov    0x8(%ebp),%eax
  102d26:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102d28:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2b:	8b 00                	mov    (%eax),%eax
}
  102d2d:	5d                   	pop    %ebp
  102d2e:	c3                   	ret    

00102d2f <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102d2f:	55                   	push   %ebp
  102d30:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102d32:	8b 45 08             	mov    0x8(%ebp),%eax
  102d35:	8b 00                	mov    (%eax),%eax
  102d37:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3d:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d42:	8b 00                	mov    (%eax),%eax
}
  102d44:	5d                   	pop    %ebp
  102d45:	c3                   	ret    

00102d46 <__intr_save>:
__intr_save(void) {
  102d46:	55                   	push   %ebp
  102d47:	89 e5                	mov    %esp,%ebp
  102d49:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102d4c:	9c                   	pushf  
  102d4d:	58                   	pop    %eax
  102d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102d54:	25 00 02 00 00       	and    $0x200,%eax
  102d59:	85 c0                	test   %eax,%eax
  102d5b:	74 0c                	je     102d69 <__intr_save+0x23>
        intr_disable();
  102d5d:	e8 12 ec ff ff       	call   101974 <intr_disable>
        return 1;
  102d62:	b8 01 00 00 00       	mov    $0x1,%eax
  102d67:	eb 05                	jmp    102d6e <__intr_save+0x28>
    return 0;
  102d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d6e:	c9                   	leave  
  102d6f:	c3                   	ret    

00102d70 <__intr_restore>:
__intr_restore(bool flag) {
  102d70:	55                   	push   %ebp
  102d71:	89 e5                	mov    %esp,%ebp
  102d73:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102d76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102d7a:	74 05                	je     102d81 <__intr_restore+0x11>
        intr_enable();
  102d7c:	e8 e7 eb ff ff       	call   101968 <intr_enable>
}
  102d81:	90                   	nop
  102d82:	c9                   	leave  
  102d83:	c3                   	ret    

00102d84 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102d84:	55                   	push   %ebp
  102d85:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102d87:	8b 45 08             	mov    0x8(%ebp),%eax
  102d8a:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102d8d:	b8 23 00 00 00       	mov    $0x23,%eax
  102d92:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102d94:	b8 23 00 00 00       	mov    $0x23,%eax
  102d99:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102d9b:	b8 10 00 00 00       	mov    $0x10,%eax
  102da0:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102da2:	b8 10 00 00 00       	mov    $0x10,%eax
  102da7:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102da9:	b8 10 00 00 00       	mov    $0x10,%eax
  102dae:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102db0:	ea b7 2d 10 00 08 00 	ljmp   $0x8,$0x102db7
}
  102db7:	90                   	nop
  102db8:	5d                   	pop    %ebp
  102db9:	c3                   	ret    

00102dba <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102dba:	f3 0f 1e fb          	endbr32 
  102dbe:	55                   	push   %ebp
  102dbf:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc4:	a3 a4 3e 12 00       	mov    %eax,0x123ea4
}
  102dc9:	90                   	nop
  102dca:	5d                   	pop    %ebp
  102dcb:	c3                   	ret    

00102dcc <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102dcc:	f3 0f 1e fb          	endbr32 
  102dd0:	55                   	push   %ebp
  102dd1:	89 e5                	mov    %esp,%ebp
  102dd3:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102dd6:	b8 00 00 12 00       	mov    $0x120000,%eax
  102ddb:	89 04 24             	mov    %eax,(%esp)
  102dde:	e8 d7 ff ff ff       	call   102dba <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102de3:	66 c7 05 a8 3e 12 00 	movw   $0x10,0x123ea8
  102dea:	10 00 

    // initialize the TSS field of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102dec:	66 c7 05 28 0a 12 00 	movw   $0x68,0x120a28
  102df3:	68 00 
  102df5:	b8 a0 3e 12 00       	mov    $0x123ea0,%eax
  102dfa:	0f b7 c0             	movzwl %ax,%eax
  102dfd:	66 a3 2a 0a 12 00    	mov    %ax,0x120a2a
  102e03:	b8 a0 3e 12 00       	mov    $0x123ea0,%eax
  102e08:	c1 e8 10             	shr    $0x10,%eax
  102e0b:	a2 2c 0a 12 00       	mov    %al,0x120a2c
  102e10:	0f b6 05 2d 0a 12 00 	movzbl 0x120a2d,%eax
  102e17:	24 f0                	and    $0xf0,%al
  102e19:	0c 09                	or     $0x9,%al
  102e1b:	a2 2d 0a 12 00       	mov    %al,0x120a2d
  102e20:	0f b6 05 2d 0a 12 00 	movzbl 0x120a2d,%eax
  102e27:	24 ef                	and    $0xef,%al
  102e29:	a2 2d 0a 12 00       	mov    %al,0x120a2d
  102e2e:	0f b6 05 2d 0a 12 00 	movzbl 0x120a2d,%eax
  102e35:	24 9f                	and    $0x9f,%al
  102e37:	a2 2d 0a 12 00       	mov    %al,0x120a2d
  102e3c:	0f b6 05 2d 0a 12 00 	movzbl 0x120a2d,%eax
  102e43:	0c 80                	or     $0x80,%al
  102e45:	a2 2d 0a 12 00       	mov    %al,0x120a2d
  102e4a:	0f b6 05 2e 0a 12 00 	movzbl 0x120a2e,%eax
  102e51:	24 f0                	and    $0xf0,%al
  102e53:	a2 2e 0a 12 00       	mov    %al,0x120a2e
  102e58:	0f b6 05 2e 0a 12 00 	movzbl 0x120a2e,%eax
  102e5f:	24 ef                	and    $0xef,%al
  102e61:	a2 2e 0a 12 00       	mov    %al,0x120a2e
  102e66:	0f b6 05 2e 0a 12 00 	movzbl 0x120a2e,%eax
  102e6d:	24 df                	and    $0xdf,%al
  102e6f:	a2 2e 0a 12 00       	mov    %al,0x120a2e
  102e74:	0f b6 05 2e 0a 12 00 	movzbl 0x120a2e,%eax
  102e7b:	0c 40                	or     $0x40,%al
  102e7d:	a2 2e 0a 12 00       	mov    %al,0x120a2e
  102e82:	0f b6 05 2e 0a 12 00 	movzbl 0x120a2e,%eax
  102e89:	24 7f                	and    $0x7f,%al
  102e8b:	a2 2e 0a 12 00       	mov    %al,0x120a2e
  102e90:	b8 a0 3e 12 00       	mov    $0x123ea0,%eax
  102e95:	c1 e8 18             	shr    $0x18,%eax
  102e98:	a2 2f 0a 12 00       	mov    %al,0x120a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102e9d:	c7 04 24 30 0a 12 00 	movl   $0x120a30,(%esp)
  102ea4:	e8 db fe ff ff       	call   102d84 <lgdt>
  102ea9:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102eaf:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102eb3:	0f 00 d8             	ltr    %ax
}
  102eb6:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102eb7:	90                   	nop
  102eb8:	c9                   	leave  
  102eb9:	c3                   	ret    

00102eba <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102eba:	f3 0f 1e fb          	endbr32 
  102ebe:	55                   	push   %ebp
  102ebf:	89 e5                	mov    %esp,%ebp
  102ec1:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &buddy_pmm_manager;
  102ec4:	c7 05 2c 3f 12 00 78 	movl   $0x10b678,0x123f2c
  102ecb:	b6 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102ece:	a1 2c 3f 12 00       	mov    0x123f2c,%eax
  102ed3:	8b 00                	mov    (%eax),%eax
  102ed5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ed9:	c7 04 24 d0 a8 10 00 	movl   $0x10a8d0,(%esp)
  102ee0:	e8 e5 d3 ff ff       	call   1002ca <cprintf>
    pmm_manager->init();
  102ee5:	a1 2c 3f 12 00       	mov    0x123f2c,%eax
  102eea:	8b 40 04             	mov    0x4(%eax),%eax
  102eed:	ff d0                	call   *%eax
}
  102eef:	90                   	nop
  102ef0:	c9                   	leave  
  102ef1:	c3                   	ret    

00102ef2 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102ef2:	f3 0f 1e fb          	endbr32 
  102ef6:	55                   	push   %ebp
  102ef7:	89 e5                	mov    %esp,%ebp
  102ef9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102efc:	a1 2c 3f 12 00       	mov    0x123f2c,%eax
  102f01:	8b 40 08             	mov    0x8(%eax),%eax
  102f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f07:	89 54 24 04          	mov    %edx,0x4(%esp)
  102f0b:	8b 55 08             	mov    0x8(%ebp),%edx
  102f0e:	89 14 24             	mov    %edx,(%esp)
  102f11:	ff d0                	call   *%eax
}
  102f13:	90                   	nop
  102f14:	c9                   	leave  
  102f15:	c3                   	ret    

00102f16 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102f16:	f3 0f 1e fb          	endbr32 
  102f1a:	55                   	push   %ebp
  102f1b:	89 e5                	mov    %esp,%ebp
  102f1d:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102f20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102f27:	e8 1a fe ff ff       	call   102d46 <__intr_save>
  102f2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102f2f:	a1 2c 3f 12 00       	mov    0x123f2c,%eax
  102f34:	8b 40 0c             	mov    0xc(%eax),%eax
  102f37:	8b 55 08             	mov    0x8(%ebp),%edx
  102f3a:	89 14 24             	mov    %edx,(%esp)
  102f3d:	ff d0                	call   *%eax
  102f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f45:	89 04 24             	mov    %eax,(%esp)
  102f48:	e8 23 fe ff ff       	call   102d70 <__intr_restore>
    return page;
  102f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f50:	c9                   	leave  
  102f51:	c3                   	ret    

00102f52 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102f52:	f3 0f 1e fb          	endbr32 
  102f56:	55                   	push   %ebp
  102f57:	89 e5                	mov    %esp,%ebp
  102f59:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102f5c:	e8 e5 fd ff ff       	call   102d46 <__intr_save>
  102f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102f64:	a1 2c 3f 12 00       	mov    0x123f2c,%eax
  102f69:	8b 40 10             	mov    0x10(%eax),%eax
  102f6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f6f:	89 54 24 04          	mov    %edx,0x4(%esp)
  102f73:	8b 55 08             	mov    0x8(%ebp),%edx
  102f76:	89 14 24             	mov    %edx,(%esp)
  102f79:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f7e:	89 04 24             	mov    %eax,(%esp)
  102f81:	e8 ea fd ff ff       	call   102d70 <__intr_restore>
}
  102f86:	90                   	nop
  102f87:	c9                   	leave  
  102f88:	c3                   	ret    

00102f89 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102f89:	f3 0f 1e fb          	endbr32 
  102f8d:	55                   	push   %ebp
  102f8e:	89 e5                	mov    %esp,%ebp
  102f90:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102f93:	e8 ae fd ff ff       	call   102d46 <__intr_save>
  102f98:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102f9b:	a1 2c 3f 12 00       	mov    0x123f2c,%eax
  102fa0:	8b 40 14             	mov    0x14(%eax),%eax
  102fa3:	ff d0                	call   *%eax
  102fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fab:	89 04 24             	mov    %eax,(%esp)
  102fae:	e8 bd fd ff ff       	call   102d70 <__intr_restore>
    return ret;
  102fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102fb6:	c9                   	leave  
  102fb7:	c3                   	ret    

00102fb8 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102fb8:	f3 0f 1e fb          	endbr32 
  102fbc:	55                   	push   %ebp
  102fbd:	89 e5                	mov    %esp,%ebp
  102fbf:	57                   	push   %edi
  102fc0:	56                   	push   %esi
  102fc1:	53                   	push   %ebx
  102fc2:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102fc8:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102fcf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102fd6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102fdd:	c7 04 24 e7 a8 10 00 	movl   $0x10a8e7,(%esp)
  102fe4:	e8 e1 d2 ff ff       	call   1002ca <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102fe9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102ff0:	e9 1a 01 00 00       	jmp    10310f <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102ff5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ff8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ffb:	89 d0                	mov    %edx,%eax
  102ffd:	c1 e0 02             	shl    $0x2,%eax
  103000:	01 d0                	add    %edx,%eax
  103002:	c1 e0 02             	shl    $0x2,%eax
  103005:	01 c8                	add    %ecx,%eax
  103007:	8b 50 08             	mov    0x8(%eax),%edx
  10300a:	8b 40 04             	mov    0x4(%eax),%eax
  10300d:	89 45 a0             	mov    %eax,-0x60(%ebp)
  103010:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  103013:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103016:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103019:	89 d0                	mov    %edx,%eax
  10301b:	c1 e0 02             	shl    $0x2,%eax
  10301e:	01 d0                	add    %edx,%eax
  103020:	c1 e0 02             	shl    $0x2,%eax
  103023:	01 c8                	add    %ecx,%eax
  103025:	8b 48 0c             	mov    0xc(%eax),%ecx
  103028:	8b 58 10             	mov    0x10(%eax),%ebx
  10302b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10302e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  103031:	01 c8                	add    %ecx,%eax
  103033:	11 da                	adc    %ebx,%edx
  103035:	89 45 98             	mov    %eax,-0x68(%ebp)
  103038:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  10303b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10303e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103041:	89 d0                	mov    %edx,%eax
  103043:	c1 e0 02             	shl    $0x2,%eax
  103046:	01 d0                	add    %edx,%eax
  103048:	c1 e0 02             	shl    $0x2,%eax
  10304b:	01 c8                	add    %ecx,%eax
  10304d:	83 c0 14             	add    $0x14,%eax
  103050:	8b 00                	mov    (%eax),%eax
  103052:	89 45 84             	mov    %eax,-0x7c(%ebp)
  103055:	8b 45 98             	mov    -0x68(%ebp),%eax
  103058:	8b 55 9c             	mov    -0x64(%ebp),%edx
  10305b:	83 c0 ff             	add    $0xffffffff,%eax
  10305e:	83 d2 ff             	adc    $0xffffffff,%edx
  103061:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  103067:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  10306d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103070:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103073:	89 d0                	mov    %edx,%eax
  103075:	c1 e0 02             	shl    $0x2,%eax
  103078:	01 d0                	add    %edx,%eax
  10307a:	c1 e0 02             	shl    $0x2,%eax
  10307d:	01 c8                	add    %ecx,%eax
  10307f:	8b 48 0c             	mov    0xc(%eax),%ecx
  103082:	8b 58 10             	mov    0x10(%eax),%ebx
  103085:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103088:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  10308c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  103092:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  103098:	89 44 24 14          	mov    %eax,0x14(%esp)
  10309c:	89 54 24 18          	mov    %edx,0x18(%esp)
  1030a0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1030a3:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1030a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1030aa:	89 54 24 10          	mov    %edx,0x10(%esp)
  1030ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1030b2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1030b6:	c7 04 24 f4 a8 10 00 	movl   $0x10a8f4,(%esp)
  1030bd:	e8 08 d2 ff ff       	call   1002ca <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  1030c2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1030c5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1030c8:	89 d0                	mov    %edx,%eax
  1030ca:	c1 e0 02             	shl    $0x2,%eax
  1030cd:	01 d0                	add    %edx,%eax
  1030cf:	c1 e0 02             	shl    $0x2,%eax
  1030d2:	01 c8                	add    %ecx,%eax
  1030d4:	83 c0 14             	add    $0x14,%eax
  1030d7:	8b 00                	mov    (%eax),%eax
  1030d9:	83 f8 01             	cmp    $0x1,%eax
  1030dc:	75 2e                	jne    10310c <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
  1030de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1030e4:	3b 45 98             	cmp    -0x68(%ebp),%eax
  1030e7:	89 d0                	mov    %edx,%eax
  1030e9:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  1030ec:	73 1e                	jae    10310c <page_init+0x154>
  1030ee:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  1030f3:	b8 00 00 00 00       	mov    $0x0,%eax
  1030f8:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  1030fb:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  1030fe:	72 0c                	jb     10310c <page_init+0x154>
                maxpa = end;
  103100:	8b 45 98             	mov    -0x68(%ebp),%eax
  103103:	8b 55 9c             	mov    -0x64(%ebp),%edx
  103106:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103109:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  10310c:	ff 45 dc             	incl   -0x24(%ebp)
  10310f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103112:	8b 00                	mov    (%eax),%eax
  103114:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103117:	0f 8c d8 fe ff ff    	jl     102ff5 <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  10311d:	ba 00 00 00 38       	mov    $0x38000000,%edx
  103122:	b8 00 00 00 00       	mov    $0x0,%eax
  103127:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  10312a:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  10312d:	73 0e                	jae    10313d <page_init+0x185>
        maxpa = KMEMSIZE;
  10312f:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103136:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  10313d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103140:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103143:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103147:	c1 ea 0c             	shr    $0xc,%edx
  10314a:	a3 80 3e 12 00       	mov    %eax,0x123e80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  10314f:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  103156:	b8 44 3f 12 00       	mov    $0x123f44,%eax
  10315b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10315e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103161:	01 d0                	add    %edx,%eax
  103163:	89 45 bc             	mov    %eax,-0x44(%ebp)
  103166:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103169:	ba 00 00 00 00       	mov    $0x0,%edx
  10316e:	f7 75 c0             	divl   -0x40(%ebp)
  103171:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103174:	29 d0                	sub    %edx,%eax
  103176:	a3 34 3f 12 00       	mov    %eax,0x123f34

    for (i = 0; i < npage; i ++) {
  10317b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103182:	eb 2f                	jmp    1031b3 <page_init+0x1fb>
        SetPageReserved(pages + i);
  103184:	8b 0d 34 3f 12 00    	mov    0x123f34,%ecx
  10318a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10318d:	89 d0                	mov    %edx,%eax
  10318f:	c1 e0 02             	shl    $0x2,%eax
  103192:	01 d0                	add    %edx,%eax
  103194:	c1 e0 02             	shl    $0x2,%eax
  103197:	01 c8                	add    %ecx,%eax
  103199:	83 c0 04             	add    $0x4,%eax
  10319c:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  1031a3:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1031a6:	8b 45 90             	mov    -0x70(%ebp),%eax
  1031a9:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1031ac:	0f ab 10             	bts    %edx,(%eax)
}
  1031af:	90                   	nop
    for (i = 0; i < npage; i ++) {
  1031b0:	ff 45 dc             	incl   -0x24(%ebp)
  1031b3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1031b6:	a1 80 3e 12 00       	mov    0x123e80,%eax
  1031bb:	39 c2                	cmp    %eax,%edx
  1031bd:	72 c5                	jb     103184 <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1031bf:	8b 15 80 3e 12 00    	mov    0x123e80,%edx
  1031c5:	89 d0                	mov    %edx,%eax
  1031c7:	c1 e0 02             	shl    $0x2,%eax
  1031ca:	01 d0                	add    %edx,%eax
  1031cc:	c1 e0 02             	shl    $0x2,%eax
  1031cf:	89 c2                	mov    %eax,%edx
  1031d1:	a1 34 3f 12 00       	mov    0x123f34,%eax
  1031d6:	01 d0                	add    %edx,%eax
  1031d8:	89 45 b8             	mov    %eax,-0x48(%ebp)
  1031db:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  1031e2:	77 23                	ja     103207 <page_init+0x24f>
  1031e4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1031e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1031eb:	c7 44 24 08 24 a9 10 	movl   $0x10a924,0x8(%esp)
  1031f2:	00 
  1031f3:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  1031fa:	00 
  1031fb:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103202:	e8 2f d2 ff ff       	call   100436 <__panic>
  103207:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10320a:	05 00 00 00 40       	add    $0x40000000,%eax
  10320f:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103212:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103219:	e9 4b 01 00 00       	jmp    103369 <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10321e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103221:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103224:	89 d0                	mov    %edx,%eax
  103226:	c1 e0 02             	shl    $0x2,%eax
  103229:	01 d0                	add    %edx,%eax
  10322b:	c1 e0 02             	shl    $0x2,%eax
  10322e:	01 c8                	add    %ecx,%eax
  103230:	8b 50 08             	mov    0x8(%eax),%edx
  103233:	8b 40 04             	mov    0x4(%eax),%eax
  103236:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103239:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10323c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10323f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103242:	89 d0                	mov    %edx,%eax
  103244:	c1 e0 02             	shl    $0x2,%eax
  103247:	01 d0                	add    %edx,%eax
  103249:	c1 e0 02             	shl    $0x2,%eax
  10324c:	01 c8                	add    %ecx,%eax
  10324e:	8b 48 0c             	mov    0xc(%eax),%ecx
  103251:	8b 58 10             	mov    0x10(%eax),%ebx
  103254:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103257:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10325a:	01 c8                	add    %ecx,%eax
  10325c:	11 da                	adc    %ebx,%edx
  10325e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103261:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103264:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103267:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10326a:	89 d0                	mov    %edx,%eax
  10326c:	c1 e0 02             	shl    $0x2,%eax
  10326f:	01 d0                	add    %edx,%eax
  103271:	c1 e0 02             	shl    $0x2,%eax
  103274:	01 c8                	add    %ecx,%eax
  103276:	83 c0 14             	add    $0x14,%eax
  103279:	8b 00                	mov    (%eax),%eax
  10327b:	83 f8 01             	cmp    $0x1,%eax
  10327e:	0f 85 e2 00 00 00    	jne    103366 <page_init+0x3ae>
            if (begin < freemem) {
  103284:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103287:	ba 00 00 00 00       	mov    $0x0,%edx
  10328c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10328f:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103292:	19 d1                	sbb    %edx,%ecx
  103294:	73 0d                	jae    1032a3 <page_init+0x2eb>
                begin = freemem;
  103296:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103299:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10329c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1032a3:	ba 00 00 00 38       	mov    $0x38000000,%edx
  1032a8:	b8 00 00 00 00       	mov    $0x0,%eax
  1032ad:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  1032b0:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1032b3:	73 0e                	jae    1032c3 <page_init+0x30b>
                end = KMEMSIZE;
  1032b5:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1032bc:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1032c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1032c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1032c9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1032cc:	89 d0                	mov    %edx,%eax
  1032ce:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1032d1:	0f 83 8f 00 00 00    	jae    103366 <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
  1032d7:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  1032de:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1032e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1032e4:	01 d0                	add    %edx,%eax
  1032e6:	48                   	dec    %eax
  1032e7:	89 45 ac             	mov    %eax,-0x54(%ebp)
  1032ea:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1032ed:	ba 00 00 00 00       	mov    $0x0,%edx
  1032f2:	f7 75 b0             	divl   -0x50(%ebp)
  1032f5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1032f8:	29 d0                	sub    %edx,%eax
  1032fa:	ba 00 00 00 00       	mov    $0x0,%edx
  1032ff:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103302:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  103305:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103308:	89 45 a8             	mov    %eax,-0x58(%ebp)
  10330b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10330e:	ba 00 00 00 00       	mov    $0x0,%edx
  103313:	89 c3                	mov    %eax,%ebx
  103315:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  10331b:	89 de                	mov    %ebx,%esi
  10331d:	89 d0                	mov    %edx,%eax
  10331f:	83 e0 00             	and    $0x0,%eax
  103322:	89 c7                	mov    %eax,%edi
  103324:	89 75 c8             	mov    %esi,-0x38(%ebp)
  103327:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  10332a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10332d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103330:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103333:	89 d0                	mov    %edx,%eax
  103335:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103338:	73 2c                	jae    103366 <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10333a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10333d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103340:	2b 45 d0             	sub    -0x30(%ebp),%eax
  103343:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  103346:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10334a:	c1 ea 0c             	shr    $0xc,%edx
  10334d:	89 c3                	mov    %eax,%ebx
  10334f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103352:	89 04 24             	mov    %eax,(%esp)
  103355:	e8 ad f8 ff ff       	call   102c07 <pa2page>
  10335a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10335e:	89 04 24             	mov    %eax,(%esp)
  103361:	e8 8c fb ff ff       	call   102ef2 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  103366:	ff 45 dc             	incl   -0x24(%ebp)
  103369:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10336c:	8b 00                	mov    (%eax),%eax
  10336e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103371:	0f 8c a7 fe ff ff    	jl     10321e <page_init+0x266>
                }
            }
        }
    }
}
  103377:	90                   	nop
  103378:	90                   	nop
  103379:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  10337f:	5b                   	pop    %ebx
  103380:	5e                   	pop    %esi
  103381:	5f                   	pop    %edi
  103382:	5d                   	pop    %ebp
  103383:	c3                   	ret    

00103384 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103384:	f3 0f 1e fb          	endbr32 
  103388:	55                   	push   %ebp
  103389:	89 e5                	mov    %esp,%ebp
  10338b:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10338e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103391:	33 45 14             	xor    0x14(%ebp),%eax
  103394:	25 ff 0f 00 00       	and    $0xfff,%eax
  103399:	85 c0                	test   %eax,%eax
  10339b:	74 24                	je     1033c1 <boot_map_segment+0x3d>
  10339d:	c7 44 24 0c 56 a9 10 	movl   $0x10a956,0xc(%esp)
  1033a4:	00 
  1033a5:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  1033ac:	00 
  1033ad:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  1033b4:	00 
  1033b5:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  1033bc:	e8 75 d0 ff ff       	call   100436 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1033c1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1033c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033cb:	25 ff 0f 00 00       	and    $0xfff,%eax
  1033d0:	89 c2                	mov    %eax,%edx
  1033d2:	8b 45 10             	mov    0x10(%ebp),%eax
  1033d5:	01 c2                	add    %eax,%edx
  1033d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033da:	01 d0                	add    %edx,%eax
  1033dc:	48                   	dec    %eax
  1033dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033e3:	ba 00 00 00 00       	mov    $0x0,%edx
  1033e8:	f7 75 f0             	divl   -0x10(%ebp)
  1033eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033ee:	29 d0                	sub    %edx,%eax
  1033f0:	c1 e8 0c             	shr    $0xc,%eax
  1033f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1033f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103404:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  103407:	8b 45 14             	mov    0x14(%ebp),%eax
  10340a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10340d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103410:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103415:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103418:	eb 68                	jmp    103482 <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10341a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103421:	00 
  103422:	8b 45 0c             	mov    0xc(%ebp),%eax
  103425:	89 44 24 04          	mov    %eax,0x4(%esp)
  103429:	8b 45 08             	mov    0x8(%ebp),%eax
  10342c:	89 04 24             	mov    %eax,(%esp)
  10342f:	e8 8a 01 00 00       	call   1035be <get_pte>
  103434:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103437:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10343b:	75 24                	jne    103461 <boot_map_segment+0xdd>
  10343d:	c7 44 24 0c 82 a9 10 	movl   $0x10a982,0xc(%esp)
  103444:	00 
  103445:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  10344c:	00 
  10344d:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  103454:	00 
  103455:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  10345c:	e8 d5 cf ff ff       	call   100436 <__panic>
        *ptep = pa | PTE_P | perm;
  103461:	8b 45 14             	mov    0x14(%ebp),%eax
  103464:	0b 45 18             	or     0x18(%ebp),%eax
  103467:	83 c8 01             	or     $0x1,%eax
  10346a:	89 c2                	mov    %eax,%edx
  10346c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10346f:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103471:	ff 4d f4             	decl   -0xc(%ebp)
  103474:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10347b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103486:	75 92                	jne    10341a <boot_map_segment+0x96>
    }
}
  103488:	90                   	nop
  103489:	90                   	nop
  10348a:	c9                   	leave  
  10348b:	c3                   	ret    

0010348c <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10348c:	f3 0f 1e fb          	endbr32 
  103490:	55                   	push   %ebp
  103491:	89 e5                	mov    %esp,%ebp
  103493:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  103496:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10349d:	e8 74 fa ff ff       	call   102f16 <alloc_pages>
  1034a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1034a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1034a9:	75 1c                	jne    1034c7 <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
  1034ab:	c7 44 24 08 8f a9 10 	movl   $0x10a98f,0x8(%esp)
  1034b2:	00 
  1034b3:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  1034ba:	00 
  1034bb:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  1034c2:	e8 6f cf ff ff       	call   100436 <__panic>
    }
    return page2kva(p);
  1034c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034ca:	89 04 24             	mov    %eax,(%esp)
  1034cd:	e8 84 f7 ff ff       	call   102c56 <page2kva>
}
  1034d2:	c9                   	leave  
  1034d3:	c3                   	ret    

001034d4 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1034d4:	f3 0f 1e fb          	endbr32 
  1034d8:	55                   	push   %ebp
  1034d9:	89 e5                	mov    %esp,%ebp
  1034db:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1034de:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  1034e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1034e6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1034ed:	77 23                	ja     103512 <pmm_init+0x3e>
  1034ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1034f6:	c7 44 24 08 24 a9 10 	movl   $0x10a924,0x8(%esp)
  1034fd:	00 
  1034fe:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  103505:	00 
  103506:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  10350d:	e8 24 cf ff ff       	call   100436 <__panic>
  103512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103515:	05 00 00 00 40       	add    $0x40000000,%eax
  10351a:	a3 30 3f 12 00       	mov    %eax,0x123f30
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  10351f:	e8 96 f9 ff ff       	call   102eba <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  103524:	e8 8f fa ff ff       	call   102fb8 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  103529:	e8 1a 04 00 00       	call   103948 <check_alloc_page>

    check_pgdir();
  10352e:	e8 38 04 00 00       	call   10396b <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103533:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103538:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10353b:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103542:	77 23                	ja     103567 <pmm_init+0x93>
  103544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103547:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10354b:	c7 44 24 08 24 a9 10 	movl   $0x10a924,0x8(%esp)
  103552:	00 
  103553:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
  10355a:	00 
  10355b:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103562:	e8 cf ce ff ff       	call   100436 <__panic>
  103567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10356a:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  103570:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103575:	05 ac 0f 00 00       	add    $0xfac,%eax
  10357a:	83 ca 03             	or     $0x3,%edx
  10357d:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10357f:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103584:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  10358b:	00 
  10358c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103593:	00 
  103594:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10359b:	38 
  10359c:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1035a3:	c0 
  1035a4:	89 04 24             	mov    %eax,(%esp)
  1035a7:	e8 d8 fd ff ff       	call   103384 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1035ac:	e8 1b f8 ff ff       	call   102dcc <gdt_init>

    //now the basic virtual memory map(see memlayout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1035b1:	e8 55 0a 00 00       	call   10400b <check_boot_pgdir>

    print_pgdir();
  1035b6:	e8 da 0e 00 00       	call   104495 <print_pgdir>

}
  1035bb:	90                   	nop
  1035bc:	c9                   	leave  
  1035bd:	c3                   	ret    

001035be <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1035be:	f3 0f 1e fb          	endbr32 
  1035c2:	55                   	push   %ebp
  1035c3:	89 e5                	mov    %esp,%ebp
  1035c5:	83 ec 38             	sub    $0x38,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
// #if 0
    pde_t *pdep = &pgdir[PDX(la)];                      // (1) find page directory entry
  1035c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035cb:	c1 e8 16             	shr    $0x16,%eax
  1035ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1035d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1035d8:	01 d0                	add    %edx,%eax
  1035da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {                             // (2) check if entry is not present
  1035dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035e0:	8b 00                	mov    (%eax),%eax
  1035e2:	83 e0 01             	and    $0x1,%eax
  1035e5:	85 c0                	test   %eax,%eax
  1035e7:	0f 85 d6 00 00 00    	jne    1036c3 <get_pte+0x105>
        if (create){
  1035ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1035f1:	0f 84 c5 00 00 00    	je     1036bc <get_pte+0xfe>
            struct Page* page =  alloc_page();          // (3) check if creating is needed, then alloc page for page table    
  1035f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1035fe:	e8 13 f9 ff ff       	call   102f16 <alloc_pages>
  103603:	89 45 f0             	mov    %eax,-0x10(%ebp)
                                                        // CAUTION: this page is used for page table, not for common data page
            assert (page != NULL);
  103606:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10360a:	75 24                	jne    103630 <get_pte+0x72>
  10360c:	c7 44 24 0c a8 a9 10 	movl   $0x10a9a8,0xc(%esp)
  103613:	00 
  103614:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  10361b:	00 
  10361c:	c7 44 24 04 65 01 00 	movl   $0x165,0x4(%esp)
  103623:	00 
  103624:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  10362b:	e8 06 ce ff ff       	call   100436 <__panic>
            set_page_ref(page, 1);                      // (4) set page reference
  103630:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103637:	00 
  103638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10363b:	89 04 24             	mov    %eax,(%esp)
  10363e:	e8 c7 f6 ff ff       	call   102d0a <set_page_ref>
            uintptr_t pa = page2pa(page);               // (5) get physical address of page
  103643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103646:	89 04 24             	mov    %eax,(%esp)
  103649:	e8 a3 f5 ff ff       	call   102bf1 <page2pa>
  10364e:	89 45 ec             	mov    %eax,-0x14(%ebp)
            memset(KADDR(pa), 0, PGSIZE);               // (6) clear page content using memset
  103651:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103654:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103657:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10365a:	c1 e8 0c             	shr    $0xc,%eax
  10365d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103660:	a1 80 3e 12 00       	mov    0x123e80,%eax
  103665:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103668:	72 23                	jb     10368d <get_pte+0xcf>
  10366a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10366d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103671:	c7 44 24 08 80 a8 10 	movl   $0x10a880,0x8(%esp)
  103678:	00 
  103679:	c7 44 24 04 68 01 00 	movl   $0x168,0x4(%esp)
  103680:	00 
  103681:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103688:	e8 a9 cd ff ff       	call   100436 <__panic>
  10368d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103690:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103695:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10369c:	00 
  10369d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1036a4:	00 
  1036a5:	89 04 24             	mov    %eax,(%esp)
  1036a8:	e8 c9 61 00 00       	call   109876 <memset>
            *pdep = pa | PTE_U | PTE_W | PTE_P;         // (7) set page directory entry's permission
  1036ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036b0:	83 c8 07             	or     $0x7,%eax
  1036b3:	89 c2                	mov    %eax,%edx
  1036b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036b8:	89 10                	mov    %edx,(%eax)
  1036ba:	eb 07                	jmp    1036c3 <get_pte+0x105>
        }
        else
            return NULL;
  1036bc:	b8 00 00 00 00       	mov    $0x0,%eax
  1036c1:	eb 5d                	jmp    103720 <get_pte+0x162>
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; // (8) return page table entry
  1036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036c6:	8b 00                	mov    (%eax),%eax
  1036c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1036cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1036d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1036d3:	c1 e8 0c             	shr    $0xc,%eax
  1036d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1036d9:	a1 80 3e 12 00       	mov    0x123e80,%eax
  1036de:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1036e1:	72 23                	jb     103706 <get_pte+0x148>
  1036e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1036e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1036ea:	c7 44 24 08 80 a8 10 	movl   $0x10a880,0x8(%esp)
  1036f1:	00 
  1036f2:	c7 44 24 04 6e 01 00 	movl   $0x16e,0x4(%esp)
  1036f9:	00 
  1036fa:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103701:	e8 30 cd ff ff       	call   100436 <__panic>
  103706:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103709:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10370e:	89 c2                	mov    %eax,%edx
  103710:	8b 45 0c             	mov    0xc(%ebp),%eax
  103713:	c1 e8 0c             	shr    $0xc,%eax
  103716:	25 ff 03 00 00       	and    $0x3ff,%eax
  10371b:	c1 e0 02             	shl    $0x2,%eax
  10371e:	01 d0                	add    %edx,%eax
// #endif
}
  103720:	c9                   	leave  
  103721:	c3                   	ret    

00103722 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  103722:	f3 0f 1e fb          	endbr32 
  103726:	55                   	push   %ebp
  103727:	89 e5                	mov    %esp,%ebp
  103729:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10372c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103733:	00 
  103734:	8b 45 0c             	mov    0xc(%ebp),%eax
  103737:	89 44 24 04          	mov    %eax,0x4(%esp)
  10373b:	8b 45 08             	mov    0x8(%ebp),%eax
  10373e:	89 04 24             	mov    %eax,(%esp)
  103741:	e8 78 fe ff ff       	call   1035be <get_pte>
  103746:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  103749:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10374d:	74 08                	je     103757 <get_page+0x35>
        *ptep_store = ptep;
  10374f:	8b 45 10             	mov    0x10(%ebp),%eax
  103752:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103755:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  103757:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10375b:	74 1b                	je     103778 <get_page+0x56>
  10375d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103760:	8b 00                	mov    (%eax),%eax
  103762:	83 e0 01             	and    $0x1,%eax
  103765:	85 c0                	test   %eax,%eax
  103767:	74 0f                	je     103778 <get_page+0x56>
        return pte2page(*ptep);
  103769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10376c:	8b 00                	mov    (%eax),%eax
  10376e:	89 04 24             	mov    %eax,(%esp)
  103771:	e8 34 f5 ff ff       	call   102caa <pte2page>
  103776:	eb 05                	jmp    10377d <get_page+0x5b>
    }
    return NULL;
  103778:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10377d:	c9                   	leave  
  10377e:	c3                   	ret    

0010377f <page_remove_pte>:

//page_remove_pte - free a Page struct which is related to linear address la
//                - and clean(invalidate) pte which is related to linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10377f:	55                   	push   %ebp
  103780:	89 e5                	mov    %esp,%ebp
  103782:	83 ec 28             	sub    $0x28,%esp
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
// #if 0
     if (*ptep & PTE_P) {                     //(1) check if this page table entry is present
  103785:	8b 45 10             	mov    0x10(%ebp),%eax
  103788:	8b 00                	mov    (%eax),%eax
  10378a:	83 e0 01             	and    $0x1,%eax
  10378d:	85 c0                	test   %eax,%eax
  10378f:	74 4d                	je     1037de <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);  //(2) find corresponding page to pte
  103791:	8b 45 10             	mov    0x10(%ebp),%eax
  103794:	8b 00                	mov    (%eax),%eax
  103796:	89 04 24             	mov    %eax,(%esp)
  103799:	e8 0c f5 ff ff       	call   102caa <pte2page>
  10379e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0)          //(3) decrease page reference
  1037a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037a4:	89 04 24             	mov    %eax,(%esp)
  1037a7:	e8 83 f5 ff ff       	call   102d2f <page_ref_dec>
  1037ac:	85 c0                	test   %eax,%eax
  1037ae:	75 13                	jne    1037c3 <page_remove_pte+0x44>
            free_page(page);                  //(4) and free this page when page reference reaches 0      
  1037b0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037b7:	00 
  1037b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037bb:	89 04 24             	mov    %eax,(%esp)
  1037be:	e8 8f f7 ff ff       	call   102f52 <free_pages>
        *ptep = 0;                            //(5) clear second page table entry
  1037c3:	8b 45 10             	mov    0x10(%ebp),%eax
  1037c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);            //(6) flush tlb
  1037cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1037d6:	89 04 24             	mov    %eax,(%esp)
  1037d9:	e8 09 01 00 00       	call   1038e7 <tlb_invalidate>
    }
// #endif
}
  1037de:	90                   	nop
  1037df:	c9                   	leave  
  1037e0:	c3                   	ret    

001037e1 <page_remove>:

//page_remove - free a Page which is related to linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1037e1:	f3 0f 1e fb          	endbr32 
  1037e5:	55                   	push   %ebp
  1037e6:	89 e5                	mov    %esp,%ebp
  1037e8:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1037eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1037f2:	00 
  1037f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1037fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1037fd:	89 04 24             	mov    %eax,(%esp)
  103800:	e8 b9 fd ff ff       	call   1035be <get_pte>
  103805:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103808:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10380c:	74 19                	je     103827 <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
  10380e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103811:	89 44 24 08          	mov    %eax,0x8(%esp)
  103815:	8b 45 0c             	mov    0xc(%ebp),%eax
  103818:	89 44 24 04          	mov    %eax,0x4(%esp)
  10381c:	8b 45 08             	mov    0x8(%ebp),%eax
  10381f:	89 04 24             	mov    %eax,(%esp)
  103822:	e8 58 ff ff ff       	call   10377f <page_remove_pte>
    }
}
  103827:	90                   	nop
  103828:	c9                   	leave  
  103829:	c3                   	ret    

0010382a <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10382a:	f3 0f 1e fb          	endbr32 
  10382e:	55                   	push   %ebp
  10382f:	89 e5                	mov    %esp,%ebp
  103831:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103834:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10383b:	00 
  10383c:	8b 45 10             	mov    0x10(%ebp),%eax
  10383f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103843:	8b 45 08             	mov    0x8(%ebp),%eax
  103846:	89 04 24             	mov    %eax,(%esp)
  103849:	e8 70 fd ff ff       	call   1035be <get_pte>
  10384e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  103851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103855:	75 0a                	jne    103861 <page_insert+0x37>
        return -E_NO_MEM;
  103857:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10385c:	e9 84 00 00 00       	jmp    1038e5 <page_insert+0xbb>
    }
    page_ref_inc(page);
  103861:	8b 45 0c             	mov    0xc(%ebp),%eax
  103864:	89 04 24             	mov    %eax,(%esp)
  103867:	e8 ac f4 ff ff       	call   102d18 <page_ref_inc>
    if (*ptep & PTE_P) {
  10386c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10386f:	8b 00                	mov    (%eax),%eax
  103871:	83 e0 01             	and    $0x1,%eax
  103874:	85 c0                	test   %eax,%eax
  103876:	74 3e                	je     1038b6 <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
  103878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10387b:	8b 00                	mov    (%eax),%eax
  10387d:	89 04 24             	mov    %eax,(%esp)
  103880:	e8 25 f4 ff ff       	call   102caa <pte2page>
  103885:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  103888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10388b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10388e:	75 0d                	jne    10389d <page_insert+0x73>
            page_ref_dec(page);
  103890:	8b 45 0c             	mov    0xc(%ebp),%eax
  103893:	89 04 24             	mov    %eax,(%esp)
  103896:	e8 94 f4 ff ff       	call   102d2f <page_ref_dec>
  10389b:	eb 19                	jmp    1038b6 <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  10389d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1038a4:	8b 45 10             	mov    0x10(%ebp),%eax
  1038a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1038ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1038ae:	89 04 24             	mov    %eax,(%esp)
  1038b1:	e8 c9 fe ff ff       	call   10377f <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1038b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1038b9:	89 04 24             	mov    %eax,(%esp)
  1038bc:	e8 30 f3 ff ff       	call   102bf1 <page2pa>
  1038c1:	0b 45 14             	or     0x14(%ebp),%eax
  1038c4:	83 c8 01             	or     $0x1,%eax
  1038c7:	89 c2                	mov    %eax,%edx
  1038c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038cc:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1038ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1038d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1038d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1038d8:	89 04 24             	mov    %eax,(%esp)
  1038db:	e8 07 00 00 00       	call   1038e7 <tlb_invalidate>
    return 0;
  1038e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1038e5:	c9                   	leave  
  1038e6:	c3                   	ret    

001038e7 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1038e7:	f3 0f 1e fb          	endbr32 
  1038eb:	55                   	push   %ebp
  1038ec:	89 e5                	mov    %esp,%ebp
  1038ee:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1038f1:	0f 20 d8             	mov    %cr3,%eax
  1038f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1038f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  1038fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1038fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103900:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103907:	77 23                	ja     10392c <tlb_invalidate+0x45>
  103909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10390c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103910:	c7 44 24 08 24 a9 10 	movl   $0x10a924,0x8(%esp)
  103917:	00 
  103918:	c7 44 24 04 c9 01 00 	movl   $0x1c9,0x4(%esp)
  10391f:	00 
  103920:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103927:	e8 0a cb ff ff       	call   100436 <__panic>
  10392c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10392f:	05 00 00 00 40       	add    $0x40000000,%eax
  103934:	39 d0                	cmp    %edx,%eax
  103936:	75 0d                	jne    103945 <tlb_invalidate+0x5e>
        invlpg((void *)la);
  103938:	8b 45 0c             	mov    0xc(%ebp),%eax
  10393b:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10393e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103941:	0f 01 38             	invlpg (%eax)
}
  103944:	90                   	nop
    }
}
  103945:	90                   	nop
  103946:	c9                   	leave  
  103947:	c3                   	ret    

00103948 <check_alloc_page>:

static void
check_alloc_page(void) {
  103948:	f3 0f 1e fb          	endbr32 
  10394c:	55                   	push   %ebp
  10394d:	89 e5                	mov    %esp,%ebp
  10394f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  103952:	a1 2c 3f 12 00       	mov    0x123f2c,%eax
  103957:	8b 40 18             	mov    0x18(%eax),%eax
  10395a:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10395c:	c7 04 24 b8 a9 10 00 	movl   $0x10a9b8,(%esp)
  103963:	e8 62 c9 ff ff       	call   1002ca <cprintf>
}
  103968:	90                   	nop
  103969:	c9                   	leave  
  10396a:	c3                   	ret    

0010396b <check_pgdir>:

static void
check_pgdir(void) {
  10396b:	f3 0f 1e fb          	endbr32 
  10396f:	55                   	push   %ebp
  103970:	89 e5                	mov    %esp,%ebp
  103972:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  103975:	a1 80 3e 12 00       	mov    0x123e80,%eax
  10397a:	3d 00 80 03 00       	cmp    $0x38000,%eax
  10397f:	76 24                	jbe    1039a5 <check_pgdir+0x3a>
  103981:	c7 44 24 0c d7 a9 10 	movl   $0x10a9d7,0xc(%esp)
  103988:	00 
  103989:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103990:	00 
  103991:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
  103998:	00 
  103999:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  1039a0:	e8 91 ca ff ff       	call   100436 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1039a5:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  1039aa:	85 c0                	test   %eax,%eax
  1039ac:	74 0e                	je     1039bc <check_pgdir+0x51>
  1039ae:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  1039b3:	25 ff 0f 00 00       	and    $0xfff,%eax
  1039b8:	85 c0                	test   %eax,%eax
  1039ba:	74 24                	je     1039e0 <check_pgdir+0x75>
  1039bc:	c7 44 24 0c f4 a9 10 	movl   $0x10a9f4,0xc(%esp)
  1039c3:	00 
  1039c4:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  1039cb:	00 
  1039cc:	c7 44 24 04 d7 01 00 	movl   $0x1d7,0x4(%esp)
  1039d3:	00 
  1039d4:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  1039db:	e8 56 ca ff ff       	call   100436 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1039e0:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  1039e5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1039ec:	00 
  1039ed:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1039f4:	00 
  1039f5:	89 04 24             	mov    %eax,(%esp)
  1039f8:	e8 25 fd ff ff       	call   103722 <get_page>
  1039fd:	85 c0                	test   %eax,%eax
  1039ff:	74 24                	je     103a25 <check_pgdir+0xba>
  103a01:	c7 44 24 0c 2c aa 10 	movl   $0x10aa2c,0xc(%esp)
  103a08:	00 
  103a09:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103a10:	00 
  103a11:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
  103a18:	00 
  103a19:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103a20:	e8 11 ca ff ff       	call   100436 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103a25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103a2c:	e8 e5 f4 ff ff       	call   102f16 <alloc_pages>
  103a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  103a34:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103a39:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103a40:	00 
  103a41:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103a48:	00 
  103a49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103a4c:	89 54 24 04          	mov    %edx,0x4(%esp)
  103a50:	89 04 24             	mov    %eax,(%esp)
  103a53:	e8 d2 fd ff ff       	call   10382a <page_insert>
  103a58:	85 c0                	test   %eax,%eax
  103a5a:	74 24                	je     103a80 <check_pgdir+0x115>
  103a5c:	c7 44 24 0c 54 aa 10 	movl   $0x10aa54,0xc(%esp)
  103a63:	00 
  103a64:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103a6b:	00 
  103a6c:	c7 44 24 04 dc 01 00 	movl   $0x1dc,0x4(%esp)
  103a73:	00 
  103a74:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103a7b:	e8 b6 c9 ff ff       	call   100436 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103a80:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103a85:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103a8c:	00 
  103a8d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103a94:	00 
  103a95:	89 04 24             	mov    %eax,(%esp)
  103a98:	e8 21 fb ff ff       	call   1035be <get_pte>
  103a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103aa0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103aa4:	75 24                	jne    103aca <check_pgdir+0x15f>
  103aa6:	c7 44 24 0c 80 aa 10 	movl   $0x10aa80,0xc(%esp)
  103aad:	00 
  103aae:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103ab5:	00 
  103ab6:	c7 44 24 04 df 01 00 	movl   $0x1df,0x4(%esp)
  103abd:	00 
  103abe:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103ac5:	e8 6c c9 ff ff       	call   100436 <__panic>
    assert(pte2page(*ptep) == p1);
  103aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103acd:	8b 00                	mov    (%eax),%eax
  103acf:	89 04 24             	mov    %eax,(%esp)
  103ad2:	e8 d3 f1 ff ff       	call   102caa <pte2page>
  103ad7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103ada:	74 24                	je     103b00 <check_pgdir+0x195>
  103adc:	c7 44 24 0c ad aa 10 	movl   $0x10aaad,0xc(%esp)
  103ae3:	00 
  103ae4:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103aeb:	00 
  103aec:	c7 44 24 04 e0 01 00 	movl   $0x1e0,0x4(%esp)
  103af3:	00 
  103af4:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103afb:	e8 36 c9 ff ff       	call   100436 <__panic>
    assert(page_ref(p1) == 1);
  103b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b03:	89 04 24             	mov    %eax,(%esp)
  103b06:	e8 f5 f1 ff ff       	call   102d00 <page_ref>
  103b0b:	83 f8 01             	cmp    $0x1,%eax
  103b0e:	74 24                	je     103b34 <check_pgdir+0x1c9>
  103b10:	c7 44 24 0c c3 aa 10 	movl   $0x10aac3,0xc(%esp)
  103b17:	00 
  103b18:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103b1f:	00 
  103b20:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
  103b27:	00 
  103b28:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103b2f:	e8 02 c9 ff ff       	call   100436 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103b34:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103b39:	8b 00                	mov    (%eax),%eax
  103b3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b40:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b46:	c1 e8 0c             	shr    $0xc,%eax
  103b49:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103b4c:	a1 80 3e 12 00       	mov    0x123e80,%eax
  103b51:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103b54:	72 23                	jb     103b79 <check_pgdir+0x20e>
  103b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b59:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103b5d:	c7 44 24 08 80 a8 10 	movl   $0x10a880,0x8(%esp)
  103b64:	00 
  103b65:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  103b6c:	00 
  103b6d:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103b74:	e8 bd c8 ff ff       	call   100436 <__panic>
  103b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b7c:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103b81:	83 c0 04             	add    $0x4,%eax
  103b84:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103b87:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103b8c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103b93:	00 
  103b94:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103b9b:	00 
  103b9c:	89 04 24             	mov    %eax,(%esp)
  103b9f:	e8 1a fa ff ff       	call   1035be <get_pte>
  103ba4:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103ba7:	74 24                	je     103bcd <check_pgdir+0x262>
  103ba9:	c7 44 24 0c d8 aa 10 	movl   $0x10aad8,0xc(%esp)
  103bb0:	00 
  103bb1:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103bb8:	00 
  103bb9:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  103bc0:	00 
  103bc1:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103bc8:	e8 69 c8 ff ff       	call   100436 <__panic>

    p2 = alloc_page();
  103bcd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103bd4:	e8 3d f3 ff ff       	call   102f16 <alloc_pages>
  103bd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103bdc:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103be1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103be8:	00 
  103be9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103bf0:	00 
  103bf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103bf4:	89 54 24 04          	mov    %edx,0x4(%esp)
  103bf8:	89 04 24             	mov    %eax,(%esp)
  103bfb:	e8 2a fc ff ff       	call   10382a <page_insert>
  103c00:	85 c0                	test   %eax,%eax
  103c02:	74 24                	je     103c28 <check_pgdir+0x2bd>
  103c04:	c7 44 24 0c 00 ab 10 	movl   $0x10ab00,0xc(%esp)
  103c0b:	00 
  103c0c:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103c13:	00 
  103c14:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
  103c1b:	00 
  103c1c:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103c23:	e8 0e c8 ff ff       	call   100436 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103c28:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103c2d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103c34:	00 
  103c35:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103c3c:	00 
  103c3d:	89 04 24             	mov    %eax,(%esp)
  103c40:	e8 79 f9 ff ff       	call   1035be <get_pte>
  103c45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c4c:	75 24                	jne    103c72 <check_pgdir+0x307>
  103c4e:	c7 44 24 0c 38 ab 10 	movl   $0x10ab38,0xc(%esp)
  103c55:	00 
  103c56:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103c5d:	00 
  103c5e:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  103c65:	00 
  103c66:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103c6d:	e8 c4 c7 ff ff       	call   100436 <__panic>
    assert(*ptep & PTE_U);
  103c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c75:	8b 00                	mov    (%eax),%eax
  103c77:	83 e0 04             	and    $0x4,%eax
  103c7a:	85 c0                	test   %eax,%eax
  103c7c:	75 24                	jne    103ca2 <check_pgdir+0x337>
  103c7e:	c7 44 24 0c 68 ab 10 	movl   $0x10ab68,0xc(%esp)
  103c85:	00 
  103c86:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103c8d:	00 
  103c8e:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  103c95:	00 
  103c96:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103c9d:	e8 94 c7 ff ff       	call   100436 <__panic>
    assert(*ptep & PTE_W);
  103ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ca5:	8b 00                	mov    (%eax),%eax
  103ca7:	83 e0 02             	and    $0x2,%eax
  103caa:	85 c0                	test   %eax,%eax
  103cac:	75 24                	jne    103cd2 <check_pgdir+0x367>
  103cae:	c7 44 24 0c 76 ab 10 	movl   $0x10ab76,0xc(%esp)
  103cb5:	00 
  103cb6:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103cbd:	00 
  103cbe:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  103cc5:	00 
  103cc6:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103ccd:	e8 64 c7 ff ff       	call   100436 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103cd2:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103cd7:	8b 00                	mov    (%eax),%eax
  103cd9:	83 e0 04             	and    $0x4,%eax
  103cdc:	85 c0                	test   %eax,%eax
  103cde:	75 24                	jne    103d04 <check_pgdir+0x399>
  103ce0:	c7 44 24 0c 84 ab 10 	movl   $0x10ab84,0xc(%esp)
  103ce7:	00 
  103ce8:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103cef:	00 
  103cf0:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  103cf7:	00 
  103cf8:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103cff:	e8 32 c7 ff ff       	call   100436 <__panic>
    assert(page_ref(p2) == 1);
  103d04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d07:	89 04 24             	mov    %eax,(%esp)
  103d0a:	e8 f1 ef ff ff       	call   102d00 <page_ref>
  103d0f:	83 f8 01             	cmp    $0x1,%eax
  103d12:	74 24                	je     103d38 <check_pgdir+0x3cd>
  103d14:	c7 44 24 0c 9a ab 10 	movl   $0x10ab9a,0xc(%esp)
  103d1b:	00 
  103d1c:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103d23:	00 
  103d24:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  103d2b:	00 
  103d2c:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103d33:	e8 fe c6 ff ff       	call   100436 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103d38:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103d3d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103d44:	00 
  103d45:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103d4c:	00 
  103d4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103d50:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d54:	89 04 24             	mov    %eax,(%esp)
  103d57:	e8 ce fa ff ff       	call   10382a <page_insert>
  103d5c:	85 c0                	test   %eax,%eax
  103d5e:	74 24                	je     103d84 <check_pgdir+0x419>
  103d60:	c7 44 24 0c ac ab 10 	movl   $0x10abac,0xc(%esp)
  103d67:	00 
  103d68:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103d6f:	00 
  103d70:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  103d77:	00 
  103d78:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103d7f:	e8 b2 c6 ff ff       	call   100436 <__panic>
    assert(page_ref(p1) == 2);
  103d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d87:	89 04 24             	mov    %eax,(%esp)
  103d8a:	e8 71 ef ff ff       	call   102d00 <page_ref>
  103d8f:	83 f8 02             	cmp    $0x2,%eax
  103d92:	74 24                	je     103db8 <check_pgdir+0x44d>
  103d94:	c7 44 24 0c d8 ab 10 	movl   $0x10abd8,0xc(%esp)
  103d9b:	00 
  103d9c:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103da3:	00 
  103da4:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  103dab:	00 
  103dac:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103db3:	e8 7e c6 ff ff       	call   100436 <__panic>
    assert(page_ref(p2) == 0);
  103db8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103dbb:	89 04 24             	mov    %eax,(%esp)
  103dbe:	e8 3d ef ff ff       	call   102d00 <page_ref>
  103dc3:	85 c0                	test   %eax,%eax
  103dc5:	74 24                	je     103deb <check_pgdir+0x480>
  103dc7:	c7 44 24 0c ea ab 10 	movl   $0x10abea,0xc(%esp)
  103dce:	00 
  103dcf:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103dd6:	00 
  103dd7:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  103dde:	00 
  103ddf:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103de6:	e8 4b c6 ff ff       	call   100436 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103deb:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103df0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103df7:	00 
  103df8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103dff:	00 
  103e00:	89 04 24             	mov    %eax,(%esp)
  103e03:	e8 b6 f7 ff ff       	call   1035be <get_pte>
  103e08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103e0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103e0f:	75 24                	jne    103e35 <check_pgdir+0x4ca>
  103e11:	c7 44 24 0c 38 ab 10 	movl   $0x10ab38,0xc(%esp)
  103e18:	00 
  103e19:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103e20:	00 
  103e21:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  103e28:	00 
  103e29:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103e30:	e8 01 c6 ff ff       	call   100436 <__panic>
    assert(pte2page(*ptep) == p1);
  103e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e38:	8b 00                	mov    (%eax),%eax
  103e3a:	89 04 24             	mov    %eax,(%esp)
  103e3d:	e8 68 ee ff ff       	call   102caa <pte2page>
  103e42:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103e45:	74 24                	je     103e6b <check_pgdir+0x500>
  103e47:	c7 44 24 0c ad aa 10 	movl   $0x10aaad,0xc(%esp)
  103e4e:	00 
  103e4f:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103e56:	00 
  103e57:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  103e5e:	00 
  103e5f:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103e66:	e8 cb c5 ff ff       	call   100436 <__panic>
    assert((*ptep & PTE_U) == 0);
  103e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e6e:	8b 00                	mov    (%eax),%eax
  103e70:	83 e0 04             	and    $0x4,%eax
  103e73:	85 c0                	test   %eax,%eax
  103e75:	74 24                	je     103e9b <check_pgdir+0x530>
  103e77:	c7 44 24 0c fc ab 10 	movl   $0x10abfc,0xc(%esp)
  103e7e:	00 
  103e7f:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103e86:	00 
  103e87:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  103e8e:	00 
  103e8f:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103e96:	e8 9b c5 ff ff       	call   100436 <__panic>

    page_remove(boot_pgdir, 0x0);
  103e9b:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103ea0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103ea7:	00 
  103ea8:	89 04 24             	mov    %eax,(%esp)
  103eab:	e8 31 f9 ff ff       	call   1037e1 <page_remove>
    assert(page_ref(p1) == 1);
  103eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103eb3:	89 04 24             	mov    %eax,(%esp)
  103eb6:	e8 45 ee ff ff       	call   102d00 <page_ref>
  103ebb:	83 f8 01             	cmp    $0x1,%eax
  103ebe:	74 24                	je     103ee4 <check_pgdir+0x579>
  103ec0:	c7 44 24 0c c3 aa 10 	movl   $0x10aac3,0xc(%esp)
  103ec7:	00 
  103ec8:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103ecf:	00 
  103ed0:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  103ed7:	00 
  103ed8:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103edf:	e8 52 c5 ff ff       	call   100436 <__panic>
    assert(page_ref(p2) == 0);
  103ee4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ee7:	89 04 24             	mov    %eax,(%esp)
  103eea:	e8 11 ee ff ff       	call   102d00 <page_ref>
  103eef:	85 c0                	test   %eax,%eax
  103ef1:	74 24                	je     103f17 <check_pgdir+0x5ac>
  103ef3:	c7 44 24 0c ea ab 10 	movl   $0x10abea,0xc(%esp)
  103efa:	00 
  103efb:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103f02:	00 
  103f03:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  103f0a:	00 
  103f0b:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103f12:	e8 1f c5 ff ff       	call   100436 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103f17:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103f1c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103f23:	00 
  103f24:	89 04 24             	mov    %eax,(%esp)
  103f27:	e8 b5 f8 ff ff       	call   1037e1 <page_remove>
    assert(page_ref(p1) == 0);
  103f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f2f:	89 04 24             	mov    %eax,(%esp)
  103f32:	e8 c9 ed ff ff       	call   102d00 <page_ref>
  103f37:	85 c0                	test   %eax,%eax
  103f39:	74 24                	je     103f5f <check_pgdir+0x5f4>
  103f3b:	c7 44 24 0c 11 ac 10 	movl   $0x10ac11,0xc(%esp)
  103f42:	00 
  103f43:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103f4a:	00 
  103f4b:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  103f52:	00 
  103f53:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103f5a:	e8 d7 c4 ff ff       	call   100436 <__panic>
    assert(page_ref(p2) == 0);
  103f5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103f62:	89 04 24             	mov    %eax,(%esp)
  103f65:	e8 96 ed ff ff       	call   102d00 <page_ref>
  103f6a:	85 c0                	test   %eax,%eax
  103f6c:	74 24                	je     103f92 <check_pgdir+0x627>
  103f6e:	c7 44 24 0c ea ab 10 	movl   $0x10abea,0xc(%esp)
  103f75:	00 
  103f76:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103f7d:	00 
  103f7e:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  103f85:	00 
  103f86:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103f8d:	e8 a4 c4 ff ff       	call   100436 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103f92:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103f97:	8b 00                	mov    (%eax),%eax
  103f99:	89 04 24             	mov    %eax,(%esp)
  103f9c:	e8 47 ed ff ff       	call   102ce8 <pde2page>
  103fa1:	89 04 24             	mov    %eax,(%esp)
  103fa4:	e8 57 ed ff ff       	call   102d00 <page_ref>
  103fa9:	83 f8 01             	cmp    $0x1,%eax
  103fac:	74 24                	je     103fd2 <check_pgdir+0x667>
  103fae:	c7 44 24 0c 24 ac 10 	movl   $0x10ac24,0xc(%esp)
  103fb5:	00 
  103fb6:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  103fbd:	00 
  103fbe:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  103fc5:	00 
  103fc6:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  103fcd:	e8 64 c4 ff ff       	call   100436 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103fd2:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103fd7:	8b 00                	mov    (%eax),%eax
  103fd9:	89 04 24             	mov    %eax,(%esp)
  103fdc:	e8 07 ed ff ff       	call   102ce8 <pde2page>
  103fe1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103fe8:	00 
  103fe9:	89 04 24             	mov    %eax,(%esp)
  103fec:	e8 61 ef ff ff       	call   102f52 <free_pages>
    boot_pgdir[0] = 0;
  103ff1:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  103ff6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103ffc:	c7 04 24 4b ac 10 00 	movl   $0x10ac4b,(%esp)
  104003:	e8 c2 c2 ff ff       	call   1002ca <cprintf>
}
  104008:	90                   	nop
  104009:	c9                   	leave  
  10400a:	c3                   	ret    

0010400b <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  10400b:	f3 0f 1e fb          	endbr32 
  10400f:	55                   	push   %ebp
  104010:	89 e5                	mov    %esp,%ebp
  104012:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104015:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10401c:	e9 ca 00 00 00       	jmp    1040eb <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104024:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10402a:	c1 e8 0c             	shr    $0xc,%eax
  10402d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104030:	a1 80 3e 12 00       	mov    0x123e80,%eax
  104035:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104038:	72 23                	jb     10405d <check_boot_pgdir+0x52>
  10403a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10403d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104041:	c7 44 24 08 80 a8 10 	movl   $0x10a880,0x8(%esp)
  104048:	00 
  104049:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104050:	00 
  104051:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  104058:	e8 d9 c3 ff ff       	call   100436 <__panic>
  10405d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104060:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104065:	89 c2                	mov    %eax,%edx
  104067:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  10406c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104073:	00 
  104074:	89 54 24 04          	mov    %edx,0x4(%esp)
  104078:	89 04 24             	mov    %eax,(%esp)
  10407b:	e8 3e f5 ff ff       	call   1035be <get_pte>
  104080:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104083:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104087:	75 24                	jne    1040ad <check_boot_pgdir+0xa2>
  104089:	c7 44 24 0c 68 ac 10 	movl   $0x10ac68,0xc(%esp)
  104090:	00 
  104091:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  104098:	00 
  104099:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  1040a0:	00 
  1040a1:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  1040a8:	e8 89 c3 ff ff       	call   100436 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  1040ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1040b0:	8b 00                	mov    (%eax),%eax
  1040b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1040b7:	89 c2                	mov    %eax,%edx
  1040b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1040bc:	39 c2                	cmp    %eax,%edx
  1040be:	74 24                	je     1040e4 <check_boot_pgdir+0xd9>
  1040c0:	c7 44 24 0c a5 ac 10 	movl   $0x10aca5,0xc(%esp)
  1040c7:	00 
  1040c8:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  1040cf:	00 
  1040d0:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  1040d7:	00 
  1040d8:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  1040df:	e8 52 c3 ff ff       	call   100436 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  1040e4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  1040eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1040ee:	a1 80 3e 12 00       	mov    0x123e80,%eax
  1040f3:	39 c2                	cmp    %eax,%edx
  1040f5:	0f 82 26 ff ff ff    	jb     104021 <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  1040fb:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  104100:	05 ac 0f 00 00       	add    $0xfac,%eax
  104105:	8b 00                	mov    (%eax),%eax
  104107:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10410c:	89 c2                	mov    %eax,%edx
  10410e:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  104113:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104116:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10411d:	77 23                	ja     104142 <check_boot_pgdir+0x137>
  10411f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104122:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104126:	c7 44 24 08 24 a9 10 	movl   $0x10a924,0x8(%esp)
  10412d:	00 
  10412e:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104135:	00 
  104136:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  10413d:	e8 f4 c2 ff ff       	call   100436 <__panic>
  104142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104145:	05 00 00 00 40       	add    $0x40000000,%eax
  10414a:	39 d0                	cmp    %edx,%eax
  10414c:	74 24                	je     104172 <check_boot_pgdir+0x167>
  10414e:	c7 44 24 0c bc ac 10 	movl   $0x10acbc,0xc(%esp)
  104155:	00 
  104156:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  10415d:	00 
  10415e:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104165:	00 
  104166:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  10416d:	e8 c4 c2 ff ff       	call   100436 <__panic>

    assert(boot_pgdir[0] == 0);
  104172:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  104177:	8b 00                	mov    (%eax),%eax
  104179:	85 c0                	test   %eax,%eax
  10417b:	74 24                	je     1041a1 <check_boot_pgdir+0x196>
  10417d:	c7 44 24 0c f0 ac 10 	movl   $0x10acf0,0xc(%esp)
  104184:	00 
  104185:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  10418c:	00 
  10418d:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104194:	00 
  104195:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  10419c:	e8 95 c2 ff ff       	call   100436 <__panic>

    struct Page *p;
    p = alloc_page();
  1041a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1041a8:	e8 69 ed ff ff       	call   102f16 <alloc_pages>
  1041ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  1041b0:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  1041b5:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1041bc:	00 
  1041bd:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  1041c4:	00 
  1041c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1041c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  1041cc:	89 04 24             	mov    %eax,(%esp)
  1041cf:	e8 56 f6 ff ff       	call   10382a <page_insert>
  1041d4:	85 c0                	test   %eax,%eax
  1041d6:	74 24                	je     1041fc <check_boot_pgdir+0x1f1>
  1041d8:	c7 44 24 0c 04 ad 10 	movl   $0x10ad04,0xc(%esp)
  1041df:	00 
  1041e0:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  1041e7:	00 
  1041e8:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  1041ef:	00 
  1041f0:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  1041f7:	e8 3a c2 ff ff       	call   100436 <__panic>
    assert(page_ref(p) == 1);
  1041fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041ff:	89 04 24             	mov    %eax,(%esp)
  104202:	e8 f9 ea ff ff       	call   102d00 <page_ref>
  104207:	83 f8 01             	cmp    $0x1,%eax
  10420a:	74 24                	je     104230 <check_boot_pgdir+0x225>
  10420c:	c7 44 24 0c 32 ad 10 	movl   $0x10ad32,0xc(%esp)
  104213:	00 
  104214:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  10421b:	00 
  10421c:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104223:	00 
  104224:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  10422b:	e8 06 c2 ff ff       	call   100436 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104230:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  104235:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10423c:	00 
  10423d:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104244:	00 
  104245:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104248:	89 54 24 04          	mov    %edx,0x4(%esp)
  10424c:	89 04 24             	mov    %eax,(%esp)
  10424f:	e8 d6 f5 ff ff       	call   10382a <page_insert>
  104254:	85 c0                	test   %eax,%eax
  104256:	74 24                	je     10427c <check_boot_pgdir+0x271>
  104258:	c7 44 24 0c 44 ad 10 	movl   $0x10ad44,0xc(%esp)
  10425f:	00 
  104260:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  104267:	00 
  104268:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  10426f:	00 
  104270:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  104277:	e8 ba c1 ff ff       	call   100436 <__panic>
    assert(page_ref(p) == 2);
  10427c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10427f:	89 04 24             	mov    %eax,(%esp)
  104282:	e8 79 ea ff ff       	call   102d00 <page_ref>
  104287:	83 f8 02             	cmp    $0x2,%eax
  10428a:	74 24                	je     1042b0 <check_boot_pgdir+0x2a5>
  10428c:	c7 44 24 0c 7b ad 10 	movl   $0x10ad7b,0xc(%esp)
  104293:	00 
  104294:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  10429b:	00 
  10429c:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  1042a3:	00 
  1042a4:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  1042ab:	e8 86 c1 ff ff       	call   100436 <__panic>

    const char *str = "ucore: Hello world!!";
  1042b0:	c7 45 e8 8c ad 10 00 	movl   $0x10ad8c,-0x18(%ebp)
    strcpy((void *)0x100, str);
  1042b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1042ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1042be:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1042c5:	e8 c8 52 00 00       	call   109592 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1042ca:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1042d1:	00 
  1042d2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1042d9:	e8 32 53 00 00       	call   109610 <strcmp>
  1042de:	85 c0                	test   %eax,%eax
  1042e0:	74 24                	je     104306 <check_boot_pgdir+0x2fb>
  1042e2:	c7 44 24 0c a4 ad 10 	movl   $0x10ada4,0xc(%esp)
  1042e9:	00 
  1042ea:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  1042f1:	00 
  1042f2:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  1042f9:	00 
  1042fa:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  104301:	e8 30 c1 ff ff       	call   100436 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104306:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104309:	89 04 24             	mov    %eax,(%esp)
  10430c:	e8 45 e9 ff ff       	call   102c56 <page2kva>
  104311:	05 00 01 00 00       	add    $0x100,%eax
  104316:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104319:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104320:	e8 0f 52 00 00       	call   109534 <strlen>
  104325:	85 c0                	test   %eax,%eax
  104327:	74 24                	je     10434d <check_boot_pgdir+0x342>
  104329:	c7 44 24 0c dc ad 10 	movl   $0x10addc,0xc(%esp)
  104330:	00 
  104331:	c7 44 24 08 6d a9 10 	movl   $0x10a96d,0x8(%esp)
  104338:	00 
  104339:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104340:	00 
  104341:	c7 04 24 48 a9 10 00 	movl   $0x10a948,(%esp)
  104348:	e8 e9 c0 ff ff       	call   100436 <__panic>

    free_page(p);
  10434d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104354:	00 
  104355:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104358:	89 04 24             	mov    %eax,(%esp)
  10435b:	e8 f2 eb ff ff       	call   102f52 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  104360:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  104365:	8b 00                	mov    (%eax),%eax
  104367:	89 04 24             	mov    %eax,(%esp)
  10436a:	e8 79 e9 ff ff       	call   102ce8 <pde2page>
  10436f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104376:	00 
  104377:	89 04 24             	mov    %eax,(%esp)
  10437a:	e8 d3 eb ff ff       	call   102f52 <free_pages>
    boot_pgdir[0] = 0;
  10437f:	a1 e0 09 12 00       	mov    0x1209e0,%eax
  104384:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  10438a:	c7 04 24 00 ae 10 00 	movl   $0x10ae00,(%esp)
  104391:	e8 34 bf ff ff       	call   1002ca <cprintf>
}
  104396:	90                   	nop
  104397:	c9                   	leave  
  104398:	c3                   	ret    

00104399 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  104399:	f3 0f 1e fb          	endbr32 
  10439d:	55                   	push   %ebp
  10439e:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1043a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1043a3:	83 e0 04             	and    $0x4,%eax
  1043a6:	85 c0                	test   %eax,%eax
  1043a8:	74 04                	je     1043ae <perm2str+0x15>
  1043aa:	b0 75                	mov    $0x75,%al
  1043ac:	eb 02                	jmp    1043b0 <perm2str+0x17>
  1043ae:	b0 2d                	mov    $0x2d,%al
  1043b0:	a2 08 3f 12 00       	mov    %al,0x123f08
    str[1] = 'r';
  1043b5:	c6 05 09 3f 12 00 72 	movb   $0x72,0x123f09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1043bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1043bf:	83 e0 02             	and    $0x2,%eax
  1043c2:	85 c0                	test   %eax,%eax
  1043c4:	74 04                	je     1043ca <perm2str+0x31>
  1043c6:	b0 77                	mov    $0x77,%al
  1043c8:	eb 02                	jmp    1043cc <perm2str+0x33>
  1043ca:	b0 2d                	mov    $0x2d,%al
  1043cc:	a2 0a 3f 12 00       	mov    %al,0x123f0a
    str[3] = '\0';
  1043d1:	c6 05 0b 3f 12 00 00 	movb   $0x0,0x123f0b
    return str;
  1043d8:	b8 08 3f 12 00       	mov    $0x123f08,%eax
}
  1043dd:	5d                   	pop    %ebp
  1043de:	c3                   	ret    

001043df <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1043df:	f3 0f 1e fb          	endbr32 
  1043e3:	55                   	push   %ebp
  1043e4:	89 e5                	mov    %esp,%ebp
  1043e6:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1043e9:	8b 45 10             	mov    0x10(%ebp),%eax
  1043ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1043ef:	72 0d                	jb     1043fe <get_pgtable_items+0x1f>
        return 0;
  1043f1:	b8 00 00 00 00       	mov    $0x0,%eax
  1043f6:	e9 98 00 00 00       	jmp    104493 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  1043fb:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  1043fe:	8b 45 10             	mov    0x10(%ebp),%eax
  104401:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104404:	73 18                	jae    10441e <get_pgtable_items+0x3f>
  104406:	8b 45 10             	mov    0x10(%ebp),%eax
  104409:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104410:	8b 45 14             	mov    0x14(%ebp),%eax
  104413:	01 d0                	add    %edx,%eax
  104415:	8b 00                	mov    (%eax),%eax
  104417:	83 e0 01             	and    $0x1,%eax
  10441a:	85 c0                	test   %eax,%eax
  10441c:	74 dd                	je     1043fb <get_pgtable_items+0x1c>
    }
    if (start < right) {
  10441e:	8b 45 10             	mov    0x10(%ebp),%eax
  104421:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104424:	73 68                	jae    10448e <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  104426:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10442a:	74 08                	je     104434 <get_pgtable_items+0x55>
            *left_store = start;
  10442c:	8b 45 18             	mov    0x18(%ebp),%eax
  10442f:	8b 55 10             	mov    0x10(%ebp),%edx
  104432:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);       while (start < right && (table[start] & PTE_USER) == perm) {
  104434:	8b 45 10             	mov    0x10(%ebp),%eax
  104437:	8d 50 01             	lea    0x1(%eax),%edx
  10443a:	89 55 10             	mov    %edx,0x10(%ebp)
  10443d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104444:	8b 45 14             	mov    0x14(%ebp),%eax
  104447:	01 d0                	add    %edx,%eax
  104449:	8b 00                	mov    (%eax),%eax
  10444b:	83 e0 07             	and    $0x7,%eax
  10444e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  104451:	eb 03                	jmp    104456 <get_pgtable_items+0x77>
            start ++;
  104453:	ff 45 10             	incl   0x10(%ebp)
        int perm = (table[start ++] & PTE_USER);       while (start < right && (table[start] & PTE_USER) == perm) {
  104456:	8b 45 10             	mov    0x10(%ebp),%eax
  104459:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10445c:	73 1d                	jae    10447b <get_pgtable_items+0x9c>
  10445e:	8b 45 10             	mov    0x10(%ebp),%eax
  104461:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104468:	8b 45 14             	mov    0x14(%ebp),%eax
  10446b:	01 d0                	add    %edx,%eax
  10446d:	8b 00                	mov    (%eax),%eax
  10446f:	83 e0 07             	and    $0x7,%eax
  104472:	89 c2                	mov    %eax,%edx
  104474:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104477:	39 c2                	cmp    %eax,%edx
  104479:	74 d8                	je     104453 <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
  10447b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10447f:	74 08                	je     104489 <get_pgtable_items+0xaa>
            *right_store = start;
  104481:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104484:	8b 55 10             	mov    0x10(%ebp),%edx
  104487:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  104489:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10448c:	eb 05                	jmp    104493 <get_pgtable_items+0xb4>
    }
    return 0;
  10448e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104493:	c9                   	leave  
  104494:	c3                   	ret    

00104495 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104495:	f3 0f 1e fb          	endbr32 
  104499:	55                   	push   %ebp
  10449a:	89 e5                	mov    %esp,%ebp
  10449c:	57                   	push   %edi
  10449d:	56                   	push   %esi
  10449e:	53                   	push   %ebx
  10449f:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1044a2:	c7 04 24 20 ae 10 00 	movl   $0x10ae20,(%esp)
  1044a9:	e8 1c be ff ff       	call   1002ca <cprintf>
    size_t left, right = 0, perm;
  1044ae:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1044b5:	e9 fa 00 00 00       	jmp    1045b4 <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1044ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1044bd:	89 04 24             	mov    %eax,(%esp)
  1044c0:	e8 d4 fe ff ff       	call   104399 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1044c5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1044c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1044cb:	29 d1                	sub    %edx,%ecx
  1044cd:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1044cf:	89 d6                	mov    %edx,%esi
  1044d1:	c1 e6 16             	shl    $0x16,%esi
  1044d4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1044d7:	89 d3                	mov    %edx,%ebx
  1044d9:	c1 e3 16             	shl    $0x16,%ebx
  1044dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1044df:	89 d1                	mov    %edx,%ecx
  1044e1:	c1 e1 16             	shl    $0x16,%ecx
  1044e4:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1044e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1044ea:	29 d7                	sub    %edx,%edi
  1044ec:	89 fa                	mov    %edi,%edx
  1044ee:	89 44 24 14          	mov    %eax,0x14(%esp)
  1044f2:	89 74 24 10          	mov    %esi,0x10(%esp)
  1044f6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1044fa:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1044fe:	89 54 24 04          	mov    %edx,0x4(%esp)
  104502:	c7 04 24 51 ae 10 00 	movl   $0x10ae51,(%esp)
  104509:	e8 bc bd ff ff       	call   1002ca <cprintf>
        size_t l, r = left * NPTEENTRY;
  10450e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104511:	c1 e0 0a             	shl    $0xa,%eax
  104514:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104517:	eb 54                	jmp    10456d <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10451c:	89 04 24             	mov    %eax,(%esp)
  10451f:	e8 75 fe ff ff       	call   104399 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104524:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104527:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10452a:	29 d1                	sub    %edx,%ecx
  10452c:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10452e:	89 d6                	mov    %edx,%esi
  104530:	c1 e6 0c             	shl    $0xc,%esi
  104533:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104536:	89 d3                	mov    %edx,%ebx
  104538:	c1 e3 0c             	shl    $0xc,%ebx
  10453b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10453e:	89 d1                	mov    %edx,%ecx
  104540:	c1 e1 0c             	shl    $0xc,%ecx
  104543:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  104546:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104549:	29 d7                	sub    %edx,%edi
  10454b:	89 fa                	mov    %edi,%edx
  10454d:	89 44 24 14          	mov    %eax,0x14(%esp)
  104551:	89 74 24 10          	mov    %esi,0x10(%esp)
  104555:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104559:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10455d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104561:	c7 04 24 70 ae 10 00 	movl   $0x10ae70,(%esp)
  104568:	e8 5d bd ff ff       	call   1002ca <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10456d:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  104572:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104575:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104578:	89 d3                	mov    %edx,%ebx
  10457a:	c1 e3 0a             	shl    $0xa,%ebx
  10457d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104580:	89 d1                	mov    %edx,%ecx
  104582:	c1 e1 0a             	shl    $0xa,%ecx
  104585:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  104588:	89 54 24 14          	mov    %edx,0x14(%esp)
  10458c:	8d 55 d8             	lea    -0x28(%ebp),%edx
  10458f:	89 54 24 10          	mov    %edx,0x10(%esp)
  104593:	89 74 24 0c          	mov    %esi,0xc(%esp)
  104597:	89 44 24 08          	mov    %eax,0x8(%esp)
  10459b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10459f:	89 0c 24             	mov    %ecx,(%esp)
  1045a2:	e8 38 fe ff ff       	call   1043df <get_pgtable_items>
  1045a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1045aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1045ae:	0f 85 65 ff ff ff    	jne    104519 <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1045b4:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  1045b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1045bc:	8d 55 dc             	lea    -0x24(%ebp),%edx
  1045bf:	89 54 24 14          	mov    %edx,0x14(%esp)
  1045c3:	8d 55 e0             	lea    -0x20(%ebp),%edx
  1045c6:	89 54 24 10          	mov    %edx,0x10(%esp)
  1045ca:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1045ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  1045d2:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1045d9:	00 
  1045da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1045e1:	e8 f9 fd ff ff       	call   1043df <get_pgtable_items>
  1045e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1045e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1045ed:	0f 85 c7 fe ff ff    	jne    1044ba <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1045f3:	c7 04 24 94 ae 10 00 	movl   $0x10ae94,(%esp)
  1045fa:	e8 cb bc ff ff       	call   1002ca <cprintf>
}
  1045ff:	90                   	nop
  104600:	83 c4 4c             	add    $0x4c,%esp
  104603:	5b                   	pop    %ebx
  104604:	5e                   	pop    %esi
  104605:	5f                   	pop    %edi
  104606:	5d                   	pop    %ebp
  104607:	c3                   	ret    

00104608 <page2ppn>:
page2ppn(struct Page *page) {
  104608:	55                   	push   %ebp
  104609:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10460b:	a1 34 3f 12 00       	mov    0x123f34,%eax
  104610:	8b 55 08             	mov    0x8(%ebp),%edx
  104613:	29 c2                	sub    %eax,%edx
  104615:	89 d0                	mov    %edx,%eax
  104617:	c1 f8 02             	sar    $0x2,%eax
  10461a:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  104620:	5d                   	pop    %ebp
  104621:	c3                   	ret    

00104622 <page2pa>:
page2pa(struct Page *page) {
  104622:	55                   	push   %ebp
  104623:	89 e5                	mov    %esp,%ebp
  104625:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  104628:	8b 45 08             	mov    0x8(%ebp),%eax
  10462b:	89 04 24             	mov    %eax,(%esp)
  10462e:	e8 d5 ff ff ff       	call   104608 <page2ppn>
  104633:	c1 e0 0c             	shl    $0xc,%eax
}
  104636:	c9                   	leave  
  104637:	c3                   	ret    

00104638 <page_ref>:
page_ref(struct Page *page) {
  104638:	55                   	push   %ebp
  104639:	89 e5                	mov    %esp,%ebp
    return page->ref;
  10463b:	8b 45 08             	mov    0x8(%ebp),%eax
  10463e:	8b 00                	mov    (%eax),%eax
}
  104640:	5d                   	pop    %ebp
  104641:	c3                   	ret    

00104642 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  104642:	55                   	push   %ebp
  104643:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104645:	8b 45 08             	mov    0x8(%ebp),%eax
  104648:	8b 55 0c             	mov    0xc(%ebp),%edx
  10464b:	89 10                	mov    %edx,(%eax)
}
  10464d:	90                   	nop
  10464e:	5d                   	pop    %ebp
  10464f:	c3                   	ret    

00104650 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  104650:	f3 0f 1e fb          	endbr32 
  104654:	55                   	push   %ebp
  104655:	89 e5                	mov    %esp,%ebp
  104657:	83 ec 10             	sub    $0x10,%esp
  10465a:	c7 45 fc 38 3f 12 00 	movl   $0x123f38,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104661:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104664:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104667:	89 50 04             	mov    %edx,0x4(%eax)
  10466a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10466d:	8b 50 04             	mov    0x4(%eax),%edx
  104670:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104673:	89 10                	mov    %edx,(%eax)
}
  104675:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  104676:	c7 05 40 3f 12 00 00 	movl   $0x0,0x123f40
  10467d:	00 00 00 
}
  104680:	90                   	nop
  104681:	c9                   	leave  
  104682:	c3                   	ret    

00104683 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  104683:	f3 0f 1e fb          	endbr32 
  104687:	55                   	push   %ebp
  104688:	89 e5                	mov    %esp,%ebp
  10468a:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  10468d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104691:	75 24                	jne    1046b7 <default_init_memmap+0x34>
  104693:	c7 44 24 0c c8 ae 10 	movl   $0x10aec8,0xc(%esp)
  10469a:	00 
  10469b:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  1046a2:	00 
  1046a3:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  1046aa:	00 
  1046ab:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  1046b2:	e8 7f bd ff ff       	call   100436 <__panic>
    struct Page *p = base;
  1046b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1046ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1046bd:	eb 7d                	jmp    10473c <default_init_memmap+0xb9>
        assert(PageReserved(p));
  1046bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046c2:	83 c0 04             	add    $0x4,%eax
  1046c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1046cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1046cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1046d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1046d5:	0f a3 10             	bt     %edx,(%eax)
  1046d8:	19 c0                	sbb    %eax,%eax
  1046da:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1046dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1046e1:	0f 95 c0             	setne  %al
  1046e4:	0f b6 c0             	movzbl %al,%eax
  1046e7:	85 c0                	test   %eax,%eax
  1046e9:	75 24                	jne    10470f <default_init_memmap+0x8c>
  1046eb:	c7 44 24 0c f9 ae 10 	movl   $0x10aef9,0xc(%esp)
  1046f2:	00 
  1046f3:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  1046fa:	00 
  1046fb:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  104702:	00 
  104703:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  10470a:	e8 27 bd ff ff       	call   100436 <__panic>
        p->flags = p->property = 0;
  10470f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104712:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  104719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10471c:	8b 50 08             	mov    0x8(%eax),%edx
  10471f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104722:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  104725:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10472c:	00 
  10472d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104730:	89 04 24             	mov    %eax,(%esp)
  104733:	e8 0a ff ff ff       	call   104642 <set_page_ref>
    for (; p != base + n; p ++) {
  104738:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10473c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10473f:	89 d0                	mov    %edx,%eax
  104741:	c1 e0 02             	shl    $0x2,%eax
  104744:	01 d0                	add    %edx,%eax
  104746:	c1 e0 02             	shl    $0x2,%eax
  104749:	89 c2                	mov    %eax,%edx
  10474b:	8b 45 08             	mov    0x8(%ebp),%eax
  10474e:	01 d0                	add    %edx,%eax
  104750:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104753:	0f 85 66 ff ff ff    	jne    1046bf <default_init_memmap+0x3c>
    }
    base->property = n;
  104759:	8b 45 08             	mov    0x8(%ebp),%eax
  10475c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10475f:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104762:	8b 45 08             	mov    0x8(%ebp),%eax
  104765:	83 c0 04             	add    $0x4,%eax
  104768:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10476f:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104772:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104775:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104778:	0f ab 10             	bts    %edx,(%eax)
}
  10477b:	90                   	nop
    nr_free += n;
  10477c:	8b 15 40 3f 12 00    	mov    0x123f40,%edx
  104782:	8b 45 0c             	mov    0xc(%ebp),%eax
  104785:	01 d0                	add    %edx,%eax
  104787:	a3 40 3f 12 00       	mov    %eax,0x123f40
    // list_add(&free_list, &(base->page_link));
    list_add_before(&free_list, &(base->page_link)); // 需要保证空闲页块起始地址有序
  10478c:	8b 45 08             	mov    0x8(%ebp),%eax
  10478f:	83 c0 0c             	add    $0xc,%eax
  104792:	c7 45 e4 38 3f 12 00 	movl   $0x123f38,-0x1c(%ebp)
  104799:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  10479c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10479f:	8b 00                	mov    (%eax),%eax
  1047a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1047a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1047a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1047aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1047ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1047b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1047b3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1047b6:	89 10                	mov    %edx,(%eax)
  1047b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1047bb:	8b 10                	mov    (%eax),%edx
  1047bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1047c0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1047c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1047c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1047c9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1047cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1047cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1047d2:	89 10                	mov    %edx,(%eax)
}
  1047d4:	90                   	nop
}
  1047d5:	90                   	nop
}
  1047d6:	90                   	nop
  1047d7:	c9                   	leave  
  1047d8:	c3                   	ret    

001047d9 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  1047d9:	f3 0f 1e fb          	endbr32 
  1047dd:	55                   	push   %ebp
  1047de:	89 e5                	mov    %esp,%ebp
  1047e0:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  1047e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1047e7:	75 24                	jne    10480d <default_alloc_pages+0x34>
  1047e9:	c7 44 24 0c c8 ae 10 	movl   $0x10aec8,0xc(%esp)
  1047f0:	00 
  1047f1:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  1047f8:	00 
  1047f9:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  104800:	00 
  104801:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104808:	e8 29 bc ff ff       	call   100436 <__panic>
    if (n > nr_free) {
  10480d:	a1 40 3f 12 00       	mov    0x123f40,%eax
  104812:	39 45 08             	cmp    %eax,0x8(%ebp)
  104815:	76 0a                	jbe    104821 <default_alloc_pages+0x48>
        return NULL;
  104817:	b8 00 00 00 00       	mov    $0x0,%eax
  10481c:	e9 43 01 00 00       	jmp    104964 <default_alloc_pages+0x18b>
    }
    struct Page *page = NULL;
  104821:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  104828:	c7 45 f0 38 3f 12 00 	movl   $0x123f38,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10482f:	eb 1c                	jmp    10484d <default_alloc_pages+0x74>
        struct Page *p = le2page(le, page_link);
  104831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104834:	83 e8 0c             	sub    $0xc,%eax
  104837:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  10483a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10483d:	8b 40 08             	mov    0x8(%eax),%eax
  104840:	39 45 08             	cmp    %eax,0x8(%ebp)
  104843:	77 08                	ja     10484d <default_alloc_pages+0x74>
            page = p;
  104845:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104848:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  10484b:	eb 18                	jmp    104865 <default_alloc_pages+0x8c>
  10484d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104850:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  104853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104856:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104859:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10485c:	81 7d f0 38 3f 12 00 	cmpl   $0x123f38,-0x10(%ebp)
  104863:	75 cc                	jne    104831 <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {
  104865:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104869:	0f 84 f2 00 00 00    	je     104961 <default_alloc_pages+0x188>
        // list_del(&(page->page_link));
        // 页块分裂
        if (page->property > n) {   
  10486f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104872:	8b 40 08             	mov    0x8(%eax),%eax
  104875:	39 45 08             	cmp    %eax,0x8(%ebp)
  104878:	0f 83 8f 00 00 00    	jae    10490d <default_alloc_pages+0x134>
            struct Page *p = page + n;
  10487e:	8b 55 08             	mov    0x8(%ebp),%edx
  104881:	89 d0                	mov    %edx,%eax
  104883:	c1 e0 02             	shl    $0x2,%eax
  104886:	01 d0                	add    %edx,%eax
  104888:	c1 e0 02             	shl    $0x2,%eax
  10488b:	89 c2                	mov    %eax,%edx
  10488d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104890:	01 d0                	add    %edx,%eax
  104892:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  104895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104898:	8b 40 08             	mov    0x8(%eax),%eax
  10489b:	2b 45 08             	sub    0x8(%ebp),%eax
  10489e:	89 c2                	mov    %eax,%edx
  1048a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1048a3:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p); // 这时p指向的页是一个空闲页块的起始页
  1048a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1048a9:	83 c0 04             	add    $0x4,%eax
  1048ac:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  1048b3:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1048b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1048b9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1048bc:	0f ab 10             	bts    %edx,(%eax)
}
  1048bf:	90                   	nop
            // list_add(&free_list, &(p->page_link));
            list_add_after(&(page->page_link), &(p->page_link));  // p代替page在空闲链表中的位置，保证空闲页块起始地址有序
  1048c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1048c3:	83 c0 0c             	add    $0xc,%eax
  1048c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1048c9:	83 c2 0c             	add    $0xc,%edx
  1048cc:	89 55 e0             	mov    %edx,-0x20(%ebp)
  1048cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
  1048d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1048d5:	8b 40 04             	mov    0x4(%eax),%eax
  1048d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1048db:	89 55 d8             	mov    %edx,-0x28(%ebp)
  1048de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1048e1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1048e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
  1048e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1048ea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1048ed:	89 10                	mov    %edx,(%eax)
  1048ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1048f2:	8b 10                	mov    (%eax),%edx
  1048f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1048f7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1048fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1048fd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104900:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104903:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104906:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104909:	89 10                	mov    %edx,(%eax)
}
  10490b:	90                   	nop
}
  10490c:	90                   	nop
        }
        list_del(&(page->page_link));
  10490d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104910:	83 c0 0c             	add    $0xc,%eax
  104913:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  104916:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104919:	8b 40 04             	mov    0x4(%eax),%eax
  10491c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10491f:	8b 12                	mov    (%edx),%edx
  104921:	89 55 b8             	mov    %edx,-0x48(%ebp)
  104924:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104927:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10492a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10492d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104930:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104933:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104936:	89 10                	mov    %edx,(%eax)
}
  104938:	90                   	nop
}
  104939:	90                   	nop
        nr_free -= n;
  10493a:	a1 40 3f 12 00       	mov    0x123f40,%eax
  10493f:	2b 45 08             	sub    0x8(%ebp),%eax
  104942:	a3 40 3f 12 00       	mov    %eax,0x123f40
        ClearPageProperty(page);
  104947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10494a:	83 c0 04             	add    $0x4,%eax
  10494d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  104954:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104957:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10495a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10495d:	0f b3 10             	btr    %edx,(%eax)
}
  104960:	90                   	nop
    }
    return page;
  104961:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104964:	c9                   	leave  
  104965:	c3                   	ret    

00104966 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  104966:	f3 0f 1e fb          	endbr32 
  10496a:	55                   	push   %ebp
  10496b:	89 e5                	mov    %esp,%ebp
  10496d:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
  104973:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104977:	75 24                	jne    10499d <default_free_pages+0x37>
  104979:	c7 44 24 0c c8 ae 10 	movl   $0x10aec8,0xc(%esp)
  104980:	00 
  104981:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  104988:	00 
  104989:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
  104990:	00 
  104991:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104998:	e8 99 ba ff ff       	call   100436 <__panic>
    struct Page *p = base;
  10499d:	8b 45 08             	mov    0x8(%ebp),%eax
  1049a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1049a3:	e9 9d 00 00 00       	jmp    104a45 <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));
  1049a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049ab:	83 c0 04             	add    $0x4,%eax
  1049ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1049b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1049b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1049bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1049be:	0f a3 10             	bt     %edx,(%eax)
  1049c1:	19 c0                	sbb    %eax,%eax
  1049c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  1049c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1049ca:	0f 95 c0             	setne  %al
  1049cd:	0f b6 c0             	movzbl %al,%eax
  1049d0:	85 c0                	test   %eax,%eax
  1049d2:	75 2c                	jne    104a00 <default_free_pages+0x9a>
  1049d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049d7:	83 c0 04             	add    $0x4,%eax
  1049da:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  1049e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1049e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1049e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1049ea:	0f a3 10             	bt     %edx,(%eax)
  1049ed:	19 c0                	sbb    %eax,%eax
  1049ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  1049f2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1049f6:	0f 95 c0             	setne  %al
  1049f9:	0f b6 c0             	movzbl %al,%eax
  1049fc:	85 c0                	test   %eax,%eax
  1049fe:	74 24                	je     104a24 <default_free_pages+0xbe>
  104a00:	c7 44 24 0c 0c af 10 	movl   $0x10af0c,0xc(%esp)
  104a07:	00 
  104a08:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  104a0f:	00 
  104a10:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
  104a17:	00 
  104a18:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104a1f:	e8 12 ba ff ff       	call   100436 <__panic>
        p->flags = 0;
  104a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  104a2e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104a35:	00 
  104a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a39:	89 04 24             	mov    %eax,(%esp)
  104a3c:	e8 01 fc ff ff       	call   104642 <set_page_ref>
    for (; p != base + n; p ++) {
  104a41:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  104a48:	89 d0                	mov    %edx,%eax
  104a4a:	c1 e0 02             	shl    $0x2,%eax
  104a4d:	01 d0                	add    %edx,%eax
  104a4f:	c1 e0 02             	shl    $0x2,%eax
  104a52:	89 c2                	mov    %eax,%edx
  104a54:	8b 45 08             	mov    0x8(%ebp),%eax
  104a57:	01 d0                	add    %edx,%eax
  104a59:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104a5c:	0f 85 46 ff ff ff    	jne    1049a8 <default_free_pages+0x42>
    }
    base->property = n;
  104a62:	8b 45 08             	mov    0x8(%ebp),%eax
  104a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  104a68:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  104a6e:	83 c0 04             	add    $0x4,%eax
  104a71:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104a78:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104a7b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104a7e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104a81:	0f ab 10             	bts    %edx,(%eax)
}
  104a84:	90                   	nop
  104a85:	c7 45 d4 38 3f 12 00 	movl   $0x123f38,-0x2c(%ebp)
    return listelm->next;
  104a8c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104a8f:	8b 40 04             	mov    0x4(%eax),%eax
    // 页块合并
    list_entry_t *le = list_next(&free_list);
  104a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104a95:	e9 79 01 00 00       	jmp    104c13 <default_free_pages+0x2ad>
        p = le2page(le, page_link);
  104a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a9d:	83 e8 0c             	sub    $0xc,%eax
  104aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        assert(!(base < p && p < base + base->property));   // 要释放的页块不能与空闲页块有交叉
  104aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  104aa6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104aa9:	73 40                	jae    104aeb <default_free_pages+0x185>
  104aab:	8b 45 08             	mov    0x8(%ebp),%eax
  104aae:	8b 50 08             	mov    0x8(%eax),%edx
  104ab1:	89 d0                	mov    %edx,%eax
  104ab3:	c1 e0 02             	shl    $0x2,%eax
  104ab6:	01 d0                	add    %edx,%eax
  104ab8:	c1 e0 02             	shl    $0x2,%eax
  104abb:	89 c2                	mov    %eax,%edx
  104abd:	8b 45 08             	mov    0x8(%ebp),%eax
  104ac0:	01 d0                	add    %edx,%eax
  104ac2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104ac5:	73 24                	jae    104aeb <default_free_pages+0x185>
  104ac7:	c7 44 24 0c 34 af 10 	movl   $0x10af34,0xc(%esp)
  104ace:	00 
  104acf:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  104ad6:	00 
  104ad7:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
  104ade:	00 
  104adf:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104ae6:	e8 4b b9 ff ff       	call   100436 <__panic>
        if (base + base->property < p)  // 再往后的空闲页块与 base 页块一定不相邻
  104aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  104aee:	8b 50 08             	mov    0x8(%eax),%edx
  104af1:	89 d0                	mov    %edx,%eax
  104af3:	c1 e0 02             	shl    $0x2,%eax
  104af6:	01 d0                	add    %edx,%eax
  104af8:	c1 e0 02             	shl    $0x2,%eax
  104afb:	89 c2                	mov    %eax,%edx
  104afd:	8b 45 08             	mov    0x8(%ebp),%eax
  104b00:	01 d0                	add    %edx,%eax
  104b02:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104b05:	0f 87 17 01 00 00    	ja     104c22 <default_free_pages+0x2bc>
  104b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b0e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104b11:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104b14:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        le = list_next(le); // 必须写在前面，因为后面可能会list_del(old_le)
  104b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  104b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  104b1d:	8b 50 08             	mov    0x8(%eax),%edx
  104b20:	89 d0                	mov    %edx,%eax
  104b22:	c1 e0 02             	shl    $0x2,%eax
  104b25:	01 d0                	add    %edx,%eax
  104b27:	c1 e0 02             	shl    $0x2,%eax
  104b2a:	89 c2                	mov    %eax,%edx
  104b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  104b2f:	01 d0                	add    %edx,%eax
  104b31:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104b34:	75 60                	jne    104b96 <default_free_pages+0x230>
            base->property += p->property;
  104b36:	8b 45 08             	mov    0x8(%ebp),%eax
  104b39:	8b 50 08             	mov    0x8(%eax),%edx
  104b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b3f:	8b 40 08             	mov    0x8(%eax),%eax
  104b42:	01 c2                	add    %eax,%edx
  104b44:	8b 45 08             	mov    0x8(%ebp),%eax
  104b47:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  104b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b4d:	83 c0 04             	add    $0x4,%eax
  104b50:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  104b57:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104b5a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104b5d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104b60:	0f b3 10             	btr    %edx,(%eax)
}
  104b63:	90                   	nop
            list_del(&(p->page_link));
  104b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b67:	83 c0 0c             	add    $0xc,%eax
  104b6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104b6d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104b70:	8b 40 04             	mov    0x4(%eax),%eax
  104b73:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104b76:	8b 12                	mov    (%edx),%edx
  104b78:	89 55 c0             	mov    %edx,-0x40(%ebp)
  104b7b:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  104b7e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104b81:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104b84:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104b87:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104b8a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104b8d:	89 10                	mov    %edx,(%eax)
}
  104b8f:	90                   	nop
}
  104b90:	90                   	nop
            break;  // 认为空闲链表的页块间维持不相邻的状态，所以最多向后合并一次
  104b91:	e9 8d 00 00 00       	jmp    104c23 <default_free_pages+0x2bd>
        }
        else if (p + p->property == base) {
  104b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b99:	8b 50 08             	mov    0x8(%eax),%edx
  104b9c:	89 d0                	mov    %edx,%eax
  104b9e:	c1 e0 02             	shl    $0x2,%eax
  104ba1:	01 d0                	add    %edx,%eax
  104ba3:	c1 e0 02             	shl    $0x2,%eax
  104ba6:	89 c2                	mov    %eax,%edx
  104ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bab:	01 d0                	add    %edx,%eax
  104bad:	39 45 08             	cmp    %eax,0x8(%ebp)
  104bb0:	75 61                	jne    104c13 <default_free_pages+0x2ad>
            p->property += base->property;
  104bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bb5:	8b 50 08             	mov    0x8(%eax),%edx
  104bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  104bbb:	8b 40 08             	mov    0x8(%eax),%eax
  104bbe:	01 c2                	add    %eax,%edx
  104bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bc3:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  104bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  104bc9:	83 c0 04             	add    $0x4,%eax
  104bcc:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  104bd3:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104bd6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104bd9:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104bdc:	0f b3 10             	btr    %edx,(%eax)
}
  104bdf:	90                   	nop
            base = p;
  104be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104be3:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  104be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104be9:	83 c0 0c             	add    $0xc,%eax
  104bec:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  104bef:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104bf2:	8b 40 04             	mov    0x4(%eax),%eax
  104bf5:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104bf8:	8b 12                	mov    (%edx),%edx
  104bfa:	89 55 ac             	mov    %edx,-0x54(%ebp)
  104bfd:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  104c00:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104c03:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104c06:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104c09:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104c0c:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104c0f:	89 10                	mov    %edx,(%eax)
}
  104c11:	90                   	nop
}
  104c12:	90                   	nop
    while (le != &free_list) {
  104c13:	81 7d f0 38 3f 12 00 	cmpl   $0x123f38,-0x10(%ebp)
  104c1a:	0f 85 7a fe ff ff    	jne    104a9a <default_free_pages+0x134>
  104c20:	eb 01                	jmp    104c23 <default_free_pages+0x2bd>
            break;
  104c22:	90                   	nop
        }
    }
    nr_free += n;
  104c23:	8b 15 40 3f 12 00    	mov    0x123f40,%edx
  104c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  104c2c:	01 d0                	add    %edx,%eax
  104c2e:	a3 40 3f 12 00       	mov    %eax,0x123f40
    // list_add(&free_list, &(base->page_link));
    list_add_before(le, &(base->page_link));    // 前面 break 时 le 正好对应 base 的下一个页块的起始页
  104c33:	8b 45 08             	mov    0x8(%ebp),%eax
  104c36:	8d 50 0c             	lea    0xc(%eax),%edx
  104c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c3c:	89 45 9c             	mov    %eax,-0x64(%ebp)
  104c3f:	89 55 98             	mov    %edx,-0x68(%ebp)
    __list_add(elm, listelm->prev, listelm);
  104c42:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104c45:	8b 00                	mov    (%eax),%eax
  104c47:	8b 55 98             	mov    -0x68(%ebp),%edx
  104c4a:	89 55 94             	mov    %edx,-0x6c(%ebp)
  104c4d:	89 45 90             	mov    %eax,-0x70(%ebp)
  104c50:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104c53:	89 45 8c             	mov    %eax,-0x74(%ebp)
    prev->next = next->prev = elm;
  104c56:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104c59:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104c5c:	89 10                	mov    %edx,(%eax)
  104c5e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104c61:	8b 10                	mov    (%eax),%edx
  104c63:	8b 45 90             	mov    -0x70(%ebp),%eax
  104c66:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104c69:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104c6c:	8b 55 8c             	mov    -0x74(%ebp),%edx
  104c6f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104c72:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104c75:	8b 55 90             	mov    -0x70(%ebp),%edx
  104c78:	89 10                	mov    %edx,(%eax)
}
  104c7a:	90                   	nop
}
  104c7b:	90                   	nop
}
  104c7c:	90                   	nop
  104c7d:	c9                   	leave  
  104c7e:	c3                   	ret    

00104c7f <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  104c7f:	f3 0f 1e fb          	endbr32 
  104c83:	55                   	push   %ebp
  104c84:	89 e5                	mov    %esp,%ebp
    return nr_free;
  104c86:	a1 40 3f 12 00       	mov    0x123f40,%eax
}
  104c8b:	5d                   	pop    %ebp
  104c8c:	c3                   	ret    

00104c8d <basic_check>:

static void
basic_check(void) {
  104c8d:	f3 0f 1e fb          	endbr32 
  104c91:	55                   	push   %ebp
  104c92:	89 e5                	mov    %esp,%ebp
  104c94:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104c97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ca7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104caa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104cb1:	e8 60 e2 ff ff       	call   102f16 <alloc_pages>
  104cb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104cb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104cbd:	75 24                	jne    104ce3 <basic_check+0x56>
  104cbf:	c7 44 24 0c 5d af 10 	movl   $0x10af5d,0xc(%esp)
  104cc6:	00 
  104cc7:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  104cce:	00 
  104ccf:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  104cd6:	00 
  104cd7:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104cde:	e8 53 b7 ff ff       	call   100436 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104ce3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104cea:	e8 27 e2 ff ff       	call   102f16 <alloc_pages>
  104cef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104cf2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104cf6:	75 24                	jne    104d1c <basic_check+0x8f>
  104cf8:	c7 44 24 0c 79 af 10 	movl   $0x10af79,0xc(%esp)
  104cff:	00 
  104d00:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  104d07:	00 
  104d08:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  104d0f:	00 
  104d10:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104d17:	e8 1a b7 ff ff       	call   100436 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104d1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d23:	e8 ee e1 ff ff       	call   102f16 <alloc_pages>
  104d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104d2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104d2f:	75 24                	jne    104d55 <basic_check+0xc8>
  104d31:	c7 44 24 0c 95 af 10 	movl   $0x10af95,0xc(%esp)
  104d38:	00 
  104d39:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  104d40:	00 
  104d41:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  104d48:	00 
  104d49:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104d50:	e8 e1 b6 ff ff       	call   100436 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d58:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104d5b:	74 10                	je     104d6d <basic_check+0xe0>
  104d5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d60:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104d63:	74 08                	je     104d6d <basic_check+0xe0>
  104d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d68:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104d6b:	75 24                	jne    104d91 <basic_check+0x104>
  104d6d:	c7 44 24 0c b4 af 10 	movl   $0x10afb4,0xc(%esp)
  104d74:	00 
  104d75:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  104d7c:	00 
  104d7d:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  104d84:	00 
  104d85:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104d8c:	e8 a5 b6 ff ff       	call   100436 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d94:	89 04 24             	mov    %eax,(%esp)
  104d97:	e8 9c f8 ff ff       	call   104638 <page_ref>
  104d9c:	85 c0                	test   %eax,%eax
  104d9e:	75 1e                	jne    104dbe <basic_check+0x131>
  104da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104da3:	89 04 24             	mov    %eax,(%esp)
  104da6:	e8 8d f8 ff ff       	call   104638 <page_ref>
  104dab:	85 c0                	test   %eax,%eax
  104dad:	75 0f                	jne    104dbe <basic_check+0x131>
  104daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104db2:	89 04 24             	mov    %eax,(%esp)
  104db5:	e8 7e f8 ff ff       	call   104638 <page_ref>
  104dba:	85 c0                	test   %eax,%eax
  104dbc:	74 24                	je     104de2 <basic_check+0x155>
  104dbe:	c7 44 24 0c d8 af 10 	movl   $0x10afd8,0xc(%esp)
  104dc5:	00 
  104dc6:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  104dcd:	00 
  104dce:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  104dd5:	00 
  104dd6:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104ddd:	e8 54 b6 ff ff       	call   100436 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104de2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104de5:	89 04 24             	mov    %eax,(%esp)
  104de8:	e8 35 f8 ff ff       	call   104622 <page2pa>
  104ded:	8b 15 80 3e 12 00    	mov    0x123e80,%edx
  104df3:	c1 e2 0c             	shl    $0xc,%edx
  104df6:	39 d0                	cmp    %edx,%eax
  104df8:	72 24                	jb     104e1e <basic_check+0x191>
  104dfa:	c7 44 24 0c 14 b0 10 	movl   $0x10b014,0xc(%esp)
  104e01:	00 
  104e02:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  104e09:	00 
  104e0a:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  104e11:	00 
  104e12:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104e19:	e8 18 b6 ff ff       	call   100436 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e21:	89 04 24             	mov    %eax,(%esp)
  104e24:	e8 f9 f7 ff ff       	call   104622 <page2pa>
  104e29:	8b 15 80 3e 12 00    	mov    0x123e80,%edx
  104e2f:	c1 e2 0c             	shl    $0xc,%edx
  104e32:	39 d0                	cmp    %edx,%eax
  104e34:	72 24                	jb     104e5a <basic_check+0x1cd>
  104e36:	c7 44 24 0c 31 b0 10 	movl   $0x10b031,0xc(%esp)
  104e3d:	00 
  104e3e:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  104e45:	00 
  104e46:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  104e4d:	00 
  104e4e:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104e55:	e8 dc b5 ff ff       	call   100436 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e5d:	89 04 24             	mov    %eax,(%esp)
  104e60:	e8 bd f7 ff ff       	call   104622 <page2pa>
  104e65:	8b 15 80 3e 12 00    	mov    0x123e80,%edx
  104e6b:	c1 e2 0c             	shl    $0xc,%edx
  104e6e:	39 d0                	cmp    %edx,%eax
  104e70:	72 24                	jb     104e96 <basic_check+0x209>
  104e72:	c7 44 24 0c 4e b0 10 	movl   $0x10b04e,0xc(%esp)
  104e79:	00 
  104e7a:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  104e81:	00 
  104e82:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  104e89:	00 
  104e8a:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104e91:	e8 a0 b5 ff ff       	call   100436 <__panic>

    list_entry_t free_list_store = free_list;
  104e96:	a1 38 3f 12 00       	mov    0x123f38,%eax
  104e9b:	8b 15 3c 3f 12 00    	mov    0x123f3c,%edx
  104ea1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104ea4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104ea7:	c7 45 dc 38 3f 12 00 	movl   $0x123f38,-0x24(%ebp)
    elm->prev = elm->next = elm;
  104eae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104eb1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104eb4:	89 50 04             	mov    %edx,0x4(%eax)
  104eb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104eba:	8b 50 04             	mov    0x4(%eax),%edx
  104ebd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ec0:	89 10                	mov    %edx,(%eax)
}
  104ec2:	90                   	nop
  104ec3:	c7 45 e0 38 3f 12 00 	movl   $0x123f38,-0x20(%ebp)
    return list->next == list;
  104eca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ecd:	8b 40 04             	mov    0x4(%eax),%eax
  104ed0:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104ed3:	0f 94 c0             	sete   %al
  104ed6:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104ed9:	85 c0                	test   %eax,%eax
  104edb:	75 24                	jne    104f01 <basic_check+0x274>
  104edd:	c7 44 24 0c 6b b0 10 	movl   $0x10b06b,0xc(%esp)
  104ee4:	00 
  104ee5:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  104eec:	00 
  104eed:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  104ef4:	00 
  104ef5:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104efc:	e8 35 b5 ff ff       	call   100436 <__panic>

    unsigned int nr_free_store = nr_free;
  104f01:	a1 40 3f 12 00       	mov    0x123f40,%eax
  104f06:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104f09:	c7 05 40 3f 12 00 00 	movl   $0x0,0x123f40
  104f10:	00 00 00 

    assert(alloc_page() == NULL);
  104f13:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f1a:	e8 f7 df ff ff       	call   102f16 <alloc_pages>
  104f1f:	85 c0                	test   %eax,%eax
  104f21:	74 24                	je     104f47 <basic_check+0x2ba>
  104f23:	c7 44 24 0c 82 b0 10 	movl   $0x10b082,0xc(%esp)
  104f2a:	00 
  104f2b:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  104f32:	00 
  104f33:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  104f3a:	00 
  104f3b:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104f42:	e8 ef b4 ff ff       	call   100436 <__panic>

    free_page(p0);
  104f47:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f4e:	00 
  104f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f52:	89 04 24             	mov    %eax,(%esp)
  104f55:	e8 f8 df ff ff       	call   102f52 <free_pages>
    free_page(p1);
  104f5a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f61:	00 
  104f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f65:	89 04 24             	mov    %eax,(%esp)
  104f68:	e8 e5 df ff ff       	call   102f52 <free_pages>
    free_page(p2);
  104f6d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f74:	00 
  104f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f78:	89 04 24             	mov    %eax,(%esp)
  104f7b:	e8 d2 df ff ff       	call   102f52 <free_pages>
    assert(nr_free == 3);
  104f80:	a1 40 3f 12 00       	mov    0x123f40,%eax
  104f85:	83 f8 03             	cmp    $0x3,%eax
  104f88:	74 24                	je     104fae <basic_check+0x321>
  104f8a:	c7 44 24 0c 97 b0 10 	movl   $0x10b097,0xc(%esp)
  104f91:	00 
  104f92:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  104f99:	00 
  104f9a:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  104fa1:	00 
  104fa2:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104fa9:	e8 88 b4 ff ff       	call   100436 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104fae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104fb5:	e8 5c df ff ff       	call   102f16 <alloc_pages>
  104fba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104fbd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104fc1:	75 24                	jne    104fe7 <basic_check+0x35a>
  104fc3:	c7 44 24 0c 5d af 10 	movl   $0x10af5d,0xc(%esp)
  104fca:	00 
  104fcb:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  104fd2:	00 
  104fd3:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  104fda:	00 
  104fdb:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  104fe2:	e8 4f b4 ff ff       	call   100436 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104fe7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104fee:	e8 23 df ff ff       	call   102f16 <alloc_pages>
  104ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ff6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104ffa:	75 24                	jne    105020 <basic_check+0x393>
  104ffc:	c7 44 24 0c 79 af 10 	movl   $0x10af79,0xc(%esp)
  105003:	00 
  105004:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  10500b:	00 
  10500c:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  105013:	00 
  105014:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  10501b:	e8 16 b4 ff ff       	call   100436 <__panic>
    assert((p2 = alloc_page()) != NULL);
  105020:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105027:	e8 ea de ff ff       	call   102f16 <alloc_pages>
  10502c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10502f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105033:	75 24                	jne    105059 <basic_check+0x3cc>
  105035:	c7 44 24 0c 95 af 10 	movl   $0x10af95,0xc(%esp)
  10503c:	00 
  10503d:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  105044:	00 
  105045:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  10504c:	00 
  10504d:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  105054:	e8 dd b3 ff ff       	call   100436 <__panic>

    assert(alloc_page() == NULL);
  105059:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105060:	e8 b1 de ff ff       	call   102f16 <alloc_pages>
  105065:	85 c0                	test   %eax,%eax
  105067:	74 24                	je     10508d <basic_check+0x400>
  105069:	c7 44 24 0c 82 b0 10 	movl   $0x10b082,0xc(%esp)
  105070:	00 
  105071:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  105078:	00 
  105079:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  105080:	00 
  105081:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  105088:	e8 a9 b3 ff ff       	call   100436 <__panic>

    free_page(p0);
  10508d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105094:	00 
  105095:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105098:	89 04 24             	mov    %eax,(%esp)
  10509b:	e8 b2 de ff ff       	call   102f52 <free_pages>
  1050a0:	c7 45 d8 38 3f 12 00 	movl   $0x123f38,-0x28(%ebp)
  1050a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1050aa:	8b 40 04             	mov    0x4(%eax),%eax
  1050ad:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1050b0:	0f 94 c0             	sete   %al
  1050b3:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1050b6:	85 c0                	test   %eax,%eax
  1050b8:	74 24                	je     1050de <basic_check+0x451>
  1050ba:	c7 44 24 0c a4 b0 10 	movl   $0x10b0a4,0xc(%esp)
  1050c1:	00 
  1050c2:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  1050c9:	00 
  1050ca:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  1050d1:	00 
  1050d2:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  1050d9:	e8 58 b3 ff ff       	call   100436 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1050de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1050e5:	e8 2c de ff ff       	call   102f16 <alloc_pages>
  1050ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1050ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1050f0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1050f3:	74 24                	je     105119 <basic_check+0x48c>
  1050f5:	c7 44 24 0c bc b0 10 	movl   $0x10b0bc,0xc(%esp)
  1050fc:	00 
  1050fd:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  105104:	00 
  105105:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  10510c:	00 
  10510d:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  105114:	e8 1d b3 ff ff       	call   100436 <__panic>
    assert(alloc_page() == NULL);
  105119:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105120:	e8 f1 dd ff ff       	call   102f16 <alloc_pages>
  105125:	85 c0                	test   %eax,%eax
  105127:	74 24                	je     10514d <basic_check+0x4c0>
  105129:	c7 44 24 0c 82 b0 10 	movl   $0x10b082,0xc(%esp)
  105130:	00 
  105131:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  105138:	00 
  105139:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  105140:	00 
  105141:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  105148:	e8 e9 b2 ff ff       	call   100436 <__panic>

    assert(nr_free == 0);
  10514d:	a1 40 3f 12 00       	mov    0x123f40,%eax
  105152:	85 c0                	test   %eax,%eax
  105154:	74 24                	je     10517a <basic_check+0x4ed>
  105156:	c7 44 24 0c d5 b0 10 	movl   $0x10b0d5,0xc(%esp)
  10515d:	00 
  10515e:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  105165:	00 
  105166:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  10516d:	00 
  10516e:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  105175:	e8 bc b2 ff ff       	call   100436 <__panic>
    free_list = free_list_store;
  10517a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10517d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105180:	a3 38 3f 12 00       	mov    %eax,0x123f38
  105185:	89 15 3c 3f 12 00    	mov    %edx,0x123f3c
    nr_free = nr_free_store;
  10518b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10518e:	a3 40 3f 12 00       	mov    %eax,0x123f40

    free_page(p);
  105193:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10519a:	00 
  10519b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10519e:	89 04 24             	mov    %eax,(%esp)
  1051a1:	e8 ac dd ff ff       	call   102f52 <free_pages>
    free_page(p1);
  1051a6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051ad:	00 
  1051ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051b1:	89 04 24             	mov    %eax,(%esp)
  1051b4:	e8 99 dd ff ff       	call   102f52 <free_pages>
    free_page(p2);
  1051b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051c0:	00 
  1051c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051c4:	89 04 24             	mov    %eax,(%esp)
  1051c7:	e8 86 dd ff ff       	call   102f52 <free_pages>
}
  1051cc:	90                   	nop
  1051cd:	c9                   	leave  
  1051ce:	c3                   	ret    

001051cf <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1051cf:	f3 0f 1e fb          	endbr32 
  1051d3:	55                   	push   %ebp
  1051d4:	89 e5                	mov    %esp,%ebp
  1051d6:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  1051dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1051e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1051ea:	c7 45 ec 38 3f 12 00 	movl   $0x123f38,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1051f1:	eb 6a                	jmp    10525d <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
  1051f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1051f6:	83 e8 0c             	sub    $0xc,%eax
  1051f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  1051fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1051ff:	83 c0 04             	add    $0x4,%eax
  105202:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  105209:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10520c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10520f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  105212:	0f a3 10             	bt     %edx,(%eax)
  105215:	19 c0                	sbb    %eax,%eax
  105217:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  10521a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10521e:	0f 95 c0             	setne  %al
  105221:	0f b6 c0             	movzbl %al,%eax
  105224:	85 c0                	test   %eax,%eax
  105226:	75 24                	jne    10524c <default_check+0x7d>
  105228:	c7 44 24 0c e2 b0 10 	movl   $0x10b0e2,0xc(%esp)
  10522f:	00 
  105230:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  105237:	00 
  105238:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  10523f:	00 
  105240:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  105247:	e8 ea b1 ff ff       	call   100436 <__panic>
        count ++, total += p->property;
  10524c:	ff 45 f4             	incl   -0xc(%ebp)
  10524f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105252:	8b 50 08             	mov    0x8(%eax),%edx
  105255:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105258:	01 d0                	add    %edx,%eax
  10525a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10525d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105260:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  105263:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  105266:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  105269:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10526c:	81 7d ec 38 3f 12 00 	cmpl   $0x123f38,-0x14(%ebp)
  105273:	0f 85 7a ff ff ff    	jne    1051f3 <default_check+0x24>
    }
    assert(total == nr_free_pages());
  105279:	e8 0b dd ff ff       	call   102f89 <nr_free_pages>
  10527e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105281:	39 d0                	cmp    %edx,%eax
  105283:	74 24                	je     1052a9 <default_check+0xda>
  105285:	c7 44 24 0c f2 b0 10 	movl   $0x10b0f2,0xc(%esp)
  10528c:	00 
  10528d:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  105294:	00 
  105295:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  10529c:	00 
  10529d:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  1052a4:	e8 8d b1 ff ff       	call   100436 <__panic>

    basic_check();
  1052a9:	e8 df f9 ff ff       	call   104c8d <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1052ae:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1052b5:	e8 5c dc ff ff       	call   102f16 <alloc_pages>
  1052ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  1052bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1052c1:	75 24                	jne    1052e7 <default_check+0x118>
  1052c3:	c7 44 24 0c 0b b1 10 	movl   $0x10b10b,0xc(%esp)
  1052ca:	00 
  1052cb:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  1052d2:	00 
  1052d3:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  1052da:	00 
  1052db:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  1052e2:	e8 4f b1 ff ff       	call   100436 <__panic>
    assert(!PageProperty(p0));
  1052e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052ea:	83 c0 04             	add    $0x4,%eax
  1052ed:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1052f4:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1052f7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1052fa:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1052fd:	0f a3 10             	bt     %edx,(%eax)
  105300:	19 c0                	sbb    %eax,%eax
  105302:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  105305:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  105309:	0f 95 c0             	setne  %al
  10530c:	0f b6 c0             	movzbl %al,%eax
  10530f:	85 c0                	test   %eax,%eax
  105311:	74 24                	je     105337 <default_check+0x168>
  105313:	c7 44 24 0c 16 b1 10 	movl   $0x10b116,0xc(%esp)
  10531a:	00 
  10531b:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  105322:	00 
  105323:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  10532a:	00 
  10532b:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  105332:	e8 ff b0 ff ff       	call   100436 <__panic>

    list_entry_t free_list_store = free_list;
  105337:	a1 38 3f 12 00       	mov    0x123f38,%eax
  10533c:	8b 15 3c 3f 12 00    	mov    0x123f3c,%edx
  105342:	89 45 80             	mov    %eax,-0x80(%ebp)
  105345:	89 55 84             	mov    %edx,-0x7c(%ebp)
  105348:	c7 45 b0 38 3f 12 00 	movl   $0x123f38,-0x50(%ebp)
    elm->prev = elm->next = elm;
  10534f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105352:	8b 55 b0             	mov    -0x50(%ebp),%edx
  105355:	89 50 04             	mov    %edx,0x4(%eax)
  105358:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10535b:	8b 50 04             	mov    0x4(%eax),%edx
  10535e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  105361:	89 10                	mov    %edx,(%eax)
}
  105363:	90                   	nop
  105364:	c7 45 b4 38 3f 12 00 	movl   $0x123f38,-0x4c(%ebp)
    return list->next == list;
  10536b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10536e:	8b 40 04             	mov    0x4(%eax),%eax
  105371:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  105374:	0f 94 c0             	sete   %al
  105377:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10537a:	85 c0                	test   %eax,%eax
  10537c:	75 24                	jne    1053a2 <default_check+0x1d3>
  10537e:	c7 44 24 0c 6b b0 10 	movl   $0x10b06b,0xc(%esp)
  105385:	00 
  105386:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  10538d:	00 
  10538e:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  105395:	00 
  105396:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  10539d:	e8 94 b0 ff ff       	call   100436 <__panic>
    assert(alloc_page() == NULL);
  1053a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1053a9:	e8 68 db ff ff       	call   102f16 <alloc_pages>
  1053ae:	85 c0                	test   %eax,%eax
  1053b0:	74 24                	je     1053d6 <default_check+0x207>
  1053b2:	c7 44 24 0c 82 b0 10 	movl   $0x10b082,0xc(%esp)
  1053b9:	00 
  1053ba:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  1053c1:	00 
  1053c2:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  1053c9:	00 
  1053ca:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  1053d1:	e8 60 b0 ff ff       	call   100436 <__panic>

    unsigned int nr_free_store = nr_free;
  1053d6:	a1 40 3f 12 00       	mov    0x123f40,%eax
  1053db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  1053de:	c7 05 40 3f 12 00 00 	movl   $0x0,0x123f40
  1053e5:	00 00 00 

    free_pages(p0 + 2, 3);
  1053e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053eb:	83 c0 28             	add    $0x28,%eax
  1053ee:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1053f5:	00 
  1053f6:	89 04 24             	mov    %eax,(%esp)
  1053f9:	e8 54 db ff ff       	call   102f52 <free_pages>
    assert(alloc_pages(4) == NULL);
  1053fe:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  105405:	e8 0c db ff ff       	call   102f16 <alloc_pages>
  10540a:	85 c0                	test   %eax,%eax
  10540c:	74 24                	je     105432 <default_check+0x263>
  10540e:	c7 44 24 0c 28 b1 10 	movl   $0x10b128,0xc(%esp)
  105415:	00 
  105416:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  10541d:	00 
  10541e:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  105425:	00 
  105426:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  10542d:	e8 04 b0 ff ff       	call   100436 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  105432:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105435:	83 c0 28             	add    $0x28,%eax
  105438:	83 c0 04             	add    $0x4,%eax
  10543b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  105442:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105445:	8b 45 a8             	mov    -0x58(%ebp),%eax
  105448:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10544b:	0f a3 10             	bt     %edx,(%eax)
  10544e:	19 c0                	sbb    %eax,%eax
  105450:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  105453:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  105457:	0f 95 c0             	setne  %al
  10545a:	0f b6 c0             	movzbl %al,%eax
  10545d:	85 c0                	test   %eax,%eax
  10545f:	74 0e                	je     10546f <default_check+0x2a0>
  105461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105464:	83 c0 28             	add    $0x28,%eax
  105467:	8b 40 08             	mov    0x8(%eax),%eax
  10546a:	83 f8 03             	cmp    $0x3,%eax
  10546d:	74 24                	je     105493 <default_check+0x2c4>
  10546f:	c7 44 24 0c 40 b1 10 	movl   $0x10b140,0xc(%esp)
  105476:	00 
  105477:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  10547e:	00 
  10547f:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  105486:	00 
  105487:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  10548e:	e8 a3 af ff ff       	call   100436 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  105493:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10549a:	e8 77 da ff ff       	call   102f16 <alloc_pages>
  10549f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1054a6:	75 24                	jne    1054cc <default_check+0x2fd>
  1054a8:	c7 44 24 0c 6c b1 10 	movl   $0x10b16c,0xc(%esp)
  1054af:	00 
  1054b0:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  1054b7:	00 
  1054b8:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1054bf:	00 
  1054c0:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  1054c7:	e8 6a af ff ff       	call   100436 <__panic>
    assert(alloc_page() == NULL);
  1054cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1054d3:	e8 3e da ff ff       	call   102f16 <alloc_pages>
  1054d8:	85 c0                	test   %eax,%eax
  1054da:	74 24                	je     105500 <default_check+0x331>
  1054dc:	c7 44 24 0c 82 b0 10 	movl   $0x10b082,0xc(%esp)
  1054e3:	00 
  1054e4:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  1054eb:	00 
  1054ec:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  1054f3:	00 
  1054f4:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  1054fb:	e8 36 af ff ff       	call   100436 <__panic>
    assert(p0 + 2 == p1);
  105500:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105503:	83 c0 28             	add    $0x28,%eax
  105506:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105509:	74 24                	je     10552f <default_check+0x360>
  10550b:	c7 44 24 0c 8a b1 10 	movl   $0x10b18a,0xc(%esp)
  105512:	00 
  105513:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  10551a:	00 
  10551b:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  105522:	00 
  105523:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  10552a:	e8 07 af ff ff       	call   100436 <__panic>

    p2 = p0 + 1;
  10552f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105532:	83 c0 14             	add    $0x14,%eax
  105535:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  105538:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10553f:	00 
  105540:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105543:	89 04 24             	mov    %eax,(%esp)
  105546:	e8 07 da ff ff       	call   102f52 <free_pages>
    free_pages(p1, 3);
  10554b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105552:	00 
  105553:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105556:	89 04 24             	mov    %eax,(%esp)
  105559:	e8 f4 d9 ff ff       	call   102f52 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10555e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105561:	83 c0 04             	add    $0x4,%eax
  105564:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10556b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10556e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  105571:	8b 55 a0             	mov    -0x60(%ebp),%edx
  105574:	0f a3 10             	bt     %edx,(%eax)
  105577:	19 c0                	sbb    %eax,%eax
  105579:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10557c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  105580:	0f 95 c0             	setne  %al
  105583:	0f b6 c0             	movzbl %al,%eax
  105586:	85 c0                	test   %eax,%eax
  105588:	74 0b                	je     105595 <default_check+0x3c6>
  10558a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10558d:	8b 40 08             	mov    0x8(%eax),%eax
  105590:	83 f8 01             	cmp    $0x1,%eax
  105593:	74 24                	je     1055b9 <default_check+0x3ea>
  105595:	c7 44 24 0c 98 b1 10 	movl   $0x10b198,0xc(%esp)
  10559c:	00 
  10559d:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  1055a4:	00 
  1055a5:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  1055ac:	00 
  1055ad:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  1055b4:	e8 7d ae ff ff       	call   100436 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1055b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1055bc:	83 c0 04             	add    $0x4,%eax
  1055bf:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1055c6:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1055c9:	8b 45 90             	mov    -0x70(%ebp),%eax
  1055cc:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1055cf:	0f a3 10             	bt     %edx,(%eax)
  1055d2:	19 c0                	sbb    %eax,%eax
  1055d4:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1055d7:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1055db:	0f 95 c0             	setne  %al
  1055de:	0f b6 c0             	movzbl %al,%eax
  1055e1:	85 c0                	test   %eax,%eax
  1055e3:	74 0b                	je     1055f0 <default_check+0x421>
  1055e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1055e8:	8b 40 08             	mov    0x8(%eax),%eax
  1055eb:	83 f8 03             	cmp    $0x3,%eax
  1055ee:	74 24                	je     105614 <default_check+0x445>
  1055f0:	c7 44 24 0c c0 b1 10 	movl   $0x10b1c0,0xc(%esp)
  1055f7:	00 
  1055f8:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  1055ff:	00 
  105600:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  105607:	00 
  105608:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  10560f:	e8 22 ae ff ff       	call   100436 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  105614:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10561b:	e8 f6 d8 ff ff       	call   102f16 <alloc_pages>
  105620:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105623:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105626:	83 e8 14             	sub    $0x14,%eax
  105629:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10562c:	74 24                	je     105652 <default_check+0x483>
  10562e:	c7 44 24 0c e6 b1 10 	movl   $0x10b1e6,0xc(%esp)
  105635:	00 
  105636:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  10563d:	00 
  10563e:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  105645:	00 
  105646:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  10564d:	e8 e4 ad ff ff       	call   100436 <__panic>
    free_page(p0);
  105652:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105659:	00 
  10565a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10565d:	89 04 24             	mov    %eax,(%esp)
  105660:	e8 ed d8 ff ff       	call   102f52 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  105665:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10566c:	e8 a5 d8 ff ff       	call   102f16 <alloc_pages>
  105671:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105674:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105677:	83 c0 14             	add    $0x14,%eax
  10567a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10567d:	74 24                	je     1056a3 <default_check+0x4d4>
  10567f:	c7 44 24 0c 04 b2 10 	movl   $0x10b204,0xc(%esp)
  105686:	00 
  105687:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  10568e:	00 
  10568f:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
  105696:	00 
  105697:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  10569e:	e8 93 ad ff ff       	call   100436 <__panic>

    free_pages(p0, 2);
  1056a3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1056aa:	00 
  1056ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1056ae:	89 04 24             	mov    %eax,(%esp)
  1056b1:	e8 9c d8 ff ff       	call   102f52 <free_pages>
    free_page(p2);
  1056b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1056bd:	00 
  1056be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1056c1:	89 04 24             	mov    %eax,(%esp)
  1056c4:	e8 89 d8 ff ff       	call   102f52 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1056c9:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1056d0:	e8 41 d8 ff ff       	call   102f16 <alloc_pages>
  1056d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1056d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056dc:	75 24                	jne    105702 <default_check+0x533>
  1056de:	c7 44 24 0c 24 b2 10 	movl   $0x10b224,0xc(%esp)
  1056e5:	00 
  1056e6:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  1056ed:	00 
  1056ee:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  1056f5:	00 
  1056f6:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  1056fd:	e8 34 ad ff ff       	call   100436 <__panic>
    assert(alloc_page() == NULL);
  105702:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105709:	e8 08 d8 ff ff       	call   102f16 <alloc_pages>
  10570e:	85 c0                	test   %eax,%eax
  105710:	74 24                	je     105736 <default_check+0x567>
  105712:	c7 44 24 0c 82 b0 10 	movl   $0x10b082,0xc(%esp)
  105719:	00 
  10571a:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  105721:	00 
  105722:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  105729:	00 
  10572a:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  105731:	e8 00 ad ff ff       	call   100436 <__panic>

    assert(nr_free == 0);
  105736:	a1 40 3f 12 00       	mov    0x123f40,%eax
  10573b:	85 c0                	test   %eax,%eax
  10573d:	74 24                	je     105763 <default_check+0x594>
  10573f:	c7 44 24 0c d5 b0 10 	movl   $0x10b0d5,0xc(%esp)
  105746:	00 
  105747:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  10574e:	00 
  10574f:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  105756:	00 
  105757:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  10575e:	e8 d3 ac ff ff       	call   100436 <__panic>
    nr_free = nr_free_store;
  105763:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105766:	a3 40 3f 12 00       	mov    %eax,0x123f40

    free_list = free_list_store;
  10576b:	8b 45 80             	mov    -0x80(%ebp),%eax
  10576e:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105771:	a3 38 3f 12 00       	mov    %eax,0x123f38
  105776:	89 15 3c 3f 12 00    	mov    %edx,0x123f3c
    free_pages(p0, 5);
  10577c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  105783:	00 
  105784:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105787:	89 04 24             	mov    %eax,(%esp)
  10578a:	e8 c3 d7 ff ff       	call   102f52 <free_pages>

    le = &free_list;
  10578f:	c7 45 ec 38 3f 12 00 	movl   $0x123f38,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105796:	eb 5a                	jmp    1057f2 <default_check+0x623>
        assert(le->next->prev == le && le->prev->next == le);
  105798:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10579b:	8b 40 04             	mov    0x4(%eax),%eax
  10579e:	8b 00                	mov    (%eax),%eax
  1057a0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1057a3:	75 0d                	jne    1057b2 <default_check+0x5e3>
  1057a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057a8:	8b 00                	mov    (%eax),%eax
  1057aa:	8b 40 04             	mov    0x4(%eax),%eax
  1057ad:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1057b0:	74 24                	je     1057d6 <default_check+0x607>
  1057b2:	c7 44 24 0c 44 b2 10 	movl   $0x10b244,0xc(%esp)
  1057b9:	00 
  1057ba:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  1057c1:	00 
  1057c2:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  1057c9:	00 
  1057ca:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  1057d1:	e8 60 ac ff ff       	call   100436 <__panic>
        struct Page *p = le2page(le, page_link);
  1057d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057d9:	83 e8 0c             	sub    $0xc,%eax
  1057dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  1057df:	ff 4d f4             	decl   -0xc(%ebp)
  1057e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1057e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1057e8:	8b 40 08             	mov    0x8(%eax),%eax
  1057eb:	29 c2                	sub    %eax,%edx
  1057ed:	89 d0                	mov    %edx,%eax
  1057ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057f5:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  1057f8:	8b 45 88             	mov    -0x78(%ebp),%eax
  1057fb:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1057fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105801:	81 7d ec 38 3f 12 00 	cmpl   $0x123f38,-0x14(%ebp)
  105808:	75 8e                	jne    105798 <default_check+0x5c9>
    }
    assert(count == 0);
  10580a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10580e:	74 24                	je     105834 <default_check+0x665>
  105810:	c7 44 24 0c 71 b2 10 	movl   $0x10b271,0xc(%esp)
  105817:	00 
  105818:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  10581f:	00 
  105820:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  105827:	00 
  105828:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  10582f:	e8 02 ac ff ff       	call   100436 <__panic>
    assert(total == 0);
  105834:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105838:	74 24                	je     10585e <default_check+0x68f>
  10583a:	c7 44 24 0c 7c b2 10 	movl   $0x10b27c,0xc(%esp)
  105841:	00 
  105842:	c7 44 24 08 ce ae 10 	movl   $0x10aece,0x8(%esp)
  105849:	00 
  10584a:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
  105851:	00 
  105852:	c7 04 24 e3 ae 10 00 	movl   $0x10aee3,(%esp)
  105859:	e8 d8 ab ff ff       	call   100436 <__panic>
}
  10585e:	90                   	nop
  10585f:	c9                   	leave  
  105860:	c3                   	ret    

00105861 <page2ppn>:
page2ppn(struct Page *page) {
  105861:	55                   	push   %ebp
  105862:	89 e5                	mov    %esp,%ebp
    return page - pages;
  105864:	a1 34 3f 12 00       	mov    0x123f34,%eax
  105869:	8b 55 08             	mov    0x8(%ebp),%edx
  10586c:	29 c2                	sub    %eax,%edx
  10586e:	89 d0                	mov    %edx,%eax
  105870:	c1 f8 02             	sar    $0x2,%eax
  105873:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  105879:	5d                   	pop    %ebp
  10587a:	c3                   	ret    

0010587b <page2pa>:
page2pa(struct Page *page) {
  10587b:	55                   	push   %ebp
  10587c:	89 e5                	mov    %esp,%ebp
  10587e:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  105881:	8b 45 08             	mov    0x8(%ebp),%eax
  105884:	89 04 24             	mov    %eax,(%esp)
  105887:	e8 d5 ff ff ff       	call   105861 <page2ppn>
  10588c:	c1 e0 0c             	shl    $0xc,%eax
}
  10588f:	c9                   	leave  
  105890:	c3                   	ret    

00105891 <page_ref>:
page_ref(struct Page *page) {
  105891:	55                   	push   %ebp
  105892:	89 e5                	mov    %esp,%ebp
    return page->ref;
  105894:	8b 45 08             	mov    0x8(%ebp),%eax
  105897:	8b 00                	mov    (%eax),%eax
}
  105899:	5d                   	pop    %ebp
  10589a:	c3                   	ret    

0010589b <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  10589b:	55                   	push   %ebp
  10589c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10589e:	8b 45 08             	mov    0x8(%ebp),%eax
  1058a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1058a4:	89 10                	mov    %edx,(%eax)
}
  1058a6:	90                   	nop
  1058a7:	5d                   	pop    %ebp
  1058a8:	c3                   	ret    

001058a9 <buddy_init_size>:
#define UINT32_REMAINDER(a)     ((a)&(UINT32_MASK(a)>>1))
#define UINT32_ROUND_UP(a)      (UINT32_REMAINDER(a)?(((a)-UINT32_REMAINDER(a))<<1):(a))
#define UINT32_ROUND_DOWN(a)    (UINT32_REMAINDER(a)?((a)-UINT32_REMAINDER(a)):(a))

static void
buddy_init_size(size_t n) {
  1058a9:	f3 0f 1e fb          	endbr32 
  1058ad:	55                   	push   %ebp
  1058ae:	89 e5                	mov    %esp,%ebp
  1058b0:	57                   	push   %edi
  1058b1:	56                   	push   %esi
  1058b2:	53                   	push   %ebx
  1058b3:	83 ec 2c             	sub    $0x2c,%esp
    assert(n > 1);
  1058b6:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  1058ba:	77 24                	ja     1058e0 <buddy_init_size+0x37>
  1058bc:	c7 44 24 0c b8 b2 10 	movl   $0x10b2b8,0xc(%esp)
  1058c3:	00 
  1058c4:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  1058cb:	00 
  1058cc:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  1058d3:	00 
  1058d4:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  1058db:	e8 56 ab ff ff       	call   100436 <__panic>
    buddy_physical_size = n;
  1058e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e3:	a3 0c 3f 12 00       	mov    %eax,0x123f0c
    if (n < 512) {
  1058e8:	81 7d 08 ff 01 00 00 	cmpl   $0x1ff,0x8(%ebp)
  1058ef:	0f 87 98 02 00 00    	ja     105b8d <buddy_init_size+0x2e4>
        buddy_virtual_size = UINT32_ROUND_UP(n-1);
  1058f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1058f8:	8d 78 ff             	lea    -0x1(%eax),%edi
  1058fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1058fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  105901:	8b 45 08             	mov    0x8(%ebp),%eax
  105904:	48                   	dec    %eax
  105905:	d1 e8                	shr    %eax
  105907:	09 c2                	or     %eax,%edx
  105909:	8b 45 08             	mov    0x8(%ebp),%eax
  10590c:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10590f:	8b 45 08             	mov    0x8(%ebp),%eax
  105912:	48                   	dec    %eax
  105913:	d1 e8                	shr    %eax
  105915:	09 c8                	or     %ecx,%eax
  105917:	c1 e8 02             	shr    $0x2,%eax
  10591a:	09 c2                	or     %eax,%edx
  10591c:	8b 45 08             	mov    0x8(%ebp),%eax
  10591f:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105922:	8b 45 08             	mov    0x8(%ebp),%eax
  105925:	48                   	dec    %eax
  105926:	d1 e8                	shr    %eax
  105928:	09 c1                	or     %eax,%ecx
  10592a:	8b 45 08             	mov    0x8(%ebp),%eax
  10592d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  105930:	8b 45 08             	mov    0x8(%ebp),%eax
  105933:	48                   	dec    %eax
  105934:	d1 e8                	shr    %eax
  105936:	09 d8                	or     %ebx,%eax
  105938:	c1 e8 02             	shr    $0x2,%eax
  10593b:	09 c8                	or     %ecx,%eax
  10593d:	c1 e8 04             	shr    $0x4,%eax
  105940:	09 c2                	or     %eax,%edx
  105942:	8b 45 08             	mov    0x8(%ebp),%eax
  105945:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105948:	8b 45 08             	mov    0x8(%ebp),%eax
  10594b:	48                   	dec    %eax
  10594c:	d1 e8                	shr    %eax
  10594e:	09 c1                	or     %eax,%ecx
  105950:	8b 45 08             	mov    0x8(%ebp),%eax
  105953:	8d 58 ff             	lea    -0x1(%eax),%ebx
  105956:	8b 45 08             	mov    0x8(%ebp),%eax
  105959:	48                   	dec    %eax
  10595a:	d1 e8                	shr    %eax
  10595c:	09 d8                	or     %ebx,%eax
  10595e:	c1 e8 02             	shr    $0x2,%eax
  105961:	09 c1                	or     %eax,%ecx
  105963:	8b 45 08             	mov    0x8(%ebp),%eax
  105966:	8d 58 ff             	lea    -0x1(%eax),%ebx
  105969:	8b 45 08             	mov    0x8(%ebp),%eax
  10596c:	48                   	dec    %eax
  10596d:	d1 e8                	shr    %eax
  10596f:	09 c3                	or     %eax,%ebx
  105971:	8b 45 08             	mov    0x8(%ebp),%eax
  105974:	8d 70 ff             	lea    -0x1(%eax),%esi
  105977:	8b 45 08             	mov    0x8(%ebp),%eax
  10597a:	48                   	dec    %eax
  10597b:	d1 e8                	shr    %eax
  10597d:	09 f0                	or     %esi,%eax
  10597f:	c1 e8 02             	shr    $0x2,%eax
  105982:	09 d8                	or     %ebx,%eax
  105984:	c1 e8 04             	shr    $0x4,%eax
  105987:	09 c8                	or     %ecx,%eax
  105989:	c1 e8 08             	shr    $0x8,%eax
  10598c:	89 d6                	mov    %edx,%esi
  10598e:	09 c6                	or     %eax,%esi
  105990:	8b 45 08             	mov    0x8(%ebp),%eax
  105993:	8d 50 ff             	lea    -0x1(%eax),%edx
  105996:	8b 45 08             	mov    0x8(%ebp),%eax
  105999:	48                   	dec    %eax
  10599a:	d1 e8                	shr    %eax
  10599c:	09 c2                	or     %eax,%edx
  10599e:	8b 45 08             	mov    0x8(%ebp),%eax
  1059a1:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1059a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1059a7:	48                   	dec    %eax
  1059a8:	d1 e8                	shr    %eax
  1059aa:	09 c8                	or     %ecx,%eax
  1059ac:	c1 e8 02             	shr    $0x2,%eax
  1059af:	09 c2                	or     %eax,%edx
  1059b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b4:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1059b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ba:	48                   	dec    %eax
  1059bb:	d1 e8                	shr    %eax
  1059bd:	09 c1                	or     %eax,%ecx
  1059bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1059c2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  1059c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1059c8:	48                   	dec    %eax
  1059c9:	d1 e8                	shr    %eax
  1059cb:	09 d8                	or     %ebx,%eax
  1059cd:	c1 e8 02             	shr    $0x2,%eax
  1059d0:	09 c8                	or     %ecx,%eax
  1059d2:	c1 e8 04             	shr    $0x4,%eax
  1059d5:	89 d3                	mov    %edx,%ebx
  1059d7:	09 c3                	or     %eax,%ebx
  1059d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1059dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  1059df:	8b 45 08             	mov    0x8(%ebp),%eax
  1059e2:	48                   	dec    %eax
  1059e3:	d1 e8                	shr    %eax
  1059e5:	09 c2                	or     %eax,%edx
  1059e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ea:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1059ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1059f0:	48                   	dec    %eax
  1059f1:	d1 e8                	shr    %eax
  1059f3:	09 c8                	or     %ecx,%eax
  1059f5:	c1 e8 02             	shr    $0x2,%eax
  1059f8:	89 d1                	mov    %edx,%ecx
  1059fa:	09 c1                	or     %eax,%ecx
  1059fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ff:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a02:	8b 45 08             	mov    0x8(%ebp),%eax
  105a05:	48                   	dec    %eax
  105a06:	d1 e8                	shr    %eax
  105a08:	09 c2                	or     %eax,%edx
  105a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a0d:	48                   	dec    %eax
  105a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105a11:	8b 45 08             	mov    0x8(%ebp),%eax
  105a14:	48                   	dec    %eax
  105a15:	d1 e8                	shr    %eax
  105a17:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105a1a:	c1 e8 02             	shr    $0x2,%eax
  105a1d:	09 d0                	or     %edx,%eax
  105a1f:	c1 e8 04             	shr    $0x4,%eax
  105a22:	09 c8                	or     %ecx,%eax
  105a24:	c1 e8 08             	shr    $0x8,%eax
  105a27:	09 d8                	or     %ebx,%eax
  105a29:	c1 e8 10             	shr    $0x10,%eax
  105a2c:	09 f0                	or     %esi,%eax
  105a2e:	d1 e8                	shr    %eax
  105a30:	21 f8                	and    %edi,%eax
  105a32:	85 c0                	test   %eax,%eax
  105a34:	0f 84 3b 01 00 00    	je     105b75 <buddy_init_size+0x2cc>
  105a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a40:	8b 45 08             	mov    0x8(%ebp),%eax
  105a43:	48                   	dec    %eax
  105a44:	d1 e8                	shr    %eax
  105a46:	09 c2                	or     %eax,%edx
  105a48:	8b 45 08             	mov    0x8(%ebp),%eax
  105a4b:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  105a51:	48                   	dec    %eax
  105a52:	d1 e8                	shr    %eax
  105a54:	09 c8                	or     %ecx,%eax
  105a56:	c1 e8 02             	shr    $0x2,%eax
  105a59:	09 c2                	or     %eax,%edx
  105a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  105a5e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105a61:	8b 45 08             	mov    0x8(%ebp),%eax
  105a64:	48                   	dec    %eax
  105a65:	d1 e8                	shr    %eax
  105a67:	09 c1                	or     %eax,%ecx
  105a69:	8b 45 08             	mov    0x8(%ebp),%eax
  105a6c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  105a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a72:	48                   	dec    %eax
  105a73:	d1 e8                	shr    %eax
  105a75:	09 d8                	or     %ebx,%eax
  105a77:	c1 e8 02             	shr    $0x2,%eax
  105a7a:	09 c8                	or     %ecx,%eax
  105a7c:	c1 e8 04             	shr    $0x4,%eax
  105a7f:	09 c2                	or     %eax,%edx
  105a81:	8b 45 08             	mov    0x8(%ebp),%eax
  105a84:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105a87:	8b 45 08             	mov    0x8(%ebp),%eax
  105a8a:	48                   	dec    %eax
  105a8b:	d1 e8                	shr    %eax
  105a8d:	09 c1                	or     %eax,%ecx
  105a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a92:	8d 58 ff             	lea    -0x1(%eax),%ebx
  105a95:	8b 45 08             	mov    0x8(%ebp),%eax
  105a98:	48                   	dec    %eax
  105a99:	d1 e8                	shr    %eax
  105a9b:	09 d8                	or     %ebx,%eax
  105a9d:	c1 e8 02             	shr    $0x2,%eax
  105aa0:	09 c1                	or     %eax,%ecx
  105aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  105aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  105aab:	48                   	dec    %eax
  105aac:	d1 e8                	shr    %eax
  105aae:	09 c3                	or     %eax,%ebx
  105ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ab3:	8d 70 ff             	lea    -0x1(%eax),%esi
  105ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ab9:	48                   	dec    %eax
  105aba:	d1 e8                	shr    %eax
  105abc:	09 f0                	or     %esi,%eax
  105abe:	c1 e8 02             	shr    $0x2,%eax
  105ac1:	09 d8                	or     %ebx,%eax
  105ac3:	c1 e8 04             	shr    $0x4,%eax
  105ac6:	09 c8                	or     %ecx,%eax
  105ac8:	c1 e8 08             	shr    $0x8,%eax
  105acb:	09 c2                	or     %eax,%edx
  105acd:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad0:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad6:	48                   	dec    %eax
  105ad7:	d1 e8                	shr    %eax
  105ad9:	09 c1                	or     %eax,%ecx
  105adb:	8b 45 08             	mov    0x8(%ebp),%eax
  105ade:	8d 58 ff             	lea    -0x1(%eax),%ebx
  105ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae4:	48                   	dec    %eax
  105ae5:	d1 e8                	shr    %eax
  105ae7:	09 d8                	or     %ebx,%eax
  105ae9:	c1 e8 02             	shr    $0x2,%eax
  105aec:	09 c1                	or     %eax,%ecx
  105aee:	8b 45 08             	mov    0x8(%ebp),%eax
  105af1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  105af4:	8b 45 08             	mov    0x8(%ebp),%eax
  105af7:	48                   	dec    %eax
  105af8:	d1 e8                	shr    %eax
  105afa:	09 c3                	or     %eax,%ebx
  105afc:	8b 45 08             	mov    0x8(%ebp),%eax
  105aff:	8d 70 ff             	lea    -0x1(%eax),%esi
  105b02:	8b 45 08             	mov    0x8(%ebp),%eax
  105b05:	48                   	dec    %eax
  105b06:	d1 e8                	shr    %eax
  105b08:	09 f0                	or     %esi,%eax
  105b0a:	c1 e8 02             	shr    $0x2,%eax
  105b0d:	09 d8                	or     %ebx,%eax
  105b0f:	c1 e8 04             	shr    $0x4,%eax
  105b12:	09 c1                	or     %eax,%ecx
  105b14:	8b 45 08             	mov    0x8(%ebp),%eax
  105b17:	8d 58 ff             	lea    -0x1(%eax),%ebx
  105b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  105b1d:	48                   	dec    %eax
  105b1e:	d1 e8                	shr    %eax
  105b20:	09 c3                	or     %eax,%ebx
  105b22:	8b 45 08             	mov    0x8(%ebp),%eax
  105b25:	8d 70 ff             	lea    -0x1(%eax),%esi
  105b28:	8b 45 08             	mov    0x8(%ebp),%eax
  105b2b:	48                   	dec    %eax
  105b2c:	d1 e8                	shr    %eax
  105b2e:	09 f0                	or     %esi,%eax
  105b30:	c1 e8 02             	shr    $0x2,%eax
  105b33:	09 c3                	or     %eax,%ebx
  105b35:	8b 45 08             	mov    0x8(%ebp),%eax
  105b38:	8d 70 ff             	lea    -0x1(%eax),%esi
  105b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b3e:	48                   	dec    %eax
  105b3f:	d1 e8                	shr    %eax
  105b41:	09 c6                	or     %eax,%esi
  105b43:	8b 45 08             	mov    0x8(%ebp),%eax
  105b46:	8d 78 ff             	lea    -0x1(%eax),%edi
  105b49:	8b 45 08             	mov    0x8(%ebp),%eax
  105b4c:	48                   	dec    %eax
  105b4d:	d1 e8                	shr    %eax
  105b4f:	09 f8                	or     %edi,%eax
  105b51:	c1 e8 02             	shr    $0x2,%eax
  105b54:	09 f0                	or     %esi,%eax
  105b56:	c1 e8 04             	shr    $0x4,%eax
  105b59:	09 d8                	or     %ebx,%eax
  105b5b:	c1 e8 08             	shr    $0x8,%eax
  105b5e:	09 c8                	or     %ecx,%eax
  105b60:	c1 e8 10             	shr    $0x10,%eax
  105b63:	09 d0                	or     %edx,%eax
  105b65:	d1 e8                	shr    %eax
  105b67:	f7 d0                	not    %eax
  105b69:	89 c2                	mov    %eax,%edx
  105b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b6e:	48                   	dec    %eax
  105b6f:	21 d0                	and    %edx,%eax
  105b71:	01 c0                	add    %eax,%eax
  105b73:	eb 04                	jmp    105b79 <buddy_init_size+0x2d0>
  105b75:	8b 45 08             	mov    0x8(%ebp),%eax
  105b78:	48                   	dec    %eax
  105b79:	a3 10 3f 12 00       	mov    %eax,0x123f10
        buddy_segment_size = 1;
  105b7e:	c7 05 14 3f 12 00 01 	movl   $0x1,0x123f14
  105b85:	00 00 00 
  105b88:	e9 00 02 00 00       	jmp    105d8d <buddy_init_size+0x4e4>
    } else {
        buddy_virtual_size = UINT32_ROUND_DOWN(n);
  105b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  105b90:	d1 e8                	shr    %eax
  105b92:	0b 45 08             	or     0x8(%ebp),%eax
  105b95:	8b 55 08             	mov    0x8(%ebp),%edx
  105b98:	d1 ea                	shr    %edx
  105b9a:	0b 55 08             	or     0x8(%ebp),%edx
  105b9d:	c1 ea 02             	shr    $0x2,%edx
  105ba0:	09 d0                	or     %edx,%eax
  105ba2:	89 c1                	mov    %eax,%ecx
  105ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba7:	d1 e8                	shr    %eax
  105ba9:	0b 45 08             	or     0x8(%ebp),%eax
  105bac:	8b 55 08             	mov    0x8(%ebp),%edx
  105baf:	d1 ea                	shr    %edx
  105bb1:	0b 55 08             	or     0x8(%ebp),%edx
  105bb4:	c1 ea 02             	shr    $0x2,%edx
  105bb7:	09 d0                	or     %edx,%eax
  105bb9:	c1 e8 04             	shr    $0x4,%eax
  105bbc:	09 c1                	or     %eax,%ecx
  105bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  105bc1:	d1 e8                	shr    %eax
  105bc3:	0b 45 08             	or     0x8(%ebp),%eax
  105bc6:	8b 55 08             	mov    0x8(%ebp),%edx
  105bc9:	d1 ea                	shr    %edx
  105bcb:	0b 55 08             	or     0x8(%ebp),%edx
  105bce:	c1 ea 02             	shr    $0x2,%edx
  105bd1:	09 d0                	or     %edx,%eax
  105bd3:	89 c3                	mov    %eax,%ebx
  105bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd8:	d1 e8                	shr    %eax
  105bda:	0b 45 08             	or     0x8(%ebp),%eax
  105bdd:	8b 55 08             	mov    0x8(%ebp),%edx
  105be0:	d1 ea                	shr    %edx
  105be2:	0b 55 08             	or     0x8(%ebp),%edx
  105be5:	c1 ea 02             	shr    $0x2,%edx
  105be8:	09 d0                	or     %edx,%eax
  105bea:	c1 e8 04             	shr    $0x4,%eax
  105bed:	09 d8                	or     %ebx,%eax
  105bef:	c1 e8 08             	shr    $0x8,%eax
  105bf2:	09 c1                	or     %eax,%ecx
  105bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf7:	d1 e8                	shr    %eax
  105bf9:	0b 45 08             	or     0x8(%ebp),%eax
  105bfc:	8b 55 08             	mov    0x8(%ebp),%edx
  105bff:	d1 ea                	shr    %edx
  105c01:	0b 55 08             	or     0x8(%ebp),%edx
  105c04:	c1 ea 02             	shr    $0x2,%edx
  105c07:	09 d0                	or     %edx,%eax
  105c09:	89 c3                	mov    %eax,%ebx
  105c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  105c0e:	d1 e8                	shr    %eax
  105c10:	0b 45 08             	or     0x8(%ebp),%eax
  105c13:	8b 55 08             	mov    0x8(%ebp),%edx
  105c16:	d1 ea                	shr    %edx
  105c18:	0b 55 08             	or     0x8(%ebp),%edx
  105c1b:	c1 ea 02             	shr    $0x2,%edx
  105c1e:	09 d0                	or     %edx,%eax
  105c20:	c1 e8 04             	shr    $0x4,%eax
  105c23:	09 c3                	or     %eax,%ebx
  105c25:	8b 45 08             	mov    0x8(%ebp),%eax
  105c28:	d1 e8                	shr    %eax
  105c2a:	0b 45 08             	or     0x8(%ebp),%eax
  105c2d:	8b 55 08             	mov    0x8(%ebp),%edx
  105c30:	d1 ea                	shr    %edx
  105c32:	0b 55 08             	or     0x8(%ebp),%edx
  105c35:	c1 ea 02             	shr    $0x2,%edx
  105c38:	09 d0                	or     %edx,%eax
  105c3a:	89 c6                	mov    %eax,%esi
  105c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c3f:	d1 e8                	shr    %eax
  105c41:	0b 45 08             	or     0x8(%ebp),%eax
  105c44:	8b 55 08             	mov    0x8(%ebp),%edx
  105c47:	d1 ea                	shr    %edx
  105c49:	0b 55 08             	or     0x8(%ebp),%edx
  105c4c:	c1 ea 02             	shr    $0x2,%edx
  105c4f:	09 d0                	or     %edx,%eax
  105c51:	c1 e8 04             	shr    $0x4,%eax
  105c54:	09 f0                	or     %esi,%eax
  105c56:	c1 e8 08             	shr    $0x8,%eax
  105c59:	09 d8                	or     %ebx,%eax
  105c5b:	c1 e8 10             	shr    $0x10,%eax
  105c5e:	09 c8                	or     %ecx,%eax
  105c60:	d1 e8                	shr    %eax
  105c62:	23 45 08             	and    0x8(%ebp),%eax
  105c65:	85 c0                	test   %eax,%eax
  105c67:	0f 84 dc 00 00 00    	je     105d49 <buddy_init_size+0x4a0>
  105c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  105c70:	d1 e8                	shr    %eax
  105c72:	0b 45 08             	or     0x8(%ebp),%eax
  105c75:	8b 55 08             	mov    0x8(%ebp),%edx
  105c78:	d1 ea                	shr    %edx
  105c7a:	0b 55 08             	or     0x8(%ebp),%edx
  105c7d:	c1 ea 02             	shr    $0x2,%edx
  105c80:	09 d0                	or     %edx,%eax
  105c82:	89 c1                	mov    %eax,%ecx
  105c84:	8b 45 08             	mov    0x8(%ebp),%eax
  105c87:	d1 e8                	shr    %eax
  105c89:	0b 45 08             	or     0x8(%ebp),%eax
  105c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  105c8f:	d1 ea                	shr    %edx
  105c91:	0b 55 08             	or     0x8(%ebp),%edx
  105c94:	c1 ea 02             	shr    $0x2,%edx
  105c97:	09 d0                	or     %edx,%eax
  105c99:	c1 e8 04             	shr    $0x4,%eax
  105c9c:	09 c1                	or     %eax,%ecx
  105c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca1:	d1 e8                	shr    %eax
  105ca3:	0b 45 08             	or     0x8(%ebp),%eax
  105ca6:	8b 55 08             	mov    0x8(%ebp),%edx
  105ca9:	d1 ea                	shr    %edx
  105cab:	0b 55 08             	or     0x8(%ebp),%edx
  105cae:	c1 ea 02             	shr    $0x2,%edx
  105cb1:	09 d0                	or     %edx,%eax
  105cb3:	89 c3                	mov    %eax,%ebx
  105cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  105cb8:	d1 e8                	shr    %eax
  105cba:	0b 45 08             	or     0x8(%ebp),%eax
  105cbd:	8b 55 08             	mov    0x8(%ebp),%edx
  105cc0:	d1 ea                	shr    %edx
  105cc2:	0b 55 08             	or     0x8(%ebp),%edx
  105cc5:	c1 ea 02             	shr    $0x2,%edx
  105cc8:	09 d0                	or     %edx,%eax
  105cca:	c1 e8 04             	shr    $0x4,%eax
  105ccd:	09 d8                	or     %ebx,%eax
  105ccf:	c1 e8 08             	shr    $0x8,%eax
  105cd2:	09 c1                	or     %eax,%ecx
  105cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd7:	d1 e8                	shr    %eax
  105cd9:	0b 45 08             	or     0x8(%ebp),%eax
  105cdc:	8b 55 08             	mov    0x8(%ebp),%edx
  105cdf:	d1 ea                	shr    %edx
  105ce1:	0b 55 08             	or     0x8(%ebp),%edx
  105ce4:	c1 ea 02             	shr    $0x2,%edx
  105ce7:	09 d0                	or     %edx,%eax
  105ce9:	89 c3                	mov    %eax,%ebx
  105ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  105cee:	d1 e8                	shr    %eax
  105cf0:	0b 45 08             	or     0x8(%ebp),%eax
  105cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  105cf6:	d1 ea                	shr    %edx
  105cf8:	0b 55 08             	or     0x8(%ebp),%edx
  105cfb:	c1 ea 02             	shr    $0x2,%edx
  105cfe:	09 d0                	or     %edx,%eax
  105d00:	c1 e8 04             	shr    $0x4,%eax
  105d03:	09 c3                	or     %eax,%ebx
  105d05:	8b 45 08             	mov    0x8(%ebp),%eax
  105d08:	d1 e8                	shr    %eax
  105d0a:	0b 45 08             	or     0x8(%ebp),%eax
  105d0d:	8b 55 08             	mov    0x8(%ebp),%edx
  105d10:	d1 ea                	shr    %edx
  105d12:	0b 55 08             	or     0x8(%ebp),%edx
  105d15:	c1 ea 02             	shr    $0x2,%edx
  105d18:	09 d0                	or     %edx,%eax
  105d1a:	89 c6                	mov    %eax,%esi
  105d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d1f:	d1 e8                	shr    %eax
  105d21:	0b 45 08             	or     0x8(%ebp),%eax
  105d24:	8b 55 08             	mov    0x8(%ebp),%edx
  105d27:	d1 ea                	shr    %edx
  105d29:	0b 55 08             	or     0x8(%ebp),%edx
  105d2c:	c1 ea 02             	shr    $0x2,%edx
  105d2f:	09 d0                	or     %edx,%eax
  105d31:	c1 e8 04             	shr    $0x4,%eax
  105d34:	09 f0                	or     %esi,%eax
  105d36:	c1 e8 08             	shr    $0x8,%eax
  105d39:	09 d8                	or     %ebx,%eax
  105d3b:	c1 e8 10             	shr    $0x10,%eax
  105d3e:	09 c8                	or     %ecx,%eax
  105d40:	d1 e8                	shr    %eax
  105d42:	f7 d0                	not    %eax
  105d44:	23 45 08             	and    0x8(%ebp),%eax
  105d47:	eb 03                	jmp    105d4c <buddy_init_size+0x4a3>
  105d49:	8b 45 08             	mov    0x8(%ebp),%eax
  105d4c:	a3 10 3f 12 00       	mov    %eax,0x123f10
        buddy_segment_size = buddy_virtual_size*sizeof(size_t)*2/PGSIZE;
  105d51:	a1 10 3f 12 00       	mov    0x123f10,%eax
  105d56:	c1 e0 03             	shl    $0x3,%eax
  105d59:	c1 e8 0c             	shr    $0xc,%eax
  105d5c:	a3 14 3f 12 00       	mov    %eax,0x123f14
        if (n > buddy_virtual_size + (buddy_segment_size<<1)) {
  105d61:	a1 14 3f 12 00       	mov    0x123f14,%eax
  105d66:	8d 14 00             	lea    (%eax,%eax,1),%edx
  105d69:	a1 10 3f 12 00       	mov    0x123f10,%eax
  105d6e:	01 d0                	add    %edx,%eax
  105d70:	39 45 08             	cmp    %eax,0x8(%ebp)
  105d73:	76 18                	jbe    105d8d <buddy_init_size+0x4e4>
            buddy_virtual_size <<= 1;
  105d75:	a1 10 3f 12 00       	mov    0x123f10,%eax
  105d7a:	01 c0                	add    %eax,%eax
  105d7c:	a3 10 3f 12 00       	mov    %eax,0x123f10
            buddy_segment_size <<= 1;
  105d81:	a1 14 3f 12 00       	mov    0x123f14,%eax
  105d86:	01 c0                	add    %eax,%eax
  105d88:	a3 14 3f 12 00       	mov    %eax,0x123f14
        }
    }
    buddy_alloc_size = MIN(buddy_virtual_size, buddy_physical_size-buddy_segment_size);
  105d8d:	8b 15 0c 3f 12 00    	mov    0x123f0c,%edx
  105d93:	a1 14 3f 12 00       	mov    0x123f14,%eax
  105d98:	29 c2                	sub    %eax,%edx
  105d9a:	a1 10 3f 12 00       	mov    0x123f10,%eax
  105d9f:	39 c2                	cmp    %eax,%edx
  105da1:	0f 46 c2             	cmovbe %edx,%eax
  105da4:	a3 18 3f 12 00       	mov    %eax,0x123f18
}
  105da9:	90                   	nop
  105daa:	83 c4 2c             	add    $0x2c,%esp
  105dad:	5b                   	pop    %ebx
  105dae:	5e                   	pop    %esi
  105daf:	5f                   	pop    %edi
  105db0:	5d                   	pop    %ebp
  105db1:	c3                   	ret    

00105db2 <buddy_init_segment>:

static void
buddy_init_segment(struct Page *base) {
  105db2:	f3 0f 1e fb          	endbr32 
  105db6:	55                   	push   %ebp
  105db7:	89 e5                	mov    %esp,%ebp
  105db9:	57                   	push   %edi
  105dba:	56                   	push   %esi
  105dbb:	53                   	push   %ebx
  105dbc:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
    // Init address
    buddy_physical = base;
  105dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc5:	a3 20 3f 12 00       	mov    %eax,0x123f20
    buddy_segment = KADDR(page2pa(base));
  105dca:	8b 45 08             	mov    0x8(%ebp),%eax
  105dcd:	89 04 24             	mov    %eax,(%esp)
  105dd0:	e8 a6 fa ff ff       	call   10587b <page2pa>
  105dd5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  105dd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105ddb:	c1 e8 0c             	shr    $0xc,%eax
  105dde:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  105de1:	a1 80 3e 12 00       	mov    0x123e80,%eax
  105de6:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  105de9:	72 23                	jb     105e0e <buddy_init_segment+0x5c>
  105deb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105dee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105df2:	c7 44 24 08 e8 b2 10 	movl   $0x10b2e8,0x8(%esp)
  105df9:	00 
  105dfa:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  105e01:	00 
  105e02:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  105e09:	e8 28 a6 ff ff       	call   100436 <__panic>
  105e0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105e11:	2d 00 00 00 40       	sub    $0x40000000,%eax
  105e16:	a3 1c 3f 12 00       	mov    %eax,0x123f1c
    buddy_alloc = base + buddy_segment_size;
  105e1b:	8b 15 14 3f 12 00    	mov    0x123f14,%edx
  105e21:	89 d0                	mov    %edx,%eax
  105e23:	c1 e0 02             	shl    $0x2,%eax
  105e26:	01 d0                	add    %edx,%eax
  105e28:	c1 e0 02             	shl    $0x2,%eax
  105e2b:	89 c2                	mov    %eax,%edx
  105e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  105e30:	01 d0                	add    %edx,%eax
  105e32:	a3 24 3f 12 00       	mov    %eax,0x123f24
    memset(buddy_segment, 0, buddy_segment_size*PGSIZE);
  105e37:	a1 14 3f 12 00       	mov    0x123f14,%eax
  105e3c:	c1 e0 0c             	shl    $0xc,%eax
  105e3f:	89 c2                	mov    %eax,%edx
  105e41:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  105e46:	89 54 24 08          	mov    %edx,0x8(%esp)
  105e4a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  105e51:	00 
  105e52:	89 04 24             	mov    %eax,(%esp)
  105e55:	e8 1c 3a 00 00       	call   109876 <memset>
    // Init segment
    nr_free += buddy_alloc_size;
  105e5a:	8b 15 40 3f 12 00    	mov    0x123f40,%edx
  105e60:	a1 18 3f 12 00       	mov    0x123f18,%eax
  105e65:	01 d0                	add    %edx,%eax
  105e67:	a3 40 3f 12 00       	mov    %eax,0x123f40
    size_t block = BUDDY_ROOT;
  105e6c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    size_t alloc_size = buddy_alloc_size;
  105e73:	a1 18 3f 12 00       	mov    0x123f18,%eax
  105e78:	89 45 e0             	mov    %eax,-0x20(%ebp)
    size_t virtual_size = buddy_virtual_size;
  105e7b:	a1 10 3f 12 00       	mov    0x123f10,%eax
  105e80:	89 45 dc             	mov    %eax,-0x24(%ebp)
    buddy_segment[block] = alloc_size;
  105e83:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  105e88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105e8b:	c1 e2 02             	shl    $0x2,%edx
  105e8e:	01 c2                	add    %eax,%edx
  105e90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e93:	89 02                	mov    %eax,(%edx)
    while (alloc_size > 0 && alloc_size < virtual_size) {
  105e95:	e9 b4 03 00 00       	jmp    10624e <buddy_init_segment+0x49c>
        virtual_size >>= 1;
  105e9a:	d1 6d dc             	shrl   -0x24(%ebp)
        if (alloc_size > virtual_size) {
  105e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ea0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  105ea3:	0f 86 7a 03 00 00    	jbe    106223 <buddy_init_segment+0x471>
            // Add left to free list
            struct Page *page = &buddy_alloc[BUDDY_BEGIN(block)];
  105ea9:	a1 24 3f 12 00       	mov    0x123f24,%eax
  105eae:	89 45 84             	mov    %eax,-0x7c(%ebp)
  105eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105eb4:	d1 e8                	shr    %eax
  105eb6:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105eb9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ebc:	d1 ea                	shr    %edx
  105ebe:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105ec1:	c1 ea 02             	shr    $0x2,%edx
  105ec4:	09 d0                	or     %edx,%eax
  105ec6:	89 c1                	mov    %eax,%ecx
  105ec8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ecb:	d1 e8                	shr    %eax
  105ecd:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105ed0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ed3:	d1 ea                	shr    %edx
  105ed5:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105ed8:	c1 ea 02             	shr    $0x2,%edx
  105edb:	09 d0                	or     %edx,%eax
  105edd:	c1 e8 04             	shr    $0x4,%eax
  105ee0:	09 c1                	or     %eax,%ecx
  105ee2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ee5:	d1 e8                	shr    %eax
  105ee7:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105eea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105eed:	d1 ea                	shr    %edx
  105eef:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105ef2:	c1 ea 02             	shr    $0x2,%edx
  105ef5:	09 d0                	or     %edx,%eax
  105ef7:	89 c3                	mov    %eax,%ebx
  105ef9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105efc:	d1 e8                	shr    %eax
  105efe:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105f01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f04:	d1 ea                	shr    %edx
  105f06:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105f09:	c1 ea 02             	shr    $0x2,%edx
  105f0c:	09 d0                	or     %edx,%eax
  105f0e:	c1 e8 04             	shr    $0x4,%eax
  105f11:	09 d8                	or     %ebx,%eax
  105f13:	c1 e8 08             	shr    $0x8,%eax
  105f16:	09 c1                	or     %eax,%ecx
  105f18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105f1b:	d1 e8                	shr    %eax
  105f1d:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105f20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f23:	d1 ea                	shr    %edx
  105f25:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105f28:	c1 ea 02             	shr    $0x2,%edx
  105f2b:	09 d0                	or     %edx,%eax
  105f2d:	89 c3                	mov    %eax,%ebx
  105f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105f32:	d1 e8                	shr    %eax
  105f34:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105f37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f3a:	d1 ea                	shr    %edx
  105f3c:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105f3f:	c1 ea 02             	shr    $0x2,%edx
  105f42:	09 d0                	or     %edx,%eax
  105f44:	c1 e8 04             	shr    $0x4,%eax
  105f47:	09 c3                	or     %eax,%ebx
  105f49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105f4c:	d1 e8                	shr    %eax
  105f4e:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105f51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f54:	d1 ea                	shr    %edx
  105f56:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105f59:	c1 ea 02             	shr    $0x2,%edx
  105f5c:	09 d0                	or     %edx,%eax
  105f5e:	89 c6                	mov    %eax,%esi
  105f60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105f63:	d1 e8                	shr    %eax
  105f65:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105f68:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f6b:	d1 ea                	shr    %edx
  105f6d:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105f70:	c1 ea 02             	shr    $0x2,%edx
  105f73:	09 d0                	or     %edx,%eax
  105f75:	c1 e8 04             	shr    $0x4,%eax
  105f78:	09 f0                	or     %esi,%eax
  105f7a:	c1 e8 08             	shr    $0x8,%eax
  105f7d:	09 d8                	or     %ebx,%eax
  105f7f:	c1 e8 10             	shr    $0x10,%eax
  105f82:	09 c8                	or     %ecx,%eax
  105f84:	d1 e8                	shr    %eax
  105f86:	23 45 e4             	and    -0x1c(%ebp),%eax
  105f89:	89 45 80             	mov    %eax,-0x80(%ebp)
  105f8c:	8b 3d 10 3f 12 00    	mov    0x123f10,%edi
  105f92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105f95:	d1 e8                	shr    %eax
  105f97:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105f9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105f9d:	d1 ea                	shr    %edx
  105f9f:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105fa2:	c1 ea 02             	shr    $0x2,%edx
  105fa5:	09 d0                	or     %edx,%eax
  105fa7:	89 c1                	mov    %eax,%ecx
  105fa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105fac:	d1 e8                	shr    %eax
  105fae:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105fb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105fb4:	d1 ea                	shr    %edx
  105fb6:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105fb9:	c1 ea 02             	shr    $0x2,%edx
  105fbc:	09 d0                	or     %edx,%eax
  105fbe:	c1 e8 04             	shr    $0x4,%eax
  105fc1:	09 c1                	or     %eax,%ecx
  105fc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105fc6:	d1 e8                	shr    %eax
  105fc8:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105fcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105fce:	d1 ea                	shr    %edx
  105fd0:	0b 55 e4             	or     -0x1c(%ebp),%edx
  105fd3:	c1 ea 02             	shr    $0x2,%edx
  105fd6:	09 d0                	or     %edx,%eax
  105fd8:	89 c3                	mov    %eax,%ebx
  105fda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105fdd:	d1 e8                	shr    %eax
  105fdf:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105fe2:	89 c2                	mov    %eax,%edx
  105fe4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105fe7:	d1 e8                	shr    %eax
  105fe9:	0b 45 e4             	or     -0x1c(%ebp),%eax
  105fec:	c1 e8 02             	shr    $0x2,%eax
  105fef:	09 d0                	or     %edx,%eax
  105ff1:	c1 e8 04             	shr    $0x4,%eax
  105ff4:	09 d8                	or     %ebx,%eax
  105ff6:	c1 e8 08             	shr    $0x8,%eax
  105ff9:	89 ce                	mov    %ecx,%esi
  105ffb:	09 c6                	or     %eax,%esi
  105ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106000:	d1 e8                	shr    %eax
  106002:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106005:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106008:	d1 ea                	shr    %edx
  10600a:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10600d:	c1 ea 02             	shr    $0x2,%edx
  106010:	09 d0                	or     %edx,%eax
  106012:	89 c1                	mov    %eax,%ecx
  106014:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106017:	d1 e8                	shr    %eax
  106019:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10601c:	89 c2                	mov    %eax,%edx
  10601e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106021:	d1 e8                	shr    %eax
  106023:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106026:	c1 e8 02             	shr    $0x2,%eax
  106029:	09 d0                	or     %edx,%eax
  10602b:	c1 e8 04             	shr    $0x4,%eax
  10602e:	89 cb                	mov    %ecx,%ebx
  106030:	09 c3                	or     %eax,%ebx
  106032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106035:	d1 e8                	shr    %eax
  106037:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10603a:	89 c2                	mov    %eax,%edx
  10603c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10603f:	d1 e8                	shr    %eax
  106041:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106044:	c1 e8 02             	shr    $0x2,%eax
  106047:	89 d1                	mov    %edx,%ecx
  106049:	09 c1                	or     %eax,%ecx
  10604b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10604e:	d1 e8                	shr    %eax
  106050:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106053:	89 c2                	mov    %eax,%edx
  106055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106058:	d1 e8                	shr    %eax
  10605a:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10605d:	c1 e8 02             	shr    $0x2,%eax
  106060:	09 d0                	or     %edx,%eax
  106062:	c1 e8 04             	shr    $0x4,%eax
  106065:	09 c8                	or     %ecx,%eax
  106067:	c1 e8 08             	shr    $0x8,%eax
  10606a:	09 d8                	or     %ebx,%eax
  10606c:	c1 e8 10             	shr    $0x10,%eax
  10606f:	09 f0                	or     %esi,%eax
  106071:	d1 e8                	shr    %eax
  106073:	23 45 e4             	and    -0x1c(%ebp),%eax
  106076:	85 c0                	test   %eax,%eax
  106078:	0f 84 ea 00 00 00    	je     106168 <buddy_init_segment+0x3b6>
  10607e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106081:	d1 e8                	shr    %eax
  106083:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106086:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106089:	d1 ea                	shr    %edx
  10608b:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10608e:	c1 ea 02             	shr    $0x2,%edx
  106091:	09 d0                	or     %edx,%eax
  106093:	89 c1                	mov    %eax,%ecx
  106095:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106098:	d1 e8                	shr    %eax
  10609a:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10609d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1060a0:	d1 ea                	shr    %edx
  1060a2:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1060a5:	c1 ea 02             	shr    $0x2,%edx
  1060a8:	09 d0                	or     %edx,%eax
  1060aa:	c1 e8 04             	shr    $0x4,%eax
  1060ad:	09 c1                	or     %eax,%ecx
  1060af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1060b2:	d1 e8                	shr    %eax
  1060b4:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1060b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1060ba:	d1 ea                	shr    %edx
  1060bc:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1060bf:	c1 ea 02             	shr    $0x2,%edx
  1060c2:	09 d0                	or     %edx,%eax
  1060c4:	89 c3                	mov    %eax,%ebx
  1060c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1060c9:	d1 e8                	shr    %eax
  1060cb:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1060ce:	89 c2                	mov    %eax,%edx
  1060d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1060d3:	d1 e8                	shr    %eax
  1060d5:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1060d8:	c1 e8 02             	shr    $0x2,%eax
  1060db:	09 d0                	or     %edx,%eax
  1060dd:	c1 e8 04             	shr    $0x4,%eax
  1060e0:	09 d8                	or     %ebx,%eax
  1060e2:	c1 e8 08             	shr    $0x8,%eax
  1060e5:	89 ce                	mov    %ecx,%esi
  1060e7:	09 c6                	or     %eax,%esi
  1060e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1060ec:	d1 e8                	shr    %eax
  1060ee:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1060f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1060f4:	d1 ea                	shr    %edx
  1060f6:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1060f9:	c1 ea 02             	shr    $0x2,%edx
  1060fc:	09 d0                	or     %edx,%eax
  1060fe:	89 c1                	mov    %eax,%ecx
  106100:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106103:	d1 e8                	shr    %eax
  106105:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106108:	89 c2                	mov    %eax,%edx
  10610a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10610d:	d1 e8                	shr    %eax
  10610f:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106112:	c1 e8 02             	shr    $0x2,%eax
  106115:	09 d0                	or     %edx,%eax
  106117:	c1 e8 04             	shr    $0x4,%eax
  10611a:	89 cb                	mov    %ecx,%ebx
  10611c:	09 c3                	or     %eax,%ebx
  10611e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106121:	d1 e8                	shr    %eax
  106123:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106126:	89 c2                	mov    %eax,%edx
  106128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10612b:	d1 e8                	shr    %eax
  10612d:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106130:	c1 e8 02             	shr    $0x2,%eax
  106133:	89 d1                	mov    %edx,%ecx
  106135:	09 c1                	or     %eax,%ecx
  106137:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10613a:	d1 e8                	shr    %eax
  10613c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10613f:	89 c2                	mov    %eax,%edx
  106141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106144:	d1 e8                	shr    %eax
  106146:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106149:	c1 e8 02             	shr    $0x2,%eax
  10614c:	09 d0                	or     %edx,%eax
  10614e:	c1 e8 04             	shr    $0x4,%eax
  106151:	09 c8                	or     %ecx,%eax
  106153:	c1 e8 08             	shr    $0x8,%eax
  106156:	09 d8                	or     %ebx,%eax
  106158:	c1 e8 10             	shr    $0x10,%eax
  10615b:	09 f0                	or     %esi,%eax
  10615d:	d1 e8                	shr    %eax
  10615f:	f7 d0                	not    %eax
  106161:	23 45 e4             	and    -0x1c(%ebp),%eax
  106164:	89 c6                	mov    %eax,%esi
  106166:	eb 03                	jmp    10616b <buddy_init_segment+0x3b9>
  106168:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  10616b:	89 f8                	mov    %edi,%eax
  10616d:	ba 00 00 00 00       	mov    $0x0,%edx
  106172:	f7 f6                	div    %esi
  106174:	8b 55 80             	mov    -0x80(%ebp),%edx
  106177:	0f af d0             	imul   %eax,%edx
  10617a:	89 d0                	mov    %edx,%eax
  10617c:	c1 e0 02             	shl    $0x2,%eax
  10617f:	01 d0                	add    %edx,%eax
  106181:	c1 e0 02             	shl    $0x2,%eax
  106184:	03 45 84             	add    -0x7c(%ebp),%eax
  106187:	89 45 d0             	mov    %eax,-0x30(%ebp)
            page->property = virtual_size;
  10618a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10618d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  106190:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&(free_list), &(page->page_link));
  106193:	8b 45 d0             	mov    -0x30(%ebp),%eax
  106196:	83 c0 0c             	add    $0xc,%eax
  106199:	c7 45 c8 38 3f 12 00 	movl   $0x123f38,-0x38(%ebp)
  1061a0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  1061a3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1061a6:	89 45 c0             	mov    %eax,-0x40(%ebp)
  1061a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1061ac:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_add(elm, listelm, listelm->next);
  1061af:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1061b2:	8b 40 04             	mov    0x4(%eax),%eax
  1061b5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1061b8:	89 55 b8             	mov    %edx,-0x48(%ebp)
  1061bb:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1061be:	89 55 b4             	mov    %edx,-0x4c(%ebp)
  1061c1:	89 45 b0             	mov    %eax,-0x50(%ebp)
    prev->next = next->prev = elm;
  1061c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1061c7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1061ca:	89 10                	mov    %edx,(%eax)
  1061cc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1061cf:	8b 10                	mov    (%eax),%edx
  1061d1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1061d4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1061d7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1061da:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1061dd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1061e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1061e3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1061e6:	89 10                	mov    %edx,(%eax)
}
  1061e8:	90                   	nop
}
  1061e9:	90                   	nop
}
  1061ea:	90                   	nop
            buddy_segment[BUDDY_LEFT(block)] = virtual_size;
  1061eb:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  1061f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1061f3:	c1 e2 03             	shl    $0x3,%edx
  1061f6:	01 c2                	add    %eax,%edx
  1061f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1061fb:	89 02                	mov    %eax,(%edx)
            // Switch to right
            alloc_size -= virtual_size;
  1061fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106200:	29 45 e0             	sub    %eax,-0x20(%ebp)
            buddy_segment[BUDDY_RIGHT(block)] = alloc_size;
  106203:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  106208:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10620b:	c1 e2 03             	shl    $0x3,%edx
  10620e:	83 c2 04             	add    $0x4,%edx
  106211:	01 c2                	add    %eax,%edx
  106213:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106216:	89 02                	mov    %eax,(%edx)
            block = BUDDY_RIGHT(block);
  106218:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10621b:	01 c0                	add    %eax,%eax
  10621d:	40                   	inc    %eax
  10621e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106221:	eb 2b                	jmp    10624e <buddy_init_segment+0x49c>
        } else {
            // Switch to left
            buddy_segment[BUDDY_LEFT(block)] = alloc_size;
  106223:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  106228:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10622b:	c1 e2 03             	shl    $0x3,%edx
  10622e:	01 c2                	add    %eax,%edx
  106230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106233:	89 02                	mov    %eax,(%edx)
            buddy_segment[BUDDY_RIGHT(block)] = 0;
  106235:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  10623a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10623d:	c1 e2 03             	shl    $0x3,%edx
  106240:	83 c2 04             	add    $0x4,%edx
  106243:	01 d0                	add    %edx,%eax
  106245:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            block = BUDDY_LEFT(block);
  10624b:	d1 65 e4             	shll   -0x1c(%ebp)
    while (alloc_size > 0 && alloc_size < virtual_size) {
  10624e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  106252:	74 0c                	je     106260 <buddy_init_segment+0x4ae>
  106254:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106257:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10625a:	0f 82 3a fc ff ff    	jb     105e9a <buddy_init_segment+0xe8>
        }
    }
    if (alloc_size > 0) {
  106260:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  106264:	0f 84 42 03 00 00    	je     1065ac <buddy_init_segment+0x7fa>
        struct Page *page = &buddy_alloc[BUDDY_BEGIN(block)];
  10626a:	a1 24 3f 12 00       	mov    0x123f24,%eax
  10626f:	89 45 84             	mov    %eax,-0x7c(%ebp)
  106272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106275:	d1 e8                	shr    %eax
  106277:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10627a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10627d:	d1 ea                	shr    %edx
  10627f:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106282:	c1 ea 02             	shr    $0x2,%edx
  106285:	09 d0                	or     %edx,%eax
  106287:	89 c1                	mov    %eax,%ecx
  106289:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10628c:	d1 e8                	shr    %eax
  10628e:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106291:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106294:	d1 ea                	shr    %edx
  106296:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106299:	c1 ea 02             	shr    $0x2,%edx
  10629c:	09 d0                	or     %edx,%eax
  10629e:	c1 e8 04             	shr    $0x4,%eax
  1062a1:	09 c1                	or     %eax,%ecx
  1062a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1062a6:	d1 e8                	shr    %eax
  1062a8:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1062ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1062ae:	d1 ea                	shr    %edx
  1062b0:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1062b3:	c1 ea 02             	shr    $0x2,%edx
  1062b6:	09 d0                	or     %edx,%eax
  1062b8:	89 c3                	mov    %eax,%ebx
  1062ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1062bd:	d1 e8                	shr    %eax
  1062bf:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1062c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1062c5:	d1 ea                	shr    %edx
  1062c7:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1062ca:	c1 ea 02             	shr    $0x2,%edx
  1062cd:	09 d0                	or     %edx,%eax
  1062cf:	c1 e8 04             	shr    $0x4,%eax
  1062d2:	09 d8                	or     %ebx,%eax
  1062d4:	c1 e8 08             	shr    $0x8,%eax
  1062d7:	09 c1                	or     %eax,%ecx
  1062d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1062dc:	d1 e8                	shr    %eax
  1062de:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1062e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1062e4:	d1 ea                	shr    %edx
  1062e6:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1062e9:	c1 ea 02             	shr    $0x2,%edx
  1062ec:	09 d0                	or     %edx,%eax
  1062ee:	89 c3                	mov    %eax,%ebx
  1062f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1062f3:	d1 e8                	shr    %eax
  1062f5:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1062f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1062fb:	d1 ea                	shr    %edx
  1062fd:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106300:	c1 ea 02             	shr    $0x2,%edx
  106303:	09 d0                	or     %edx,%eax
  106305:	c1 e8 04             	shr    $0x4,%eax
  106308:	09 c3                	or     %eax,%ebx
  10630a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10630d:	d1 e8                	shr    %eax
  10630f:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106312:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106315:	d1 ea                	shr    %edx
  106317:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10631a:	c1 ea 02             	shr    $0x2,%edx
  10631d:	09 d0                	or     %edx,%eax
  10631f:	89 c6                	mov    %eax,%esi
  106321:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106324:	d1 e8                	shr    %eax
  106326:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106329:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10632c:	d1 ea                	shr    %edx
  10632e:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106331:	c1 ea 02             	shr    $0x2,%edx
  106334:	09 d0                	or     %edx,%eax
  106336:	c1 e8 04             	shr    $0x4,%eax
  106339:	09 f0                	or     %esi,%eax
  10633b:	c1 e8 08             	shr    $0x8,%eax
  10633e:	09 d8                	or     %ebx,%eax
  106340:	c1 e8 10             	shr    $0x10,%eax
  106343:	09 c8                	or     %ecx,%eax
  106345:	d1 e8                	shr    %eax
  106347:	23 45 e4             	and    -0x1c(%ebp),%eax
  10634a:	89 45 80             	mov    %eax,-0x80(%ebp)
  10634d:	8b 3d 10 3f 12 00    	mov    0x123f10,%edi
  106353:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106356:	d1 e8                	shr    %eax
  106358:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10635b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10635e:	d1 ea                	shr    %edx
  106360:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106363:	c1 ea 02             	shr    $0x2,%edx
  106366:	09 d0                	or     %edx,%eax
  106368:	89 c1                	mov    %eax,%ecx
  10636a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10636d:	d1 e8                	shr    %eax
  10636f:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106372:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106375:	d1 ea                	shr    %edx
  106377:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10637a:	c1 ea 02             	shr    $0x2,%edx
  10637d:	09 d0                	or     %edx,%eax
  10637f:	c1 e8 04             	shr    $0x4,%eax
  106382:	09 c1                	or     %eax,%ecx
  106384:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106387:	d1 e8                	shr    %eax
  106389:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10638c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10638f:	d1 ea                	shr    %edx
  106391:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106394:	c1 ea 02             	shr    $0x2,%edx
  106397:	09 d0                	or     %edx,%eax
  106399:	89 c3                	mov    %eax,%ebx
  10639b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10639e:	d1 e8                	shr    %eax
  1063a0:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1063a3:	89 c2                	mov    %eax,%edx
  1063a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1063a8:	d1 e8                	shr    %eax
  1063aa:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1063ad:	c1 e8 02             	shr    $0x2,%eax
  1063b0:	09 d0                	or     %edx,%eax
  1063b2:	c1 e8 04             	shr    $0x4,%eax
  1063b5:	09 d8                	or     %ebx,%eax
  1063b7:	c1 e8 08             	shr    $0x8,%eax
  1063ba:	89 ce                	mov    %ecx,%esi
  1063bc:	09 c6                	or     %eax,%esi
  1063be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1063c1:	d1 e8                	shr    %eax
  1063c3:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1063c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1063c9:	d1 ea                	shr    %edx
  1063cb:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1063ce:	c1 ea 02             	shr    $0x2,%edx
  1063d1:	09 d0                	or     %edx,%eax
  1063d3:	89 c1                	mov    %eax,%ecx
  1063d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1063d8:	d1 e8                	shr    %eax
  1063da:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1063dd:	89 c2                	mov    %eax,%edx
  1063df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1063e2:	d1 e8                	shr    %eax
  1063e4:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1063e7:	c1 e8 02             	shr    $0x2,%eax
  1063ea:	09 d0                	or     %edx,%eax
  1063ec:	c1 e8 04             	shr    $0x4,%eax
  1063ef:	89 cb                	mov    %ecx,%ebx
  1063f1:	09 c3                	or     %eax,%ebx
  1063f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1063f6:	d1 e8                	shr    %eax
  1063f8:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1063fb:	89 c2                	mov    %eax,%edx
  1063fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106400:	d1 e8                	shr    %eax
  106402:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106405:	c1 e8 02             	shr    $0x2,%eax
  106408:	89 d1                	mov    %edx,%ecx
  10640a:	09 c1                	or     %eax,%ecx
  10640c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10640f:	d1 e8                	shr    %eax
  106411:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106414:	89 c2                	mov    %eax,%edx
  106416:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106419:	d1 e8                	shr    %eax
  10641b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10641e:	c1 e8 02             	shr    $0x2,%eax
  106421:	09 d0                	or     %edx,%eax
  106423:	c1 e8 04             	shr    $0x4,%eax
  106426:	09 c8                	or     %ecx,%eax
  106428:	c1 e8 08             	shr    $0x8,%eax
  10642b:	09 d8                	or     %ebx,%eax
  10642d:	c1 e8 10             	shr    $0x10,%eax
  106430:	09 f0                	or     %esi,%eax
  106432:	d1 e8                	shr    %eax
  106434:	23 45 e4             	and    -0x1c(%ebp),%eax
  106437:	85 c0                	test   %eax,%eax
  106439:	0f 84 ea 00 00 00    	je     106529 <buddy_init_segment+0x777>
  10643f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106442:	d1 e8                	shr    %eax
  106444:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106447:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10644a:	d1 ea                	shr    %edx
  10644c:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10644f:	c1 ea 02             	shr    $0x2,%edx
  106452:	09 d0                	or     %edx,%eax
  106454:	89 c1                	mov    %eax,%ecx
  106456:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106459:	d1 e8                	shr    %eax
  10645b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10645e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106461:	d1 ea                	shr    %edx
  106463:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106466:	c1 ea 02             	shr    $0x2,%edx
  106469:	09 d0                	or     %edx,%eax
  10646b:	c1 e8 04             	shr    $0x4,%eax
  10646e:	09 c1                	or     %eax,%ecx
  106470:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106473:	d1 e8                	shr    %eax
  106475:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106478:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10647b:	d1 ea                	shr    %edx
  10647d:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106480:	c1 ea 02             	shr    $0x2,%edx
  106483:	09 d0                	or     %edx,%eax
  106485:	89 c3                	mov    %eax,%ebx
  106487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10648a:	d1 e8                	shr    %eax
  10648c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10648f:	89 c2                	mov    %eax,%edx
  106491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106494:	d1 e8                	shr    %eax
  106496:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106499:	c1 e8 02             	shr    $0x2,%eax
  10649c:	09 d0                	or     %edx,%eax
  10649e:	c1 e8 04             	shr    $0x4,%eax
  1064a1:	09 d8                	or     %ebx,%eax
  1064a3:	c1 e8 08             	shr    $0x8,%eax
  1064a6:	89 ce                	mov    %ecx,%esi
  1064a8:	09 c6                	or     %eax,%esi
  1064aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1064ad:	d1 e8                	shr    %eax
  1064af:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1064b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1064b5:	d1 ea                	shr    %edx
  1064b7:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1064ba:	c1 ea 02             	shr    $0x2,%edx
  1064bd:	09 d0                	or     %edx,%eax
  1064bf:	89 c1                	mov    %eax,%ecx
  1064c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1064c4:	d1 e8                	shr    %eax
  1064c6:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1064c9:	89 c2                	mov    %eax,%edx
  1064cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1064ce:	d1 e8                	shr    %eax
  1064d0:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1064d3:	c1 e8 02             	shr    $0x2,%eax
  1064d6:	09 d0                	or     %edx,%eax
  1064d8:	c1 e8 04             	shr    $0x4,%eax
  1064db:	89 cb                	mov    %ecx,%ebx
  1064dd:	09 c3                	or     %eax,%ebx
  1064df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1064e2:	d1 e8                	shr    %eax
  1064e4:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1064e7:	89 c2                	mov    %eax,%edx
  1064e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1064ec:	d1 e8                	shr    %eax
  1064ee:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1064f1:	c1 e8 02             	shr    $0x2,%eax
  1064f4:	89 d1                	mov    %edx,%ecx
  1064f6:	09 c1                	or     %eax,%ecx
  1064f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1064fb:	d1 e8                	shr    %eax
  1064fd:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106500:	89 c2                	mov    %eax,%edx
  106502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106505:	d1 e8                	shr    %eax
  106507:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10650a:	c1 e8 02             	shr    $0x2,%eax
  10650d:	09 d0                	or     %edx,%eax
  10650f:	c1 e8 04             	shr    $0x4,%eax
  106512:	09 c8                	or     %ecx,%eax
  106514:	c1 e8 08             	shr    $0x8,%eax
  106517:	09 d8                	or     %ebx,%eax
  106519:	c1 e8 10             	shr    $0x10,%eax
  10651c:	09 f0                	or     %esi,%eax
  10651e:	d1 e8                	shr    %eax
  106520:	f7 d0                	not    %eax
  106522:	23 45 e4             	and    -0x1c(%ebp),%eax
  106525:	89 c6                	mov    %eax,%esi
  106527:	eb 03                	jmp    10652c <buddy_init_segment+0x77a>
  106529:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  10652c:	89 f8                	mov    %edi,%eax
  10652e:	ba 00 00 00 00       	mov    $0x0,%edx
  106533:	f7 f6                	div    %esi
  106535:	8b 55 80             	mov    -0x80(%ebp),%edx
  106538:	0f af d0             	imul   %eax,%edx
  10653b:	89 d0                	mov    %edx,%eax
  10653d:	c1 e0 02             	shl    $0x2,%eax
  106540:	01 d0                	add    %edx,%eax
  106542:	c1 e0 02             	shl    $0x2,%eax
  106545:	03 45 84             	add    -0x7c(%ebp),%eax
  106548:	89 45 cc             	mov    %eax,-0x34(%ebp)
        page->property = alloc_size;
  10654b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10654e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  106551:	89 50 08             	mov    %edx,0x8(%eax)
        list_add(&(free_list), &(page->page_link));
  106554:	8b 45 cc             	mov    -0x34(%ebp),%eax
  106557:	83 c0 0c             	add    $0xc,%eax
  10655a:	c7 45 ac 38 3f 12 00 	movl   $0x123f38,-0x54(%ebp)
  106561:	89 45 a8             	mov    %eax,-0x58(%ebp)
  106564:	8b 45 ac             	mov    -0x54(%ebp),%eax
  106567:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  10656a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10656d:	89 45 a0             	mov    %eax,-0x60(%ebp)
    __list_add(elm, listelm, listelm->next);
  106570:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  106573:	8b 40 04             	mov    0x4(%eax),%eax
  106576:	8b 55 a0             	mov    -0x60(%ebp),%edx
  106579:	89 55 9c             	mov    %edx,-0x64(%ebp)
  10657c:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  10657f:	89 55 98             	mov    %edx,-0x68(%ebp)
  106582:	89 45 94             	mov    %eax,-0x6c(%ebp)
    prev->next = next->prev = elm;
  106585:	8b 45 94             	mov    -0x6c(%ebp),%eax
  106588:	8b 55 9c             	mov    -0x64(%ebp),%edx
  10658b:	89 10                	mov    %edx,(%eax)
  10658d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  106590:	8b 10                	mov    (%eax),%edx
  106592:	8b 45 98             	mov    -0x68(%ebp),%eax
  106595:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  106598:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10659b:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10659e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1065a1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1065a4:	8b 55 98             	mov    -0x68(%ebp),%edx
  1065a7:	89 10                	mov    %edx,(%eax)
}
  1065a9:	90                   	nop
}
  1065aa:	90                   	nop
}
  1065ab:	90                   	nop
    }
}
  1065ac:	90                   	nop
  1065ad:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  1065b3:	5b                   	pop    %ebx
  1065b4:	5e                   	pop    %esi
  1065b5:	5f                   	pop    %edi
  1065b6:	5d                   	pop    %ebp
  1065b7:	c3                   	ret    

001065b8 <buddy_init>:

static void
buddy_init(void) {
  1065b8:	f3 0f 1e fb          	endbr32 
  1065bc:	55                   	push   %ebp
  1065bd:	89 e5                	mov    %esp,%ebp
  1065bf:	83 ec 10             	sub    $0x10,%esp
  1065c2:	c7 45 fc 38 3f 12 00 	movl   $0x123f38,-0x4(%ebp)
    elm->prev = elm->next = elm;
  1065c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1065cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1065cf:	89 50 04             	mov    %edx,0x4(%eax)
  1065d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1065d5:	8b 50 04             	mov    0x4(%eax),%edx
  1065d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1065db:	89 10                	mov    %edx,(%eax)
}
  1065dd:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  1065de:	c7 05 40 3f 12 00 00 	movl   $0x0,0x123f40
  1065e5:	00 00 00 
}
  1065e8:	90                   	nop
  1065e9:	c9                   	leave  
  1065ea:	c3                   	ret    

001065eb <buddy_init_memmap>:

static void
buddy_init_memmap(struct Page *base, size_t n) {
  1065eb:	f3 0f 1e fb          	endbr32 
  1065ef:	55                   	push   %ebp
  1065f0:	89 e5                	mov    %esp,%ebp
  1065f2:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0);
  1065f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1065f9:	75 24                	jne    10661f <buddy_init_memmap+0x34>
  1065fb:	c7 44 24 0c 0b b3 10 	movl   $0x10b30b,0xc(%esp)
  106602:	00 
  106603:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  10660a:	00 
  10660b:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
  106612:	00 
  106613:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  10661a:	e8 17 9e ff ff       	call   100436 <__panic>
    // Init pages
    for (struct Page *p = base; p < base + n; p++) {
  10661f:	8b 45 08             	mov    0x8(%ebp),%eax
  106622:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106625:	eb 7d                	jmp    1066a4 <buddy_init_memmap+0xb9>
        assert(PageReserved(p));
  106627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10662a:	83 c0 04             	add    $0x4,%eax
  10662d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  106634:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  106637:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10663a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10663d:	0f a3 10             	bt     %edx,(%eax)
  106640:	19 c0                	sbb    %eax,%eax
  106642:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  106645:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  106649:	0f 95 c0             	setne  %al
  10664c:	0f b6 c0             	movzbl %al,%eax
  10664f:	85 c0                	test   %eax,%eax
  106651:	75 24                	jne    106677 <buddy_init_memmap+0x8c>
  106653:	c7 44 24 0c 11 b3 10 	movl   $0x10b311,0xc(%esp)
  10665a:	00 
  10665b:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  106662:	00 
  106663:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  10666a:	00 
  10666b:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  106672:	e8 bf 9d ff ff       	call   100436 <__panic>
        p->flags = p->property = 0;
  106677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10667a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  106681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106684:	8b 50 08             	mov    0x8(%eax),%edx
  106687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10668a:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  10668d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  106694:	00 
  106695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106698:	89 04 24             	mov    %eax,(%esp)
  10669b:	e8 fb f1 ff ff       	call   10589b <set_page_ref>
    for (struct Page *p = base; p < base + n; p++) {
  1066a0:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1066a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1066a7:	89 d0                	mov    %edx,%eax
  1066a9:	c1 e0 02             	shl    $0x2,%eax
  1066ac:	01 d0                	add    %edx,%eax
  1066ae:	c1 e0 02             	shl    $0x2,%eax
  1066b1:	89 c2                	mov    %eax,%edx
  1066b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1066b6:	01 d0                	add    %edx,%eax
  1066b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1066bb:	0f 82 66 ff ff ff    	jb     106627 <buddy_init_memmap+0x3c>
    }
    // Init size
    buddy_init_size(n);
  1066c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1066c4:	89 04 24             	mov    %eax,(%esp)
  1066c7:	e8 dd f1 ff ff       	call   1058a9 <buddy_init_size>
    // Init segment
    buddy_init_segment(base);
  1066cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1066cf:	89 04 24             	mov    %eax,(%esp)
  1066d2:	e8 db f6 ff ff       	call   105db2 <buddy_init_segment>
}
  1066d7:	90                   	nop
  1066d8:	c9                   	leave  
  1066d9:	c3                   	ret    

001066da <buddy_alloc_pages>:

static struct Page *
buddy_alloc_pages(size_t n) {
  1066da:	f3 0f 1e fb          	endbr32 
  1066de:	55                   	push   %ebp
  1066df:	89 e5                	mov    %esp,%ebp
  1066e1:	57                   	push   %edi
  1066e2:	56                   	push   %esi
  1066e3:	53                   	push   %ebx
  1066e4:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    assert(n > 0);
  1066ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1066ee:	75 24                	jne    106714 <buddy_alloc_pages+0x3a>
  1066f0:	c7 44 24 0c 0b b3 10 	movl   $0x10b30b,0xc(%esp)
  1066f7:	00 
  1066f8:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  1066ff:	00 
  106700:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  106707:	00 
  106708:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  10670f:	e8 22 9d ff ff       	call   100436 <__panic>
    struct Page *page;
    size_t block = BUDDY_ROOT;
  106714:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    size_t length = UINT32_ROUND_UP(n);
  10671b:	8b 45 08             	mov    0x8(%ebp),%eax
  10671e:	d1 e8                	shr    %eax
  106720:	0b 45 08             	or     0x8(%ebp),%eax
  106723:	8b 55 08             	mov    0x8(%ebp),%edx
  106726:	d1 ea                	shr    %edx
  106728:	0b 55 08             	or     0x8(%ebp),%edx
  10672b:	c1 ea 02             	shr    $0x2,%edx
  10672e:	09 d0                	or     %edx,%eax
  106730:	89 c1                	mov    %eax,%ecx
  106732:	8b 45 08             	mov    0x8(%ebp),%eax
  106735:	d1 e8                	shr    %eax
  106737:	0b 45 08             	or     0x8(%ebp),%eax
  10673a:	8b 55 08             	mov    0x8(%ebp),%edx
  10673d:	d1 ea                	shr    %edx
  10673f:	0b 55 08             	or     0x8(%ebp),%edx
  106742:	c1 ea 02             	shr    $0x2,%edx
  106745:	09 d0                	or     %edx,%eax
  106747:	c1 e8 04             	shr    $0x4,%eax
  10674a:	09 c1                	or     %eax,%ecx
  10674c:	8b 45 08             	mov    0x8(%ebp),%eax
  10674f:	d1 e8                	shr    %eax
  106751:	0b 45 08             	or     0x8(%ebp),%eax
  106754:	8b 55 08             	mov    0x8(%ebp),%edx
  106757:	d1 ea                	shr    %edx
  106759:	0b 55 08             	or     0x8(%ebp),%edx
  10675c:	c1 ea 02             	shr    $0x2,%edx
  10675f:	09 d0                	or     %edx,%eax
  106761:	89 c3                	mov    %eax,%ebx
  106763:	8b 45 08             	mov    0x8(%ebp),%eax
  106766:	d1 e8                	shr    %eax
  106768:	0b 45 08             	or     0x8(%ebp),%eax
  10676b:	8b 55 08             	mov    0x8(%ebp),%edx
  10676e:	d1 ea                	shr    %edx
  106770:	0b 55 08             	or     0x8(%ebp),%edx
  106773:	c1 ea 02             	shr    $0x2,%edx
  106776:	09 d0                	or     %edx,%eax
  106778:	c1 e8 04             	shr    $0x4,%eax
  10677b:	09 d8                	or     %ebx,%eax
  10677d:	c1 e8 08             	shr    $0x8,%eax
  106780:	09 c1                	or     %eax,%ecx
  106782:	8b 45 08             	mov    0x8(%ebp),%eax
  106785:	d1 e8                	shr    %eax
  106787:	0b 45 08             	or     0x8(%ebp),%eax
  10678a:	8b 55 08             	mov    0x8(%ebp),%edx
  10678d:	d1 ea                	shr    %edx
  10678f:	0b 55 08             	or     0x8(%ebp),%edx
  106792:	c1 ea 02             	shr    $0x2,%edx
  106795:	09 d0                	or     %edx,%eax
  106797:	89 c3                	mov    %eax,%ebx
  106799:	8b 45 08             	mov    0x8(%ebp),%eax
  10679c:	d1 e8                	shr    %eax
  10679e:	0b 45 08             	or     0x8(%ebp),%eax
  1067a1:	8b 55 08             	mov    0x8(%ebp),%edx
  1067a4:	d1 ea                	shr    %edx
  1067a6:	0b 55 08             	or     0x8(%ebp),%edx
  1067a9:	c1 ea 02             	shr    $0x2,%edx
  1067ac:	09 d0                	or     %edx,%eax
  1067ae:	c1 e8 04             	shr    $0x4,%eax
  1067b1:	09 c3                	or     %eax,%ebx
  1067b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1067b6:	d1 e8                	shr    %eax
  1067b8:	0b 45 08             	or     0x8(%ebp),%eax
  1067bb:	8b 55 08             	mov    0x8(%ebp),%edx
  1067be:	d1 ea                	shr    %edx
  1067c0:	0b 55 08             	or     0x8(%ebp),%edx
  1067c3:	c1 ea 02             	shr    $0x2,%edx
  1067c6:	09 d0                	or     %edx,%eax
  1067c8:	89 c6                	mov    %eax,%esi
  1067ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1067cd:	d1 e8                	shr    %eax
  1067cf:	0b 45 08             	or     0x8(%ebp),%eax
  1067d2:	8b 55 08             	mov    0x8(%ebp),%edx
  1067d5:	d1 ea                	shr    %edx
  1067d7:	0b 55 08             	or     0x8(%ebp),%edx
  1067da:	c1 ea 02             	shr    $0x2,%edx
  1067dd:	09 d0                	or     %edx,%eax
  1067df:	c1 e8 04             	shr    $0x4,%eax
  1067e2:	09 f0                	or     %esi,%eax
  1067e4:	c1 e8 08             	shr    $0x8,%eax
  1067e7:	09 d8                	or     %ebx,%eax
  1067e9:	c1 e8 10             	shr    $0x10,%eax
  1067ec:	09 c8                	or     %ecx,%eax
  1067ee:	d1 e8                	shr    %eax
  1067f0:	23 45 08             	and    0x8(%ebp),%eax
  1067f3:	85 c0                	test   %eax,%eax
  1067f5:	0f 84 de 00 00 00    	je     1068d9 <buddy_alloc_pages+0x1ff>
  1067fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1067fe:	d1 e8                	shr    %eax
  106800:	0b 45 08             	or     0x8(%ebp),%eax
  106803:	8b 55 08             	mov    0x8(%ebp),%edx
  106806:	d1 ea                	shr    %edx
  106808:	0b 55 08             	or     0x8(%ebp),%edx
  10680b:	c1 ea 02             	shr    $0x2,%edx
  10680e:	09 d0                	or     %edx,%eax
  106810:	89 c1                	mov    %eax,%ecx
  106812:	8b 45 08             	mov    0x8(%ebp),%eax
  106815:	d1 e8                	shr    %eax
  106817:	0b 45 08             	or     0x8(%ebp),%eax
  10681a:	8b 55 08             	mov    0x8(%ebp),%edx
  10681d:	d1 ea                	shr    %edx
  10681f:	0b 55 08             	or     0x8(%ebp),%edx
  106822:	c1 ea 02             	shr    $0x2,%edx
  106825:	09 d0                	or     %edx,%eax
  106827:	c1 e8 04             	shr    $0x4,%eax
  10682a:	09 c1                	or     %eax,%ecx
  10682c:	8b 45 08             	mov    0x8(%ebp),%eax
  10682f:	d1 e8                	shr    %eax
  106831:	0b 45 08             	or     0x8(%ebp),%eax
  106834:	8b 55 08             	mov    0x8(%ebp),%edx
  106837:	d1 ea                	shr    %edx
  106839:	0b 55 08             	or     0x8(%ebp),%edx
  10683c:	c1 ea 02             	shr    $0x2,%edx
  10683f:	09 d0                	or     %edx,%eax
  106841:	89 c3                	mov    %eax,%ebx
  106843:	8b 45 08             	mov    0x8(%ebp),%eax
  106846:	d1 e8                	shr    %eax
  106848:	0b 45 08             	or     0x8(%ebp),%eax
  10684b:	8b 55 08             	mov    0x8(%ebp),%edx
  10684e:	d1 ea                	shr    %edx
  106850:	0b 55 08             	or     0x8(%ebp),%edx
  106853:	c1 ea 02             	shr    $0x2,%edx
  106856:	09 d0                	or     %edx,%eax
  106858:	c1 e8 04             	shr    $0x4,%eax
  10685b:	09 d8                	or     %ebx,%eax
  10685d:	c1 e8 08             	shr    $0x8,%eax
  106860:	09 c1                	or     %eax,%ecx
  106862:	8b 45 08             	mov    0x8(%ebp),%eax
  106865:	d1 e8                	shr    %eax
  106867:	0b 45 08             	or     0x8(%ebp),%eax
  10686a:	8b 55 08             	mov    0x8(%ebp),%edx
  10686d:	d1 ea                	shr    %edx
  10686f:	0b 55 08             	or     0x8(%ebp),%edx
  106872:	c1 ea 02             	shr    $0x2,%edx
  106875:	09 d0                	or     %edx,%eax
  106877:	89 c3                	mov    %eax,%ebx
  106879:	8b 45 08             	mov    0x8(%ebp),%eax
  10687c:	d1 e8                	shr    %eax
  10687e:	0b 45 08             	or     0x8(%ebp),%eax
  106881:	8b 55 08             	mov    0x8(%ebp),%edx
  106884:	d1 ea                	shr    %edx
  106886:	0b 55 08             	or     0x8(%ebp),%edx
  106889:	c1 ea 02             	shr    $0x2,%edx
  10688c:	09 d0                	or     %edx,%eax
  10688e:	c1 e8 04             	shr    $0x4,%eax
  106891:	09 c3                	or     %eax,%ebx
  106893:	8b 45 08             	mov    0x8(%ebp),%eax
  106896:	d1 e8                	shr    %eax
  106898:	0b 45 08             	or     0x8(%ebp),%eax
  10689b:	8b 55 08             	mov    0x8(%ebp),%edx
  10689e:	d1 ea                	shr    %edx
  1068a0:	0b 55 08             	or     0x8(%ebp),%edx
  1068a3:	c1 ea 02             	shr    $0x2,%edx
  1068a6:	09 d0                	or     %edx,%eax
  1068a8:	89 c6                	mov    %eax,%esi
  1068aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1068ad:	d1 e8                	shr    %eax
  1068af:	0b 45 08             	or     0x8(%ebp),%eax
  1068b2:	8b 55 08             	mov    0x8(%ebp),%edx
  1068b5:	d1 ea                	shr    %edx
  1068b7:	0b 55 08             	or     0x8(%ebp),%edx
  1068ba:	c1 ea 02             	shr    $0x2,%edx
  1068bd:	09 d0                	or     %edx,%eax
  1068bf:	c1 e8 04             	shr    $0x4,%eax
  1068c2:	09 f0                	or     %esi,%eax
  1068c4:	c1 e8 08             	shr    $0x8,%eax
  1068c7:	09 d8                	or     %ebx,%eax
  1068c9:	c1 e8 10             	shr    $0x10,%eax
  1068cc:	09 c8                	or     %ecx,%eax
  1068ce:	d1 e8                	shr    %eax
  1068d0:	f7 d0                	not    %eax
  1068d2:	23 45 08             	and    0x8(%ebp),%eax
  1068d5:	01 c0                	add    %eax,%eax
  1068d7:	eb 03                	jmp    1068dc <buddy_alloc_pages+0x202>
  1068d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1068dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    // Find block
    while (length <= buddy_segment[block] && length < BUDDY_LENGTH(block)) {
  1068df:	e9 f3 09 00 00       	jmp    1072d7 <buddy_alloc_pages+0xbfd>
        size_t left = BUDDY_LEFT(block);
  1068e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1068e7:	01 c0                	add    %eax,%eax
  1068e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
        size_t right = BUDDY_RIGHT(block);
  1068ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1068ef:	01 c0                	add    %eax,%eax
  1068f1:	40                   	inc    %eax
  1068f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
        if (BUDDY_EMPTY(block)) {                   // Split
  1068f5:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  1068fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1068fd:	c1 e2 02             	shl    $0x2,%edx
  106900:	01 d0                	add    %edx,%eax
  106902:	8b 00                	mov    (%eax),%eax
  106904:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  10690a:	8b 3d 10 3f 12 00    	mov    0x123f10,%edi
  106910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106913:	d1 e8                	shr    %eax
  106915:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106918:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10691b:	d1 ea                	shr    %edx
  10691d:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106920:	c1 ea 02             	shr    $0x2,%edx
  106923:	09 d0                	or     %edx,%eax
  106925:	89 c1                	mov    %eax,%ecx
  106927:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10692a:	d1 e8                	shr    %eax
  10692c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10692f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106932:	d1 ea                	shr    %edx
  106934:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106937:	c1 ea 02             	shr    $0x2,%edx
  10693a:	09 d0                	or     %edx,%eax
  10693c:	c1 e8 04             	shr    $0x4,%eax
  10693f:	09 c1                	or     %eax,%ecx
  106941:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106944:	d1 e8                	shr    %eax
  106946:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106949:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10694c:	d1 ea                	shr    %edx
  10694e:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106951:	c1 ea 02             	shr    $0x2,%edx
  106954:	09 d0                	or     %edx,%eax
  106956:	89 c3                	mov    %eax,%ebx
  106958:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10695b:	d1 e8                	shr    %eax
  10695d:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106960:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106963:	d1 ea                	shr    %edx
  106965:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106968:	c1 ea 02             	shr    $0x2,%edx
  10696b:	09 d0                	or     %edx,%eax
  10696d:	c1 e8 04             	shr    $0x4,%eax
  106970:	09 d8                	or     %ebx,%eax
  106972:	c1 e8 08             	shr    $0x8,%eax
  106975:	89 cb                	mov    %ecx,%ebx
  106977:	09 c3                	or     %eax,%ebx
  106979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10697c:	d1 e8                	shr    %eax
  10697e:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106981:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106984:	d1 ea                	shr    %edx
  106986:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106989:	c1 ea 02             	shr    $0x2,%edx
  10698c:	09 d0                	or     %edx,%eax
  10698e:	89 c1                	mov    %eax,%ecx
  106990:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106993:	d1 e8                	shr    %eax
  106995:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106998:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10699b:	d1 ea                	shr    %edx
  10699d:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1069a0:	c1 ea 02             	shr    $0x2,%edx
  1069a3:	09 d0                	or     %edx,%eax
  1069a5:	c1 e8 04             	shr    $0x4,%eax
  1069a8:	09 c1                	or     %eax,%ecx
  1069aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1069ad:	d1 e8                	shr    %eax
  1069af:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1069b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1069b5:	d1 ea                	shr    %edx
  1069b7:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1069ba:	c1 ea 02             	shr    $0x2,%edx
  1069bd:	09 d0                	or     %edx,%eax
  1069bf:	89 c6                	mov    %eax,%esi
  1069c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1069c4:	d1 e8                	shr    %eax
  1069c6:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1069c9:	89 c2                	mov    %eax,%edx
  1069cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1069ce:	d1 e8                	shr    %eax
  1069d0:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1069d3:	c1 e8 02             	shr    $0x2,%eax
  1069d6:	09 d0                	or     %edx,%eax
  1069d8:	c1 e8 04             	shr    $0x4,%eax
  1069db:	09 f0                	or     %esi,%eax
  1069dd:	c1 e8 08             	shr    $0x8,%eax
  1069e0:	09 c8                	or     %ecx,%eax
  1069e2:	c1 e8 10             	shr    $0x10,%eax
  1069e5:	09 d8                	or     %ebx,%eax
  1069e7:	d1 e8                	shr    %eax
  1069e9:	23 45 e4             	and    -0x1c(%ebp),%eax
  1069ec:	85 c0                	test   %eax,%eax
  1069ee:	0f 84 e2 00 00 00    	je     106ad6 <buddy_alloc_pages+0x3fc>
  1069f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1069f7:	d1 e8                	shr    %eax
  1069f9:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1069fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1069ff:	d1 ea                	shr    %edx
  106a01:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106a04:	c1 ea 02             	shr    $0x2,%edx
  106a07:	09 d0                	or     %edx,%eax
  106a09:	89 c1                	mov    %eax,%ecx
  106a0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106a0e:	d1 e8                	shr    %eax
  106a10:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106a13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106a16:	d1 ea                	shr    %edx
  106a18:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106a1b:	c1 ea 02             	shr    $0x2,%edx
  106a1e:	09 d0                	or     %edx,%eax
  106a20:	c1 e8 04             	shr    $0x4,%eax
  106a23:	09 c1                	or     %eax,%ecx
  106a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106a28:	d1 e8                	shr    %eax
  106a2a:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106a2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106a30:	d1 ea                	shr    %edx
  106a32:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106a35:	c1 ea 02             	shr    $0x2,%edx
  106a38:	09 d0                	or     %edx,%eax
  106a3a:	89 c3                	mov    %eax,%ebx
  106a3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106a3f:	d1 e8                	shr    %eax
  106a41:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106a44:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106a47:	d1 ea                	shr    %edx
  106a49:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106a4c:	c1 ea 02             	shr    $0x2,%edx
  106a4f:	09 d0                	or     %edx,%eax
  106a51:	c1 e8 04             	shr    $0x4,%eax
  106a54:	09 d8                	or     %ebx,%eax
  106a56:	c1 e8 08             	shr    $0x8,%eax
  106a59:	89 cb                	mov    %ecx,%ebx
  106a5b:	09 c3                	or     %eax,%ebx
  106a5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106a60:	d1 e8                	shr    %eax
  106a62:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106a65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106a68:	d1 ea                	shr    %edx
  106a6a:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106a6d:	c1 ea 02             	shr    $0x2,%edx
  106a70:	09 d0                	or     %edx,%eax
  106a72:	89 c1                	mov    %eax,%ecx
  106a74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106a77:	d1 e8                	shr    %eax
  106a79:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106a7c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106a7f:	d1 ea                	shr    %edx
  106a81:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106a84:	c1 ea 02             	shr    $0x2,%edx
  106a87:	09 d0                	or     %edx,%eax
  106a89:	c1 e8 04             	shr    $0x4,%eax
  106a8c:	09 c1                	or     %eax,%ecx
  106a8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106a91:	d1 e8                	shr    %eax
  106a93:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106a96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106a99:	d1 ea                	shr    %edx
  106a9b:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106a9e:	c1 ea 02             	shr    $0x2,%edx
  106aa1:	09 d0                	or     %edx,%eax
  106aa3:	89 c6                	mov    %eax,%esi
  106aa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106aa8:	d1 e8                	shr    %eax
  106aaa:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106aad:	89 c2                	mov    %eax,%edx
  106aaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106ab2:	d1 e8                	shr    %eax
  106ab4:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106ab7:	c1 e8 02             	shr    $0x2,%eax
  106aba:	09 d0                	or     %edx,%eax
  106abc:	c1 e8 04             	shr    $0x4,%eax
  106abf:	09 f0                	or     %esi,%eax
  106ac1:	c1 e8 08             	shr    $0x8,%eax
  106ac4:	09 c8                	or     %ecx,%eax
  106ac6:	c1 e8 10             	shr    $0x10,%eax
  106ac9:	09 d8                	or     %ebx,%eax
  106acb:	d1 e8                	shr    %eax
  106acd:	f7 d0                	not    %eax
  106acf:	23 45 e4             	and    -0x1c(%ebp),%eax
  106ad2:	89 c6                	mov    %eax,%esi
  106ad4:	eb 03                	jmp    106ad9 <buddy_alloc_pages+0x3ff>
  106ad6:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  106ad9:	89 f8                	mov    %edi,%eax
  106adb:	ba 00 00 00 00       	mov    $0x0,%edx
  106ae0:	f7 f6                	div    %esi
  106ae2:	39 85 74 ff ff ff    	cmp    %eax,-0x8c(%ebp)
  106ae8:	0f 85 51 07 00 00    	jne    10723f <buddy_alloc_pages+0xb65>
            size_t begin = BUDDY_BEGIN(block);
  106aee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106af1:	d1 e8                	shr    %eax
  106af3:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106af6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106af9:	d1 ea                	shr    %edx
  106afb:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106afe:	c1 ea 02             	shr    $0x2,%edx
  106b01:	09 d0                	or     %edx,%eax
  106b03:	89 c1                	mov    %eax,%ecx
  106b05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106b08:	d1 e8                	shr    %eax
  106b0a:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106b0d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106b10:	d1 ea                	shr    %edx
  106b12:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106b15:	c1 ea 02             	shr    $0x2,%edx
  106b18:	09 d0                	or     %edx,%eax
  106b1a:	c1 e8 04             	shr    $0x4,%eax
  106b1d:	09 c1                	or     %eax,%ecx
  106b1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106b22:	d1 e8                	shr    %eax
  106b24:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106b27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106b2a:	d1 ea                	shr    %edx
  106b2c:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106b2f:	c1 ea 02             	shr    $0x2,%edx
  106b32:	09 d0                	or     %edx,%eax
  106b34:	89 c3                	mov    %eax,%ebx
  106b36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106b39:	d1 e8                	shr    %eax
  106b3b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106b3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106b41:	d1 ea                	shr    %edx
  106b43:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106b46:	c1 ea 02             	shr    $0x2,%edx
  106b49:	09 d0                	or     %edx,%eax
  106b4b:	c1 e8 04             	shr    $0x4,%eax
  106b4e:	09 d8                	or     %ebx,%eax
  106b50:	c1 e8 08             	shr    $0x8,%eax
  106b53:	09 c1                	or     %eax,%ecx
  106b55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106b58:	d1 e8                	shr    %eax
  106b5a:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106b5d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106b60:	d1 ea                	shr    %edx
  106b62:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106b65:	c1 ea 02             	shr    $0x2,%edx
  106b68:	09 d0                	or     %edx,%eax
  106b6a:	89 c3                	mov    %eax,%ebx
  106b6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106b6f:	d1 e8                	shr    %eax
  106b71:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106b74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106b77:	d1 ea                	shr    %edx
  106b79:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106b7c:	c1 ea 02             	shr    $0x2,%edx
  106b7f:	09 d0                	or     %edx,%eax
  106b81:	c1 e8 04             	shr    $0x4,%eax
  106b84:	09 c3                	or     %eax,%ebx
  106b86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106b89:	d1 e8                	shr    %eax
  106b8b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106b8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106b91:	d1 ea                	shr    %edx
  106b93:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106b96:	c1 ea 02             	shr    $0x2,%edx
  106b99:	09 d0                	or     %edx,%eax
  106b9b:	89 c6                	mov    %eax,%esi
  106b9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106ba0:	d1 e8                	shr    %eax
  106ba2:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106ba5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106ba8:	d1 ea                	shr    %edx
  106baa:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106bad:	c1 ea 02             	shr    $0x2,%edx
  106bb0:	09 d0                	or     %edx,%eax
  106bb2:	c1 e8 04             	shr    $0x4,%eax
  106bb5:	09 f0                	or     %esi,%eax
  106bb7:	c1 e8 08             	shr    $0x8,%eax
  106bba:	09 d8                	or     %ebx,%eax
  106bbc:	c1 e8 10             	shr    $0x10,%eax
  106bbf:	09 c8                	or     %ecx,%eax
  106bc1:	d1 e8                	shr    %eax
  106bc3:	23 45 e4             	and    -0x1c(%ebp),%eax
  106bc6:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  106bcc:	8b 3d 10 3f 12 00    	mov    0x123f10,%edi
  106bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106bd5:	d1 e8                	shr    %eax
  106bd7:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106bda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106bdd:	d1 ea                	shr    %edx
  106bdf:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106be2:	c1 ea 02             	shr    $0x2,%edx
  106be5:	09 d0                	or     %edx,%eax
  106be7:	89 c1                	mov    %eax,%ecx
  106be9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106bec:	d1 e8                	shr    %eax
  106bee:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106bf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106bf4:	d1 ea                	shr    %edx
  106bf6:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106bf9:	c1 ea 02             	shr    $0x2,%edx
  106bfc:	09 d0                	or     %edx,%eax
  106bfe:	c1 e8 04             	shr    $0x4,%eax
  106c01:	09 c1                	or     %eax,%ecx
  106c03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106c06:	d1 e8                	shr    %eax
  106c08:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106c0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106c0e:	d1 ea                	shr    %edx
  106c10:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106c13:	c1 ea 02             	shr    $0x2,%edx
  106c16:	09 d0                	or     %edx,%eax
  106c18:	89 c3                	mov    %eax,%ebx
  106c1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106c1d:	d1 e8                	shr    %eax
  106c1f:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106c22:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106c25:	d1 ea                	shr    %edx
  106c27:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106c2a:	c1 ea 02             	shr    $0x2,%edx
  106c2d:	09 d0                	or     %edx,%eax
  106c2f:	c1 e8 04             	shr    $0x4,%eax
  106c32:	09 d8                	or     %ebx,%eax
  106c34:	c1 e8 08             	shr    $0x8,%eax
  106c37:	89 cb                	mov    %ecx,%ebx
  106c39:	09 c3                	or     %eax,%ebx
  106c3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106c3e:	d1 e8                	shr    %eax
  106c40:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106c43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106c46:	d1 ea                	shr    %edx
  106c48:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106c4b:	c1 ea 02             	shr    $0x2,%edx
  106c4e:	09 d0                	or     %edx,%eax
  106c50:	89 c1                	mov    %eax,%ecx
  106c52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106c55:	d1 e8                	shr    %eax
  106c57:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106c5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106c5d:	d1 ea                	shr    %edx
  106c5f:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106c62:	c1 ea 02             	shr    $0x2,%edx
  106c65:	09 d0                	or     %edx,%eax
  106c67:	c1 e8 04             	shr    $0x4,%eax
  106c6a:	09 c1                	or     %eax,%ecx
  106c6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106c6f:	d1 e8                	shr    %eax
  106c71:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106c74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106c77:	d1 ea                	shr    %edx
  106c79:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106c7c:	c1 ea 02             	shr    $0x2,%edx
  106c7f:	09 d0                	or     %edx,%eax
  106c81:	89 c6                	mov    %eax,%esi
  106c83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106c86:	d1 e8                	shr    %eax
  106c88:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106c8b:	89 c2                	mov    %eax,%edx
  106c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106c90:	d1 e8                	shr    %eax
  106c92:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106c95:	c1 e8 02             	shr    $0x2,%eax
  106c98:	09 d0                	or     %edx,%eax
  106c9a:	c1 e8 04             	shr    $0x4,%eax
  106c9d:	09 f0                	or     %esi,%eax
  106c9f:	c1 e8 08             	shr    $0x8,%eax
  106ca2:	09 c8                	or     %ecx,%eax
  106ca4:	c1 e8 10             	shr    $0x10,%eax
  106ca7:	09 d8                	or     %ebx,%eax
  106ca9:	d1 e8                	shr    %eax
  106cab:	23 45 e4             	and    -0x1c(%ebp),%eax
  106cae:	85 c0                	test   %eax,%eax
  106cb0:	0f 84 e2 00 00 00    	je     106d98 <buddy_alloc_pages+0x6be>
  106cb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106cb9:	d1 e8                	shr    %eax
  106cbb:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106cbe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106cc1:	d1 ea                	shr    %edx
  106cc3:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106cc6:	c1 ea 02             	shr    $0x2,%edx
  106cc9:	09 d0                	or     %edx,%eax
  106ccb:	89 c1                	mov    %eax,%ecx
  106ccd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106cd0:	d1 e8                	shr    %eax
  106cd2:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106cd5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106cd8:	d1 ea                	shr    %edx
  106cda:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106cdd:	c1 ea 02             	shr    $0x2,%edx
  106ce0:	09 d0                	or     %edx,%eax
  106ce2:	c1 e8 04             	shr    $0x4,%eax
  106ce5:	09 c1                	or     %eax,%ecx
  106ce7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106cea:	d1 e8                	shr    %eax
  106cec:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106cef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106cf2:	d1 ea                	shr    %edx
  106cf4:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106cf7:	c1 ea 02             	shr    $0x2,%edx
  106cfa:	09 d0                	or     %edx,%eax
  106cfc:	89 c3                	mov    %eax,%ebx
  106cfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106d01:	d1 e8                	shr    %eax
  106d03:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106d06:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106d09:	d1 ea                	shr    %edx
  106d0b:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106d0e:	c1 ea 02             	shr    $0x2,%edx
  106d11:	09 d0                	or     %edx,%eax
  106d13:	c1 e8 04             	shr    $0x4,%eax
  106d16:	09 d8                	or     %ebx,%eax
  106d18:	c1 e8 08             	shr    $0x8,%eax
  106d1b:	89 cb                	mov    %ecx,%ebx
  106d1d:	09 c3                	or     %eax,%ebx
  106d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106d22:	d1 e8                	shr    %eax
  106d24:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106d27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106d2a:	d1 ea                	shr    %edx
  106d2c:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106d2f:	c1 ea 02             	shr    $0x2,%edx
  106d32:	09 d0                	or     %edx,%eax
  106d34:	89 c1                	mov    %eax,%ecx
  106d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106d39:	d1 e8                	shr    %eax
  106d3b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106d3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106d41:	d1 ea                	shr    %edx
  106d43:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106d46:	c1 ea 02             	shr    $0x2,%edx
  106d49:	09 d0                	or     %edx,%eax
  106d4b:	c1 e8 04             	shr    $0x4,%eax
  106d4e:	09 c1                	or     %eax,%ecx
  106d50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106d53:	d1 e8                	shr    %eax
  106d55:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106d58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106d5b:	d1 ea                	shr    %edx
  106d5d:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106d60:	c1 ea 02             	shr    $0x2,%edx
  106d63:	09 d0                	or     %edx,%eax
  106d65:	89 c6                	mov    %eax,%esi
  106d67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106d6a:	d1 e8                	shr    %eax
  106d6c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106d6f:	89 c2                	mov    %eax,%edx
  106d71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106d74:	d1 e8                	shr    %eax
  106d76:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106d79:	c1 e8 02             	shr    $0x2,%eax
  106d7c:	09 d0                	or     %edx,%eax
  106d7e:	c1 e8 04             	shr    $0x4,%eax
  106d81:	09 f0                	or     %esi,%eax
  106d83:	c1 e8 08             	shr    $0x8,%eax
  106d86:	09 c8                	or     %ecx,%eax
  106d88:	c1 e8 10             	shr    $0x10,%eax
  106d8b:	09 d8                	or     %ebx,%eax
  106d8d:	d1 e8                	shr    %eax
  106d8f:	f7 d0                	not    %eax
  106d91:	23 45 e4             	and    -0x1c(%ebp),%eax
  106d94:	89 c6                	mov    %eax,%esi
  106d96:	eb 03                	jmp    106d9b <buddy_alloc_pages+0x6c1>
  106d98:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  106d9b:	89 f8                	mov    %edi,%eax
  106d9d:	ba 00 00 00 00       	mov    $0x0,%edx
  106da2:	f7 f6                	div    %esi
  106da4:	0f af 85 74 ff ff ff 	imul   -0x8c(%ebp),%eax
  106dab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            size_t end = BUDDY_END(block);
  106dae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106db1:	d1 e8                	shr    %eax
  106db3:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106db6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106db9:	d1 ea                	shr    %edx
  106dbb:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106dbe:	c1 ea 02             	shr    $0x2,%edx
  106dc1:	09 d0                	or     %edx,%eax
  106dc3:	89 c1                	mov    %eax,%ecx
  106dc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106dc8:	d1 e8                	shr    %eax
  106dca:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106dcd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106dd0:	d1 ea                	shr    %edx
  106dd2:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106dd5:	c1 ea 02             	shr    $0x2,%edx
  106dd8:	09 d0                	or     %edx,%eax
  106dda:	c1 e8 04             	shr    $0x4,%eax
  106ddd:	09 c1                	or     %eax,%ecx
  106ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106de2:	d1 e8                	shr    %eax
  106de4:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106de7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106dea:	d1 ea                	shr    %edx
  106dec:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106def:	c1 ea 02             	shr    $0x2,%edx
  106df2:	09 d0                	or     %edx,%eax
  106df4:	89 c3                	mov    %eax,%ebx
  106df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106df9:	d1 e8                	shr    %eax
  106dfb:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106dfe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106e01:	d1 ea                	shr    %edx
  106e03:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106e06:	c1 ea 02             	shr    $0x2,%edx
  106e09:	09 d0                	or     %edx,%eax
  106e0b:	c1 e8 04             	shr    $0x4,%eax
  106e0e:	09 d8                	or     %ebx,%eax
  106e10:	c1 e8 08             	shr    $0x8,%eax
  106e13:	09 c1                	or     %eax,%ecx
  106e15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106e18:	d1 e8                	shr    %eax
  106e1a:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106e1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106e20:	d1 ea                	shr    %edx
  106e22:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106e25:	c1 ea 02             	shr    $0x2,%edx
  106e28:	09 d0                	or     %edx,%eax
  106e2a:	89 c3                	mov    %eax,%ebx
  106e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106e2f:	d1 e8                	shr    %eax
  106e31:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106e34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106e37:	d1 ea                	shr    %edx
  106e39:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106e3c:	c1 ea 02             	shr    $0x2,%edx
  106e3f:	09 d0                	or     %edx,%eax
  106e41:	c1 e8 04             	shr    $0x4,%eax
  106e44:	09 c3                	or     %eax,%ebx
  106e46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106e49:	d1 e8                	shr    %eax
  106e4b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106e4e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106e51:	d1 ea                	shr    %edx
  106e53:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106e56:	c1 ea 02             	shr    $0x2,%edx
  106e59:	09 d0                	or     %edx,%eax
  106e5b:	89 c6                	mov    %eax,%esi
  106e5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106e60:	d1 e8                	shr    %eax
  106e62:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106e65:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106e68:	d1 ea                	shr    %edx
  106e6a:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106e6d:	c1 ea 02             	shr    $0x2,%edx
  106e70:	09 d0                	or     %edx,%eax
  106e72:	c1 e8 04             	shr    $0x4,%eax
  106e75:	09 f0                	or     %esi,%eax
  106e77:	c1 e8 08             	shr    $0x8,%eax
  106e7a:	09 d8                	or     %ebx,%eax
  106e7c:	c1 e8 10             	shr    $0x10,%eax
  106e7f:	09 c8                	or     %ecx,%eax
  106e81:	d1 e8                	shr    %eax
  106e83:	23 45 e4             	and    -0x1c(%ebp),%eax
  106e86:	40                   	inc    %eax
  106e87:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  106e8d:	8b 3d 10 3f 12 00    	mov    0x123f10,%edi
  106e93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106e96:	d1 e8                	shr    %eax
  106e98:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106e9b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106e9e:	d1 ea                	shr    %edx
  106ea0:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106ea3:	c1 ea 02             	shr    $0x2,%edx
  106ea6:	09 d0                	or     %edx,%eax
  106ea8:	89 c1                	mov    %eax,%ecx
  106eaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106ead:	d1 e8                	shr    %eax
  106eaf:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106eb2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106eb5:	d1 ea                	shr    %edx
  106eb7:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106eba:	c1 ea 02             	shr    $0x2,%edx
  106ebd:	09 d0                	or     %edx,%eax
  106ebf:	c1 e8 04             	shr    $0x4,%eax
  106ec2:	09 c1                	or     %eax,%ecx
  106ec4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106ec7:	d1 e8                	shr    %eax
  106ec9:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106ecc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106ecf:	d1 ea                	shr    %edx
  106ed1:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106ed4:	c1 ea 02             	shr    $0x2,%edx
  106ed7:	09 d0                	or     %edx,%eax
  106ed9:	89 c3                	mov    %eax,%ebx
  106edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106ede:	d1 e8                	shr    %eax
  106ee0:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106ee3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106ee6:	d1 ea                	shr    %edx
  106ee8:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106eeb:	c1 ea 02             	shr    $0x2,%edx
  106eee:	09 d0                	or     %edx,%eax
  106ef0:	c1 e8 04             	shr    $0x4,%eax
  106ef3:	09 d8                	or     %ebx,%eax
  106ef5:	c1 e8 08             	shr    $0x8,%eax
  106ef8:	89 cb                	mov    %ecx,%ebx
  106efa:	09 c3                	or     %eax,%ebx
  106efc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106eff:	d1 e8                	shr    %eax
  106f01:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106f04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106f07:	d1 ea                	shr    %edx
  106f09:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106f0c:	c1 ea 02             	shr    $0x2,%edx
  106f0f:	09 d0                	or     %edx,%eax
  106f11:	89 c1                	mov    %eax,%ecx
  106f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106f16:	d1 e8                	shr    %eax
  106f18:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106f1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106f1e:	d1 ea                	shr    %edx
  106f20:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106f23:	c1 ea 02             	shr    $0x2,%edx
  106f26:	09 d0                	or     %edx,%eax
  106f28:	c1 e8 04             	shr    $0x4,%eax
  106f2b:	09 c1                	or     %eax,%ecx
  106f2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106f30:	d1 e8                	shr    %eax
  106f32:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106f35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106f38:	d1 ea                	shr    %edx
  106f3a:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106f3d:	c1 ea 02             	shr    $0x2,%edx
  106f40:	09 d0                	or     %edx,%eax
  106f42:	89 c6                	mov    %eax,%esi
  106f44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106f47:	d1 e8                	shr    %eax
  106f49:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106f4c:	89 c2                	mov    %eax,%edx
  106f4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106f51:	d1 e8                	shr    %eax
  106f53:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106f56:	c1 e8 02             	shr    $0x2,%eax
  106f59:	09 d0                	or     %edx,%eax
  106f5b:	c1 e8 04             	shr    $0x4,%eax
  106f5e:	09 f0                	or     %esi,%eax
  106f60:	c1 e8 08             	shr    $0x8,%eax
  106f63:	09 c8                	or     %ecx,%eax
  106f65:	c1 e8 10             	shr    $0x10,%eax
  106f68:	09 d8                	or     %ebx,%eax
  106f6a:	d1 e8                	shr    %eax
  106f6c:	23 45 e4             	and    -0x1c(%ebp),%eax
  106f6f:	85 c0                	test   %eax,%eax
  106f71:	0f 84 e2 00 00 00    	je     107059 <buddy_alloc_pages+0x97f>
  106f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106f7a:	d1 e8                	shr    %eax
  106f7c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106f7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106f82:	d1 ea                	shr    %edx
  106f84:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106f87:	c1 ea 02             	shr    $0x2,%edx
  106f8a:	09 d0                	or     %edx,%eax
  106f8c:	89 c1                	mov    %eax,%ecx
  106f8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106f91:	d1 e8                	shr    %eax
  106f93:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106f96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106f99:	d1 ea                	shr    %edx
  106f9b:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106f9e:	c1 ea 02             	shr    $0x2,%edx
  106fa1:	09 d0                	or     %edx,%eax
  106fa3:	c1 e8 04             	shr    $0x4,%eax
  106fa6:	09 c1                	or     %eax,%ecx
  106fa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106fab:	d1 e8                	shr    %eax
  106fad:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106fb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106fb3:	d1 ea                	shr    %edx
  106fb5:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106fb8:	c1 ea 02             	shr    $0x2,%edx
  106fbb:	09 d0                	or     %edx,%eax
  106fbd:	89 c3                	mov    %eax,%ebx
  106fbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106fc2:	d1 e8                	shr    %eax
  106fc4:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106fc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106fca:	d1 ea                	shr    %edx
  106fcc:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106fcf:	c1 ea 02             	shr    $0x2,%edx
  106fd2:	09 d0                	or     %edx,%eax
  106fd4:	c1 e8 04             	shr    $0x4,%eax
  106fd7:	09 d8                	or     %ebx,%eax
  106fd9:	c1 e8 08             	shr    $0x8,%eax
  106fdc:	89 cb                	mov    %ecx,%ebx
  106fde:	09 c3                	or     %eax,%ebx
  106fe0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106fe3:	d1 e8                	shr    %eax
  106fe5:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106fe8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106feb:	d1 ea                	shr    %edx
  106fed:	0b 55 e4             	or     -0x1c(%ebp),%edx
  106ff0:	c1 ea 02             	shr    $0x2,%edx
  106ff3:	09 d0                	or     %edx,%eax
  106ff5:	89 c1                	mov    %eax,%ecx
  106ff7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106ffa:	d1 e8                	shr    %eax
  106ffc:	0b 45 e4             	or     -0x1c(%ebp),%eax
  106fff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107002:	d1 ea                	shr    %edx
  107004:	0b 55 e4             	or     -0x1c(%ebp),%edx
  107007:	c1 ea 02             	shr    $0x2,%edx
  10700a:	09 d0                	or     %edx,%eax
  10700c:	c1 e8 04             	shr    $0x4,%eax
  10700f:	09 c1                	or     %eax,%ecx
  107011:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107014:	d1 e8                	shr    %eax
  107016:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107019:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10701c:	d1 ea                	shr    %edx
  10701e:	0b 55 e4             	or     -0x1c(%ebp),%edx
  107021:	c1 ea 02             	shr    $0x2,%edx
  107024:	09 d0                	or     %edx,%eax
  107026:	89 c6                	mov    %eax,%esi
  107028:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10702b:	d1 e8                	shr    %eax
  10702d:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107030:	89 c2                	mov    %eax,%edx
  107032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107035:	d1 e8                	shr    %eax
  107037:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10703a:	c1 e8 02             	shr    $0x2,%eax
  10703d:	09 d0                	or     %edx,%eax
  10703f:	c1 e8 04             	shr    $0x4,%eax
  107042:	09 f0                	or     %esi,%eax
  107044:	c1 e8 08             	shr    $0x8,%eax
  107047:	09 c8                	or     %ecx,%eax
  107049:	c1 e8 10             	shr    $0x10,%eax
  10704c:	09 d8                	or     %ebx,%eax
  10704e:	d1 e8                	shr    %eax
  107050:	f7 d0                	not    %eax
  107052:	23 45 e4             	and    -0x1c(%ebp),%eax
  107055:	89 c6                	mov    %eax,%esi
  107057:	eb 03                	jmp    10705c <buddy_alloc_pages+0x982>
  107059:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  10705c:	89 f8                	mov    %edi,%eax
  10705e:	ba 00 00 00 00       	mov    $0x0,%edx
  107063:	f7 f6                	div    %esi
  107065:	0f af 85 74 ff ff ff 	imul   -0x8c(%ebp),%eax
  10706c:	89 45 d0             	mov    %eax,-0x30(%ebp)
            size_t mid = (begin+end)>>1;
  10706f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  107072:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107075:	01 d0                	add    %edx,%eax
  107077:	d1 e8                	shr    %eax
  107079:	89 45 cc             	mov    %eax,-0x34(%ebp)
            list_del(&(buddy_alloc[begin].page_link));
  10707c:	8b 0d 24 3f 12 00    	mov    0x123f24,%ecx
  107082:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  107085:	89 d0                	mov    %edx,%eax
  107087:	c1 e0 02             	shl    $0x2,%eax
  10708a:	01 d0                	add    %edx,%eax
  10708c:	c1 e0 02             	shl    $0x2,%eax
  10708f:	01 c8                	add    %ecx,%eax
  107091:	83 c0 0c             	add    $0xc,%eax
  107094:	89 45 8c             	mov    %eax,-0x74(%ebp)
    __list_del(listelm->prev, listelm->next);
  107097:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10709a:	8b 40 04             	mov    0x4(%eax),%eax
  10709d:	8b 55 8c             	mov    -0x74(%ebp),%edx
  1070a0:	8b 12                	mov    (%edx),%edx
  1070a2:	89 55 88             	mov    %edx,-0x78(%ebp)
  1070a5:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next;
  1070a8:	8b 45 88             	mov    -0x78(%ebp),%eax
  1070ab:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1070ae:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1070b1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  1070b4:	8b 55 88             	mov    -0x78(%ebp),%edx
  1070b7:	89 10                	mov    %edx,(%eax)
}
  1070b9:	90                   	nop
}
  1070ba:	90                   	nop
            buddy_alloc[begin].property >>= 1;
  1070bb:	8b 0d 24 3f 12 00    	mov    0x123f24,%ecx
  1070c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1070c4:	89 d0                	mov    %edx,%eax
  1070c6:	c1 e0 02             	shl    $0x2,%eax
  1070c9:	01 d0                	add    %edx,%eax
  1070cb:	c1 e0 02             	shl    $0x2,%eax
  1070ce:	01 c8                	add    %ecx,%eax
  1070d0:	8b 48 08             	mov    0x8(%eax),%ecx
  1070d3:	8b 1d 24 3f 12 00    	mov    0x123f24,%ebx
  1070d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1070dc:	89 d0                	mov    %edx,%eax
  1070de:	c1 e0 02             	shl    $0x2,%eax
  1070e1:	01 d0                	add    %edx,%eax
  1070e3:	c1 e0 02             	shl    $0x2,%eax
  1070e6:	01 d8                	add    %ebx,%eax
  1070e8:	d1 e9                	shr    %ecx
  1070ea:	89 ca                	mov    %ecx,%edx
  1070ec:	89 50 08             	mov    %edx,0x8(%eax)
            buddy_alloc[mid].property = buddy_alloc[begin].property;
  1070ef:	8b 0d 24 3f 12 00    	mov    0x123f24,%ecx
  1070f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1070f8:	89 d0                	mov    %edx,%eax
  1070fa:	c1 e0 02             	shl    $0x2,%eax
  1070fd:	01 d0                	add    %edx,%eax
  1070ff:	c1 e0 02             	shl    $0x2,%eax
  107102:	01 c1                	add    %eax,%ecx
  107104:	8b 1d 24 3f 12 00    	mov    0x123f24,%ebx
  10710a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10710d:	89 d0                	mov    %edx,%eax
  10710f:	c1 e0 02             	shl    $0x2,%eax
  107112:	01 d0                	add    %edx,%eax
  107114:	c1 e0 02             	shl    $0x2,%eax
  107117:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  10711a:	8b 41 08             	mov    0x8(%ecx),%eax
  10711d:	89 42 08             	mov    %eax,0x8(%edx)
            buddy_segment[left] = buddy_segment[block]>>1;
  107120:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  107125:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107128:	c1 e2 02             	shl    $0x2,%edx
  10712b:	01 d0                	add    %edx,%eax
  10712d:	8b 10                	mov    (%eax),%edx
  10712f:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  107134:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  107137:	c1 e1 02             	shl    $0x2,%ecx
  10713a:	01 c8                	add    %ecx,%eax
  10713c:	d1 ea                	shr    %edx
  10713e:	89 10                	mov    %edx,(%eax)
            buddy_segment[right] = buddy_segment[block]>>1;
  107140:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  107145:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107148:	c1 e2 02             	shl    $0x2,%edx
  10714b:	01 d0                	add    %edx,%eax
  10714d:	8b 10                	mov    (%eax),%edx
  10714f:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  107154:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  107157:	c1 e1 02             	shl    $0x2,%ecx
  10715a:	01 c8                	add    %ecx,%eax
  10715c:	d1 ea                	shr    %edx
  10715e:	89 10                	mov    %edx,(%eax)
            list_add(&free_list, &(buddy_alloc[begin].page_link));
  107160:	8b 0d 24 3f 12 00    	mov    0x123f24,%ecx
  107166:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  107169:	89 d0                	mov    %edx,%eax
  10716b:	c1 e0 02             	shl    $0x2,%eax
  10716e:	01 d0                	add    %edx,%eax
  107170:	c1 e0 02             	shl    $0x2,%eax
  107173:	01 c8                	add    %ecx,%eax
  107175:	83 c0 0c             	add    $0xc,%eax
  107178:	c7 45 a8 38 3f 12 00 	movl   $0x123f38,-0x58(%ebp)
  10717f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  107182:	8b 45 a8             	mov    -0x58(%ebp),%eax
  107185:	89 45 a0             	mov    %eax,-0x60(%ebp)
  107188:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10718b:	89 45 9c             	mov    %eax,-0x64(%ebp)
    __list_add(elm, listelm, listelm->next);
  10718e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  107191:	8b 40 04             	mov    0x4(%eax),%eax
  107194:	8b 55 9c             	mov    -0x64(%ebp),%edx
  107197:	89 55 98             	mov    %edx,-0x68(%ebp)
  10719a:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10719d:	89 55 94             	mov    %edx,-0x6c(%ebp)
  1071a0:	89 45 90             	mov    %eax,-0x70(%ebp)
    prev->next = next->prev = elm;
  1071a3:	8b 45 90             	mov    -0x70(%ebp),%eax
  1071a6:	8b 55 98             	mov    -0x68(%ebp),%edx
  1071a9:	89 10                	mov    %edx,(%eax)
  1071ab:	8b 45 90             	mov    -0x70(%ebp),%eax
  1071ae:	8b 10                	mov    (%eax),%edx
  1071b0:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1071b3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1071b6:	8b 45 98             	mov    -0x68(%ebp),%eax
  1071b9:	8b 55 90             	mov    -0x70(%ebp),%edx
  1071bc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1071bf:	8b 45 98             	mov    -0x68(%ebp),%eax
  1071c2:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1071c5:	89 10                	mov    %edx,(%eax)
}
  1071c7:	90                   	nop
}
  1071c8:	90                   	nop
}
  1071c9:	90                   	nop
            list_add(&free_list, &(buddy_alloc[mid].page_link));
  1071ca:	8b 0d 24 3f 12 00    	mov    0x123f24,%ecx
  1071d0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1071d3:	89 d0                	mov    %edx,%eax
  1071d5:	c1 e0 02             	shl    $0x2,%eax
  1071d8:	01 d0                	add    %edx,%eax
  1071da:	c1 e0 02             	shl    $0x2,%eax
  1071dd:	01 c8                	add    %ecx,%eax
  1071df:	83 c0 0c             	add    $0xc,%eax
  1071e2:	c7 45 c4 38 3f 12 00 	movl   $0x123f38,-0x3c(%ebp)
  1071e9:	89 45 c0             	mov    %eax,-0x40(%ebp)
  1071ec:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1071ef:	89 45 bc             	mov    %eax,-0x44(%ebp)
  1071f2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1071f5:	89 45 b8             	mov    %eax,-0x48(%ebp)
    __list_add(elm, listelm, listelm->next);
  1071f8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1071fb:	8b 40 04             	mov    0x4(%eax),%eax
  1071fe:	8b 55 b8             	mov    -0x48(%ebp),%edx
  107201:	89 55 b4             	mov    %edx,-0x4c(%ebp)
  107204:	8b 55 bc             	mov    -0x44(%ebp),%edx
  107207:	89 55 b0             	mov    %edx,-0x50(%ebp)
  10720a:	89 45 ac             	mov    %eax,-0x54(%ebp)
    prev->next = next->prev = elm;
  10720d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  107210:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  107213:	89 10                	mov    %edx,(%eax)
  107215:	8b 45 ac             	mov    -0x54(%ebp),%eax
  107218:	8b 10                	mov    (%eax),%edx
  10721a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10721d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  107220:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  107223:	8b 55 ac             	mov    -0x54(%ebp),%edx
  107226:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  107229:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10722c:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10722f:	89 10                	mov    %edx,(%eax)
}
  107231:	90                   	nop
}
  107232:	90                   	nop
}
  107233:	90                   	nop
            block = left;
  107234:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107237:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10723a:	e9 98 00 00 00       	jmp    1072d7 <buddy_alloc_pages+0xbfd>
        } else if (length & buddy_segment[left]) {  // Find in left (optimize)
  10723f:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  107244:	8b 55 dc             	mov    -0x24(%ebp),%edx
  107247:	c1 e2 02             	shl    $0x2,%edx
  10724a:	01 d0                	add    %edx,%eax
  10724c:	8b 00                	mov    (%eax),%eax
  10724e:	23 45 e0             	and    -0x20(%ebp),%eax
  107251:	85 c0                	test   %eax,%eax
  107253:	74 08                	je     10725d <buddy_alloc_pages+0xb83>
            block = left;
  107255:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107258:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10725b:	eb 7a                	jmp    1072d7 <buddy_alloc_pages+0xbfd>
        } else if (length & buddy_segment[right]) { // Find in right (optimize)
  10725d:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  107262:	8b 55 d8             	mov    -0x28(%ebp),%edx
  107265:	c1 e2 02             	shl    $0x2,%edx
  107268:	01 d0                	add    %edx,%eax
  10726a:	8b 00                	mov    (%eax),%eax
  10726c:	23 45 e0             	and    -0x20(%ebp),%eax
  10726f:	85 c0                	test   %eax,%eax
  107271:	74 08                	je     10727b <buddy_alloc_pages+0xba1>
            block = right;
  107273:	8b 45 d8             	mov    -0x28(%ebp),%eax
  107276:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  107279:	eb 5c                	jmp    1072d7 <buddy_alloc_pages+0xbfd>
        } else if (length <= buddy_segment[left]) { // Find in left
  10727b:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  107280:	8b 55 dc             	mov    -0x24(%ebp),%edx
  107283:	c1 e2 02             	shl    $0x2,%edx
  107286:	01 d0                	add    %edx,%eax
  107288:	8b 00                	mov    (%eax),%eax
  10728a:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  10728d:	77 08                	ja     107297 <buddy_alloc_pages+0xbbd>
            block = left;
  10728f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107292:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  107295:	eb 40                	jmp    1072d7 <buddy_alloc_pages+0xbfd>
        } else if (length <= buddy_segment[right]) {// Find in right
  107297:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  10729c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10729f:	c1 e2 02             	shl    $0x2,%edx
  1072a2:	01 d0                	add    %edx,%eax
  1072a4:	8b 00                	mov    (%eax),%eax
  1072a6:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1072a9:	77 08                	ja     1072b3 <buddy_alloc_pages+0xbd9>
            block = right;
  1072ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1072ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1072b1:	eb 24                	jmp    1072d7 <buddy_alloc_pages+0xbfd>
        } else {                                    // Shouldn't be here
            assert(0);
  1072b3:	c7 44 24 0c 21 b3 10 	movl   $0x10b321,0xc(%esp)
  1072ba:	00 
  1072bb:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  1072c2:	00 
  1072c3:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
  1072ca:	00 
  1072cb:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  1072d2:	e8 5f 91 ff ff       	call   100436 <__panic>
    while (length <= buddy_segment[block] && length < BUDDY_LENGTH(block)) {
  1072d7:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  1072dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1072df:	c1 e2 02             	shl    $0x2,%edx
  1072e2:	01 d0                	add    %edx,%eax
  1072e4:	8b 00                	mov    (%eax),%eax
  1072e6:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1072e9:	0f 87 d6 01 00 00    	ja     1074c5 <buddy_alloc_pages+0xdeb>
  1072ef:	a1 10 3f 12 00       	mov    0x123f10,%eax
  1072f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1072f7:	d1 ea                	shr    %edx
  1072f9:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1072fc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1072ff:	d1 e9                	shr    %ecx
  107301:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  107304:	c1 e9 02             	shr    $0x2,%ecx
  107307:	89 d3                	mov    %edx,%ebx
  107309:	09 cb                	or     %ecx,%ebx
  10730b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10730e:	d1 ea                	shr    %edx
  107310:	0b 55 e4             	or     -0x1c(%ebp),%edx
  107313:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  107316:	d1 e9                	shr    %ecx
  107318:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  10731b:	c1 e9 02             	shr    $0x2,%ecx
  10731e:	09 ca                	or     %ecx,%edx
  107320:	c1 ea 04             	shr    $0x4,%edx
  107323:	09 d3                	or     %edx,%ebx
  107325:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107328:	d1 ea                	shr    %edx
  10732a:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10732d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  107330:	d1 e9                	shr    %ecx
  107332:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  107335:	c1 e9 02             	shr    $0x2,%ecx
  107338:	89 d6                	mov    %edx,%esi
  10733a:	09 ce                	or     %ecx,%esi
  10733c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10733f:	d1 ea                	shr    %edx
  107341:	0b 55 e4             	or     -0x1c(%ebp),%edx
  107344:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  107347:	d1 e9                	shr    %ecx
  107349:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  10734c:	c1 e9 02             	shr    $0x2,%ecx
  10734f:	09 ca                	or     %ecx,%edx
  107351:	c1 ea 04             	shr    $0x4,%edx
  107354:	09 f2                	or     %esi,%edx
  107356:	c1 ea 08             	shr    $0x8,%edx
  107359:	09 d3                	or     %edx,%ebx
  10735b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10735e:	d1 ea                	shr    %edx
  107360:	0b 55 e4             	or     -0x1c(%ebp),%edx
  107363:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  107366:	d1 e9                	shr    %ecx
  107368:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  10736b:	c1 e9 02             	shr    $0x2,%ecx
  10736e:	89 d6                	mov    %edx,%esi
  107370:	09 ce                	or     %ecx,%esi
  107372:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107375:	d1 ea                	shr    %edx
  107377:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10737a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  10737d:	d1 e9                	shr    %ecx
  10737f:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  107382:	c1 e9 02             	shr    $0x2,%ecx
  107385:	09 ca                	or     %ecx,%edx
  107387:	c1 ea 04             	shr    $0x4,%edx
  10738a:	09 d6                	or     %edx,%esi
  10738c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10738f:	d1 ea                	shr    %edx
  107391:	0b 55 e4             	or     -0x1c(%ebp),%edx
  107394:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  107397:	d1 e9                	shr    %ecx
  107399:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  10739c:	c1 e9 02             	shr    $0x2,%ecx
  10739f:	89 d7                	mov    %edx,%edi
  1073a1:	09 cf                	or     %ecx,%edi
  1073a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1073a6:	d1 ea                	shr    %edx
  1073a8:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1073ab:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1073ae:	d1 e9                	shr    %ecx
  1073b0:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  1073b3:	c1 e9 02             	shr    $0x2,%ecx
  1073b6:	09 ca                	or     %ecx,%edx
  1073b8:	c1 ea 04             	shr    $0x4,%edx
  1073bb:	09 fa                	or     %edi,%edx
  1073bd:	c1 ea 08             	shr    $0x8,%edx
  1073c0:	09 f2                	or     %esi,%edx
  1073c2:	c1 ea 10             	shr    $0x10,%edx
  1073c5:	09 da                	or     %ebx,%edx
  1073c7:	d1 ea                	shr    %edx
  1073c9:	23 55 e4             	and    -0x1c(%ebp),%edx
  1073cc:	85 d2                	test   %edx,%edx
  1073ce:	0f 84 de 00 00 00    	je     1074b2 <buddy_alloc_pages+0xdd8>
  1073d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1073d7:	d1 ea                	shr    %edx
  1073d9:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1073dc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1073df:	d1 e9                	shr    %ecx
  1073e1:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  1073e4:	c1 e9 02             	shr    $0x2,%ecx
  1073e7:	89 d3                	mov    %edx,%ebx
  1073e9:	09 cb                	or     %ecx,%ebx
  1073eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1073ee:	d1 ea                	shr    %edx
  1073f0:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1073f3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  1073f6:	d1 e9                	shr    %ecx
  1073f8:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  1073fb:	c1 e9 02             	shr    $0x2,%ecx
  1073fe:	09 ca                	or     %ecx,%edx
  107400:	c1 ea 04             	shr    $0x4,%edx
  107403:	09 d3                	or     %edx,%ebx
  107405:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107408:	d1 ea                	shr    %edx
  10740a:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10740d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  107410:	d1 e9                	shr    %ecx
  107412:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  107415:	c1 e9 02             	shr    $0x2,%ecx
  107418:	89 d6                	mov    %edx,%esi
  10741a:	09 ce                	or     %ecx,%esi
  10741c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10741f:	d1 ea                	shr    %edx
  107421:	0b 55 e4             	or     -0x1c(%ebp),%edx
  107424:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  107427:	d1 e9                	shr    %ecx
  107429:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  10742c:	c1 e9 02             	shr    $0x2,%ecx
  10742f:	09 ca                	or     %ecx,%edx
  107431:	c1 ea 04             	shr    $0x4,%edx
  107434:	09 f2                	or     %esi,%edx
  107436:	c1 ea 08             	shr    $0x8,%edx
  107439:	09 d3                	or     %edx,%ebx
  10743b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10743e:	d1 ea                	shr    %edx
  107440:	0b 55 e4             	or     -0x1c(%ebp),%edx
  107443:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  107446:	d1 e9                	shr    %ecx
  107448:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  10744b:	c1 e9 02             	shr    $0x2,%ecx
  10744e:	89 d6                	mov    %edx,%esi
  107450:	09 ce                	or     %ecx,%esi
  107452:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107455:	d1 ea                	shr    %edx
  107457:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10745a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  10745d:	d1 e9                	shr    %ecx
  10745f:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  107462:	c1 e9 02             	shr    $0x2,%ecx
  107465:	09 ca                	or     %ecx,%edx
  107467:	c1 ea 04             	shr    $0x4,%edx
  10746a:	09 d6                	or     %edx,%esi
  10746c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10746f:	d1 ea                	shr    %edx
  107471:	0b 55 e4             	or     -0x1c(%ebp),%edx
  107474:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  107477:	d1 e9                	shr    %ecx
  107479:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  10747c:	c1 e9 02             	shr    $0x2,%ecx
  10747f:	89 d7                	mov    %edx,%edi
  107481:	09 cf                	or     %ecx,%edi
  107483:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107486:	d1 ea                	shr    %edx
  107488:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10748b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  10748e:	d1 e9                	shr    %ecx
  107490:	0b 4d e4             	or     -0x1c(%ebp),%ecx
  107493:	c1 e9 02             	shr    $0x2,%ecx
  107496:	09 ca                	or     %ecx,%edx
  107498:	c1 ea 04             	shr    $0x4,%edx
  10749b:	09 fa                	or     %edi,%edx
  10749d:	c1 ea 08             	shr    $0x8,%edx
  1074a0:	09 f2                	or     %esi,%edx
  1074a2:	c1 ea 10             	shr    $0x10,%edx
  1074a5:	09 da                	or     %ebx,%edx
  1074a7:	d1 ea                	shr    %edx
  1074a9:	f7 d2                	not    %edx
  1074ab:	89 d7                	mov    %edx,%edi
  1074ad:	23 7d e4             	and    -0x1c(%ebp),%edi
  1074b0:	eb 03                	jmp    1074b5 <buddy_alloc_pages+0xddb>
  1074b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  1074b5:	ba 00 00 00 00       	mov    $0x0,%edx
  1074ba:	f7 f7                	div    %edi
  1074bc:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1074bf:	0f 82 1f f4 ff ff    	jb     1068e4 <buddy_alloc_pages+0x20a>
        }
    }
    // Allocate
    if (length > buddy_segment[block])
  1074c5:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  1074ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1074cd:	c1 e2 02             	shl    $0x2,%edx
  1074d0:	01 d0                	add    %edx,%eax
  1074d2:	8b 00                	mov    (%eax),%eax
  1074d4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  1074d7:	76 0a                	jbe    1074e3 <buddy_alloc_pages+0xe09>
        return NULL;
  1074d9:	b8 00 00 00 00       	mov    $0x0,%eax
  1074de:	e9 8c 03 00 00       	jmp    10786f <buddy_alloc_pages+0x1195>
    page = &(buddy_alloc[BUDDY_BEGIN(block)]);
  1074e3:	a1 24 3f 12 00       	mov    0x123f24,%eax
  1074e8:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  1074ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1074f1:	d1 e8                	shr    %eax
  1074f3:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1074f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1074f9:	d1 ea                	shr    %edx
  1074fb:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1074fe:	c1 ea 02             	shr    $0x2,%edx
  107501:	09 d0                	or     %edx,%eax
  107503:	89 c1                	mov    %eax,%ecx
  107505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107508:	d1 e8                	shr    %eax
  10750a:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10750d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107510:	d1 ea                	shr    %edx
  107512:	0b 55 e4             	or     -0x1c(%ebp),%edx
  107515:	c1 ea 02             	shr    $0x2,%edx
  107518:	09 d0                	or     %edx,%eax
  10751a:	c1 e8 04             	shr    $0x4,%eax
  10751d:	09 c1                	or     %eax,%ecx
  10751f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107522:	d1 e8                	shr    %eax
  107524:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107527:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10752a:	d1 ea                	shr    %edx
  10752c:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10752f:	c1 ea 02             	shr    $0x2,%edx
  107532:	09 d0                	or     %edx,%eax
  107534:	89 c3                	mov    %eax,%ebx
  107536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107539:	d1 e8                	shr    %eax
  10753b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10753e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107541:	d1 ea                	shr    %edx
  107543:	0b 55 e4             	or     -0x1c(%ebp),%edx
  107546:	c1 ea 02             	shr    $0x2,%edx
  107549:	09 d0                	or     %edx,%eax
  10754b:	c1 e8 04             	shr    $0x4,%eax
  10754e:	09 d8                	or     %ebx,%eax
  107550:	c1 e8 08             	shr    $0x8,%eax
  107553:	09 c1                	or     %eax,%ecx
  107555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107558:	d1 e8                	shr    %eax
  10755a:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10755d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107560:	d1 ea                	shr    %edx
  107562:	0b 55 e4             	or     -0x1c(%ebp),%edx
  107565:	c1 ea 02             	shr    $0x2,%edx
  107568:	09 d0                	or     %edx,%eax
  10756a:	89 c3                	mov    %eax,%ebx
  10756c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10756f:	d1 e8                	shr    %eax
  107571:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107574:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107577:	d1 ea                	shr    %edx
  107579:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10757c:	c1 ea 02             	shr    $0x2,%edx
  10757f:	09 d0                	or     %edx,%eax
  107581:	c1 e8 04             	shr    $0x4,%eax
  107584:	09 c3                	or     %eax,%ebx
  107586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107589:	d1 e8                	shr    %eax
  10758b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10758e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107591:	d1 ea                	shr    %edx
  107593:	0b 55 e4             	or     -0x1c(%ebp),%edx
  107596:	c1 ea 02             	shr    $0x2,%edx
  107599:	09 d0                	or     %edx,%eax
  10759b:	89 c6                	mov    %eax,%esi
  10759d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1075a0:	d1 e8                	shr    %eax
  1075a2:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1075a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1075a8:	d1 ea                	shr    %edx
  1075aa:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1075ad:	c1 ea 02             	shr    $0x2,%edx
  1075b0:	09 d0                	or     %edx,%eax
  1075b2:	c1 e8 04             	shr    $0x4,%eax
  1075b5:	09 f0                	or     %esi,%eax
  1075b7:	c1 e8 08             	shr    $0x8,%eax
  1075ba:	09 d8                	or     %ebx,%eax
  1075bc:	c1 e8 10             	shr    $0x10,%eax
  1075bf:	09 c8                	or     %ecx,%eax
  1075c1:	d1 e8                	shr    %eax
  1075c3:	23 45 e4             	and    -0x1c(%ebp),%eax
  1075c6:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  1075cc:	8b 3d 10 3f 12 00    	mov    0x123f10,%edi
  1075d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1075d5:	d1 e8                	shr    %eax
  1075d7:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1075da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1075dd:	d1 ea                	shr    %edx
  1075df:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1075e2:	c1 ea 02             	shr    $0x2,%edx
  1075e5:	09 d0                	or     %edx,%eax
  1075e7:	89 c1                	mov    %eax,%ecx
  1075e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1075ec:	d1 e8                	shr    %eax
  1075ee:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1075f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1075f4:	d1 ea                	shr    %edx
  1075f6:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1075f9:	c1 ea 02             	shr    $0x2,%edx
  1075fc:	09 d0                	or     %edx,%eax
  1075fe:	c1 e8 04             	shr    $0x4,%eax
  107601:	09 c1                	or     %eax,%ecx
  107603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107606:	d1 e8                	shr    %eax
  107608:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10760b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10760e:	d1 ea                	shr    %edx
  107610:	0b 55 e4             	or     -0x1c(%ebp),%edx
  107613:	c1 ea 02             	shr    $0x2,%edx
  107616:	09 d0                	or     %edx,%eax
  107618:	89 c3                	mov    %eax,%ebx
  10761a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10761d:	d1 e8                	shr    %eax
  10761f:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107622:	89 c2                	mov    %eax,%edx
  107624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107627:	d1 e8                	shr    %eax
  107629:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10762c:	c1 e8 02             	shr    $0x2,%eax
  10762f:	09 d0                	or     %edx,%eax
  107631:	c1 e8 04             	shr    $0x4,%eax
  107634:	09 d8                	or     %ebx,%eax
  107636:	c1 e8 08             	shr    $0x8,%eax
  107639:	89 ce                	mov    %ecx,%esi
  10763b:	09 c6                	or     %eax,%esi
  10763d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107640:	d1 e8                	shr    %eax
  107642:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107645:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107648:	d1 ea                	shr    %edx
  10764a:	0b 55 e4             	or     -0x1c(%ebp),%edx
  10764d:	c1 ea 02             	shr    $0x2,%edx
  107650:	09 d0                	or     %edx,%eax
  107652:	89 c1                	mov    %eax,%ecx
  107654:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107657:	d1 e8                	shr    %eax
  107659:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10765c:	89 c2                	mov    %eax,%edx
  10765e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107661:	d1 e8                	shr    %eax
  107663:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107666:	c1 e8 02             	shr    $0x2,%eax
  107669:	09 d0                	or     %edx,%eax
  10766b:	c1 e8 04             	shr    $0x4,%eax
  10766e:	89 cb                	mov    %ecx,%ebx
  107670:	09 c3                	or     %eax,%ebx
  107672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107675:	d1 e8                	shr    %eax
  107677:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10767a:	89 c2                	mov    %eax,%edx
  10767c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10767f:	d1 e8                	shr    %eax
  107681:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107684:	c1 e8 02             	shr    $0x2,%eax
  107687:	89 d1                	mov    %edx,%ecx
  107689:	09 c1                	or     %eax,%ecx
  10768b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10768e:	d1 e8                	shr    %eax
  107690:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107693:	89 c2                	mov    %eax,%edx
  107695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107698:	d1 e8                	shr    %eax
  10769a:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10769d:	c1 e8 02             	shr    $0x2,%eax
  1076a0:	09 d0                	or     %edx,%eax
  1076a2:	c1 e8 04             	shr    $0x4,%eax
  1076a5:	09 c8                	or     %ecx,%eax
  1076a7:	c1 e8 08             	shr    $0x8,%eax
  1076aa:	09 d8                	or     %ebx,%eax
  1076ac:	c1 e8 10             	shr    $0x10,%eax
  1076af:	09 f0                	or     %esi,%eax
  1076b1:	d1 e8                	shr    %eax
  1076b3:	23 45 e4             	and    -0x1c(%ebp),%eax
  1076b6:	85 c0                	test   %eax,%eax
  1076b8:	0f 84 ea 00 00 00    	je     1077a8 <buddy_alloc_pages+0x10ce>
  1076be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1076c1:	d1 e8                	shr    %eax
  1076c3:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1076c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1076c9:	d1 ea                	shr    %edx
  1076cb:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1076ce:	c1 ea 02             	shr    $0x2,%edx
  1076d1:	09 d0                	or     %edx,%eax
  1076d3:	89 c1                	mov    %eax,%ecx
  1076d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1076d8:	d1 e8                	shr    %eax
  1076da:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1076dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1076e0:	d1 ea                	shr    %edx
  1076e2:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1076e5:	c1 ea 02             	shr    $0x2,%edx
  1076e8:	09 d0                	or     %edx,%eax
  1076ea:	c1 e8 04             	shr    $0x4,%eax
  1076ed:	09 c1                	or     %eax,%ecx
  1076ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1076f2:	d1 e8                	shr    %eax
  1076f4:	0b 45 e4             	or     -0x1c(%ebp),%eax
  1076f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1076fa:	d1 ea                	shr    %edx
  1076fc:	0b 55 e4             	or     -0x1c(%ebp),%edx
  1076ff:	c1 ea 02             	shr    $0x2,%edx
  107702:	09 d0                	or     %edx,%eax
  107704:	89 c3                	mov    %eax,%ebx
  107706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107709:	d1 e8                	shr    %eax
  10770b:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10770e:	89 c2                	mov    %eax,%edx
  107710:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107713:	d1 e8                	shr    %eax
  107715:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107718:	c1 e8 02             	shr    $0x2,%eax
  10771b:	09 d0                	or     %edx,%eax
  10771d:	c1 e8 04             	shr    $0x4,%eax
  107720:	09 d8                	or     %ebx,%eax
  107722:	c1 e8 08             	shr    $0x8,%eax
  107725:	89 ce                	mov    %ecx,%esi
  107727:	09 c6                	or     %eax,%esi
  107729:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10772c:	d1 e8                	shr    %eax
  10772e:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107731:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107734:	d1 ea                	shr    %edx
  107736:	0b 55 e4             	or     -0x1c(%ebp),%edx
  107739:	c1 ea 02             	shr    $0x2,%edx
  10773c:	09 d0                	or     %edx,%eax
  10773e:	89 c1                	mov    %eax,%ecx
  107740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107743:	d1 e8                	shr    %eax
  107745:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107748:	89 c2                	mov    %eax,%edx
  10774a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10774d:	d1 e8                	shr    %eax
  10774f:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107752:	c1 e8 02             	shr    $0x2,%eax
  107755:	09 d0                	or     %edx,%eax
  107757:	c1 e8 04             	shr    $0x4,%eax
  10775a:	89 cb                	mov    %ecx,%ebx
  10775c:	09 c3                	or     %eax,%ebx
  10775e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107761:	d1 e8                	shr    %eax
  107763:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107766:	89 c2                	mov    %eax,%edx
  107768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10776b:	d1 e8                	shr    %eax
  10776d:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107770:	c1 e8 02             	shr    $0x2,%eax
  107773:	89 d1                	mov    %edx,%ecx
  107775:	09 c1                	or     %eax,%ecx
  107777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10777a:	d1 e8                	shr    %eax
  10777c:	0b 45 e4             	or     -0x1c(%ebp),%eax
  10777f:	89 c2                	mov    %eax,%edx
  107781:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107784:	d1 e8                	shr    %eax
  107786:	0b 45 e4             	or     -0x1c(%ebp),%eax
  107789:	c1 e8 02             	shr    $0x2,%eax
  10778c:	09 d0                	or     %edx,%eax
  10778e:	c1 e8 04             	shr    $0x4,%eax
  107791:	09 c8                	or     %ecx,%eax
  107793:	c1 e8 08             	shr    $0x8,%eax
  107796:	09 d8                	or     %ebx,%eax
  107798:	c1 e8 10             	shr    $0x10,%eax
  10779b:	09 f0                	or     %esi,%eax
  10779d:	d1 e8                	shr    %eax
  10779f:	f7 d0                	not    %eax
  1077a1:	23 45 e4             	and    -0x1c(%ebp),%eax
  1077a4:	89 c6                	mov    %eax,%esi
  1077a6:	eb 03                	jmp    1077ab <buddy_alloc_pages+0x10d1>
  1077a8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  1077ab:	89 f8                	mov    %edi,%eax
  1077ad:	ba 00 00 00 00       	mov    $0x0,%edx
  1077b2:	f7 f6                	div    %esi
  1077b4:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  1077ba:	0f af d0             	imul   %eax,%edx
  1077bd:	89 d0                	mov    %edx,%eax
  1077bf:	c1 e0 02             	shl    $0x2,%eax
  1077c2:	01 d0                	add    %edx,%eax
  1077c4:	c1 e0 02             	shl    $0x2,%eax
  1077c7:	03 85 74 ff ff ff    	add    -0x8c(%ebp),%eax
  1077cd:	89 45 c8             	mov    %eax,-0x38(%ebp)
    list_del(&(page->page_link));
  1077d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1077d3:	83 c0 0c             	add    $0xc,%eax
  1077d6:	89 45 80             	mov    %eax,-0x80(%ebp)
    __list_del(listelm->prev, listelm->next);
  1077d9:	8b 45 80             	mov    -0x80(%ebp),%eax
  1077dc:	8b 40 04             	mov    0x4(%eax),%eax
  1077df:	8b 55 80             	mov    -0x80(%ebp),%edx
  1077e2:	8b 12                	mov    (%edx),%edx
  1077e4:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  1077ea:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
    prev->next = next;
  1077f0:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  1077f6:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  1077fc:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1077ff:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  107805:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  10780b:	89 10                	mov    %edx,(%eax)
}
  10780d:	90                   	nop
}
  10780e:	90                   	nop
    buddy_segment[block] = 0;
  10780f:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  107814:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  107817:	c1 e2 02             	shl    $0x2,%edx
  10781a:	01 d0                	add    %edx,%eax
  10781c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    nr_free -= length;
  107822:	a1 40 3f 12 00       	mov    0x123f40,%eax
  107827:	2b 45 e0             	sub    -0x20(%ebp),%eax
  10782a:	a3 40 3f 12 00       	mov    %eax,0x123f40
    // Update buddy segment
    while (block != BUDDY_ROOT) {
  10782f:	eb 35                	jmp    107866 <buddy_alloc_pages+0x118c>
        block = BUDDY_PARENT(block);
  107831:	d1 6d e4             	shrl   -0x1c(%ebp)
        buddy_segment[block] = buddy_segment[BUDDY_LEFT(block)] | buddy_segment[BUDDY_RIGHT(block)];
  107834:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  107839:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10783c:	c1 e2 03             	shl    $0x3,%edx
  10783f:	01 d0                	add    %edx,%eax
  107841:	8b 08                	mov    (%eax),%ecx
  107843:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  107848:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10784b:	c1 e2 03             	shl    $0x3,%edx
  10784e:	83 c2 04             	add    $0x4,%edx
  107851:	01 d0                	add    %edx,%eax
  107853:	8b 10                	mov    (%eax),%edx
  107855:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  10785a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  10785d:	c1 e3 02             	shl    $0x2,%ebx
  107860:	01 d8                	add    %ebx,%eax
  107862:	09 ca                	or     %ecx,%edx
  107864:	89 10                	mov    %edx,(%eax)
    while (block != BUDDY_ROOT) {
  107866:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  10786a:	75 c5                	jne    107831 <buddy_alloc_pages+0x1157>
    }
    return page;
  10786c:	8b 45 c8             	mov    -0x38(%ebp),%eax
}
  10786f:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  107875:	5b                   	pop    %ebx
  107876:	5e                   	pop    %esi
  107877:	5f                   	pop    %edi
  107878:	5d                   	pop    %ebp
  107879:	c3                   	ret    

0010787a <buddy_free_pages>:

static void
buddy_free_pages(struct Page *base, size_t n) {
  10787a:	f3 0f 1e fb          	endbr32 
  10787e:	55                   	push   %ebp
  10787f:	89 e5                	mov    %esp,%ebp
  107881:	57                   	push   %edi
  107882:	56                   	push   %esi
  107883:	53                   	push   %ebx
  107884:	81 ec ac 00 00 00    	sub    $0xac,%esp
    assert(n > 0);
  10788a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10788e:	75 24                	jne    1078b4 <buddy_free_pages+0x3a>
  107890:	c7 44 24 0c 0b b3 10 	movl   $0x10b30b,0xc(%esp)
  107897:	00 
  107898:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  10789f:	00 
  1078a0:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
  1078a7:	00 
  1078a8:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  1078af:	e8 82 8b ff ff       	call   100436 <__panic>
    struct Page *p = base;
  1078b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1078b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    size_t length = UINT32_ROUND_UP(n);
  1078ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1078bd:	d1 e8                	shr    %eax
  1078bf:	0b 45 0c             	or     0xc(%ebp),%eax
  1078c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1078c5:	d1 ea                	shr    %edx
  1078c7:	0b 55 0c             	or     0xc(%ebp),%edx
  1078ca:	c1 ea 02             	shr    $0x2,%edx
  1078cd:	09 d0                	or     %edx,%eax
  1078cf:	89 c1                	mov    %eax,%ecx
  1078d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1078d4:	d1 e8                	shr    %eax
  1078d6:	0b 45 0c             	or     0xc(%ebp),%eax
  1078d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1078dc:	d1 ea                	shr    %edx
  1078de:	0b 55 0c             	or     0xc(%ebp),%edx
  1078e1:	c1 ea 02             	shr    $0x2,%edx
  1078e4:	09 d0                	or     %edx,%eax
  1078e6:	c1 e8 04             	shr    $0x4,%eax
  1078e9:	09 c1                	or     %eax,%ecx
  1078eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1078ee:	d1 e8                	shr    %eax
  1078f0:	0b 45 0c             	or     0xc(%ebp),%eax
  1078f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1078f6:	d1 ea                	shr    %edx
  1078f8:	0b 55 0c             	or     0xc(%ebp),%edx
  1078fb:	c1 ea 02             	shr    $0x2,%edx
  1078fe:	09 d0                	or     %edx,%eax
  107900:	89 c3                	mov    %eax,%ebx
  107902:	8b 45 0c             	mov    0xc(%ebp),%eax
  107905:	d1 e8                	shr    %eax
  107907:	0b 45 0c             	or     0xc(%ebp),%eax
  10790a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10790d:	d1 ea                	shr    %edx
  10790f:	0b 55 0c             	or     0xc(%ebp),%edx
  107912:	c1 ea 02             	shr    $0x2,%edx
  107915:	09 d0                	or     %edx,%eax
  107917:	c1 e8 04             	shr    $0x4,%eax
  10791a:	09 d8                	or     %ebx,%eax
  10791c:	c1 e8 08             	shr    $0x8,%eax
  10791f:	09 c1                	or     %eax,%ecx
  107921:	8b 45 0c             	mov    0xc(%ebp),%eax
  107924:	d1 e8                	shr    %eax
  107926:	0b 45 0c             	or     0xc(%ebp),%eax
  107929:	8b 55 0c             	mov    0xc(%ebp),%edx
  10792c:	d1 ea                	shr    %edx
  10792e:	0b 55 0c             	or     0xc(%ebp),%edx
  107931:	c1 ea 02             	shr    $0x2,%edx
  107934:	09 d0                	or     %edx,%eax
  107936:	89 c3                	mov    %eax,%ebx
  107938:	8b 45 0c             	mov    0xc(%ebp),%eax
  10793b:	d1 e8                	shr    %eax
  10793d:	0b 45 0c             	or     0xc(%ebp),%eax
  107940:	8b 55 0c             	mov    0xc(%ebp),%edx
  107943:	d1 ea                	shr    %edx
  107945:	0b 55 0c             	or     0xc(%ebp),%edx
  107948:	c1 ea 02             	shr    $0x2,%edx
  10794b:	09 d0                	or     %edx,%eax
  10794d:	c1 e8 04             	shr    $0x4,%eax
  107950:	09 c3                	or     %eax,%ebx
  107952:	8b 45 0c             	mov    0xc(%ebp),%eax
  107955:	d1 e8                	shr    %eax
  107957:	0b 45 0c             	or     0xc(%ebp),%eax
  10795a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10795d:	d1 ea                	shr    %edx
  10795f:	0b 55 0c             	or     0xc(%ebp),%edx
  107962:	c1 ea 02             	shr    $0x2,%edx
  107965:	09 d0                	or     %edx,%eax
  107967:	89 c6                	mov    %eax,%esi
  107969:	8b 45 0c             	mov    0xc(%ebp),%eax
  10796c:	d1 e8                	shr    %eax
  10796e:	0b 45 0c             	or     0xc(%ebp),%eax
  107971:	8b 55 0c             	mov    0xc(%ebp),%edx
  107974:	d1 ea                	shr    %edx
  107976:	0b 55 0c             	or     0xc(%ebp),%edx
  107979:	c1 ea 02             	shr    $0x2,%edx
  10797c:	09 d0                	or     %edx,%eax
  10797e:	c1 e8 04             	shr    $0x4,%eax
  107981:	09 f0                	or     %esi,%eax
  107983:	c1 e8 08             	shr    $0x8,%eax
  107986:	09 d8                	or     %ebx,%eax
  107988:	c1 e8 10             	shr    $0x10,%eax
  10798b:	09 c8                	or     %ecx,%eax
  10798d:	d1 e8                	shr    %eax
  10798f:	23 45 0c             	and    0xc(%ebp),%eax
  107992:	85 c0                	test   %eax,%eax
  107994:	0f 84 de 00 00 00    	je     107a78 <buddy_free_pages+0x1fe>
  10799a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10799d:	d1 e8                	shr    %eax
  10799f:	0b 45 0c             	or     0xc(%ebp),%eax
  1079a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1079a5:	d1 ea                	shr    %edx
  1079a7:	0b 55 0c             	or     0xc(%ebp),%edx
  1079aa:	c1 ea 02             	shr    $0x2,%edx
  1079ad:	09 d0                	or     %edx,%eax
  1079af:	89 c1                	mov    %eax,%ecx
  1079b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1079b4:	d1 e8                	shr    %eax
  1079b6:	0b 45 0c             	or     0xc(%ebp),%eax
  1079b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1079bc:	d1 ea                	shr    %edx
  1079be:	0b 55 0c             	or     0xc(%ebp),%edx
  1079c1:	c1 ea 02             	shr    $0x2,%edx
  1079c4:	09 d0                	or     %edx,%eax
  1079c6:	c1 e8 04             	shr    $0x4,%eax
  1079c9:	09 c1                	or     %eax,%ecx
  1079cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1079ce:	d1 e8                	shr    %eax
  1079d0:	0b 45 0c             	or     0xc(%ebp),%eax
  1079d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1079d6:	d1 ea                	shr    %edx
  1079d8:	0b 55 0c             	or     0xc(%ebp),%edx
  1079db:	c1 ea 02             	shr    $0x2,%edx
  1079de:	09 d0                	or     %edx,%eax
  1079e0:	89 c3                	mov    %eax,%ebx
  1079e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1079e5:	d1 e8                	shr    %eax
  1079e7:	0b 45 0c             	or     0xc(%ebp),%eax
  1079ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  1079ed:	d1 ea                	shr    %edx
  1079ef:	0b 55 0c             	or     0xc(%ebp),%edx
  1079f2:	c1 ea 02             	shr    $0x2,%edx
  1079f5:	09 d0                	or     %edx,%eax
  1079f7:	c1 e8 04             	shr    $0x4,%eax
  1079fa:	09 d8                	or     %ebx,%eax
  1079fc:	c1 e8 08             	shr    $0x8,%eax
  1079ff:	09 c1                	or     %eax,%ecx
  107a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  107a04:	d1 e8                	shr    %eax
  107a06:	0b 45 0c             	or     0xc(%ebp),%eax
  107a09:	8b 55 0c             	mov    0xc(%ebp),%edx
  107a0c:	d1 ea                	shr    %edx
  107a0e:	0b 55 0c             	or     0xc(%ebp),%edx
  107a11:	c1 ea 02             	shr    $0x2,%edx
  107a14:	09 d0                	or     %edx,%eax
  107a16:	89 c3                	mov    %eax,%ebx
  107a18:	8b 45 0c             	mov    0xc(%ebp),%eax
  107a1b:	d1 e8                	shr    %eax
  107a1d:	0b 45 0c             	or     0xc(%ebp),%eax
  107a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  107a23:	d1 ea                	shr    %edx
  107a25:	0b 55 0c             	or     0xc(%ebp),%edx
  107a28:	c1 ea 02             	shr    $0x2,%edx
  107a2b:	09 d0                	or     %edx,%eax
  107a2d:	c1 e8 04             	shr    $0x4,%eax
  107a30:	09 c3                	or     %eax,%ebx
  107a32:	8b 45 0c             	mov    0xc(%ebp),%eax
  107a35:	d1 e8                	shr    %eax
  107a37:	0b 45 0c             	or     0xc(%ebp),%eax
  107a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  107a3d:	d1 ea                	shr    %edx
  107a3f:	0b 55 0c             	or     0xc(%ebp),%edx
  107a42:	c1 ea 02             	shr    $0x2,%edx
  107a45:	09 d0                	or     %edx,%eax
  107a47:	89 c6                	mov    %eax,%esi
  107a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  107a4c:	d1 e8                	shr    %eax
  107a4e:	0b 45 0c             	or     0xc(%ebp),%eax
  107a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  107a54:	d1 ea                	shr    %edx
  107a56:	0b 55 0c             	or     0xc(%ebp),%edx
  107a59:	c1 ea 02             	shr    $0x2,%edx
  107a5c:	09 d0                	or     %edx,%eax
  107a5e:	c1 e8 04             	shr    $0x4,%eax
  107a61:	09 f0                	or     %esi,%eax
  107a63:	c1 e8 08             	shr    $0x8,%eax
  107a66:	09 d8                	or     %ebx,%eax
  107a68:	c1 e8 10             	shr    $0x10,%eax
  107a6b:	09 c8                	or     %ecx,%eax
  107a6d:	d1 e8                	shr    %eax
  107a6f:	f7 d0                	not    %eax
  107a71:	23 45 0c             	and    0xc(%ebp),%eax
  107a74:	01 c0                	add    %eax,%eax
  107a76:	eb 03                	jmp    107a7b <buddy_free_pages+0x201>
  107a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  107a7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    // Find buddy id 
    size_t begin = (base-buddy_alloc);
  107a7e:	a1 24 3f 12 00       	mov    0x123f24,%eax
  107a83:	8b 55 08             	mov    0x8(%ebp),%edx
  107a86:	29 c2                	sub    %eax,%edx
  107a88:	89 d0                	mov    %edx,%eax
  107a8a:	c1 f8 02             	sar    $0x2,%eax
  107a8d:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
  107a93:	89 45 d8             	mov    %eax,-0x28(%ebp)
    size_t end = begin + length;
  107a96:	8b 55 d8             	mov    -0x28(%ebp),%edx
  107a99:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107a9c:	01 d0                	add    %edx,%eax
  107a9e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    size_t block = BUDDY_BLOCK(begin, end);
  107aa1:	a1 10 3f 12 00       	mov    0x123f10,%eax
  107aa6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  107aa9:	89 d7                	mov    %edx,%edi
  107aab:	2b 7d d8             	sub    -0x28(%ebp),%edi
  107aae:	ba 00 00 00 00       	mov    $0x0,%edx
  107ab3:	f7 f7                	div    %edi
  107ab5:	89 c1                	mov    %eax,%ecx
  107ab7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  107aba:	2b 45 d8             	sub    -0x28(%ebp),%eax
  107abd:	89 c7                	mov    %eax,%edi
  107abf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  107ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  107ac7:	f7 f7                	div    %edi
  107ac9:	01 c8                	add    %ecx,%eax
  107acb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    // Release block
    for (; p != base + n; p ++) {
  107ace:	eb 71                	jmp    107b41 <buddy_free_pages+0x2c7>
        assert(!PageReserved(p));
  107ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107ad3:	83 c0 04             	add    $0x4,%eax
  107ad6:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  107add:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  107ae0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  107ae3:	8b 55 c0             	mov    -0x40(%ebp),%edx
  107ae6:	0f a3 10             	bt     %edx,(%eax)
  107ae9:	19 c0                	sbb    %eax,%eax
  107aeb:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  107aee:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  107af2:	0f 95 c0             	setne  %al
  107af5:	0f b6 c0             	movzbl %al,%eax
  107af8:	85 c0                	test   %eax,%eax
  107afa:	74 24                	je     107b20 <buddy_free_pages+0x2a6>
  107afc:	c7 44 24 0c 23 b3 10 	movl   $0x10b323,0xc(%esp)
  107b03:	00 
  107b04:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  107b0b:	00 
  107b0c:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
  107b13:	00 
  107b14:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  107b1b:	e8 16 89 ff ff       	call   100436 <__panic>
        p->flags = 0;
  107b20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107b23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  107b2a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  107b31:	00 
  107b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  107b35:	89 04 24             	mov    %eax,(%esp)
  107b38:	e8 5e dd ff ff       	call   10589b <set_page_ref>
    for (; p != base + n; p ++) {
  107b3d:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
  107b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  107b44:	89 d0                	mov    %edx,%eax
  107b46:	c1 e0 02             	shl    $0x2,%eax
  107b49:	01 d0                	add    %edx,%eax
  107b4b:	c1 e0 02             	shl    $0x2,%eax
  107b4e:	89 c2                	mov    %eax,%edx
  107b50:	8b 45 08             	mov    0x8(%ebp),%eax
  107b53:	01 d0                	add    %edx,%eax
  107b55:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  107b58:	0f 85 72 ff ff ff    	jne    107ad0 <buddy_free_pages+0x256>
    }
    base->property = length;
  107b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  107b61:	8b 55 dc             	mov    -0x24(%ebp),%edx
  107b64:	89 50 08             	mov    %edx,0x8(%eax)
    list_add(&(free_list), &(base->page_link));
  107b67:	8b 45 08             	mov    0x8(%ebp),%eax
  107b6a:	83 c0 0c             	add    $0xc,%eax
  107b6d:	c7 45 b4 38 3f 12 00 	movl   $0x123f38,-0x4c(%ebp)
  107b74:	89 45 b0             	mov    %eax,-0x50(%ebp)
  107b77:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  107b7a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  107b7d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  107b80:	89 45 a8             	mov    %eax,-0x58(%ebp)
    __list_add(elm, listelm, listelm->next);
  107b83:	8b 45 ac             	mov    -0x54(%ebp),%eax
  107b86:	8b 40 04             	mov    0x4(%eax),%eax
  107b89:	8b 55 a8             	mov    -0x58(%ebp),%edx
  107b8c:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  107b8f:	8b 55 ac             	mov    -0x54(%ebp),%edx
  107b92:	89 55 a0             	mov    %edx,-0x60(%ebp)
  107b95:	89 45 9c             	mov    %eax,-0x64(%ebp)
    prev->next = next->prev = elm;
  107b98:	8b 45 9c             	mov    -0x64(%ebp),%eax
  107b9b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  107b9e:	89 10                	mov    %edx,(%eax)
  107ba0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  107ba3:	8b 10                	mov    (%eax),%edx
  107ba5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  107ba8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  107bab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  107bae:	8b 55 9c             	mov    -0x64(%ebp),%edx
  107bb1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  107bb4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  107bb7:	8b 55 a0             	mov    -0x60(%ebp),%edx
  107bba:	89 10                	mov    %edx,(%eax)
}
  107bbc:	90                   	nop
}
  107bbd:	90                   	nop
}
  107bbe:	90                   	nop
    nr_free += length;
  107bbf:	8b 15 40 3f 12 00    	mov    0x123f40,%edx
  107bc5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107bc8:	01 d0                	add    %edx,%eax
  107bca:	a3 40 3f 12 00       	mov    %eax,0x123f40
    buddy_segment[block] = length;
  107bcf:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  107bd4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  107bd7:	c1 e2 02             	shl    $0x2,%edx
  107bda:	01 c2                	add    %eax,%edx
  107bdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  107bdf:	89 02                	mov    %eax,(%edx)
    // Upadte & merge
    while (block != BUDDY_ROOT) {
  107be1:	e9 22 0b 00 00       	jmp    108708 <buddy_free_pages+0xe8e>
        block = BUDDY_PARENT(block);
  107be6:	d1 6d e0             	shrl   -0x20(%ebp)
        size_t left = BUDDY_LEFT(block);
  107be9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107bec:	01 c0                	add    %eax,%eax
  107bee:	89 45 d0             	mov    %eax,-0x30(%ebp)
        size_t right = BUDDY_RIGHT(block);
  107bf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  107bf4:	01 c0                	add    %eax,%eax
  107bf6:	40                   	inc    %eax
  107bf7:	89 45 cc             	mov    %eax,-0x34(%ebp)
        if (BUDDY_EMPTY(left) && BUDDY_EMPTY(right)) {  // Merge
  107bfa:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  107bff:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107c02:	c1 e2 02             	shl    $0x2,%edx
  107c05:	01 d0                	add    %edx,%eax
  107c07:	8b 00                	mov    (%eax),%eax
  107c09:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  107c0f:	8b 3d 10 3f 12 00    	mov    0x123f10,%edi
  107c15:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107c18:	d1 e8                	shr    %eax
  107c1a:	0b 45 d0             	or     -0x30(%ebp),%eax
  107c1d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107c20:	d1 ea                	shr    %edx
  107c22:	0b 55 d0             	or     -0x30(%ebp),%edx
  107c25:	c1 ea 02             	shr    $0x2,%edx
  107c28:	09 d0                	or     %edx,%eax
  107c2a:	89 c1                	mov    %eax,%ecx
  107c2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107c2f:	d1 e8                	shr    %eax
  107c31:	0b 45 d0             	or     -0x30(%ebp),%eax
  107c34:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107c37:	d1 ea                	shr    %edx
  107c39:	0b 55 d0             	or     -0x30(%ebp),%edx
  107c3c:	c1 ea 02             	shr    $0x2,%edx
  107c3f:	09 d0                	or     %edx,%eax
  107c41:	c1 e8 04             	shr    $0x4,%eax
  107c44:	09 c1                	or     %eax,%ecx
  107c46:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107c49:	d1 e8                	shr    %eax
  107c4b:	0b 45 d0             	or     -0x30(%ebp),%eax
  107c4e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107c51:	d1 ea                	shr    %edx
  107c53:	0b 55 d0             	or     -0x30(%ebp),%edx
  107c56:	c1 ea 02             	shr    $0x2,%edx
  107c59:	09 d0                	or     %edx,%eax
  107c5b:	89 c3                	mov    %eax,%ebx
  107c5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107c60:	d1 e8                	shr    %eax
  107c62:	0b 45 d0             	or     -0x30(%ebp),%eax
  107c65:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107c68:	d1 ea                	shr    %edx
  107c6a:	0b 55 d0             	or     -0x30(%ebp),%edx
  107c6d:	c1 ea 02             	shr    $0x2,%edx
  107c70:	09 d0                	or     %edx,%eax
  107c72:	c1 e8 04             	shr    $0x4,%eax
  107c75:	09 d8                	or     %ebx,%eax
  107c77:	c1 e8 08             	shr    $0x8,%eax
  107c7a:	89 cb                	mov    %ecx,%ebx
  107c7c:	09 c3                	or     %eax,%ebx
  107c7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107c81:	d1 e8                	shr    %eax
  107c83:	0b 45 d0             	or     -0x30(%ebp),%eax
  107c86:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107c89:	d1 ea                	shr    %edx
  107c8b:	0b 55 d0             	or     -0x30(%ebp),%edx
  107c8e:	c1 ea 02             	shr    $0x2,%edx
  107c91:	09 d0                	or     %edx,%eax
  107c93:	89 c1                	mov    %eax,%ecx
  107c95:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107c98:	d1 e8                	shr    %eax
  107c9a:	0b 45 d0             	or     -0x30(%ebp),%eax
  107c9d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107ca0:	d1 ea                	shr    %edx
  107ca2:	0b 55 d0             	or     -0x30(%ebp),%edx
  107ca5:	c1 ea 02             	shr    $0x2,%edx
  107ca8:	09 d0                	or     %edx,%eax
  107caa:	c1 e8 04             	shr    $0x4,%eax
  107cad:	09 c1                	or     %eax,%ecx
  107caf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107cb2:	d1 e8                	shr    %eax
  107cb4:	0b 45 d0             	or     -0x30(%ebp),%eax
  107cb7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107cba:	d1 ea                	shr    %edx
  107cbc:	0b 55 d0             	or     -0x30(%ebp),%edx
  107cbf:	c1 ea 02             	shr    $0x2,%edx
  107cc2:	09 d0                	or     %edx,%eax
  107cc4:	89 c6                	mov    %eax,%esi
  107cc6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107cc9:	d1 e8                	shr    %eax
  107ccb:	0b 45 d0             	or     -0x30(%ebp),%eax
  107cce:	89 c2                	mov    %eax,%edx
  107cd0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107cd3:	d1 e8                	shr    %eax
  107cd5:	0b 45 d0             	or     -0x30(%ebp),%eax
  107cd8:	c1 e8 02             	shr    $0x2,%eax
  107cdb:	09 d0                	or     %edx,%eax
  107cdd:	c1 e8 04             	shr    $0x4,%eax
  107ce0:	09 f0                	or     %esi,%eax
  107ce2:	c1 e8 08             	shr    $0x8,%eax
  107ce5:	09 c8                	or     %ecx,%eax
  107ce7:	c1 e8 10             	shr    $0x10,%eax
  107cea:	09 d8                	or     %ebx,%eax
  107cec:	d1 e8                	shr    %eax
  107cee:	23 45 d0             	and    -0x30(%ebp),%eax
  107cf1:	85 c0                	test   %eax,%eax
  107cf3:	0f 84 e2 00 00 00    	je     107ddb <buddy_free_pages+0x561>
  107cf9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107cfc:	d1 e8                	shr    %eax
  107cfe:	0b 45 d0             	or     -0x30(%ebp),%eax
  107d01:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107d04:	d1 ea                	shr    %edx
  107d06:	0b 55 d0             	or     -0x30(%ebp),%edx
  107d09:	c1 ea 02             	shr    $0x2,%edx
  107d0c:	09 d0                	or     %edx,%eax
  107d0e:	89 c1                	mov    %eax,%ecx
  107d10:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107d13:	d1 e8                	shr    %eax
  107d15:	0b 45 d0             	or     -0x30(%ebp),%eax
  107d18:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107d1b:	d1 ea                	shr    %edx
  107d1d:	0b 55 d0             	or     -0x30(%ebp),%edx
  107d20:	c1 ea 02             	shr    $0x2,%edx
  107d23:	09 d0                	or     %edx,%eax
  107d25:	c1 e8 04             	shr    $0x4,%eax
  107d28:	09 c1                	or     %eax,%ecx
  107d2a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107d2d:	d1 e8                	shr    %eax
  107d2f:	0b 45 d0             	or     -0x30(%ebp),%eax
  107d32:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107d35:	d1 ea                	shr    %edx
  107d37:	0b 55 d0             	or     -0x30(%ebp),%edx
  107d3a:	c1 ea 02             	shr    $0x2,%edx
  107d3d:	09 d0                	or     %edx,%eax
  107d3f:	89 c3                	mov    %eax,%ebx
  107d41:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107d44:	d1 e8                	shr    %eax
  107d46:	0b 45 d0             	or     -0x30(%ebp),%eax
  107d49:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107d4c:	d1 ea                	shr    %edx
  107d4e:	0b 55 d0             	or     -0x30(%ebp),%edx
  107d51:	c1 ea 02             	shr    $0x2,%edx
  107d54:	09 d0                	or     %edx,%eax
  107d56:	c1 e8 04             	shr    $0x4,%eax
  107d59:	09 d8                	or     %ebx,%eax
  107d5b:	c1 e8 08             	shr    $0x8,%eax
  107d5e:	89 cb                	mov    %ecx,%ebx
  107d60:	09 c3                	or     %eax,%ebx
  107d62:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107d65:	d1 e8                	shr    %eax
  107d67:	0b 45 d0             	or     -0x30(%ebp),%eax
  107d6a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107d6d:	d1 ea                	shr    %edx
  107d6f:	0b 55 d0             	or     -0x30(%ebp),%edx
  107d72:	c1 ea 02             	shr    $0x2,%edx
  107d75:	09 d0                	or     %edx,%eax
  107d77:	89 c1                	mov    %eax,%ecx
  107d79:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107d7c:	d1 e8                	shr    %eax
  107d7e:	0b 45 d0             	or     -0x30(%ebp),%eax
  107d81:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107d84:	d1 ea                	shr    %edx
  107d86:	0b 55 d0             	or     -0x30(%ebp),%edx
  107d89:	c1 ea 02             	shr    $0x2,%edx
  107d8c:	09 d0                	or     %edx,%eax
  107d8e:	c1 e8 04             	shr    $0x4,%eax
  107d91:	09 c1                	or     %eax,%ecx
  107d93:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107d96:	d1 e8                	shr    %eax
  107d98:	0b 45 d0             	or     -0x30(%ebp),%eax
  107d9b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107d9e:	d1 ea                	shr    %edx
  107da0:	0b 55 d0             	or     -0x30(%ebp),%edx
  107da3:	c1 ea 02             	shr    $0x2,%edx
  107da6:	09 d0                	or     %edx,%eax
  107da8:	89 c6                	mov    %eax,%esi
  107daa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107dad:	d1 e8                	shr    %eax
  107daf:	0b 45 d0             	or     -0x30(%ebp),%eax
  107db2:	89 c2                	mov    %eax,%edx
  107db4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107db7:	d1 e8                	shr    %eax
  107db9:	0b 45 d0             	or     -0x30(%ebp),%eax
  107dbc:	c1 e8 02             	shr    $0x2,%eax
  107dbf:	09 d0                	or     %edx,%eax
  107dc1:	c1 e8 04             	shr    $0x4,%eax
  107dc4:	09 f0                	or     %esi,%eax
  107dc6:	c1 e8 08             	shr    $0x8,%eax
  107dc9:	09 c8                	or     %ecx,%eax
  107dcb:	c1 e8 10             	shr    $0x10,%eax
  107dce:	09 d8                	or     %ebx,%eax
  107dd0:	d1 e8                	shr    %eax
  107dd2:	f7 d0                	not    %eax
  107dd4:	23 45 d0             	and    -0x30(%ebp),%eax
  107dd7:	89 c6                	mov    %eax,%esi
  107dd9:	eb 03                	jmp    107dde <buddy_free_pages+0x564>
  107ddb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  107dde:	89 f8                	mov    %edi,%eax
  107de0:	ba 00 00 00 00       	mov    $0x0,%edx
  107de5:	f7 f6                	div    %esi
  107de7:	39 85 64 ff ff ff    	cmp    %eax,-0x9c(%ebp)
  107ded:	0f 85 e3 08 00 00    	jne    1086d6 <buddy_free_pages+0xe5c>
  107df3:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  107df8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107dfb:	c1 e2 02             	shl    $0x2,%edx
  107dfe:	01 d0                	add    %edx,%eax
  107e00:	8b 00                	mov    (%eax),%eax
  107e02:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  107e08:	8b 3d 10 3f 12 00    	mov    0x123f10,%edi
  107e0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107e11:	d1 e8                	shr    %eax
  107e13:	0b 45 cc             	or     -0x34(%ebp),%eax
  107e16:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107e19:	d1 ea                	shr    %edx
  107e1b:	0b 55 cc             	or     -0x34(%ebp),%edx
  107e1e:	c1 ea 02             	shr    $0x2,%edx
  107e21:	09 d0                	or     %edx,%eax
  107e23:	89 c1                	mov    %eax,%ecx
  107e25:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107e28:	d1 e8                	shr    %eax
  107e2a:	0b 45 cc             	or     -0x34(%ebp),%eax
  107e2d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107e30:	d1 ea                	shr    %edx
  107e32:	0b 55 cc             	or     -0x34(%ebp),%edx
  107e35:	c1 ea 02             	shr    $0x2,%edx
  107e38:	09 d0                	or     %edx,%eax
  107e3a:	c1 e8 04             	shr    $0x4,%eax
  107e3d:	09 c1                	or     %eax,%ecx
  107e3f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107e42:	d1 e8                	shr    %eax
  107e44:	0b 45 cc             	or     -0x34(%ebp),%eax
  107e47:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107e4a:	d1 ea                	shr    %edx
  107e4c:	0b 55 cc             	or     -0x34(%ebp),%edx
  107e4f:	c1 ea 02             	shr    $0x2,%edx
  107e52:	09 d0                	or     %edx,%eax
  107e54:	89 c3                	mov    %eax,%ebx
  107e56:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107e59:	d1 e8                	shr    %eax
  107e5b:	0b 45 cc             	or     -0x34(%ebp),%eax
  107e5e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107e61:	d1 ea                	shr    %edx
  107e63:	0b 55 cc             	or     -0x34(%ebp),%edx
  107e66:	c1 ea 02             	shr    $0x2,%edx
  107e69:	09 d0                	or     %edx,%eax
  107e6b:	c1 e8 04             	shr    $0x4,%eax
  107e6e:	09 d8                	or     %ebx,%eax
  107e70:	c1 e8 08             	shr    $0x8,%eax
  107e73:	89 cb                	mov    %ecx,%ebx
  107e75:	09 c3                	or     %eax,%ebx
  107e77:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107e7a:	d1 e8                	shr    %eax
  107e7c:	0b 45 cc             	or     -0x34(%ebp),%eax
  107e7f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107e82:	d1 ea                	shr    %edx
  107e84:	0b 55 cc             	or     -0x34(%ebp),%edx
  107e87:	c1 ea 02             	shr    $0x2,%edx
  107e8a:	09 d0                	or     %edx,%eax
  107e8c:	89 c1                	mov    %eax,%ecx
  107e8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107e91:	d1 e8                	shr    %eax
  107e93:	0b 45 cc             	or     -0x34(%ebp),%eax
  107e96:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107e99:	d1 ea                	shr    %edx
  107e9b:	0b 55 cc             	or     -0x34(%ebp),%edx
  107e9e:	c1 ea 02             	shr    $0x2,%edx
  107ea1:	09 d0                	or     %edx,%eax
  107ea3:	c1 e8 04             	shr    $0x4,%eax
  107ea6:	09 c1                	or     %eax,%ecx
  107ea8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107eab:	d1 e8                	shr    %eax
  107ead:	0b 45 cc             	or     -0x34(%ebp),%eax
  107eb0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107eb3:	d1 ea                	shr    %edx
  107eb5:	0b 55 cc             	or     -0x34(%ebp),%edx
  107eb8:	c1 ea 02             	shr    $0x2,%edx
  107ebb:	09 d0                	or     %edx,%eax
  107ebd:	89 c6                	mov    %eax,%esi
  107ebf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107ec2:	d1 e8                	shr    %eax
  107ec4:	0b 45 cc             	or     -0x34(%ebp),%eax
  107ec7:	89 c2                	mov    %eax,%edx
  107ec9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107ecc:	d1 e8                	shr    %eax
  107ece:	0b 45 cc             	or     -0x34(%ebp),%eax
  107ed1:	c1 e8 02             	shr    $0x2,%eax
  107ed4:	09 d0                	or     %edx,%eax
  107ed6:	c1 e8 04             	shr    $0x4,%eax
  107ed9:	09 f0                	or     %esi,%eax
  107edb:	c1 e8 08             	shr    $0x8,%eax
  107ede:	09 c8                	or     %ecx,%eax
  107ee0:	c1 e8 10             	shr    $0x10,%eax
  107ee3:	09 d8                	or     %ebx,%eax
  107ee5:	d1 e8                	shr    %eax
  107ee7:	23 45 cc             	and    -0x34(%ebp),%eax
  107eea:	85 c0                	test   %eax,%eax
  107eec:	0f 84 e2 00 00 00    	je     107fd4 <buddy_free_pages+0x75a>
  107ef2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107ef5:	d1 e8                	shr    %eax
  107ef7:	0b 45 cc             	or     -0x34(%ebp),%eax
  107efa:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107efd:	d1 ea                	shr    %edx
  107eff:	0b 55 cc             	or     -0x34(%ebp),%edx
  107f02:	c1 ea 02             	shr    $0x2,%edx
  107f05:	09 d0                	or     %edx,%eax
  107f07:	89 c1                	mov    %eax,%ecx
  107f09:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107f0c:	d1 e8                	shr    %eax
  107f0e:	0b 45 cc             	or     -0x34(%ebp),%eax
  107f11:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107f14:	d1 ea                	shr    %edx
  107f16:	0b 55 cc             	or     -0x34(%ebp),%edx
  107f19:	c1 ea 02             	shr    $0x2,%edx
  107f1c:	09 d0                	or     %edx,%eax
  107f1e:	c1 e8 04             	shr    $0x4,%eax
  107f21:	09 c1                	or     %eax,%ecx
  107f23:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107f26:	d1 e8                	shr    %eax
  107f28:	0b 45 cc             	or     -0x34(%ebp),%eax
  107f2b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107f2e:	d1 ea                	shr    %edx
  107f30:	0b 55 cc             	or     -0x34(%ebp),%edx
  107f33:	c1 ea 02             	shr    $0x2,%edx
  107f36:	09 d0                	or     %edx,%eax
  107f38:	89 c3                	mov    %eax,%ebx
  107f3a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107f3d:	d1 e8                	shr    %eax
  107f3f:	0b 45 cc             	or     -0x34(%ebp),%eax
  107f42:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107f45:	d1 ea                	shr    %edx
  107f47:	0b 55 cc             	or     -0x34(%ebp),%edx
  107f4a:	c1 ea 02             	shr    $0x2,%edx
  107f4d:	09 d0                	or     %edx,%eax
  107f4f:	c1 e8 04             	shr    $0x4,%eax
  107f52:	09 d8                	or     %ebx,%eax
  107f54:	c1 e8 08             	shr    $0x8,%eax
  107f57:	89 cb                	mov    %ecx,%ebx
  107f59:	09 c3                	or     %eax,%ebx
  107f5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107f5e:	d1 e8                	shr    %eax
  107f60:	0b 45 cc             	or     -0x34(%ebp),%eax
  107f63:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107f66:	d1 ea                	shr    %edx
  107f68:	0b 55 cc             	or     -0x34(%ebp),%edx
  107f6b:	c1 ea 02             	shr    $0x2,%edx
  107f6e:	09 d0                	or     %edx,%eax
  107f70:	89 c1                	mov    %eax,%ecx
  107f72:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107f75:	d1 e8                	shr    %eax
  107f77:	0b 45 cc             	or     -0x34(%ebp),%eax
  107f7a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107f7d:	d1 ea                	shr    %edx
  107f7f:	0b 55 cc             	or     -0x34(%ebp),%edx
  107f82:	c1 ea 02             	shr    $0x2,%edx
  107f85:	09 d0                	or     %edx,%eax
  107f87:	c1 e8 04             	shr    $0x4,%eax
  107f8a:	09 c1                	or     %eax,%ecx
  107f8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107f8f:	d1 e8                	shr    %eax
  107f91:	0b 45 cc             	or     -0x34(%ebp),%eax
  107f94:	8b 55 cc             	mov    -0x34(%ebp),%edx
  107f97:	d1 ea                	shr    %edx
  107f99:	0b 55 cc             	or     -0x34(%ebp),%edx
  107f9c:	c1 ea 02             	shr    $0x2,%edx
  107f9f:	09 d0                	or     %edx,%eax
  107fa1:	89 c6                	mov    %eax,%esi
  107fa3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107fa6:	d1 e8                	shr    %eax
  107fa8:	0b 45 cc             	or     -0x34(%ebp),%eax
  107fab:	89 c2                	mov    %eax,%edx
  107fad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  107fb0:	d1 e8                	shr    %eax
  107fb2:	0b 45 cc             	or     -0x34(%ebp),%eax
  107fb5:	c1 e8 02             	shr    $0x2,%eax
  107fb8:	09 d0                	or     %edx,%eax
  107fba:	c1 e8 04             	shr    $0x4,%eax
  107fbd:	09 f0                	or     %esi,%eax
  107fbf:	c1 e8 08             	shr    $0x8,%eax
  107fc2:	09 c8                	or     %ecx,%eax
  107fc4:	c1 e8 10             	shr    $0x10,%eax
  107fc7:	09 d8                	or     %ebx,%eax
  107fc9:	d1 e8                	shr    %eax
  107fcb:	f7 d0                	not    %eax
  107fcd:	23 45 cc             	and    -0x34(%ebp),%eax
  107fd0:	89 c6                	mov    %eax,%esi
  107fd2:	eb 03                	jmp    107fd7 <buddy_free_pages+0x75d>
  107fd4:	8b 75 cc             	mov    -0x34(%ebp),%esi
  107fd7:	89 f8                	mov    %edi,%eax
  107fd9:	ba 00 00 00 00       	mov    $0x0,%edx
  107fde:	f7 f6                	div    %esi
  107fe0:	39 85 64 ff ff ff    	cmp    %eax,-0x9c(%ebp)
  107fe6:	0f 85 ea 06 00 00    	jne    1086d6 <buddy_free_pages+0xe5c>
            size_t lbegin = BUDDY_BEGIN(left);
  107fec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  107fef:	d1 e8                	shr    %eax
  107ff1:	0b 45 d0             	or     -0x30(%ebp),%eax
  107ff4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  107ff7:	d1 ea                	shr    %edx
  107ff9:	0b 55 d0             	or     -0x30(%ebp),%edx
  107ffc:	c1 ea 02             	shr    $0x2,%edx
  107fff:	09 d0                	or     %edx,%eax
  108001:	89 c1                	mov    %eax,%ecx
  108003:	8b 45 d0             	mov    -0x30(%ebp),%eax
  108006:	d1 e8                	shr    %eax
  108008:	0b 45 d0             	or     -0x30(%ebp),%eax
  10800b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10800e:	d1 ea                	shr    %edx
  108010:	0b 55 d0             	or     -0x30(%ebp),%edx
  108013:	c1 ea 02             	shr    $0x2,%edx
  108016:	09 d0                	or     %edx,%eax
  108018:	c1 e8 04             	shr    $0x4,%eax
  10801b:	09 c1                	or     %eax,%ecx
  10801d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  108020:	d1 e8                	shr    %eax
  108022:	0b 45 d0             	or     -0x30(%ebp),%eax
  108025:	8b 55 d0             	mov    -0x30(%ebp),%edx
  108028:	d1 ea                	shr    %edx
  10802a:	0b 55 d0             	or     -0x30(%ebp),%edx
  10802d:	c1 ea 02             	shr    $0x2,%edx
  108030:	09 d0                	or     %edx,%eax
  108032:	89 c3                	mov    %eax,%ebx
  108034:	8b 45 d0             	mov    -0x30(%ebp),%eax
  108037:	d1 e8                	shr    %eax
  108039:	0b 45 d0             	or     -0x30(%ebp),%eax
  10803c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10803f:	d1 ea                	shr    %edx
  108041:	0b 55 d0             	or     -0x30(%ebp),%edx
  108044:	c1 ea 02             	shr    $0x2,%edx
  108047:	09 d0                	or     %edx,%eax
  108049:	c1 e8 04             	shr    $0x4,%eax
  10804c:	09 d8                	or     %ebx,%eax
  10804e:	c1 e8 08             	shr    $0x8,%eax
  108051:	09 c1                	or     %eax,%ecx
  108053:	8b 45 d0             	mov    -0x30(%ebp),%eax
  108056:	d1 e8                	shr    %eax
  108058:	0b 45 d0             	or     -0x30(%ebp),%eax
  10805b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10805e:	d1 ea                	shr    %edx
  108060:	0b 55 d0             	or     -0x30(%ebp),%edx
  108063:	c1 ea 02             	shr    $0x2,%edx
  108066:	09 d0                	or     %edx,%eax
  108068:	89 c3                	mov    %eax,%ebx
  10806a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10806d:	d1 e8                	shr    %eax
  10806f:	0b 45 d0             	or     -0x30(%ebp),%eax
  108072:	8b 55 d0             	mov    -0x30(%ebp),%edx
  108075:	d1 ea                	shr    %edx
  108077:	0b 55 d0             	or     -0x30(%ebp),%edx
  10807a:	c1 ea 02             	shr    $0x2,%edx
  10807d:	09 d0                	or     %edx,%eax
  10807f:	c1 e8 04             	shr    $0x4,%eax
  108082:	09 c3                	or     %eax,%ebx
  108084:	8b 45 d0             	mov    -0x30(%ebp),%eax
  108087:	d1 e8                	shr    %eax
  108089:	0b 45 d0             	or     -0x30(%ebp),%eax
  10808c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10808f:	d1 ea                	shr    %edx
  108091:	0b 55 d0             	or     -0x30(%ebp),%edx
  108094:	c1 ea 02             	shr    $0x2,%edx
  108097:	09 d0                	or     %edx,%eax
  108099:	89 c6                	mov    %eax,%esi
  10809b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10809e:	d1 e8                	shr    %eax
  1080a0:	0b 45 d0             	or     -0x30(%ebp),%eax
  1080a3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1080a6:	d1 ea                	shr    %edx
  1080a8:	0b 55 d0             	or     -0x30(%ebp),%edx
  1080ab:	c1 ea 02             	shr    $0x2,%edx
  1080ae:	09 d0                	or     %edx,%eax
  1080b0:	c1 e8 04             	shr    $0x4,%eax
  1080b3:	09 f0                	or     %esi,%eax
  1080b5:	c1 e8 08             	shr    $0x8,%eax
  1080b8:	09 d8                	or     %ebx,%eax
  1080ba:	c1 e8 10             	shr    $0x10,%eax
  1080bd:	09 c8                	or     %ecx,%eax
  1080bf:	d1 e8                	shr    %eax
  1080c1:	23 45 d0             	and    -0x30(%ebp),%eax
  1080c4:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  1080ca:	8b 3d 10 3f 12 00    	mov    0x123f10,%edi
  1080d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1080d3:	d1 e8                	shr    %eax
  1080d5:	0b 45 d0             	or     -0x30(%ebp),%eax
  1080d8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1080db:	d1 ea                	shr    %edx
  1080dd:	0b 55 d0             	or     -0x30(%ebp),%edx
  1080e0:	c1 ea 02             	shr    $0x2,%edx
  1080e3:	09 d0                	or     %edx,%eax
  1080e5:	89 c1                	mov    %eax,%ecx
  1080e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1080ea:	d1 e8                	shr    %eax
  1080ec:	0b 45 d0             	or     -0x30(%ebp),%eax
  1080ef:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1080f2:	d1 ea                	shr    %edx
  1080f4:	0b 55 d0             	or     -0x30(%ebp),%edx
  1080f7:	c1 ea 02             	shr    $0x2,%edx
  1080fa:	09 d0                	or     %edx,%eax
  1080fc:	c1 e8 04             	shr    $0x4,%eax
  1080ff:	09 c1                	or     %eax,%ecx
  108101:	8b 45 d0             	mov    -0x30(%ebp),%eax
  108104:	d1 e8                	shr    %eax
  108106:	0b 45 d0             	or     -0x30(%ebp),%eax
  108109:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10810c:	d1 ea                	shr    %edx
  10810e:	0b 55 d0             	or     -0x30(%ebp),%edx
  108111:	c1 ea 02             	shr    $0x2,%edx
  108114:	09 d0                	or     %edx,%eax
  108116:	89 c3                	mov    %eax,%ebx
  108118:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10811b:	d1 e8                	shr    %eax
  10811d:	0b 45 d0             	or     -0x30(%ebp),%eax
  108120:	8b 55 d0             	mov    -0x30(%ebp),%edx
  108123:	d1 ea                	shr    %edx
  108125:	0b 55 d0             	or     -0x30(%ebp),%edx
  108128:	c1 ea 02             	shr    $0x2,%edx
  10812b:	09 d0                	or     %edx,%eax
  10812d:	c1 e8 04             	shr    $0x4,%eax
  108130:	09 d8                	or     %ebx,%eax
  108132:	c1 e8 08             	shr    $0x8,%eax
  108135:	89 cb                	mov    %ecx,%ebx
  108137:	09 c3                	or     %eax,%ebx
  108139:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10813c:	d1 e8                	shr    %eax
  10813e:	0b 45 d0             	or     -0x30(%ebp),%eax
  108141:	8b 55 d0             	mov    -0x30(%ebp),%edx
  108144:	d1 ea                	shr    %edx
  108146:	0b 55 d0             	or     -0x30(%ebp),%edx
  108149:	c1 ea 02             	shr    $0x2,%edx
  10814c:	09 d0                	or     %edx,%eax
  10814e:	89 c1                	mov    %eax,%ecx
  108150:	8b 45 d0             	mov    -0x30(%ebp),%eax
  108153:	d1 e8                	shr    %eax
  108155:	0b 45 d0             	or     -0x30(%ebp),%eax
  108158:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10815b:	d1 ea                	shr    %edx
  10815d:	0b 55 d0             	or     -0x30(%ebp),%edx
  108160:	c1 ea 02             	shr    $0x2,%edx
  108163:	09 d0                	or     %edx,%eax
  108165:	c1 e8 04             	shr    $0x4,%eax
  108168:	09 c1                	or     %eax,%ecx
  10816a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10816d:	d1 e8                	shr    %eax
  10816f:	0b 45 d0             	or     -0x30(%ebp),%eax
  108172:	8b 55 d0             	mov    -0x30(%ebp),%edx
  108175:	d1 ea                	shr    %edx
  108177:	0b 55 d0             	or     -0x30(%ebp),%edx
  10817a:	c1 ea 02             	shr    $0x2,%edx
  10817d:	09 d0                	or     %edx,%eax
  10817f:	89 c6                	mov    %eax,%esi
  108181:	8b 45 d0             	mov    -0x30(%ebp),%eax
  108184:	d1 e8                	shr    %eax
  108186:	0b 45 d0             	or     -0x30(%ebp),%eax
  108189:	89 c2                	mov    %eax,%edx
  10818b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10818e:	d1 e8                	shr    %eax
  108190:	0b 45 d0             	or     -0x30(%ebp),%eax
  108193:	c1 e8 02             	shr    $0x2,%eax
  108196:	09 d0                	or     %edx,%eax
  108198:	c1 e8 04             	shr    $0x4,%eax
  10819b:	09 f0                	or     %esi,%eax
  10819d:	c1 e8 08             	shr    $0x8,%eax
  1081a0:	09 c8                	or     %ecx,%eax
  1081a2:	c1 e8 10             	shr    $0x10,%eax
  1081a5:	09 d8                	or     %ebx,%eax
  1081a7:	d1 e8                	shr    %eax
  1081a9:	23 45 d0             	and    -0x30(%ebp),%eax
  1081ac:	85 c0                	test   %eax,%eax
  1081ae:	0f 84 e2 00 00 00    	je     108296 <buddy_free_pages+0xa1c>
  1081b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1081b7:	d1 e8                	shr    %eax
  1081b9:	0b 45 d0             	or     -0x30(%ebp),%eax
  1081bc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1081bf:	d1 ea                	shr    %edx
  1081c1:	0b 55 d0             	or     -0x30(%ebp),%edx
  1081c4:	c1 ea 02             	shr    $0x2,%edx
  1081c7:	09 d0                	or     %edx,%eax
  1081c9:	89 c1                	mov    %eax,%ecx
  1081cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1081ce:	d1 e8                	shr    %eax
  1081d0:	0b 45 d0             	or     -0x30(%ebp),%eax
  1081d3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1081d6:	d1 ea                	shr    %edx
  1081d8:	0b 55 d0             	or     -0x30(%ebp),%edx
  1081db:	c1 ea 02             	shr    $0x2,%edx
  1081de:	09 d0                	or     %edx,%eax
  1081e0:	c1 e8 04             	shr    $0x4,%eax
  1081e3:	09 c1                	or     %eax,%ecx
  1081e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1081e8:	d1 e8                	shr    %eax
  1081ea:	0b 45 d0             	or     -0x30(%ebp),%eax
  1081ed:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1081f0:	d1 ea                	shr    %edx
  1081f2:	0b 55 d0             	or     -0x30(%ebp),%edx
  1081f5:	c1 ea 02             	shr    $0x2,%edx
  1081f8:	09 d0                	or     %edx,%eax
  1081fa:	89 c3                	mov    %eax,%ebx
  1081fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1081ff:	d1 e8                	shr    %eax
  108201:	0b 45 d0             	or     -0x30(%ebp),%eax
  108204:	8b 55 d0             	mov    -0x30(%ebp),%edx
  108207:	d1 ea                	shr    %edx
  108209:	0b 55 d0             	or     -0x30(%ebp),%edx
  10820c:	c1 ea 02             	shr    $0x2,%edx
  10820f:	09 d0                	or     %edx,%eax
  108211:	c1 e8 04             	shr    $0x4,%eax
  108214:	09 d8                	or     %ebx,%eax
  108216:	c1 e8 08             	shr    $0x8,%eax
  108219:	89 cb                	mov    %ecx,%ebx
  10821b:	09 c3                	or     %eax,%ebx
  10821d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  108220:	d1 e8                	shr    %eax
  108222:	0b 45 d0             	or     -0x30(%ebp),%eax
  108225:	8b 55 d0             	mov    -0x30(%ebp),%edx
  108228:	d1 ea                	shr    %edx
  10822a:	0b 55 d0             	or     -0x30(%ebp),%edx
  10822d:	c1 ea 02             	shr    $0x2,%edx
  108230:	09 d0                	or     %edx,%eax
  108232:	89 c1                	mov    %eax,%ecx
  108234:	8b 45 d0             	mov    -0x30(%ebp),%eax
  108237:	d1 e8                	shr    %eax
  108239:	0b 45 d0             	or     -0x30(%ebp),%eax
  10823c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10823f:	d1 ea                	shr    %edx
  108241:	0b 55 d0             	or     -0x30(%ebp),%edx
  108244:	c1 ea 02             	shr    $0x2,%edx
  108247:	09 d0                	or     %edx,%eax
  108249:	c1 e8 04             	shr    $0x4,%eax
  10824c:	09 c1                	or     %eax,%ecx
  10824e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  108251:	d1 e8                	shr    %eax
  108253:	0b 45 d0             	or     -0x30(%ebp),%eax
  108256:	8b 55 d0             	mov    -0x30(%ebp),%edx
  108259:	d1 ea                	shr    %edx
  10825b:	0b 55 d0             	or     -0x30(%ebp),%edx
  10825e:	c1 ea 02             	shr    $0x2,%edx
  108261:	09 d0                	or     %edx,%eax
  108263:	89 c6                	mov    %eax,%esi
  108265:	8b 45 d0             	mov    -0x30(%ebp),%eax
  108268:	d1 e8                	shr    %eax
  10826a:	0b 45 d0             	or     -0x30(%ebp),%eax
  10826d:	89 c2                	mov    %eax,%edx
  10826f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  108272:	d1 e8                	shr    %eax
  108274:	0b 45 d0             	or     -0x30(%ebp),%eax
  108277:	c1 e8 02             	shr    $0x2,%eax
  10827a:	09 d0                	or     %edx,%eax
  10827c:	c1 e8 04             	shr    $0x4,%eax
  10827f:	09 f0                	or     %esi,%eax
  108281:	c1 e8 08             	shr    $0x8,%eax
  108284:	09 c8                	or     %ecx,%eax
  108286:	c1 e8 10             	shr    $0x10,%eax
  108289:	09 d8                	or     %ebx,%eax
  10828b:	d1 e8                	shr    %eax
  10828d:	f7 d0                	not    %eax
  10828f:	23 45 d0             	and    -0x30(%ebp),%eax
  108292:	89 c6                	mov    %eax,%esi
  108294:	eb 03                	jmp    108299 <buddy_free_pages+0xa1f>
  108296:	8b 75 d0             	mov    -0x30(%ebp),%esi
  108299:	89 f8                	mov    %edi,%eax
  10829b:	ba 00 00 00 00       	mov    $0x0,%edx
  1082a0:	f7 f6                	div    %esi
  1082a2:	0f af 85 64 ff ff ff 	imul   -0x9c(%ebp),%eax
  1082a9:	89 45 c8             	mov    %eax,-0x38(%ebp)
            size_t rbegin = BUDDY_BEGIN(right);
  1082ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1082af:	d1 e8                	shr    %eax
  1082b1:	0b 45 cc             	or     -0x34(%ebp),%eax
  1082b4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1082b7:	d1 ea                	shr    %edx
  1082b9:	0b 55 cc             	or     -0x34(%ebp),%edx
  1082bc:	c1 ea 02             	shr    $0x2,%edx
  1082bf:	09 d0                	or     %edx,%eax
  1082c1:	89 c1                	mov    %eax,%ecx
  1082c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1082c6:	d1 e8                	shr    %eax
  1082c8:	0b 45 cc             	or     -0x34(%ebp),%eax
  1082cb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1082ce:	d1 ea                	shr    %edx
  1082d0:	0b 55 cc             	or     -0x34(%ebp),%edx
  1082d3:	c1 ea 02             	shr    $0x2,%edx
  1082d6:	09 d0                	or     %edx,%eax
  1082d8:	c1 e8 04             	shr    $0x4,%eax
  1082db:	09 c1                	or     %eax,%ecx
  1082dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1082e0:	d1 e8                	shr    %eax
  1082e2:	0b 45 cc             	or     -0x34(%ebp),%eax
  1082e5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1082e8:	d1 ea                	shr    %edx
  1082ea:	0b 55 cc             	or     -0x34(%ebp),%edx
  1082ed:	c1 ea 02             	shr    $0x2,%edx
  1082f0:	09 d0                	or     %edx,%eax
  1082f2:	89 c3                	mov    %eax,%ebx
  1082f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1082f7:	d1 e8                	shr    %eax
  1082f9:	0b 45 cc             	or     -0x34(%ebp),%eax
  1082fc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1082ff:	d1 ea                	shr    %edx
  108301:	0b 55 cc             	or     -0x34(%ebp),%edx
  108304:	c1 ea 02             	shr    $0x2,%edx
  108307:	09 d0                	or     %edx,%eax
  108309:	c1 e8 04             	shr    $0x4,%eax
  10830c:	09 d8                	or     %ebx,%eax
  10830e:	c1 e8 08             	shr    $0x8,%eax
  108311:	09 c1                	or     %eax,%ecx
  108313:	8b 45 cc             	mov    -0x34(%ebp),%eax
  108316:	d1 e8                	shr    %eax
  108318:	0b 45 cc             	or     -0x34(%ebp),%eax
  10831b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10831e:	d1 ea                	shr    %edx
  108320:	0b 55 cc             	or     -0x34(%ebp),%edx
  108323:	c1 ea 02             	shr    $0x2,%edx
  108326:	09 d0                	or     %edx,%eax
  108328:	89 c3                	mov    %eax,%ebx
  10832a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10832d:	d1 e8                	shr    %eax
  10832f:	0b 45 cc             	or     -0x34(%ebp),%eax
  108332:	8b 55 cc             	mov    -0x34(%ebp),%edx
  108335:	d1 ea                	shr    %edx
  108337:	0b 55 cc             	or     -0x34(%ebp),%edx
  10833a:	c1 ea 02             	shr    $0x2,%edx
  10833d:	09 d0                	or     %edx,%eax
  10833f:	c1 e8 04             	shr    $0x4,%eax
  108342:	09 c3                	or     %eax,%ebx
  108344:	8b 45 cc             	mov    -0x34(%ebp),%eax
  108347:	d1 e8                	shr    %eax
  108349:	0b 45 cc             	or     -0x34(%ebp),%eax
  10834c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10834f:	d1 ea                	shr    %edx
  108351:	0b 55 cc             	or     -0x34(%ebp),%edx
  108354:	c1 ea 02             	shr    $0x2,%edx
  108357:	09 d0                	or     %edx,%eax
  108359:	89 c6                	mov    %eax,%esi
  10835b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10835e:	d1 e8                	shr    %eax
  108360:	0b 45 cc             	or     -0x34(%ebp),%eax
  108363:	8b 55 cc             	mov    -0x34(%ebp),%edx
  108366:	d1 ea                	shr    %edx
  108368:	0b 55 cc             	or     -0x34(%ebp),%edx
  10836b:	c1 ea 02             	shr    $0x2,%edx
  10836e:	09 d0                	or     %edx,%eax
  108370:	c1 e8 04             	shr    $0x4,%eax
  108373:	09 f0                	or     %esi,%eax
  108375:	c1 e8 08             	shr    $0x8,%eax
  108378:	09 d8                	or     %ebx,%eax
  10837a:	c1 e8 10             	shr    $0x10,%eax
  10837d:	09 c8                	or     %ecx,%eax
  10837f:	d1 e8                	shr    %eax
  108381:	23 45 cc             	and    -0x34(%ebp),%eax
  108384:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  10838a:	8b 3d 10 3f 12 00    	mov    0x123f10,%edi
  108390:	8b 45 cc             	mov    -0x34(%ebp),%eax
  108393:	d1 e8                	shr    %eax
  108395:	0b 45 cc             	or     -0x34(%ebp),%eax
  108398:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10839b:	d1 ea                	shr    %edx
  10839d:	0b 55 cc             	or     -0x34(%ebp),%edx
  1083a0:	c1 ea 02             	shr    $0x2,%edx
  1083a3:	09 d0                	or     %edx,%eax
  1083a5:	89 c1                	mov    %eax,%ecx
  1083a7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1083aa:	d1 e8                	shr    %eax
  1083ac:	0b 45 cc             	or     -0x34(%ebp),%eax
  1083af:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1083b2:	d1 ea                	shr    %edx
  1083b4:	0b 55 cc             	or     -0x34(%ebp),%edx
  1083b7:	c1 ea 02             	shr    $0x2,%edx
  1083ba:	09 d0                	or     %edx,%eax
  1083bc:	c1 e8 04             	shr    $0x4,%eax
  1083bf:	09 c1                	or     %eax,%ecx
  1083c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1083c4:	d1 e8                	shr    %eax
  1083c6:	0b 45 cc             	or     -0x34(%ebp),%eax
  1083c9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1083cc:	d1 ea                	shr    %edx
  1083ce:	0b 55 cc             	or     -0x34(%ebp),%edx
  1083d1:	c1 ea 02             	shr    $0x2,%edx
  1083d4:	09 d0                	or     %edx,%eax
  1083d6:	89 c3                	mov    %eax,%ebx
  1083d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1083db:	d1 e8                	shr    %eax
  1083dd:	0b 45 cc             	or     -0x34(%ebp),%eax
  1083e0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1083e3:	d1 ea                	shr    %edx
  1083e5:	0b 55 cc             	or     -0x34(%ebp),%edx
  1083e8:	c1 ea 02             	shr    $0x2,%edx
  1083eb:	09 d0                	or     %edx,%eax
  1083ed:	c1 e8 04             	shr    $0x4,%eax
  1083f0:	09 d8                	or     %ebx,%eax
  1083f2:	c1 e8 08             	shr    $0x8,%eax
  1083f5:	89 cb                	mov    %ecx,%ebx
  1083f7:	09 c3                	or     %eax,%ebx
  1083f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1083fc:	d1 e8                	shr    %eax
  1083fe:	0b 45 cc             	or     -0x34(%ebp),%eax
  108401:	8b 55 cc             	mov    -0x34(%ebp),%edx
  108404:	d1 ea                	shr    %edx
  108406:	0b 55 cc             	or     -0x34(%ebp),%edx
  108409:	c1 ea 02             	shr    $0x2,%edx
  10840c:	09 d0                	or     %edx,%eax
  10840e:	89 c1                	mov    %eax,%ecx
  108410:	8b 45 cc             	mov    -0x34(%ebp),%eax
  108413:	d1 e8                	shr    %eax
  108415:	0b 45 cc             	or     -0x34(%ebp),%eax
  108418:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10841b:	d1 ea                	shr    %edx
  10841d:	0b 55 cc             	or     -0x34(%ebp),%edx
  108420:	c1 ea 02             	shr    $0x2,%edx
  108423:	09 d0                	or     %edx,%eax
  108425:	c1 e8 04             	shr    $0x4,%eax
  108428:	09 c1                	or     %eax,%ecx
  10842a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10842d:	d1 e8                	shr    %eax
  10842f:	0b 45 cc             	or     -0x34(%ebp),%eax
  108432:	8b 55 cc             	mov    -0x34(%ebp),%edx
  108435:	d1 ea                	shr    %edx
  108437:	0b 55 cc             	or     -0x34(%ebp),%edx
  10843a:	c1 ea 02             	shr    $0x2,%edx
  10843d:	09 d0                	or     %edx,%eax
  10843f:	89 c6                	mov    %eax,%esi
  108441:	8b 45 cc             	mov    -0x34(%ebp),%eax
  108444:	d1 e8                	shr    %eax
  108446:	0b 45 cc             	or     -0x34(%ebp),%eax
  108449:	89 c2                	mov    %eax,%edx
  10844b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10844e:	d1 e8                	shr    %eax
  108450:	0b 45 cc             	or     -0x34(%ebp),%eax
  108453:	c1 e8 02             	shr    $0x2,%eax
  108456:	09 d0                	or     %edx,%eax
  108458:	c1 e8 04             	shr    $0x4,%eax
  10845b:	09 f0                	or     %esi,%eax
  10845d:	c1 e8 08             	shr    $0x8,%eax
  108460:	09 c8                	or     %ecx,%eax
  108462:	c1 e8 10             	shr    $0x10,%eax
  108465:	09 d8                	or     %ebx,%eax
  108467:	d1 e8                	shr    %eax
  108469:	23 45 cc             	and    -0x34(%ebp),%eax
  10846c:	85 c0                	test   %eax,%eax
  10846e:	0f 84 e2 00 00 00    	je     108556 <buddy_free_pages+0xcdc>
  108474:	8b 45 cc             	mov    -0x34(%ebp),%eax
  108477:	d1 e8                	shr    %eax
  108479:	0b 45 cc             	or     -0x34(%ebp),%eax
  10847c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10847f:	d1 ea                	shr    %edx
  108481:	0b 55 cc             	or     -0x34(%ebp),%edx
  108484:	c1 ea 02             	shr    $0x2,%edx
  108487:	09 d0                	or     %edx,%eax
  108489:	89 c1                	mov    %eax,%ecx
  10848b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10848e:	d1 e8                	shr    %eax
  108490:	0b 45 cc             	or     -0x34(%ebp),%eax
  108493:	8b 55 cc             	mov    -0x34(%ebp),%edx
  108496:	d1 ea                	shr    %edx
  108498:	0b 55 cc             	or     -0x34(%ebp),%edx
  10849b:	c1 ea 02             	shr    $0x2,%edx
  10849e:	09 d0                	or     %edx,%eax
  1084a0:	c1 e8 04             	shr    $0x4,%eax
  1084a3:	09 c1                	or     %eax,%ecx
  1084a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1084a8:	d1 e8                	shr    %eax
  1084aa:	0b 45 cc             	or     -0x34(%ebp),%eax
  1084ad:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1084b0:	d1 ea                	shr    %edx
  1084b2:	0b 55 cc             	or     -0x34(%ebp),%edx
  1084b5:	c1 ea 02             	shr    $0x2,%edx
  1084b8:	09 d0                	or     %edx,%eax
  1084ba:	89 c3                	mov    %eax,%ebx
  1084bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1084bf:	d1 e8                	shr    %eax
  1084c1:	0b 45 cc             	or     -0x34(%ebp),%eax
  1084c4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1084c7:	d1 ea                	shr    %edx
  1084c9:	0b 55 cc             	or     -0x34(%ebp),%edx
  1084cc:	c1 ea 02             	shr    $0x2,%edx
  1084cf:	09 d0                	or     %edx,%eax
  1084d1:	c1 e8 04             	shr    $0x4,%eax
  1084d4:	09 d8                	or     %ebx,%eax
  1084d6:	c1 e8 08             	shr    $0x8,%eax
  1084d9:	89 cb                	mov    %ecx,%ebx
  1084db:	09 c3                	or     %eax,%ebx
  1084dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1084e0:	d1 e8                	shr    %eax
  1084e2:	0b 45 cc             	or     -0x34(%ebp),%eax
  1084e5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1084e8:	d1 ea                	shr    %edx
  1084ea:	0b 55 cc             	or     -0x34(%ebp),%edx
  1084ed:	c1 ea 02             	shr    $0x2,%edx
  1084f0:	09 d0                	or     %edx,%eax
  1084f2:	89 c1                	mov    %eax,%ecx
  1084f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1084f7:	d1 e8                	shr    %eax
  1084f9:	0b 45 cc             	or     -0x34(%ebp),%eax
  1084fc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1084ff:	d1 ea                	shr    %edx
  108501:	0b 55 cc             	or     -0x34(%ebp),%edx
  108504:	c1 ea 02             	shr    $0x2,%edx
  108507:	09 d0                	or     %edx,%eax
  108509:	c1 e8 04             	shr    $0x4,%eax
  10850c:	09 c1                	or     %eax,%ecx
  10850e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  108511:	d1 e8                	shr    %eax
  108513:	0b 45 cc             	or     -0x34(%ebp),%eax
  108516:	8b 55 cc             	mov    -0x34(%ebp),%edx
  108519:	d1 ea                	shr    %edx
  10851b:	0b 55 cc             	or     -0x34(%ebp),%edx
  10851e:	c1 ea 02             	shr    $0x2,%edx
  108521:	09 d0                	or     %edx,%eax
  108523:	89 c6                	mov    %eax,%esi
  108525:	8b 45 cc             	mov    -0x34(%ebp),%eax
  108528:	d1 e8                	shr    %eax
  10852a:	0b 45 cc             	or     -0x34(%ebp),%eax
  10852d:	89 c2                	mov    %eax,%edx
  10852f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  108532:	d1 e8                	shr    %eax
  108534:	0b 45 cc             	or     -0x34(%ebp),%eax
  108537:	c1 e8 02             	shr    $0x2,%eax
  10853a:	09 d0                	or     %edx,%eax
  10853c:	c1 e8 04             	shr    $0x4,%eax
  10853f:	09 f0                	or     %esi,%eax
  108541:	c1 e8 08             	shr    $0x8,%eax
  108544:	09 c8                	or     %ecx,%eax
  108546:	c1 e8 10             	shr    $0x10,%eax
  108549:	09 d8                	or     %ebx,%eax
  10854b:	d1 e8                	shr    %eax
  10854d:	f7 d0                	not    %eax
  10854f:	23 45 cc             	and    -0x34(%ebp),%eax
  108552:	89 c6                	mov    %eax,%esi
  108554:	eb 03                	jmp    108559 <buddy_free_pages+0xcdf>
  108556:	8b 75 cc             	mov    -0x34(%ebp),%esi
  108559:	89 f8                	mov    %edi,%eax
  10855b:	ba 00 00 00 00       	mov    $0x0,%edx
  108560:	f7 f6                	div    %esi
  108562:	0f af 85 64 ff ff ff 	imul   -0x9c(%ebp),%eax
  108569:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            list_del(&(buddy_alloc[lbegin].page_link));
  10856c:	8b 0d 24 3f 12 00    	mov    0x123f24,%ecx
  108572:	8b 55 c8             	mov    -0x38(%ebp),%edx
  108575:	89 d0                	mov    %edx,%eax
  108577:	c1 e0 02             	shl    $0x2,%eax
  10857a:	01 d0                	add    %edx,%eax
  10857c:	c1 e0 02             	shl    $0x2,%eax
  10857f:	01 c8                	add    %ecx,%eax
  108581:	83 c0 0c             	add    $0xc,%eax
  108584:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
    __list_del(listelm->prev, listelm->next);
  10858a:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  108590:	8b 40 04             	mov    0x4(%eax),%eax
  108593:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  108599:	8b 12                	mov    (%edx),%edx
  10859b:	89 95 6c ff ff ff    	mov    %edx,-0x94(%ebp)
  1085a1:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
    prev->next = next;
  1085a7:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  1085ad:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
  1085b3:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1085b6:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  1085bc:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  1085c2:	89 10                	mov    %edx,(%eax)
}
  1085c4:	90                   	nop
}
  1085c5:	90                   	nop
            list_del(&(buddy_alloc[rbegin].page_link));
  1085c6:	8b 0d 24 3f 12 00    	mov    0x123f24,%ecx
  1085cc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1085cf:	89 d0                	mov    %edx,%eax
  1085d1:	c1 e0 02             	shl    $0x2,%eax
  1085d4:	01 d0                	add    %edx,%eax
  1085d6:	c1 e0 02             	shl    $0x2,%eax
  1085d9:	01 c8                	add    %ecx,%eax
  1085db:	83 c0 0c             	add    $0xc,%eax
  1085de:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
    __list_del(listelm->prev, listelm->next);
  1085e4:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  1085ea:	8b 40 04             	mov    0x4(%eax),%eax
  1085ed:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  1085f3:	8b 12                	mov    (%edx),%edx
  1085f5:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)
  1085fb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
    prev->next = next;
  108601:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  108607:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  10860d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  108610:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  108616:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  10861c:	89 10                	mov    %edx,(%eax)
}
  10861e:	90                   	nop
}
  10861f:	90                   	nop
            buddy_segment[block] = buddy_segment[left]<<1;
  108620:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  108625:	8b 55 d0             	mov    -0x30(%ebp),%edx
  108628:	c1 e2 02             	shl    $0x2,%edx
  10862b:	01 d0                	add    %edx,%eax
  10862d:	8b 10                	mov    (%eax),%edx
  10862f:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  108634:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  108637:	c1 e1 02             	shl    $0x2,%ecx
  10863a:	01 c8                	add    %ecx,%eax
  10863c:	01 d2                	add    %edx,%edx
  10863e:	89 10                	mov    %edx,(%eax)
            buddy_alloc[lbegin].property = buddy_segment[left]<<1;
  108640:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  108645:	8b 55 d0             	mov    -0x30(%ebp),%edx
  108648:	c1 e2 02             	shl    $0x2,%edx
  10864b:	01 d0                	add    %edx,%eax
  10864d:	8b 08                	mov    (%eax),%ecx
  10864f:	8b 1d 24 3f 12 00    	mov    0x123f24,%ebx
  108655:	8b 55 c8             	mov    -0x38(%ebp),%edx
  108658:	89 d0                	mov    %edx,%eax
  10865a:	c1 e0 02             	shl    $0x2,%eax
  10865d:	01 d0                	add    %edx,%eax
  10865f:	c1 e0 02             	shl    $0x2,%eax
  108662:	01 d8                	add    %ebx,%eax
  108664:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
  108667:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&(free_list), &(buddy_alloc[lbegin].page_link));
  10866a:	8b 0d 24 3f 12 00    	mov    0x123f24,%ecx
  108670:	8b 55 c8             	mov    -0x38(%ebp),%edx
  108673:	89 d0                	mov    %edx,%eax
  108675:	c1 e0 02             	shl    $0x2,%eax
  108678:	01 d0                	add    %edx,%eax
  10867a:	c1 e0 02             	shl    $0x2,%eax
  10867d:	01 c8                	add    %ecx,%eax
  10867f:	83 c0 0c             	add    $0xc,%eax
  108682:	c7 45 98 38 3f 12 00 	movl   $0x123f38,-0x68(%ebp)
  108689:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10868c:	8b 45 98             	mov    -0x68(%ebp),%eax
  10868f:	89 45 90             	mov    %eax,-0x70(%ebp)
  108692:	8b 45 94             	mov    -0x6c(%ebp),%eax
  108695:	89 45 8c             	mov    %eax,-0x74(%ebp)
    __list_add(elm, listelm, listelm->next);
  108698:	8b 45 90             	mov    -0x70(%ebp),%eax
  10869b:	8b 40 04             	mov    0x4(%eax),%eax
  10869e:	8b 55 8c             	mov    -0x74(%ebp),%edx
  1086a1:	89 55 88             	mov    %edx,-0x78(%ebp)
  1086a4:	8b 55 90             	mov    -0x70(%ebp),%edx
  1086a7:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1086aa:	89 45 80             	mov    %eax,-0x80(%ebp)
    prev->next = next->prev = elm;
  1086ad:	8b 45 80             	mov    -0x80(%ebp),%eax
  1086b0:	8b 55 88             	mov    -0x78(%ebp),%edx
  1086b3:	89 10                	mov    %edx,(%eax)
  1086b5:	8b 45 80             	mov    -0x80(%ebp),%eax
  1086b8:	8b 10                	mov    (%eax),%edx
  1086ba:	8b 45 84             	mov    -0x7c(%ebp),%eax
  1086bd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1086c0:	8b 45 88             	mov    -0x78(%ebp),%eax
  1086c3:	8b 55 80             	mov    -0x80(%ebp),%edx
  1086c6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1086c9:	8b 45 88             	mov    -0x78(%ebp),%eax
  1086cc:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1086cf:	89 10                	mov    %edx,(%eax)
}
  1086d1:	90                   	nop
}
  1086d2:	90                   	nop
}
  1086d3:	90                   	nop
        if (BUDDY_EMPTY(left) && BUDDY_EMPTY(right)) {  // Merge
  1086d4:	eb 32                	jmp    108708 <buddy_free_pages+0xe8e>
        } else {                                        // Update
            buddy_segment[block] = buddy_segment[BUDDY_LEFT(block)] | buddy_segment[BUDDY_RIGHT(block)];
  1086d6:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  1086db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1086de:	c1 e2 03             	shl    $0x3,%edx
  1086e1:	01 d0                	add    %edx,%eax
  1086e3:	8b 08                	mov    (%eax),%ecx
  1086e5:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  1086ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1086ed:	c1 e2 03             	shl    $0x3,%edx
  1086f0:	83 c2 04             	add    $0x4,%edx
  1086f3:	01 d0                	add    %edx,%eax
  1086f5:	8b 10                	mov    (%eax),%edx
  1086f7:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  1086fc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  1086ff:	c1 e3 02             	shl    $0x2,%ebx
  108702:	01 d8                	add    %ebx,%eax
  108704:	09 ca                	or     %ecx,%edx
  108706:	89 10                	mov    %edx,(%eax)
    while (block != BUDDY_ROOT) {
  108708:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
  10870c:	0f 85 d4 f4 ff ff    	jne    107be6 <buddy_free_pages+0x36c>
        }
    }
}
  108712:	90                   	nop
  108713:	90                   	nop
  108714:	81 c4 ac 00 00 00    	add    $0xac,%esp
  10871a:	5b                   	pop    %ebx
  10871b:	5e                   	pop    %esi
  10871c:	5f                   	pop    %edi
  10871d:	5d                   	pop    %ebp
  10871e:	c3                   	ret    

0010871f <buddy_nr_free_pages>:

static size_t
buddy_nr_free_pages(void) {
  10871f:	f3 0f 1e fb          	endbr32 
  108723:	55                   	push   %ebp
  108724:	89 e5                	mov    %esp,%ebp
    return nr_free;
  108726:	a1 40 3f 12 00       	mov    0x123f40,%eax
}
  10872b:	5d                   	pop    %ebp
  10872c:	c3                   	ret    

0010872d <macro_check>:

static void
macro_check(void) {
  10872d:	f3 0f 1e fb          	endbr32 
  108731:	55                   	push   %ebp
  108732:	89 e5                	mov    %esp,%ebp
  108734:	83 ec 28             	sub    $0x28,%esp
    assert(BUDDY_ROOT == 1);
    assert(BUDDY_LEFT(3) == 6);
    assert(BUDDY_RIGHT(3) == 7);
    assert(BUDDY_PARENT(6) == 3);
    assert(BUDDY_PARENT(7) == 3);
    size_t buddy_virtual_size_store = buddy_virtual_size;
  108737:	a1 10 3f 12 00       	mov    0x123f10,%eax
  10873c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t buddy_segment_root_store = buddy_segment[BUDDY_ROOT];
  10873f:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  108744:	8b 40 04             	mov    0x4(%eax),%eax
  108747:	89 45 f0             	mov    %eax,-0x10(%ebp)
    buddy_virtual_size = 16;
  10874a:	c7 05 10 3f 12 00 10 	movl   $0x10,0x123f10
  108751:	00 00 00 
    buddy_segment[BUDDY_ROOT] = 16;
  108754:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  108759:	83 c0 04             	add    $0x4,%eax
  10875c:	c7 00 10 00 00 00    	movl   $0x10,(%eax)
    assert(BUDDY_LENGTH(6) == 4);
  108762:	a1 10 3f 12 00       	mov    0x123f10,%eax
  108767:	83 e8 10             	sub    $0x10,%eax
  10876a:	83 f8 03             	cmp    $0x3,%eax
  10876d:	76 24                	jbe    108793 <macro_check+0x66>
  10876f:	c7 44 24 0c 34 b3 10 	movl   $0x10b334,0xc(%esp)
  108776:	00 
  108777:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  10877e:	00 
  10877f:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  108786:	00 
  108787:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  10878e:	e8 a3 7c ff ff       	call   100436 <__panic>
    assert(BUDDY_BEGIN(6) == 8);
  108793:	a1 10 3f 12 00       	mov    0x123f10,%eax
  108798:	c1 e8 02             	shr    $0x2,%eax
  10879b:	01 c0                	add    %eax,%eax
  10879d:	83 f8 08             	cmp    $0x8,%eax
  1087a0:	74 24                	je     1087c6 <macro_check+0x99>
  1087a2:	c7 44 24 0c 49 b3 10 	movl   $0x10b349,0xc(%esp)
  1087a9:	00 
  1087aa:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  1087b1:	00 
  1087b2:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  1087b9:	00 
  1087ba:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  1087c1:	e8 70 7c ff ff       	call   100436 <__panic>
    assert(BUDDY_END(6) == 12);
  1087c6:	a1 10 3f 12 00       	mov    0x123f10,%eax
  1087cb:	c1 e8 02             	shr    $0x2,%eax
  1087ce:	89 c2                	mov    %eax,%edx
  1087d0:	89 d0                	mov    %edx,%eax
  1087d2:	01 c0                	add    %eax,%eax
  1087d4:	01 d0                	add    %edx,%eax
  1087d6:	83 f8 0c             	cmp    $0xc,%eax
  1087d9:	74 24                	je     1087ff <macro_check+0xd2>
  1087db:	c7 44 24 0c 5d b3 10 	movl   $0x10b35d,0xc(%esp)
  1087e2:	00 
  1087e3:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  1087ea:	00 
  1087eb:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  1087f2:	00 
  1087f3:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  1087fa:	e8 37 7c ff ff       	call   100436 <__panic>
    assert(BUDDY_BLOCK(8, 12) == 6);
  1087ff:	a1 10 3f 12 00       	mov    0x123f10,%eax
  108804:	83 e8 10             	sub    $0x10,%eax
  108807:	83 f8 03             	cmp    $0x3,%eax
  10880a:	76 24                	jbe    108830 <macro_check+0x103>
  10880c:	c7 44 24 0c 70 b3 10 	movl   $0x10b370,0xc(%esp)
  108813:	00 
  108814:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  10881b:	00 
  10881c:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  108823:	00 
  108824:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  10882b:	e8 06 7c ff ff       	call   100436 <__panic>
    assert(BUDDY_EMPTY(BUDDY_ROOT));
  108830:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  108835:	83 c0 04             	add    $0x4,%eax
  108838:	8b 10                	mov    (%eax),%edx
  10883a:	a1 10 3f 12 00       	mov    0x123f10,%eax
  10883f:	39 c2                	cmp    %eax,%edx
  108841:	74 24                	je     108867 <macro_check+0x13a>
  108843:	c7 44 24 0c 88 b3 10 	movl   $0x10b388,0xc(%esp)
  10884a:	00 
  10884b:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  108852:	00 
  108853:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  10885a:	00 
  10885b:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  108862:	e8 cf 7b ff ff       	call   100436 <__panic>
    buddy_virtual_size = buddy_virtual_size_store;
  108867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10886a:	a3 10 3f 12 00       	mov    %eax,0x123f10
    buddy_segment[BUDDY_ROOT] = buddy_segment_root_store;
  10886f:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  108874:	8d 50 04             	lea    0x4(%eax),%edx
  108877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10887a:	89 02                	mov    %eax,(%edx)
    assert(UINT32_ROUND_UP(0x2321) == 0x4000);
    assert(UINT32_ROUND_UP(0x2000) == 0x2000);
    assert(UINT32_ROUND_DOWN(0x4321) == 0x4000);
    assert(UINT32_ROUND_DOWN(0x4000) == 0x4000);

}
  10887c:	90                   	nop
  10887d:	c9                   	leave  
  10887e:	c3                   	ret    

0010887f <size_check>:

static void
size_check(void) {
  10887f:	f3 0f 1e fb          	endbr32 
  108883:	55                   	push   %ebp
  108884:	89 e5                	mov    %esp,%ebp
  108886:	83 ec 28             	sub    $0x28,%esp

    size_t buddy_physical_size_store = buddy_physical_size;
  108889:	a1 0c 3f 12 00       	mov    0x123f0c,%eax
  10888e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    buddy_init_size(200);
  108891:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
  108898:	e8 0c d0 ff ff       	call   1058a9 <buddy_init_size>
    assert(buddy_virtual_size == 256);
  10889d:	a1 10 3f 12 00       	mov    0x123f10,%eax
  1088a2:	3d 00 01 00 00       	cmp    $0x100,%eax
  1088a7:	74 24                	je     1088cd <size_check+0x4e>
  1088a9:	c7 44 24 0c a0 b3 10 	movl   $0x10b3a0,0xc(%esp)
  1088b0:	00 
  1088b1:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  1088b8:	00 
  1088b9:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1088c0:	00 
  1088c1:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  1088c8:	e8 69 7b ff ff       	call   100436 <__panic>
    buddy_init_size(1024);
  1088cd:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
  1088d4:	e8 d0 cf ff ff       	call   1058a9 <buddy_init_size>
    assert(buddy_virtual_size == 1024);
  1088d9:	a1 10 3f 12 00       	mov    0x123f10,%eax
  1088de:	3d 00 04 00 00       	cmp    $0x400,%eax
  1088e3:	74 24                	je     108909 <size_check+0x8a>
  1088e5:	c7 44 24 0c ba b3 10 	movl   $0x10b3ba,0xc(%esp)
  1088ec:	00 
  1088ed:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  1088f4:	00 
  1088f5:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  1088fc:	00 
  1088fd:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  108904:	e8 2d 7b ff ff       	call   100436 <__panic>
    buddy_init_size(1026);
  108909:	c7 04 24 02 04 00 00 	movl   $0x402,(%esp)
  108910:	e8 94 cf ff ff       	call   1058a9 <buddy_init_size>
    assert(buddy_virtual_size == 1024);
  108915:	a1 10 3f 12 00       	mov    0x123f10,%eax
  10891a:	3d 00 04 00 00       	cmp    $0x400,%eax
  10891f:	74 24                	je     108945 <size_check+0xc6>
  108921:	c7 44 24 0c ba b3 10 	movl   $0x10b3ba,0xc(%esp)
  108928:	00 
  108929:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  108930:	00 
  108931:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  108938:	00 
  108939:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  108940:	e8 f1 7a ff ff       	call   100436 <__panic>
    buddy_init_size(1028);    
  108945:	c7 04 24 04 04 00 00 	movl   $0x404,(%esp)
  10894c:	e8 58 cf ff ff       	call   1058a9 <buddy_init_size>
    assert(buddy_virtual_size == 1024);
  108951:	a1 10 3f 12 00       	mov    0x123f10,%eax
  108956:	3d 00 04 00 00       	cmp    $0x400,%eax
  10895b:	74 24                	je     108981 <size_check+0x102>
  10895d:	c7 44 24 0c ba b3 10 	movl   $0x10b3ba,0xc(%esp)
  108964:	00 
  108965:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  10896c:	00 
  10896d:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  108974:	00 
  108975:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  10897c:	e8 b5 7a ff ff       	call   100436 <__panic>
    buddy_init_size(1030);    
  108981:	c7 04 24 06 04 00 00 	movl   $0x406,(%esp)
  108988:	e8 1c cf ff ff       	call   1058a9 <buddy_init_size>
    assert(buddy_virtual_size == 2048);
  10898d:	a1 10 3f 12 00       	mov    0x123f10,%eax
  108992:	3d 00 08 00 00       	cmp    $0x800,%eax
  108997:	74 24                	je     1089bd <size_check+0x13e>
  108999:	c7 44 24 0c d5 b3 10 	movl   $0x10b3d5,0xc(%esp)
  1089a0:	00 
  1089a1:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  1089a8:	00 
  1089a9:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  1089b0:	00 
  1089b1:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  1089b8:	e8 79 7a ff ff       	call   100436 <__panic>
    buddy_init_size(buddy_physical_size_store);   
  1089bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1089c0:	89 04 24             	mov    %eax,(%esp)
  1089c3:	e8 e1 ce ff ff       	call   1058a9 <buddy_init_size>

}
  1089c8:	90                   	nop
  1089c9:	c9                   	leave  
  1089ca:	c3                   	ret    

001089cb <segment_check>:

static void
segment_check(void) {
  1089cb:	f3 0f 1e fb          	endbr32 
  1089cf:	55                   	push   %ebp
  1089d0:	89 e5                	mov    %esp,%ebp
  1089d2:	57                   	push   %edi
  1089d3:	56                   	push   %esi
  1089d4:	53                   	push   %ebx
  1089d5:	83 ec 4c             	sub    $0x4c,%esp

    // Check buddy segment
    size_t total = 0, count = 0;
  1089d8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1089df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    for (size_t block = BUDDY_ROOT; block < (buddy_virtual_size<<1); block++)
  1089e6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  1089ed:	e9 2e 04 00 00       	jmp    108e20 <segment_check+0x455>
        if (BUDDY_EMPTY(block))
  1089f2:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  1089f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1089fa:	c1 e2 02             	shl    $0x2,%edx
  1089fd:	01 d0                	add    %edx,%eax
  1089ff:	8b 00                	mov    (%eax),%eax
  108a01:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  108a04:	8b 3d 10 3f 12 00    	mov    0x123f10,%edi
  108a0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108a0d:	d1 e8                	shr    %eax
  108a0f:	0b 45 dc             	or     -0x24(%ebp),%eax
  108a12:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108a15:	d1 ea                	shr    %edx
  108a17:	0b 55 dc             	or     -0x24(%ebp),%edx
  108a1a:	c1 ea 02             	shr    $0x2,%edx
  108a1d:	09 d0                	or     %edx,%eax
  108a1f:	89 c1                	mov    %eax,%ecx
  108a21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108a24:	d1 e8                	shr    %eax
  108a26:	0b 45 dc             	or     -0x24(%ebp),%eax
  108a29:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108a2c:	d1 ea                	shr    %edx
  108a2e:	0b 55 dc             	or     -0x24(%ebp),%edx
  108a31:	c1 ea 02             	shr    $0x2,%edx
  108a34:	09 d0                	or     %edx,%eax
  108a36:	c1 e8 04             	shr    $0x4,%eax
  108a39:	09 c1                	or     %eax,%ecx
  108a3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108a3e:	d1 e8                	shr    %eax
  108a40:	0b 45 dc             	or     -0x24(%ebp),%eax
  108a43:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108a46:	d1 ea                	shr    %edx
  108a48:	0b 55 dc             	or     -0x24(%ebp),%edx
  108a4b:	c1 ea 02             	shr    $0x2,%edx
  108a4e:	09 d0                	or     %edx,%eax
  108a50:	89 c3                	mov    %eax,%ebx
  108a52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108a55:	d1 e8                	shr    %eax
  108a57:	0b 45 dc             	or     -0x24(%ebp),%eax
  108a5a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108a5d:	d1 ea                	shr    %edx
  108a5f:	0b 55 dc             	or     -0x24(%ebp),%edx
  108a62:	c1 ea 02             	shr    $0x2,%edx
  108a65:	09 d0                	or     %edx,%eax
  108a67:	c1 e8 04             	shr    $0x4,%eax
  108a6a:	09 d8                	or     %ebx,%eax
  108a6c:	c1 e8 08             	shr    $0x8,%eax
  108a6f:	89 cb                	mov    %ecx,%ebx
  108a71:	09 c3                	or     %eax,%ebx
  108a73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108a76:	d1 e8                	shr    %eax
  108a78:	0b 45 dc             	or     -0x24(%ebp),%eax
  108a7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108a7e:	d1 ea                	shr    %edx
  108a80:	0b 55 dc             	or     -0x24(%ebp),%edx
  108a83:	c1 ea 02             	shr    $0x2,%edx
  108a86:	09 d0                	or     %edx,%eax
  108a88:	89 c1                	mov    %eax,%ecx
  108a8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108a8d:	d1 e8                	shr    %eax
  108a8f:	0b 45 dc             	or     -0x24(%ebp),%eax
  108a92:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108a95:	d1 ea                	shr    %edx
  108a97:	0b 55 dc             	or     -0x24(%ebp),%edx
  108a9a:	c1 ea 02             	shr    $0x2,%edx
  108a9d:	09 d0                	or     %edx,%eax
  108a9f:	c1 e8 04             	shr    $0x4,%eax
  108aa2:	09 c1                	or     %eax,%ecx
  108aa4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108aa7:	d1 e8                	shr    %eax
  108aa9:	0b 45 dc             	or     -0x24(%ebp),%eax
  108aac:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108aaf:	d1 ea                	shr    %edx
  108ab1:	0b 55 dc             	or     -0x24(%ebp),%edx
  108ab4:	c1 ea 02             	shr    $0x2,%edx
  108ab7:	09 d0                	or     %edx,%eax
  108ab9:	89 c6                	mov    %eax,%esi
  108abb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108abe:	d1 e8                	shr    %eax
  108ac0:	0b 45 dc             	or     -0x24(%ebp),%eax
  108ac3:	89 c2                	mov    %eax,%edx
  108ac5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108ac8:	d1 e8                	shr    %eax
  108aca:	0b 45 dc             	or     -0x24(%ebp),%eax
  108acd:	c1 e8 02             	shr    $0x2,%eax
  108ad0:	09 d0                	or     %edx,%eax
  108ad2:	c1 e8 04             	shr    $0x4,%eax
  108ad5:	09 f0                	or     %esi,%eax
  108ad7:	c1 e8 08             	shr    $0x8,%eax
  108ada:	09 c8                	or     %ecx,%eax
  108adc:	c1 e8 10             	shr    $0x10,%eax
  108adf:	09 d8                	or     %ebx,%eax
  108ae1:	d1 e8                	shr    %eax
  108ae3:	23 45 dc             	and    -0x24(%ebp),%eax
  108ae6:	85 c0                	test   %eax,%eax
  108ae8:	0f 84 e2 00 00 00    	je     108bd0 <segment_check+0x205>
  108aee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108af1:	d1 e8                	shr    %eax
  108af3:	0b 45 dc             	or     -0x24(%ebp),%eax
  108af6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108af9:	d1 ea                	shr    %edx
  108afb:	0b 55 dc             	or     -0x24(%ebp),%edx
  108afe:	c1 ea 02             	shr    $0x2,%edx
  108b01:	09 d0                	or     %edx,%eax
  108b03:	89 c1                	mov    %eax,%ecx
  108b05:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108b08:	d1 e8                	shr    %eax
  108b0a:	0b 45 dc             	or     -0x24(%ebp),%eax
  108b0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108b10:	d1 ea                	shr    %edx
  108b12:	0b 55 dc             	or     -0x24(%ebp),%edx
  108b15:	c1 ea 02             	shr    $0x2,%edx
  108b18:	09 d0                	or     %edx,%eax
  108b1a:	c1 e8 04             	shr    $0x4,%eax
  108b1d:	09 c1                	or     %eax,%ecx
  108b1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108b22:	d1 e8                	shr    %eax
  108b24:	0b 45 dc             	or     -0x24(%ebp),%eax
  108b27:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108b2a:	d1 ea                	shr    %edx
  108b2c:	0b 55 dc             	or     -0x24(%ebp),%edx
  108b2f:	c1 ea 02             	shr    $0x2,%edx
  108b32:	09 d0                	or     %edx,%eax
  108b34:	89 c3                	mov    %eax,%ebx
  108b36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108b39:	d1 e8                	shr    %eax
  108b3b:	0b 45 dc             	or     -0x24(%ebp),%eax
  108b3e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108b41:	d1 ea                	shr    %edx
  108b43:	0b 55 dc             	or     -0x24(%ebp),%edx
  108b46:	c1 ea 02             	shr    $0x2,%edx
  108b49:	09 d0                	or     %edx,%eax
  108b4b:	c1 e8 04             	shr    $0x4,%eax
  108b4e:	09 d8                	or     %ebx,%eax
  108b50:	c1 e8 08             	shr    $0x8,%eax
  108b53:	89 cb                	mov    %ecx,%ebx
  108b55:	09 c3                	or     %eax,%ebx
  108b57:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108b5a:	d1 e8                	shr    %eax
  108b5c:	0b 45 dc             	or     -0x24(%ebp),%eax
  108b5f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108b62:	d1 ea                	shr    %edx
  108b64:	0b 55 dc             	or     -0x24(%ebp),%edx
  108b67:	c1 ea 02             	shr    $0x2,%edx
  108b6a:	09 d0                	or     %edx,%eax
  108b6c:	89 c1                	mov    %eax,%ecx
  108b6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108b71:	d1 e8                	shr    %eax
  108b73:	0b 45 dc             	or     -0x24(%ebp),%eax
  108b76:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108b79:	d1 ea                	shr    %edx
  108b7b:	0b 55 dc             	or     -0x24(%ebp),%edx
  108b7e:	c1 ea 02             	shr    $0x2,%edx
  108b81:	09 d0                	or     %edx,%eax
  108b83:	c1 e8 04             	shr    $0x4,%eax
  108b86:	09 c1                	or     %eax,%ecx
  108b88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108b8b:	d1 e8                	shr    %eax
  108b8d:	0b 45 dc             	or     -0x24(%ebp),%eax
  108b90:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108b93:	d1 ea                	shr    %edx
  108b95:	0b 55 dc             	or     -0x24(%ebp),%edx
  108b98:	c1 ea 02             	shr    $0x2,%edx
  108b9b:	09 d0                	or     %edx,%eax
  108b9d:	89 c6                	mov    %eax,%esi
  108b9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108ba2:	d1 e8                	shr    %eax
  108ba4:	0b 45 dc             	or     -0x24(%ebp),%eax
  108ba7:	89 c2                	mov    %eax,%edx
  108ba9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  108bac:	d1 e8                	shr    %eax
  108bae:	0b 45 dc             	or     -0x24(%ebp),%eax
  108bb1:	c1 e8 02             	shr    $0x2,%eax
  108bb4:	09 d0                	or     %edx,%eax
  108bb6:	c1 e8 04             	shr    $0x4,%eax
  108bb9:	09 f0                	or     %esi,%eax
  108bbb:	c1 e8 08             	shr    $0x8,%eax
  108bbe:	09 c8                	or     %ecx,%eax
  108bc0:	c1 e8 10             	shr    $0x10,%eax
  108bc3:	09 d8                	or     %ebx,%eax
  108bc5:	d1 e8                	shr    %eax
  108bc7:	f7 d0                	not    %eax
  108bc9:	23 45 dc             	and    -0x24(%ebp),%eax
  108bcc:	89 c6                	mov    %eax,%esi
  108bce:	eb 03                	jmp    108bd3 <segment_check+0x208>
  108bd0:	8b 75 dc             	mov    -0x24(%ebp),%esi
  108bd3:	89 f8                	mov    %edi,%eax
  108bd5:	ba 00 00 00 00       	mov    $0x0,%edx
  108bda:	f7 f6                	div    %esi
  108bdc:	39 45 c4             	cmp    %eax,-0x3c(%ebp)
  108bdf:	0f 85 d2 01 00 00    	jne    108db7 <segment_check+0x3ec>
            total += BUDDY_LENGTH(block);
  108be5:	a1 10 3f 12 00       	mov    0x123f10,%eax
  108bea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108bed:	d1 ea                	shr    %edx
  108bef:	0b 55 dc             	or     -0x24(%ebp),%edx
  108bf2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108bf5:	d1 e9                	shr    %ecx
  108bf7:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108bfa:	c1 e9 02             	shr    $0x2,%ecx
  108bfd:	89 d3                	mov    %edx,%ebx
  108bff:	09 cb                	or     %ecx,%ebx
  108c01:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108c04:	d1 ea                	shr    %edx
  108c06:	0b 55 dc             	or     -0x24(%ebp),%edx
  108c09:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108c0c:	d1 e9                	shr    %ecx
  108c0e:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108c11:	c1 e9 02             	shr    $0x2,%ecx
  108c14:	09 ca                	or     %ecx,%edx
  108c16:	c1 ea 04             	shr    $0x4,%edx
  108c19:	09 d3                	or     %edx,%ebx
  108c1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108c1e:	d1 ea                	shr    %edx
  108c20:	0b 55 dc             	or     -0x24(%ebp),%edx
  108c23:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108c26:	d1 e9                	shr    %ecx
  108c28:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108c2b:	c1 e9 02             	shr    $0x2,%ecx
  108c2e:	89 d6                	mov    %edx,%esi
  108c30:	09 ce                	or     %ecx,%esi
  108c32:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108c35:	d1 ea                	shr    %edx
  108c37:	0b 55 dc             	or     -0x24(%ebp),%edx
  108c3a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108c3d:	d1 e9                	shr    %ecx
  108c3f:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108c42:	c1 e9 02             	shr    $0x2,%ecx
  108c45:	09 ca                	or     %ecx,%edx
  108c47:	c1 ea 04             	shr    $0x4,%edx
  108c4a:	09 f2                	or     %esi,%edx
  108c4c:	c1 ea 08             	shr    $0x8,%edx
  108c4f:	09 d3                	or     %edx,%ebx
  108c51:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108c54:	d1 ea                	shr    %edx
  108c56:	0b 55 dc             	or     -0x24(%ebp),%edx
  108c59:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108c5c:	d1 e9                	shr    %ecx
  108c5e:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108c61:	c1 e9 02             	shr    $0x2,%ecx
  108c64:	89 d6                	mov    %edx,%esi
  108c66:	09 ce                	or     %ecx,%esi
  108c68:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108c6b:	d1 ea                	shr    %edx
  108c6d:	0b 55 dc             	or     -0x24(%ebp),%edx
  108c70:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108c73:	d1 e9                	shr    %ecx
  108c75:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108c78:	c1 e9 02             	shr    $0x2,%ecx
  108c7b:	09 ca                	or     %ecx,%edx
  108c7d:	c1 ea 04             	shr    $0x4,%edx
  108c80:	09 d6                	or     %edx,%esi
  108c82:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108c85:	d1 ea                	shr    %edx
  108c87:	0b 55 dc             	or     -0x24(%ebp),%edx
  108c8a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108c8d:	d1 e9                	shr    %ecx
  108c8f:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108c92:	c1 e9 02             	shr    $0x2,%ecx
  108c95:	89 d7                	mov    %edx,%edi
  108c97:	09 cf                	or     %ecx,%edi
  108c99:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108c9c:	d1 ea                	shr    %edx
  108c9e:	0b 55 dc             	or     -0x24(%ebp),%edx
  108ca1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108ca4:	d1 e9                	shr    %ecx
  108ca6:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108ca9:	c1 e9 02             	shr    $0x2,%ecx
  108cac:	09 ca                	or     %ecx,%edx
  108cae:	c1 ea 04             	shr    $0x4,%edx
  108cb1:	09 fa                	or     %edi,%edx
  108cb3:	c1 ea 08             	shr    $0x8,%edx
  108cb6:	09 f2                	or     %esi,%edx
  108cb8:	c1 ea 10             	shr    $0x10,%edx
  108cbb:	09 da                	or     %ebx,%edx
  108cbd:	d1 ea                	shr    %edx
  108cbf:	23 55 dc             	and    -0x24(%ebp),%edx
  108cc2:	85 d2                	test   %edx,%edx
  108cc4:	0f 84 de 00 00 00    	je     108da8 <segment_check+0x3dd>
  108cca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108ccd:	d1 ea                	shr    %edx
  108ccf:	0b 55 dc             	or     -0x24(%ebp),%edx
  108cd2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108cd5:	d1 e9                	shr    %ecx
  108cd7:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108cda:	c1 e9 02             	shr    $0x2,%ecx
  108cdd:	89 d3                	mov    %edx,%ebx
  108cdf:	09 cb                	or     %ecx,%ebx
  108ce1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108ce4:	d1 ea                	shr    %edx
  108ce6:	0b 55 dc             	or     -0x24(%ebp),%edx
  108ce9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108cec:	d1 e9                	shr    %ecx
  108cee:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108cf1:	c1 e9 02             	shr    $0x2,%ecx
  108cf4:	09 ca                	or     %ecx,%edx
  108cf6:	c1 ea 04             	shr    $0x4,%edx
  108cf9:	09 d3                	or     %edx,%ebx
  108cfb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108cfe:	d1 ea                	shr    %edx
  108d00:	0b 55 dc             	or     -0x24(%ebp),%edx
  108d03:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108d06:	d1 e9                	shr    %ecx
  108d08:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108d0b:	c1 e9 02             	shr    $0x2,%ecx
  108d0e:	89 d6                	mov    %edx,%esi
  108d10:	09 ce                	or     %ecx,%esi
  108d12:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108d15:	d1 ea                	shr    %edx
  108d17:	0b 55 dc             	or     -0x24(%ebp),%edx
  108d1a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108d1d:	d1 e9                	shr    %ecx
  108d1f:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108d22:	c1 e9 02             	shr    $0x2,%ecx
  108d25:	09 ca                	or     %ecx,%edx
  108d27:	c1 ea 04             	shr    $0x4,%edx
  108d2a:	09 f2                	or     %esi,%edx
  108d2c:	c1 ea 08             	shr    $0x8,%edx
  108d2f:	09 d3                	or     %edx,%ebx
  108d31:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108d34:	d1 ea                	shr    %edx
  108d36:	0b 55 dc             	or     -0x24(%ebp),%edx
  108d39:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108d3c:	d1 e9                	shr    %ecx
  108d3e:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108d41:	c1 e9 02             	shr    $0x2,%ecx
  108d44:	89 d6                	mov    %edx,%esi
  108d46:	09 ce                	or     %ecx,%esi
  108d48:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108d4b:	d1 ea                	shr    %edx
  108d4d:	0b 55 dc             	or     -0x24(%ebp),%edx
  108d50:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108d53:	d1 e9                	shr    %ecx
  108d55:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108d58:	c1 e9 02             	shr    $0x2,%ecx
  108d5b:	09 ca                	or     %ecx,%edx
  108d5d:	c1 ea 04             	shr    $0x4,%edx
  108d60:	09 d6                	or     %edx,%esi
  108d62:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108d65:	d1 ea                	shr    %edx
  108d67:	0b 55 dc             	or     -0x24(%ebp),%edx
  108d6a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108d6d:	d1 e9                	shr    %ecx
  108d6f:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108d72:	c1 e9 02             	shr    $0x2,%ecx
  108d75:	89 d7                	mov    %edx,%edi
  108d77:	09 cf                	or     %ecx,%edi
  108d79:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108d7c:	d1 ea                	shr    %edx
  108d7e:	0b 55 dc             	or     -0x24(%ebp),%edx
  108d81:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108d84:	d1 e9                	shr    %ecx
  108d86:	0b 4d dc             	or     -0x24(%ebp),%ecx
  108d89:	c1 e9 02             	shr    $0x2,%ecx
  108d8c:	09 ca                	or     %ecx,%edx
  108d8e:	c1 ea 04             	shr    $0x4,%edx
  108d91:	09 fa                	or     %edi,%edx
  108d93:	c1 ea 08             	shr    $0x8,%edx
  108d96:	09 f2                	or     %esi,%edx
  108d98:	c1 ea 10             	shr    $0x10,%edx
  108d9b:	09 da                	or     %ebx,%edx
  108d9d:	d1 ea                	shr    %edx
  108d9f:	f7 d2                	not    %edx
  108da1:	89 d7                	mov    %edx,%edi
  108da3:	23 7d dc             	and    -0x24(%ebp),%edi
  108da6:	eb 03                	jmp    108dab <segment_check+0x3e0>
  108da8:	8b 7d dc             	mov    -0x24(%ebp),%edi
  108dab:	ba 00 00 00 00       	mov    $0x0,%edx
  108db0:	f7 f7                	div    %edi
  108db2:	01 45 e4             	add    %eax,-0x1c(%ebp)
  108db5:	eb 66                	jmp    108e1d <segment_check+0x452>
        else if (block < buddy_virtual_size)
  108db7:	a1 10 3f 12 00       	mov    0x123f10,%eax
  108dbc:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  108dbf:	73 5c                	jae    108e1d <segment_check+0x452>
            assert(buddy_segment[block] == (buddy_segment[BUDDY_LEFT(block)] | buddy_segment[BUDDY_RIGHT(block)]));
  108dc1:	a1 1c 3f 12 00       	mov    0x123f1c,%eax
  108dc6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  108dc9:	c1 e2 02             	shl    $0x2,%edx
  108dcc:	01 d0                	add    %edx,%eax
  108dce:	8b 00                	mov    (%eax),%eax
  108dd0:	8b 15 1c 3f 12 00    	mov    0x123f1c,%edx
  108dd6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  108dd9:	c1 e1 03             	shl    $0x3,%ecx
  108ddc:	01 ca                	add    %ecx,%edx
  108dde:	8b 0a                	mov    (%edx),%ecx
  108de0:	8b 15 1c 3f 12 00    	mov    0x123f1c,%edx
  108de6:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  108de9:	c1 e3 03             	shl    $0x3,%ebx
  108dec:	83 c3 04             	add    $0x4,%ebx
  108def:	01 da                	add    %ebx,%edx
  108df1:	8b 12                	mov    (%edx),%edx
  108df3:	09 ca                	or     %ecx,%edx
  108df5:	39 d0                	cmp    %edx,%eax
  108df7:	74 24                	je     108e1d <segment_check+0x452>
  108df9:	c7 44 24 0c f0 b3 10 	movl   $0x10b3f0,0xc(%esp)
  108e00:	00 
  108e01:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  108e08:	00 
  108e09:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  108e10:	00 
  108e11:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  108e18:	e8 19 76 ff ff       	call   100436 <__panic>
    for (size_t block = BUDDY_ROOT; block < (buddy_virtual_size<<1); block++)
  108e1d:	ff 45 dc             	incl   -0x24(%ebp)
  108e20:	a1 10 3f 12 00       	mov    0x123f10,%eax
  108e25:	01 c0                	add    %eax,%eax
  108e27:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  108e2a:	0f 82 c2 fb ff ff    	jb     1089f2 <segment_check+0x27>
    assert(total == nr_free_pages());
  108e30:	e8 54 a1 ff ff       	call   102f89 <nr_free_pages>
  108e35:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  108e38:	74 24                	je     108e5e <segment_check+0x493>
  108e3a:	c7 44 24 0c 4f b4 10 	movl   $0x10b44f,0xc(%esp)
  108e41:	00 
  108e42:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  108e49:	00 
  108e4a:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  108e51:	00 
  108e52:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  108e59:	e8 d8 75 ff ff       	call   100436 <__panic>

    // Check free list 
    total = 0, count = 0;
  108e5e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  108e65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    list_entry_t *le = &free_list;
  108e6c:	c7 45 d8 38 3f 12 00 	movl   $0x123f38,-0x28(%ebp)
    while ((le = list_next(le)) != &free_list) {
  108e73:	eb 15                	jmp    108e8a <segment_check+0x4bf>
        struct Page *p = le2page(le, page_link);
  108e75:	8b 45 d8             	mov    -0x28(%ebp),%eax
  108e78:	83 e8 0c             	sub    $0xc,%eax
  108e7b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count ++, total += p->property;
  108e7e:	ff 45 e0             	incl   -0x20(%ebp)
  108e81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  108e84:	8b 40 08             	mov    0x8(%eax),%eax
  108e87:	01 45 e4             	add    %eax,-0x1c(%ebp)
  108e8a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  108e8d:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return listelm->next;
  108e90:	8b 45 d0             	mov    -0x30(%ebp),%eax
  108e93:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  108e96:	89 45 d8             	mov    %eax,-0x28(%ebp)
  108e99:	81 7d d8 38 3f 12 00 	cmpl   $0x123f38,-0x28(%ebp)
  108ea0:	75 d3                	jne    108e75 <segment_check+0x4aa>
    }
    assert(total == nr_free_pages());
  108ea2:	e8 e2 a0 ff ff       	call   102f89 <nr_free_pages>
  108ea7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  108eaa:	74 24                	je     108ed0 <segment_check+0x505>
  108eac:	c7 44 24 0c 4f b4 10 	movl   $0x10b44f,0xc(%esp)
  108eb3:	00 
  108eb4:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  108ebb:	00 
  108ebc:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  108ec3:	00 
  108ec4:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  108ecb:	e8 66 75 ff ff       	call   100436 <__panic>

}
  108ed0:	90                   	nop
  108ed1:	83 c4 4c             	add    $0x4c,%esp
  108ed4:	5b                   	pop    %ebx
  108ed5:	5e                   	pop    %esi
  108ed6:	5f                   	pop    %edi
  108ed7:	5d                   	pop    %ebp
  108ed8:	c3                   	ret    

00108ed9 <alloc_check>:

static void
alloc_check(void) {
  108ed9:	f3 0f 1e fb          	endbr32 
  108edd:	55                   	push   %ebp
  108ede:	89 e5                	mov    %esp,%ebp
  108ee0:	83 ec 58             	sub    $0x58,%esp

    // Build buddy system for test
    size_t buddy_physical_size_store = buddy_physical_size;
  108ee3:	a1 0c 3f 12 00       	mov    0x123f0c,%eax
  108ee8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for (struct Page *p = buddy_physical; p < buddy_physical + 1026; p++)
  108eeb:	a1 20 3f 12 00       	mov    0x123f20,%eax
  108ef0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  108ef3:	eb 1e                	jmp    108f13 <alloc_check+0x3a>
        SetPageReserved(p);
  108ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  108ef8:	83 c0 04             	add    $0x4,%eax
  108efb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  108f02:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  108f05:	8b 45 c8             	mov    -0x38(%ebp),%eax
  108f08:	8b 55 cc             	mov    -0x34(%ebp),%edx
  108f0b:	0f ab 10             	bts    %edx,(%eax)
}
  108f0e:	90                   	nop
    for (struct Page *p = buddy_physical; p < buddy_physical + 1026; p++)
  108f0f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  108f13:	a1 20 3f 12 00       	mov    0x123f20,%eax
  108f18:	05 28 50 00 00       	add    $0x5028,%eax
  108f1d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  108f20:	72 d3                	jb     108ef5 <alloc_check+0x1c>
    buddy_init();
  108f22:	e8 91 d6 ff ff       	call   1065b8 <buddy_init>
    buddy_init_memmap(buddy_physical, 1026);
  108f27:	a1 20 3f 12 00       	mov    0x123f20,%eax
  108f2c:	c7 44 24 04 02 04 00 	movl   $0x402,0x4(%esp)
  108f33:	00 
  108f34:	89 04 24             	mov    %eax,(%esp)
  108f37:	e8 af d6 ff ff       	call   1065eb <buddy_init_memmap>

    // Check allocation
    struct Page *p0, *p1, *p2, *p3;
    p0 = p1 = p2 = NULL;
  108f3c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  108f43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  108f46:	89 45 e0             	mov    %eax,-0x20(%ebp)
  108f49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  108f4c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert((p0 = alloc_page()) != NULL);
  108f4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  108f56:	e8 bb 9f ff ff       	call   102f16 <alloc_pages>
  108f5b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  108f5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  108f62:	75 24                	jne    108f88 <alloc_check+0xaf>
  108f64:	c7 44 24 0c 68 b4 10 	movl   $0x10b468,0xc(%esp)
  108f6b:	00 
  108f6c:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  108f73:	00 
  108f74:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  108f7b:	00 
  108f7c:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  108f83:	e8 ae 74 ff ff       	call   100436 <__panic>
    assert((p1 = alloc_page()) != NULL);
  108f88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  108f8f:	e8 82 9f ff ff       	call   102f16 <alloc_pages>
  108f94:	89 45 e0             	mov    %eax,-0x20(%ebp)
  108f97:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  108f9b:	75 24                	jne    108fc1 <alloc_check+0xe8>
  108f9d:	c7 44 24 0c 84 b4 10 	movl   $0x10b484,0xc(%esp)
  108fa4:	00 
  108fa5:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  108fac:	00 
  108fad:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  108fb4:	00 
  108fb5:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  108fbc:	e8 75 74 ff ff       	call   100436 <__panic>
    assert((p2 = alloc_page()) != NULL);
  108fc1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  108fc8:	e8 49 9f ff ff       	call   102f16 <alloc_pages>
  108fcd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  108fd0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  108fd4:	75 24                	jne    108ffa <alloc_check+0x121>
  108fd6:	c7 44 24 0c a0 b4 10 	movl   $0x10b4a0,0xc(%esp)
  108fdd:	00 
  108fde:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  108fe5:	00 
  108fe6:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  108fed:	00 
  108fee:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  108ff5:	e8 3c 74 ff ff       	call   100436 <__panic>
    assert((p3 = alloc_page()) != NULL);
  108ffa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  109001:	e8 10 9f ff ff       	call   102f16 <alloc_pages>
  109006:	89 45 d8             	mov    %eax,-0x28(%ebp)
  109009:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  10900d:	75 24                	jne    109033 <alloc_check+0x15a>
  10900f:	c7 44 24 0c bc b4 10 	movl   $0x10b4bc,0xc(%esp)
  109016:	00 
  109017:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  10901e:	00 
  10901f:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  109026:	00 
  109027:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  10902e:	e8 03 74 ff ff       	call   100436 <__panic>

    assert(p0 + 1 == p1);
  109033:	8b 45 dc             	mov    -0x24(%ebp),%eax
  109036:	83 c0 14             	add    $0x14,%eax
  109039:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  10903c:	74 24                	je     109062 <alloc_check+0x189>
  10903e:	c7 44 24 0c d8 b4 10 	movl   $0x10b4d8,0xc(%esp)
  109045:	00 
  109046:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  10904d:	00 
  10904e:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
  109055:	00 
  109056:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  10905d:	e8 d4 73 ff ff       	call   100436 <__panic>
    assert(p1 + 1 == p2);
  109062:	8b 45 e0             	mov    -0x20(%ebp),%eax
  109065:	83 c0 14             	add    $0x14,%eax
  109068:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10906b:	74 24                	je     109091 <alloc_check+0x1b8>
  10906d:	c7 44 24 0c e5 b4 10 	movl   $0x10b4e5,0xc(%esp)
  109074:	00 
  109075:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  10907c:	00 
  10907d:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  109084:	00 
  109085:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  10908c:	e8 a5 73 ff ff       	call   100436 <__panic>
    assert(p2 + 1 == p3);
  109091:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  109094:	83 c0 14             	add    $0x14,%eax
  109097:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10909a:	74 24                	je     1090c0 <alloc_check+0x1e7>
  10909c:	c7 44 24 0c f2 b4 10 	movl   $0x10b4f2,0xc(%esp)
  1090a3:	00 
  1090a4:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  1090ab:	00 
  1090ac:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  1090b3:	00 
  1090b4:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  1090bb:	e8 76 73 ff ff       	call   100436 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0 && page_ref(p3) == 0);
  1090c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1090c3:	89 04 24             	mov    %eax,(%esp)
  1090c6:	e8 c6 c7 ff ff       	call   105891 <page_ref>
  1090cb:	85 c0                	test   %eax,%eax
  1090cd:	75 2d                	jne    1090fc <alloc_check+0x223>
  1090cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1090d2:	89 04 24             	mov    %eax,(%esp)
  1090d5:	e8 b7 c7 ff ff       	call   105891 <page_ref>
  1090da:	85 c0                	test   %eax,%eax
  1090dc:	75 1e                	jne    1090fc <alloc_check+0x223>
  1090de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1090e1:	89 04 24             	mov    %eax,(%esp)
  1090e4:	e8 a8 c7 ff ff       	call   105891 <page_ref>
  1090e9:	85 c0                	test   %eax,%eax
  1090eb:	75 0f                	jne    1090fc <alloc_check+0x223>
  1090ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1090f0:	89 04 24             	mov    %eax,(%esp)
  1090f3:	e8 99 c7 ff ff       	call   105891 <page_ref>
  1090f8:	85 c0                	test   %eax,%eax
  1090fa:	74 24                	je     109120 <alloc_check+0x247>
  1090fc:	c7 44 24 0c 00 b5 10 	movl   $0x10b500,0xc(%esp)
  109103:	00 
  109104:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  10910b:	00 
  10910c:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  109113:	00 
  109114:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  10911b:	e8 16 73 ff ff       	call   100436 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  109120:	8b 45 dc             	mov    -0x24(%ebp),%eax
  109123:	89 04 24             	mov    %eax,(%esp)
  109126:	e8 50 c7 ff ff       	call   10587b <page2pa>
  10912b:	8b 15 80 3e 12 00    	mov    0x123e80,%edx
  109131:	c1 e2 0c             	shl    $0xc,%edx
  109134:	39 d0                	cmp    %edx,%eax
  109136:	72 24                	jb     10915c <alloc_check+0x283>
  109138:	c7 44 24 0c 51 b5 10 	movl   $0x10b551,0xc(%esp)
  10913f:	00 
  109140:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  109147:	00 
  109148:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  10914f:	00 
  109150:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  109157:	e8 da 72 ff ff       	call   100436 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  10915c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10915f:	89 04 24             	mov    %eax,(%esp)
  109162:	e8 14 c7 ff ff       	call   10587b <page2pa>
  109167:	8b 15 80 3e 12 00    	mov    0x123e80,%edx
  10916d:	c1 e2 0c             	shl    $0xc,%edx
  109170:	39 d0                	cmp    %edx,%eax
  109172:	72 24                	jb     109198 <alloc_check+0x2bf>
  109174:	c7 44 24 0c 6e b5 10 	movl   $0x10b56e,0xc(%esp)
  10917b:	00 
  10917c:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  109183:	00 
  109184:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
  10918b:	00 
  10918c:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  109193:	e8 9e 72 ff ff       	call   100436 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  109198:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10919b:	89 04 24             	mov    %eax,(%esp)
  10919e:	e8 d8 c6 ff ff       	call   10587b <page2pa>
  1091a3:	8b 15 80 3e 12 00    	mov    0x123e80,%edx
  1091a9:	c1 e2 0c             	shl    $0xc,%edx
  1091ac:	39 d0                	cmp    %edx,%eax
  1091ae:	72 24                	jb     1091d4 <alloc_check+0x2fb>
  1091b0:	c7 44 24 0c 8b b5 10 	movl   $0x10b58b,0xc(%esp)
  1091b7:	00 
  1091b8:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  1091bf:	00 
  1091c0:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
  1091c7:	00 
  1091c8:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  1091cf:	e8 62 72 ff ff       	call   100436 <__panic>
    assert(page2pa(p3) < npage * PGSIZE);
  1091d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1091d7:	89 04 24             	mov    %eax,(%esp)
  1091da:	e8 9c c6 ff ff       	call   10587b <page2pa>
  1091df:	8b 15 80 3e 12 00    	mov    0x123e80,%edx
  1091e5:	c1 e2 0c             	shl    $0xc,%edx
  1091e8:	39 d0                	cmp    %edx,%eax
  1091ea:	72 24                	jb     109210 <alloc_check+0x337>
  1091ec:	c7 44 24 0c a8 b5 10 	movl   $0x10b5a8,0xc(%esp)
  1091f3:	00 
  1091f4:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  1091fb:	00 
  1091fc:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  109203:	00 
  109204:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  10920b:	e8 26 72 ff ff       	call   100436 <__panic>

    list_entry_t *le = &free_list;
  109210:	c7 45 f0 38 3f 12 00 	movl   $0x123f38,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  109217:	eb 3f                	jmp    109258 <alloc_check+0x37f>
        struct Page *p = le2page(le, page_link);
  109219:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10921c:	83 e8 0c             	sub    $0xc,%eax
  10921f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(buddy_alloc_pages(p->property) != NULL);
  109222:	8b 45 d0             	mov    -0x30(%ebp),%eax
  109225:	8b 40 08             	mov    0x8(%eax),%eax
  109228:	89 04 24             	mov    %eax,(%esp)
  10922b:	e8 aa d4 ff ff       	call   1066da <buddy_alloc_pages>
  109230:	85 c0                	test   %eax,%eax
  109232:	75 24                	jne    109258 <alloc_check+0x37f>
  109234:	c7 44 24 0c c8 b5 10 	movl   $0x10b5c8,0xc(%esp)
  10923b:	00 
  10923c:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  109243:	00 
  109244:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
  10924b:	00 
  10924c:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  109253:	e8 de 71 ff ff       	call   100436 <__panic>
  109258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10925b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  10925e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  109261:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  109264:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109267:	81 7d f0 38 3f 12 00 	cmpl   $0x123f38,-0x10(%ebp)
  10926e:	75 a9                	jne    109219 <alloc_check+0x340>
    }

    assert(alloc_page() == NULL);
  109270:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  109277:	e8 9a 9c ff ff       	call   102f16 <alloc_pages>
  10927c:	85 c0                	test   %eax,%eax
  10927e:	74 24                	je     1092a4 <alloc_check+0x3cb>
  109280:	c7 44 24 0c ef b5 10 	movl   $0x10b5ef,0xc(%esp)
  109287:	00 
  109288:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  10928f:	00 
  109290:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
  109297:	00 
  109298:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  10929f:	e8 92 71 ff ff       	call   100436 <__panic>

    // Check release
    free_page(p0);
  1092a4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1092ab:	00 
  1092ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1092af:	89 04 24             	mov    %eax,(%esp)
  1092b2:	e8 9b 9c ff ff       	call   102f52 <free_pages>
    free_page(p1);
  1092b7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1092be:	00 
  1092bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1092c2:	89 04 24             	mov    %eax,(%esp)
  1092c5:	e8 88 9c ff ff       	call   102f52 <free_pages>
    free_page(p2);
  1092ca:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1092d1:	00 
  1092d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1092d5:	89 04 24             	mov    %eax,(%esp)
  1092d8:	e8 75 9c ff ff       	call   102f52 <free_pages>
    assert(nr_free == 3);
  1092dd:	a1 40 3f 12 00       	mov    0x123f40,%eax
  1092e2:	83 f8 03             	cmp    $0x3,%eax
  1092e5:	74 24                	je     10930b <alloc_check+0x432>
  1092e7:	c7 44 24 0c 04 b6 10 	movl   $0x10b604,0xc(%esp)
  1092ee:	00 
  1092ef:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  1092f6:	00 
  1092f7:	c7 44 24 04 44 01 00 	movl   $0x144,0x4(%esp)
  1092fe:	00 
  1092ff:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  109306:	e8 2b 71 ff ff       	call   100436 <__panic>

    assert((p1 = alloc_page()) != NULL);
  10930b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  109312:	e8 ff 9b ff ff       	call   102f16 <alloc_pages>
  109317:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10931a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10931e:	75 24                	jne    109344 <alloc_check+0x46b>
  109320:	c7 44 24 0c 84 b4 10 	movl   $0x10b484,0xc(%esp)
  109327:	00 
  109328:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  10932f:	00 
  109330:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
  109337:	00 
  109338:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  10933f:	e8 f2 70 ff ff       	call   100436 <__panic>
    assert((p0 = alloc_pages(2)) != NULL);
  109344:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10934b:	e8 c6 9b ff ff       	call   102f16 <alloc_pages>
  109350:	89 45 dc             	mov    %eax,-0x24(%ebp)
  109353:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  109357:	75 24                	jne    10937d <alloc_check+0x4a4>
  109359:	c7 44 24 0c 11 b6 10 	movl   $0x10b611,0xc(%esp)
  109360:	00 
  109361:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  109368:	00 
  109369:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
  109370:	00 
  109371:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  109378:	e8 b9 70 ff ff       	call   100436 <__panic>
    assert(p0 + 2 == p1);
  10937d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  109380:	83 c0 28             	add    $0x28,%eax
  109383:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  109386:	74 24                	je     1093ac <alloc_check+0x4d3>
  109388:	c7 44 24 0c 2f b6 10 	movl   $0x10b62f,0xc(%esp)
  10938f:	00 
  109390:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  109397:	00 
  109398:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
  10939f:	00 
  1093a0:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  1093a7:	e8 8a 70 ff ff       	call   100436 <__panic>

    assert(alloc_page() == NULL);
  1093ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1093b3:	e8 5e 9b ff ff       	call   102f16 <alloc_pages>
  1093b8:	85 c0                	test   %eax,%eax
  1093ba:	74 24                	je     1093e0 <alloc_check+0x507>
  1093bc:	c7 44 24 0c ef b5 10 	movl   $0x10b5ef,0xc(%esp)
  1093c3:	00 
  1093c4:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  1093cb:	00 
  1093cc:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
  1093d3:	00 
  1093d4:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  1093db:	e8 56 70 ff ff       	call   100436 <__panic>

    free_pages(p0, 2);
  1093e0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1093e7:	00 
  1093e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1093eb:	89 04 24             	mov    %eax,(%esp)
  1093ee:	e8 5f 9b ff ff       	call   102f52 <free_pages>
    free_page(p1);
  1093f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1093fa:	00 
  1093fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1093fe:	89 04 24             	mov    %eax,(%esp)
  109401:	e8 4c 9b ff ff       	call   102f52 <free_pages>
    free_page(p3);
  109406:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10940d:	00 
  10940e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  109411:	89 04 24             	mov    %eax,(%esp)
  109414:	e8 39 9b ff ff       	call   102f52 <free_pages>

    struct Page *p;
    assert((p = alloc_pages(4)) == p0);
  109419:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  109420:	e8 f1 9a ff ff       	call   102f16 <alloc_pages>
  109425:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  109428:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10942b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10942e:	74 24                	je     109454 <alloc_check+0x57b>
  109430:	c7 44 24 0c 3c b6 10 	movl   $0x10b63c,0xc(%esp)
  109437:	00 
  109438:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  10943f:	00 
  109440:	c7 44 24 04 51 01 00 	movl   $0x151,0x4(%esp)
  109447:	00 
  109448:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  10944f:	e8 e2 6f ff ff       	call   100436 <__panic>
    assert(alloc_page() == NULL);
  109454:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10945b:	e8 b6 9a ff ff       	call   102f16 <alloc_pages>
  109460:	85 c0                	test   %eax,%eax
  109462:	74 24                	je     109488 <alloc_check+0x5af>
  109464:	c7 44 24 0c ef b5 10 	movl   $0x10b5ef,0xc(%esp)
  10946b:	00 
  10946c:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  109473:	00 
  109474:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
  10947b:	00 
  10947c:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  109483:	e8 ae 6f ff ff       	call   100436 <__panic>

    assert(nr_free == 0);
  109488:	a1 40 3f 12 00       	mov    0x123f40,%eax
  10948d:	85 c0                	test   %eax,%eax
  10948f:	74 24                	je     1094b5 <alloc_check+0x5dc>
  109491:	c7 44 24 0c 57 b6 10 	movl   $0x10b657,0xc(%esp)
  109498:	00 
  109499:	c7 44 24 08 be b2 10 	movl   $0x10b2be,0x8(%esp)
  1094a0:	00 
  1094a1:	c7 44 24 04 54 01 00 	movl   $0x154,0x4(%esp)
  1094a8:	00 
  1094a9:	c7 04 24 d3 b2 10 00 	movl   $0x10b2d3,(%esp)
  1094b0:	e8 81 6f ff ff       	call   100436 <__panic>

    // Restore buddy system
    for (struct Page *p = buddy_physical; p < buddy_physical + buddy_physical_size_store; p++)
  1094b5:	a1 20 3f 12 00       	mov    0x123f20,%eax
  1094ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1094bd:	eb 1e                	jmp    1094dd <alloc_check+0x604>
        SetPageReserved(p);
  1094bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1094c2:	83 c0 04             	add    $0x4,%eax
  1094c5:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  1094cc:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1094cf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1094d2:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1094d5:	0f ab 10             	bts    %edx,(%eax)
}
  1094d8:	90                   	nop
    for (struct Page *p = buddy_physical; p < buddy_physical + buddy_physical_size_store; p++)
  1094d9:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  1094dd:	8b 0d 20 3f 12 00    	mov    0x123f20,%ecx
  1094e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1094e6:	89 d0                	mov    %edx,%eax
  1094e8:	c1 e0 02             	shl    $0x2,%eax
  1094eb:	01 d0                	add    %edx,%eax
  1094ed:	c1 e0 02             	shl    $0x2,%eax
  1094f0:	01 c8                	add    %ecx,%eax
  1094f2:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1094f5:	72 c8                	jb     1094bf <alloc_check+0x5e6>
    buddy_init();
  1094f7:	e8 bc d0 ff ff       	call   1065b8 <buddy_init>
    buddy_init_memmap(buddy_physical, buddy_physical_size_store);
  1094fc:	a1 20 3f 12 00       	mov    0x123f20,%eax
  109501:	8b 55 e8             	mov    -0x18(%ebp),%edx
  109504:	89 54 24 04          	mov    %edx,0x4(%esp)
  109508:	89 04 24             	mov    %eax,(%esp)
  10950b:	e8 db d0 ff ff       	call   1065eb <buddy_init_memmap>

}
  109510:	90                   	nop
  109511:	c9                   	leave  
  109512:	c3                   	ret    

00109513 <default_check>:

static void
default_check(void) {
  109513:	f3 0f 1e fb          	endbr32 
  109517:	55                   	push   %ebp
  109518:	89 e5                	mov    %esp,%ebp
  10951a:	83 ec 08             	sub    $0x8,%esp

    // Check buddy system
    macro_check();
  10951d:	e8 0b f2 ff ff       	call   10872d <macro_check>
    size_check();
  109522:	e8 58 f3 ff ff       	call   10887f <size_check>
    segment_check();
  109527:	e8 9f f4 ff ff       	call   1089cb <segment_check>
    alloc_check();
  10952c:	e8 a8 f9 ff ff       	call   108ed9 <alloc_check>
    
}
  109531:	90                   	nop
  109532:	c9                   	leave  
  109533:	c3                   	ret    

00109534 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  109534:	f3 0f 1e fb          	endbr32 
  109538:	55                   	push   %ebp
  109539:	89 e5                	mov    %esp,%ebp
  10953b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10953e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  109545:	eb 03                	jmp    10954a <strlen+0x16>
        cnt ++;
  109547:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  10954a:	8b 45 08             	mov    0x8(%ebp),%eax
  10954d:	8d 50 01             	lea    0x1(%eax),%edx
  109550:	89 55 08             	mov    %edx,0x8(%ebp)
  109553:	0f b6 00             	movzbl (%eax),%eax
  109556:	84 c0                	test   %al,%al
  109558:	75 ed                	jne    109547 <strlen+0x13>
    }
    return cnt;
  10955a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10955d:	c9                   	leave  
  10955e:	c3                   	ret    

0010955f <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10955f:	f3 0f 1e fb          	endbr32 
  109563:	55                   	push   %ebp
  109564:	89 e5                	mov    %esp,%ebp
  109566:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  109569:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  109570:	eb 03                	jmp    109575 <strnlen+0x16>
        cnt ++;
  109572:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  109575:	8b 45 fc             	mov    -0x4(%ebp),%eax
  109578:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10957b:	73 10                	jae    10958d <strnlen+0x2e>
  10957d:	8b 45 08             	mov    0x8(%ebp),%eax
  109580:	8d 50 01             	lea    0x1(%eax),%edx
  109583:	89 55 08             	mov    %edx,0x8(%ebp)
  109586:	0f b6 00             	movzbl (%eax),%eax
  109589:	84 c0                	test   %al,%al
  10958b:	75 e5                	jne    109572 <strnlen+0x13>
    }
    return cnt;
  10958d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  109590:	c9                   	leave  
  109591:	c3                   	ret    

00109592 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  109592:	f3 0f 1e fb          	endbr32 
  109596:	55                   	push   %ebp
  109597:	89 e5                	mov    %esp,%ebp
  109599:	57                   	push   %edi
  10959a:	56                   	push   %esi
  10959b:	83 ec 20             	sub    $0x20,%esp
  10959e:	8b 45 08             	mov    0x8(%ebp),%eax
  1095a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1095a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1095a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1095aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1095ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1095b0:	89 d1                	mov    %edx,%ecx
  1095b2:	89 c2                	mov    %eax,%edx
  1095b4:	89 ce                	mov    %ecx,%esi
  1095b6:	89 d7                	mov    %edx,%edi
  1095b8:	ac                   	lods   %ds:(%esi),%al
  1095b9:	aa                   	stos   %al,%es:(%edi)
  1095ba:	84 c0                	test   %al,%al
  1095bc:	75 fa                	jne    1095b8 <strcpy+0x26>
  1095be:	89 fa                	mov    %edi,%edx
  1095c0:	89 f1                	mov    %esi,%ecx
  1095c2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1095c5:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1095c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  1095cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1095ce:	83 c4 20             	add    $0x20,%esp
  1095d1:	5e                   	pop    %esi
  1095d2:	5f                   	pop    %edi
  1095d3:	5d                   	pop    %ebp
  1095d4:	c3                   	ret    

001095d5 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1095d5:	f3 0f 1e fb          	endbr32 
  1095d9:	55                   	push   %ebp
  1095da:	89 e5                	mov    %esp,%ebp
  1095dc:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1095df:	8b 45 08             	mov    0x8(%ebp),%eax
  1095e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1095e5:	eb 1e                	jmp    109605 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  1095e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1095ea:	0f b6 10             	movzbl (%eax),%edx
  1095ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1095f0:	88 10                	mov    %dl,(%eax)
  1095f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1095f5:	0f b6 00             	movzbl (%eax),%eax
  1095f8:	84 c0                	test   %al,%al
  1095fa:	74 03                	je     1095ff <strncpy+0x2a>
            src ++;
  1095fc:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  1095ff:	ff 45 fc             	incl   -0x4(%ebp)
  109602:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  109605:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  109609:	75 dc                	jne    1095e7 <strncpy+0x12>
    }
    return dst;
  10960b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10960e:	c9                   	leave  
  10960f:	c3                   	ret    

00109610 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  109610:	f3 0f 1e fb          	endbr32 
  109614:	55                   	push   %ebp
  109615:	89 e5                	mov    %esp,%ebp
  109617:	57                   	push   %edi
  109618:	56                   	push   %esi
  109619:	83 ec 20             	sub    $0x20,%esp
  10961c:	8b 45 08             	mov    0x8(%ebp),%eax
  10961f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  109622:	8b 45 0c             	mov    0xc(%ebp),%eax
  109625:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  109628:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10962b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10962e:	89 d1                	mov    %edx,%ecx
  109630:	89 c2                	mov    %eax,%edx
  109632:	89 ce                	mov    %ecx,%esi
  109634:	89 d7                	mov    %edx,%edi
  109636:	ac                   	lods   %ds:(%esi),%al
  109637:	ae                   	scas   %es:(%edi),%al
  109638:	75 08                	jne    109642 <strcmp+0x32>
  10963a:	84 c0                	test   %al,%al
  10963c:	75 f8                	jne    109636 <strcmp+0x26>
  10963e:	31 c0                	xor    %eax,%eax
  109640:	eb 04                	jmp    109646 <strcmp+0x36>
  109642:	19 c0                	sbb    %eax,%eax
  109644:	0c 01                	or     $0x1,%al
  109646:	89 fa                	mov    %edi,%edx
  109648:	89 f1                	mov    %esi,%ecx
  10964a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10964d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  109650:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  109653:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  109656:	83 c4 20             	add    $0x20,%esp
  109659:	5e                   	pop    %esi
  10965a:	5f                   	pop    %edi
  10965b:	5d                   	pop    %ebp
  10965c:	c3                   	ret    

0010965d <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10965d:	f3 0f 1e fb          	endbr32 
  109661:	55                   	push   %ebp
  109662:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  109664:	eb 09                	jmp    10966f <strncmp+0x12>
        n --, s1 ++, s2 ++;
  109666:	ff 4d 10             	decl   0x10(%ebp)
  109669:	ff 45 08             	incl   0x8(%ebp)
  10966c:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10966f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  109673:	74 1a                	je     10968f <strncmp+0x32>
  109675:	8b 45 08             	mov    0x8(%ebp),%eax
  109678:	0f b6 00             	movzbl (%eax),%eax
  10967b:	84 c0                	test   %al,%al
  10967d:	74 10                	je     10968f <strncmp+0x32>
  10967f:	8b 45 08             	mov    0x8(%ebp),%eax
  109682:	0f b6 10             	movzbl (%eax),%edx
  109685:	8b 45 0c             	mov    0xc(%ebp),%eax
  109688:	0f b6 00             	movzbl (%eax),%eax
  10968b:	38 c2                	cmp    %al,%dl
  10968d:	74 d7                	je     109666 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10968f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  109693:	74 18                	je     1096ad <strncmp+0x50>
  109695:	8b 45 08             	mov    0x8(%ebp),%eax
  109698:	0f b6 00             	movzbl (%eax),%eax
  10969b:	0f b6 d0             	movzbl %al,%edx
  10969e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1096a1:	0f b6 00             	movzbl (%eax),%eax
  1096a4:	0f b6 c0             	movzbl %al,%eax
  1096a7:	29 c2                	sub    %eax,%edx
  1096a9:	89 d0                	mov    %edx,%eax
  1096ab:	eb 05                	jmp    1096b2 <strncmp+0x55>
  1096ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1096b2:	5d                   	pop    %ebp
  1096b3:	c3                   	ret    

001096b4 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1096b4:	f3 0f 1e fb          	endbr32 
  1096b8:	55                   	push   %ebp
  1096b9:	89 e5                	mov    %esp,%ebp
  1096bb:	83 ec 04             	sub    $0x4,%esp
  1096be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1096c1:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1096c4:	eb 13                	jmp    1096d9 <strchr+0x25>
        if (*s == c) {
  1096c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1096c9:	0f b6 00             	movzbl (%eax),%eax
  1096cc:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1096cf:	75 05                	jne    1096d6 <strchr+0x22>
            return (char *)s;
  1096d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1096d4:	eb 12                	jmp    1096e8 <strchr+0x34>
        }
        s ++;
  1096d6:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1096d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1096dc:	0f b6 00             	movzbl (%eax),%eax
  1096df:	84 c0                	test   %al,%al
  1096e1:	75 e3                	jne    1096c6 <strchr+0x12>
    }
    return NULL;
  1096e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1096e8:	c9                   	leave  
  1096e9:	c3                   	ret    

001096ea <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1096ea:	f3 0f 1e fb          	endbr32 
  1096ee:	55                   	push   %ebp
  1096ef:	89 e5                	mov    %esp,%ebp
  1096f1:	83 ec 04             	sub    $0x4,%esp
  1096f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1096f7:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1096fa:	eb 0e                	jmp    10970a <strfind+0x20>
        if (*s == c) {
  1096fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1096ff:	0f b6 00             	movzbl (%eax),%eax
  109702:	38 45 fc             	cmp    %al,-0x4(%ebp)
  109705:	74 0f                	je     109716 <strfind+0x2c>
            break;
        }
        s ++;
  109707:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10970a:	8b 45 08             	mov    0x8(%ebp),%eax
  10970d:	0f b6 00             	movzbl (%eax),%eax
  109710:	84 c0                	test   %al,%al
  109712:	75 e8                	jne    1096fc <strfind+0x12>
  109714:	eb 01                	jmp    109717 <strfind+0x2d>
            break;
  109716:	90                   	nop
    }
    return (char *)s;
  109717:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10971a:	c9                   	leave  
  10971b:	c3                   	ret    

0010971c <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10971c:	f3 0f 1e fb          	endbr32 
  109720:	55                   	push   %ebp
  109721:	89 e5                	mov    %esp,%ebp
  109723:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  109726:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  10972d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  109734:	eb 03                	jmp    109739 <strtol+0x1d>
        s ++;
  109736:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  109739:	8b 45 08             	mov    0x8(%ebp),%eax
  10973c:	0f b6 00             	movzbl (%eax),%eax
  10973f:	3c 20                	cmp    $0x20,%al
  109741:	74 f3                	je     109736 <strtol+0x1a>
  109743:	8b 45 08             	mov    0x8(%ebp),%eax
  109746:	0f b6 00             	movzbl (%eax),%eax
  109749:	3c 09                	cmp    $0x9,%al
  10974b:	74 e9                	je     109736 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  10974d:	8b 45 08             	mov    0x8(%ebp),%eax
  109750:	0f b6 00             	movzbl (%eax),%eax
  109753:	3c 2b                	cmp    $0x2b,%al
  109755:	75 05                	jne    10975c <strtol+0x40>
        s ++;
  109757:	ff 45 08             	incl   0x8(%ebp)
  10975a:	eb 14                	jmp    109770 <strtol+0x54>
    }
    else if (*s == '-') {
  10975c:	8b 45 08             	mov    0x8(%ebp),%eax
  10975f:	0f b6 00             	movzbl (%eax),%eax
  109762:	3c 2d                	cmp    $0x2d,%al
  109764:	75 0a                	jne    109770 <strtol+0x54>
        s ++, neg = 1;
  109766:	ff 45 08             	incl   0x8(%ebp)
  109769:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  109770:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  109774:	74 06                	je     10977c <strtol+0x60>
  109776:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10977a:	75 22                	jne    10979e <strtol+0x82>
  10977c:	8b 45 08             	mov    0x8(%ebp),%eax
  10977f:	0f b6 00             	movzbl (%eax),%eax
  109782:	3c 30                	cmp    $0x30,%al
  109784:	75 18                	jne    10979e <strtol+0x82>
  109786:	8b 45 08             	mov    0x8(%ebp),%eax
  109789:	40                   	inc    %eax
  10978a:	0f b6 00             	movzbl (%eax),%eax
  10978d:	3c 78                	cmp    $0x78,%al
  10978f:	75 0d                	jne    10979e <strtol+0x82>
        s += 2, base = 16;
  109791:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  109795:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10979c:	eb 29                	jmp    1097c7 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  10979e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1097a2:	75 16                	jne    1097ba <strtol+0x9e>
  1097a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1097a7:	0f b6 00             	movzbl (%eax),%eax
  1097aa:	3c 30                	cmp    $0x30,%al
  1097ac:	75 0c                	jne    1097ba <strtol+0x9e>
        s ++, base = 8;
  1097ae:	ff 45 08             	incl   0x8(%ebp)
  1097b1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1097b8:	eb 0d                	jmp    1097c7 <strtol+0xab>
    }
    else if (base == 0) {
  1097ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1097be:	75 07                	jne    1097c7 <strtol+0xab>
        base = 10;
  1097c0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1097c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1097ca:	0f b6 00             	movzbl (%eax),%eax
  1097cd:	3c 2f                	cmp    $0x2f,%al
  1097cf:	7e 1b                	jle    1097ec <strtol+0xd0>
  1097d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1097d4:	0f b6 00             	movzbl (%eax),%eax
  1097d7:	3c 39                	cmp    $0x39,%al
  1097d9:	7f 11                	jg     1097ec <strtol+0xd0>
            dig = *s - '0';
  1097db:	8b 45 08             	mov    0x8(%ebp),%eax
  1097de:	0f b6 00             	movzbl (%eax),%eax
  1097e1:	0f be c0             	movsbl %al,%eax
  1097e4:	83 e8 30             	sub    $0x30,%eax
  1097e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1097ea:	eb 48                	jmp    109834 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1097ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1097ef:	0f b6 00             	movzbl (%eax),%eax
  1097f2:	3c 60                	cmp    $0x60,%al
  1097f4:	7e 1b                	jle    109811 <strtol+0xf5>
  1097f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1097f9:	0f b6 00             	movzbl (%eax),%eax
  1097fc:	3c 7a                	cmp    $0x7a,%al
  1097fe:	7f 11                	jg     109811 <strtol+0xf5>
            dig = *s - 'a' + 10;
  109800:	8b 45 08             	mov    0x8(%ebp),%eax
  109803:	0f b6 00             	movzbl (%eax),%eax
  109806:	0f be c0             	movsbl %al,%eax
  109809:	83 e8 57             	sub    $0x57,%eax
  10980c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10980f:	eb 23                	jmp    109834 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  109811:	8b 45 08             	mov    0x8(%ebp),%eax
  109814:	0f b6 00             	movzbl (%eax),%eax
  109817:	3c 40                	cmp    $0x40,%al
  109819:	7e 3b                	jle    109856 <strtol+0x13a>
  10981b:	8b 45 08             	mov    0x8(%ebp),%eax
  10981e:	0f b6 00             	movzbl (%eax),%eax
  109821:	3c 5a                	cmp    $0x5a,%al
  109823:	7f 31                	jg     109856 <strtol+0x13a>
            dig = *s - 'A' + 10;
  109825:	8b 45 08             	mov    0x8(%ebp),%eax
  109828:	0f b6 00             	movzbl (%eax),%eax
  10982b:	0f be c0             	movsbl %al,%eax
  10982e:	83 e8 37             	sub    $0x37,%eax
  109831:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  109834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  109837:	3b 45 10             	cmp    0x10(%ebp),%eax
  10983a:	7d 19                	jge    109855 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  10983c:	ff 45 08             	incl   0x8(%ebp)
  10983f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  109842:	0f af 45 10          	imul   0x10(%ebp),%eax
  109846:	89 c2                	mov    %eax,%edx
  109848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10984b:	01 d0                	add    %edx,%eax
  10984d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  109850:	e9 72 ff ff ff       	jmp    1097c7 <strtol+0xab>
            break;
  109855:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  109856:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10985a:	74 08                	je     109864 <strtol+0x148>
        *endptr = (char *) s;
  10985c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10985f:	8b 55 08             	mov    0x8(%ebp),%edx
  109862:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  109864:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  109868:	74 07                	je     109871 <strtol+0x155>
  10986a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10986d:	f7 d8                	neg    %eax
  10986f:	eb 03                	jmp    109874 <strtol+0x158>
  109871:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  109874:	c9                   	leave  
  109875:	c3                   	ret    

00109876 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  109876:	f3 0f 1e fb          	endbr32 
  10987a:	55                   	push   %ebp
  10987b:	89 e5                	mov    %esp,%ebp
  10987d:	57                   	push   %edi
  10987e:	83 ec 24             	sub    $0x24,%esp
  109881:	8b 45 0c             	mov    0xc(%ebp),%eax
  109884:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  109887:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  10988b:	8b 45 08             	mov    0x8(%ebp),%eax
  10988e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  109891:	88 55 f7             	mov    %dl,-0x9(%ebp)
  109894:	8b 45 10             	mov    0x10(%ebp),%eax
  109897:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10989a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10989d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1098a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1098a4:	89 d7                	mov    %edx,%edi
  1098a6:	f3 aa                	rep stos %al,%es:(%edi)
  1098a8:	89 fa                	mov    %edi,%edx
  1098aa:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1098ad:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  1098b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1098b3:	83 c4 24             	add    $0x24,%esp
  1098b6:	5f                   	pop    %edi
  1098b7:	5d                   	pop    %ebp
  1098b8:	c3                   	ret    

001098b9 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1098b9:	f3 0f 1e fb          	endbr32 
  1098bd:	55                   	push   %ebp
  1098be:	89 e5                	mov    %esp,%ebp
  1098c0:	57                   	push   %edi
  1098c1:	56                   	push   %esi
  1098c2:	53                   	push   %ebx
  1098c3:	83 ec 30             	sub    $0x30,%esp
  1098c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1098c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1098cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1098cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1098d2:	8b 45 10             	mov    0x10(%ebp),%eax
  1098d5:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1098d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1098db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1098de:	73 42                	jae    109922 <memmove+0x69>
  1098e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1098e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1098e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1098e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1098ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1098ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1098f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1098f5:	c1 e8 02             	shr    $0x2,%eax
  1098f8:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1098fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1098fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  109900:	89 d7                	mov    %edx,%edi
  109902:	89 c6                	mov    %eax,%esi
  109904:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  109906:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  109909:	83 e1 03             	and    $0x3,%ecx
  10990c:	74 02                	je     109910 <memmove+0x57>
  10990e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  109910:	89 f0                	mov    %esi,%eax
  109912:	89 fa                	mov    %edi,%edx
  109914:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  109917:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10991a:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  10991d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  109920:	eb 36                	jmp    109958 <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  109922:	8b 45 e8             	mov    -0x18(%ebp),%eax
  109925:	8d 50 ff             	lea    -0x1(%eax),%edx
  109928:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10992b:	01 c2                	add    %eax,%edx
  10992d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  109930:	8d 48 ff             	lea    -0x1(%eax),%ecx
  109933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  109936:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  109939:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10993c:	89 c1                	mov    %eax,%ecx
  10993e:	89 d8                	mov    %ebx,%eax
  109940:	89 d6                	mov    %edx,%esi
  109942:	89 c7                	mov    %eax,%edi
  109944:	fd                   	std    
  109945:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  109947:	fc                   	cld    
  109948:	89 f8                	mov    %edi,%eax
  10994a:	89 f2                	mov    %esi,%edx
  10994c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10994f:	89 55 c8             	mov    %edx,-0x38(%ebp)
  109952:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  109955:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  109958:	83 c4 30             	add    $0x30,%esp
  10995b:	5b                   	pop    %ebx
  10995c:	5e                   	pop    %esi
  10995d:	5f                   	pop    %edi
  10995e:	5d                   	pop    %ebp
  10995f:	c3                   	ret    

00109960 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  109960:	f3 0f 1e fb          	endbr32 
  109964:	55                   	push   %ebp
  109965:	89 e5                	mov    %esp,%ebp
  109967:	57                   	push   %edi
  109968:	56                   	push   %esi
  109969:	83 ec 20             	sub    $0x20,%esp
  10996c:	8b 45 08             	mov    0x8(%ebp),%eax
  10996f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  109972:	8b 45 0c             	mov    0xc(%ebp),%eax
  109975:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109978:	8b 45 10             	mov    0x10(%ebp),%eax
  10997b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10997e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  109981:	c1 e8 02             	shr    $0x2,%eax
  109984:	89 c1                	mov    %eax,%ecx
    asm volatile (
  109986:	8b 55 f4             	mov    -0xc(%ebp),%edx
  109989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10998c:	89 d7                	mov    %edx,%edi
  10998e:	89 c6                	mov    %eax,%esi
  109990:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  109992:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  109995:	83 e1 03             	and    $0x3,%ecx
  109998:	74 02                	je     10999c <memcpy+0x3c>
  10999a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10999c:	89 f0                	mov    %esi,%eax
  10999e:	89 fa                	mov    %edi,%edx
  1099a0:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1099a3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1099a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1099a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1099ac:	83 c4 20             	add    $0x20,%esp
  1099af:	5e                   	pop    %esi
  1099b0:	5f                   	pop    %edi
  1099b1:	5d                   	pop    %ebp
  1099b2:	c3                   	ret    

001099b3 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1099b3:	f3 0f 1e fb          	endbr32 
  1099b7:	55                   	push   %ebp
  1099b8:	89 e5                	mov    %esp,%ebp
  1099ba:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1099bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1099c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1099c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1099c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1099c9:	eb 2e                	jmp    1099f9 <memcmp+0x46>
        if (*s1 != *s2) {
  1099cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1099ce:	0f b6 10             	movzbl (%eax),%edx
  1099d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1099d4:	0f b6 00             	movzbl (%eax),%eax
  1099d7:	38 c2                	cmp    %al,%dl
  1099d9:	74 18                	je     1099f3 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1099db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1099de:	0f b6 00             	movzbl (%eax),%eax
  1099e1:	0f b6 d0             	movzbl %al,%edx
  1099e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1099e7:	0f b6 00             	movzbl (%eax),%eax
  1099ea:	0f b6 c0             	movzbl %al,%eax
  1099ed:	29 c2                	sub    %eax,%edx
  1099ef:	89 d0                	mov    %edx,%eax
  1099f1:	eb 18                	jmp    109a0b <memcmp+0x58>
        }
        s1 ++, s2 ++;
  1099f3:	ff 45 fc             	incl   -0x4(%ebp)
  1099f6:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  1099f9:	8b 45 10             	mov    0x10(%ebp),%eax
  1099fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  1099ff:	89 55 10             	mov    %edx,0x10(%ebp)
  109a02:	85 c0                	test   %eax,%eax
  109a04:	75 c5                	jne    1099cb <memcmp+0x18>
    }
    return 0;
  109a06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  109a0b:	c9                   	leave  
  109a0c:	c3                   	ret    

00109a0d <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  109a0d:	f3 0f 1e fb          	endbr32 
  109a11:	55                   	push   %ebp
  109a12:	89 e5                	mov    %esp,%ebp
  109a14:	83 ec 58             	sub    $0x58,%esp
  109a17:	8b 45 10             	mov    0x10(%ebp),%eax
  109a1a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  109a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  109a20:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  109a23:	8b 45 d0             	mov    -0x30(%ebp),%eax
  109a26:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  109a29:	89 45 e8             	mov    %eax,-0x18(%ebp)
  109a2c:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  109a2f:	8b 45 18             	mov    0x18(%ebp),%eax
  109a32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  109a35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  109a38:	8b 55 ec             	mov    -0x14(%ebp),%edx
  109a3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  109a3e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  109a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  109a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  109a47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  109a4b:	74 1c                	je     109a69 <printnum+0x5c>
  109a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  109a50:	ba 00 00 00 00       	mov    $0x0,%edx
  109a55:	f7 75 e4             	divl   -0x1c(%ebp)
  109a58:	89 55 f4             	mov    %edx,-0xc(%ebp)
  109a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  109a5e:	ba 00 00 00 00       	mov    $0x0,%edx
  109a63:	f7 75 e4             	divl   -0x1c(%ebp)
  109a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109a69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  109a6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  109a6f:	f7 75 e4             	divl   -0x1c(%ebp)
  109a72:	89 45 e0             	mov    %eax,-0x20(%ebp)
  109a75:	89 55 dc             	mov    %edx,-0x24(%ebp)
  109a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  109a7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  109a7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  109a81:	89 55 ec             	mov    %edx,-0x14(%ebp)
  109a84:	8b 45 dc             	mov    -0x24(%ebp),%eax
  109a87:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  109a8a:	8b 45 18             	mov    0x18(%ebp),%eax
  109a8d:	ba 00 00 00 00       	mov    $0x0,%edx
  109a92:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  109a95:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  109a98:	19 d1                	sbb    %edx,%ecx
  109a9a:	72 4c                	jb     109ae8 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  109a9c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  109a9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  109aa2:	8b 45 20             	mov    0x20(%ebp),%eax
  109aa5:	89 44 24 18          	mov    %eax,0x18(%esp)
  109aa9:	89 54 24 14          	mov    %edx,0x14(%esp)
  109aad:	8b 45 18             	mov    0x18(%ebp),%eax
  109ab0:	89 44 24 10          	mov    %eax,0x10(%esp)
  109ab4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  109ab7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  109aba:	89 44 24 08          	mov    %eax,0x8(%esp)
  109abe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  109ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  109ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
  109ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  109acc:	89 04 24             	mov    %eax,(%esp)
  109acf:	e8 39 ff ff ff       	call   109a0d <printnum>
  109ad4:	eb 1b                	jmp    109af1 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  109ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  109ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  109add:	8b 45 20             	mov    0x20(%ebp),%eax
  109ae0:	89 04 24             	mov    %eax,(%esp)
  109ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  109ae6:	ff d0                	call   *%eax
        while (-- width > 0)
  109ae8:	ff 4d 1c             	decl   0x1c(%ebp)
  109aeb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  109aef:	7f e5                	jg     109ad6 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  109af1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  109af4:	05 14 b7 10 00       	add    $0x10b714,%eax
  109af9:	0f b6 00             	movzbl (%eax),%eax
  109afc:	0f be c0             	movsbl %al,%eax
  109aff:	8b 55 0c             	mov    0xc(%ebp),%edx
  109b02:	89 54 24 04          	mov    %edx,0x4(%esp)
  109b06:	89 04 24             	mov    %eax,(%esp)
  109b09:	8b 45 08             	mov    0x8(%ebp),%eax
  109b0c:	ff d0                	call   *%eax
}
  109b0e:	90                   	nop
  109b0f:	c9                   	leave  
  109b10:	c3                   	ret    

00109b11 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  109b11:	f3 0f 1e fb          	endbr32 
  109b15:	55                   	push   %ebp
  109b16:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  109b18:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  109b1c:	7e 14                	jle    109b32 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  109b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  109b21:	8b 00                	mov    (%eax),%eax
  109b23:	8d 48 08             	lea    0x8(%eax),%ecx
  109b26:	8b 55 08             	mov    0x8(%ebp),%edx
  109b29:	89 0a                	mov    %ecx,(%edx)
  109b2b:	8b 50 04             	mov    0x4(%eax),%edx
  109b2e:	8b 00                	mov    (%eax),%eax
  109b30:	eb 30                	jmp    109b62 <getuint+0x51>
    }
    else if (lflag) {
  109b32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  109b36:	74 16                	je     109b4e <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  109b38:	8b 45 08             	mov    0x8(%ebp),%eax
  109b3b:	8b 00                	mov    (%eax),%eax
  109b3d:	8d 48 04             	lea    0x4(%eax),%ecx
  109b40:	8b 55 08             	mov    0x8(%ebp),%edx
  109b43:	89 0a                	mov    %ecx,(%edx)
  109b45:	8b 00                	mov    (%eax),%eax
  109b47:	ba 00 00 00 00       	mov    $0x0,%edx
  109b4c:	eb 14                	jmp    109b62 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  109b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  109b51:	8b 00                	mov    (%eax),%eax
  109b53:	8d 48 04             	lea    0x4(%eax),%ecx
  109b56:	8b 55 08             	mov    0x8(%ebp),%edx
  109b59:	89 0a                	mov    %ecx,(%edx)
  109b5b:	8b 00                	mov    (%eax),%eax
  109b5d:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  109b62:	5d                   	pop    %ebp
  109b63:	c3                   	ret    

00109b64 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  109b64:	f3 0f 1e fb          	endbr32 
  109b68:	55                   	push   %ebp
  109b69:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  109b6b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  109b6f:	7e 14                	jle    109b85 <getint+0x21>
        return va_arg(*ap, long long);
  109b71:	8b 45 08             	mov    0x8(%ebp),%eax
  109b74:	8b 00                	mov    (%eax),%eax
  109b76:	8d 48 08             	lea    0x8(%eax),%ecx
  109b79:	8b 55 08             	mov    0x8(%ebp),%edx
  109b7c:	89 0a                	mov    %ecx,(%edx)
  109b7e:	8b 50 04             	mov    0x4(%eax),%edx
  109b81:	8b 00                	mov    (%eax),%eax
  109b83:	eb 28                	jmp    109bad <getint+0x49>
    }
    else if (lflag) {
  109b85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  109b89:	74 12                	je     109b9d <getint+0x39>
        return va_arg(*ap, long);
  109b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  109b8e:	8b 00                	mov    (%eax),%eax
  109b90:	8d 48 04             	lea    0x4(%eax),%ecx
  109b93:	8b 55 08             	mov    0x8(%ebp),%edx
  109b96:	89 0a                	mov    %ecx,(%edx)
  109b98:	8b 00                	mov    (%eax),%eax
  109b9a:	99                   	cltd   
  109b9b:	eb 10                	jmp    109bad <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  109b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  109ba0:	8b 00                	mov    (%eax),%eax
  109ba2:	8d 48 04             	lea    0x4(%eax),%ecx
  109ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  109ba8:	89 0a                	mov    %ecx,(%edx)
  109baa:	8b 00                	mov    (%eax),%eax
  109bac:	99                   	cltd   
    }
}
  109bad:	5d                   	pop    %ebp
  109bae:	c3                   	ret    

00109baf <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  109baf:	f3 0f 1e fb          	endbr32 
  109bb3:	55                   	push   %ebp
  109bb4:	89 e5                	mov    %esp,%ebp
  109bb6:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  109bb9:	8d 45 14             	lea    0x14(%ebp),%eax
  109bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  109bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  109bc2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  109bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  109bc9:	89 44 24 08          	mov    %eax,0x8(%esp)
  109bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  109bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  109bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  109bd7:	89 04 24             	mov    %eax,(%esp)
  109bda:	e8 03 00 00 00       	call   109be2 <vprintfmt>
    va_end(ap);
}
  109bdf:	90                   	nop
  109be0:	c9                   	leave  
  109be1:	c3                   	ret    

00109be2 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  109be2:	f3 0f 1e fb          	endbr32 
  109be6:	55                   	push   %ebp
  109be7:	89 e5                	mov    %esp,%ebp
  109be9:	56                   	push   %esi
  109bea:	53                   	push   %ebx
  109beb:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  109bee:	eb 17                	jmp    109c07 <vprintfmt+0x25>
            if (ch == '\0') {
  109bf0:	85 db                	test   %ebx,%ebx
  109bf2:	0f 84 c0 03 00 00    	je     109fb8 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  109bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  109bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  109bff:	89 1c 24             	mov    %ebx,(%esp)
  109c02:	8b 45 08             	mov    0x8(%ebp),%eax
  109c05:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  109c07:	8b 45 10             	mov    0x10(%ebp),%eax
  109c0a:	8d 50 01             	lea    0x1(%eax),%edx
  109c0d:	89 55 10             	mov    %edx,0x10(%ebp)
  109c10:	0f b6 00             	movzbl (%eax),%eax
  109c13:	0f b6 d8             	movzbl %al,%ebx
  109c16:	83 fb 25             	cmp    $0x25,%ebx
  109c19:	75 d5                	jne    109bf0 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  109c1b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  109c1f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  109c26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  109c29:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  109c2c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  109c33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  109c36:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  109c39:	8b 45 10             	mov    0x10(%ebp),%eax
  109c3c:	8d 50 01             	lea    0x1(%eax),%edx
  109c3f:	89 55 10             	mov    %edx,0x10(%ebp)
  109c42:	0f b6 00             	movzbl (%eax),%eax
  109c45:	0f b6 d8             	movzbl %al,%ebx
  109c48:	8d 43 dd             	lea    -0x23(%ebx),%eax
  109c4b:	83 f8 55             	cmp    $0x55,%eax
  109c4e:	0f 87 38 03 00 00    	ja     109f8c <vprintfmt+0x3aa>
  109c54:	8b 04 85 38 b7 10 00 	mov    0x10b738(,%eax,4),%eax
  109c5b:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  109c5e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  109c62:	eb d5                	jmp    109c39 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  109c64:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  109c68:	eb cf                	jmp    109c39 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  109c6a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  109c71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  109c74:	89 d0                	mov    %edx,%eax
  109c76:	c1 e0 02             	shl    $0x2,%eax
  109c79:	01 d0                	add    %edx,%eax
  109c7b:	01 c0                	add    %eax,%eax
  109c7d:	01 d8                	add    %ebx,%eax
  109c7f:	83 e8 30             	sub    $0x30,%eax
  109c82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  109c85:	8b 45 10             	mov    0x10(%ebp),%eax
  109c88:	0f b6 00             	movzbl (%eax),%eax
  109c8b:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  109c8e:	83 fb 2f             	cmp    $0x2f,%ebx
  109c91:	7e 38                	jle    109ccb <vprintfmt+0xe9>
  109c93:	83 fb 39             	cmp    $0x39,%ebx
  109c96:	7f 33                	jg     109ccb <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  109c98:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  109c9b:	eb d4                	jmp    109c71 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  109c9d:	8b 45 14             	mov    0x14(%ebp),%eax
  109ca0:	8d 50 04             	lea    0x4(%eax),%edx
  109ca3:	89 55 14             	mov    %edx,0x14(%ebp)
  109ca6:	8b 00                	mov    (%eax),%eax
  109ca8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  109cab:	eb 1f                	jmp    109ccc <vprintfmt+0xea>

        case '.':
            if (width < 0)
  109cad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  109cb1:	79 86                	jns    109c39 <vprintfmt+0x57>
                width = 0;
  109cb3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  109cba:	e9 7a ff ff ff       	jmp    109c39 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  109cbf:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  109cc6:	e9 6e ff ff ff       	jmp    109c39 <vprintfmt+0x57>
            goto process_precision;
  109ccb:	90                   	nop

        process_precision:
            if (width < 0)
  109ccc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  109cd0:	0f 89 63 ff ff ff    	jns    109c39 <vprintfmt+0x57>
                width = precision, precision = -1;
  109cd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  109cd9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  109cdc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  109ce3:	e9 51 ff ff ff       	jmp    109c39 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  109ce8:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  109ceb:	e9 49 ff ff ff       	jmp    109c39 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  109cf0:	8b 45 14             	mov    0x14(%ebp),%eax
  109cf3:	8d 50 04             	lea    0x4(%eax),%edx
  109cf6:	89 55 14             	mov    %edx,0x14(%ebp)
  109cf9:	8b 00                	mov    (%eax),%eax
  109cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  109cfe:	89 54 24 04          	mov    %edx,0x4(%esp)
  109d02:	89 04 24             	mov    %eax,(%esp)
  109d05:	8b 45 08             	mov    0x8(%ebp),%eax
  109d08:	ff d0                	call   *%eax
            break;
  109d0a:	e9 a4 02 00 00       	jmp    109fb3 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  109d0f:	8b 45 14             	mov    0x14(%ebp),%eax
  109d12:	8d 50 04             	lea    0x4(%eax),%edx
  109d15:	89 55 14             	mov    %edx,0x14(%ebp)
  109d18:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  109d1a:	85 db                	test   %ebx,%ebx
  109d1c:	79 02                	jns    109d20 <vprintfmt+0x13e>
                err = -err;
  109d1e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  109d20:	83 fb 06             	cmp    $0x6,%ebx
  109d23:	7f 0b                	jg     109d30 <vprintfmt+0x14e>
  109d25:	8b 34 9d f8 b6 10 00 	mov    0x10b6f8(,%ebx,4),%esi
  109d2c:	85 f6                	test   %esi,%esi
  109d2e:	75 23                	jne    109d53 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  109d30:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  109d34:	c7 44 24 08 25 b7 10 	movl   $0x10b725,0x8(%esp)
  109d3b:	00 
  109d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  109d3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  109d43:	8b 45 08             	mov    0x8(%ebp),%eax
  109d46:	89 04 24             	mov    %eax,(%esp)
  109d49:	e8 61 fe ff ff       	call   109baf <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  109d4e:	e9 60 02 00 00       	jmp    109fb3 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  109d53:	89 74 24 0c          	mov    %esi,0xc(%esp)
  109d57:	c7 44 24 08 2e b7 10 	movl   $0x10b72e,0x8(%esp)
  109d5e:	00 
  109d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  109d62:	89 44 24 04          	mov    %eax,0x4(%esp)
  109d66:	8b 45 08             	mov    0x8(%ebp),%eax
  109d69:	89 04 24             	mov    %eax,(%esp)
  109d6c:	e8 3e fe ff ff       	call   109baf <printfmt>
            break;
  109d71:	e9 3d 02 00 00       	jmp    109fb3 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  109d76:	8b 45 14             	mov    0x14(%ebp),%eax
  109d79:	8d 50 04             	lea    0x4(%eax),%edx
  109d7c:	89 55 14             	mov    %edx,0x14(%ebp)
  109d7f:	8b 30                	mov    (%eax),%esi
  109d81:	85 f6                	test   %esi,%esi
  109d83:	75 05                	jne    109d8a <vprintfmt+0x1a8>
                p = "(null)";
  109d85:	be 31 b7 10 00       	mov    $0x10b731,%esi
            }
            if (width > 0 && padc != '-') {
  109d8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  109d8e:	7e 76                	jle    109e06 <vprintfmt+0x224>
  109d90:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  109d94:	74 70                	je     109e06 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  109d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  109d99:	89 44 24 04          	mov    %eax,0x4(%esp)
  109d9d:	89 34 24             	mov    %esi,(%esp)
  109da0:	e8 ba f7 ff ff       	call   10955f <strnlen>
  109da5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  109da8:	29 c2                	sub    %eax,%edx
  109daa:	89 d0                	mov    %edx,%eax
  109dac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  109daf:	eb 16                	jmp    109dc7 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  109db1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  109db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  109db8:	89 54 24 04          	mov    %edx,0x4(%esp)
  109dbc:	89 04 24             	mov    %eax,(%esp)
  109dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  109dc2:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  109dc4:	ff 4d e8             	decl   -0x18(%ebp)
  109dc7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  109dcb:	7f e4                	jg     109db1 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  109dcd:	eb 37                	jmp    109e06 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  109dcf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  109dd3:	74 1f                	je     109df4 <vprintfmt+0x212>
  109dd5:	83 fb 1f             	cmp    $0x1f,%ebx
  109dd8:	7e 05                	jle    109ddf <vprintfmt+0x1fd>
  109dda:	83 fb 7e             	cmp    $0x7e,%ebx
  109ddd:	7e 15                	jle    109df4 <vprintfmt+0x212>
                    putch('?', putdat);
  109ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  109de2:	89 44 24 04          	mov    %eax,0x4(%esp)
  109de6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  109ded:	8b 45 08             	mov    0x8(%ebp),%eax
  109df0:	ff d0                	call   *%eax
  109df2:	eb 0f                	jmp    109e03 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  109df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  109df7:	89 44 24 04          	mov    %eax,0x4(%esp)
  109dfb:	89 1c 24             	mov    %ebx,(%esp)
  109dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  109e01:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  109e03:	ff 4d e8             	decl   -0x18(%ebp)
  109e06:	89 f0                	mov    %esi,%eax
  109e08:	8d 70 01             	lea    0x1(%eax),%esi
  109e0b:	0f b6 00             	movzbl (%eax),%eax
  109e0e:	0f be d8             	movsbl %al,%ebx
  109e11:	85 db                	test   %ebx,%ebx
  109e13:	74 27                	je     109e3c <vprintfmt+0x25a>
  109e15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  109e19:	78 b4                	js     109dcf <vprintfmt+0x1ed>
  109e1b:	ff 4d e4             	decl   -0x1c(%ebp)
  109e1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  109e22:	79 ab                	jns    109dcf <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  109e24:	eb 16                	jmp    109e3c <vprintfmt+0x25a>
                putch(' ', putdat);
  109e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  109e29:	89 44 24 04          	mov    %eax,0x4(%esp)
  109e2d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  109e34:	8b 45 08             	mov    0x8(%ebp),%eax
  109e37:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  109e39:	ff 4d e8             	decl   -0x18(%ebp)
  109e3c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  109e40:	7f e4                	jg     109e26 <vprintfmt+0x244>
            }
            break;
  109e42:	e9 6c 01 00 00       	jmp    109fb3 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  109e47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  109e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  109e4e:	8d 45 14             	lea    0x14(%ebp),%eax
  109e51:	89 04 24             	mov    %eax,(%esp)
  109e54:	e8 0b fd ff ff       	call   109b64 <getint>
  109e59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109e5c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  109e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  109e62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  109e65:	85 d2                	test   %edx,%edx
  109e67:	79 26                	jns    109e8f <vprintfmt+0x2ad>
                putch('-', putdat);
  109e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  109e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  109e70:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  109e77:	8b 45 08             	mov    0x8(%ebp),%eax
  109e7a:	ff d0                	call   *%eax
                num = -(long long)num;
  109e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  109e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  109e82:	f7 d8                	neg    %eax
  109e84:	83 d2 00             	adc    $0x0,%edx
  109e87:	f7 da                	neg    %edx
  109e89:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109e8c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  109e8f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  109e96:	e9 a8 00 00 00       	jmp    109f43 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  109e9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  109e9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  109ea2:	8d 45 14             	lea    0x14(%ebp),%eax
  109ea5:	89 04 24             	mov    %eax,(%esp)
  109ea8:	e8 64 fc ff ff       	call   109b11 <getuint>
  109ead:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109eb0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  109eb3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  109eba:	e9 84 00 00 00       	jmp    109f43 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  109ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  109ec2:	89 44 24 04          	mov    %eax,0x4(%esp)
  109ec6:	8d 45 14             	lea    0x14(%ebp),%eax
  109ec9:	89 04 24             	mov    %eax,(%esp)
  109ecc:	e8 40 fc ff ff       	call   109b11 <getuint>
  109ed1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109ed4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  109ed7:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  109ede:	eb 63                	jmp    109f43 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  109ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  109ee3:	89 44 24 04          	mov    %eax,0x4(%esp)
  109ee7:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  109eee:	8b 45 08             	mov    0x8(%ebp),%eax
  109ef1:	ff d0                	call   *%eax
            putch('x', putdat);
  109ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  109ef6:	89 44 24 04          	mov    %eax,0x4(%esp)
  109efa:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  109f01:	8b 45 08             	mov    0x8(%ebp),%eax
  109f04:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  109f06:	8b 45 14             	mov    0x14(%ebp),%eax
  109f09:	8d 50 04             	lea    0x4(%eax),%edx
  109f0c:	89 55 14             	mov    %edx,0x14(%ebp)
  109f0f:	8b 00                	mov    (%eax),%eax
  109f11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109f14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  109f1b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  109f22:	eb 1f                	jmp    109f43 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  109f24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  109f27:	89 44 24 04          	mov    %eax,0x4(%esp)
  109f2b:	8d 45 14             	lea    0x14(%ebp),%eax
  109f2e:	89 04 24             	mov    %eax,(%esp)
  109f31:	e8 db fb ff ff       	call   109b11 <getuint>
  109f36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  109f39:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  109f3c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  109f43:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  109f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  109f4a:	89 54 24 18          	mov    %edx,0x18(%esp)
  109f4e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  109f51:	89 54 24 14          	mov    %edx,0x14(%esp)
  109f55:	89 44 24 10          	mov    %eax,0x10(%esp)
  109f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  109f5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  109f5f:	89 44 24 08          	mov    %eax,0x8(%esp)
  109f63:	89 54 24 0c          	mov    %edx,0xc(%esp)
  109f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  109f6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  109f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  109f71:	89 04 24             	mov    %eax,(%esp)
  109f74:	e8 94 fa ff ff       	call   109a0d <printnum>
            break;
  109f79:	eb 38                	jmp    109fb3 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  109f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  109f7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  109f82:	89 1c 24             	mov    %ebx,(%esp)
  109f85:	8b 45 08             	mov    0x8(%ebp),%eax
  109f88:	ff d0                	call   *%eax
            break;
  109f8a:	eb 27                	jmp    109fb3 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  109f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  109f8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  109f93:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  109f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  109f9d:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  109f9f:	ff 4d 10             	decl   0x10(%ebp)
  109fa2:	eb 03                	jmp    109fa7 <vprintfmt+0x3c5>
  109fa4:	ff 4d 10             	decl   0x10(%ebp)
  109fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  109faa:	48                   	dec    %eax
  109fab:	0f b6 00             	movzbl (%eax),%eax
  109fae:	3c 25                	cmp    $0x25,%al
  109fb0:	75 f2                	jne    109fa4 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  109fb2:	90                   	nop
    while (1) {
  109fb3:	e9 36 fc ff ff       	jmp    109bee <vprintfmt+0xc>
                return;
  109fb8:	90                   	nop
        }
    }
}
  109fb9:	83 c4 40             	add    $0x40,%esp
  109fbc:	5b                   	pop    %ebx
  109fbd:	5e                   	pop    %esi
  109fbe:	5d                   	pop    %ebp
  109fbf:	c3                   	ret    

00109fc0 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  109fc0:	f3 0f 1e fb          	endbr32 
  109fc4:	55                   	push   %ebp
  109fc5:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  109fc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  109fca:	8b 40 08             	mov    0x8(%eax),%eax
  109fcd:	8d 50 01             	lea    0x1(%eax),%edx
  109fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  109fd3:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  109fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  109fd9:	8b 10                	mov    (%eax),%edx
  109fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  109fde:	8b 40 04             	mov    0x4(%eax),%eax
  109fe1:	39 c2                	cmp    %eax,%edx
  109fe3:	73 12                	jae    109ff7 <sprintputch+0x37>
        *b->buf ++ = ch;
  109fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  109fe8:	8b 00                	mov    (%eax),%eax
  109fea:	8d 48 01             	lea    0x1(%eax),%ecx
  109fed:	8b 55 0c             	mov    0xc(%ebp),%edx
  109ff0:	89 0a                	mov    %ecx,(%edx)
  109ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  109ff5:	88 10                	mov    %dl,(%eax)
    }
}
  109ff7:	90                   	nop
  109ff8:	5d                   	pop    %ebp
  109ff9:	c3                   	ret    

00109ffa <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  109ffa:	f3 0f 1e fb          	endbr32 
  109ffe:	55                   	push   %ebp
  109fff:	89 e5                	mov    %esp,%ebp
  10a001:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10a004:	8d 45 14             	lea    0x14(%ebp),%eax
  10a007:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10a00a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10a00d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10a011:	8b 45 10             	mov    0x10(%ebp),%eax
  10a014:	89 44 24 08          	mov    %eax,0x8(%esp)
  10a018:	8b 45 0c             	mov    0xc(%ebp),%eax
  10a01b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10a01f:	8b 45 08             	mov    0x8(%ebp),%eax
  10a022:	89 04 24             	mov    %eax,(%esp)
  10a025:	e8 08 00 00 00       	call   10a032 <vsnprintf>
  10a02a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10a02d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10a030:	c9                   	leave  
  10a031:	c3                   	ret    

0010a032 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10a032:	f3 0f 1e fb          	endbr32 
  10a036:	55                   	push   %ebp
  10a037:	89 e5                	mov    %esp,%ebp
  10a039:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10a03c:	8b 45 08             	mov    0x8(%ebp),%eax
  10a03f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10a042:	8b 45 0c             	mov    0xc(%ebp),%eax
  10a045:	8d 50 ff             	lea    -0x1(%eax),%edx
  10a048:	8b 45 08             	mov    0x8(%ebp),%eax
  10a04b:	01 d0                	add    %edx,%eax
  10a04d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10a050:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10a057:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10a05b:	74 0a                	je     10a067 <vsnprintf+0x35>
  10a05d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10a060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10a063:	39 c2                	cmp    %eax,%edx
  10a065:	76 07                	jbe    10a06e <vsnprintf+0x3c>
        return -E_INVAL;
  10a067:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10a06c:	eb 2a                	jmp    10a098 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10a06e:	8b 45 14             	mov    0x14(%ebp),%eax
  10a071:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10a075:	8b 45 10             	mov    0x10(%ebp),%eax
  10a078:	89 44 24 08          	mov    %eax,0x8(%esp)
  10a07c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10a07f:	89 44 24 04          	mov    %eax,0x4(%esp)
  10a083:	c7 04 24 c0 9f 10 00 	movl   $0x109fc0,(%esp)
  10a08a:	e8 53 fb ff ff       	call   109be2 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10a08f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10a092:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10a095:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10a098:	c9                   	leave  
  10a099:	c3                   	ret    
