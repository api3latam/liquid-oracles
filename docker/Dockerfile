FROM alpine:3.15.5@sha256:26284c09912acfc5497b462c5da8a2cd14e01b4f3ffa876596f5289dd8eab7f2

ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8 USER=root HOME=/home/service

RUN /bin/sh -c "apk update && apk add sudo" && \
    adduser -u 1002 -D -s /bin/sh service wheel

WORKDIR ${HOME}

RUN su - service && apk update && \
    apk add git boost-dev libevent && \
    wget https://github.com/ElementsProject/elements/releases/download/elements-0.21.0.2/elements-elements-0.21.0.2-x86_64-linux-gnu.tar.gz && \
    tar -xvzf elements-elements-0.21.0.2-x86_64-linux-gnu.tar.gz && \
    cp elements-elements-0.21.0.2/bin/* /usr/local/bin && \
    cp elements-elements-0.21.0.2/lib/* /usr/local/lib && \
    cp -r elements-elements-0.21.0.2/share/* /usr/local/share && \
    cp elements-elements-0.21.0.2/include/* /usr/local/include && \
    rm -rf elements-elements-0.21.0.2 && \
    mkdir $HOME/.elements

COPY regtest.elements.conf $HOME/.elements/elements.conf

RUN su - service && \
    apk add --no-cache make g++ llvm libressl-dev \
        zlib-dev libbz2 libffi-dev sqlite-dev ncurses-dev \
        xz tk-dev libxml2-dev libuv python3-dev && \
    git clone https://github.com/api3latam/PyLiquid2EVM.git && \
    apk add --no-cache python3=~3.9 && \
    cd PyLiquid2EVM && python3.9 -m ensurepip &&\
    python3.9 -m pip install --upgrade pip && \
    python3.9 -m pip install -r requirements.txt 

WORKDIR $HOME/PyLiquid2EVM

CMD ["python3.9 -m uvicorn pyliquid.main:app"]
