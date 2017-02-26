FROM ubuntu:14.04

RUN echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-updates main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-security main restricted universe multiverse\n" > /etc/apt/sources.list ; \
apt-get update ; \
apt-get -y install g++ gcc build-essential git qemu-system-x86 qemu gdb make diffutils gcc-multilib vim tmux cscope

CMD ["/bin/bash"]
