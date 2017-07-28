FROM debian:jessie

RUN REPO=http://cdn-fastly.deb.debian.org && \
    echo "deb $REPO/debian jessie main\ndeb $REPO/debian jessie-updates main\ndeb $REPO/debian-security jessie/updates main" > /etc/apt/sources.list && \
    apt-get update --yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes \
        autogen \
        automake \
        bash \
        bc \
        build-essential \
        bzip2 \
        ca-certificates \
        curl \
        file \
        flex \
        git \
        gzip \
        libtool \
        libcurl4-gnutls-dev \
        make \
        ncurses-dev \
        pax \
        pkg-config \
        rsync \
        ssh \
        tar \
        wget \
        xz-utils \
        zip && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes \
        libgl1-mesa-dri \
        menu \
        net-tools \
        openbox \
        p7zip \
        sudo \
        supervisor \
        tint2 \
        x11-xserver-utils \
        x11vnc \
        xinit \
        xserver-xorg-input-void \
        xserver-xorg-video-dummy && \
    apt-get -y clean && \
    useradd -m -s /bin/bash user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd && cat /etc/motd.3ds-dev' > /etc/bash.rc && \

    true;

USER user

COPY ["imagefs/", "/"]

COPY ["sources.tar.gz", "/usr/share/doc/3ds-dev/"]

ENV DISPLAY=":0" \
    DEVKITPRO="/opt/devkitPro" \
    DEVKITARM="/opt/devkitPro/devkitARM"

# These args are not meant to be set from the command line for public builds.
# They are meant as local variables and should only be changed in this file.
ARG devkitARM_url

# Install:
RUN cp /etc/skel/.xinitrc ~/ && \
    sudo apt-get update && \
    DEBIAN_FRONTEND=noninteractive sudo apt-get install --no-install-recommends --yes \
        # libsdl2 for citra
        libsdl2-2.0-0=2.0.2+dfsg1-6 \

        # Required packages for CircleCI
        libstdc++6/stretch \
        unzip && \
    DEBIAN_FRONTEND=noninteractive sudo apt-get -t jessie-backports install --no-install-recommends --yes cmake && \
    sudo apt-get -y clean && \

    mkdir ~/build && \
    tar -xvzf /usr/share/doc/3ds-dev/sources.tar.gz -C ~/build/ && \

    # The devkitARM archive contains the folder, so it has to be extracted in $DEVKITPRO, not ARM.
    sudo -E mkdir -p $DEVKITARM && \
    curl -L ${devkitARM_url} | sudo tar xpjC "${DEVKITPRO}" && \

    sudo -E make -C ~/build/submodules/ctrulib/libctru install && \

    # Currently libxml2 is not included. See devkitPro/3ds_portlibs#15 for details.
    # Currently tremor isn't installed, because it threw some error. I might add it
    # back in later.
    sudo -E make -C ~/build/submodules/3ds-portlibs \
        GIT=echo \
        zlib \
        install-zlib \
        bzip2 \
        freetype \
        giflib \
        jansson \
        libconfig \
        libexif \
        libjpeg-turbo \
        libmad \
        libogg \
        libpng \
        libxmp-lite \
        mbedtls \
        tinyxml2 \
        xz \
        install && \

    sudo -E make -C ~/build/submodules/citro3d install && \

    sudo -E make -C ~/build/submodules/sf2dlib/libsf2d install && \

    sudo -E make -C ~/build/submodules/sfillib/libsfil install && \

    sudo -E make -C ~/build/submodules/sftdlib/libsftd install && \

    make -C ~/build/submodules/Project_CTR/makerom && \
    sudo mv ~/build/submodules/Project_CTR/makerom/makerom /usr/bin && \

    make -C ~/build/submodules/bannertool && \
    sudo mv ~/build/submodules/bannertool/output/linux-x86_64/bannertool /usr/bin && \

    true;

# Install citra. Citra's archive contains one folder named after it's current
# build number. Inside are two executables, a license and a readme. We only care
# about `citra`, since we already have those files in the included sources, so 
# we'll just copy it into /usr/bin and remove the rest.
# This should stay a separate layer, since citra has nightly builds and new
# features are frequently added.
# We are taking the lazy way out by not compiling citra ourselves to avoid
# having to keep up with build dependencies.
ARG citra_url

RUN mkdir -p /tmp/citra && \
    curl -L ${citra_url} | sudo tar xpvJC /tmp/citra && \
    sudo mv "/tmp/citra/$(dir /tmp/citra)/citra" /usr/bin && \
    sudo rm -rf /tmp/citra && \

    # Create the working directory. WORKDIR would make it owned by root.
    mkdir ~/work && \
    sudo rm -rf ~/build

WORKDIR /home/user/work

ARG git_commit
ARG build_date
ARG version_number

LABEL \
    org.label-schema.schema-version=1.0 \
    org.label-schema.name="3DS Homebrew Development" \
    org.label-schema.description="This image provides tools for building and testing 3ds homebrew applications." \
    org.label-schema.vendor="ahoischen" \
    org.label-schema.vcs-url="https://github.com/ahoischen/3ds-dev-docker" \
    org.label-schema.vcs-ref=${git_commit} \
    org.label-schema.build-date=${build_date} \
    org.label-schema.version=${version_number:-"git-${git_tag}"} \
    maintainer="ahoischen"

CMD ["/bin/bash"]
