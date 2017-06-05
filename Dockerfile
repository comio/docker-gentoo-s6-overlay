ARG GENTOO_RELEASE

FROM gentoo/stage3-amd64:$GENTOO_RELEASE
LABEL maintainer "Luigi 'Comio' Mantellini"

ARG GENTOO_RELEASE

WORKDIR /

RUN mkdir -p /usr && \
    wget http://distfiles.gentoo.org/snapshots/portage-${GENTOO_RELEASE}.tar.bz2 && \
    bzcat /portage-${GENTOO_RELEASE}.tar.bz2 | tar -xf - -C /usr && \
    mkdir -p /usr/portage/distfiles /usr/portage/metadata /usr/portage/packages && \
    echo sys-apps/s6-portable-utils ~amd64 >> /etc/portage/package.accept_keywords && \
    echo dev-libs/skalibs ~amd64 >> /etc/portage/package.accept_keywords && \
    echo app-emulation/s6-overlay ~amd64 >> /etc/portage/package.accept_keywords && \
    echo dev-lang/execline ~amd64 >> /etc/portage/package.accept_keywords && \
    echo sys-apps/s6  ~amd64 >> /etc/portage/package.accept_keywords && \
    emerge -v app-emulation/s6-overlay && \
    rm -rf /usr/portage /var/tmp/portage /portage-${GENTOO_RELEASE}.tar.bz2

ENTRYPOINT ["/init"]