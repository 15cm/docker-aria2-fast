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

ENV CONFIG_PATH=/config/aria2.conf
ENV LOG_DIR=/var/log/aria2
ENV DOWNLOAD_PATH=/download/default

# Create necessary files
RUN mkdir -p ${LOG_DIR} \
    && touch ${LOG_DIR}/aria2.log ${LOG_DIR}/aria2.session \
    && chmod -R 777 ${LOG_DIR} \
    && mkdir -p ${DOWNLOAD_PATH}

# Clean up
RUN rm -rf /build \
    && pacman --noconfirm -Scc \
    && pacman --noconfirm -Rns $(pacman -Qtdq)

VOLUME ["/config"]

EXPOSE 6800 6801 6802

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
