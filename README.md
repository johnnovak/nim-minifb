# nim-MiniFB

Nim wrapper/port of the cute [MiniFB](https://github.com/emoon/minifb) (Mini
FrameBuffer) library originally written by [Daniel
Collin](https://github.com/emoon).

The usage in a nutshell:

  * `mfbOpen` opens a non-resizable window of the specified size.

  * `mfbUpdate` copies a buffer of 32-bit pixels (in XRGB
    format) into the window area and displays it. It returns `true` if ESC was
    pressed, `false` otherwise. The buffer must be at least `WIDTH * HEIGHT
    * 4` bytes in size and must be managed by the application. 

  * `mfbClose` to closes the window.

See the original documentation
[here](https://github.com/emoon/minifb/blob/master/README.md) and the `test`
directory for examples.

Works on Windows, Mac OS X and X11 (FreeBSD, Linux, *nix). Most likely fails
on platforms where it cannot allocate a 32-bit pixel buffer and probably only
supports little-endian architectures (can't test either, sorry).

