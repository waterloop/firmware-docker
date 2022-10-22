# docker build . -t waterloop-firmware
FROM debian:bullseye-slim

RUN apt update
RUN apt update --fix-missing && apt upgrade

RUN apt update && apt install -y \
    git \
    locales \
    locales-all \
    make \
    build-essential \
    gcc-arm-none-eabi \
    gdb \
    gdb-multiarch \
    bear \
    clangd \
    stlink-tools \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    wget \
    nano \
    vim \
    net-tools \
    can-utils \
    screen \
    cmake

# install buildroot dependencies
RUN apt update && apt install -y \
    sed \
    make \
    binutils \
    gcc \
    g++ \
    bash \
    patch \
    gzip \
    bzip2 \
    perl \
    tar \
    cpio \
    unzip \
    rsync \
    wget \
    libncurses-dev \
    coreutils \
    flex \
    bison \
    bc

# install latest NodeJS
RUN curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
RUN bash /tmp/nodesource_setup.sh
RUN apt update && apt install -y nodejs

# build openocd from source cus the apt version can be weirdge
RUN apt update && apt install -y \
    libtool \
    pkg-config \
    autoconf \
    automake \
    texinfo \
    libusb-1.0-0-dev

WORKDIR /
RUN git clone https://github.com/openocd-org/openocd.git
WORKDIR /openocd
RUN git checkout tags/v0.11.0

RUN ./bootstrap
RUN ./configure --enable-stlink --enable-ftdi --enable-jlink
RUN make
RUN make install

WORKDIR /
RUN rm -rf openocd


# install useful python libraries...
RUN pip3 install \
    gdbgui \
    python-can \
    pygments \
    numpy \
    pandas \
    click

# install flatc from source
RUN git clone https://github.com/google/flatbuffers.git
WORKDIR /flatbuffers
# This hash happens to corrispond the the commit that is working with our current tool chain. This should prevent future commits to flatbuffers from breaking future members virtual machines.
RUN git checkout 7edf8c90842aaa402257bf99989b58b8147ceabf
RUN cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release
RUN make
RUN make install
WORKDIR /
RUN rm -rf flatbuffers

WORKDIR /firmware

RUN useradd -rm -d /home/dev -s /bin/bash -g root -G sudo -u 1000 dev
RUN echo "dev:dev" | chpasswd
USER dev
ENTRYPOINT [ "python3" ]
CMD [ "-h" ]
