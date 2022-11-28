#include <asm.h>

# Start the CPU: switch to 32-bit protected mode, jump into C.
# The BIOS loads this code from the first sector of the hard disk into
# memory at physical address 0x7c00 and starts executing in real mode
# with %cs=0 %ip=7c00.

.set PROT_MODE_CSEG,        0x8                     # kernel code segment selector:index=1;TI=0b0;RPL=0b00 (TI=0代表应该访问全局描述符表（GDT），TI=1代表应该访问局部描述符表（LDT）)
# protected mode enable flag
.set PROT_MODE_DSEG,        0x10                    # kernel data segment selector:index=2;TI=0b0;RPL=0b00
.set CR0_PE_ON,             0x1                     # protected mode enable flag
.set SMAP,                  0x534d4150

# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
.code16                                             # Assemble for 16-bit mode
    cli                                             # Disable interrupts，之前BIOS运行时，可能打开了中断，而后面打开A20 Gate需要给键盘端口发送指令，而且操作系统还未加载，也无法处理中断.（猜测）
    cld                                             # String operations increment，串处理指令，例如movs,执行后指针寄存器(si, di)自增1

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment

    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al                                 # Status Register(0x64端口) 的 bit1 代表 input register (60h/64h) 有数据
    jnz seta20.1

    # 向键盘输入缓冲器(0x64端口)写一个控制命令(0xd1)
    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

    # 向键盘输入缓冲器(0x60端口)写入0xdf
    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1

probe_memory:
    movl $0, 0x8000                                 # 给位于0x8000处的struct e820map的成员变量nr_map清零
    xorl %ebx, %ebx                                 # 如果是第一次调用或内存区域扫描完毕，则ebx为0。 如果不是，则存放上次调用之后的计数值
    movw $0x8004, %di                               # es:di 指向保存地址范围描述符结构的缓冲区，BIOS把信息写入这个结构的起始地址
start_probe:
    movl $0xE820, %eax                              # INT 15的中断调用参数
    movl $20, %ecx                                  # 保存地址范围描述符的内存大小,其大小等于struct e820map的成员变量map的大小
    movl $SMAP, %edx                                # 534D4150h (即4个ASCII字符“SMAP”), 这只是一个签名而已, 这是一个约定
    int $0x15
    jnc cont                                        # CF = 0 则跳转 (CF: 若INT 15中断执行成功，则不置位，否则置位；)
    movw $12345, 0x8000
    jmp finish_probe
cont:
    addw $20, %di                                   # es:di 指向保存地址范围描述符的缓冲区,此时缓冲区内的数据已由BIOS填写完毕
    incl 0x8000                                     # 递增struct e820map的成员变量nr_map
    cmpl $0, %ebx                                   # ebx: 下一个地址范围描述符的计数地址, 为0表示探测结束
    jnz start_probe
finish_probe:

    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc                                    # 加载全局描述符表放入GDTR寄存器
    movl %cr0, %eax                                 # cr0寄存器0位是保护允许位PE(Protedted Enable)，用于启动保护模式，如果PE位置1，则保护模式启动，如果PE=0，则在实模式下运行。
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    ljmp $PROT_MODE_CSEG, $protcseg                 # 第一个参数是段，第二个参数是偏移量

.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    movw %ax, %ds                                   # -> DS: Data Segment
    movw %ax, %es                                   # -> ES: Extra Segment
    movw %ax, %fs                                   # -> FS
    movw %ax, %gs                                   # -> GS
    movw %ax, %ss                                   # -> SS: Stack Segment

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    movl $0x0, %ebp
    movl $start, %esp
    call bootmain

    # If bootmain returns (it shouldn't), loop.
spin:
    jmp spin

.data
# Bootstrap GDT
.p2align 2                                          # force 4 byte alignment， 将位置计数器移动到4字节的倍数，如果已经是4字节的倍数则不会发生变化。
gdt:                                                # 关于SEG_ASM（段描述符）的定义在ASM.h中，以type，base，lim为参数定义一个段描述符
    SEG_NULLASM                                     # null seg
    SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)           # code seg for bootloader and kernel，可读可执行
    SEG_ASM(STA_W, 0x0, 0xffffffff)                 # data seg for bootloader and kernel，可写但不可执行
# GDTR长48位，其中高32位为基地址，低16位为段界限
gdtdesc:
    .word 0x17                                      # sizeof(gdt) - 1，为什么是sizeof(gdt) - 1而不是sizeof(gdt)我也不是特别清楚，据说是规定
    .long gdt                    