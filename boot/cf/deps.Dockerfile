ARG SRC_PATH=r.cfcr.io/hysmagus
ARG SRC_NAME=build_os_libs
ARG SRC_TAG=develop

FROM ${SRC_PATH}/${SRC_NAME}:${SRC_TAG}
ENV SRC_IMG=${SRC_PATH}/${SRC_NAME}:${SRC_TAG}

ARG BUILD_TARGET=linux
ENV BUILD_TARGET=${BUILD_TARGET}


#COPY source
RUN mkdir -p /DAPS/
COPY . /DAPS/

#BUILD dependencies, autogen, configure, then make
RUN su && cd /DAPS/depends &&  \
    apt-get update && \
#    
    if [ "$BUILD_TARGET" = "windowsx64" ]; \
      then echo "Building dependencies for windows x64 cross-compile..." && \
        DEBIAN_FRONTEND=noninteractive apt-get install g++-mingw-w64-x86-64 -y --fix-missing && \
        #use posix G++ compiler
        echo "1\n" | update-alternatives --config x86_64-w64-mingw32-g++; \
        #strip PATH
        PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g') && \
        #make dependencies
        make HOST=x86_64-w64-mingw32 -j2 && \
        echo -e "Windows x64 Dependencies Build complete."; \
#
    elif [ "$BUILD_TARGET" = "windowsx86" ]; \
      then echo "Building dependencies for windows x86 cross-compile..." && \
        DEBIAN_FRONTEND=noninteractive apt-get install g++-mingw-w64-i686 mingw-w64-i686-dev -y --fix-missing && \
        #use posix G++ compiler
        echo "1\n" | update-alternatives --config i686-w64-mingw32-g++; \
        #strip PATH
        PATH=$(echo "$PATH" | sed -e 's/:\/mnt.*//g') && \
        #make dependencies
        make HOST=i686-w64-mingw32 -j2 && \
        echo -e "Windows x86 Dependencies Build complete."; \
#
    elif [ "$BUILD_TARGET" = "linux" ]; \
      then echo "Building dependencies for linux..." && \
        make HOST=x86_64-pc-linux-gnu -j2 && \
        echo -e "Linux (x86_64-pc-linux-gnu) Dependencies Build complete."; \
#
	elif [ "$BUILD_TARGET" = "linuxarm64" ]; \
      then echo "Building dependencies for Linux ARM 64-bit (aarch64-linux-gnu)..." && \
        DEBIAN_FRONTEND=noninteractive apt-get install g++-aarch64-linux-gnu binutils-aarch64-linux-gnu -y --fix-missing && \
        #make dependencies
        make HOST=aarch64-linux-gnu -j2 && \
        echo -e "Linux ARM 64-bit (aarch64-linux-gnu) Dependencies Build complete."; \
#
    elif [ "$BUILD_TARGET" = "linuxarm32" ]; \
      then echo "Building dependencies for Linux ARM 32-bit (arm-linux-gnueabihf)..." && \
        DEBIAN_FRONTEND=noninteractive apt-get install g++-arm-linux-gnueabihf binutils-arm-linux-gnueabihf -y --fix-missing && \
        #make dependencies
        make HOST=arm-linux-gnueabihf -j2 && \
        echo -e "Linux (arm-linux-gnueabihf) Dependencies Build complete."; \
#
    elif [ "$BUILD_TARGET" = "mac" ]; \
      then echo "Building dependencies for mac cross-compile..." && \
        DEBIAN_FRONTEND=noninteractive apt-get install python-setuptools dpkg-dev libdvdnav-dev libcap-dev cmake libleveldb-dev clang clang++-3.8 libfuse-dev libbz2-dev librsvg2-bin libtiff-tools imagemagick expect libssl1.0-dev -y --fix-missing && \
        #GET MacOS SDK
        mkdir -p SDKs && \
        curl -LO "https://github.com/phracker/MacOSX-SDKs/releases/download/MacOSX10.11.sdk/MacOSX10.11.sdk.tar.xz" && \
        tar xvf MacOSX10.11.sdk.tar.xz -C ./SDKs/ && \
        make HOST="x86_64-apple-darwin11" DARWIN_SDK_PATH=$PWD/SDKs/MacOSX10.11.sdk/ -j2 || true && \
        echo "Mac Dependencies Build complete."; \
#
    else echo "Build target not recognized."; \
      exit 127; \
#
    fi
    
CMD /bin/bash -c "trap: TERM INT; sleep infinity & wait"