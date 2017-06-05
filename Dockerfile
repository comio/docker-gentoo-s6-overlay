ARG GENTOO_RELEASE

FROM gentoo/stage3-amd64:${GENTOO_RELEASE:-latest}

LABEL maintainer "Luigi 'Comio' Mantellini <luigi.mantellini@gmail.com>"

ARG GENTOO_RELEASE
ARG IMAGE_RELEASE
ARG BUILD_DATE

LABEL gentoo_release="${GENTOO_RELEASE}"
LABEL image_relase="${IMAGE_RELEASE}"
LABEL build_date="${BUILD_DATE}"
LABEL build_version="comio/gentoo-s6-overlay Release: ${IMAGE_RELEASE} Build-date: ${BUILD_DATE} Gentoo-Release: ${GENTOO_RELEASE}"

WORKDIR /

RUN \

# Download and unzip the Portage tree
    mkdir -p /usr && \
    wget http://distfiles.gentoo.org/snapshots/portage-${GENTOO_RELEASE}.tar.bz2 && \
    bzcat /portage-${GENTOO_RELEASE}.tar.bz2 | tar -xf - -C /usr && \
    mkdir -p /usr/portage/distfiles /usr/portage/metadata /usr/portage/packages && \

# Enable ~amd64 for required packages
    echo sys-apps/s6-portable-utils ~amd64 >> /etc/portage/package.accept_keywords && \
    echo dev-libs/skalibs ~amd64 >> /etc/portage/package.accept_keywords && \
    echo app-emulation/s6-overlay ~amd64 >> /etc/portage/package.accept_keywords && \
    echo dev-lang/execline ~amd64 >> /etc/portage/package.accept_keywords && \
    echo sys-apps/s6  ~amd64 >> /etc/portage/package.accept_keywords && \

# Emerge the package (and its dependencies)
    emerge -v app-emulation/s6-overlay && \

# Cleanup
    rm -rf /usr/portage /var/tmp/portage /portage-${GENTOO_RELEASE}.tar.bz2

ENTRYPOINT ["/init"]

