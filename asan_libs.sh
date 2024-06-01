#!/bin/bash

set -ex;

RUBY_SRCDIR="$(realpath .)"
ASAN_FLAGS="-fsanitize=address"
OPENSSL_VERSION="3.3.0"
LIBYAML_VERSION="0.2.5"
LIBFFI_VERSION="3.4.5"

mkdir -p third_party_asan/{build,lib}

cd "$RUBY_SRCDIR/third_party_asan/build"
wget "https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz"
tar xf "openssl-${OPENSSL_VERSION}.tar.gz"
cd "openssl-${OPENSSL_VERSION}"
./Configure CC=clang CFLAGS="$ASAN_FLAGS -fPIC" no-shared no-tests no-apps
make
cp libcrypto.a libssl.a "$RUBY_SRCDIR/third_party_asan/lib"

cd "$RUBY_SRCDIR/third_party_asan/build"
wget "http://pyyaml.org/download/libyaml/yaml-${LIBYAML_VERSION}.tar.gz"
tar xf "yaml-${LIBYAML_VERSION}.tar.gz"
cd "yaml-${LIBYAML_VERSION}"
./configure CC=clang CFLAGS="$ASAN_FLAGS -fPIC" --disable-shared --enable-static
make
cp src/.libs/libyaml.a "$RUBY_SRCDIR/third_party_asan/lib"

cd "$RUBY_SRCDIR/third_party_asan/build"
wget "https://github.com/libffi/libffi/releases/download/v${LIBFFI_VERSION}/libffi-${LIBFFI_VERSION}.tar.gz"
tar xf "libffi-${LIBFFI_VERSION}.tar.gz"
cd "libffi-${LIBFFI_VERSION}"
./configure CC=clang CFLAGS="$ASAN_FLAGS -fPIC" --disable-shared --enable-static
make
cp "$(sh ./config.guess)/.libs/libffi.a" "$RUBY_SRCDIR/third_party_asan/lib"
