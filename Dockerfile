########## ----- Base Image ----- ##########
FROM ubuntu:24.04 AS base

LABEL Author="PunGrumpy"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    sudo \
    git \
    gpg \
    wget \
    neovim \
    landscape-common \
    build-essential \
    gcc \
    cmake \
    curl \
    python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/apt/keyrings \
    && wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" > /etc/apt/sources.list.d/gierens.list \
    && chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    eza \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

########## ----- User Image ----- ##########
FROM base AS user

ARG USER=default
RUN useradd -ms /bin/bash ${USER} \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USER}
ENV USER=${USER}
ENV color_prompt=yes

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/${USER}/.cargo/bin:${PATH}"

WORKDIR /home/${USER}
COPY ./scripts /home/${USER}/.scripts
COPY ./config/* /home/${USER}/

RUN sudo chmod +x /home/${USER}/.scripts/*

RUN sudo cp /home/${USER}/.scripts/game_beginner.sh /usr/bin/game_beginner

USER ${USER}

CMD ["/bin/bash"]
