FROM debian:bullseye-slim AS builder

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
        && apt-get -y install --no-install-recommends\
           nsis \
           curl \
           p7zip \
           unzip \
           ca-certificates \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        && curl -L -o /tmp/EnVar_plugin.zip https://nsis.sourceforge.io/mediawiki/images/7/7f/EnVar_plugin.zip  \
        && curl -L -o /tmp/ShellExecAsUser_amd64-Unicode.7z https://nsis.sourceforge.io/mediawiki/images/6/68/ShellExecAsUser_amd64-Unicode.7z \
        && unzip /tmp/EnVar_plugin.zip -d /tmp/EnVar \
        && 7zr x /tmp/ShellExecAsUser_amd64-Unicode.7z -o/tmp/ShellExec \
        && mkdir -p /usr/share/nsis/Plugins \
        && cp -r /tmp/EnVar/Plugins/* /usr/share/nsis/Plugins \
        && cp -r /tmp/ShellExec/Plugins/* /usr/share/nsis/Plugins \
        && rm -r /tmp/EnVar_plugin.zip /tmp/ShellExecAsUser_amd64-Unicode.7z /tmp/EnVar /tmp/ShellExec

WORKDIR /app
COPY . .

ENV APPVER=0.0.0.1
RUN mkdir -p dist/netbird_windows_amd64 && \
    curl -L -o /tmp/wintun.zip https://www.wintun.net/builds/wintun-0.14.1.zip && \
    unzip /tmp/wintun.zip -d /tmp/wintun && \
    cp /tmp/wintun/wintun/bin/amd64/wintun.dll dist/netbird_windows_amd64/ && \
    rm -r /tmp/wintun /tmp/wintun.zip && \
    cp dist/netbird_windows_amd64_v1/* dist/netbird_windows_amd64 && \
    cp dist/netbird-ui-windows-amd64_windows_amd64_v1/* dist/netbird_windows_amd64 && \
    makensis -V4 client/installer.nsis

FROM scratch
COPY --from=builder /app/netbird-installer.exe .
