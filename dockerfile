FROM ubuntu:20.04

RUN apt update
RUN apt install -y sudo
RUN apt install -y openssh-server
RUN apt install -y language-pack-en
RUN apt install -y software-properties-common
RUN apt install -y git
RUN apt install -y build-essential
RUN apt install -y gdb
RUN apt install -y gcc-arm-none-eabi
RUN apt install -y gdb-multiarch
RUN apt install -y openocd
RUN apt install -y stlink-tools
RUN apt install -y python3
RUN apt install -y python3-pip
RUN apt install -y python3-venv
RUN apt install -y curl
RUN apt install -y wget
RUN apt install -y nodejs
RUN apt install -y npm
RUN apt install -y nano
RUN apt install -y vim


RUN pip3 install \
    gdbgui \
    numpy \
    sympy \
    pandas \
    pygments \
    python-can \
    click

RUN useradd -rm -d /home/dev -s /bin/bash -g root -G sudo -u 1000 dev
RUN echo "dev:dev" | chpasswd

RUN update-locale

# change the SSH port to 2222
RUN echo "Port 2222" >> /etc/ssh/sshd_config

# start SSH and expose port 2222
RUN service ssh start
EXPOSE 2222

# configure pre-commit hooks
# RUN git config --global init.templatedir "/home/dev/.git_template"


ADD pre-commit /home/dev/.git

CMD ["/usr/sbin/sshd", "-D"]
