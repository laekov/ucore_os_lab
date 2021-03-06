Lab1 实验报告
===
## 练习一: Makefile
### img 文件生成原理
首先编译内核和 bootloader 中的各种组件, 然后将链接后的文件输出到 `/bin/bootblock` 和 `/bin/kernal`, 最后生成 `ucore.img`.
### 合法主引导扇区特征
不超过 `512` 字节, 并且有可执行的 `bootloader`.
## 练习二: 执行与调试
### 使用 qemu 和 gdb
对 `makefile` 进行微小的修改使得它支持没有 `X11` 的 docker 环境.

这里由于没有启动 `terminal`, 所以几个命令为串行执行, 所以需要手工执行 `gdb -q -x tools/gdbinit`.

使用 `nexti` 进行跟踪, 代码与 `bootblock.asm` 中的代码相同, 但是行号不同.
## 练习三: 进入保护模式
### A20
A20 是为了在保护模式下兼容回卷的情况. 具体做法在 `/boot/bootasm.S` 第 `30` 行开始. 从 8042 芯片的 `0x64` 口读入它的状态, 然后将它的第二位或上一, 然后再输出回 `0x60` 口, 即实现了使能 A20.
### 初始化 GDT
`lgdt gdtdsec`
### 使能保护模式
将 `cr0` 寄存器的最低位设为 `1`, 即打开了保护模式开关, 进入了保护模式. 然后使用长跳转 `movl` 来刷新 `cs` 和 `eip` 寄存器的值, 从而真正进入保护模式.
## 练习四: 从硬盘加载 ELF
### 读硬盘
使用 `/boot/bootmain.c` 中的 `readsect` 函数, 通过向硬盘发送相应请求的方式, 每次读一个扇区, 然后用 `readseg` 函数读多个扇区. 
### 加载 ELF
首先读一个扇区, 并通过比对 `magic` 检查该文件是否为合法 elf. 然后读入整个 elf 文件加载到内存, 并从 `e_entry` 所指向的代码地址开始运行操作系统, 并用死循环将 bootloader 挂起.
## 练习五: 调用栈
`ebp` 指针是该调用的起始位置, `eip` 是调用的函数的地址, 接下来是本次调用的各种参数. `ebp` 指针指向的值是一个指向调用本函数的 `ebp` 指针. 通过不断沿 `ebp` 向上查找, 可以找到整个调用栈.

代码中还有提供 `print_debuginfo` 函数, 可以通过 `eip` 找到函数的具体信息.
## 练习六: 中断初始化和处理
### IDT初始化
使用 `/kern/mm/mmu.h` 中的 `SETGATE` 宏来初始化 IDT. 其中普通的中断处理函数均是由内核态权限调用, 只有从用户态转换到内核态的调用是用户态权限的. 然后用 `lidt` 函数将 idt 的初始地址告诉 cpu 即可.
### 时钟中断处理
在相应 `case` 语句处增加静态 `int` 形变量计数即可.