FROM mcr.microsoft.com/vscode/devcontainers/base:alpine

RUN apk add --no-cache --virtual litex-build-dependencies \
    build-base \
    dtc \
    git \
    py3-setuptools \
    python3-dev \
    gettext-doc \
    gettext-dev \
    tk \
    bash \
    boost-python3 \
    boost-dev \
    py3-pip

ADD oss-cad-suite-linux-x64-*.tgz /opt

ADD https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py /opt/litex/

WORKDIR /opt/litex

ENV PATH="/opt/oss-cad-suite/bin:$PATH" \
    VERILATOR_ROOT="/opt/oss-cad-suite/share/verilator" \
    GHDL_PREFIX="/opt/oss-cad-suite/lib/ghdl"
RUN python3 ./litex_setup.py init && \
    python3 ./litex_setup.py install
