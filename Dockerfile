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
    echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user

ADD ["imagefs/", "/"]

WORKDIR /home/user/work
USER user

ENV DISPLAY :0
ENV HOME="/home/user"
ENV DEVKITPRO="/opt/devkitPro"
ENV DEVKITARM="${DEVKITPRO}/devkitARM"
ENV CITRA_SDMC="${HOME}/.local/share/citra-emu/sdmc"

# These args are not meant to be set from the command line for public builds.
# They are meant as local variables and should only be changed in this file.
ARG devkit_arm_gdb_url="https://downloads.sourceforge.net/project/devkitpro/devkitARM/3ds-gdb-8.0-x86_64-linux.7z"
ARG devkit_arm_url="https://downloads.sourceforge.net/project/devkitpro/devkitARM/devkitARM_r46/devkitARM_r46-x86_64-linux.tar.bz2"
ARG libctru_url="https://github.com/smealum/ctrulib/releases/download/v1.2.1/libctru-1.2.1.tar.bz2"
ARG portlibs_url="https://github.com/devkitPro/3ds_portlibs.git"
ARG citro3d_url="https://github.com/fincs/citro3d.git"
ARG sf2dlib_url="https://github.com/xerpi/sf2dlib.git"
ARG sfillib_url="https://github.com/xerpi/sfillib.git"
ARG sftdlib_url="https://github.com/xerpi/sftdlib.git"
ARG citra_build="citra-linux-20170629-686fde7"
ARG citra_url="https://github.com/citra-emu/citra-nightly/releases/download/nightly-111/${citra_build}.tar.xz"
ARG makerom_url="https://github.com/profi200/Project_CTR/releases/download/0.15/makerom_015_ctrtool.zip"

# Install:
RUN cp /etc/skel/.xinitrc /home/user/ && \
    sudo apt-get update && \
    DEBIAN_FRONTEND=noninteractive sudo apt-get install --no-install-recommends --yes \
        # libsdl2 for citra
        libsdl2-2.0-0 \

        # Required packages for CircleCI
        libstdc++6/testing \
        cmake/testing && \
    sudo apt-get -y clean && \

    # The devkitARM archive contains the folder, so it has to be extracted in $DEVKITPRO, not ARM.
    sudo mkdir -p /tmp/citra /usr/bin/ "${DEVKITPRO}/libctru" && \
    curl -L ${devkit_arm_url} | sudo tar xpjC "${DEVKITPRO}" && \

    # r46 requies a patch to work with gdb on latest luma.
    curl -o /tmp/devkitARMgdb.7z -L ${devkit_arm_gdb_url} && \
    7z e /tmp/devkitARMgdb.7z -o"${DEVKITPRO}/devkitARM" && \
    rm /tmp/devkitARMgdb.7z && \

    # Libctru's archive has all files directly at it's root, so it'l be extracted into the libctru folder.
    curl -L ${libctru_url} | \
    sudo tar xpvj -C "${DEVKITPRO}/libctru" && \

    # Download makerom and ctrtool.
    curl -o /tmp/makerom.zip -L "${makerom_url}" && \
    unzip /tmp/makerom.zip -d /tmp/makerom && \
    sudo cp /tmp/makerom/Linux_x86_64/* /usr/bin && \
    rm -r /tmp/makerom* && \

    # Currently libxml2 is not included. See devkitPro/3ds_portlibs#15 for details.
    # Currently tremor isn't installed, because it threw some error. I might add it
    # back in later.
    git -C /tmp/ clone "${portlibs_url}" && \
    sudo -E make -C /tmp/3ds_portlibs \
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
        sqlite \
        tinyxml2 \
        xz \
        install && \
    sudo rm -rf /tmp/3ds_portlibs && \

    git -C /tmp/ clone "${citro3d_url}" && \
    sudo -E make -C /tmp/citro3d install && \
    sudo rm -rf /tmp/citro3d && \

    git -C /tmp/ clone "${sf2dlib_url}" && \
    sudo -E make -C /tmp/sf2dlib/libsf2d install && \
    sudo rm -rf /tmp/sf2dlib && \

    git -C /tmp/ clone "${sfillib_url}" && \
    sudo -E make -C /tmp/sfillib/libsfil install && \
    sudo rm -rf /tmp/sfillib && \

    git -C /tmp/ clone "${sftdlib_url}" && \
    sudo -E make -C /tmp/sftdlib/libsftd install && \
    sudo rm -rf /tmp/sftdlib && \

    # Install makerom from source.
    git -C /tmp/ clone "https://github.com/profi200/Project_CTR.git" && \
    make -C /tmp/Project_CTR/makerom && \
    sudo mv /tmp/Project_CTR/makerom/makerom /usr/bin && \
    rm -rf /tmp/Project_CTR && \

    # Install bannertool from source
    git -C /tmp/ clone --recursive "https://github.com/Steveice10/bannertool.git" && \
    make -C /tmp/bannertool && \
    sudo mv /tmp/bannertool/output/linux-x86_64/bannertool /usr/bin && \
    rm -rf /tmp/bannertool && \

    true;

# Install citra. Citra's archive contains one folder named after it's current
# build number. Inside are two executables, a license and a readme. We only care
# about `citra`, so we'll just copy it into /usr/bin and remove the rest.
# This should stay a separate layer, since citra has nightly builds and new
# features are frequently added.
RUN curl -L ${citra_url} | sudo tar xpvJC /tmp/ && \
    sudo mv "/tmp/${citra_build}/citra" /usr/bin && \
    sudo rm -rf "/tmp/${citra_build}"

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
