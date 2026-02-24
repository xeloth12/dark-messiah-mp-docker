FROM ubuntu:24.04

ARG STEAM_UID=1001

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        lib32gcc-s1 \
        curl \
        ca-certificates \
        wine32 \
        xvfb \
        winbind \
        x11-utils \
        python3-pip && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix && \
    ln -s /usr/lib/wine/wine /usr/bin/wine

RUN useradd -m steam
USER steam

RUN mkdir -p /home/steam/darkmessiah/custom_scripts
WORKDIR /home/steam/steamcmd
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
RUN pip3 install vpk --break-system-packages --no-warn-script-location

COPY scripts/vpks_extraction.py /home/steam/darkmessiah/custom_scripts
COPY scripts/laa_patch.py /home/steam/darkmessiah/custom_scripts

USER root
COPY scripts/entrypoint.sh /home/steam/darkmessiah/custom_scripts
RUN chmod +x /home/steam/darkmessiah/custom_scripts/entrypoint.sh && \
    chown steam:steam /home/steam/darkmessiah/custom_scripts/entrypoint.sh

ENV WINEPREFIX=/home/steam/.wine
ENV WINEESYNC=1
ENV DISPLAY=:1

EXPOSE 27015/udp
EXPOSE 27015/tcp

USER steam
ENTRYPOINT ["/home/steam/darkmessiah/custom_scripts/entrypoint.sh"]