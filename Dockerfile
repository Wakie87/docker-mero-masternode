FROM ubuntu:16.04

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wget git pwgen && \
    apt-get -y install software-properties-common libzmq3-dev && \
    apt-get -y install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev libboost-all-dev unzip libminiupnpc-dev python-virtualenv && \
    apt-get -y install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils && \
    add-apt-repository ppa:bitcoin/bitcoin && \
    apt-get update && \
    apt-get -y install libdb4.8-dev libdb4.8++-dev

RUN echo "mero ALL = NOPASSWD : ALL" >> /etc/sudoers

ARG MEROCORE_VERSION="v1.0.0"
ARG MEROCORE_FILENAME="linux_x64.tar.gz"
ARG MEROCORE_URL="https://github.com/merocoin/mero/releases/download/${MEROCORE_VERSION}/${MEROCORE_FILENAME}"

WORKDIR /root
RUN wget ${MEROCORE_URL} && \
    tar xvf ${MEROCORE_FILENAME} && \
    cp ~/merod /usr/bin/ && rm -fr ~/merod && \
    cp ~/mero-cli /usr/bin/ && rm -fr ~/mero-cli && \
    cp ~/mero-tx /usr/bin/ && rm -fr ~/mero-tx \
    rm -rf ${MEROCORE_FILENAME}

RUN useradd --create-home mero && echo "mero:mero" | chpasswd && adduser mero sudo
USER mero
WORKDIR /home/mero

COPY *.sh ./

CMD [ "./start.sh" ]