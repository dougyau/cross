#!/usr/bin/env bash

set -eux

cargo install --path . --force

if [[ "${TARGET}" = "x86_64-unknown-linux-gnu" ]]; then
    # for this particular target, `cross` command below will try to reuse the artifacts (e.g. build
    # script binaries) generated by the previous `cargo` command. that will fail to run because the
    # cross environment has glibc 2.17 and the CI env (ubuntu 20.04) produces binaries that depend
    # on glibc 2.18+
    # to avoid the issue discard the build script artifacts produced by the previous command
    cargo clean
fi

cross build --target "${TARGET}" --release

rm -rf "${BUILD_BINARIESDIRECTORY}"
mkdir "${BUILD_BINARIESDIRECTORY}"

if [[ -f "target/${TARGET}/release/cross.exe" ]]; then
    mv "target/${TARGET}/release/cross.exe" "${BUILD_BINARIESDIRECTORY}/"
else
    mv "target/${TARGET}/release/cross" "${BUILD_BINARIESDIRECTORY}/"
fi
