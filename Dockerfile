# thewtex/opengl provides opengl functionality, which citra depends on.
FROM thewtex/opengl:latest
USER user
ENV HOME="/home/user"
ENV DEVKITPRO="/opt/devkitPro"
ENV DEVKITARM="${DEVKITPRO}/devkitARM"
ENV CITRA_SDMC="${HOME}/.local/share/citra-emu/sdmc"

ADD ["imagefs/", "/"]

# Install:
RUN sudo apt-get update && sudo apt-get install -y \
    # libsdl2 for citra
    libsdl2-2.0-0 \

    # Required packages for CircleCI
    git \
    ssh \
    tar \
    gzip \
    ca-certificates \
    zip \
    libstdc++6/testing \
    cmake/testing \
    && sudo apt-get -y clean

# The devkitARM archive contains the folder, so it has to be extracted in $DEVKITPRO, not ARM.
ARG devkit_arm_url="https://downloads.sourceforge.net/project/devkitpro/devkitARM/devkitARM_r46/devkitARM_r46-x86_64-linux.tar.bz2"
RUN sudo mkdir -p /tmp/citra /usr/bin/ "${DEVKITPRO}/libctru" && \
    curl -L ${devkit_arm_url} | \
    sudo tar xpjC "${DEVKITPRO}"

# Libctru's archive has all files directly at it's root, so it'l be extracted into the libctru folder.
ARG libctru_url="https://github.com/smealum/ctrulib/releases/download/v1.2.1/libctru-1.2.1.tar.bz2"
RUN curl -L ${libctru_url} | \
    sudo tar xpvj -C "${DEVKITPRO}/libctru"

# Currently libxml2 is not included. See devkitPro/3ds_portlibs#15 for details.
# Currently tremor isn't installed, because it threw some error. I might add it
# back in later.
ARG portlibs_url="https://github.com/devkitPro/3ds_portlibs.git"
RUN git -C /tmp/ clone "${portlibs_url}" && \
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
    sudo rm -rf /tmp/3ds_portlibs

ARG citro3d_url="https://github.com/fincs/citro3d.git"
RUN git -C /tmp/ clone "${citro3d_url}" && \
    sudo -E make -C /tmp/citro3d install && \
    sudo rm -rf /tmp/citro3d

ARG sf2dlib_url="https://github.com/xerpi/sf2dlib.git"
RUN git -C /tmp/ clone "${sf2dlib_url}" && \
    sudo -E make -C /tmp/sf2dlib/libsf2d install && \
    sudo rm -rf /tmp/sf2dlib

ARG sfillib_url="https://github.com/xerpi/sfillib.git"
RUN git -C /tmp/ clone "${sfillib_url}" && \
    sudo -E make -C /tmp/sfillib/libsfil install && \
    sudo rm -rf /tmp/sfillib

ARG sftdlib_url="https://github.com/xerpi/sftdlib.git"
RUN git -C /tmp/ clone "${sftdlib_url}" && \
    sudo -E make -C /tmp/sftdlib/libsftd install && \
    sudo rm -rf /tmp/sftdlib

# Install makerom from source.
RUN git -C /tmp/ clone "https://github.com/profi200/Project_CTR.git" && \
    make -C /tmp/Project_CTR/makerom && \
    sudo mv /tmp/Project_CTR/makerom/makerom /usr/bin && \
    rm -rf /tmp/Project_CTR

# Install bannertool from source
RUN git -C /tmp/ clone --recursive "https://github.com/Steveice10/bannertool.git" && \
    make -C /tmp/bannertool && \
    sudo mv /tmp/bannertool/output/linux-x86_64/bannertool /usr/bin && \
    rm -rf /tmp/bannertool

# Install citra. Citra's archive contains one folder named after it's current build number. Inside are two executables,
# a license and a readme. We only care about `citra`, so we'll just copy it into /usr/bin and remove the rest.
# This should stay a separate layer, since citra has nightly builds and new features are frequently added.
ARG citra_build="citra-linux-20170418-941a3dd"
ARG citra_url="https://github.com/citra-emu/citra-nightly/releases/download/nightly-111/${citra_build}.tar.xz"
RUN curl -L ${citra_url} | \
    sudo tar xpvJC /tmp/ && \
    sudo mv "/tmp/${citra_build}/citra" /usr/bin && \
    sudo rm -rf "/tmp/${citra_build}"

# Override supervisord. thewtex/opengl was intended to run $APP in a noVNC session at startup.
# However, we want to run and build the project and then run citra. To enable us to run this
# script, we need to start bash and then manually run
#   $ sudo /usr/bin/supervisord -c /etc/supervisor/supervisord.conf &
# before running citra.
WORKDIR /home/user
CMD ["/bin/bash"]
