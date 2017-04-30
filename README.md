# 3ds-dev-docker
A docker image for 3ds development and testing

This image aims to provide a preinstalled 3ds development environment including DevkitARM, ctrulib, 
all portlibs and a working citra emulator.

This project is not in any way affiliated with nintendo.

# Usage

As a docker image this project requires docker to be installed. While it's very
useful to know about how docker works, this guide assumes you've never heard of
it.

## Running interactively

If you intend to build or test a project manually you should choose this way.
You will want to run the image interactively (`-i`), in a pseudo-tty(`-t`) and
remove the container when you're done (`--rm`). You can also specify a version
of the image you want to use. If you omit this tag you'll get the `latest`
version which is up to date with the current master. The following command will
download the image (once), start a container based on it, open up a bash prompt
for you and remove the *container* once you are done:

```Bash
docker run --rm -it ahoischen/3ds-dev[:tag]
```

To use version 1.0.0 of the image simply insert the tag `1.0.0`:

```Bash
docker run --rm -it ahoischen/3ds-dev:1.0.0
```

## Running in scripts

If you intend to automate builds or tests this you will need a slightly more
sophisticated approach. The first step of the process is to start a container
from this image, which can then run your commands at a later time. This means
running it in detached mode (`-d`) and specifying a command that keeps the
container from exiting as bash would do. One possible command is
`tail -f /dev/null`. For automatic testing it is also advised to fix your
version number to avoid accidental breakage. Since you intend to use the
container in later commands you shold give it a name. The full command
is as follows:


```Bash
docker run -d --name container_name ahoischen/3ds-dev[:tag] tail -f /dev/null
```

You now have a container ready to execute all the commands you want. Each
command can now be executed via the following:

```Bash
docker exec container_name COMMAND [ARG...]
```

If you intend to run a script you will need to run it in its own shell:

```Bash
docker exec container_name bash -c "SCRIPT" [ARG...]
```

The easiest way to run a script is of course to include it in your project and
run it as a command (`./myscript`).

## Using your project

While it is possible to use git inside it that practice is highly discouraged
since it requires all changes to be already commited and available on a server.
Instead, the preferred method is to mount the source directory as a volume.
This is done by adding the `-v YOURSOURCEDIR:/home/user/work` to the
`docker run` arguments before specifying the image. Please note that 
`YOURSOURCEDIR` cannot be `.`; use `$PWD` instead. Example:

```Bash
docker run --rm -it -v $PWD:/home/user/work ahoischen/3ds-dev
```

## The environment

You will be running as the user `user`. You have passwordless `sudo` access.
Your working directory will be `/home/user/work`. `$DEVKITPRO` and `ARM` are
set for `user`; if you need to `make install` remember to use `sudo -E` to
preserve environment variables. 

***TODO: INCLUDE LIST OF PROGRAMS***

## Using citra

Citra can be very useful for running tests. To do so you must first
run `sudo /usr/bin/supervisord -c /etc/supervisor/supervisord.conf &` to start a
dummy xserver. You should wait around 3 seconds for it to come online before
starting citra by running `citra your_file`. Please make sure that the built
application does not require any inputs to exit, since that would cause the
script to hang.


# Versioning

This project attempts to version similarly to 
[Semantic Versioning](http://semver.org/spec/v2.0.0.html), however, most
dependencies don't have fixed versions. Because of this there are probably
breaking changes in minor and patch updates. The only thing that can be
guaranteed is that if any of the following changes the version shall be
increased accordingly.

- Packages explicitly provided by this image are part of the public API. 
Currently this includes libctru, devkitARM, all portlibs which compile and 
citra.

- The guarantee that there will be an empty folder ~/work is part of the public
API. This folder is intended to be used as a working directory for builds and CI
and, therefore, cannot include any files as they may conflict with those of the
project.

# Contributing

Contributions in form of issues and pull requests are encouraged. This project
includes a [CONTRIBUTING](./CONTRIBUTING.md) file which outlines the details of doing so.

# Licenses
This image itself is licensed under the [GPLv3+](./LICENSE) to allow it to
include as many licenses as possible. The projects built with this image 
**do not need to be Licensed under the GPLv3+**. Your project's license depends
on the licenses of the projects you use. This software is provided without
warranty and so are all packages within it, unless otherwise stated by the
respective owner.

The precise license terms are available within this project's
[LICENSE file](./LICENSE).

This image is based on thewtex/opengl which is licensed under the 
[Apache-2.0 License](https://github.com/thewtex/docker-opengl/blob/master/LICENSE)
and dockcross/dockcross which is licensed under the
[MIT License](https://github.com/dockcross/dockcross/blob/master/LICENSE).
The following list aims to describe the licenses of all included
software. It is not comprehensive due to the number of packages installed.
Any contributions to it are greatly appreciated. None of these packages were
created by me. All copyright belongs to their respective owners. None provide
warranty unless otherwise stated.

| Software | License | Author | Year |
| --- | --- | --- | --- |
| bzip2 | [BSD Style License](https://github.com/asimonov-im/bzip2/blob/master/LICENSE) | Julian R Seward | 1996-2010 |
| citra | [GPLv2](https://github.com/citra-emu/citra/blob/master/license.txt) | | |
| devkitARM | BSD License | ? | ? |
| FreeType Library | [FTL License](http://git.savannah.gnu.org/cgit/freetype/freetype2.git/tree/docs/FTL.TXT) | | |
| GIFLIB | [MIT](https://github.com/wasamasa/giflib/blob/master/LICENSE) | Vasilij Schneidermann | 2016 |
| jansson | [MIT](https://github.com/akheron/jansson/blob/master/LICENSE) | Petri Lehtinen | 2009-2016 |
| libconfig | [LGPLv3](http://www.hyperrealm.com/libconfig/) (x?)or? [LGPLv2](https://github.com/hyperrealm/libconfig/blob/master/COPYING.LIB) | | |
| libctru | [zlib License](https://github.com/smealum/ctrulib/blob/master/README.md) | | |
| libexif | [LGPLv2.1](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html) | | |
| libjpeg-turbo | [3 BSD style licenses](https://github.com/libjpeg-turbo/libjpeg-turbo/blob/master/LICENSE.md)) | <AUTHOR> | <YEAR> |
| libmad | [GPLv2](http://www.underbit.com/resources/license/gpl) | | |
| libogg | [BSD-3-Clause](https://github.com/gcp/libogg/blob/master/COPYING) | Xiph.org Foundation | 2002 |
| libpng | [zlib License](http://www.libpng.org/pub/png/src/libpng-LICENSE.txt) | Glenn Randers-Pehrson | 2000-2002, 2004, 2006-2017 |
| libxml2 | [MIT](https://opensource.org/licenses/mit-license.html) | | |
| libxmp-lite | [LGPLv2.1+](https://www.gnu.org/licenses/lgpl.html) | | |
| mbedtls | [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0) | | |
| sqlite | [Public Domain](https://sqlite.org/copyright.html) | | |
| tinyxml2 | [zlib](https://github.com/leethomason/tinyxml2/blob/master/readme.md) | | |
| tremor | [New BSD License](https://git.xiph.org/?p=tremor.git;a=blob;f=COPYING;h=6111c6c5a6b95057e43d36b7c217b073bf5f9b22;hb=HEAD) | Xiph.org Foundation | 2002 |
| xz | [Public Domain, GPLv2+](https://git.tukaani.org/?p=xz.git;a=blob;f=COPYING) | | |
| zlib | [zlib License](https://github.com/madler/zlib/blob/master/README)| Jean-loup Gailly and Mark Adler | 1995-2017 |
