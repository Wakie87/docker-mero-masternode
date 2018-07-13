## Base Image
FROM ubuntu:16.04

## Environment Variables
# ENV TMP_FOLDER=$(mktemp -d)
ENV CONFIG_FILE='mero.conf'
ENV CONFIGFOLDER='/root/.mero'
ENV COIN_DAEMON='/usr/local/bin/merod'
ENV COIN_CLI='/usr/local/bin/mero-cli'
ENV COIN_REPO='https://github.com/merocoin/mero/releases/download/v1.0.0/linux_x64.tar.gz'
ENV COIN_NAME='mero'
ENV COIN_PORT=14550
ENV CONFIG_FILE='mero.conf'
ENV CONFIGFOLDER='/root/.mero'
ENV COINKEY=""

# ENV NODEIP=$(curl -s4 icanhazip.com)
ENV RED='\033[0;31m'
ENV GREEN='\033[0;32m'
ENV NC='\033[0m'

## Install Dependencies
RUN apt-get upgrade && apt-get update && apt-get install -y \
    software-properties-common
RUN apt-add-repository -y ppa:bitcoin/bitcoin
RUN apt-get update && apt-get install -y \
    build-essential libtool autoconf libssl-dev libboost-dev sudo automake \
    make wget curl unzip ufw git pkg-config net-tools \ 
    libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev \
    libboost-system-dev libboost-test-dev libboost-thread-dev \
    libdb4.8-dev bsdmainutils libdb4.8++-dev libminiupnpc-dev \
    libgmp3-dev libzmq3-dev libevent-dev libdb5.3++

## Download Binaries and copy to system folder
WORKDIR /root
RUN git clone -b master https://github.com/merocoin/mero.git mero && cd /mero \
    ./autogen.sh && \
    ./configure && \
    make &&\
    strip /root/mero/src/merod /root/mero/src/mero-cli && \
    mv /root/mero/src/merod /usr/local/bin/ && \
    mv /root/mero/src/mero-cli /usr/local/bin/ && \
    # clean
    rm -rf /mero


##WORKDIR /root
##RUN wget -nv -o $COIN_NAME $COIN_REPO && tar xzf -C /root
##RUN cp /root/mero* /usr/local/bin \
##    && strip /usr/local/bin/merod /usr/local/bin/mero-cli \
##    && chmod +x /usr/local/bin/merod && chmod +x /usr/local/bin/mero-cli \
##    && rm -rf /root/mero*

WORKDIR /root
COPY ./mero_install.sh ./
RUN chmod +x /root/mero_install.sh
CMD [ "mero_install.sh" ]
ENTRYPOINT [ "bash" ]