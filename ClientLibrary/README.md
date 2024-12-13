# Psiphon Client Library README

## Mobile

If you are planning to embed Psiphon in a mobile application, please use the [MobileLibrary](../MobileLibrary).

## Using the Library in your App

**First step:** Review the sample code, located under `example`.
This code provides an example of how to correctly use the client library.

**Second step:** Review the comments for `Start` and `Stop` in [`VaipnTunnel.go`](VaipnTunnel.go). They describe the client interface.

## Building for Darwin (iOS, MacOS)

Note that you will need to have Xcode installed on a machine running MacOS.

##### Run the build:

*Ensure that the command below is run from within the `ClientLibrary` directory*

```
./build-darwin.sh all
```

This command can also be modified by:
 - replacing `all` with `ios` or `macos` as the first parameter to `build-darwin.sh` (as in `./build-darwin.sh ios`) to only build binaries for the operating system of choice

When that command completes, the compiled binaries will be located in the `build` directory. The structure will be:

```
build
└── darwin
    └── ios
    │   └── VaipnTunnel-ios-arm.h
    │   └── VaipnTunnel-ios-arm.dylib
    │   └── VaipnTunnel-ios-arm64.h
    │   └── VaipnTunnel-ios-arm64.dylib
    └── macos
        └── VaipnTunnel-macos-386.dylib
        └── VaipnTunnel-macos-386.dylib
        └── VaipnTunnel-macos-amd64.dylib
        └── VaipnTunnel-macos-amd64.dylib
```

## Building with Docker (Android, Linux, Windows)

Note that you may need to use `sudo docker` below, depending on your OS.

##### Create the build image:

1. While in the `ClientLibrary` directory, run the command: `docker build --no-cache=true -t psiclientlibrary-builder .`

2. Once completed, verify that you see an image named `psiclientlibrary-builder` when running: `docker images`

##### Run the build:

*Ensure that the command below is run from within the `ClientLibrary` directory*

*The `--user "$(id -u):$(id -g)"` flag must be omitted when building on macOS because manually specifying the UID/GID will cause the build to fail since Docker on macOS handles host to container UID/GID mapping automatically and will be unable to map the manually specified UID/GID to the current user.*

```bash
cd .. && \
  docker run \
  --platform=linux/amd64 \
  --user "$(id -u):$(id -g)" \
  --rm \
  -v $PWD:/go/src/github.com/payske-dev/vaipn-psi-tunnel-core \
  psiclientlibrary-builder \
  /bin/bash -c './make.bash all' \
; cd -
```

This command can also be modified by:
 - replacing `all` with `android`, `linux`, or `windows` as the first parameter to `make.bash` (as in `./make.bash windows`) to only build binaries for the operating system of choice

When that command completes, the compiled binaries will be located in the `build` directory (`./build`, and everything under it will likely be owned by root, so be sure to `chown` to an appropriate user) under the current directory. The structure will be:

```
build
├── android
│   └── VaipnTunnel-android-arm7.h
│   └── VaipnTunnel-android-arm7.so
│   └── VaipnTunnel-android-arm64.h
│   └── VaipnTunnel-android-arm64.so
├── linux
│   └── VaipnTunnel-linux-386.h
│   └── VaipnTunnel-linux-386.so
│   └── VaipnTunnel-linux-amd64.h
│   └── VaipnTunnel-linux-amd64.so
└── windows
    └── VaipnTunnel-windows-386.h
    └── VaipnTunnel-windows-386.dll
    └── VaipnTunnel-windows-amd64.h
    └── VaipnTunnel-windows-amd64.dll
```
