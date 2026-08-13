FROM kasmweb/debian-trixie-desktop:1.18.0

USER root

# Install dependencies + Zen Browser
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget ca-certificates \
        libdbus-glib-1-2 \
        libgtk-3-0 \
        libasound2 \
        libxt6 \
        libxrender1 \
        libnotify4 \
    && wget -q "https://github.com/zen-browser/desktop/releases/latest/download/zen-browser.deb" -O /tmp/zen.deb \
    && dpkg -i /tmp/zen.deb || apt-get install -f -y \
    && rm /tmp/zen.deb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Container-friendly Firefox-based browser settings
ENV MOZ_DISABLE_CONTENT_SANDBOX=1
ENV MOZ_ARG_OVERRIDE="--no-sandbox"

# Desktop icon
RUN mkdir -p /usr/share/applications && \
    printf '[Desktop Entry]\nName=Zen Browser\nExec=/usr/bin/zen-browser --no-sandbox %%u\nIcon=zen-browser\nType=Application\nCategories=Network;WebBrowser;\n' \
    > /usr/share/applications/zen-browser.desktop

USER kasm-user
