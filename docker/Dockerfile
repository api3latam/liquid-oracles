FROM ubuntu:20.04@sha256:b2339eee806d44d6a8adc0a790f824fb71f03366dd754d400316ae5a7e3ece3e

ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8 USER=root HOME=/home

WORKDIR ${HOME}

RUN apt-get update && \
    apt-get install -yqq --no-install-recommends wget curl && \
    wget https://github.com/ElementsProject/elements/releases/download/elements-0.21.0.2/elements-elements-0.21.0.2-x86_64-linux-gnu.tar.gz  --no-check-certificate && \
    tar -xvzf elements-elements-0.21.0.2-x86_64-linux-gnu.tar.gz && \
    cp elements-elements-0.21.0.2/bin/* /usr/local/bin && \
    cp elements-elements-0.21.0.2/lib/* /usr/local/lib && \
    cp -r elements-elements-0.21.0.2/share/* /usr/local/share && \
    cp elements-elements-0.21.0.2/include/* /usr/local/include && \
    rm -rf elements-elements-0.21.0.2 && rm elements-elements-0.21.0.2-x86_64-linux-gnu.tar.gz && \
    mkdir $HOME/.elements

COPY regtest.elements.conf $HOME/.elements/elements.conf

RUN apt-get install -yqq make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev llvm \
        libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
        libffi-dev liblzma-dev python3-dev software-properties-common

RUN add-apt-repository ppa:deadsnakes/ppa && apt-get update && \
    apt-get install -yqq python3.9 python3-pip git sudo && \
    apt-get autoclean

RUN git clone https://github.com/api3latam/PyLiquid2EVM.git && \
    cd PyLiquid2EVM && git checkout dev && \
    python3.9 -m pip install --upgrade pip && \
    python3.9 -m pip install -r requirements.txt --ignore-installed PyYAML
    
WORKDIR $HOME/PyLiquid2EVM

EXPOSE 8000

CMD ["python3.9 -m uvicorn pyliquid.main:app --reload"]
