FROM fedora:42

ARG VERSION=no-version
ENV VERSION=$VERSION

# Install required packages including Flatpak
RUN dnf -y update && \
    dnf -y install \
    flatpak \
    ffmpeg \
    && dnf clean all

# Configure Flatpak to work in unprivileged mode
ENV FLATPAK_SYSTEM_DIR=/var/lib/flatpak
ENV FLATPAK_SYSTEM_HELPER_ON_SESSION=0
ENV FLATPAK_ENABLE_SUDO=0

# Add Flathub repository and install KiCad
RUN flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo && \
    flatpak --user install -y --noninteractive flathub org.kicad.KiCad

# Copy scripts
COPY *.sh /usr/bin/

# Make scripts executable
RUN chmod +rx /usr/bin/render-pcb.sh && chmod +rx /usr/bin/kicad_animation.sh

WORKDIR /pwd