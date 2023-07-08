########## ----- Base Image ----- ##########
FROM ubuntu:23.10 AS base

LABEL Author="PunGrumpy"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    sudo \
    git \
    landscape-common \
    build-essential \
    gcc \
    cmake \
    lsd \
    python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

########## ----- User Image ----- ##########
FROM base AS user

ARG USERNAME=default

RUN useradd -ms /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH="/home/${USERNAME}/.cargo/bin:${PATH}"

WORKDIR /home/${USERNAME}

COPY ./scripts /home/${USERNAME}/.scripts

COPY ./config/* /home/${USERNAME}/

RUN sudo chmod +x /home/${USERNAME}/.scripts/*

RUN sudo cp /home/${USERNAME}/.scripts/game_beginner.sh /usr/bin/game_beginner

CMD ["/bin/bash"]
