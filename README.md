# 3ds-dev-docker
A docker image for 3ds development and testing

This image aims to provide a preinstalled 3ds development environment including DevkitARM, ctrulib, 
all portlibs(except libmad due to licenses) and a working citra emulator.

This project is not in any way affiliated with nintendo.

# Versioning

This project is versioned according to 
[Semantic Versioning](http://semver.org/spec/v2.0.0.html). As the project is
currently below version 1.0.0 the public API has not been established. However,
initial drafts for it outline the following specifications:

- Packages explicitly provided by this image are part of the public API. 
Currently this includes libctru, devkitARM, all portlibs and citra.

- Packages explicitly provided by this image which use SemVer are guaranteed
to be held at their current major version. The minor and path version may be
incremented at will.

- Packages explicitly provided by this image which do not use SemVer cannot be
guaranteed to not break. When a breaking change within a package becomes known
the major version shall be incremented. This is sadly not reliable.

- The guarantee that there will be no folder ~/work is part of the public API.
This folder is intended to be used as a working directory for builds and CI and,
therefore, cannot include any files as they may conflict with those of the
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
