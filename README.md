# XlibNoSHM builds for Ubuntu

XlibNoSHM is a solution for the "MIT-SHM container problem" (see below).

This repository provides 32 and 64 bit Ubuntu builds for XlibNoSHM and the scripts to create them yourself.


## The problem

Using X11 with docker can cause errors like this

```
X Error of failed request:  BadValue (integer parameter out of range for operation)
  Major opcode of failed request:  130 (MIT-SHM)
  Minor opcode of failed request:  3 (X_ShmPutImage)
  Value in failed request:  0xf00
  Serial number of failed request:  15423
  Current serial number in output stream:  15454
```

This error is caused by using the MIT-SHM extension inside a container. The MIT Shared Memory Extension or MIT-SHM or XShm is an X Window System extension for exchange of image data between client and server using shared memory. With MIT-SHM the actual image data is stored in a shared memory segment, and thus need not be transferred across the socket to the X server. For large images, use of this facility can improve performance.

However the MIT-SHM mechanism only works when both client and server are on the same computer and have access to the shared memory. With docker they are technically still running on the same computer but isolated through the container mechanism. This will cause the BadValue error as soon as shared memory is requested.


## The solution

There are basically 3 solutions

1. Use a second X server with MIT-SHM disabled

This is described on [stackoverflow](https://stackoverflow.com/questions/16296753/can-you-run-gui-applications-in-a-linux-docker-container/39681017#39681017). Safe, but a bit complex for my taste.

2. Run docker with `--ipc=host`

This makes the shared memory on the host available to the docker and removes the isolation between client and server. This is the easiest solution, but makes the docker (a bit) less secure. Depending on your use-case this may be fine for you.

3. Make the application think MIT-SHM is not available on your server

This can be be done by preloading a library that will handle requests for MIT-SHM by indicating that the extension is not avalable. This is implemented in XlibNoSHM.c (not by me: [credits](https://github.com/mobdata/mobnode/blob/master/XlibNoSHM.c)). This solution is simple and secure.

The compiled library depends heavily on the version of other libraries used in the image. You can either build it inside your target docker or use the pre-built versions from this repository.


## Building XlibNoSHM for Ubuntu

Use the `buid.sh` script if you want to build the libraries yourself.

For **18.04** / **Bionic**:

```
./build.sh bionic
```

For **20.04** / **Focal**:

```
./build.sh focal
```

For **22.04** / **Jammy**:

```
./build.sh jammy
```
