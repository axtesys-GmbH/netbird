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
        golang-1.23 \
    && echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' | tee /etc/apt/sources.list.d/goreleaser.list \
    && apt-get update && apt-get -y install goreleaser \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \

# Configure Go
ENV GOROOT /usr/lib/go-1.23
ENV PATH $GOROOT/bin:$PATH


WORKDIR /app
COPY . .

RUN goreleaser release --skip=publish,announce,docker -f .goreleaser_ui_darwin.yaml

FROM scratch
COPY --from=builder /app/dist .
