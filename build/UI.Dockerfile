FROM ubuntu:22.04 AS builder

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends\
        gcc-mingw-w64-x86-64 \
        libappindicator3-dev \
        gir1.2-appindicator3-0.1 \
        libxxf86vm-dev \
        wget \
        build-essential \
        ca-certificates \
        golang-1.24 \
    && echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' | tee /etc/apt/sources.list.d/goreleaser.list \
    && apt-get update && apt-get -y install goreleaser \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* && \
    cd /tmp && \
    wget -q https://github.com/mstorsjo/llvm-mingw/releases/download/20250709/llvm-mingw-20250709-ucrt-ubuntu-22.04-x86_64.tar.xz && \
    echo "60cafae6474c7411174cff1d4ba21a8e46cadbaeb05a1bace306add301628337  llvm-mingw-20250709-ucrt-ubuntu-22.04-x86_64.tar.xz" | sha256sum -c && \
    tar -xf llvm-mingw-20250709-ucrt-ubuntu-22.04-x86_64.tar.xz

ENV PATH="$PATH:/tmp/llvm-mingw-20250709-ucrt-ubuntu-22.04-x86_64/bin"

# Configure Go
ENV GOROOT /usr/lib/go-1.24
ENV PATH $GOROOT/bin:$PATH


WORKDIR /app
COPY . .

RUN goreleaser release --skip=publish,announce,docker -f .goreleaser_ui.yaml

FROM scratch
COPY --from=builder /app/dist .
