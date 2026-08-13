FROM kasmweb/debian-trixie-desktop:1.18.0

USER root

# Remove broken third-party repos from base image, then install dependencies
RUN find /etc/apt/sources.list.d/ -type f -not -name '*.debian*' -not -name '*debian*' -delete 2>/dev/null; \
    rm -f /etc/apt/trusted.gpg.d/* 2>/dev/null; \
    apt-get update -o Acquire::AllowInsecureRepositories=true \
    -o Dir::Etc::sourcelist="/dev/null" \
    -o Dir::Etc::sourceparts="/dev/null" \
    && echo 'deb http://deb.debian.org/debian trixie main' > /etc/apt/sources.list \
    && echo 'deb http://deb.debian.org/debian trixie-updates main' >> /etc/apt/sources.list \
    && echo 'deb http://deb.debian.org/debian-security trixie-security main' >> /etc/apt/sources.list \
    && rm -rf /etc/apt/sources.list.d/* \
    && apt-get update && \
    apt-get install -y --no-install-recommends \
        wget ca-certificates xz-utils \
        libdbus-glib-1-2 \
        libgtk-3-0 \
        libasound2 \
        libxt6 \
        libxrender1 \
        libnotify4 \
        libnss3 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libcurl4 \
        libxcb-shm0 \
    && rm -rf /var/lib/apt/lists/*

# Download and install Zen Browser from tarball
ARG ZEN_ARCH=x86_64
RUN wget -q "https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-${ZEN_ARCH}.tar.xz" -O /tmp/zen.tar.xz && \
    mkdir -p /opt/zen && \
    tar xf /tmp/zen.tar.xz -C /opt/zen --strip-components=1 && \
    rm /tmp/zen.tar.xz && \
    ln -sf /opt/zen/zen /usr/local/bin/zen-browser && \
    chmod +x /usr/local/bin/zen-browser

# Container-friendly settings
ENV MOZ_DISABLE_CONTENT_SANDBOX=1

# Desktop shortcut
RUN mkdir -p /usr/share/applications && \
    printf '[Desktop Entry]\nName=Zen Browser\nExec=/usr/local/bin/zen-browser --no-sandbox %%u\nIcon=/opt/zen/browser/chrome/icons/default/default128.png\nType=Application\nCategories=Network;WebBrowser;\n' \
    > /usr/share/applications/zen-browser.desktop

USER kasm-user
