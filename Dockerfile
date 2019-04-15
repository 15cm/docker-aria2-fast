From archlinux/base

ARG PKG_NAME=aria2-fast

RUN pacman -Sy --noconfirm

RUN pacman -S --noconfirm \
    base-devel

RUN useradd --no-create-home --shell=/bin/false builduser \
    && usermod -L builduser \
    && echo 'builduser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN mkdir -p /build \
    && chown builduser /build

USER builduser
WORKDIR /build
RUN curl -O -L https://aur.archlinux.org/cgit/aur.git/snapshot/${PKG_NAME}.tar.gz \
    && tar xf ${PKG_NAME}.tar.gz

RUN cd ${PKG_NAME} \
    && makepkg --noconfirm -si

USER root
WORKDIR /

# Create files
RUN mkdir -p /var/log/aria2 \
    && touch /var/log/aria2/aria2.log /var/log/aria2/aria2.session \
    && chmod -R 777 /var/log/aria2

# Clean up
RUN rm -rf /build \
    && pacman --noconfirm -Scc \
    && pacman --noconfirm -Rns $(pacman -Qtdq)

ADD run.sh /run.sh
RUN chmod a+x /run.sh

VOLUME ["/config"]

EXPOSE 6800 6801 6802

CMD ["/run.sh"]
