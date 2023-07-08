########## ----- Base Image ----- ##########
FROM ubuntu:23.10 AS base

LABEL Author="PunGrumpy"

RUN apt update -y \
    && apt upgrade -y \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt install -y \
    sudo \
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

########## ----- User Image ----- ##########
FROM base AS user

ARG USERNAME=default

RUN useradd -ms /bin/bash ${USERNAME}

RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/home/${USERNAME}/.cargo/bin:${PATH}"

RUN cargo install lsd

WORKDIR /home/${USERNAME}

COPY ./scripts /home/${USERNAME}/.scripts

COPY ./config/* /home/${USERNAME}/

RUN sudo chmod +x /home/${USERNAME}/.scripts/*

RUN sudo cp /home/${USERNAME}/.scripts/game_beginner.sh /usr/bin/game_beginner

CMD ["/bin/bash"]