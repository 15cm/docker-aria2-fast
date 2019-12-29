From 15cm/s6-archlinux:latest

ARG PKG_NAME=aria2-fast
ARG TMP_INSTALL_LIST=/tmp/tmp_install_list.txt

RUN pacman -Sy --noconfirm

RUN pacman -Sp base-devel --print-format '%n' --needed > ${TMP_INSTALL_LIST} \
    && pacman -S --noconfirm base-devel

RUN useradd --no-create-home --shell=/bin/false builduser \
    && usermod -L builduser \
    && echo 'builduser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && mkdir -p /build \
    && chown builduser /build

USER builduser
WORKDIR /build
RUN curl -O -L https://aur.archlinux.org/cgit/aur.git/snapshot/${PKG_NAME}.tar.gz \
    && tar xf ${PKG_NAME}.tar.gz \
    && cd ${PKG_NAME} \
    && MAKEFLAGS="-j$(nproc)" makepkg --noconfirm -si

USER root
WORKDIR /

# Clean up
RUN userdel builduser \
    && rm -rf /build \
    ; pacman --noconfirm -Rnu - < ${TMP_INSTALL_LIST} \
    ; pacman --noconfirm -Rns $(pacman -Qtdq) \
    ; pacman --noconfirm -Scc

COPY root/ /

EXPOSE 6800 6801 6802

VOLUME ["/config", "/downloads"]
