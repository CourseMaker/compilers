FROM judge0/buildpack-deps:buster-2019-11-23

ENV GCC_VERSIONS \
      7.4.0 \
      8.3.0 \
      9.2.0
RUN set -xe && \
    for VERSION in $GCC_VERSIONS; do \
      curl -fSsL "https://ftpmirror.gnu.org/gcc/gcc-$VERSION/gcc-$VERSION.tar.gz" -o /tmp/gcc-$VERSION.tar.gz && \
      mkdir /tmp/gcc-$VERSION && \
      tar -xf /tmp/gcc-$VERSION.tar.gz -C /tmp/gcc-$VERSION --strip-components=1 && \
      rm /tmp/gcc-$VERSION.tar.gz && \
      cd /tmp/gcc-$VERSION && \
      ./contrib/download_prerequisites && \
      { rm *.tar.* || true; } && \
      tmpdir="$(mktemp -d)" && \
      cd "$tmpdir"; \
      if [ $VERSION = "9.2.0" ]; then \
        ENABLE_FORTRAN=",fortran"; \
      else \
        ENABLE_FORTRAN=""; \
      fi; \
      /tmp/gcc-$VERSION/configure \
        --disable-multilib \
        --enable-languages=c,c++$ENABLE_FORTRAN \
        --prefix=/usr/local/gcc-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install-strip && \
      rm -rf /tmp/*; \
    done

ENV RUBY_VERSIONS \
      2.6.5
RUN set -xe && \
    for VERSION in $RUBY_VERSIONS; do \
      curl -fSsL "https://cache.ruby-lang.org/pub/ruby/${VERSION%.*}/ruby-$VERSION.tar.gz" -o /tmp/ruby-$VERSION.tar.gz && \
      mkdir /tmp/ruby-$VERSION && \
      tar -xf /tmp/ruby-$VERSION.tar.gz -C /tmp/ruby-$VERSION --strip-components=1 && \
      rm /tmp/ruby-$VERSION.tar.gz && \
      cd /tmp/ruby-$VERSION && \
      ./configure \
        --disable-install-doc \
        --prefix=/usr/local/ruby-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

ENV PYTHON_VERSIONS \
      3.8.0 \
      2.7.17
RUN set -xe && \
    for VERSION in $PYTHON_VERSIONS; do \
      curl -fSsL "https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.xz" -o /tmp/python-$VERSION.tar.xz && \
      mkdir /tmp/python-$VERSION && \
      tar -xf /tmp/python-$VERSION.tar.xz -C /tmp/python-$VERSION --strip-components=1 && \
      rm /tmp/python-$VERSION.tar.xz && \
      cd /tmp/python-$VERSION && \
      ./configure \
        --prefix=/usr/local/python-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

ENV OCTAVE_VERSIONS \
      5.1.0
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends gfortran libblas-dev liblapack-dev libpcre3-dev && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $OCTAVE_VERSIONS; do \
      curl -fSsL "https://ftp.gnu.org/gnu/octave/octave-$VERSION.tar.gz" -o /tmp/octave-$VERSION.tar.gz && \
      mkdir /tmp/octave-$VERSION && \
      tar -xf /tmp/octave-$VERSION.tar.gz -C /tmp/octave-$VERSION --strip-components=1 && \
      rm /tmp/octave-$VERSION.tar.gz && \
      cd /tmp/octave-$VERSION && \
      ./configure \
        --prefix=/usr/local/octave-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

RUN set -xe && \
    curl -fSsL "https://download.java.net/java/GA/jdk13.0.1/cec27d702aa74d5a8630c65ae61e4305/9/GPL/openjdk-13.0.1_linux-x64_bin.tar.gz" -o /tmp/openjdk13.tar.gz && \
    mkdir /usr/local/openjdk13 && \
    tar -xf /tmp/openjdk13.tar.gz -C /usr/local/openjdk13 --strip-components=1 && \
    rm /tmp/openjdk13.tar.gz && \
    ln -s /usr/local/openjdk13/bin/javac /usr/local/bin/javac && \
    ln -s /usr/local/openjdk13/bin/java /usr/local/bin/java && \
    ln -s /usr/local/openjdk13/bin/jar /usr/local/bin/jar

ENV BASH_VERSIONS \
      5.0
RUN set -xe && \
    for VERSION in $BASH_VERSIONS; do \
      curl -fSsL "https://ftpmirror.gnu.org/bash/bash-$VERSION.tar.gz" -o /tmp/bash-$VERSION.tar.gz && \
      mkdir /tmp/bash-$VERSION && \
      tar -xf /tmp/bash-$VERSION.tar.gz -C /tmp/bash-$VERSION --strip-components=1 && \
      rm /tmp/bash-$VERSION.tar.gz && \
      cd /tmp/bash-$VERSION && \
      ./configure \
        --prefix=/usr/local/bash-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

ENV FPC_VERSIONS \
      3.0.4
RUN set -xe && \
    for VERSION in $FPC_VERSIONS; do \
      curl -fSsL "ftp://ftp.freepascal.org/fpc/dist/$VERSION/x86_64-linux/fpc-$VERSION.x86_64-linux.tar" -o /tmp/fpc-$VERSION.tar && \
      mkdir /tmp/fpc-$VERSION && \
      tar -xf /tmp/fpc-$VERSION.tar -C /tmp/fpc-$VERSION --strip-components=1 && \
      rm /tmp/fpc-$VERSION.tar && \
      cd /tmp/fpc-$VERSION && \
      echo "/usr/local/fpc-$VERSION" | sh install.sh && \
      rm -rf /tmp/*; \
    done

ENV HASKELL_VERSIONS \
      8.8.1
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends libgmp-dev libtinfo5 && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $HASKELL_VERSIONS; do \
      curl -fSsL "https://downloads.haskell.org/~ghc/$VERSION/ghc-$VERSION-x86_64-deb8-linux.tar.xz" -o /tmp/ghc-$VERSION.tar.xz && \
      mkdir /tmp/ghc-$VERSION && \
      tar -xf /tmp/ghc-$VERSION.tar.xz -C /tmp/ghc-$VERSION --strip-components=1 && \
      rm /tmp/ghc-$VERSION.tar.xz && \
      cd /tmp/ghc-$VERSION && \
      ./configure \
        --prefix=/usr/local/ghc-$VERSION && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

ENV MONO_VERSIONS \
      6.6.0.161
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends cmake && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $MONO_VERSIONS; do \
      curl -fSsL "https://download.mono-project.com/sources/mono/mono-$VERSION.tar.xz" -o /tmp/mono-$VERSION.tar.xz && \
      mkdir /tmp/mono-$VERSION && \
      tar -xf /tmp/mono-$VERSION.tar.xz -C /tmp/mono-$VERSION --strip-components=1 && \
      rm /tmp/mono-$VERSION.tar.xz && \
      cd /tmp/mono-$VERSION && \
      ./configure \
        --prefix=/usr/local/mono-$VERSION && \
      make -j$(nproc) && \
      make -j$(proc) install && \
      rm -rf /tmp/*; \
    done

ENV NODE_VERSIONS \
      12.13.1
RUN set -xe && \
    for VERSION in $NODE_VERSIONS; do \
      curl -fSsL "https://nodejs.org/dist/v$VERSION/node-v$VERSION.tar.gz" -o /tmp/node-$VERSION.tar.gz && \
      mkdir /tmp/node-$VERSION && \
      tar -xf /tmp/node-$VERSION.tar.gz -C /tmp/node-$VERSION --strip-components=1 && \
      rm /tmp/node-$VERSION.tar.gz && \
      cd /tmp/node-$VERSION && \
      ./configure \
        --prefix=/usr/local/node-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

ENV CLOJURE_VERSIONS \
      1.10.1.492
RUN set -xe && \
    for VERSION in $CLOJURE_VERSIONS; do \
      curl -fSsL "https://download.clojure.org/install/linux-install-$VERSION.sh" -o /tmp/clojure-$VERSION.sh && \
      chmod +x /tmp/clojure-$VERSION.sh && \
      /tmp/clojure-$VERSION.sh --prefix /usr/local/clojure-$VERSION && \
      rm -rf /tmp/*; \
    done

ENV ERLANG_VERSIONS \
      22.2
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $ERLANG_VERSIONS; do \
      curl -fSsL "https://github.com/erlang/otp/archive/OTP-$VERSION.tar.gz" -o /tmp/erlang-$VERSION.tar.gz && \
      mkdir /tmp/erlang-$VERSION && \
      tar -xf /tmp/erlang-$VERSION.tar.gz -C /tmp/erlang-$VERSION --strip-components=1 && \
      rm /tmp/erlang-$VERSION.tar.gz && \
      cd /tmp/erlang-$VERSION && \
      ./otp_build autoconf && \
      ./configure \
        --prefix=/usr/local/erlang-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done; \
    ln -s /usr/local/erlang-22.2/bin/erl /usr/local/bin/erl

ENV ELIXIR_VERSIONS \
      1.9.4
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends unzip && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $ELIXIR_VERSIONS; do \
      curl -fSsL "https://github.com/elixir-lang/elixir/releases/download/v$VERSION/Precompiled.zip" -o /tmp/elixir-$VERSION.zip && \
      unzip -d /usr/local/elixir-$VERSION /tmp/elixir-$VERSION.zip && \
      rm -rf /tmp/*; \
    done

ENV RUST_VERSIONS \
      1.39.0
RUN set -xe && \
    for VERSION in $RUST_VERSIONS; do \
      curl -fSsL "https://static.rust-lang.org/dist/rust-$VERSION-x86_64-unknown-linux-gnu.tar.gz" -o /tmp/rust-$VERSION.tar.gz && \
      mkdir /tmp/rust-$VERSION && \
      tar -xf /tmp/rust-$VERSION.tar.gz -C /tmp/rust-$VERSION --strip-components=1 && \
      rm /tmp/rust-$VERSION.tar.gz && \
      cd /tmp/rust-$VERSION && \
      ./install.sh \
        --prefix=/usr/local/rust-$VERSION \
        --components=rustc,rust-std-x86_64-unknown-linux-gnu && \
      rm -rf /tmp/*; \
    done

ENV GO_VERSIONS \
      1.13.5
RUN set -xe && \
    for VERSION in $GO_VERSIONS; do \
      curl -fSsL "https://storage.googleapis.com/golang/go$VERSION.linux-amd64.tar.gz" -o /tmp/go-$VERSION.tar.gz && \
      mkdir /usr/local/go-$VERSION && \
      tar -xf /tmp/go-$VERSION.tar.gz -C /usr/local/go-$VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

ENV FBC_VERSIONS \
      1.07.1
RUN set -xe && \
    for VERSION in $FBC_VERSIONS; do \
      curl -fSsL "https://downloads.sourceforge.net/project/fbc/Binaries%20-%20Linux/FreeBASIC-$VERSION-linux-x86_64.tar.gz" -o /tmp/fbc-$VERSION.tar.gz && \
      mkdir /usr/local/fbc-$VERSION && \
      tar -xf /tmp/fbc-$VERSION.tar.gz -C /usr/local/fbc-$VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

ENV OCAML_VERSIONS \
      4.09.0
RUN set -xe && \
    for VERSION in $OCAML_VERSIONS; do \
      curl -fSsL "https://github.com/ocaml/ocaml/archive/$VERSION.tar.gz" -o /tmp/ocaml-$VERSION.tar.gz && \
      mkdir /tmp/ocaml-$VERSION && \
      tar -xf /tmp/ocaml-$VERSION.tar.gz -C /tmp/ocaml-$VERSION --strip-components=1 && \
      rm /tmp/ocaml-$VERSION.tar.gz && \
      cd /tmp/ocaml-$VERSION && \
      ./configure \
        -prefix /usr/local/ocaml-$VERSION \
        --disable-ocamldoc --disable-debugger && \
      make -j$(nproc) world.opt && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

ENV PHP_VERSIONS \
      7.4.0
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends bison re2c && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $PHP_VERSIONS; do \
      curl -fSsL "https://codeload.github.com/php/php-src/tar.gz/php-$VERSION" -o /tmp/php-$VERSION.tar.gz && \
      mkdir /tmp/php-$VERSION && \
      tar -xf /tmp/php-$VERSION.tar.gz -C /tmp/php-$VERSION --strip-components=1 && \
      rm /tmp/php-$VERSION.tar.gz && \
      cd /tmp/php-$VERSION && \
      ./buildconf --force && \
      ./configure \
        --prefix=/usr/local/php-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

ENV KOTLIN_VERSIONS \
      1.3.61
RUN set -xe && \
    for VERSION in $KOTLIN_VERSIONS; do \
      curl -fSsL "https://github.com/JetBrains/kotlin/releases/download/v$VERSION/kotlin-native-linux-$VERSION.tar.gz" -o /tmp/kotlin-$VERSION.tar.gz && \
      mkdir /usr/local/kotlin-$VERSION && \
      tar -xf /tmp/kotlin-$VERSION.tar.gz -C /usr/local/kotlin-$VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

ENV D_VERSIONS \
      2.089.0
RUN set -xe && \
    for VERSION in $D_VERSIONS; do \
      curl -fSsL "https://downloads.dlang.org/releases/2.x/$VERSION/dmd.$VERSION.linux.tar.xz" -o /tmp/d-$VERSION.tar.gz && \
      mkdir /usr/local/d-$VERSION && \
      tar -xf /tmp/d-$VERSION.tar.gz -C /usr/local/d-$VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

ENV LUA_VERSIONS \
      5.3.5
RUN set -xe && \
    for VERSION in $LUA_VERSIONS; do \
      curl -fSsL "https://downloads.sourceforge.net/project/luabinaries/$VERSION/Tools%20Executables/lua-${VERSION}_Linux44_64_bin.tar.gz" -o /tmp/lua-$VERSION.tar.gz && \
      mkdir /usr/local/lua-$VERSION && \
      tar -xf /tmp/lua-$VERSION.tar.gz -C /usr/local/lua-$VERSION && \
      rm -rf /tmp/*; \
    done

ENV TYPESCRIPT_VERSIONS \
      3.7.3
RUN set -xe && \
    curl -fSsL "https://deb.nodesource.com/setup_12.x" | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $TYPESCRIPT_VERSIONS; do \
      npm install -g typescript@$VERSION; \
    done

ENV NASM_VERSIONS \
      2.14.02
RUN set -xe && \
    for VERSION in $NASM_VERSIONS; do \
      curl -fSsL "https://www.nasm.us/pub/nasm/releasebuilds/$VERSION/nasm-$VERSION.tar.gz" -o /tmp/nasm-$VERSION.tar.gz && \
      mkdir /tmp/nasm-$VERSIONS && \
      tar -xf /tmp/nasm-$VERSION.tar.gz -C /tmp/nasm-$VERSION --strip-components=1 && \
      rm /tmp/nasm-$VERSION.tar.gz && \
      cd /tmp/nasm-$VERSION && \
      ./configure \
        --prefix=/usr/local/nasm-$VERSION && \
      make -j$(nproc) nasm ndisasm && \
      make -j$(nproc) strip && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

ENV GPROLOG_VERSIONS \
      1.4.5
RUN set -xe && \
    for VERSION in $GPROLOG_VERSIONS; do \
      curl -fSsl "https://gprolog.org/gprolog-$VERSION.tar.gz" -o /tmp/gprolog-$VERSION.tar.gz && \
      mkdir /tmp/gprolog-$VERSIONS && \
      tar -xf /tmp/gprolog-$VERSION.tar.gz -C /tmp/gprolog-$VERSION --strip-components=1 && \
      rm /tmp/gprolog-$VERSION.tar.gz && \
      cd /tmp/gprolog-$VERSION/src && \
      ./configure \
        --prefix=/usr/local/gprolog-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install-strip && \
      rm -rf /tmp/*; \
    done

ENV R_VERSIONS \
      3.6.1
RUN set -xe && \
    for VERSION in $R_VERSIONS; do \
      curl -fSsl "https://cloud.r-project.org/src/base/R-3/R-$VERSION.tar.gz" -o /tmp/r-$VERSION.tar.gz && \
      mkdir /tmp/r-$VERSIONS && \
      tar -xf /tmp/r-$VERSION.tar.gz -C /tmp/r-$VERSION --strip-components=1 && \
      rm /tmp/r-$VERSION.tar.gz && \
      cd /tmp/r-$VERSION && \
      ./configure \
        --prefix=/usr/local/r-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

ENV JULIA_VERSIONS \
      1.3.0
RUN set -xe && \
    for VERSION in $JULIA_VERSIONS; do \
      curl -fSsl "https://julialang-s3.julialang.org/bin/linux/x64/${VERSION%.*}/julia-$VERSION-linux-x86_64.tar.gz" -o /tmp/julia-$VERSION.tar.gz && \
      mkdir /usr/local/julia-$VERSION && \
      tar -xf /tmp/julia-$VERSION.tar.gz -C /usr/local/julia-$VERSION && \
      rm -rf /tmp/*; \
    done

RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends locales && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends git libcap-dev && \
    rm -rf /var/lib/apt/lists/* && \
    git clone https://github.com/ioi/isolate.git /tmp/isolate && \
    cd /tmp/isolate && \
    git checkout 18554e83793508acd1032d0cf4229a332c43085e && \
    echo "num_boxes = 2147483647" >> default.cf && \
    make -j$(nproc) install && \
    rm -rf /tmp/*
ENV BOX_ROOT /var/local/lib/isolate

LABEL maintainer="Herman Zvonimir Došilović, hermanz.dosilovic@gmail.com"
LABEL version="1.0.0"