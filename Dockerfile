########## ----- Base Image ----- ##########
FROM ubuntu:latest AS base

LABEL Author="PunGrumpy"

RUN apt update -y \
    && apt upgrade -y \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt install -y \
    git \
    landscape-common \
    build-essential \
    gcc \
    cmake \
    python3 \
    python3-pip \
    python3-dev \
    curl

RUN apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip

########## ----- User Image ----- ##########
FROM base AS user

# ARG USERNAME=default
ENV USERNAME=default

RUN useradd -ms /bin/bash ${USERNAME}

USER ${USERNAME}

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/home/${USERNAME}/.cargo/bin:${PATH}"

RUN cargo install lsd

WORKDIR /home/${USERNAME}

COPY ./scripts /home/${USERNAME}/.scripts

COPY ./config/* /home/${USERNAME}/

CMD ["/bin/bash"]