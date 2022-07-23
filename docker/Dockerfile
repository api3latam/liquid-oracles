FROM alpine:3.15.5@sha256:f223d3b51b1eda2d5e693aac27fda364a0bdd3c6f2e1a433378ae41365da3f47

ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8 USER=root HOME=/home/service

RUN /bin/sh -c "addgroup -g 1001 server && adduser -u 1002 -D -s /bin/sh service server"

WORKDIR ${HOME}

RUN su - service && apk update && \
    apk add boost-dev libevent && \
    wget https://github.com/ElementsProject/elements/releases/download/elements-0.21.0.2/elements-elements-0.21.0.2-x86_64-linux-gnu.tar.gz && \
    tar -xvzf elements-elements-0.21.0.2-x86_64-linux-gnu.tar.gz && \
    cp elements-elements-0.21.0.2/bin/* /usr/local/bin && \
    cp elements-elements-0.21.0.2/lib/* /usr/local/lib && \
    cp elements-elements-0.21.0.2/share/* /usr/local/share && \
    cp elements-elements-0.21.0.2/include/* /usr/local/include && \
    rm -rf elements-elements-0.21.0.2 && \
    mkdir $HOME/.elements

COPY regtest.elements.conf $HOME/.elements/elements.conf

RUN /bin/sh -c "git clone https://github.com/api3latam/PyLiquid2EVM.git" && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt update && \
    apt install python3.9.10 && \
    cd PyLiquid2EVM && python3.9 -m pip install -r --no-cache-dir --upgrade requirements.txt

WORKDIR $HOME/PyLiquid2EVM

CMD ["python3.9 -m uvicorn ./pyliquid/main:app"]
