Lab5 实验报告
===
## 练习零
在 `do_fork` 的时候把 `list_add` 改成 `set_links`, 并且去掉 `++ nr_process`. 否则 `nr_prcess` 会被重复加两次.
## 练习一
在 `kern/process/proc.c` 中按照注释将 `tf_*` 依次填写即可.
## 练习二
用给的 `page2kva` 函数搞到 `page` 和 `npage` 的内核地址. 然后用 `memcpy` 复制页表的内容. 然后用 `page_insert` 来把这页插入到页目录表里.

注意不能直接自己改 `nptep`. 因为已经提供好了宏.
## 练习三
这几个函数都是系统调用. 用于进行进程相关的操作.
### fork
创建一个新的进程, 并把当前的进程状态复制过去. 利用 `cow` 的方式把当前函数的页表复制一遍. (节省下复制所有页的时间)

然后把新的进程扔进进程队列里去执行.
### exec
用 `load_icode` 方式把 `elf` 文件 (目前在内存里) 加载到内存里. 加载的时候和 `fork` 其实差不多, 是从一个构造好的现场开始继续执行这个进程.
### wait
用于等待一个进程结束.

如果指定进程 `pid`, 则一直轮询此进程的状态, 直到它变为 `ZOMBIE`. 如果未指定, 就遍历当前进程的所有子进程.

一直循环直接找到这样一个进程, 然后把已结束的子进程的资源全部回收掉. 
### exit
结束当前进程.

如果它的父进程在等待子进程结束, 就唤醒父进程.

否则它是孤儿了. 它结束之后它的儿子也将变成孤儿. 那么把它的儿子们全部过继给 `init_proc`. 如果它的儿子们中有僵尸, 那么让 `init_proc` 来回收这些僵尸儿子.

完成这个工作后会调用一次 `schedule`.
### 进程生命周期
出生: `fork()`. 获得了自己的 `pid` 和内存空间 (虽然是 `cow` 来的)

拥有自主意识: `exec()`. 运行规定的代码.

可能会接着 `fork()`, 拥有儿子, 并且使用 `wait()` 来等待儿子结束.

死亡: `exit()` 来结束自己的生命.
## 与参考答案的区别
原理都一样. 很多地方忘记用给定的宏和函数, 看了参考答案之后改过来了.
## 重点知识
实验答案中有锁定中断的机制, 但是注释中并没有, 自己写代码的时候也没有考虑到这一点.