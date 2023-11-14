FROM --platform=linux/amd64 condaforge/miniforge3:23.3.1-1

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apt-utils \
    gcc \
    build-essential \
    curl wget gzip sudo locales

RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid $USER_GID $USERNAME

RUN useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers

RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

# その他環境変数など
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm

USER $USERNAME
WORKDIR /home/$USERNAME

ENV PATH /home/$USERNAME/.local/bin:$PATH


# conda
ENV ENVNAME="LazyB"

COPY environment.yaml /tmp/environment.yaml
RUN mamba env create -n $ENVNAME --file /tmp/environment.yaml

ENV CONDA_DEFAULT_ENV ${ENVNAME}
# Switch default environment
RUN echo "conda activate ${ENVNAME}" >> ~/.bashrc

