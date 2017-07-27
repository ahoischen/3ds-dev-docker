# 3ds-dev-docker
[![](https://images.microbadger.com/badges/image/ahoischen/3ds-dev.svg)](https://microbadger.com/images/ahoischen/3ds-dev "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/ahoischen/3ds-dev.svg)](https://microbadger.com/images/ahoischen/3ds-dev "Get your own version badge on microbadger.com") [![Build Status](https://travis-ci.org/ahoischen/3ds-dev-docker.svg?branch=master)](https://travis-ci.org/ahoischen/3ds-dev-docker)

A docker image for 3ds development and testing

This image aims to provide a preinstalled 3ds development environment including
essential build tools and an emulator to test binaries.

# Important

This project is not in any way affiliated with Nintendo or any of the developers
of included software or packages unless otherwise stated.

Some of the bugs in included software might be caused by their inclusion in this
project. Please create an issue here first to avoid bothering innocent
developers.

# Usage

As a docker image this project requires docker to be installed. While it's very
useful to know about how docker works, this guide assumes you've never heard of
it.

## Running interactively

If you intend to build or test a project manually you should choose this way.
You will want to run the image interactively (`-i`), in a pseudo-tty(`-t`) and
remove the container when you're done (`--rm`). You also specify a version
of the image you want to use. The following command will download the image
(once), start a container based on it, open up a bash prompt for you and remove
the *container* once you are done:

```Bash
docker run --rm -it ahoischen/3ds-dev:tag
```

To use version 1.0.0 of the image simply insert the tag `v1.0.0`:

```Bash
docker run --rm -it ahoischen/3ds-dev:v1.0.0
```

## Running in scripts

If you intend to automate builds or tests this you will need a slightly more
sophisticated approach. The first step of the process is to start a container
from this image, which can then run your commands at a later time. This means
running it in detached mode (`-d`) and specifying a command that keeps the
container from exiting as bash would do. One possible command is
`tail -f /dev/null`. Since you intend to use the container in later commands
you shold give it a name. The full command is as follows:


```
docker run -d --name container_name ahoischen/3ds-dev:tag tail -f /dev/null
```

You now have a container ready to execute all the commands you want. Each
command can now be executed via the following:

```
docker exec container_name COMMAND [ARG...]
```

If you intend to run a script you will need to run it in its own shell:

```
docker exec container_name bash -c "SCRIPT" [ARG...]
```

The easiest way to run a script is of course to include it in your project and
run it as a command (`./myscript`).

## Using your project

While it is possible to use git to pull the project that practice has the
disadvantage of requiring all changes to be already commited and available
on a server. Instead, the preferred method is to mount the source directory as
a volume. This is done by adding the argument `-v YOURSOURCEDIR:/home/user/work`
to the `docker run` commands before specifying the image. Please note that
`YOURSOURCEDIR` cannot be `.`; use `$PWD` instead. Example:

```
docker run --rm -it -v $PWD:/home/user/work ahoischen/3ds-dev
```

## The environment

You will be running as the user `user`. You have passwordless `sudo` access.
Your working directory will be `/home/user/work`. The environment variables
`DEVKITPRO` and `DEVKITARM` are set for `user`; if you need to `make install` 
remember to use `sudo -E` to preserve environment variables. 

## Using the emulator

Emulation can be very useful for running tests. To do so you must first
run `startdisplay` to start a dummy xserver. You can then start the emluator
by running `citra your_file`. Please make sure that the built application does
not require any inputs to exit, since that would cause the script to hang. The
exit code is likely to be non-zero even if all tests succeeded.

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

# Licenses & Included works

This image's source is licensed under the [GPLv3+](./LICENSE) to allow it to
include as many licenses as possible. The licenses of included packages may
differ. Licenses for included software are partially available within the image
and in this document. 
The projects built with this image  **do not necessarily need to be licensed
under the GPLv3+**. Your project's license depends on the licenses of the
projects you use. This software is provided without warranty and so are all
packages aggregated within it, unless otherwise stated by the respective owner.
This isn't legal advice; I am not a lawyer.

This image is based on [thewtex/opengl](https://github.com/thewtex/docker-opengl)
which is licensed under the 
[Apache-2.0 License](https://github.com/thewtex/docker-opengl/blob/master/LICENSE),
[dockcross/dockcross](https://github.com/dockcross/dockcross) which is licensed under the
[MIT License](https://github.com/dockcross/dockcross/blob/master/LICENSE) and
[debian:jessie](https://hub.docker.com/_/debian/).

The built image contains works from many sources. Please utilize the `apt`
tools to obtain licenses and sources for included packages. Some of the sources
of included projects are embedded via git submodules into this project's repo.
Since not all included works are available via git, each binary release is
accompanied by a source release on the
[GitHub releases page](https://github.com/ahoischen/3ds-dev-docker/releases) of
this project.

The built image contains work from multiple projects, including:

- [The Citra emulator](https://github.com/citra-emu/citra)
- [devkitARM](https://sourceforge.net/projects/devkitpro/files/devkitARM/)
- [ctrulib](https://github.com/smealum/ctrulib)
- [The libraries included in ahoischen/3ds-portlibs](https://github.com/ahoischen/3ds-portlibs)
- [citro3d](https://github.com/fincs/citro3d)
- [sf2dlib](https://github.com/xerpi/sf2dlib)
- [sfillib](https://github.com/xerpi/sfillib)
- [sftdlib](https://github.com/xerpi/sftdlib)
- [makerom](https://github.com/profi200/Project_CTR)
- [bannertool](https://github.com/Steveice10/bannertool)

While the source of those projects has not been modified their execution in
this environment may introduce differences in behaviour (such as bugs) for
which their creators are not responsible. Please contact the maintainers of
this project by opening an Issue on the project's
[Issue Tracker](https://github.com/ahoischen/3ds-dev-docker/releases) if you
suspect such a scenario might have arisen.

This project is not in any way affiliated with the creators, contributors,
copyright holders or other involved entities, unless otherwise stated. Consult
the provided links and tools (such as `apt-get`) for each project's licenses
and copyright holders.